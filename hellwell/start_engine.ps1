param(
  [int]$GoalHours = 500
)

$ErrorActionPreference = "SilentlyContinue"

$DataDir = Join-Path $env:USERPROFILE ".infernal_wheel"
$timerPidFile = Join-Path $DataDir "timer.pid"

function Stop-ByPidFile($p) {
  try {
    if (Test-Path $p) {
      $id = (Get-Content $p -Raw).Trim()
      if ($id) {
        $proc = Get-Process -Id ([int]$id) -ErrorAction SilentlyContinue
        if ($proc) { Stop-Process -Id $proc.Id -Force }
      }
    }
  } catch {}
}

Stop-ByPidFile $timerPidFile

$root = Split-Path -Parent $PSCommandPath
$timer = Join-Path $root "InfernalWheel.ps1"

Start-Process pwsh -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-File",$timer,"-GoalHours",$GoalHours) -WindowStyle Hidden | Out-Null

Write-Host "InfernalWheel engine started." -ForegroundColor Green
