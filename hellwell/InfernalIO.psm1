Set-StrictMode -Version Latest

function New-BackoffMs([int]$attempt) {
  $base = [Math]::Min(800, 60 + ($attempt * 80))
  $jitter = Get-Random -Minimum 0 -Maximum 120
  return ($base + $jitter)
}

function Get-MutexNameForPath {
  param(
    [Parameter(Mandatory)][string]$Path,
    [string]$Prefix = "Local\InfernalWheel_File"
  )
  try {
    $norm = $Path.ToLowerInvariant()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($norm)
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $hash = $sha.ComputeHash($bytes)
    $sha.Dispose()
    $hex = [System.BitConverter]::ToString($hash).Replace("-", "")
    return ("{0}_{1}" -f $Prefix, $hex.Substring(0, 16))
  } catch {
    return ($Prefix + "_fallback")
  }
}

function Invoke-WithMutexRetry {
  param(
    [Parameter(Mandatory)] [string] $Name,
    [Parameter(Mandatory)] [scriptblock] $Script,
    [int] $TimeoutMs = 1500,
    [int] $Retries = 12
  )
  $m = $null
  try {
    $m = [System.Threading.Mutex]::new($false, $Name)
    for ($i=0; $i -lt $Retries; $i++) {
      $locked = $false
      try {
        try {
          $locked = $m.WaitOne($TimeoutMs)
        } catch [System.Threading.AbandonedMutexException] {
          # Treat abandoned mutex as acquired to avoid permanent deadlock.
          $locked = $true
        }
        if ($locked) {
          return & $Script
        }
      } catch {
        # ignore and retry
      } finally {
        if ($locked) { try { $m.ReleaseMutex() } catch {} }
      }
      Start-Sleep -Milliseconds (New-BackoffMs $i)
    }
    throw "Mutex timeout: $Name"
  } finally {
    if ($m) { try { $m.Dispose() } catch {} }
  }
}

function Read-TextSafe {
  param([Parameter(Mandatory)][string]$Path, [string]$Default = "")
  try {
    if (-not (Test-Path $Path)) { return $Default }
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
  } catch {
    return $Default
  }
}

function Write-TextAtomicCore {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][AllowEmptyString()][string]$Text,
    [string]$BackupPath = $null
  )

  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

  $tmp = "$Path.tmp.$([Guid]::NewGuid().ToString('N'))"
  [System.IO.File]::WriteAllText($tmp, $Text, [System.Text.Encoding]::UTF8)

  # flush best-effort
  try {
    $fs = [System.IO.File]::Open($tmp, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read)
    $fs.Flush($true)
    $fs.Dispose()
  } catch {}

  if (Test-Path $Path) {
    try {
      if ($BackupPath) {
        [System.IO.File]::Replace($tmp, $Path, $BackupPath, $true)
      } else {
        [System.IO.File]::Replace($tmp, $Path, $null, $true)
      }
      return
    } catch {
      # fallback
    }
  }

  try {
    Move-Item -Force -Path $tmp -Destination $Path
  } catch {
    # last resort: copy then remove
    Copy-Item -Force -Path $tmp -Destination $Path
    Remove-Item -Force -Path $tmp -ErrorAction SilentlyContinue
  }
}

function Write-TextAtomic {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][AllowEmptyString()][string]$Text,
    [string]$BackupPath = $null,
    [string]$MutexName = $null,
    [int]$TimeoutMs = 1500,
    [int]$Retries = 12
  )

  if (-not $MutexName) { $MutexName = Get-MutexNameForPath -Path $Path -Prefix "Local\InfernalWheel_Text" }
  Invoke-WithMutexRetry -Name $MutexName -TimeoutMs $TimeoutMs -Retries $Retries -Script {
    Write-TextAtomicCore -Path $Path -Text $Text -BackupPath $BackupPath
  } | Out-Null
}

function ConvertTo-JsonUtf8 {
  param([Parameter(Mandatory)]$Obj)
  return ($Obj | ConvertTo-Json -Depth 16)
}

function Read-JsonSafe {
  param(
    [Parameter(Mandatory)][string]$Path,
    [string]$BackupPath = $null
  )
  try {
    if (-not (Test-Path $Path)) { return $null }
    $raw = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
    if (-not $raw.Trim()) { return $null }
    return ($raw | ConvertFrom-Json)
  } catch {
    # try backup
    if ($BackupPath -and (Test-Path $BackupPath)) {
      try {
        $raw2 = [System.IO.File]::ReadAllText($BackupPath, [System.Text.Encoding]::UTF8)
        if ($raw2.Trim()) { return ($raw2 | ConvertFrom-Json) }
      } catch {}
    }
    return $null
  }
}

function Write-JsonAtomic {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)]$Obj,
    [string]$BackupPath = $null,
    [string]$MutexName = $null,
    [int]$TimeoutMs = 1500,
    [int]$Retries = 12
  )
  $json = ConvertTo-JsonUtf8 -Obj $Obj

  # validate JSON parse before writing
  try { $null = ($json | ConvertFrom-Json) } catch {
    throw "Refuse to write invalid JSON to $Path"
  }

  Write-TextAtomic -Path $Path -Text $json -BackupPath $BackupPath -MutexName $MutexName -TimeoutMs $TimeoutMs -Retries $Retries
}

function Add-LineSafe {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Line,
    [string]$MutexName = $null,
    [int]$TimeoutMs = 1500,
    [int]$Retries = 12
  )
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  if (-not $MutexName) { $MutexName = Get-MutexNameForPath -Path $Path -Prefix "Local\InfernalWheel_Line" }
  Invoke-WithMutexRetry -Name $MutexName -TimeoutMs $TimeoutMs -Retries $Retries -Script {
    try {
      Add-Content -Path $Path -Value $Line -Encoding UTF8
    } catch {
      # retry via atomic-ish append (read+write)
      Write-TextAtomicCore -Path $Path -Text ((Read-TextSafe -Path $Path -Default "") + $Line + "`r`n")
    }
  } | Out-Null
}

function Add-CsvLineSafe {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Line,
    [string]$MutexName = "Local\InfernalWheel_CSV",
    [int]$TimeoutMs = 1500,
    [int]$Retries = 12
  )
  Invoke-WithMutexRetry -Name $MutexName -TimeoutMs $TimeoutMs -Retries $Retries -Script {
    $fs = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::OpenOrCreate, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::Read)
    try {
      $fs.Seek(0, [System.IO.SeekOrigin]::End) | Out-Null
      $sw = [System.IO.StreamWriter]::new($fs, [System.Text.Encoding]::UTF8, 1024, $true)
      try { $sw.WriteLine($Line) } finally { $sw.Flush() }
    } finally {
      $fs.Dispose()
    }
  } | Out-Null
}

function Write-ErrorLog {
  param(
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Context,
    [System.Exception]$Exception
  )
  try {
    $msg = ""
    if ($Exception) { $msg = $Exception.ToString() }
    $line = "{0}`t{1}`t{2}" -f (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"), $Context, $msg
    Add-LineSafe -Path $Path -Line $line -MutexName (Get-MutexNameForPath -Path $Path -Prefix "Local\InfernalWheel_Log")
  } catch {
    # swallow logging errors
  }
}

Export-ModuleMember -Function *-*
