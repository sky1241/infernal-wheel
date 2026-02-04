param(
  [string]$HostAddr = "127.0.0.1",
  [int]$Port = 8011
)

$ErrorActionPreference = "SilentlyContinue"

$DataDir = Join-Path $env:USERPROFILE ".infernal_wheel"
$dashPidFile = Join-Path $DataDir "dashboard.pid"

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

function Test-PortInUse([int]$port) {
  try {
    return $null -ne (Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction Stop | Select-Object -First 1)
  } catch {
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

Stop-ByPidFile $dashPidFile

if (Test-PortInUse $Port) {
  Write-Host "Port $Port already in use. Stop the existing dashboard and retry." -ForegroundColor Red
  return
}

$root = Split-Path -Parent $PSCommandPath
$dash = Join-Path $root "InfernalDashboard.ps1"

Start-Process pwsh -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-File",$dash,"-HostAddr",$HostAddr,"-Port",$Port) -WindowStyle Hidden | Out-Null
Start-Sleep -Milliseconds 600
Start-Process "http://${HostAddr}:$Port/"

Write-Host "InfernalDashboard started on http://${HostAddr}:$Port/" -ForegroundColor Green
