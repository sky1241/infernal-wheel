function NowStr() { (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }

function Write-EngineError([string]$Context, [System.Exception]$Exception) {
  Write-ErrorLog -Path $EngineLogPath -Context $Context -Exception $Exception
}

function Get-InfernalDayKey([datetime]$dt) {
  $dayStart = Get-Date -Year $dt.Year -Month $dt.Month -Day $dt.Day -Hour 4 -Minute 0 -Second 0
  if ($dt -lt $dayStart) { return $dt.AddDays(-1).ToString("yyyy-MM-dd") }
  return $dt.ToString("yyyy-MM-dd")
}

function Initialize-DefaultSettings() {
  Invoke-WithMutexRetry -Name $M_SETTINGS -TimeoutMs 1200 -Retries 10 -Script {
    $s = Read-JsonSafe -Path $SettingsPath -BackupPath $SettingsBak
    $corrupt = $false
    if ($null -eq $s -and (Test-Path $SettingsPath)) { $corrupt = $true }
    if ($corrupt) {
      $stamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
      try { Move-Item -Force $SettingsPath (Join-Path $DataDir "settings.corrupt.$stamp.json") } catch {}
    }
    if ($null -eq $s) {
      $s = @{
        manualBreakOnly = $true
        penalty = @{ enableOvertimeCounter = $true }
        actions = @(
          @{ key="work";   label="Work";   mode="work";  minutes=0;  requireOk=$false },
          @{ key="dodo";   label="Dodo";   mode="sleep"; minutes=0;  requireOk=$false },

          @{ key="clope";  label="Clope";  mode="break"; minutes=10; requireOk=$true },
          @{ key="manger"; label="Manger"; mode="break"; minutes=30; requireOk=$true },
          @{ key="menage"; label="M`u{00E9}nage"; mode="break"; minutes=20; requireOk=$true },
          @{ key="chier";  label="Chier";  mode="break"; minutes=10; requireOk=$true },
          @{ key="douche"; label="Douche"; mode="break"; minutes=10; requireOk=$true },
          @{ key="marche"; label="Marche"; mode="break"; minutes=15; requireOk=$true },
          @{ key="reveille"; label="R`u{00E9}veille"; mode="break"; minutes=10; requireOk=$true },
          @{ key="meditation"; label="M`u{00E9}ditation"; mode="break"; minutes=15; requireOk=$true },
          @{ key="glandouille"; label="Glandouille"; mode="break"; minutes=10; requireOk=$true },
          @{ key="sport";  label="Sport";  mode="break"; minutes=45; requireOk=$true },
          @{ key="push";   label="Push Git"; mode="break"; minutes=25; requireOk=$true },
          @{ key="rego";   label="Rego";   mode="break"; minutes=5;  requireOk=$true }
        )
      }
      Write-JsonAtomic -Path $SettingsPath -Obj $s -BackupPath $SettingsBak -MutexName $M_SETTINGS
    }
  }
}

function Get-Settings() {
  return (Invoke-WithMutexRetry -Name $M_SETTINGS -TimeoutMs 1200 -Retries 10 -Script {
    $s = Read-JsonSafe -Path $SettingsPath -BackupPath $SettingsBak
    if ($null -eq $s) { $s = @{ penalty=@{ enableOvertimeCounter=$true }; actions=@() } }
    return $s
  })
}

function Get-ActionMap($settings) {
  $map = @{}
  foreach ($a in ($settings.actions ?? @())) {
    $k = [string]($a.key ?? "")
    if (-not $k.Trim()) { continue }
    $map[$k.ToLowerInvariant()] = $a
  }
  return $map
}

function Get-ManualBreakOnly($settings) {
  try {
    if ($null -eq $settings) { return $true }
    $v = $settings.manualBreakOnly
    if ($null -eq $v) { return $true }
    return [bool]$v
  } catch {
    return $true
  }
}

function Read-State() {
  try {
    return (Invoke-WithMutexRetry -Name $M_STATE -TimeoutMs 1500 -Retries 12 -Script {
      return (Read-JsonSafe -Path $StatePath -BackupPath $StateBakPath)
    })
  } catch {
    Write-EngineError "Read-State" $_.Exception
    return $null
  }
}

function Write-State($s) {
  try {
    Invoke-WithMutexRetry -Name $M_STATE -TimeoutMs 1500 -Retries 12 -Script {
      Write-JsonAtomic -Path $StatePath -Obj $s -BackupPath $StateBakPath -MutexName $M_STATE
    } | Out-Null
  } catch {
    Write-EngineError "Write-State" $_.Exception
  }
}

function Initialize-State() {
  $s = Read-State
  if ($null -eq $s) {
    $now = Get-Date
    $s = [pscustomobject]@{
      GoalWorkSeconds  = [int]($GoalHours * 3600)
      TotalWorkSeconds = 0
      TotalSleepSeconds = 0
      TotalOverrunSeconds = 0

      DayKey          = (Get-InfernalDayKey $now)
      DayWorkSeconds  = 0
      DaySleepSeconds = 0
      DayClopeCount   = 0
      DayClopeSeconds = 0
      DayBreakSeconds = 0

      Current = [pscustomobject]@{
        Name = "idle"
        StartedAt = (NowStr)
        DisplayStartedAt = $null
        EndsAt = $null
        IsWork = $false
        IsSleep = $false
        RequireOk = $false
        Paused = $false
        PausedRemainSec = $null
        OvertimeStartedAt = $null
      }

      Engine = [pscustomobject]@{
        Started = $false
        AwaitOk = $false
        LastTick = (NowStr)
        ResumeDetected = $false
      }

      TotalClopeCount = 0
      TotalClopeSeconds = 0
      TotalBreakSeconds = 0
    }
    Write-State $s
  }

  # repair minimal fields if corrupted/partial
  $changed = $false
  if (-not $s.GoalWorkSeconds) { $s | Add-Member -NotePropertyName GoalWorkSeconds -NotePropertyValue ([int]($GoalHours*3600)) -Force; $changed=$true }
  if ($null -eq $s.TotalWorkSeconds) { $s | Add-Member -NotePropertyName TotalWorkSeconds -NotePropertyValue 0 -Force; $changed=$true }
  if ($null -eq $s.TotalOverrunSeconds) { $s | Add-Member -NotePropertyName TotalOverrunSeconds -NotePropertyValue 0 -Force; $changed=$true }
  if ($null -eq $s.TotalSleepSeconds) { $s | Add-Member -NotePropertyName TotalSleepSeconds -NotePropertyValue 0 -Force; $changed=$true }
  if ($null -eq $s.TotalClopeCount) { $s | Add-Member -NotePropertyName TotalClopeCount -NotePropertyValue 0 -Force; $changed=$true }
  if ($null -eq $s.DayClopeCount) { $s | Add-Member -NotePropertyName DayClopeCount -NotePropertyValue 0 -Force; $changed=$true }
  if ($null -eq $s.TotalClopeSeconds) { $s | Add-Member -NotePropertyName TotalClopeSeconds -NotePropertyValue 0 -Force; $changed=$true }
  if ($null -eq $s.DayClopeSeconds) { $s | Add-Member -NotePropertyName DayClopeSeconds -NotePropertyValue 0 -Force; $changed=$true }
  if ($null -eq $s.TotalBreakSeconds) { $s | Add-Member -NotePropertyName TotalBreakSeconds -NotePropertyValue 0 -Force; $changed=$true }
  if ($null -eq $s.DayBreakSeconds) { $s | Add-Member -NotePropertyName DayBreakSeconds -NotePropertyValue 0 -Force; $changed=$true }
  if ($null -eq $s.Current) {
    $s | Add-Member -NotePropertyName Current -NotePropertyValue ([pscustomobject]@{
      Name="idle"; StartedAt=(NowStr); DisplayStartedAt=$null; EndsAt=$null; IsWork=$false; IsSleep=$false; RequireOk=$false;
      Paused=$false; PausedRemainSec=$null; OvertimeStartedAt=$null
    }) -Force
    $changed=$true
  } else {
    if ([string]::IsNullOrWhiteSpace([string]$s.Current.StartedAt)) { $s.Current.StartedAt = (NowStr); $changed=$true }
    if ($null -eq $s.Current.DisplayStartedAt) { $s.Current | Add-Member -NotePropertyName DisplayStartedAt -NotePropertyValue $null -Force; $changed=$true }
    if (($s.Current.EndsAt -is [string]) -and [string]::IsNullOrWhiteSpace($s.Current.EndsAt)) { $s.Current.EndsAt = $null; $changed=$true }
    if ($null -eq $s.Current.Paused) { $s.Current | Add-Member -NotePropertyName Paused -NotePropertyValue $false -Force; $changed=$true }
    if ($null -eq $s.Current.PausedRemainSec) { $s.Current | Add-Member -NotePropertyName PausedRemainSec -NotePropertyValue $null -Force; $changed=$true }
    if ($null -eq $s.Current.OvertimeStartedAt) { $s.Current | Add-Member -NotePropertyName OvertimeStartedAt -NotePropertyValue $null -Force; $changed=$true }
  }
  if ($null -eq $s.Engine) {
    $s | Add-Member -NotePropertyName Engine -NotePropertyValue ([pscustomobject]@{ Started=$false; AwaitOk=$false; LastTick=(NowStr); ResumeDetected=$false }) -Force
    $changed=$true
  } else {
    if ([string]::IsNullOrWhiteSpace([string]$s.Engine.LastTick)) { $s.Engine.LastTick = (NowStr); $changed=$true }
    if ($null -eq $s.Engine.Started) { $s.Engine | Add-Member -NotePropertyName Started -NotePropertyValue $false -Force; $changed=$true }
    if ($null -eq $s.Engine.AwaitOk) { $s.Engine | Add-Member -NotePropertyName AwaitOk -NotePropertyValue $false -Force; $changed=$true }
    if ($null -eq $s.Engine.ResumeDetected) { $s.Engine | Add-Member -NotePropertyName ResumeDetected -NotePropertyValue $false -Force; $changed=$true }
  }

  if ($changed) { Write-State $s }
  return $s
}

function Add-LogRow([datetime]$start, [datetime]$end, [string]$name, [bool]$work, [bool]$sleep) {
  if ($end -le $start) {
    $n = [string]$name
    if ($n -and -not $work -and -not $sleep -and ($n -ne "WAIT_OK")) {
      $end = $start.AddSeconds(1)
    } else {
      return
    }
  }
  $dayKey = Get-InfernalDayKey $start
  $row = '{0},{1},{2},{3},{4},{5}' -f `
    $start.ToString("yyyy-MM-dd HH:mm:ss"), `
    $end.ToString("yyyy-MM-dd HH:mm:ss"), `
    ($name -replace ","," "), `
    $work, $sleep, $dayKey
  try {
    Add-CsvLineSafe -Path $LogPath -Line $row -MutexName "Local\InfernalWheel_LogCsv"
  } catch {
    Write-EngineError "Add-LogRow" $_.Exception
  }
}

function Read-Commands() {
  return (Invoke-WithMutexRetry -Name $M_CMDS -TimeoutMs 1200 -Retries 10 -Script {
    if (-not (Test-Path $CmdFile)) { Write-TextAtomic -Path $CmdFile -Text "" }
    $raw = Read-TextSafe -Path $CmdFile -Default ""
    Write-TextAtomic -Path $CmdFile -Text ""
    return ($raw -split "`r?`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ })
  })
}

function FmtMin([int]$sec) {
  if ($sec -lt 0) { $sec = 0 }
  return [int][Math]::Round($sec / 60.0, 0)
}

function Get-LastSleepOfflineEnd {
  try {
    if (-not (Test-Path $LogPath)) { return $null }
    $raw = Read-TextSafe -Path $LogPath -Default ""
    if (-not $raw.Trim()) { return $null }
    $lines = $raw -split "`r?`n" | Where-Object { $_ }
    for ($i = $lines.Count - 1; $i -ge 0; $i--) {
      $line = $lines[$i]
      if (-not $line) { continue }
      if ($line -like "Start,*") { continue }
      $parts = $line -split ","
      if ($parts.Count -lt 3) { continue }
      if ($parts[2] -ne "SLEEP_OFFLINE") { continue }
      try { return [datetime]::Parse($parts[1]) } catch { return $null }
    }
  } catch {}
  return $null
}

function Switch-Segment([string]$name, [int]$minutes, [bool]$isWork, [bool]$isSleep, [bool]$requireOkOnEnd) {
  $now = Get-Date
  Add-LogRow $script:segStart $now $script:segName $script:segWork $script:segSleep

  if ($script:segName -eq "clope") {
    $s.TotalClopeCount += 1
    if ((Get-InfernalDayKey $script:segStart) -eq $s.DayKey) { $s.DayClopeCount += 1 }
  }

  $script:segStart = $now
  $script:segName  = $name
  $script:segWork  = $isWork
  $script:segSleep = $isSleep

  $endsAt = $null
  if ($minutes -gt 0) { $endsAt = $now.AddMinutes($minutes).ToString("yyyy-MM-dd HH:mm:ss") }

  $s.DayKey = Get-InfernalDayKey $now
  $s.Current.Name      = $name
  $s.Current.StartedAt = $now.ToString("yyyy-MM-dd HH:mm:ss")
  $s.Current.EndsAt    = $endsAt
  $s.Current.IsWork    = $isWork
  $s.Current.IsSleep   = $isSleep
  $s.Current.RequireOk = $requireOkOnEnd
  $s.Current.DisplayStartedAt = $null
  $s.Current.Paused    = $false
  $s.Current.PausedRemainSec = $null
  if ($name -ne "WAIT_OK") { $s.Current.OvertimeStartedAt = $null }
}

function Start-OvertimeIfNeeded() {
  if (-not $s.Current.OvertimeStartedAt) {
    $s.Current.OvertimeStartedAt = (NowStr)
  }
}

function Suspend-Countdown() {
  if ($s.Current.Paused) { return }
  if (-not $s.Current.EndsAt) { return }
  try {
    $now = Get-Date
    $endAt = [datetime]::Parse($s.Current.EndsAt)
    $remain = [int][Math]::Max(0, ($endAt - $now).TotalSeconds)
    $s.Current.Paused = $true
    $s.Current.PausedRemainSec = $remain
    $s.Current.EndsAt = $null
  } catch {}
}

function Resume-Countdown() {
  if (-not $s.Current.Paused) { return }
  $rem = [int]($s.Current.PausedRemainSec ?? 0)
  $s.Current.Paused = $false
  $s.Current.PausedRemainSec = $null
  if ($rem -le 0) { return }
  $now = Get-Date
  $s.Current.EndsAt = $now.AddSeconds($rem).ToString("yyyy-MM-dd HH:mm:ss")
}

function Invoke-CommandLine([string]$cmdLine, $settings) {
  $cmdLine = ($cmdLine ?? "").Trim()
  if (-not $cmdLine) { return }

  try { Add-LineSafe -Path $CmdLogPath -Line ("{0} | {1}" -f (NowStr), $cmdLine) } catch {}

  $parts = $cmdLine -split "\s+"
  $cmd = $parts[0].ToLowerInvariant()
  $arg = $null
  if ($parts.Count -ge 2) { $arg = $parts[1] }

  $actMap = Get-ActionMap $settings

  switch ($cmd) {
    "start" { $s.Engine.Started=$true; $s.Engine.AwaitOk=$false; Switch-Segment "work" 0 $true $false $false; return }
    "work"  { $s.Engine.AwaitOk=$false; Switch-Segment "work" 0 $true $false $false; return }
    "ok"    { $s.Engine.AwaitOk=$false; Switch-Segment "work" 0 $true $false $false; return }
    "dodo"  { $s.Engine.AwaitOk=$false; Switch-Segment "sleep" 0 $false $true $false; return }
    "jpp"   { $s.Engine.AwaitOk=$true;  Switch-Segment "WAIT_OK" 0 $false $false $false; Start-OvertimeIfNeeded; return }

    "pause"  { Suspend-Countdown; return }
    "resume" { Resume-Countdown; return }

    "extend" {
      # extend N minutes on current timed action
      $n = 5
      if ($arg) { [void][int]::TryParse($arg, [ref]$n) }
      if ($n -lt 1) { $n = 1 }
      if ($s.Current.EndsAt) {
        try {
          $endAt = [datetime]::Parse($s.Current.EndsAt)
          $s.Current.EndsAt = $endAt.AddMinutes($n).ToString("yyyy-MM-dd HH:mm:ss")
        } catch {}
      } elseif ($s.Current.Paused -and $s.Current.PausedRemainSec) {
        $s.Current.PausedRemainSec = [int]$s.Current.PausedRemainSec + ($n*60)
      }
      return
    }

    default {
      if ($actMap.ContainsKey($cmd)) {
        $a = $actMap[$cmd]
        $mode = [string]($a.mode ?? "break")
        $min = [int]($a.minutes ?? 0)
        if ($arg) { [void][int]::TryParse($arg, [ref]$min) }

        if ($mode -eq "work")  { $s.Engine.AwaitOk=$false; Switch-Segment "work" 0 $true $false $false; return }
        if ($mode -eq "sleep") { $s.Engine.AwaitOk=$false; Switch-Segment "sleep" 0 $false $true $false; return }

        $manualBreakOnly = Get-ManualBreakOnly $settings
        # break (manual by default; user stops with work)
        $s.Engine.AwaitOk=$false
        if ($manualBreakOnly) {
          Switch-Segment $cmd 0 $false $false $false
          return
        }

        $requireOk = [bool]($a.requireOk ?? $false)
        Switch-Segment $cmd $min $false $false $requireOk
        return
      }
    }
  }
}
