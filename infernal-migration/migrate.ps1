# Migration InfernalWheel PowerShell -> App Flutter
# Execute ce script sur ton PC pour generer les fichiers JSON

param(
    [string]$SourceDir = "$HOME\.infernal_wheel",
    [string]$OutputDir = "$HOME\.infernal_wheel\infernal-migration\output"
)

# Creer le dossier de sortie
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

Write-Host "Migration InfernalWheel" -ForegroundColor Cyan
Write-Host "Source: $SourceDir"
Write-Host "Output: $OutputDir"
Write-Host ""

# ============================================
# 1. Charger log.csv
# ============================================
$logPath = Join-Path $SourceDir "log.csv"
$logData = @{}

if (Test-Path $logPath) {
    Write-Host "Chargement log.csv..." -ForegroundColor Yellow
    $rows = Import-Csv $logPath
    foreach ($row in $rows) {
        try {
            $dayKey = $row.InfernalDay
            if (-not $dayKey) { continue }
            if (-not $logData.ContainsKey($dayKey)) {
                $logData[$dayKey] = @{
                    clope = 0
                    clopeFirst = $null
                    sleep = $null
                    wake = $null
                }
            }
            $name = $row.Name
            if ($name -eq "clope") {
                $logData[$dayKey].clope++
                if (-not $logData[$dayKey].clopeFirst) {
                    $logData[$dayKey].clopeFirst = $row.Start
                }
            }
            if ($name -eq "sleep" -and $row.End) {
                $logData[$dayKey].wake = $row.End
            }
        } catch {}
    }
    Write-Host "  $($rows.Count) lignes traitees"
}

# ============================================
# 2. Charger drinks.csv
# ============================================
$drinksPath = Join-Path $SourceDir "drinks.csv"
$drinksData = @{}

if (Test-Path $drinksPath) {
    Write-Host "Chargement drinks.csv..." -ForegroundColor Yellow
    $rows = Import-Csv $drinksPath
    foreach ($row in $rows) {
        try {
            $ts = [datetime]::Parse($row.Timestamp)
            # Utiliser InfernalDay (avant 4h = jour precedent)
            if ($ts.Hour -lt 4) {
                $ts = $ts.AddDays(-1)
            }
            $dayKey = $ts.ToString("yyyy-MM-dd")
            if (-not $drinksData.ContainsKey($dayKey)) {
                $drinksData[$dayKey] = @{beer=0; wine=0; strong=0}
            }
            $type = $row.Type
            $count = [int]($row.Count ?? 1)
            if ($drinksData[$dayKey].ContainsKey($type)) {
                $drinksData[$dayKey][$type] += $count
            }
        } catch {}
    }
    Write-Host "  $($rows.Count) lignes traitees"
}

# ============================================
# 3. Charger notes
# ============================================
$notesDir = Join-Path $SourceDir "notes"
$notesData = @{}

if (Test-Path $notesDir) {
    Write-Host "Chargement notes..." -ForegroundColor Yellow
    $files = Get-ChildItem $notesDir -Filter "*.txt"
    foreach ($f in $files) {
        $dayKey = $f.BaseName
        $content = Get-Content $f.FullName -Raw -ErrorAction SilentlyContinue
        if ($content) {
            # Nettoyer les metriques inline (Qualite sommeil: 6, etc)
            $lines = $content -split "`n"
            $cleanLines = $lines | Where-Object {
                $_ -notmatch "^(Qualit|Energie|Motivation|Douleur|Humeur|Anxi|Irritabil|Clart|Stress|Focus|Fatigue|Fiert|Intensit|Emotion|Id.es noires|Score global|Relations|minimum|priorit|declencheur)\s*[:=]"
            }
            $notesData[$dayKey] = ($cleanLines -join "`n").Trim()
        }
    }
    Write-Host "  $($files.Count) fichiers traites"
}

# ============================================
# 4. Generer les fichiers JSON
# ============================================
Write-Host ""
Write-Host "Generation fichiers JSON..." -ForegroundColor Yellow

$allDays = @($logData.Keys) + @($drinksData.Keys) + @($notesData.Keys) | Sort-Object -Unique

foreach ($dayKey in $allDays) {
    $log = $logData[$dayKey]
    $drinks = $drinksData[$dayKey]
    $notes = $notesData[$dayKey]

    $addictions = @()

    # Tabac
    if ($log -and $log.clope -gt 0) {
        $addictions += @{
            type = "tabac"
            count = $log.clope
            firstTime = $log.clopeFirst
        }
    }

    # Alcool
    if ($drinks) {
        if ($drinks.beer -gt 0) {
            $addictions += @{type="biere"; count=$drinks.beer; firstTime=$null}
        }
        if ($drinks.wine -gt 0) {
            $addictions += @{type="vin"; count=$drinks.wine; firstTime=$null}
        }
        if ($drinks.strong -gt 0) {
            $addictions += @{type="fort"; count=$drinks.strong; firstTime=$null}
        }
    }

    # Sleep (approximatif)
    $sleep = $null
    if ($log -and $log.wake) {
        try {
            $wakeTime = [datetime]::Parse($log.wake)
            $sleep = @{
                source = "manual"
                wakeTime = $wakeTime.ToString("o")
                durationMinutes = 420  # 7h par defaut
                quality = "okay"
            }
        } catch {}
    }

    $entry = @{
        dayKey = $dayKey
        sleep = $sleep
        addictions = $addictions
        journalText = ($notes ?? "")
        createdAt = "${dayKey}T00:00:00"
        updatedAt = "${dayKey}T23:59:59"
    }

    $outPath = Join-Path $OutputDir "$dayKey.json"
    $entry | ConvertTo-Json -Depth 10 | Set-Content $outPath -Encoding UTF8
}

Write-Host ""
Write-Host "Migration terminee!" -ForegroundColor Green
Write-Host "$($allDays.Count) jours exportes vers $OutputDir"
Write-Host ""
Write-Host "Prochaine etape: transferer les fichiers JSON vers l'app"
