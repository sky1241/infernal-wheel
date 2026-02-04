param(
  [int]$GoalHours = 500
)

$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "InfernalIO.psm1") -Force

# ---- Mutex names (cross-process)
$M_STATE    = "Local\InfernalWheel_State"
$M_SETTINGS = "Local\InfernalWheel_Settings"
$M_CMDS     = "Local\InfernalWheel_Commands"
$M_ENGINE   = "Local\InfernalWheel_Engine"

# ---- Paths
$DataDir       = Join-Path $env:USERPROFILE ".infernal_wheel"
$StatePath     = Join-Path $DataDir "state.json"
$StateBakPath  = Join-Path $DataDir "state.json.bak"
$HeartbeatPath = Join-Path $DataDir "heartbeat.txt"
$CmdFile       = Join-Path $DataDir "commands.in"
$SettingsPath  = Join-Path $DataDir "settings.json"
$SettingsBak   = Join-Path $DataDir "settings.json.bak"
$LogPath       = Join-Path $DataDir "log.csv"
$PidsPath      = Join-Path $DataDir "timer.pid"
$EngineLogPath = Join-Path $DataDir "engine_error.log"
$CmdLogPath    = Join-Path $DataDir "commands.log"

$engineMutex = [System.Threading.Mutex]::new($false, $M_ENGINE)
$engineLock = $false
try { $engineLock = $engineMutex.WaitOne(0) } catch [System.Threading.AbandonedMutexException] { $engineLock = $true }
if (-not $engineLock) {
  try {
    Write-ErrorLog -Path $EngineLogPath -Context "Startup" -Exception ([System.Exception]::new("InfernalWheel already running"))
  } catch {}
  return
}

New-Item -ItemType Directory -Path $DataDir -Force | Out-Null
if (-not (Test-Path $CmdFile)) { Write-TextAtomic -Path $CmdFile -Text "" }
if (-not (Test-Path $CmdLogPath)) { Write-TextAtomic -Path $CmdLogPath -Text "" }

if (-not (Test-Path $LogPath)) {
  Write-TextAtomic -Path $LogPath -Text "Start,End,Name,CountsAsWork,CountsAsSleep,InfernalDay"
}


. (Join-Path $PSScriptRoot "engine" "Engine.Functions.ps1")


# ---- state + segment locals
Initialize-DefaultSettings | Out-Null
$s = Initialize-State

# persist PID (best-effort)
try { Write-TextAtomic -Path $PidsPath -Text "$PID" } catch {}

$segStart = [datetime]::Parse($s.Current.StartedAt)
$segName  = [string]$s.Current.Name
$segWork  = [bool]$s.Current.IsWork
$segSleep = [bool]$s.Current.IsSleep
$sleepFixApplied = $false

# ---- LOOP
$last = Get-Date
while ($true) {
  try {
    $now = Get-Date

    # heartbeat (best-effort, atomic-ish)
    try {
      Write-TextAtomic -Path $HeartbeatPath -Text (NowStr) -MutexName "Local\InfernalWheel_Heartbeat"
    } catch {
      Write-EngineError "Heartbeat" $_.Exception
    }

    # detect sleep gap (count as sleep to keep totals consistent)
    $resumeGap = $false
    $gapSec = 0
    $dt = 0
    try {
      $lt = $null
      if ($s.Engine.LastTick) { $lt = [datetime]::Parse($s.Engine.LastTick) }
      if ($lt) {
        $sinceLastTick = [int][Math]::Max(0, ($now - $lt).TotalSeconds)
        if ($sinceLastTick -gt 20) {
          $resumeGap = $true
          $gapSec = $sinceLastTick
        }
      }
    } catch {}
    if (-not $resumeGap) {
      $dt = [int]($now - $last).TotalSeconds
      if ($dt -gt 20) {
        $resumeGap = $true
        $gapSec = 0
        $dt = 0
      }
    } else {
      $dt = 0
    }
    $last = $now
    $s.Engine.ResumeDetected = $resumeGap
    if ($gapSec -gt 0) {
      $sleepDisplayStart = $null
      if ($s.Current.Name -eq "sleep") {
        $sleepDisplayStart = $s.Current.DisplayStartedAt
        if (-not $sleepDisplayStart) { $sleepDisplayStart = $s.Current.StartedAt }
      }
      $lastTick = $null
      try {
        if ($s.Engine.LastTick) { $lastTick = [datetime]::Parse($s.Engine.LastTick) }
      } catch {}
      if ($lastTick -and $lastTick -gt $script:segStart) {
        try {
          Add-LogRow $script:segStart $lastTick $script:segName $script:segWork $script:segSleep
        } catch {}
      }
      $s.TotalSleepSeconds += $gapSec
      $s.DaySleepSeconds += $gapSec
      try {
        if ($lastTick) { Add-LogRow $lastTick $now "SLEEP_OFFLINE" $false $true }
      } catch {}
      # Switch to sleep without logging work across the gap.
      if ($s.Current.Name -ne "sleep") {
        $s.Engine.AwaitOk = $false
        $s.Current.Name = "sleep"
        $s.Current.StartedAt = (NowStr)
        $s.Current.DisplayStartedAt = $null
        $s.Current.EndsAt = $null
        $s.Current.IsWork = $false
        $s.Current.IsSleep = $true
        $s.Current.RequireOk = $false
        $s.Current.Paused = $false
        $s.Current.PausedRemainSec = $null
        $s.Current.OvertimeStartedAt = $null
        $script:segStart = $now
        $script:segName = "sleep"
        $script:segWork = $false
        $script:segSleep = $true
      } else {
        $s.Engine.AwaitOk = $false
        $s.Current.StartedAt = (NowStr)
        $s.Current.DisplayStartedAt = $sleepDisplayStart
        $s.Current.EndsAt = $null
        $s.Current.IsWork = $false
        $s.Current.IsSleep = $true
        $s.Current.RequireOk = $false
        $s.Current.Paused = $false
        $s.Current.PausedRemainSec = $null
        $s.Current.OvertimeStartedAt = $null
        $script:segStart = $now
        $script:segName = "sleep"
        $script:segWork = $false
        $script:segSleep = $true
      }
    }

    # If engine restarted after a sleep gap, keep current segment from showing stale work.
    if (-not $sleepFixApplied -and $s.Current.Name -eq "work") {
      try {
        $startedAt = [datetime]::Parse($s.Current.StartedAt)
        $ageHours = ($now - $startedAt).TotalHours
        if ($ageHours -ge 3) {
          $lastSleepEnd = Get-LastSleepOfflineEnd
          if ($lastSleepEnd -and $lastSleepEnd -gt $startedAt -and ($now - $lastSleepEnd).TotalHours -le 24) {
            $s.Engine.AwaitOk = $false
            $s.Current.Name = "sleep"
            $s.Current.StartedAt = (NowStr)
            $s.Current.DisplayStartedAt = $null
            $s.Current.EndsAt = $null
            $s.Current.IsWork = $false
            $s.Current.IsSleep = $true
            $s.Current.RequireOk = $false
            $s.Current.Paused = $false
            $s.Current.PausedRemainSec = $null
            $s.Current.OvertimeStartedAt = $null
            $script:segStart = $now
            $script:segName = "sleep"
            $script:segWork = $false
            $script:segSleep = $true
          }
        }
      } catch {}
      $sleepFixApplied = $true
    }

    # day rollover
    $dk = Get-InfernalDayKey $now
    if ($s.DayKey -ne $dk) {
      $s.DayKey = $dk
      $s.DayWorkSeconds = 0
      $s.DaySleepSeconds = 0
      $s.DayClopeCount = 0
      $s.DayClopeSeconds = 0
      $s.DayBreakSeconds = 0
    }

    # settings + commands
    $settings = $null
    try { $settings = Get-Settings } catch { Write-EngineError "Get-Settings" $_.Exception }
    if (-not $settings) { $settings = @{ penalty=@{ enableOvertimeCounter=$true }; actions=@() } }
    $manualBreakOnly = Get-ManualBreakOnly $settings

    $cmds = @()
    try { $cmds = Read-Commands } catch { Write-EngineError "Read-Commands" $_.Exception }
    foreach ($line in $cmds) { Invoke-CommandLine $line $settings }

    # account time
    if ($dt -gt 0) {
      if ($segWork)  { $s.TotalWorkSeconds += $dt; $s.DayWorkSeconds += $dt }
      if ($segSleep) { $s.TotalSleepSeconds += $dt; $s.DaySleepSeconds += $dt }
      if ($segName -eq "clope") { $s.TotalClopeSeconds += $dt; $s.DayClopeSeconds += $dt }
      if ((-not $segWork) -and (-not $segSleep) -and ($segName -ne "WAIT_OK")) {
        $s.TotalBreakSeconds += $dt
        $s.DayBreakSeconds += $dt
      }
      if (($s.Current.Name -eq "WAIT_OK") -and $s.Current.OvertimeStartedAt) {
        $s.TotalOverrunSeconds += $dt
      }
    }

    # timed segment ended?
    if ($s.Current.EndsAt) {
      try {
        $endAt = [datetime]::Parse($s.Current.EndsAt)
        if ($now -ge $endAt) {
          $isBreak = ($s.Current.Name -ne "work") -and ($s.Current.Name -ne "sleep") -and ($s.Current.Name -ne "WAIT_OK") -and ($s.Current.Name -ne "idle")
          if ($isBreak -and $manualBreakOnly) {
            $s.Current.EndsAt = $null
            $s.Current.RequireOk = $false
          } else {
            if ([bool]$s.Current.RequireOk) {
              $s.Engine.AwaitOk = $true
              Switch-Segment "WAIT_OK" 0 $false $false $false
              Start-OvertimeIfNeeded
            } else {
              $s.Engine.AwaitOk = $false
              Switch-Segment "work" 0 $true $false $false
            }
          }
        }
      } catch {
        Write-EngineError "TimedSegment" $_.Exception
      }
    }

    # recompute locals from state (keeps HUD consistent)
    $segName  = [string]$s.Current.Name
    $segWork  = [bool]$s.Current.IsWork
    $segSleep = [bool]$s.Current.IsSleep

    # write state (safe)
    $s.Engine.LastTick = (NowStr)
    try { Write-State $s } catch { Write-EngineError "Write-State" $_.Exception }

    # HUD (minutes)
    $goal = [int]($s.GoalWorkSeconds)
    $remSec = [int][Math]::Max(0, $goal - [int]$s.TotalWorkSeconds)
    $line = "REM {0}m | SEG {1} | dayWork {2}m | daySleep {3}m | overrun {4}m   " -f `
      (FmtMin $remSec), ($segName.ToUpperInvariant()), (FmtMin $s.DayWorkSeconds), (FmtMin $s.DaySleepSeconds), (FmtMin $s.TotalOverrunSeconds)

    Write-Host -NoNewline "`r$line"
  } catch {
    Write-EngineError "Loop" $_.Exception
  }

  Start-Sleep -Milliseconds 1000
}
