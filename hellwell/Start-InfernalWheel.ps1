param(
  [int]$GoalHours = 500,
  [int]$Port = 8011
)

$ErrorActionPreference = "SilentlyContinue"

$DataDir = Join-Path $env:USERPROFILE ".infernal_wheel"
$timerPidFile = Join-Path $DataDir "timer.pid"
$dashPidFile  = Join-Path $DataDir "dashboard.pid"

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
Stop-ByPidFile $dashPidFile


function Test-PortInUse([int]$port) {
  try {
    return $null -ne (Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction Stop | Select-Object -First 1)
  } catch {
    # fallback: try to bind
    try {
      $l = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $port)
      $l.Start()
      $l.Stop()
      return $false
    } catch {
      return $true
    }
  }
}

if (Test-PortInUse $Port) {
  Write-Host "Port $Port already in use. Stop the existing dashboard and retry." -ForegroundColor Red
  return
}

$root = Split-Path -Parent $PSCommandPath
$timer = Join-Path $root "InfernalWheel.ps1"
$dash  = Join-Path $root "InfernalDashboard.ps1"

# start timer
Start-Process pwsh -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-File",$timer,"-GoalHours",$GoalHours) -WindowStyle Hidden | Out-Null

# start dashboard
Start-Process pwsh -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-File",$dash,"-HostAddr","127.0.0.1","-Port",$Port) -WindowStyle Hidden | Out-Null

Start-Sleep -Milliseconds 900
Start-Process "http://127.0.0.1:$Port/"

Write-Host "InfernalWheel v4 started on http://127.0.0.1:$Port/" -ForegroundColor Green
Write-Host "Click START (or WORK) to begin. If WAIT_OK: click OK." -ForegroundColor Yellow
