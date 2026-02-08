function NowStr() { (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") }

function Test-PsesHost {
  if ($env:PSES_CLIENTID -or $env:PSES_SESSIONID -or $env:PSES_JSONRPC_PIPE) { return $true }
  if ($host.Name -like "*PowerShell Editor Services*") { return $true }
  return $false
}

function Get-AlcoholUnits {
  param([int]$Wine=0, [int]$Beer=0, [int]$Strong=0)
  $beerPure = [double]$BEER_L * $BEER_ABV
  $winePure = [double]$WINE_L * $WINE_ABV
  $strongPure = [double]$STRONG_L * $STRONG_ABV
  $base = if ($beerPure -gt 0) { $beerPure } else { 1.0 }
  $units = ($Beer * ($beerPure / $base)) + ($Wine * ($winePure / $base)) + ($Strong * ($strongPure / $base))
  return [Math]::Round($units, 2)
}

# === WAKE-BASED DAY SYSTEM ===
# Le jour commence au réveil (passage sleep → work), pas à 4h fixe

function Get-WakesPath() {
  return (Join-Path $DataDir "wakes.csv")
}

function Get-LastWakeBefore([datetime]$dt) {
  # Retourne le dernier réveil avant $dt, ou $null si aucun
  $wakesPath = Get-WakesPath
  if (-not (Test-Path $wakesPath)) { return $null }

  $lastWake = $null
  try {
    $lines = Get-Content $wakesPath -ErrorAction SilentlyContinue | Select-Object -Skip 1
    foreach ($line in $lines) {
      if (-not $line) { continue }
      $parts = $line -split ","
      if ($parts.Count -lt 1) { continue }
      try {
        $wakeTime = [datetime]::Parse($parts[0])
        if ($wakeTime -le $dt) {
          if ($null -eq $lastWake -or $wakeTime -gt $lastWake) {
            $lastWake = $wakeTime
          }
        }
      } catch {}
    }
  } catch {}
  return $lastWake
}

function Get-InfernalDayKey([datetime]$dt) {
  # Nouvelle logique: le jour = date du dernier réveil
  $lastWake = Get-LastWakeBefore $dt

  if ($null -ne $lastWake) {
    # Le jour est la date du réveil
    return $lastWake.ToString("yyyy-MM-dd")
  }

  # Fallback: ancienne logique 4h si pas de réveil enregistré
  $dayStart = Get-Date -Year $dt.Year -Month $dt.Month -Day $dt.Day -Hour 4 -Minute 0 -Second 0
  if ($dt -lt $dayStart) { return $dt.AddDays(-1).ToString("yyyy-MM-dd") }
  return $dt.ToString("yyyy-MM-dd")
}

function Get-PrevDayKey([string]$dayKey) {
  try {
    $dt = [datetime]::ParseExact($dayKey, "yyyy-MM-dd", $null)
    return $dt.AddDays(-1).ToString("yyyy-MM-dd")
  } catch {
    return ""
  }
}

function Get-TimeOfDayMinutes([datetime]$dt) {
  return ($dt.Hour * 60) + $dt.Minute
}

function Add-DrinksEntry {
  param([int]$Wine=0, [int]$Beer=0, [int]$Strong=0)

  $at = Get-Date
  $dayKey = Get-InfernalDayKey $at
  $line = '{0},{1},{2},{3},{4}' -f `
    $at.ToString("yyyy-MM-dd HH:mm:ss"), $dayKey, $Wine, $Beer, $Strong

  Add-CsvLineSafe -Path $DrinksPath -Line $line -MutexName "Local\InfernalWheel_Drinks"
  return $line
}

function Get-ISOWeekKey([datetime]$dt) {
  $w = [System.Globalization.ISOWeek]::GetWeekOfYear($dt)
  $y = [System.Globalization.ISOWeek]::GetYear($dt)
  return ("{0}-W{1:00}" -f $y,$w)
}

function Get-DayShortFr([datetime]$dt) {
  switch ($dt.DayOfWeek) {
    "Monday"    { return "lun" }
    "Tuesday"   { return "mar" }
    "Wednesday" { return "mer" }
    "Thursday"  { return "jeu" }
    "Friday"    { return "ven" }
    "Saturday"  { return "sam" }
    "Sunday"    { return "dim" }
    default     { return "" }
  }
}

function Get-ISOWeekRangeLabel([string]$weekKey) {
  if (-not $weekKey) { return "" }
  if ($weekKey -notmatch "^(\d{4})-W(\d{2})$") { return "" }
  try {
    $year = [int]$matches[1]
    $week = [int]$matches[2]
    $start = [System.Globalization.ISOWeek]::ToDateTime($year, $week, [DayOfWeek]::Monday)
    $end = $start.AddDays(6)
    return ("{0} - {1}" -f $start.ToString("dd/MM"), $end.ToString("dd/MM"))
  } catch {
    return ""
  }
}

function Get-WeeklyAlcoholLiters {
  if (-not (Test-Path $DrinksPath)) { return @() }

  $rows = @()
  try { $rows = Import-Csv -Path $DrinksPath } catch {
    return [pscustomobject]@{
      MonthKey = $Ym
      WineGlasses = 0
      BeerCans = 0
      StrongGlasses = 0
      WineLiters = 0
      BeerLiters = 0
      StrongLiters = 0
      WineBottles = 0
      StrongBottles = 0
      TotalLiters = 0
    }
  }

  $weeks = @{}
  foreach ($r in $rows) {
    try {
      $dk = [string]$r.InfernalDay
      if (-not $dk) { continue }
      $dt = [datetime]::Parse($dk + " 12:00:00")
      $wk = Get-ISOWeekKey $dt
      if (-not $weeks.ContainsKey($wk)) { $weeks[$wk] = @{ wine=0; beer=0; strong=0 } }

      $weeks[$wk].wine   += [int]($r.Wine   ?? 0)
      $weeks[$wk].beer   += [int]($r.Beer   ?? 0)
      $weeks[$wk].strong += [int]($r.Strong ?? 0)
    } catch {}
  }

  $out = @()
  $prevPure = $null
  foreach ($wk in ($weeks.Keys | Sort-Object)) {
    $w = $weeks[$wk]
    $lWine   = [math]::Round($w.wine   * $WINE_L,   3)
    $lBeer   = [math]::Round($w.beer   * $BEER_L,   3)
    $lStrong = [math]::Round($w.strong * $STRONG_L, 3)
    $lTotal  = [math]::Round($lWine + $lBeer + $lStrong, 3)
    $lPure   = [math]::Round(
      ($w.wine * $WINE_L * $WINE_ABV) +
      ($w.beer * $BEER_L * $BEER_ABV) +
      ($w.strong * $STRONG_L * $STRONG_ABV),
      3
    )
    $deltaPure = $null
    if ($null -ne $prevPure) { $deltaPure = [math]::Round($lPure - $prevPure, 3) }
    $prevPure = $lPure
    $rangeLabel = Get-ISOWeekRangeLabel $wk

    $out += [pscustomobject]@{
      WeekKey = $wk
      WeekRange = $rangeLabel
      WineGlasses = $w.wine
      BeerCans = $w.beer
      StrongGlasses = $w.strong
      WineLiters = $lWine
      BeerLiters = $lBeer
      StrongLiters = $lStrong
      TotalLiters = $lTotal
      PureLiters = $lPure
      DeltaPure = $deltaPure
    }
  }

  return $out
}

function Get-MonthKey([datetime]$dt) {
  return $dt.ToString("yyyy-MM")
}

function Get-MonthlyAlcoholTotals {
  param([string]$Ym)

  if (-not $Ym) { $Ym = (Get-Date).ToString("yyyy-MM") }
  if (-not (Test-Path $DrinksPath)) {
    return [pscustomobject]@{
      MonthKey = $Ym
      WineGlasses = 0
      BeerCans = 0
      StrongGlasses = 0
      WineLiters = 0
      BeerLiters = 0
      StrongLiters = 0
      WineBottles = 0
      StrongBottles = 0
      TotalLiters = 0
    }
  }

  $rows = @()
  try { $rows = Import-Csv -Path $DrinksPath } catch { return @() }

  $wine = 0
  $beer = 0
  $strong = 0
  foreach ($r in $rows) {
    try {
      $dk = [string]$r.InfernalDay
      if (-not $dk) { continue }
      if (-not $dk.StartsWith($Ym)) { continue }
      $wine   += [int]($r.Wine   ?? 0)
      $beer   += [int]($r.Beer   ?? 0)
      $strong += [int]($r.Strong ?? 0)
    } catch {}
  }

  $lWine   = [math]::Round($wine * $WINE_L, 3)
  $lBeer   = [math]::Round($beer * $BEER_L, 3)
  $lStrong = [math]::Round($strong * $STRONG_L, 3)
  $lTotal  = [math]::Round($lWine + $lBeer + $lStrong, 3)

  $wineBottles = 0
  if ($WINE_BOTTLE_L -gt 0) { $wineBottles = [math]::Round($lWine / $WINE_BOTTLE_L, 2) }
  $strongBottles = 0
  if ($STRONG_BOTTLE_L -gt 0) { $strongBottles = [math]::Round($lStrong / $STRONG_BOTTLE_L, 2) }

  return [pscustomobject]@{
    MonthKey = $Ym
    WineGlasses = $wine
    BeerCans = $beer
    StrongGlasses = $strong
    WineLiters = $lWine
    BeerLiters = $lBeer
    StrongLiters = $lStrong
    WineBottles = $wineBottles
    StrongBottles = $strongBottles
    TotalLiters = $lTotal
  }
}

function Get-MonthlyStats {
  param([string]$Ym)

  if (-not $Ym) { $Ym = (Get-Date).ToString("yyyy-MM") }
  $mr = Get-MonthRange $Ym
  $first = $mr.first
  $daysInMonth = [DateTime]::DaysInMonth($first.Year, $first.Month)

  $daily = @{}
  for ($day=1; $day -le $daysInMonth; $day++) {
    $d = Get-Date -Year $first.Year -Month $first.Month -Day $day -Hour 0 -Minute 0 -Second 0
    $key = $d.ToString("yyyy-MM-dd")
    $daily[$key] = @{
      workSec = 0
      sleepSec = 0
      breakSec = 0
      clopeSec = 0
      clopeCount = 0
      sportSec = 0
      marcheSec = 0
      mangerSec = 0
      reveilleSec = 0
      glandouilleSec = 0
    }
  }

  $workSessions = @()
  $rows = Read-LogRows
  foreach ($r in $rows) {
    try {
      $s = [datetime]::Parse($r.Start)
      $e = [datetime]::Parse($r.End)
      if ($e -le $s) { $e = $s.AddSeconds(1) }
      $dur = [int]($e - $s).TotalSeconds
      $dk = if ($r.InfernalDay) { [string]$r.InfernalDay } else { $s.ToString("yyyy-MM-dd") }
      if (-not $dk.StartsWith($Ym)) { continue }
      if (-not $daily.ContainsKey($dk)) {
        $daily[$dk] = @{
          workSec = 0
          sleepSec = 0
          breakSec = 0
          clopeSec = 0
          clopeCount = 0
          sportSec = 0
          marcheSec = 0
          mangerSec = 0
          reveilleSec = 0
          glandouilleSec = 0
        }
      }
      $name = Get-LogName $r
      $nameKey = if ($name) { $name.ToLowerInvariant() } else { "" }

      if ([string]$r.CountsAsWork -eq "True") {
        $daily[$dk].workSec += $dur
        $workSessions += $dur
      } elseif ([string]$r.CountsAsSleep -eq "True") {
        $daily[$dk].sleepSec += $dur
      } else {
        $daily[$dk].breakSec += $dur
      }

      if ($nameKey -eq "clope") {
        $daily[$dk].clopeCount += 1
        $daily[$dk].clopeSec += $dur
      }
      if ($nameKey -eq "sport") {
        $daily[$dk].sportSec += $dur
      }
      if ($nameKey -eq "marche") {
        $daily[$dk].marcheSec += $dur
      }
      if ($nameKey -eq "manger") {
        $daily[$dk].mangerSec += $dur
      }
      if ($nameKey -eq "reveille") {
        $daily[$dk].reveilleSec += $dur
      }
      if ($nameKey -eq "glandouille") {
        $daily[$dk].glandouilleSec += $dur
      }
    } catch {}
  }

  $totalWorkSec = 0
  $totalSleepSec = 0
  $totalBreakSec = 0
  $totalClopeSec = 0
  $totalSportSec = 0
  $totalClopeCount = 0
  $workDays = 0
  $sleepDays = 0
  $sportDays = 0
  $clopeFreeDays = 0
  $bestWorkSec = -1
  $bestWorkDay = ""

  foreach ($k in $daily.Keys) {
    $d = $daily[$k]
    $totalWorkSec += [int]$d.workSec
    $totalSleepSec += [int]$d.sleepSec
    $totalBreakSec += [int]$d.breakSec
    $totalClopeSec += [int]$d.clopeSec
    $totalSportSec += [int]$d.sportSec
    $totalClopeCount += [int]$d.clopeCount
    if ($d.workSec -gt 0) { $workDays++ }
    if ($d.sleepSec -gt 0) { $sleepDays++ }
    if ($d.sportSec -gt 0) { $sportDays++ }
    if ([int]$d.clopeCount -eq 0) { $clopeFreeDays++ }
    if ($d.workSec -gt $bestWorkSec) { $bestWorkSec = [int]$d.workSec; $bestWorkDay = $k }
  }

  $avgWorkSessionSec = 0
  if ($workSessions.Count -gt 0) {
    $avgWorkSessionSec = [int][Math]::Round(($workSessions | Measure-Object -Sum).Sum / $workSessions.Count, 0)
  }

  $dailyList = @()
  for ($day=1; $day -le $daysInMonth; $day++) {
    $d = Get-Date -Year $first.Year -Month $first.Month -Day $day -Hour 0 -Minute 0 -Second 0
    $key = $d.ToString("yyyy-MM-dd")
    $v = $daily[$key]
    $dailyList += [pscustomobject]@{
      day = $day
      date = $key
      workMin = [int][Math]::Round($v.workSec / 60.0, 0)
      sleepMin = [int][Math]::Round($v.sleepSec / 60.0, 0)
      breakMin = [int][Math]::Round($v.breakSec / 60.0, 0)
      sportMin = [int][Math]::Round($v.sportSec / 60.0, 0)
      marcheMin = [int][Math]::Round($v.marcheSec / 60.0, 0)
      mangerMin = [int][Math]::Round($v.mangerSec / 60.0, 0)
      reveilleMin = [int][Math]::Round($v.reveilleSec / 60.0, 0)
      glandouilleMin = [int][Math]::Round($v.glandouilleSec / 60.0, 0)
      clopeCount = [int]$v.clopeCount
      clopeMin = [int][Math]::Round($v.clopeSec / 60.0, 0)
    }
  }

  return [pscustomobject]@{
    MonthKey = $Ym
    DaysInMonth = $daysInMonth
    Daily = $dailyList
    TotalWorkSec = $totalWorkSec
    TotalSleepSec = $totalSleepSec
    TotalBreakSec = $totalBreakSec
    TotalSportSec = $totalSportSec
    TotalClopeSec = $totalClopeSec
    TotalClopeCount = $totalClopeCount
    WorkSessions = $workSessions.Count
    AvgWorkSessionSec = $avgWorkSessionSec
    WorkDays = $workDays
    SleepDays = $sleepDays
    SportDays = $sportDays
    ClopeFreeDays = $clopeFreeDays
    BestWorkDay = $bestWorkDay
    BestWorkSec = $bestWorkSec
  }
}

function Get-MonthlySummary {
  param([string]$Ym)

  if (-not $Ym -or -not ($Ym -match "^\d{4}-\d{2}$")) { $Ym = (Get-Date).ToString("yyyy-MM") }
  $curr = Get-MonthlyStats $Ym
  $currFirst = Get-Date -Year ([int]$Ym.Split('-')[0]) -Month ([int]$Ym.Split('-')[1]) -Day 1
  $prevYm = $currFirst.AddMonths(-1).ToString("yyyy-MM")
  $prev = Get-MonthlyStats $prevYm

  $alcDaily = @{}
  $alcRows = Read-CsvSafe -Path $DrinksPath -MutexName "Local\InfernalWheel_Drinks"
  foreach ($r in $alcRows) {
    try {
      $dk = [string]$r.InfernalDay
      if (-not $dk -or -not $dk.StartsWith($Ym)) { continue }
      if (-not $alcDaily.ContainsKey($dk)) { $alcDaily[$dk] = @{ wine=0; beer=0; strong=0 } }
      $alcDaily[$dk].wine += [int]($r.Wine ?? 0)
      $alcDaily[$dk].beer += [int]($r.Beer ?? 0)
      $alcDaily[$dk].strong += [int]($r.Strong ?? 0)
    } catch {}
  }
  foreach ($d in $curr.Daily) {
    try {
      $dk = [string]$d.date
      $a = if ($alcDaily.ContainsKey($dk)) { $alcDaily[$dk] } else { @{ wine=0; beer=0; strong=0 } }
      $count = Get-AlcoholUnits -Wine ([int]$a.wine) -Beer ([int]$a.beer) -Strong ([int]$a.strong)
      $liters = [math]::Round(([double]$a.wine * $WINE_L) + ([double]$a.beer * $BEER_L) + ([double]$a.strong * $STRONG_L), 3)
      $d | Add-Member -NotePropertyName alcoholCount -NotePropertyValue $count -Force
      $d | Add-Member -NotePropertyName alcoholLiters -NotePropertyValue $liters -Force
    } catch {}
  }

  $days = [int]$curr.DaysInMonth
  $avgSleepMin = if ($days -gt 0) { [Math]::Round(($curr.TotalSleepSec / 60.0) / $days, 1) } else { 0 }
  $avgWorkMin = if ($days -gt 0) { [Math]::Round(($curr.TotalWorkSec / 60.0) / $days, 1) } else { 0 }
  $avgSportMin = if ($days -gt 0) { [Math]::Round(($curr.TotalSportSec / 60.0) / $days, 1) } else { 0 }
  $avgClopeCount = if ($days -gt 0) { [Math]::Round($curr.TotalClopeCount / [double]$days, 2) } else { 0 }
  $avgClopeMin = if ($days -gt 0) { [Math]::Round(($curr.TotalClopeSec / 60.0) / $days, 1) } else { 0 }
  $avgWorkSessionMin = if ($curr.AvgWorkSessionSec -gt 0) { [Math]::Round($curr.AvgWorkSessionSec / 60.0, 1) } else { 0 }

  $alcCurr = Get-MonthlyAlcoholTotals $Ym
  $alcPrev = Get-MonthlyAlcoholTotals $prevYm
  $alcTotalCount = Get-AlcoholUnits -Wine ([int]$alcCurr.WineGlasses) -Beer ([int]$alcCurr.BeerCans) -Strong ([int]$alcCurr.StrongGlasses)
  $alcAvgPerDay = if ($days -gt 0) { [Math]::Round($alcTotalCount / [double]$days, 2) } else { 0 }
  $alcAvgLitersPerDay = if ($days -gt 0) { [Math]::Round($alcCurr.TotalLiters / [double]$days, 3) } else { 0 }

  $prevDays = [int]$prev.DaysInMonth
  $prevAvgSleepMin = if ($prevDays -gt 0) { [Math]::Round(($prev.TotalSleepSec / 60.0) / $prevDays, 1) } else { 0 }
  $prevAvgWorkMin = if ($prevDays -gt 0) { [Math]::Round(($prev.TotalWorkSec / 60.0) / $prevDays, 1) } else { 0 }
  $prevAvgSportMin = if ($prevDays -gt 0) { [Math]::Round(($prev.TotalSportSec / 60.0) / $prevDays, 1) } else { 0 }
  $prevAvgClopeCount = if ($prevDays -gt 0) { [Math]::Round($prev.TotalClopeCount / [double]$prevDays, 2) } else { 0 }
  $prevAvgWorkSessionMin = if ($prev.AvgWorkSessionSec -gt 0) { [Math]::Round($prev.AvgWorkSessionSec / 60.0, 1) } else { 0 }
  $prevAlcTotalCount = Get-AlcoholUnits -Wine ([int]$alcPrev.WineGlasses) -Beer ([int]$alcPrev.BeerCans) -Strong ([int]$alcPrev.StrongGlasses)
  $prevAlcAvgPerDay = if ($prevDays -gt 0) { [Math]::Round($prevAlcTotalCount / [double]$prevDays, 2) } else { 0 }
  $prevAlcAvgLitersPerDay = if ($prevDays -gt 0) { [Math]::Round($alcPrev.TotalLiters / [double]$prevDays, 3) } else { 0 }

  $deltaSleepMin = [Math]::Round($avgSleepMin - $prevAvgSleepMin, 1)
  $deltaWorkMin = [Math]::Round($avgWorkMin - $prevAvgWorkMin, 1)
  $deltaSportMin = [Math]::Round($avgSportMin - $prevAvgSportMin, 1)
  $deltaClopeCount = [Math]::Round($avgClopeCount - $prevAvgClopeCount, 2)
  $deltaWorkSessionMin = [Math]::Round($avgWorkSessionMin - $prevAvgWorkSessionMin, 1)
  $deltaAlcAvgPerDay = [Math]::Round($alcAvgPerDay - $prevAlcAvgPerDay, 2)
  $deltaAlcAvgLitersPerDay = [Math]::Round($alcAvgLitersPerDay - $prevAlcAvgLitersPerDay, 3)

  $insights = @()
  if ([Math]::Abs($deltaSleepMin) -ge 0.2) {
    $insights += ("Sleep avg {0}{1} min/day vs last month." -f ($deltaSleepMin -gt 0 ? "+" : ""), $deltaSleepMin)
  } else {
    $insights += "Sleep avg stable vs last month."
  }
  if ([Math]::Abs($deltaClopeCount) -ge 0.05) {
    $insights += ("Clope avg {0}{1} per day vs last month." -f ($deltaClopeCount -gt 0 ? "+" : ""), $deltaClopeCount)
  } else {
    $insights += "Clope avg stable vs last month."
  }
  if ([Math]::Abs($deltaSportMin) -ge 1) {
    $insights += ("Sport avg {0}{1} min/day vs last month." -f ($deltaSportMin -gt 0 ? "+" : ""), $deltaSportMin)
  } else {
    $insights += "Sport avg stable vs last month."
  }
  if ([Math]::Abs($deltaAlcAvgPerDay) -ge 0.05) {
    $insights += ("Alcool avg {0}{1} per day vs last month." -f ($deltaAlcAvgPerDay -gt 0 ? "+" : ""), $deltaAlcAvgPerDay)
  } else {
    $insights += "Alcool avg stable vs last month."
  }
  if ([Math]::Abs($deltaWorkSessionMin) -ge 1) {
    $insights += ("Work session avg {0}{1} min vs last month." -f ($deltaWorkSessionMin -gt 0 ? "+" : ""), $deltaWorkSessionMin)
  } else {
    $insights += "Work session avg stable vs last month."
  }
  if ($curr.BestWorkDay) {
    $bestMin = [Math]::Round($curr.BestWorkSec / 60.0, 1)
    $insights += ("Best work day: {0} ({1} min)." -f $curr.BestWorkDay, $bestMin)
  }
  $insights += ("Alcool total: {0} L (Wine {1} L, Beer {2} L, Strong {3} L)." -f $alcCurr.TotalLiters, $alcCurr.WineLiters, $alcCurr.BeerLiters, $alcCurr.StrongLiters)
  $insights += ("Clope-free days: {0}." -f $curr.ClopeFreeDays)

  $displayClopeSec = [int]($s.DayClopeSeconds ?? 0)
  if ($currName -eq "clope" -and $currStart) {
    try {
      $currDayKey = Get-InfernalDayKey $currStart
      if ($currDayKey -eq $todayKey) {
        $minSec = 7 * 60
        $bonus = [int][Math]::Max(0, $minSec - $elapsed)
        if ($bonus -gt 0) { $displayClopeSec += $bonus }
      }
    } catch {}
  }

  return @{
    ok = $true
    month = $curr.MonthKey
    days = $curr.Daily
    summary = @{
      totalWorkMin = [Math]::Round($curr.TotalWorkSec / 60.0, 1)
      totalSleepMin = [Math]::Round($curr.TotalSleepSec / 60.0, 1)
      totalSportMin = [Math]::Round($curr.TotalSportSec / 60.0, 1)
      totalBreakMin = [Math]::Round($curr.TotalBreakSec / 60.0, 1)
      totalClopeCount = $curr.TotalClopeCount
      totalClopeMin = [Math]::Round($curr.TotalClopeSec / 60.0, 1)
      avgSleepMin = $avgSleepMin
      avgWorkMin = $avgWorkMin
      avgSportMin = $avgSportMin
      avgClopeCount = $avgClopeCount
      avgClopeMin = $avgClopeMin
      avgWorkSessionMin = $avgWorkSessionMin
      workSessions = $curr.WorkSessions
      workDays = $curr.WorkDays
      sportDays = $curr.SportDays
      clopeFreeDays = $curr.ClopeFreeDays
      bestWorkDay = $curr.BestWorkDay
      bestWorkMin = [Math]::Round($curr.BestWorkSec / 60.0, 1)
      alcohol = @{
        wineCount = $alcCurr.WineGlasses
        beerCount = $alcCurr.BeerCans
        strongCount = $alcCurr.StrongGlasses
        totalLiters = $alcCurr.TotalLiters
        wineLiters = $alcCurr.WineLiters
        beerLiters = $alcCurr.BeerLiters
        strongLiters = $alcCurr.StrongLiters
        wineBottles = $alcCurr.WineBottles
        strongBottles = $alcCurr.StrongBottles
        avgDrinksPerDay = $alcAvgPerDay
        avgLitersPerDay = $alcAvgLitersPerDay
      }
    }
    delta = @{
      avgSleepMin = $deltaSleepMin
      avgWorkMin = $deltaWorkMin
      avgSportMin = $deltaSportMin
      avgClopeCount = $deltaClopeCount
      avgWorkSessionMin = $deltaWorkSessionMin
      avgAlcoholPerDay = $deltaAlcAvgPerDay
      avgAlcoholLitersPerDay = $deltaAlcAvgLitersPerDay
    }
    insights = $insights
  }
}

function ConvertFrom-QueryString([string]$q) {
  $out = @{}
  if (-not $q) { return $out }
  $q = $q.TrimStart('?')
  foreach ($pair in $q.Split('&')) {
    if (-not $pair) { continue }
    $kv = $pair.Split('=', 2)
    $k = [uri]::UnescapeDataString($kv[0])
    $v = ""
    if ($kv.Count -gt 1) { $v = [uri]::UnescapeDataString($kv[1]) }
    $out[$k] = $v
  }
  return $out
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
  } | Out-Null
}

function Read-StateSafe() {
  try {
    return (Invoke-WithMutexRetry -Name $M_STATE -TimeoutMs 700 -Retries 4 -Script {
      Read-JsonSafe -Path $StatePath -BackupPath $StateBakPath
    })
  } catch {
    Write-ErrorLog -Path $DashLogPath -Context "Read-StateSafe" -Exception $_.Exception
    return $null
  }
}

function Get-HeartbeatStatus() {
  $hb = Read-TextSafe -Path $HeartbeatPath -Default ""
  $hb = $hb.Trim()
  if (-not $hb) { return @{ status="OFFLINE"; ageSec=$null; at=$null } }
  try {
    $t = [datetime]::Parse($hb)
    $age = (New-TimeSpan -Start $t -End (Get-Date)).TotalSeconds
    if ($age -le 5)  { return @{ status="ONLINE"; ageSec=$age; at=$hb } }
    if ($age -le 30) { return @{ status="STALE";  ageSec=$age; at=$hb } }
    return @{ status="OFFLINE"; ageSec=$age; at=$hb }
  } catch {
    return @{ status="UNKNOWN"; ageSec=$null; at=$hb }
  }
}

function Add-CommandLine([string]$cmd) {
  $cmd = ($cmd ?? "").Trim()
  if (-not $cmd) { return }
  try {
    Invoke-WithMutexRetry -Name "Local\InfernalWheel_Commands" -TimeoutMs 1200 -Retries 10 -Script {
      Add-Content -Path $CmdFile -Value $cmd -Encoding UTF8
    } | Out-Null
    try { Add-LineSafe -Path $CmdSentLogPath -Line ("{0} | {1}" -f (NowStr), $cmd) } catch {}
  } catch {
    Write-ErrorLog -Path $DashLogPath -Context "Add-CommandLine" -Exception $_.Exception
  }
}

function Add-DrinkLog([string]$msg) {
  if (-not $msg) { return }
  try {
    Add-LineSafe -Path $DrinksLogPath -Line ("{0} | {1}" -f (NowStr), $msg) -MutexName "Local\InfernalWheel_DrinksLog"
  } catch {}
}

function Get-RecordsSafe {
  $r = Read-JsonSafe -Path $RecordsPath -BackupPath $RecordsBak
  if ($r -and -not ($r -is [hashtable])) {
    try {
      $r = $r | ConvertTo-Json -Depth 8 | ConvertFrom-Json -AsHashtable
    } catch {}
  }
  if (-not $r) {
    $r = @{
      clopeFromWake = @{ bestMin = 0; date = "" }
      beerFromWake  = @{ bestMin = 0; date = "" }
      alcoholSober  = @{ bestMin = 0; date = "" }
      clopeSober    = @{ bestMin = 0; date = "" }
      anyFromWake   = @{ bestMin = 0; date = "" }
    }
  }
  if (-not $r.clopeFromWake) { $r.clopeFromWake = @{ bestMin = 0; date = "" } }
  if ($null -eq $r.clopeFromWake.bestMin) { $r.clopeFromWake.bestMin = 0 }
  if ($null -eq $r.clopeFromWake.date) { $r.clopeFromWake.date = "" }
  if (-not $r.beerFromWake) { $r.beerFromWake = @{ bestMin = 0; date = "" } }
  if ($null -eq $r.beerFromWake.bestMin) { $r.beerFromWake.bestMin = 0 }
  if ($null -eq $r.beerFromWake.date) { $r.beerFromWake.date = "" }
  if (-not $r.alcoholSober) { $r.alcoholSober = @{ bestMin = 0; date = "" } }
  if ($null -eq $r.alcoholSober.bestMin) { $r.alcoholSober.bestMin = 0 }
  if ($null -eq $r.alcoholSober.date) { $r.alcoholSober.date = "" }
  if (-not $r.clopeSober) { $r.clopeSober = @{ bestMin = 0; date = "" } }
  if ($null -eq $r.clopeSober.bestMin) { $r.clopeSober.bestMin = 0 }
  if ($null -eq $r.clopeSober.date) { $r.clopeSober.date = "" }
  if (-not $r.anyFromWake) { $r.anyFromWake = @{ bestMin = 0; date = "" } }
  if ($null -eq $r.anyFromWake.bestMin) { $r.anyFromWake.bestMin = 0 }
  if ($null -eq $r.anyFromWake.date) { $r.anyFromWake.date = "" }
  return $r
}

function Save-RecordsSafe($records) {
  try {
    Write-JsonAtomic -Path $RecordsPath -Obj $records -BackupPath $RecordsBak -MutexName "Local\InfernalWheel_Records"
  } catch {}
}

function ConvertTo-Minutes([int]$sec) {
  if ($sec -lt 0) { $sec = 0 }
  return [int][Math]::Round($sec / 60.0, 0)
}

function Read-CsvSafe {
  param(
    [Parameter(Mandatory)][string]$Path,
    [string]$MutexName = $null
  )
  try {
    if (-not (Test-Path $Path)) { return @() }
    $raw = ""
    if ($MutexName) {
      $raw = Invoke-WithMutexRetry -Name $MutexName -TimeoutMs 1200 -Retries 6 -Script {
        Read-TextSafe -Path $Path -Default ""
      }
    } else {
      $raw = Read-TextSafe -Path $Path -Default ""
    }
    if (-not $raw.Trim()) { return @() }
    return ($raw | ConvertFrom-Csv)
  } catch {
    return @()
  }
}

function Get-LogName($r) {
  try {
    if ($null -ne $r.PSObject.Properties["Name"] -and -not [string]::IsNullOrWhiteSpace([string]$r.Name)) {
      return [string]$r.Name
    }
    if ($null -ne $r.PSObject.Properties["Activity"] -and -not [string]::IsNullOrWhiteSpace([string]$r.Activity)) {
      return [string]$r.Activity
    }
  } catch {}
  return ""
}

function Read-LogRows {
  $rows = @()
  try {
    $raw = Invoke-WithMutexRetry -Name "Local\InfernalWheel_LogCsv" -TimeoutMs 1200 -Retries 6 -Script {
      Read-TextSafe -Path $LogPath -Default ""
    }
    if (-not $raw.Trim()) { return @() }
    $lines = $raw -split "`r?`n"
    foreach ($line in $lines) {
      if (-not $line) { continue }
      if ($line -like "Start,*") { continue }
      $parts = $line -split ","
      if ($parts.Count -lt 6) { continue }
      $start = $parts[0]
      $end = $parts[1]
      $p2 = $parts[2]
      $p3 = $parts[3]
      $p4 = $parts[4]
      $p5 = $parts[5]
      $isDate = ($p2 -match "^\d{4}-\d{2}-\d{2}$")
      if ($isDate) {
        # legacy: Start,End,InfernalDay,Activity,CountsAsWork,CountsAsSleep,(Note)
        $rows += [pscustomobject]@{
          Start = $start
          End = $end
          InfernalDay = $p2
          Name = $p3
          Activity = $p3
          CountsAsWork = $p4
          CountsAsSleep = $p5
        }
      } else {
        # current: Start,End,Name,CountsAsWork,CountsAsSleep,InfernalDay
        $rows += [pscustomobject]@{
          Start = $start
          End = $end
          Name = $p2
          Activity = $p2
          CountsAsWork = $p3
          CountsAsSleep = $p4
          InfernalDay = $p5
        }
      }
    }
  } catch {}
  return $rows
}

function Format-DurationShort([int]$sec) {
  if ($sec -lt 0) { $sec = 0 }
  if ($sec -le 0) { return "0m" }
  $m = [int][Math]::Ceiling($sec / 60.0)
  return ("{0}m" -f $m)
}

function Get-DayTimeline([string]$dayKey) {
  $items = @()
  if (-not (Test-Path $LogPath)) { return $items }
  $rows = Read-LogRows
  $dayStart = $null
  $dayEnd = $null
  try {
    $d = [datetime]::ParseExact($dayKey, "yyyy-MM-dd", $null)
    $dayStart = $d.AddHours(4)
    $dayEnd = $dayStart.AddDays(1)
  } catch {}
  foreach ($r in $rows) {
    try {
      $s = [datetime]::Parse($r.Start)
      $e = [datetime]::Parse($r.End)
      if ($e -le $s) { continue }
      $isSleep = ([string]$r.CountsAsSleep -eq "True")
      if ($r.InfernalDay -ne $dayKey) {
        if (-not $isSleep -or -not $dayStart -or -not $dayEnd) { continue }
        if ($e -le $dayStart -or $s -ge $dayEnd) { continue }
      }
      $dur = [int]($e-$s).TotalSeconds
      $items += [pscustomobject]@{
        Start=$s; End=$e; Name=(Get-LogName $r); DurSec=$dur;
        Work=([string]$r.CountsAsWork -eq "True"); Sleep=([string]$r.CountsAsSleep -eq "True")
      }
    } catch {}
  }
  return ($items | Sort-Object Start)
}

function Get-MonthRange([string]$ym) {
  $y, $m = $ym.Split("-") | ForEach-Object { [int]$_ }
  $first = Get-Date -Year $y -Month $m -Day 1 -Hour 0 -Minute 0 -Second 0
  $next  = $first.AddMonths(1)
  return @{ first=$first; next=$next }
}

function Get-DailyWorkSleep() {
  $out = @{}
  if (-not (Test-Path $LogPath)) { return $out }
  $rows = Read-LogRows
  foreach ($r in $rows) {
    try {
      $s = [datetime]::Parse($r.Start); $e = [datetime]::Parse($r.End)
      if ($e -le $s) { continue }
      $dk = [string]$r.InfernalDay
      if (-not $out.ContainsKey($dk)) { $out[$dk] = @{ work=0; sleep=0; clope=0 } }
      $dur = [int]($e-$s).TotalSeconds
      if ([string]$r.CountsAsWork -eq "True")  { $out[$dk].work += $dur }
      if ([string]$r.CountsAsSleep -eq "True") { $out[$dk].sleep += $dur }
      if ((Get-LogName $r) -eq "clope") { $out[$dk].clope += 1 }
    } catch {}
  }
  return $out
}

function Get-DailyAlcoholTotals([string]$dayKey) {
  $out = @{ wine=0; beer=0; strong=0 }
  if (-not (Test-Path $DrinksPath)) { return $out }
  $rows = Read-CsvSafe -Path $DrinksPath -MutexName "Local\InfernalWheel_Drinks"
  foreach ($r in $rows) {
    try {
      if ([string]$r.InfernalDay -ne $dayKey) { continue }
      $out.wine += [int]($r.Wine ?? 0)
      $out.beer += [int]($r.Beer ?? 0)
      $out.strong += [int]($r.Strong ?? 0)
    } catch {}
  }
  return $out
}

function Get-DailyAlcoholEvents([string]$dayKey) {
  $events = @()
  if (-not (Test-Path $DrinksPath)) { return $events }
  $rows = Read-CsvSafe -Path $DrinksPath -MutexName "Local\InfernalWheel_Drinks"
  foreach ($r in $rows) {
    try {
      if ([string]$r.InfernalDay -ne $dayKey) { continue }
      $at = [datetime]::Parse([string]$r.At)
      $count = [int]($r.Wine ?? 0) + [int]($r.Beer ?? 0) + [int]($r.Strong ?? 0)
      if ($count -lt 1) { $count = 1 }
      $events += [pscustomobject]@{ At=$at; Count=$count }
    } catch {}
  }
  return ($events | Sort-Object At)
}

function Get-RecentDrinkEntries([string]$dayKey, [int]$limit=5) {
  $out = @()
  if (-not (Test-Path $DrinksPath)) { return $out }
  $rows = Read-CsvSafe -Path $DrinksPath -MutexName "Local\InfernalWheel_Drinks"
  foreach ($r in $rows) {
    try {
      if ([string]$r.InfernalDay -ne $dayKey) { continue }
      $beer = [int]($r.Beer ?? 0)
      $wine = [int]($r.Wine ?? 0)
      $strong = [int]($r.Strong ?? 0)
      if (($beer + $wine + $strong) -le 0) { continue }
      $at = [datetime]::Parse([string]$r.At)
      $parts = @()
      if ($beer -gt 0) { $parts += ("B+{0}" -f $beer) }
      if ($wine -gt 0) { $parts += ("V+{0}" -f $wine) }
      if ($strong -gt 0) { $parts += ("AF+{0}" -f $strong) }
      $label = ($parts -join " ")
      $out += [pscustomobject]@{
        At = $at
        Label = $label
      }
    } catch {}
  }
  $items = $out | Sort-Object At -Descending | Select-Object -First $limit
  return ($items | ForEach-Object { [pscustomobject]@{ at=$_.At.ToString("HH:mm"); label=$_.Label } })
}

function Get-FirstActionTimeForDay([string]$dayKey, [string]$actionKey) {
  if (-not (Test-Path $LogPath)) { return $null }
  $rows = Read-LogRows
  $first = $null
  foreach ($r in $rows) {
    try {
      if ($r.InfernalDay -ne $dayKey) { continue }
      $name = (Get-LogName $r)
      if (-not $name) { continue }
      if ($name.ToLowerInvariant() -ne $actionKey.ToLowerInvariant()) { continue }
      $s = [datetime]::Parse([string]$r.Start)
      if (-not $first -or $s -lt $first) { $first = $s }
    } catch {}
  }
  return $first
}

function Get-FirstDrinkTimeForDay([string]$dayKey, [string]$kind) {
  if (-not (Test-Path $DrinksPath)) { return $null }
  $rows = Read-CsvSafe -Path $DrinksPath -MutexName "Local\InfernalWheel_Drinks"
  $first = $null
  $kind = ($kind ?? "").ToLowerInvariant()
  foreach ($r in $rows) {
    try {
      if ([string]$r.InfernalDay -ne $dayKey) { continue }
      $count = 0
      switch ($kind) {
        "beer"   { $count = [int]($r.Beer ?? 0) }
        "wine"   { $count = [int]($r.Wine ?? 0) }
        "strong" { $count = [int]($r.Strong ?? 0) }
        "any"    { $count = [int]($r.Wine ?? 0) + [int]($r.Beer ?? 0) + [int]($r.Strong ?? 0) }
        default  { $count = 0 }
      }
      if ($count -le 0) { continue }
      $at = [datetime]::Parse([string]$r.At)
      if (-not $first -or $at -lt $first) { $first = $at }
    } catch {}
  }
  return $first
}

function Get-LastDrinkTime([string]$kind) {
  if (-not (Test-Path $DrinksPath)) { return $null }
  $rows = Read-CsvSafe -Path $DrinksPath -MutexName "Local\InfernalWheel_Drinks"
  $last = $null
  $kind = ($kind ?? "").ToLowerInvariant()
  foreach ($r in $rows) {
    try {
      $count = 0
      switch ($kind) {
        "beer"   { $count = [int]($r.Beer ?? 0) }
        "wine"   { $count = [int]($r.Wine ?? 0) }
        "strong" { $count = [int]($r.Strong ?? 0) }
        "any"    { $count = [int]($r.Wine ?? 0) + [int]($r.Beer ?? 0) + [int]($r.Strong ?? 0) }
        default  { $count = 0 }
      }
      if ($count -le 0) { continue }
      $at = [datetime]::Parse([string]$r.At)
      if (-not $last -or $at -gt $last) { $last = $at }
    } catch {}
  }
  return $last
}

function Get-LastActionTime([string]$actionKey) {
  if (-not (Test-Path $LogPath)) { return $null }
  $rows = Read-LogRows
  $last = $null
  $key = ($actionKey ?? "").ToLowerInvariant()
  foreach ($r in $rows) {
    try {
      $name = Get-LogName $r
      if (-not $name) { continue }
      if ($name.ToLowerInvariant() -ne $key) { continue }
      $t = $null
      if ($r.End) { $t = [datetime]::Parse([string]$r.End) }
      elseif ($r.Start) { $t = [datetime]::Parse([string]$r.Start) }
      if ($t -and (-not $last -or $t -gt $last)) { $last = $t }
    } catch {}
  }
  return $last
}

function Get-SleepSecondsBetween([datetime]$from, [datetime]$to, $state = $null) {
  if (-not $from -or -not $to) { return 0 }
  if ($to -le $from) { return 0 }
  $total = 0
  $rows = Read-LogRows
  foreach ($r in $rows) {
    try {
      if ([string]$r.CountsAsSleep -ne "True") { continue }
      $s = [datetime]::Parse($r.Start)
      $e = [datetime]::Parse($r.End)
      if ($e -le $s) { continue }
      if ($e -le $from -or $s -ge $to) { continue }
      $os = if ($s -gt $from) { $s } else { $from }
      $oe = if ($e -lt $to) { $e } else { $to }
      if ($oe -gt $os) { $total += [int]($oe-$os).TotalSeconds }
    } catch {}
  }
  if ($state -and $state.Current -and [bool]($state.Current.IsSleep ?? $false)) {
    try {
      $cs = $state.Current.StartedAt
      if ($state.Current.DisplayStartedAt) { $cs = $state.Current.DisplayStartedAt }
      if ($cs) { $cs = [datetime]::Parse([string]$cs) }
      if ($cs -and $cs -lt $to -and $to -gt $from) {
        $os = if ($cs -gt $from) { $cs } else { $from }
        $oe = $to
        if ($oe -gt $os) { $total += [int]($oe-$os).TotalSeconds }
      }
    } catch {}
  }
  return $total
}

function Get-AwakeMinutesSince([datetime]$from, [datetime]$to, $state = $null) {
  if (-not $from -or -not $to) { return $null }
  if ($to -le $from) { return 0 }
  $totalSec = [int]($to - $from).TotalSeconds
  $sleepSec = Get-SleepSecondsBetween $from $to $state
  $awakeSec = [int][Math]::Max(0, $totalSec - $sleepSec)
  return [int][Math]::Round($awakeSec / 60.0, 0)
}

function Get-DayAgendaItems([string]$dayKey, $state) {
  $items = @()
  $dayStart = $null
  $dayEnd = $null
  try {
    $d = [datetime]::ParseExact($dayKey, "yyyy-MM-dd", $null)
    $dayStart = $d.AddHours(4)
    $dayEnd = $dayStart.AddDays(1)
  } catch {}
  $timeline = Get-DayTimeline $dayKey
  foreach ($it in $timeline) {
    $items += [pscustomobject]@{
      Start=$it.Start; End=$it.End; Name=$it.Name; DurSec=$it.DurSec;
      Work=$it.Work; Sleep=$it.Sleep; IsPoint=$false
    }
  }

  if ($state -and $state.Current -and $state.Current.Name) {
    $currName = [string]$state.Current.Name
    if ($currName -and $currName -ne "idle" -and $currName -ne "WAIT_OK") {
      try {
        $startAt = [datetime]::Parse($state.Current.StartedAt)
        $displayStart = $startAt
        if ($state.Current.DisplayStartedAt) {
          try {
            $ds = [datetime]::Parse($state.Current.DisplayStartedAt)
            if ($ds -lt $displayStart) { $displayStart = $ds }
          } catch {}
        }
        $dkCurr = Get-InfernalDayKey $startAt
        $endAt = Get-Date
        $overlaps = $false
        if ($dayStart -and $dayEnd) {
          if ($endAt -gt $dayStart -and $displayStart -lt $dayEnd) { $overlaps = $true }
        }
        $isSleep = [bool]($state.Current.IsSleep ?? $false)
        if ($dkCurr -eq $dayKey -or ($isSleep -and $overlaps)) {
          $items += [pscustomobject]@{
            Start=$displayStart; End=$endAt; Name=$currName; DurSec=[int]($endAt-$displayStart).TotalSeconds;
            Work=[bool]($state.Current.IsWork ?? $false); Sleep=$isSleep; IsPoint=$false
          }
        }
      } catch {}
    }
  }

  if ($state -and $state.Current -and [string]$state.Current.Name -eq "WAIT_OK") {
    try {
      $overSec = [int]($state.TotalOverrunSeconds ?? 0)
      $otStart = $null
      if ($state.Current.OvertimeStartedAt) { $otStart = [datetime]::Parse($state.Current.OvertimeStartedAt) }
      if ($otStart -and $overSec -gt 0) {
        $otKey = Get-InfernalDayKey $otStart
        if ($otKey -eq $dayKey) {
          $items += [pscustomobject]@{
            Start=$otStart; End=(Get-Date); Name="OVERTIME"; DurSec=$overSec; Work=$false; Sleep=$false; IsPoint=$false
          }
        }
      }
    } catch {}
  }

  foreach ($ev in (Get-DailyAlcoholEvents $dayKey)) {
    $items += [pscustomobject]@{
      Start=$ev.At; End=$ev.At; Name=("Alcool (+{0})" -f $ev.Count); DurSec=0; Work=$false; Sleep=$false; IsPoint=$true
    }
  }

  $items = $items | Sort-Object Start
  $merged = @()
  foreach ($it in $items) {
    if ($merged.Count -gt 0 -and $it.Sleep -and $merged[-1].Sleep) {
      $prev = $merged[-1]
      $gap = [int](($it.Start - $prev.End).TotalSeconds)
      if ($gap -le 120) {
        if ($it.End -gt $prev.End) { $prev.End = $it.End }
        $prev.DurSec = [int]($prev.End - $prev.Start).TotalSeconds
        $prev.Name = "sleep"
        $merged[$merged.Count - 1] = $prev
        continue
      }
    }
    $merged += $it
  }

  return $merged
}

function Get-DayTimelineHtml([string]$dayKey, $state) {
  $items = Get-DayAgendaItems $dayKey $state
  if ($items.Count -eq 0) {
    return "<div class='emptyState'><div class='emptyTitle'>Aucune action aujourd'hui</div><div class='emptyDesc'>Lance une action pour commencer l'agenda.</div><div class='emptyCta'>Astuce: clique sur WORK, DODO ou une action.</div></div>"
  }
  $actionSet = @{}
  foreach ($k in (Get-ActionKeys)) {
    $lk = [string]$k
    if ($lk) { $actionSet[$lk.ToLowerInvariant()] = $true }
  }

  # Build graphical timeline
  $hoursHtml = "<div class='timeline-hours'>"
  for ($h = 0; $h -lt 24; $h += 2) {
    $hoursHtml += "<span class='timeline-hour'>${h}h</span><span class='timeline-hour'></span>"
  }
  $hoursHtml += "</div>"

  $barsHtml = "<div class='timeline-bars'>"
  foreach ($it in $items) {
    if ($it.IsPoint) { continue }
    $tag = if ($it.Work) { "work" } elseif ($it.Sleep) { "sleep" } else { "break" }
    $actionClass = ""
    if (-not $it.Work -and -not $it.Sleep) {
      $nameKey = ([string]$it.Name).ToLowerInvariant()
      if ($actionSet.ContainsKey($nameKey)) { $actionClass = " action-$nameKey" }
    }
    # Calculate position as % of 24h
    $startMin = $it.Start.Hour * 60 + $it.Start.Minute
    $endMin = $it.End.Hour * 60 + $it.End.Minute
    if ($endMin -le $startMin) { $endMin = $startMin + 1 }
    $leftPct = [math]::Round(($startMin / 1440) * 100, 2)
    $widthPct = [math]::Round((($endMin - $startMin) / 1440) * 100, 2)
    if ($widthPct -lt 0.5) { $widthPct = 0.5 }
    $durMin = [int](ConvertTo-Minutes $it.DurSec)
    $label = if ($widthPct -gt 3) { $it.Name } else { "" }
    $title = "$($it.Name): $($it.Start.ToString('HH:mm'))-$($it.End.ToString('HH:mm')) (${durMin}m)"
    $barsHtml += "<div class='timeline-bar $tag$actionClass' style='left:${leftPct}%;width:${widthPct}%' title='$title'>"
    if ($label) { $barsHtml += "<span class='timeline-bar-label'>$label</span>" }
    $barsHtml += "</div>"
  }
  $barsHtml += "</div>"

  # Current time indicator
  $now = Get-Date
  $nowMin = $now.Hour * 60 + $now.Minute
  $nowPct = [math]::Round(($nowMin / 1440) * 100, 2)
  $nowStr = $now.ToString("HH:mm")
  $nowHtml = "<div class='timeline-now' style='left:${nowPct}%' title='Maintenant: $nowStr'></div>"

  $graphHtml = "<div class='timeline-graph'>$hoursHtml$barsHtml$nowHtml</div>"

  # Also keep text list below
  $listHtml = ""
  foreach ($it in $items) {
    if ($it.IsPoint) {
      $listHtml += "<div class='seg break'><div><b>$($it.Start.ToString('HH:mm')) - $($it.Name)</b></div></div>"
      continue
    }
    $tag = if ($it.Work) { "work" } elseif ($it.Sleep) { "sleep" } else { "break" }
    $actionClass = ""
    if (-not $it.Work -and -not $it.Sleep) {
      $nameKey = ([string]$it.Name).ToLowerInvariant()
      if ($actionSet.ContainsKey($nameKey)) { $actionClass = " action-$nameKey" }
    }
    $listHtml += "<div class='seg $tag$actionClass'><div><b>$($it.Name)</b></div><div class='muted'>$($it.Start.ToString('HH:mm')) -> $($it.End.ToString('HH:mm')) - $([int](ConvertTo-Minutes $it.DurSec))m</div></div>"
  }

  return $graphHtml + $listHtml
}

function Get-DailyActionCount([string]$dayKey, [string]$actionName) {
  $count = 0
  if (-not (Test-Path $LogPath)) { return $count }
  $rows = Read-LogRows
  foreach ($r in $rows) {
    try {
      if ([string]$r.InfernalDay -ne $dayKey) { continue }
      if ((Get-LogName $r) -eq $actionName) { $count++ }
    } catch {}
  }
  return $count
}

function Get-ActionLabelMap {
  $map = @{}
  try {
    $s = Invoke-WithMutexRetry -Name $M_SETTINGS -TimeoutMs 1200 -Retries 10 -Script {
      Read-JsonSafe -Path $SettingsPath -BackupPath $SettingsBak
    }
    foreach ($a in ($s.actions ?? @())) {
      $k = [string]($a.key ?? "")
      if (-not $k.Trim()) { continue }
      $label = [string]($a.label ?? $k)
      $map[$k] = $label
    }
  } catch {}
  return $map
}

function Get-ActionKeys {
  $keys = @()
  try {
    $s = Invoke-WithMutexRetry -Name $M_SETTINGS -TimeoutMs 1200 -Retries 10 -Script {
      Read-JsonSafe -Path $SettingsPath -BackupPath $SettingsBak
    }
    foreach ($a in ($s.actions ?? @())) {
      $k = [string]($a.key ?? "")
      if (-not $k.Trim()) { continue }
      $mode = [string]($a.mode ?? "break")
      if ($mode -ne "break") { continue }
      $keys += $k
    }
  } catch {}
  return ($keys | Sort-Object -Unique)
}

function Get-DailyActionDurationsAll {
  $out = @{}
  if (-not (Test-Path $LogPath)) { return $out }
  $rows = Read-LogRows
  foreach ($r in $rows) {
    try {
      if ([string]$r.CountsAsWork -eq "True") { continue }
      if ([string]$r.CountsAsSleep -eq "True") { continue }
      $name = Get-LogName $r
      if (-not $name) { continue }
      if ($name -eq "WAIT_OK") { continue }
      $s = [datetime]::Parse($r.Start)
      $e = [datetime]::Parse($r.End)
      if ($e -le $s) { $e = $s.AddSeconds(1) }
      $dk = $s.ToString("yyyy-MM-dd")
      if (-not $out.ContainsKey($dk)) { $out[$dk] = @{} }
      if (-not $out[$dk].ContainsKey($name)) { $out[$dk][$name] = 0 }
      $out[$dk][$name] += [int]($e-$s).TotalSeconds
    } catch {}
  }
  return $out
}

function Get-DailyActionDurationsForDay([string]$dayKey, $state) {
  $out = @{}
  $rows = Read-LogRows
  foreach ($r in $rows) {
    try {
      if ([string]$r.CountsAsWork -eq "True") { continue }
      if ([string]$r.CountsAsSleep -eq "True") { continue }
      $name = Get-LogName $r
      if (-not $name) { continue }
      if ($name -eq "WAIT_OK") { continue }
      $s = [datetime]::Parse($r.Start)
      $dk = $s.ToString("yyyy-MM-dd")
      if ($dk -ne $dayKey) { continue }
      $e = [datetime]::Parse($r.End)
      if ($e -le $s) { $e = $s.AddSeconds(1) }
      if (-not $out.ContainsKey($name)) { $out[$name] = 0 }
      $out[$name] += [int]($e-$s).TotalSeconds
    } catch {}
  }

  if ($state -and $state.Current -and $state.Current.Name) {
    $currName = [string]$state.Current.Name
    if ($currName -and $currName -ne "work" -and $currName -ne "sleep" -and $currName -ne "WAIT_OK" -and $currName -ne "idle") {
      try {
        $startAt = [datetime]::Parse($state.Current.StartedAt)
        $dkCurr = $startAt.ToString("yyyy-MM-dd")
        if ($dkCurr -eq $dayKey) {
          if (-not $out.ContainsKey($currName)) { $out[$currName] = 0 }
          $out[$currName] += [int][Math]::Max(0, ((Get-Date) - $startAt).TotalSeconds)
        }
      } catch {}
    }
  }
  return $out
}

function Get-NotePath([string]$dayKey) { return (Join-Path $NotesDir ("{0}.txt" -f $dayKey)) }

function Get-NoteContent([string]$dayKey) {
  $p = Get-NotePath $dayKey
  return (Invoke-WithMutexRetry -Name $M_NOTES -TimeoutMs 1200 -Retries 10 -Script {
    Read-TextSafe -Path $p -Default ""
  })
}

function Set-NoteContent([string]$dayKey, [string]$content) {
  $p = Get-NotePath $dayKey
  Write-TextAtomic -Path $p -Text ($content ?? "") -MutexName $M_NOTES
}

function Get-QuickNote {
  return (Read-TextSafe -Path $QuickNotePath -Default "")
}

function Set-QuickNote([string]$content) {
  Write-TextAtomic -Path $QuickNotePath -Text ($content ?? "") -MutexName "Local\InfernalWheel_QuickNote"
}

function Get-ActionNote {
  return (Read-TextSafe -Path $ActionNotePath -Default "")
}

function Set-ActionNote([string]$content) {
  Write-TextAtomic -Path $ActionNotePath -Text ($content ?? "") -MutexName "Local\InfernalWheel_ActionNote"
}

function Test-EngineMutexHeld {
  $m = $null
  try {
    $m = [System.Threading.Mutex]::new($false, "Local\InfernalWheel_Engine")
    try {
      if ($m.WaitOne(0)) {
        try { $m.ReleaseMutex() } catch {}
        return $false
      }
      return $true
    } catch [System.Threading.AbandonedMutexException] {
      try { $m.ReleaseMutex() } catch {}
      return $false
    }
  } finally {
    if ($m) { try { $m.Dispose() } catch {} }
  }
}

function Test-TimerRunning {
  if (Test-EngineMutexHeld) { return $true }
  if (-not (Test-Path $TimerPidPath)) { return $false }
  $raw = (Read-TextSafe -Path $TimerPidPath -Default "").Trim()
  if (-not $raw) { return $false }
  try {
    $p = Get-Process -Id ([int]$raw) -ErrorAction SilentlyContinue
    return $null -ne $p
  } catch {
    return $false
  }
}

function Stop-ByPidFile {
  param([Parameter(Mandatory)][string]$Path)
  try {
    if (-not (Test-Path $Path)) { return }
    $raw = (Read-TextSafe -Path $Path -Default "").Trim()
    if (-not $raw) { return }
    $procId = 0
    if (-not [int]::TryParse($raw, [ref]$procId)) { return }
    $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
    if ($proc) { Stop-Process -Id $proc.Id -Force }
  } catch {
    Write-ErrorLog -Path $DashLogPath -Context "Stop-ByPidFile" -Exception $_.Exception
  }
}

function Start-TimerIfStopped {
  if (Test-TimerRunning) { return }
  $timer = Join-Path $PSScriptRoot "InfernalWheel.ps1"
  if (-not (Test-Path $timer)) { return }
  $pwsh = Join-Path $PSHOME "pwsh.exe"
  if (-not (Test-Path $pwsh)) { $pwsh = "pwsh" }
  try {
    Start-Process $pwsh -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-File",$timer) -WindowStyle Hidden | Out-Null
  } catch {
    Write-ErrorLog -Path $DashLogPath -Context "Start-TimerIfStopped" -Exception $_.Exception
  }
}

function Restart-Timer {
  Stop-ByPidFile -Path $TimerPidPath
  Start-TimerIfStopped
}

function Start-HttpListenerFixed {
  param(
    [Parameter(Mandatory)][string]$HostAddr,
    [Parameter(Mandatory)][int]$Port
  )
  $listener = [System.Net.HttpListener]::new()
  $prefix = "http://{0}:{1}/" -f $HostAddr, $Port
  $listener.Prefixes.Clear()
  $listener.Prefixes.Add($prefix)
  $listener.Start()
  return @{ Listener = $listener; Port = $Port; Prefix = $prefix }
}

function ConvertTo-HttpBytes($s) { return [System.Text.Encoding]::UTF8.GetBytes($s) }

function Write-HttpResponse($ctx, [int]$status, [string]$type, [byte[]]$bytes) {
  $ctx.Response.StatusCode = $status
  $ctx.Response.ContentType = $type
  $ctx.Response.ContentLength64 = $bytes.Length
  $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  $ctx.Response.OutputStream.Close()
}

function Read-Body($ctx) {
  $sr = [System.IO.StreamReader]::new($ctx.Request.InputStream, $ctx.Request.ContentEncoding)
  $txt = $sr.ReadToEnd()
  $sr.Close()
  return $txt
}

function Get-LiveStatePayload() {
  $s = Read-StateSafe
  $hb = Get-HeartbeatStatus
  if (-not $s) {
    return @{
      ok = $false
      error = "state unavailable"
      heartbeat = $hb
    }
  }

  $now = Get-Date
  $startedAt = $null
  $endsAt = $null
  try {
    $startStr = $s.Current.StartedAt
    if ($s.Current.IsSleep -and $s.Current.DisplayStartedAt) { $startStr = $s.Current.DisplayStartedAt }
    if ($startStr) { $startedAt = [datetime]::Parse($startStr) }
  } catch {}
  try { if ($s.Current.EndsAt)    { $endsAt    = [datetime]::Parse($s.Current.EndsAt) } } catch {}

  $elapsed = if ($startedAt) { [int][Math]::Max(0, ($now-$startedAt).TotalSeconds) } else { 0 }
  $remain = $null
  if ($endsAt) { $remain = [int][Math]::Max(0, ($endsAt-$now).TotalSeconds) }
  if ($s.Current.Paused -and $null -ne $s.Current.PausedRemainSec) { $remain = [int]$s.Current.PausedRemainSec }

  $overtime = 0
  if ($s.Current.Name -eq "WAIT_OK" -and $s.Current.OvertimeStartedAt) {
    try {
      $ot = [datetime]::Parse($s.Current.OvertimeStartedAt)
      $overtime = [int][Math]::Max(0, ($now-$ot).TotalSeconds)
    } catch {}
  }

  $todayKey = Get-InfernalDayKey (Get-Date)
  $prevKey = Get-PrevDayKey $todayKey
  $actionsToday = Get-DailyActionDurationsForDay ((Get-Date).ToString("yyyy-MM-dd")) $s

  # Get yesterday's work for trend comparison
  $dailyWS = Get-DailyWorkSleep
  $yesterdayWorkSec = if ($dailyWS.ContainsKey($prevKey)) { [int]$dailyWS[$prevKey].work } else { 0 }
  $labels = Get-ActionLabelMap
  $list = @()
  foreach ($k in (Get-ActionKeys)) {
    $dur = 0
    if ($actionsToday.ContainsKey($k)) { $dur = [int]$actionsToday[$k] }
    $label = if ($labels.ContainsKey($k)) { $labels[$k] } else { $k }
    $list += [pscustomobject]@{ key=$k; label=$label; durSec=$dur }
  }

  $firstClopeAt = $null
  $prevClopeAt = $null
  $firstBeerAt = $null
  $prevBeerAt = $null
  $firstAnyAt = $null
  $prevAnyAt = $null
  $lastAnyAt = $null
  $lastClopeAt = $null
  $firstWakeAt = $null
  try { $firstClopeAt = Get-FirstActionTimeForDay $todayKey "clope" } catch {}
  try { $prevClopeAt = Get-FirstActionTimeForDay $prevKey "clope" } catch {}
  try { $firstBeerAt = Get-FirstDrinkTimeForDay $todayKey "beer" } catch {}
  try { $prevBeerAt = Get-FirstDrinkTimeForDay $prevKey "beer" } catch {}
  try { $firstAnyAt = Get-FirstDrinkTimeForDay $todayKey "any" } catch {}
  try { $prevAnyAt = Get-FirstDrinkTimeForDay $prevKey "any" } catch {}
  try { $lastAnyAt = Get-LastDrinkTime "any" } catch {}
  try { $lastClopeAt = Get-LastActionTime "clope" } catch {}
  try { $firstWakeAt = Get-FirstActionTimeForDay $todayKey "reveille" } catch {}
  $currName = ""
  $currStart = $null
  try {
    $currName = [string]($s.Current.Name ?? "")
    if ($currName -and $s.Current.StartedAt) { $currStart = [datetime]::Parse([string]$s.Current.StartedAt) }
    if ($currStart) {
      $currKey = Get-InfernalDayKey $currStart
      if ($currKey -eq $todayKey) {
        if ($currName -eq "reveille") {
          if (-not $firstWakeAt -or $currStart -lt $firstWakeAt) { $firstWakeAt = $currStart }
        }
        if ($currName -eq "clope") {
          if (-not $firstClopeAt -or $currStart -lt $firstClopeAt) { $firstClopeAt = $currStart }
        }
      }
    }
  } catch {}
  if ($currName -eq "clope") { $lastClopeAt = $now }

  $deltaClopeMin = $null
  $deltaBeerMin = $null
  $deltaAnyMin = $null
  if ($firstClopeAt -and $prevClopeAt) { $deltaClopeMin = (Get-TimeOfDayMinutes $firstClopeAt) - (Get-TimeOfDayMinutes $prevClopeAt) }
  if ($firstBeerAt -and $prevBeerAt) { $deltaBeerMin = (Get-TimeOfDayMinutes $firstBeerAt) - (Get-TimeOfDayMinutes $prevBeerAt) }
  if ($firstAnyAt -and $prevAnyAt) { $deltaAnyMin = (Get-TimeOfDayMinutes $firstAnyAt) - (Get-TimeOfDayMinutes $prevAnyAt) }
  $deltaClopeFromWakeMin = $null
  $deltaBeerFromWakeMin = $null
  $deltaAnyFromWakeMin = $null
  $sinceWakeMin = $null
  $soberMin = $null
  $soberClopeMin = $null
  if ($firstWakeAt) {
    $sinceWakeMin = [int][Math]::Round(($now - $firstWakeAt).TotalMinutes)
    if ($sinceWakeMin -lt 0) { $sinceWakeMin = $null }
    if ($firstClopeAt) {
      $deltaClopeFromWakeMin = [int][Math]::Round(($firstClopeAt - $firstWakeAt).TotalMinutes)
      if ($deltaClopeFromWakeMin -lt 0) { $deltaClopeFromWakeMin = $null }
    }
    if ($firstBeerAt) {
      $deltaBeerFromWakeMin = [int][Math]::Round(($firstBeerAt - $firstWakeAt).TotalMinutes)
      if ($deltaBeerFromWakeMin -lt 0) { $deltaBeerFromWakeMin = $null }
    }
    if ($firstAnyAt) {
      $deltaAnyFromWakeMin = [int][Math]::Round(($firstAnyAt - $firstWakeAt).TotalMinutes)
      if ($deltaAnyFromWakeMin -lt 0) { $deltaAnyFromWakeMin = $null }
    }
  }
  if ($lastAnyAt) {
    $soberMin = Get-AwakeMinutesSince $lastAnyAt $now $s
    if ($soberMin -lt 0) { $soberMin = 0 }
  }
  if ($lastClopeAt) {
    $soberClopeMin = Get-AwakeMinutesSince $lastClopeAt $now $s
    if ($soberClopeMin -lt 0) { $soberClopeMin = 0 }
  }
  $records = Get-RecordsSafe
  $recordsDirty = $false
  if ($null -ne $deltaClopeFromWakeMin) {
    $bestC = [int]($records.clopeFromWake.bestMin ?? 0)
    if ($deltaClopeFromWakeMin -gt $bestC) {
      $records.clopeFromWake.bestMin = $deltaClopeFromWakeMin
      $records.clopeFromWake.date = $todayKey
      $recordsDirty = $true
    }
  }
  if ($null -ne $deltaBeerFromWakeMin) {
    $bestB = [int]($records.beerFromWake.bestMin ?? 0)
    if ($deltaBeerFromWakeMin -gt $bestB) {
      $records.beerFromWake.bestMin = $deltaBeerFromWakeMin
      $records.beerFromWake.date = $todayKey
      $recordsDirty = $true
    }
  }
  if ($null -ne $deltaAnyFromWakeMin) {
    $bestA = [int]($records.anyFromWake.bestMin ?? 0)
    if ($deltaAnyFromWakeMin -gt $bestA) {
      $records.anyFromWake.bestMin = $deltaAnyFromWakeMin
      $records.anyFromWake.date = $todayKey
      $recordsDirty = $true
    }
  }
  if ($null -ne $soberMin) {
    $bestS = [int]($records.alcoholSober.bestMin ?? 0)
    if ($soberMin -gt $bestS) {
      $records.alcoholSober.bestMin = $soberMin
      $records.alcoholSober.date = $todayKey
      $recordsDirty = $true
    }
  }
  if ($null -ne $soberClopeMin) {
    $bestCS = [int]($records.clopeSober.bestMin ?? 0)
    if ($soberClopeMin -gt $bestCS) {
      $records.clopeSober.bestMin = $soberClopeMin
      $records.clopeSober.date = $todayKey
      $recordsDirty = $true
    }
  }
  if ($recordsDirty) { Save-RecordsSafe $records }
  $recentDrinks = @()
  try { $recentDrinks = Get-RecentDrinkEntries $todayKey 5 } catch {}

  return @{
    ok = $true
    heartbeat = $hb
    currentName = [string]($s.Current.Name ?? "idle")
    awaitOk = [bool]($s.Engine.AwaitOk ?? $false)
    paused = [bool]($s.Current.Paused ?? $false)
    resumeDetected = [bool]($s.Engine.ResumeDetected ?? $false)
    elapsedSec = $elapsed
    remainSec = $remain
    overtimeSec = $overtime

    goalWorkSec = [int]($s.GoalWorkSeconds ?? 500*3600)
    totalWorkSec = [int]($s.TotalWorkSeconds ?? 0)
    totalOverrunSec = [int]($s.TotalOverrunSeconds ?? 0)
    totalBreakSec = [int]($s.TotalBreakSeconds ?? 0)
    yesterdayWorkSec = $yesterdayWorkSec
    remWorkSec = [int][Math]::Max(0, ([int]($s.GoalWorkSeconds ?? 500*3600)) - ([int]($s.TotalWorkSeconds ?? 0) + [int]($s.TotalOverrunSeconds ?? 0)))
    dailyCigCount = [int]($s.DayClopeCount ?? 0)
    dailyClopeSec = $displayClopeSec
    firsts = @{
      clope = if ($firstClopeAt) { $firstClopeAt.ToString("HH:mm") } else { "" }
      beer  = if ($firstBeerAt) { $firstBeerAt.ToString("HH:mm") } else { "" }
      any   = if ($firstAnyAt) { $firstAnyAt.ToString("HH:mm") } else { "" }
      wake  = if ($firstWakeAt) { $firstWakeAt.ToString("HH:mm") } else { "" }
      deltaClopeMin = $deltaClopeMin
      deltaBeerMin = $deltaBeerMin
      deltaAnyMin = $deltaAnyMin
      deltaClopeFromWakeMin = $deltaClopeFromWakeMin
      deltaBeerFromWakeMin = $deltaBeerFromWakeMin
      deltaAnyFromWakeMin = $deltaAnyFromWakeMin
      sinceWakeMin = $sinceWakeMin
      soberMin = $soberMin
      bestClopeFromWakeMin = [int]($records.clopeFromWake.bestMin ?? 0)
      bestClopeDate = [string]($records.clopeFromWake.date ?? "")
      bestBeerFromWakeMin = [int]($records.beerFromWake.bestMin ?? 0)
      bestBeerDate = [string]($records.beerFromWake.date ?? "")
      bestAnyFromWakeMin = [int]($records.anyFromWake.bestMin ?? 0)
      bestAnyDate = [string]($records.anyFromWake.date ?? "")
      bestSoberMin = [int]($records.alcoholSober.bestMin ?? 0)
      bestSoberDate = [string]($records.alcoholSober.date ?? "")
      soberClopeMin = $soberClopeMin
      bestClopeSoberMin = [int]($records.clopeSober.bestMin ?? 0)
      bestClopeSoberDate = [string]($records.clopeSober.date ?? "")
    }
    recentDrinks = $recentDrinks
    timelineHtml = (Get-DayTimelineHtml $todayKey $s)
    dailyActions = $list
  }
}
