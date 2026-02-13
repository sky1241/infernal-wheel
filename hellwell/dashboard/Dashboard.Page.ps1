function New-PageHtml([string]$ym) {
  $now = Get-Date
  $todayKey = Get-InfernalDayKey $now
  $todayCalKey = $now.ToString("yyyy-MM-dd")
  if (-not $ym) { $ym = $now.ToString("yyyy-MM") }

  $state = Read-StateSafe
  $hb = Get-HeartbeatStatus

  $goalSec = if ($state -and $state.GoalWorkSeconds) { [int]$state.GoalWorkSeconds } else { 500*3600 }
  $workSec = if ($state -and $null -ne $state.TotalWorkSeconds) { [int]$state.TotalWorkSeconds } else { 0 }
  $overSec = if ($state -and $null -ne $state.TotalOverrunSeconds) { [int]$state.TotalOverrunSeconds } else { 0 }
  $doneSec = $workSec + $overSec
  $remSec  = [int][Math]::Max(0, $goalSec - $doneSec)

  $daily = Get-DailyWorkSleep
  $dailyActions = Get-DailyActionDurationsAll
  $labelMap = Get-ActionLabelMap
  $actionKeys = Get-ActionKeys
  $todayActions = Get-DailyActionDurationsForDay $todayCalKey $state
  $mr = Get-MonthRange $ym
  $first=$mr.first; $next=$mr.next

  $startWeekday = ([int]$first.DayOfWeek + 6) % 7
  $daysInMonth = [DateTime]::DaysInMonth($first.Year, $first.Month)

  # [WEB.md] Jours de la semaine pour attribut data-weekday (mobile)
  $weekdayNames = @("Lun","Mar","Mer","Jeu","Ven","Sam","Dim")

  $rowsHtml = ""
  $week = ""
  for ($i=0; $i -lt $startWeekday; $i++) {
    $week += "<td class='day muted empty' aria-hidden='true'></td>"
  }
  for ($day=1; $day -le $daysInMonth; $day++) {
    $d = Get-Date -Year $first.Year -Month $first.Month -Day $day -Hour 0 -Minute 0 -Second 0
    $dk = $d.ToString("yyyy-MM-dd")
    # [WEB.md §29] Calcul du jour de semaine pour data-weekday
    $weekdayIdx = ([int]$d.DayOfWeek + 6) % 7
    $weekdayName = $weekdayNames[$weekdayIdx]
    $ws = if ($daily.ContainsKey($dk)) { $daily[$dk] } else { @{work=0;sleep=0;clope=0} }
    $da = Get-DailyAlcoholTotals $dk

    # === CLEAN CELL DESIGN ===
    $workMin = [int](ConvertTo-Minutes $ws.work)
    $sleepMin = [int](ConvertTo-Minutes $ws.sleep)

    # Alcohol - 1 seul badge, tous les emojis dedans, va dans header
    $alcBadge = ""
    $alcParts = @()
    if ($da.wine -gt 0) { $alcParts += "&#127863;$($da.wine)" }
    if ($da.beer -gt 0) { $alcParts += "&#127866;$($da.beer)" }
    if ($da.strong -gt 0) { $alcParts += "<svg class='dm-whisky' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M4 4 L4 20 Q4 22 6 22 L18 22 Q20 22 20 20 L20 4 Z' fill='rgba(255,255,255,.08)' stroke='rgba(255,255,255,.4)' stroke-width='1.2'/><path d='M5 14 L5 20 Q5 21 6 21 L18 21 Q19 21 19 20 L19 14 Z' fill='#c17f24'/><rect x='5.5' y='6' width='7' height='9' rx='1.5' fill='#a8e0f0'/><rect x='11' y='8' width='7' height='8' rx='1.5' fill='#8ed0e8'/><path d='M6 7 L11.5 7 L11 12 L6.5 12 Z' fill='rgba(255,255,255,.55)'/><path d='M11.5 9 L17 9 L16.5 14 L12 14 Z' fill='rgba(255,255,255,.45)'/></svg>$($da.strong)" }
    if ($alcParts.Count -gt 0) {
      $alcBadge = "<span class='dm dm--alc'>" + ($alcParts -join " ") + "</span>"
    }

    # === LABELS + COMBINED BAR ===
    $maxRef = 720  # 12h = 100%

    # Labels row: 💻 Xh Ym (left) ... 😴 Xh Ym (right)
    $labelsHtml = ""
    $wDisp = ""; $sDisp = ""
    if ($workMin -gt 0) {
      $wH = [Math]::Floor($workMin / 60)
      $wM = $workMin % 60
      $wDisp = if ($wH -gt 0) { "${wH}h$(if($wM -gt 0){"$wM"})" } else { "${workMin}m" }
    }
    if ($sleepMin -gt 0) {
      $sH = [Math]::Floor($sleepMin / 60)
      $sM = $sleepMin % 60
      $sDisp = if ($sH -gt 0) { "${sH}h$(if($sM -gt 0){"$sM"})" } else { "${sleepMin}m" }
    }
    if ($workMin -gt 0 -or $sleepMin -gt 0) {
      $leftLabel = if ($workMin -gt 0) { "<span class='dlbl dlbl--work'>&#128187;$wDisp</span>" } else { "" }
      $rightLabel = if ($sleepMin -gt 0) { "<span class='dlbl dlbl--sleep'>&#127769;$sDisp</span>" } else { "" }
      $labelsHtml = "<div class='dlabels'>$leftLabel$rightLabel</div>"
    }

    # Combined bar
    $barHtml = ""
    if ($workMin -gt 0 -or $sleepMin -gt 0) {
      $wRaw = if ($workMin -gt 0) { [Math]::Round(($workMin / $maxRef) * 100) } else { 0 }
      $sRaw = if ($sleepMin -gt 0) { [Math]::Round(($sleepMin / $maxRef) * 100) } else { 0 }
      $total = $wRaw + $sRaw
      if ($total -gt 100) { $wPct = [Math]::Round($wRaw * 100 / $total); $sPct = 100 - $wPct }
      else { $wPct = $wRaw; $sPct = $sRaw }
      $barHtml = "<div class='dbar'>"
      if ($wPct -gt 0) { $barHtml += "<div class='dbar-seg dbar--work' style='width:${wPct}%'></div>" }
      if ($sPct -gt 0) { $barHtml += "<div class='dbar-seg dbar--sleep' style='width:${sPct}%'></div>" }
      $barHtml += "</div>"
    }

    # Clopes + Activities
    $clopeCount = [int]($ws.clope ?? 0)
    if ($dk -eq $todayKey) {
      if ($state -and $null -ne $state.DayClopeCount) {
        $clopeCount = [Math]::Max($clopeCount, [int]$state.DayClopeCount)
      }
      if ($state -and $state.Current -and [string]$state.Current.Name -eq "clope") {
        $clopeCount++
      }
    }
    $actsCount = 0
    $actsDetails = ""
    foreach ($k in $actionKeys) {
      $label = if ($labelMap.ContainsKey($k)) { $labelMap[$k] } else { $k }
      $durSec = 0
      if ($dk -eq $todayCalKey) {
        if ($todayActions.ContainsKey($k)) { $durSec = [int]$todayActions[$k] }
      } elseif ($dailyActions.ContainsKey($dk) -and $dailyActions[$dk].ContainsKey($k)) {
        $durSec = [int]$dailyActions[$dk][$k]
      }
      if ($durSec -gt 0) {
        $actsCount++
        $dur = Format-DurationShort $durSec
        $actsDetails += "<div class='dact-item'><span class='dact-name'>$label</span><span class='dact-dur'>$dur</span></div>"
      }
    }
    $botLeft = ""
    $botRight = ""
    if ($clopeCount -gt 0) { $botLeft = "<span class='dbot dbot--clope'>&#128684;$clopeCount</span>" }
    if ($actsCount -gt 0) { $botRight = "<span class='dbot dbot--acts dacts'><span class='dacts-toggle'>${actsCount}act</span><div class='dacts-details'>$actsDetails</div></span>" }

    # ARIA + today class
    $ariaLabel = "$day $($d.ToString('MMMM'))"
    $todayClass = if ($dk -eq $todayCalKey) { " today" } else { "" }

    # === BUILD CELL ===
    $cellHtml = "<td class='day$todayClass' data-weekday='$weekdayName' aria-label='$ariaLabel'>"
    $cellHtml += "<div class='dcell'>"
    $cellHtml += "<div class='dhead'><span class='dnum'>$($d.Day)</span>$alcBadge</div>"
    $cellHtml += $labelsHtml
    $cellHtml += $barHtml
    $cellHtml += "<div class='dbottom'>$botLeft<a class='dnote' href='/notes?d=$dk' aria-label='Notes du $day' title='Notes'>&#128221;</a>$botRight</div>"
    $cellHtml += "</div>"
    $cellHtml += "</td>"
    $week += $cellHtml
    $cells = $startWeekday + $day
    if (($cells % 7) -eq 0) {
      $rowsHtml += "<tr>$week</tr>"
      $week = ""
    }
  }
  if ($week -ne "") {
    $cellsInLastRow = ($startWeekday + $daysInMonth) % 7
    $pad = 0
    if ($cellsInLastRow -ne 0) { $pad = 7 - $cellsInLastRow }
    for ($i=0; $i -lt $pad; $i++) { $week += "<td class='day muted empty' aria-hidden='true'></td>" }
    $rowsHtml += "<tr>$week</tr>"
  }

  $timelineHtml = Get-DayTimelineHtml $todayKey $state

  $actionsTodayHtml = ""
  if ($actionKeys.Count -gt 0) {
    $actionsTodayHtml = "<div class='seg break'><div><b>Actions (jour)</b></div><div class='actionList'>"
    foreach ($k in $actionKeys) {
      $label = if ($labelMap.ContainsKey($k)) { $labelMap[$k] } else { $k }
      $durSec = 0
      if ($todayActions.ContainsKey($k)) { $durSec = [int]$todayActions[$k] }
      $min = if ($durSec -gt 0) { [int][Math]::Ceiling($durSec / 60.0) } else { 0 }
      $actionsTodayHtml += "<div class='chip'><span class='chipLabel'>${label}</span><span class='chipValue'>${min}m</span></div>"
    }
    $actionsTodayHtml += "</div></div>"
  }


  $monthly = Get-MonthlyAlcoholTotals $ym
  $wineUnit = $WINE_L.ToString("0.##")
  $beerUnit = $BEER_L.ToString("0.##")
  $strongUnit = $STRONG_L.ToString("0.##")
  $wineBottle = $WINE_BOTTLE_L.ToString("0.##")
  $strongBottle = $STRONG_BOTTLE_L.ToString("0.##")
  $weeks = Get-WeeklyAlcoholLiters | Sort-Object WeekKey -Descending
  $weeksTail = @($weeks)  # All weeks - scroll handles visibility
  $weeksHtml = ""
  if ($weeksTail.Count -eq 0) {
    $weeksHtml = "<div class='muted'>Aucune entree.</div>"
  } else {
    $whiskySvg = "<svg class='whisky-icon' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg' aria-hidden='true'><path d='M4 4 L4 20 Q4 22 6 22 L18 22 Q20 22 20 20 L20 4 Z' fill='rgba(255,255,255,.08)' stroke='rgba(255,255,255,.4)' stroke-width='1.2'/><rect x='4' y='20' width='16' height='2' rx='0.5' fill='rgba(255,255,255,.15)'/><path d='M5 14 L5 20 Q5 21 6 21 L18 21 Q19 21 19 20 L19 14 Z' fill='#c17f24'/><rect x='5.5' y='6' width='7' height='9' rx='1.5' fill='#a8e0f0'/><rect x='11' y='8' width='7' height='8' rx='1.5' fill='#8ed0e8'/><path d='M6 7 L11.5 7 L11 12 L6.5 12 Z' fill='rgba(255,255,255,.55)'/><path d='M11.5 9 L17 9 L16.5 14 L12 14 Z' fill='rgba(255,255,255,.45)'/></svg>"
    $beerChip = "<div class='alcUnitChip alcUnitChip--beer alcUnitChip--header'><span class='alcUnitChip__icon' aria-hidden='true'>&#127866;</span><div class='alcUnitChip__content'><span class='alcUnitChip__label'>Bi&egrave;re</span><span class='alcUnitChip__value'>1 can. = __BEER_UNIT__ L</span></div></div>"
    $wineChip = "<div class='alcUnitChip alcUnitChip--wine alcUnitChip--header'><span class='alcUnitChip__icon' aria-hidden='true'>&#127863;</span><div class='alcUnitChip__content'><span class='alcUnitChip__label'>Vin</span><span class='alcUnitChip__value'>1 verre = __WINE_UNIT__ L</span></div></div>"
    $strongChip = "<div class='alcUnitChip alcUnitChip--strong alcUnitChip--header'>$whiskySvg<div class='alcUnitChip__content'><span class='alcUnitChip__label'>Fort</span><span class='alcUnitChip__value'>1 verre = __STRONG_UNIT__ L</span></div></div>"
    $pureChip = "<div class='alcUnitChip alcUnitChip--pure alcUnitChip--header'><span class='alcUnitChip__icon' aria-hidden='true'>&#128167;</span><div class='alcUnitChip__content'><span class='alcUnitChip__label'>Pure</span><span class='alcUnitChip__value'>alcool pur (g)</span></div></div>"
    # Header OUTSIDE scroll, data rows INSIDE scroll
    $weeksHtml = "<div class='weeksWrap'>"
    $weeksHtml += "<div class='weeksTableHeader'><div class='weekLine headLine'><div class='weekRow head'><div class='weekCell'>Semaine</div><div class='weekCell'>P&eacute;riode</div><div class='weekCell num'>$beerChip</div><div class='weekCell num'>$wineChip</div><div class='weekCell num'>$strongChip</div><div class='weekCell num doseHead'>$pureChip</div></div><div class='weekDelta headDelta'></div></div></div>"
    $weeksHtml += "<div class='weeksTableScroll'><div class='weeksTable'>"
    $i = 0
    foreach ($w in $weeksTail) {
      $range = if ($w.WeekRange) { $w.WeekRange } else { "-" }
      $deltaVal = $null
      try { $deltaVal = [double]$w.DeltaPure } catch { $deltaVal = $null }
      $deltaLabel = ""
      $deltaStyle = ""
      $deltaArrow = ""
      if ($null -ne $deltaVal) {
        if ($deltaVal -gt 0) {
          $deltaLabel = "+" + $deltaVal.ToString("0.###")
          $score = 5 + ([Math]::Min([Math]::Abs($deltaVal), 0.5) / 0.5 * 5)
          $hue = [Math]::Round(120 - (($score - 1) * 13.33))
          $deltaStyle = "style=`"color:hsl($hue,85%,55%);border-color:hsl($hue,70%,40%);background:hsla($hue,80%,50%,.12)`""
          $deltaArrow = "<span class='trend-arrow' aria-label='augmentation'>&#8593;</span>"
        }
        elseif ($deltaVal -lt 0) {
          $deltaLabel = $deltaVal.ToString("0.###")
          $score = 5 - ([Math]::Min([Math]::Abs($deltaVal), 0.5) / 0.5 * 4)
          $hue = [Math]::Round(120 - (($score - 1) * 13.33))
          $deltaStyle = "style=`"color:hsl($hue,85%,55%);border-color:hsl($hue,70%,40%);background:hsla($hue,80%,50%,.12)`""
          $deltaArrow = "<span class='trend-arrow' aria-label='diminution'>&#8595;</span>"
        }
      }
      $isOlder = ($i -ge 1)
      $rowClass = if ($isOlder) { "weekRow" } else { "weekRow currentWeek" }
      $cellClass = if ($isOlder) { "weekCell olderWeek" } else { "weekCell" }
      $cellNumClass = if ($isOlder) { "weekCell num olderWeek" } else { "weekCell num" }
      $cellDoseClass = if ($isOlder) { "weekCell num doseCell olderWeek" } else { "weekCell num doseCell" }

      # Calculate trend colors + arrows by comparing with previous week (next row = older week)
      # Score 1-10: 1=green (decrease), 5=yellow (neutral), 10=red (increase)
      # HSL: hue = 120 - (score-1)*13.33 → green(120) → yellow(60) → red(0)
      # WCAG 1.4.1: arrows ↓/↑ for colorblind accessibility
      function Get-Trend($curr, $prev, $maxDelta) {
        $result = @{ Style = ""; Arrow = "" }
        if ($null -eq $prev -or $prev -eq 0) { return $result }
        $delta = $curr - $prev
        if ($delta -eq 0) { return $result }
        # Normalize delta to score 1-10, clamped
        $normalized = $delta / $maxDelta  # -1 to +1 range (approx)
        $score = 5 + ($normalized * 5)
        $score = [Math]::Max(1, [Math]::Min(10, $score))
        # Calculate HSL hue: score 1→120°(green), 5→60°(yellow), 10→0°(red)
        $hue = [Math]::Round(120 - (($score - 1) * 13.33))
        $result.Style = "style=`"color:hsl($hue,85%,55%)`""
        $result.Arrow = if ($delta -lt 0) { "<span class='trend-arrow' aria-label='diminution'>&#8595;</span>" } else { "<span class='trend-arrow' aria-label='augmentation'>&#8593;</span>" }
        return $result
      }

      $beerTrend = @{ Style = ""; Arrow = "" }; $wineTrend = @{ Style = ""; Arrow = "" }
      $strongTrend = @{ Style = ""; Arrow = "" }; $doseTrend = @{ Style = ""; Arrow = "" }
      if ($i -lt ($weeksTail.Count - 1)) {
        $prev = $weeksTail[$i + 1]
        $currBeer = 0; $prevBeer = 0
        try { $currBeer = [double]$w.BeerCans } catch {}
        try { $prevBeer = [double]$prev.BeerCans } catch {}
        $beerTrend = Get-Trend $currBeer $prevBeer 5

        $currWine = 0; $prevWine = 0
        try { $currWine = [double]$w.WineGlasses } catch {}
        try { $prevWine = [double]$prev.WineGlasses } catch {}
        $wineTrend = Get-Trend $currWine $prevWine 5

        $currStrong = 0; $prevStrong = 0
        try { $currStrong = [double]$w.StrongGlasses } catch {}
        try { $prevStrong = [double]$prev.StrongGlasses } catch {}
        $strongTrend = Get-Trend $currStrong $prevStrong 5

        $currDose = 0; $prevDose = 0
        try { $currDose = [double]$w.PureLiters } catch {}
        try { $prevDose = [double]$prev.PureLiters } catch {}
        $doseTrend = Get-Trend $currDose $prevDose 0.5
      }

      $deltaClass = if ($deltaLabel -eq "") { "weekDelta weekDelta--empty" } else { "weekDelta" }
      $weeksHtml += "<div class='weekLine'><div class='$rowClass'><div class='$cellClass'>$($w.WeekKey)</div><div class='$cellClass'>$range</div><div class='$cellNumClass'><span class='wkCount' $($beerTrend.Style)>$($w.BeerCans)$($beerTrend.Arrow)</span></div><div class='$cellNumClass'><span class='wkCount' $($wineTrend.Style)>$($w.WineGlasses)$($wineTrend.Arrow)</span></div><div class='$cellNumClass'><span class='wkCount' $($strongTrend.Style)>$($w.StrongGlasses)$($strongTrend.Arrow)</span></div><div class='$cellDoseClass'><span class='doseBox' $($doseTrend.Style)>$($w.PureLiters)$($doseTrend.Arrow)</span></div></div><div class='$deltaClass' $deltaStyle>$deltaLabel$deltaArrow</div></div>"
      $i++
    }
    $weeksHtml += "</div></div></div>"  # Close weeksTable + weeksTableScroll + weeksWrap
  }

  $hbClass = if ($hb.status -eq "ONLINE") { "online" } elseif ($hb.status -eq "STALE") { "stale" } else { "offline" }

  $tpl = @'
<!doctype html>
<html>
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>InfernalWheel</title>
<style>
:root{
  --bg:#0e1319; --panel:#121820; --panel-2:#141c25; --border:#24303c;
  --text:#e7edf3; --muted:#a7b3bf;
  --accent:#35d99a; --blue:#6bbcff; --warn:#f7bf54; --danger:#ff7a7a;
  /* [WEB] card radius 8px, shadow lighter */
  --shadow:0 1px 3px rgba(0,0,0,.1); --r:8px;
  --week-gap:8px;
  /* [UX_SPACING_PDF] Système d'espacement basé sur 4px */
  --sp-4:4px; --sp-8:8px; --sp-12:12px; --sp-16:16px;
  --sp-20:20px; --sp-24:24px; --sp-32:32px; --sp-48:48px;
  /* [UX_TIMING_PDF] Transitions standardisées */
  --transition-fast:150ms; --transition-normal:200ms; --transition-slow:300ms;
}
*{box-sizing:border-box}
/* [text_resize_200_wcag_1_4_4] base 16px pour rem */
html{font-size:100%}
body{
  /* [WEB] system-ui font stack for performance */
  margin:1rem; font-family:system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; color:var(--text);
  font-variant-numeric:lining-nums tabular-nums;
  font-feature-settings:"lnum" 1, "tnum" 1;
  /* [text_spacing_override_wcag_1_4_12] line-height >=1.5 */
  line-height:1.5;
  background:
    radial-gradient(900px 460px at 8% -12%, rgba(38,211,140,.12), transparent 60%),
    radial-gradient(820px 540px at 92% -12%, rgba(91,178,255,.12), transparent 55%),
    repeating-linear-gradient(90deg, rgba(255,255,255,.02) 0 1px, transparent 1px 28px),
    repeating-linear-gradient(180deg, rgba(255,255,255,.018) 0 1px, transparent 1px 28px),
    var(--bg);
}
a{color:var(--blue); text-decoration:none} a:hover{text-decoration:underline}
.container{max-width:1200px; margin:0 auto}
.topbar{
  /* [UX_PDF] Compact topbar - single row */
  display:flex; justify-content:space-between; align-items:center; gap:var(--sp-12);
  padding:var(--sp-8) var(--sp-16); margin-bottom:var(--sp-16);
  border:1px solid rgba(255,255,255,.08); border-radius:var(--r);
  background:rgba(18,24,32,.85);
  backdrop-filter:blur(12px); -webkit-backdrop-filter:blur(12px);
  position:sticky; top:var(--sp-8); z-index:1200;
  min-height:44px;
}
.brand{display:flex; align-items:center; gap:var(--sp-8); font-weight:700; font-size:.875rem; color:var(--text)}
/* [UX_PDF] Heartbeat indicator dot with pulse */
.hb-dot{
  width:10px; height:10px; border-radius:50%; flex-shrink:0;
  background:var(--danger);
  box-shadow:0 0 6px currentColor;
}
.hb-dot.online{
  background:var(--accent);
  box-shadow:0 0 8px rgba(53,217,154,.6);
  animation:hbPulse 2s ease-in-out infinite;
}
.hb-dot.stale{background:var(--warn); box-shadow:0 0 8px rgba(247,191,84,.5)}
.hb-dot.offline{
  background:var(--danger);
  box-shadow:0 0 10px rgba(255,122,122,.7);
  animation:hbOffline 1s ease-in-out infinite;
}
@keyframes hbPulse{
  0%,100%{box-shadow:0 0 8px rgba(53,217,154,.5)}
  50%{box-shadow:0 0 14px rgba(53,217,154,.8)}
}
@keyframes hbOffline{
  0%,100%{opacity:1}
  50%{opacity:.5}
}
/* [UX_PDF] Compact tag - smaller than pill */
.tag{
  padding:var(--sp-4) var(--sp-8); border-radius:var(--sp-4);
  background:rgba(255,255,255,.06); color:var(--muted);
  font-size:.75rem; font-weight:500; letter-spacing:.3px;
  display:inline-flex; align-items:center; gap:var(--sp-4);
}
.tag.accent{background:rgba(53,217,154,.12); color:var(--accent)}
/* Nav links row */
.nav-links{display:flex; align-items:center; gap:var(--sp-8)}
/* [UX_PDF] Secondary nav - visible but not competing with primary */
.nav-link{
  padding:var(--sp-4) var(--sp-8); border-radius:var(--sp-4);
  color:var(--muted); font-size:.75rem; font-weight:500;
  text-decoration:none; transition:all .15s ease;
  border:1px solid transparent;
}
.nav-link:hover{
  background:rgba(255,255,255,.08); color:var(--text);
  border-color:rgba(255,255,255,.15);
  text-decoration:none;
}
.nav-link:focus-visible{outline:2px solid var(--accent); outline-offset:2px}
/* [UX_PDF] Date nav - functional, secondary hierarchy */
.nav-date{
  padding:var(--sp-4) var(--sp-8);
  border:1px solid rgba(255,255,255,.1);
  border-radius:var(--sp-4);
  background:rgba(255,255,255,.03);
}
.nav-date:hover{
  background:rgba(107,188,255,.1);
  border-color:rgba(107,188,255,.3);
  color:var(--blue);
}
/* [UX_PDF] Primary nav button - clear affordance + pulse animation */
.nav-primary{
  padding:var(--sp-8) var(--sp-12);
  min-height:36px;
  background:linear-gradient(135deg, rgba(53,217,154,.2), rgba(53,217,154,.1));
  color:var(--accent); font-weight:700; font-size:.8125rem;
  border:1px solid rgba(53,217,154,.4);
  border-radius:var(--sp-8);
  box-shadow:0 2px 8px rgba(53,217,154,.15), inset 0 1px 0 rgba(255,255,255,.1);
  cursor:pointer;
  animation:notePulse 3s ease-in-out infinite;
}
.nav-primary:hover{
  background:linear-gradient(135deg, rgba(53,217,154,.3), rgba(53,217,154,.15));
  border-color:rgba(53,217,154,.6);
  box-shadow:0 4px 12px rgba(53,217,154,.25);
  transform:translateY(-1px);
  animation:none;
}
.nav-primary:active{transform:translateY(0); box-shadow:0 1px 4px rgba(53,217,154,.15)}
@keyframes notePulse{
  0%,100%{box-shadow:0 2px 8px rgba(53,217,154,.15)}
  50%{box-shadow:0 2px 16px rgba(53,217,154,.35), 0 0 20px rgba(53,217,154,.15)}
}
/* Legacy pill for backwards compat */
.pill{
  padding:var(--sp-4) var(--sp-8); min-height:32px; border:1px solid var(--border); border-radius:999px;
  background:rgba(16,22,29,.6); color:var(--muted); font-size:.75rem;
  display:inline-flex; align-items:center;
  transition:border-color .15s ease, background .15s ease;
}
/* Alcool Header - style moderne */
.alcHeader{
  display:flex;
  align-items:center;
  justify-content:space-between;
  padding:16px 16px 12px;
  gap:16px;
}
.alcHeader__left{
  display:flex;
  align-items:center;
  gap:12px;
}
.alcHeader__left h2{
  margin:0;
  font-size:1.35rem;
  font-weight:800;
  color:var(--text);
  display:flex;
  align-items:center;
  gap:10px;
}
.alcHeader__left .alcTitleIcon{font-size:1.4rem}
.alcHeader__badge{
  font-size:.75rem;
  color:#10b981;
  background:rgba(16,185,129,.12);
  border:1px solid rgba(16,185,129,.3);
  padding:5px 10px;
  border-radius:16px;
  font-weight:600;
  text-transform:uppercase;
  letter-spacing:.6px;
}
.alcHeader__date{
  font-size:.85rem;
  color:var(--muted);
  display:flex;
  align-items:center;
  gap:6px;
  padding:6px 12px;
  background:rgba(255,255,255,.04);
  border-radius:8px;
}
.alcHeader__date .dateIcon{font-size:1rem}
/* Alcool Units Chips */
.alcUnitChip{
  display:flex;
  align-items:center;
  gap:6px;
  padding:8px 10px;
  box-sizing:border-box;
  border-radius:12px;
  border:1px solid rgba(255,255,255,.12);
  background:rgba(16,22,29,.7);
  backdrop-filter:blur(8px);
  box-shadow:0 4px 12px rgba(0,0,0,.2), 0 0 0 1px rgba(255,255,255,.04) inset;
  transition:all .2s ease;
}
.alcUnitChip:hover{
  transform:translateY(-2px);
  box-shadow:0 6px 16px rgba(0,0,0,.25), 0 0 0 1px rgba(255,255,255,.08) inset;
}
.alcUnitChip__icon{font-size:1.2rem; filter:drop-shadow(0 2px 4px rgba(0,0,0,.3))}
.alcUnitChip__svg{width:22px; height:22px; flex-shrink:0; filter:drop-shadow(0 2px 4px rgba(0,0,0,.3))}
.alcUnitChip__content{display:flex; flex-direction:column; gap:1px}
.alcUnitChip__label{font-size:.75rem; font-weight:700; text-transform:uppercase; letter-spacing:.4px; color:var(--muted)}
.alcUnitChip__value{font-size:.75rem; font-weight:600; color:var(--text); font-variant-numeric:tabular-nums}
/* Chip color accents */
.alcUnitChip--beer{border-color:rgba(255,235,59,.35); background:linear-gradient(135deg, rgba(255,235,59,.1), rgba(16,22,29,.7))}
.alcUnitChip--beer .alcUnitChip__label{color:rgba(255,235,59,.9)}
.alcUnitChip--wine{border-color:rgba(220,53,69,.35); background:linear-gradient(135deg, rgba(220,53,69,.1), rgba(16,22,29,.7))}
.alcUnitChip--wine .alcUnitChip__label{color:rgba(220,100,120,.9)}
.alcUnitChip--strong{border-color:rgba(255,152,0,.35); background:linear-gradient(135deg, rgba(255,152,0,.1), rgba(16,22,29,.7))}
.alcUnitChip--strong .alcUnitChip__label{color:rgba(255,180,80,.9)}
.alcUnitChip--pure{border-color:rgba(56,189,248,.35); background:linear-gradient(135deg, rgba(56,189,248,.1), rgba(16,22,29,.7))}
.alcUnitChip--pure .alcUnitChip__label{color:rgba(56,189,248,.9)}
/* Chips dans header tableau - uniformes et centrés */
.alcUnitChip--header{
  padding:8px 10px; border-radius:8px;
  min-width:100px; justify-content:center;
}
.alcUnitChip--header .alcUnitChip__icon{font-size:1.1rem}
.alcUnitChip--header .alcUnitChip__svg{width:20px; height:20px}
.alcUnitChip--header .alcUnitChip__label{font-size:.75rem; text-align:center}
.alcUnitChip--header .alcUnitChip__value{font-size:.75rem; text-align:center; white-space:nowrap}
.alcUnitChip--header .alcUnitChip__content{align-items:center}
.alcUnitChip--header:hover{transform:none}
/* Date chip */
.alcDateChip{
  display:flex;
  align-items:center;
  gap:8px;
  padding:10px 16px;
  margin-left:auto;
  border-radius:12px;
  border:1px solid rgba(107,188,255,.4);
  background:linear-gradient(135deg, rgba(107,188,255,.15), rgba(16,22,29,.7));
  box-shadow:0 4px 12px rgba(0,0,0,.2), 0 0 12px rgba(107,188,255,.1);
}
.alcDateChip__icon{font-size:1.1rem}
.alcDateChip__value{font-size:.9rem; font-weight:800; color:var(--text); letter-spacing:.3px}
.alcCard{
  border-color:rgba(91,178,255,.4);
  box-shadow:0 16px 50px rgba(0,0,0,.5), 0 0 40px rgba(91,178,255,.15), 0 0 0 1px rgba(91,178,255,.12) inset;
  background:linear-gradient(135deg, rgba(91,178,255,.08), rgba(91,178,255,.02));
}
.alcCard::after{
  background:radial-gradient(closest-side, rgba(91,178,255,.12), transparent 70%);
  opacity:.55;
}
/* Alcool badge accent */
.alcBadge{background:linear-gradient(135deg, rgba(107,188,255,.25), rgba(107,188,255,.1)); border-color:rgba(107,188,255,.4); color:rgba(180,220,255,.95)}
.alcDivider{
  /* [WEB] margin 8px */
  height:2px;
  background:linear-gradient(90deg, rgba(255,255,255,.2), rgba(255,255,255,.08));
  margin:8px 0;
}
.card{
  /* Glass morphism renforcé */
  border:1px solid rgba(255,255,255,.12);
  background:linear-gradient(135deg, rgba(255,255,255,.08), rgba(255,255,255,.02));
  backdrop-filter:blur(12px);
  -webkit-backdrop-filter:blur(12px);
  border-radius:var(--r); padding:16px; margin:16px 0;
  box-shadow:0 8px 32px rgba(0,0,0,.4), 0 0 0 1px rgba(255,255,255,.05) inset;
  position:relative; overflow:hidden;
  transition:all .3s cubic-bezier(.4,0,.2,1);
}
.card::before{
  content:""; position:absolute; inset:0; pointer-events:none; border-radius:var(--r);
  box-shadow:0 0 0 1px rgba(255,255,255,.03) inset;
}
.card::after{
  content:""; position:absolute; left:-30%; top:-40%; width:120%; height:70%;
  background:radial-gradient(closest-side, rgba(91,178,255,.08), transparent 70%);
  opacity:.45; pointer-events:none;
}
/* [N2] Subtle hover for data cards - less motion */
.card:hover{
  border-color:rgba(91,178,255,.5);
  transform:translateY(-2px);
  box-shadow:0 12px 36px rgba(0,0,0,.45), 0 0 20px rgba(91,178,255,.1), 0 0 0 1px rgba(91,178,255,.12) inset;
}
/* [WEB] gaps multiples of 4: 8px, 16px */
.grid{display:grid; grid-template-columns:repeat(auto-fit,minmax(168px,1fr)); gap:16px}
.row{display:flex; gap:8px; flex-wrap:wrap; align-items:center}
/* Hiérarchie visuelle renforcée */
h1{font-size:1.75rem; font-weight:900; margin:8px 0 12px; letter-spacing:.4px; text-shadow:0 2px 8px rgba(0,0,0,.3)}
h2{font-size:1.375rem; font-weight:800; margin:6px 0 10px; letter-spacing:.3px}
small{color:var(--muted)}
.btn{
  /* [WEB] touch target 44px minimum (iOS), padding 10/18 */
  border:1px solid var(--border); background:rgba(16,22,29,.65); color:var(--text);
  font-family:inherit;
  min-height:2.75rem; padding:10px 18px; border-radius:8px; cursor:pointer; font-weight:600;
  box-shadow:0 1px 2px rgba(0,0,0,.18);
  /* [WEB] transition 200ms standard */
  transition:transform .2s ease, box-shadow .2s ease, border-color .2s ease, filter .2s ease, background .2s ease;
}
/* Hover plus marqués avec scale et glow */
.btn:hover{transform:translateY(-2px) scale(1.02); box-shadow:0 6px 20px rgba(0,0,0,.35), 0 0 15px rgba(255,255,255,.08)}
.btn:active{transform:translateY(0) scale(0.98)}
.btn.blue:hover{border-color:rgba(91,178,255,.9); background:rgba(91,178,255,.2); box-shadow:0 6px 20px rgba(91,178,255,.3), 0 0 20px rgba(91,178,255,.25)}
.btn.warn:hover{border-color:rgba(246,183,60,.9); background:rgba(246,183,60,.2); box-shadow:0 6px 20px rgba(246,183,60,.3), 0 0 20px rgba(246,183,60,.25)}
.btn.danger:hover{border-color:rgba(255,107,107,.9); background:rgba(255,107,107,.2); box-shadow:0 6px 20px rgba(255,107,107,.3), 0 0 20px rgba(255,107,107,.25)}
.btn.primary{border-color:rgba(38,211,140,.7); background:rgba(38,211,140,.14)}
.btn.action{
  border-color:var(--btn-border, var(--border));
  background:var(--btn-bg, rgba(16,22,29,.65));
  color:var(--btn-ink, var(--text));
  box-shadow:0 0 16px var(--btn-glow, rgba(0,0,0,.2)), 1px 1px 0 rgba(0,0,0,.18);
  text-shadow:0 1px 0 rgba(0,0,0,.35);
}
.btn.action:hover{filter:brightness(1.1) saturate(1.3); transform:translateY(-2px) scale(1.03); box-shadow:0 0 28px var(--btn-glow, rgba(255,255,255,.3)), 0 8px 24px rgba(0,0,0,.4)}
.btn.action:active{filter:brightness(0.95) saturate(1.4); transform:translateY(0) scale(0.98)}
.btn.cmd{
  border-color:var(--cmd-border, var(--border));
  background:var(--cmd-bg, rgba(16,22,29,.65));
  color:var(--cmd-ink, var(--text));
  box-shadow:0 0 16px var(--cmd-glow, rgba(0,0,0,.2)), 1px 1px 0 rgba(0,0,0,.18);
  text-shadow:0 1px 0 rgba(0,0,0,.35);
}
.btn.cmd:hover{filter:brightness(1.1) saturate(1.3); transform:translateY(-2px) scale(1.03); box-shadow:0 0 28px var(--cmd-glow, rgba(255,255,255,.3)), 0 8px 24px rgba(0,0,0,.4)}
.btn.cmd:active{filter:brightness(0.95) saturate(1.4); transform:translateY(0) scale(0.98)}
/* [web_focus_visible_wcag_2_4_7] + [web_focus_appearance_min_wcag_2_4_13] */
:focus-visible{outline:2px solid var(--blue);outline-offset:2px}
.btn:focus-visible,.pill:focus-visible{outline:2px solid var(--accent);outline-offset:2px;box-shadow:0 0 0 4px rgba(53,217,154,.25)}
a:focus-visible{outline:2px solid var(--blue);outline-offset:2px}
input:focus-visible,select:focus-visible,textarea:focus-visible{outline:2px solid var(--blue);outline-offset:0;border-color:var(--blue)}

.btn.action-clope{--btn-border:rgba(255,77,77,.95); --btn-bg:rgba(255,77,77,.28); --btn-glow:rgba(255,77,77,.4)}
.btn.action-manger{--btn-border:rgba(255,93,143,.95); --btn-bg:rgba(255,93,143,.28); --btn-glow:rgba(255,93,143,.4)}
.btn.action-menage{--btn-border:rgba(0,225,170,.95); --btn-bg:rgba(0,225,170,.26); --btn-glow:rgba(0,225,170,.4); --btn-ink:#ffffff}
.btn.action-douche{--btn-border:rgba(77,181,255,.95); --btn-bg:rgba(77,181,255,.28); --btn-glow:rgba(77,181,255,.4)}
.btn.action-marche{--btn-border:rgba(255,255,255,.98); --btn-bg:rgba(255,255,255,.32); --btn-glow:rgba(255,255,255,.45); --btn-ink:#ffffff}
.btn.action-sport{--btn-border:rgba(60,255,122,.95); --btn-bg:rgba(60,255,122,.28); --btn-glow:rgba(60,255,122,.4)}
.btn.action-push{--btn-border:rgba(178,123,255,.95); --btn-bg:rgba(178,123,255,.28); --btn-glow:rgba(178,123,255,.4)}
.btn.action-rego{--btn-border:rgba(255,210,0,.98); --btn-bg:rgba(255,210,0,.32); --btn-glow:rgba(255,210,0,.45); --btn-ink:#0e1116}
.btn.action-reveille{--btn-border:rgba(0,212,255,.98); --btn-bg:rgba(0,212,255,.3); --btn-glow:rgba(0,212,255,.45); --btn-ink:#ffffff}
.btn.action-meditation{--btn-border:rgba(79,107,255,.95); --btn-bg:rgba(79,107,255,.28); --btn-glow:rgba(79,107,255,.4)}
.btn.action-glandouille{--btn-border:rgba(155,92,255,.98); --btn-bg:rgba(155,92,255,.3); --btn-glow:rgba(155,92,255,.45)}
.btn.action-chier{--btn-border:rgba(255,153,85,.95); --btn-bg:rgba(255,153,85,.28); --btn-glow:rgba(255,153,85,.4)}

.btn.cmd-start{--cmd-border:rgba(107,255,133,.98); --cmd-bg:rgba(107,255,133,.32); --cmd-glow:rgba(107,255,133,.45); --cmd-ink:#ffffff}
.btn.cmd-work{--cmd-border:rgba(255,79,216,.98); --cmd-bg:rgba(255,79,216,.3); --cmd-glow:rgba(255,79,216,.45)}
.btn.cmd-ok{--cmd-border:rgba(255,79,216,.98); --cmd-bg:rgba(255,79,216,.3); --cmd-glow:rgba(255,79,216,.45)}
.btn.cmd-dodo{--cmd-border:rgba(102,126,234,.98); --cmd-bg:rgba(102,126,234,.3); --cmd-glow:rgba(102,126,234,.45)}
.btn.cmd-jpp{--cmd-border:rgba(255,77,77,.98); --cmd-bg:rgba(255,77,77,.3); --cmd-glow:rgba(255,77,77,.45)}

/* ========================================
   [UX PRO] Commandes Card - Glassmorphism Sub-cards
   - Spacing system 4px (--sp-8, --sp-16, etc.)
   - Touch targets 44px min
   - Cards padding 16px, radius 8px, shadow
   - HSB hover/active states
   ======================================== */
.commandsCard{ display:flex; flex-direction:column; gap:var(--sp-16) }
.cmdBadge{ background:linear-gradient(135deg, rgba(53,217,154,.2), rgba(91,178,255,.2)); border-color:rgba(53,217,154,.4); font-size:.7rem }

/* Sub-cards glassmorphism */
.cmdSubCard{
  background:linear-gradient(135deg, rgba(16,22,29,.75), rgba(16,22,29,.55));
  backdrop-filter:blur(12px);
  border:1px solid rgba(255,255,255,.08);
  border-radius:var(--sp-12);
  padding:var(--sp-16);
  transition:all .25s cubic-bezier(.4,0,.2,1);
}
.cmdSubCard:hover{
  border-color:rgba(255,255,255,.15);
  box-shadow:0 8px 32px rgba(0,0,0,.25);
}
.cmdSubCard__header{
  display:flex; align-items:center; gap:var(--sp-8);
  margin-bottom:var(--sp-12);
  padding-bottom:var(--sp-8);
  border-bottom:1px solid rgba(255,255,255,.06);
}
.cmdSubCard__icon{ font-size:1.1rem; opacity:.85 }
.cmdSubCard__title{ font-weight:700; font-size:.95rem; letter-spacing:.3px }

/* Primary sub-card (Start/Work/Dodo) - accent border */
.cmdSubCard--primary{
  border-color:rgba(53,217,154,.25);
  background:linear-gradient(135deg, rgba(53,217,154,.08), rgba(16,22,29,.65));
}
.cmdSubCard--primary:hover{ border-color:rgba(53,217,154,.45) }

/* Actions sub-card - yellow accent */
.cmdSubCard--actions{
  border-color:rgba(255,210,0,.2);
  background:linear-gradient(135deg, rgba(255,210,0,.05), rgba(16,22,29,.6));
}
.cmdSubCard--actions:hover{ border-color:rgba(255,210,0,.4) }

/* Alcohol sub-card - amber/orange accent */
.cmdSubCard--alcohol{
  border-color:rgba(255,153,85,.2);
  background:linear-gradient(135deg, rgba(255,153,85,.05), rgba(16,22,29,.6));
}
.cmdSubCard--alcohol:hover{ border-color:rgba(255,153,85,.4) }

/* System sub-card - blue accent */
.cmdSubCard--system{
  border-color:rgba(91,178,255,.15);
  background:linear-gradient(135deg, rgba(91,178,255,.04), rgba(16,22,29,.55));
}
.cmdSubCard--system:hover{ border-color:rgba(91,178,255,.35) }

/* Command buttons with icons */
.cmdGrid{ display:grid; grid-template-columns:repeat(3,1fr); gap:var(--sp-12) }
@media(max-width:640px){ .cmdGrid{ grid-template-columns:1fr } }
.cmdBtn{
  display:flex; flex-direction:column; align-items:center; justify-content:center;
  gap:var(--sp-4); min-height:4.5rem; padding:var(--sp-12) var(--sp-16);
  border-radius:var(--sp-12);
}
.cmdBtn__icon{ font-size:1.5rem; line-height:1 }
.cmdBtn__label{ font-size:.85rem; font-weight:700; letter-spacing:.5px }

/* Alcohol buttons - redesign avec volumes */
.alcFieldRow{ margin-top:var(--sp-8); gap:var(--sp-12) }
.alcBtn{
  display:inline-flex; flex-direction:column; align-items:center; justify-content:center;
  gap:2px; padding:var(--sp-8) var(--sp-16); min-height:3.25rem; min-width:7rem;
  background:rgba(18,22,28,.85); border:1.5px solid rgba(200,160,60,.6); border-radius:8px;
}
.alcBtn:hover{
  background:rgba(30,35,42,.9); border-color:rgba(220,180,80,.9);
  box-shadow:0 4px 20px rgba(200,160,60,.3);
}
.alcBtn .alcLabel{ display:flex; align-items:center; gap:6px; font-weight:600; font-size:.95rem }
.alcBtn .alcVol{ font-size:.7rem; color:var(--muted); font-weight:400 }
/* VIN - fond bordeaux */
.alcBtn.alcBtn--wine{
  background:rgba(120,30,50,.65); border-color:rgba(180,60,90,.7);
}
.alcBtn.alcBtn--wine:hover{
  background:rgba(140,40,65,.75); border-color:rgba(200,80,110,.9);
  box-shadow:0 4px 20px rgba(180,60,90,.35);
}
.alcStatus{ margin-left:auto; color:var(--muted) }
.alcAdjustToggle{ margin-top:var(--sp-8) }
.alcAdjustWrap{ margin-top:var(--sp-8); padding:var(--sp-12); background:rgba(0,0,0,.2); border-radius:var(--sp-8) }
.alcSelect{ width:auto; min-width:140px }

/* System row */
.cmdStatusRow{ margin-top:var(--sp-8) }
.cmdStatusPill{ font-size:.85rem }

/* [WEB] gap 16px */
.kpi{display:flex; gap:16px; flex-wrap:wrap}
.kpi .box{
  /* Glass morphism KPI box */
  flex:1 1 100%; min-width:0; border:1px solid rgba(255,255,255,.1);
  background:linear-gradient(135deg, rgba(16,22,29,.85), rgba(16,22,29,.6));
  backdrop-filter:blur(10px);
  border-radius:12px; padding:20px; position:relative;
  box-shadow:0 8px 32px rgba(0,0,0,.35);
  transition:all .3s cubic-bezier(.4,0,.2,1);
}
/* WORK Remaining box - minimal */
.kpi .box[aria-label="Travail restant"]{
  background:#161b22;
  border:1px solid #30363d;
  border-radius:16px;
  box-shadow:none;
  padding:24px;
}
.kpi .box[aria-label="Travail restant"]::after{display:none}
.kpi .box:hover{
  transform:translateY(-2px);
  box-shadow:0 12px 40px rgba(0,0,0,.45);
}
@media(min-width:640px){.kpi .box{flex:1 1 auto;min-width:15rem}}
/* Animation pulsation sur éléments actifs */
.kpi .box.currentBox{
  border-color:var(--curr-border, var(--border));
  background:linear-gradient(180deg, var(--curr-bg, rgba(16,22,29,.7)), rgba(16,22,29,.5));
  box-shadow:0 0 0 1px rgba(255,255,255,.04) inset, 0 0 30px var(--curr-glow, rgba(0,0,0,0));
  animation:boxPulse 2.5s ease-in-out infinite;
}
@keyframes boxPulse{
  0%,100%{box-shadow:0 0 0 1px rgba(255,255,255,.04) inset, 0 0 25px var(--curr-glow, rgba(0,0,0,0))}
  50%{box-shadow:0 0 0 1px rgba(255,255,255,.08) inset, 0 0 40px var(--curr-glow, rgba(0,0,0,0)), 0 0 60px var(--curr-glow, rgba(0,0,0,0))}
}
.currentBox.work{--curr-border:rgba(255,79,216,.7); --curr-bg:rgba(255,79,216,.12); --curr-glow:rgba(255,79,216,.45)}
.currentBox.sleep{--curr-border:rgba(102,126,234,.7); --curr-bg:rgba(102,126,234,.12); --curr-glow:rgba(102,126,234,.45)}
.currentBox.break{--curr-border:rgba(246,183,60,.6); --curr-bg:rgba(246,183,60,.1); --curr-glow:rgba(246,183,60,.35)}
.currentBox.wait-ok{--curr-border:rgba(255,77,77,.7); --curr-bg:rgba(255,77,77,.12); --curr-glow:rgba(255,77,77,.5)}
.currentBox.action-clope{--curr-border:rgba(255,77,77,.7); --curr-bg:rgba(255,77,77,.12); --curr-glow:rgba(255,77,77,.45)}
.currentBox.action-manger{--curr-border:rgba(255,93,143,.7); --curr-bg:rgba(255,93,143,.12); --curr-glow:rgba(255,93,143,.45)}
.currentBox.action-menage{--curr-border:rgba(0,225,170,.7); --curr-bg:rgba(0,225,170,.12); --curr-glow:rgba(0,225,170,.45)}
.currentBox.action-douche{--curr-border:rgba(77,181,255,.7); --curr-bg:rgba(77,181,255,.12); --curr-glow:rgba(77,181,255,.45)}
.currentBox.action-marche{--curr-border:rgba(255,255,255,.75); --curr-bg:rgba(255,255,255,.1); --curr-glow:rgba(255,255,255,.5)}
.currentBox.action-sport{--curr-border:rgba(60,255,122,.7); --curr-bg:rgba(60,255,122,.12); --curr-glow:rgba(60,255,122,.45)}
.currentBox.action-push{--curr-border:rgba(178,123,255,.7); --curr-bg:rgba(178,123,255,.12); --curr-glow:rgba(178,123,255,.45)}
.currentBox.action-rego{--curr-border:rgba(255,210,0,.7); --curr-bg:rgba(255,210,0,.12); --curr-glow:rgba(255,210,0,.45)}
.currentBox.action-reveille{--curr-border:rgba(0,212,255,.7); --curr-bg:rgba(0,212,255,.12); --curr-glow:rgba(0,212,255,.45)}
.currentBox.action-meditation{--curr-border:rgba(79,107,255,.7); --curr-bg:rgba(79,107,255,.12); --curr-glow:rgba(79,107,255,.45)}
.currentBox.action-glandouille{--curr-border:rgba(155,92,255,.7); --curr-bg:rgba(155,92,255,.12); --curr-glow:rgba(155,92,255,.45)}
.currentBox.action-chier{--curr-border:rgba(255,153,85,.7); --curr-bg:rgba(255,153,85,.12); --curr-glow:rgba(255,153,85,.45)}
/* Box header + stats - minimal */
.box-header{display:flex;align-items:center;justify-content:space-between;padding-bottom:16px;margin-bottom:0}
.box-title{font-weight:500;font-size:.875rem;color:#8b949e;display:flex;align-items:center;gap:10px}
.box-title-icon{font-size:1.2rem}
.box-title-icon.progressEmoji{font-size:1.2rem}
.box-subtitle{font-size:.75rem;color:#8b949e;font-weight:400;background:none;padding:0}
.box-stats{display:flex;justify-content:space-between;gap:16px;padding:0;margin:0 0 24px}
.box-stat{flex:1;text-align:center;padding:0;background:none;border:none}
.box-stat:hover{background:none}
.box-stat-icon{display:none}
.box-stat-value{font-size:1.5rem;font-weight:600;color:#e6edf3;font-variant-numeric:tabular-nums;line-height:1.2}
.box-stat-label{font-size:.75rem;color:#8b949e;text-transform:none;letter-spacing:0;margin-top:4px;font-weight:400}
.box-stat-value.accent{color:var(--accent);text-shadow:none}
.box-stat-value.warn{color:var(--warn);text-shadow:none}
.box-divider{display:none}
.box-remain{text-align:center;padding:24px 0}
.box-remain-value{font-size:3.5rem;font-weight:600;color:#e6edf3;letter-spacing:-2px;line-height:1}
.box-remain-label{font-size:.875rem;color:#8b949e;margin-top:8px;text-transform:none;letter-spacing:0;font-weight:400}
.box-progress{height:8px;background:#21262d;border-radius:6px;overflow:hidden;margin-top:0;border:none}
.box-progress-bar{height:100%;background:var(--accent);border-radius:6px;transition:width .3s ease}
.box-progress-pct{position:absolute;right:0;top:-24px;font-size:.875rem;color:#8b949e;font-weight:500}
.box-action-row{display:flex;align-items:center;justify-content:space-between;padding:var(--sp-12) 0;flex-wrap:wrap;gap:var(--sp-8)}
.box-action-main{font-size:2rem;font-weight:900;color:var(--text);letter-spacing:-1px;text-shadow:0 0 30px rgba(255,255,255,.15)}
.box-action-flags{display:flex;gap:var(--sp-8);flex-wrap:wrap}
.box-action-flag{font-size:.7rem;padding:4px 12px;border-radius:12px;background:rgba(255,255,255,.06);color:var(--muted);font-weight:600;border:1px solid rgba(255,255,255,.08);transition:all .2s}
.box-action-flag.active{background:linear-gradient(135deg,var(--accent),#6bbcff);color:#000;border-color:transparent;box-shadow:0 0 15px rgba(53,217,154,.4)}
.box-timer{display:flex;align-items:center;gap:var(--sp-16);padding:var(--sp-12) 0;flex-wrap:wrap}
.box-timer-item{display:flex;flex-direction:column;align-items:center}
.box-timer-value{font-size:1.1rem;font-weight:700;color:var(--text);font-variant-numeric:tabular-nums}
.box-timer-label{font-size:.6rem;color:var(--muted);text-transform:uppercase;letter-spacing:.5px}
.box-timer-value.overtime{color:var(--danger);animation:overtimePulse 1s ease-in-out infinite}
@keyframes overtimePulse{0%,100%{opacity:1}50%{opacity:.6}}
.kpi .box::after{
  content:""; position:absolute; right:10px; top:10px; width:10px; height:10px;
  border:2px solid rgba(255,255,255,.06); transform:rotate(45deg);
}
/* Chiffres KPI plus impactants */
.big{
  font-size:2rem; font-weight:900; margin-top:10px;
  background:linear-gradient(135deg, #fff 0%, rgba(255,255,255,.8) 100%);
  -webkit-background-clip:text; -webkit-text-fill-color:transparent;
  background-clip:text;
  text-shadow:0 0 30px rgba(255,255,255,.2);
  letter-spacing:-.5px;
}
/* Status avec glow */
.status.online{color:var(--accent); text-shadow:0 0 15px rgba(53,217,154,.6)}
.status.stale{color:var(--warn); text-shadow:0 0 15px rgba(247,191,84,.6)}
.status.offline{color:var(--danger); text-shadow:0 0 15px rgba(255,122,122,.6); animation:statusBlink 1.5s ease-in-out infinite}
@keyframes statusBlink{0%,100%{opacity:1}50%{opacity:.5}}
.progress{
  height:20px; background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.15);
  border-radius:999px; overflow:hidden;
  box-shadow:inset 0 2px 8px rgba(0,0,0,.4);
}
/* [N1] Simplified: 1 animation instead of 3 for GPU performance */
.progress > div{
  height:100%; width:0%;
  background-image:
    linear-gradient(180deg, rgba(255,255,255,.38), rgba(255,255,255,0) 55%, rgba(255,255,255,.28)),
    linear-gradient(90deg, rgba(107,255,133,.98), rgba(91,178,255,.95), rgba(255,79,216,.95), rgba(246,183,60,.95));
  position:relative; overflow:hidden;
  box-shadow:0 0 12px rgba(255,255,255,.45), 0 0 20px rgba(255,255,255,.25), inset 0 0 8px rgba(255,255,255,.2);
}
.progress > div::before{
  content:""; position:absolute; inset:0;
  background:linear-gradient(90deg, rgba(255,255,255,0) 0%, rgba(255,255,255,.55) 45%, rgba(255,255,255,0) 80%);
  opacity:.8; mix-blend-mode:screen; transform:translateX(-70%);
  animation:shine 2.8s ease-in-out infinite; pointer-events:none;
}
.progress > div::after{display:none}
@keyframes shine{
  0%{transform:translateX(-70%)}
  50%{transform:translateX(70%)}
  100%{transform:translateX(70%)}
}
@keyframes pulseHalo{
  0%{box-shadow:0 0 10px rgba(255,255,255,.45), 0 0 20px rgba(255,255,255,.25), inset 0 0 8px rgba(255,255,255,.2)}
  50%{box-shadow:0 0 16px rgba(255,255,255,.75), 0 0 34px rgba(255,255,255,.4), inset 0 0 12px rgba(255,255,255,.28)}
  100%{box-shadow:0 0 10px rgba(255,255,255,.45), 0 0 20px rgba(255,255,255,.25), inset 0 0 8px rgba(255,255,255,.2)}
}
.reveal{opacity:0; transform:translateY(6px); animation:fadeUp .7s ease forwards}
.reveal.d1{animation-delay:.06s}
.reveal.d2{animation-delay:.12s}
.reveal.d3{animation-delay:.18s}
.reveal.d4{animation-delay:.24s}
.reveal.d5{animation-delay:.30s}
.reveal.d6{animation-delay:.36s}
@keyframes fadeUp{
  to{opacity:1; transform:translateY(0)}
}
.alert{border-color:rgba(255,107,107,.9); box-shadow:0 0 0 2px rgba(255,107,107,.12), var(--shadow)}
.alertText{color:rgba(255,107,107,.95); font-weight:900}
/* ════════════════════════════════════════════════════════════════════════════════
   CALENDRIER PRO V2 - Refonte UX complète
   - Vue condensée par défaut
   - Progressive disclosure (détails au hover)
   - Mini-badges colorés compacts
   - Touch targets 48px
   ════════════════════════════════════════════════════════════════════════════════ */

/* Table = grille moderne */
table{
  border-collapse:separate;
  border-spacing:6px;
  width:100%;
  table-layout:fixed;
  overflow:visible;
}

/* Headers compacts */
th{
  background:transparent;
  border:none;
  padding:8px 4px 12px;
  text-align:center;
}

/* ═══════════════════════════════════════════════════════════
   CALENDRIER GLASSMORPHISM WAOW
   - Effets glass et glow
   - Emojis visuels toujours visibles
   - Animations fluides
   - Hiérarchie claire
   ═══════════════════════════════════════════════════════════ */

td.day{
  background:linear-gradient(145deg, rgba(22,30,42,.9), rgba(14,20,30,.85));
  backdrop-filter:blur(12px);
  border:1px solid rgba(255,255,255,.08);
  border-radius:16px;
  padding:12px;
  vertical-align:top;
  min-height:120px;
  height:auto;
  position:relative;
  transition:all .25s cubic-bezier(.4,0,.2,1);
  box-shadow:0 4px 24px rgba(0,0,0,.3), inset 0 1px 0 rgba(255,255,255,.06);
}
td.day:not(.empty):hover{
  transform:translateY(-2px);
  border-color:rgba(255,255,255,.15);
  box-shadow:0 8px 24px rgba(0,0,0,.35), inset 0 1px 0 rgba(255,255,255,.08);
  z-index:10;
}
td.day:focus-within{
  outline:2px solid var(--accent);
  outline-offset:2px;
}

/* TODAY - effet glow magique */
td.day.today{
  background:linear-gradient(145deg, rgba(53,217,154,.1), rgba(22,30,42,.9));
  border:2px solid var(--accent);
  box-shadow:0 0 40px rgba(53,217,154,.2), 0 8px 32px rgba(0,0,0,.35), inset 0 0 80px rgba(53,217,154,.03);
}
td.day.today::before{
  content:"Auj.";
  position:absolute;
  top:6px;
  right:6px;
  font-size:.625rem;
  font-weight:700;
  text-transform:uppercase;
  letter-spacing:.3px;
  color:var(--accent);
  background:rgba(53,217,154,.15);
  padding:1px 6px;
  border-radius:8px;
  border:1px solid rgba(53,217,154,.25);
}

/* EMPTY - quasi invisible */
td.day.empty{
  background:rgba(14,19,25,.2);
  border:1px solid transparent;
  box-shadow:none;
  min-height:110px;
  height:auto;
}
td.day.empty:hover{transform:none;box-shadow:none}

/* ═══ HEADER - Numéro + Badge Travail ═══ */
/* [§36] Grille 4px - [§49] Density sans entropy */
.dhead{
  display:flex;
  flex-wrap:nowrap;
  align-items:center;
  gap:8px;
  margin-bottom:8px;
}
.dnum{
  font-size:1.3rem;
  font-weight:800;
  color:rgba(255,255,255,.95);
  line-height:1.2;
}
td.day.today .dnum{
  color:var(--accent);
  text-shadow:0 0 18px rgba(53,217,154,.4);
}

/* ═══ LINE 1: Alcohol chips (framed, primary) ═══ */
.dm{
  display:inline-flex;
  align-items:center;
  gap:4px;
  font-size:13px;
  font-weight:600;
  padding:4px 10px;
  border-radius:12px;
  line-height:1.2;
  white-space:nowrap;
  height:28px;
  box-sizing:border-box;
}
.dm--alc{
  color:#ffd56b;
  background:rgba(255,213,107,.08);
  border:1px solid rgba(255,213,107,.2);
}
.dm-whisky{
  width:16px;
  height:16px;
  vertical-align:middle;
  flex-shrink:0;
}

/* Cell flex layout */
.dcell{
  display:flex;
  flex-direction:column;
  height:100%;
}

/* ═══ LABELS ROW: emoji + value, left/right ═══ */
.dlabels{
  display:flex;
  justify-content:space-between;
  align-items:center;
  margin-top:auto;
  margin-bottom:4px;
}
.dlbl{
  display:inline-flex;
  align-items:center;
  gap:2px;
  font-size:11px;
  font-weight:600;
  padding:2px 6px;
  border-radius:8px;
  line-height:1.2;
  white-space:nowrap;
}
.dlbl--work{
  color:#ff6ec7;
  background:rgba(255,110,199,.08);
  border:1px solid rgba(255,110,199,.2);
}
.dlbl--sleep{
  color:#a8d4ff;
  background:rgba(168,212,255,.08);
  border:1px solid rgba(168,212,255,.2);
}

/* ═══ COMBINED BAR ═══ */
.dbar{
  display:flex;
  height:4px;
  border-radius:2px;
  background:rgba(255,255,255,.06);
  overflow:hidden;
  gap:2px;
  margin-bottom:4px;
}
.dbar-seg{
  height:100%;
  border-radius:2px;
  min-width:3px;
}
.dbar--work{
  background:linear-gradient(90deg, #ff6ec7, #ff8ed4);
  box-shadow:0 0 8px rgba(255,110,199,.4);
}
.dbar--sleep{
  background:linear-gradient(90deg, #7ec8ff, #a8d4ff);
  box-shadow:0 0 8px rgba(168,212,255,.4);
  text-align:right;
}

/* Bottom row: clopes + activities + note */
.dbottom{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:4px;
  margin-top:4px;
}
.dbot{
  display:inline-flex;
  align-items:center;
  gap:2px;
  font-size:11px;
  font-weight:600;
  padding:2px 6px;
  border-radius:8px;
  line-height:1.2;
  white-space:nowrap;
}
.dbot--clope{
  color:#ff6b6b;
  background:rgba(255,107,107,.08);
  border:1px solid rgba(255,107,107,.25);
}
.dbot--acts{
  color:#a29bfe;
  background:rgba(162,155,254,.08);
  border:1px solid rgba(162,155,254,.2);
}

/* ═══ ACTIVITÉS ═══ */
.dacts{
  position:relative;
}
.dacts-toggle{
  font-size:10px;
  font-weight:600;
  color:rgba(255,255,255,.35);
  background:none;
  border:none;
  padding:0;
  cursor:pointer;
  transition:color .2s ease;
  line-height:1;
}
.dacts-toggle:hover{
  color:rgba(255,255,255,.8);
}

/* Tooltip activités - apparaît à droite de la cellule */
.dacts-details{
  position:absolute;
  bottom:0;
  left:calc(100% + 8px);
  transform:translateX(8px);
  width:max-content;
  min-width:170px;
  max-width:220px;
  background:rgba(8,12,18,.98);
  backdrop-filter:blur(24px);
  border:1px solid rgba(255,255,255,.15);
  border-radius:16px;
  padding:16px;
  font-size:.75rem;
  color:var(--text);
  line-height:1.5;
  box-shadow:0 20px 60px rgba(0,0,0,.6), 0 0 0 1px rgba(255,255,255,.05);
  opacity:0;
  visibility:hidden;
  transition:all .25s cubic-bezier(.4,0,.2,1);
  z-index:9999;
  pointer-events:none;
}
/* Desktop: hover */
.dacts:hover .dacts-details,
/* Mobile: tap-toggle via JS */
.dacts-details.open{
  opacity:1;
  visibility:visible;
  transform:translateX(0);
  pointer-events:auto;
}
.dacts-details::after{
  content:"";
  position:absolute;
  left:-7px;
  bottom:12px;
  width:12px;
  height:12px;
  background:rgba(8,12,18,.98);
  border-left:1px solid rgba(255,255,255,.15);
  border-bottom:1px solid rgba(255,255,255,.15);
  transform:rotate(45deg);
}
.dact-item{
  display:flex;
  justify-content:space-between;
  align-items:center;
  padding:6px 0;
  border-bottom:1px solid rgba(255,255,255,.06);
}
.dact-item:last-child{border-bottom:none}
.dact-name{color:rgba(255,255,255,.6);font-size:.7rem}
.dact-dur{color:var(--accent);font-weight:700;font-size:.75rem}

/* Legacy */
.dmeta{display:none}

/* ═══ NOTES - Icône stylée ═══ */
/* [WEB §E Rule 21] Touch target via padding, visual stays compact */
.dnote{
  font-size:.85rem;
  color:rgba(255,255,255,.55);
  text-decoration:none;
  transition:all .2s ease;
  filter:grayscale(20%);
  padding:2px 6px;
  border-radius:8px;
  background:rgba(53,217,154,.08);
  border:1px solid rgba(53,217,154,.2);
  display:flex;
  align-items:center;
  justify-content:center;
}
.dnote:hover{
  color:var(--accent);
  transform:scale(1.35) rotate(-8deg);
  filter:grayscale(0%) drop-shadow(0 0 12px rgba(53,217,154,.5));
}
.dnote:focus-visible{
  outline:2px solid var(--accent);
  outline-offset:4px;
  border-radius:4px;
}

/* ═══ MOBILE RESPONSIVE ═══ */
@media(max-width:640px){
  table{border-spacing:5px}
  table,thead,tbody,tr{display:block;width:100%}
  thead{display:none}
  tr{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:8px;
  }
  td.day{
    height:135px;
    padding:12px;
    border-radius:14px;
  }
  td.day.empty{display:none}
  td.day{padding:8px; min-height:auto}
  td.day.today::before{font-size:12px;padding:2px 6px;top:4px;right:4px}
  .dnum{font-size:1rem}
  .dhead{margin-bottom:4px;gap:4px}
  .dm{font-size:11px;padding:2px 6px;height:22px;gap:3px}
  .dlabels{margin-bottom:3px}
  .dlbl{font-size:10px;padding:1px 4px}
  .dbar{height:3px}
  .dbottom{gap:3px;margin-top:3px}
  .dbot{font-size:9px;padding:1px 4px}
  .dacts-toggle{font-size:9px}
  .dnote{font-size:.7rem;padding:1px 4px}
  /* [I1/I5] Mobile: disable hover, use tap-toggle only */
  .dacts:hover .dacts-details{
    opacity:0; visibility:hidden;
  }
  .dacts-details{
    position:fixed;
    bottom:auto;
    top:50%;
    left:50%;
    right:auto;
    transform:translate(-50%,-50%) scale(.95);
    width:calc(100vw - 40px);
    max-width:300px;
  }
  .dacts-details.open{
    opacity:1; visibility:visible;
    transform:translate(-50%,-50%) scale(1);
  }
  .dacts-details::after{display:none}
  /* Backdrop for mobile tooltip dismiss */
  .dacts-backdrop{
    position:fixed; inset:0;
    background:rgba(0,0,0,.5);
    z-index:9998;
    display:none;
  }
  .dacts-backdrop.show{display:block}
}

/* Reduce motion */
@media(prefers-reduced-motion:reduce){
  td.day,.dnote,.dacts-toggle{transition:none}
  td.day:not(.empty):hover{transform:none}
  .weekRow.currentWeek{animation:none}
}

/* High contrast */
@media(forced-colors:active){
  td.day{border:2px solid CanvasText}
  td.day.today{border:3px solid Highlight}
  .dlink a{border:2px solid LinkText}
}

/* ========================================
   [UX PRO] Calendrier Card - Glassmorphism Sub-cards
   - Spacing system 4px
   - Touch targets 44px min
   - Cards padding 16px, radius 8px, shadow
   - HSB hover/active states
   ======================================== */
.calendarCard{ display:flex; flex-direction:column; gap:var(--sp-16) }

/* ═══ CALENDAR HERO HEADER ═══ */
.cal-hero{
  display:flex;
  align-items:center;
  justify-content:space-between;
  padding:16px 20px;
  background:linear-gradient(135deg, rgba(91,178,255,.06), rgba(162,155,254,.06), rgba(255,110,199,.04));
  border:1px solid rgba(91,178,255,.12);
  border-radius:16px;
  position:relative;
  overflow:hidden;
}
.cal-hero::before{
  content:"";
  position:absolute;
  top:-50%;
  right:-20%;
  width:200px;
  height:200px;
  background:radial-gradient(circle, rgba(91,178,255,.08) 0%, transparent 70%);
  pointer-events:none;
}
.cal-title{
  margin:0;
  font-size:1.4rem;
  font-weight:900;
  letter-spacing:-.5px;
  background:linear-gradient(135deg, #5bb2ff, #a29bfe, #ff6ec7);
  -webkit-background-clip:text;
  -webkit-text-fill-color:transparent;
  background-clip:text;
}
.cal-nav{
  display:flex;
  align-items:center;
  gap:8px;
}
.cal-nav-btn{
  display:flex;
  align-items:center;
  justify-content:center;
  width:32px;
  height:32px;
  border-radius:50%;
  color:rgba(255,255,255,.5);
  background:rgba(255,255,255,.04);
  border:1px solid rgba(255,255,255,.08);
  text-decoration:none;
  transition:all .2s ease;
}
.cal-nav-btn:hover{
  color:#5bb2ff;
  background:rgba(91,178,255,.12);
  border-color:rgba(91,178,255,.3);
  box-shadow:0 0 12px rgba(91,178,255,.2);
  transform:scale(1.1);
}
.cal-nav-btn:active{
  transform:scale(.95);
}
.cal-month{
  font-size:.8rem;
  font-weight:700;
  color:#5bb2ff;
  background:rgba(91,178,255,.1);
  border:1px solid rgba(91,178,255,.25);
  padding:6px 14px;
  border-radius:20px;
  letter-spacing:.5px;
  box-shadow:0 0 12px rgba(91,178,255,.15);
  min-width:80px;
  text-align:center;
}

/* Day name pills */
.cal-day-pill{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  width:28px;
  height:28px;
  border-radius:50%;
  font-size:.7rem;
  font-weight:800;
  letter-spacing:.5px;
  text-transform:uppercase;
  color:rgba(255,255,255,.5);
  background:rgba(255,255,255,.04);
  border:1px solid rgba(255,255,255,.06);
  transition:all .2s ease;
}
.cal-day-pill--we{
  color:rgba(255,153,85,.85);
  background:rgba(255,153,85,.06);
  border-color:rgba(255,153,85,.15);
}

/* Calendar sub-cards */
.calSubCard{
  background:linear-gradient(135deg, rgba(16,22,29,.75), rgba(16,22,29,.55));
  backdrop-filter:blur(12px);
  border:1px solid rgba(255,255,255,.08);
  border-radius:var(--sp-12);
  padding:var(--sp-16);
  transition:all .25s cubic-bezier(.4,0,.2,1);
}
.calSubCard:hover{
  border-color:rgba(255,255,255,.15);
  box-shadow:0 8px 32px rgba(0,0,0,.25);
}

/* Grid sub-card - blue accent */
.calSubCard--grid{
  border-color:rgba(91,178,255,.2);
  background:linear-gradient(135deg, rgba(91,178,255,.05), rgba(16,22,29,.65));
  padding:var(--sp-12);
  overflow:visible; /* Permet aux tooltips de dépasser */
}
.calSubCard--grid:hover{ border-color:rgba(91,178,255,.4) }

/* Legend sub-card - muted accent */
.calSubCard--legend{
  border-color:rgba(255,255,255,.1);
  background:linear-gradient(135deg, rgba(255,255,255,.03), rgba(16,22,29,.5));
  padding:var(--sp-12);
}

/* (Old calTh styles removed - using cal-day-pill now) */

/* Legend items */
.calLegend{
  display:flex;
  flex-wrap:wrap;
  gap:var(--sp-16);
  justify-content:center;
}
.calLegend__item{
  display:flex;
  align-items:center;
  gap:var(--sp-4);
  font-size:.8rem;
  color:var(--muted);
}
.calLegend__icon{ font-size:1rem; opacity:.85; display:flex; align-items:center }
.legend-whisky{ width:18px; height:18px }
.calLegend__text strong{ color:var(--accent); font-weight:700 }

@media(max-width:640px){
  .calLegend{ gap:var(--sp-8); justify-content:flex-start }
  .calLegend__item{ font-size:.75rem }
}

/* Section headers - hero style (same pattern as calendar) */
.section-header{
  display:flex;align-items:center;justify-content:space-between;
  padding:14px 20px;margin-bottom:var(--sp-16);
  background:linear-gradient(135deg, rgba(91,178,255,.05), rgba(162,155,254,.05), rgba(255,110,199,.03));
  border:1px solid rgba(91,178,255,.10);
  border-radius:14px;position:relative;
}
.section-header::before{
  content:"";position:absolute;top:-50%;right:-20%;width:180px;height:180px;
  background:radial-gradient(circle, rgba(91,178,255,.06) 0%, transparent 70%);
  pointer-events:none;
}
.section-header h2{
  margin:0;font-size:1.25rem;font-weight:900;letter-spacing:-.5px;
  background:linear-gradient(135deg, #5bb2ff, #a29bfe, #ff6ec7);
  -webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;
  display:flex;align-items:center;gap:var(--sp-8);
}
.section-header-icon{display:none}
.section-header-badge{
  font-size:.8rem;font-weight:700;color:#5bb2ff;
  background:rgba(91,178,255,.1);border:1px solid rgba(91,178,255,.25);
  padding:6px 14px;border-radius:20px;letter-spacing:.5px;
  box-shadow:0 0 12px rgba(91,178,255,.15);min-width:70px;text-align:center;
}
.section-nav{display:flex;align-items:center;gap:8px;position:relative;z-index:1}
/* [WEB] radius 8px, padding 12px */
.seg{border:1px solid var(--seg-border, var(--border)); border-radius:8px; padding:12px; margin:8px 0; background:var(--seg-bg, rgba(16,22,29,.55)); position:relative; box-shadow:0 0 0 1px rgba(255,255,255,.02) inset}
.seg::before{
  content:""; position:absolute; left:0; top:8px; bottom:8px; width:3px; border-radius:12px;
  background:var(--seg-accent, linear-gradient(180deg, rgba(91,178,255,.7), rgba(38,211,140,.6)));
  opacity:.55;
}
.seg.work{--seg-border:rgba(255,79,216,.5); --seg-bg:rgba(255,79,216,.08); --seg-accent:rgba(255,79,216,.9); --seg-glow:rgba(255,79,216,.45)}
.seg.sleep{--seg-border:rgba(102,126,234,.5); --seg-bg:rgba(102,126,234,.08); --seg-accent:rgba(102,126,234,.9); --seg-glow:rgba(102,126,234,.45)}
.seg.break{--seg-border:rgba(246,183,60,.35); --seg-bg:rgba(246,183,60,.06); --seg-accent:rgba(246,183,60,.9); --seg-glow:rgba(246,183,60,.35)}
.seg.action-clope{--seg-border:rgba(255,77,77,.55); --seg-bg:rgba(255,77,77,.08); --seg-accent:rgba(255,77,77,.9); --seg-glow:rgba(255,77,77,.4)}
.seg.action-manger{--seg-border:rgba(255,93,143,.55); --seg-bg:rgba(255,93,143,.08); --seg-accent:rgba(255,93,143,.9); --seg-glow:rgba(255,93,143,.4)}
.seg.action-menage{--seg-border:rgba(0,225,170,.6); --seg-bg:rgba(0,225,170,.08); --seg-accent:rgba(0,225,170,.9); --seg-glow:rgba(0,225,170,.4)}
.seg.action-douche{--seg-border:rgba(77,181,255,.55); --seg-bg:rgba(77,181,255,.08); --seg-accent:rgba(77,181,255,.9); --seg-glow:rgba(77,181,255,.4)}
.seg.action-marche{--seg-border:rgba(255,255,255,.7); --seg-bg:rgba(255,255,255,.06); --seg-accent:rgba(255,255,255,.9); --seg-glow:rgba(255,255,255,.45)}
.seg.action-sport{--seg-border:rgba(60,255,122,.55); --seg-bg:rgba(60,255,122,.08); --seg-accent:rgba(60,255,122,.9); --seg-glow:rgba(60,255,122,.4)}
.seg.action-push{--seg-border:rgba(178,123,255,.55); --seg-bg:rgba(178,123,255,.08); --seg-accent:rgba(178,123,255,.9); --seg-glow:rgba(178,123,255,.4)}
.seg.action-rego{--seg-border:rgba(255,210,0,.6); --seg-bg:rgba(255,210,0,.08); --seg-accent:rgba(255,210,0,.9); --seg-glow:rgba(255,210,0,.45)}
.seg.action-reveille{--seg-border:rgba(0,212,255,.6); --seg-bg:rgba(0,212,255,.08); --seg-accent:rgba(0,212,255,.9); --seg-glow:rgba(0,212,255,.45)}
.seg.action-meditation{--seg-border:rgba(79,107,255,.6); --seg-bg:rgba(79,107,255,.08); --seg-accent:rgba(79,107,255,.9); --seg-glow:rgba(79,107,255,.4)}
.seg.action-glandouille{--seg-border:rgba(155,92,255,.6); --seg-bg:rgba(155,92,255,.08); --seg-accent:rgba(155,92,255,.9); --seg-glow:rgba(155,92,255,.45)}
.seg.action-chier{--seg-border:rgba(255,153,85,.55); --seg-bg:rgba(255,153,85,.08); --seg-accent:rgba(255,153,85,.9); --seg-glow:rgba(255,153,85,.4)}

/* Timeline graphique avec heures reelles */
.timeline-graph{
  position:relative; height:60px; background:rgba(16,22,29,.4);
  border:1px solid var(--border); border-radius:var(--r);
  margin:var(--sp-12) 0; overflow:hidden;
}
.timeline-hours{
  position:absolute; top:0; left:0; right:0; height:18px;
  display:flex; justify-content:space-between; padding:0 2px;
  font-size:.65rem; color:var(--muted); pointer-events:none;
}
.timeline-hour{flex:0 0 auto; width:calc(100%/24); text-align:center}
.timeline-bars{position:absolute; top:20px; left:0; right:0; bottom:4px}
.timeline-bar{
  position:absolute; top:0; height:100%; min-width:2px;
  border-radius:3px; opacity:.85;
  transition:opacity .2s ease;
}
.timeline-bar:hover{opacity:1; z-index:10}
.timeline-bar.work{background:linear-gradient(180deg, rgba(255,79,216,.7), rgba(255,79,216,.4))}
.timeline-bar.sleep{background:linear-gradient(180deg, rgba(102,126,234,.7), rgba(102,126,234,.4))}
.timeline-bar.break{background:linear-gradient(180deg, rgba(246,183,60,.6), rgba(246,183,60,.3))}
.timeline-bar.action-clope{background:linear-gradient(180deg, rgba(255,77,77,.7), rgba(255,77,77,.4))}
.timeline-bar.action-manger{background:linear-gradient(180deg, rgba(255,93,143,.7), rgba(255,93,143,.4))}
.timeline-bar.action-sport{background:linear-gradient(180deg, rgba(60,255,122,.7), rgba(60,255,122,.4))}
.timeline-bar.action-glandouille{background:linear-gradient(180deg, rgba(155,92,255,.7), rgba(155,92,255,.4))}
.timeline-bar-label{
  position:absolute; top:50%; left:50%; transform:translate(-50%,-50%);
  font-size:.6rem; color:#fff; text-shadow:0 1px 2px rgba(0,0,0,.5);
  white-space:nowrap; pointer-events:none;
}
.timeline-now{
  position:absolute; top:18px; bottom:0; width:2px;
  background:var(--accent); box-shadow:0 0 6px var(--accent);
  z-index:20;
}

/* [WEB] textarea radius 8px */
textarea{width:100%; min-height:70vh; resize:vertical; background:rgba(16,22,29,.6); border:1px solid var(--border); color:var(--text); padding:12px; border-radius:8px; outline:none; font-family:inherit; transition:border-color .2s ease}
.input{
  /* [WEB] touch target 44px minimum, radius 4px */
  border:1px solid var(--border); background:rgba(16,22,29,.6); color:var(--text);
  min-height:2.75rem; padding:10px 12px; border-radius:4px; outline:none; font-family:inherit;
  transition:border-color .2s ease;
}
.input.invalid{border-color:rgba(255,122,122,.8); box-shadow:0 0 0 2px rgba(255,122,122,.2)}
.fieldHint{font-size:.8rem; color:var(--muted)}
.fieldHint.error{color:#ffb3b3}
/* [UX_BEHAVIORAL_PDF C11] Labels visibles au-dessus des champs */
.fieldLabel{display:block; font-size:.8125rem; color:var(--text); font-weight:600; margin-bottom:4px; letter-spacing:.2px}
.fieldGroup{display:flex; flex-direction:column; gap:2px}
.fieldRow{display:flex; align-items:flex-end; gap:8px; flex-wrap:wrap}
/* [WEB] margin 8px */
.firstsHero{margin:8px 0}
.firstsHero .seg{
  border-color:rgba(246,183,60,.35);
  background:linear-gradient(180deg, rgba(246,183,60,.08), rgba(16,22,29,.55));
  padding:8px 12px;
}
.firstsHero .muted{font-size:.875rem}
/* [WEB] gap 8px */
.firstsHead{display:flex; align-items:center; justify-content:space-between; gap:8px}
.firstsBadges{display:flex; flex-wrap:wrap; gap:8px; justify-content:flex-end}
.firstsBadge{
  /* [WEB] font .75rem, padding 8px 12px */
  font-size:.75rem; padding:8px 12px; border-radius:999px; border:1px solid var(--border);
  background:rgba(16,22,29,.6); color:var(--text); white-space:nowrap;
}
.firstsBadge.alcohol{border-color:rgba(246,183,60,.6); background:rgba(246,183,60,.12)}
.firstsBadge.clope{border-color:rgba(255,77,77,.6); background:rgba(255,77,77,.1)}
/* [WEB] gap 8px 16px */
.firstsList{display:grid; grid-template-columns:1.3fr 1fr; gap:8px 16px; margin-top:8px}
.firstCol{display:grid; gap:8px}
.firstCol + .firstCol{
  border-left:1px dashed rgba(255,255,255,.12);
  padding-left:12px;
}
.firstRow{
  /* [WEB] padding 8px, radius 8px */
  display:grid; grid-template-columns:104px 1fr; gap:8px; align-items:baseline;
  padding:8px; border-radius:8px;
  border:1px solid rgba(255,255,255,.08);
  background:rgba(16,22,29,.55);
}
/* [WEB] font .875rem */
.firstLabel{color:var(--muted); font-weight:700; letter-spacing:.2px; font-size:.875rem}
.firstValue{color:var(--text)}
.agendaBox{max-height:400px; overflow:auto}
.agenda-header{display:flex;justify-content:space-between;align-items:center;padding-bottom:var(--sp-8);border-bottom:1px solid var(--border);margin-bottom:var(--sp-12)}
.agenda-title{display:flex;align-items:center;gap:var(--sp-8);font-weight:700;font-size:1rem;color:var(--text)}
.agenda-clock{font-size:.875rem;color:var(--accent);font-variant-numeric:tabular-nums;font-weight:600}
.agenda-legend{display:flex;flex-wrap:wrap;gap:var(--sp-12);padding:var(--sp-8) 0;border-bottom:1px solid var(--border);margin-bottom:var(--sp-8)}
.agenda-legend-item{display:flex;align-items:center;gap:var(--sp-4);font-size:.75rem;color:var(--muted)}
.agenda-legend-dot{width:10px;height:10px;border-radius:50%}
.agenda-legend-dot.work{background:linear-gradient(135deg,#ff4fd8,#ff4fd8aa)}
.agenda-legend-dot.sleep{background:linear-gradient(135deg,#667eea,#667eeaaa)}
.agenda-legend-dot.break{background:linear-gradient(135deg,#f6b73c,#f6b73caa)}
.agenda-legend-dot.action{background:linear-gradient(135deg,#ff5d8f,#ff5d8faa)}
.agenda-toggle{display:flex;align-items:center;justify-content:space-between;padding:var(--sp-8) var(--sp-12);margin-top:var(--sp-8);background:rgba(16,22,29,.4);border:1px solid var(--border);border-radius:var(--r);cursor:pointer;transition:background .2s}
.agenda-toggle:hover{background:rgba(16,22,29,.6)}
.agenda-toggle:focus-visible{outline:2px solid var(--accent);outline-offset:2px}
.agenda-toggle-label{font-size:.875rem;color:var(--muted);font-weight:600}
.agenda-toggle-arrow{font-size:.75rem;color:var(--muted);transition:transform .2s}
.agenda-toggle[aria-expanded="true"] .agenda-toggle-arrow{transform:rotate(180deg)}
.agenda-details{max-height:0;overflow:hidden;transition:max-height .3s ease}
.agenda-details.open{max-height:500px}
/* [WEB] gap 8px */
.actionList{display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:8px; margin-top:8px}
.chip{
  /* [WEB] chips height 24px, padding 8px horizontal, radius 12px */
  display:flex; align-items:center; justify-content:space-between; gap:8px;
  padding:8px 12px; border:1px solid var(--border); border-radius:12px;
  background:rgba(16,22,29,.6); font-size:.875rem;
}
.chipLabel{color:var(--text); font-weight:700; letter-spacing:.2px}
.chipValue{
  color:var(--muted);
  font-variant-numeric:lining-nums tabular-nums;
  font-feature-settings:"lnum" 1, "tnum" 1;
}
.recentList{display:flex; flex-direction:column; gap:4px; margin-top:6px}
.recentItem{display:flex; justify-content:space-between; gap:10px; font-size:.75rem; color:var(--muted)}
.recentItem b{color:var(--text)}
/* [WEB] margin/gap 8px */
.weeksWrap{margin-top:8px; width:100%; position:relative}
.weeksTableHeader{
  --week-gap:12px;
  --delta-col:88px;
  margin-bottom:8px; margin-right:-8px; /* Gap + align with scroll */
  padding:0 16px 0 12px; /* Same horizontal padding as scroll content */
}
.weeksTableScroll{
  max-height:180px; /* Exactly 3 rows */
  overflow-y:auto;
  overflow-x:visible;
  padding:20px 16px 0 12px; /* 20px top for halo glow */
  margin-right:-8px;
  scrollbar-width:thin;
  scrollbar-color:rgba(91,178,255,.4) transparent;
}
.weeksTableScroll::-webkit-scrollbar{width:6px; margin-right:4px}
.weeksTableScroll::-webkit-scrollbar-track{background:transparent}
.weeksTableScroll::-webkit-scrollbar-thumb{background:rgba(91,178,255,.35); border-radius:3px}
.weeksTableScroll::-webkit-scrollbar-thumb:hover{background:rgba(91,178,255,.55)}
.weeksTable{
  --week-gap:12px;
  --delta-col:88px;
  display:flex; flex-direction:column; gap:8px;
  width:100%;
}
.weekLine{
  display:grid; grid-template-columns:1fr var(--delta-col);
  column-gap:8px; align-items:stretch;
}
.weekRow{
  /* [WEB] padding 12px, radius 8px, grille uniforme */
  display:grid; width:100%;
  grid-template-columns:100px 110px 1fr 1fr 1fr 1fr;
  column-gap:var(--week-gap); align-items:center; padding:12px 16px;
  border:1px solid var(--border); border-radius:8px;
  background:rgba(16,22,29,.55);
  position:relative;
}
.weekRow.head{
  background:rgba(16,22,29,.7); border-color:rgba(255,255,255,.08);
  padding:16px;
}
/* [WEB] font-size .875rem, alignement uniforme */
.weekCell{font-size:.875rem; color:var(--text); display:flex; align-items:center}
.weekCell.num{
  font-variant-numeric:lining-nums tabular-nums;
  font-feature-settings:"lnum" 1, "tnum" 1;
  justify-content:center;
}
.weekCell.doseCell{
  justify-content:center;
}
.weekCell.doseHead{
  justify-content:center;
}
.weekRow.head .weekCell.num{
  justify-content:center;
}
.wkCount{
  display:inline-flex; align-items:center; justify-content:center;
  min-width:32px; font-variant-numeric:tabular-nums; font-weight:600;
  font-size:.9rem;
}
.trend-arrow{font-size:.7em; margin-left:3px; opacity:.85}
.wkLiters{min-width:0; color:var(--muted)}
.doseBox{
  display:inline-flex; align-items:center; justify-content:center;
  min-width:56px; font-variant-numeric:tabular-nums; font-weight:600;
  font-size:.9rem;
}
.whisky-icon{display:inline-block;width:20px;height:20px;vertical-align:middle;margin-right:3px;filter:drop-shadow(0 1px 2px rgba(0,0,0,.3))}
.alc-icon{font-size:1rem;margin-right:2px;vertical-align:middle}
.weekDelta{
  display:flex; align-items:center; justify-content:center;
  padding:12px 8px; border-radius:8px;
  font-size:.8rem; font-weight:700; letter-spacing:.2px; font-variant-numeric:tabular-nums;
  border:1px solid rgba(255,255,255,.12);
  background:rgba(16,22,29,.4);
  min-height:48px; box-sizing:border-box;
}
.weekLine.headLine{
  /* Header is now outside scroll container - no sticky needed */
}
.weekLine.headLine .weekDelta{
  background:transparent; border-color:transparent; min-height:auto;
}
.weekDelta--empty{
  background:transparent; border-color:transparent; box-shadow:none;
}
.weekRow.head .weekCell{color:var(--text); font-weight:700; letter-spacing:.3px}
.weekRow:not(.head) .weekCell{color:var(--text)}
.weekRow:not(.head) .weekCell.olderWeek{color:var(--muted)}
.weekRow.currentWeek{
  border-color:rgba(91,178,255,.45);
  background:linear-gradient(135deg, rgba(91,178,255,.08), rgba(16,22,29,.55));
  box-shadow:0 0 0 1px rgba(91,178,255,.12) inset, 0 4px 12px rgba(0,0,0,.2), 0 0 10px rgba(91,178,255,.12);
  animation:currentWeekPulse 3s ease-in-out infinite;
}
@keyframes currentWeekPulse{
  0%,100%{box-shadow:0 0 0 1px rgba(91,178,255,.12) inset, 0 4px 12px rgba(0,0,0,.2), 0 0 10px rgba(91,178,255,.12)}
  50%{box-shadow:0 0 0 1px rgba(91,178,255,.18) inset, 0 4px 12px rgba(0,0,0,.2), 0 0 15px rgba(91,178,255,.18)}
}
.weekRow.currentWeek::before{
  content:""; position:absolute; left:0; top:12px; bottom:12px; width:3px;
  background:linear-gradient(180deg, rgba(91,178,255,.9), rgba(91,178,255,.3));
  border-radius:3px;
  box-shadow:0 0 8px rgba(91,178,255,.5);
}
.weekRow.head .weekCell:nth-child(2){
  text-align:center;
}
.weekRow.head .weekCell:nth-child(3),
.weekRow.head .weekCell:nth-child(4),
.weekRow.head .weekCell:nth-child(5){
  justify-content:center;
  text-align:center;
}
.weekRow:not(.head) .weekCell:nth-child(2){
  text-align:center;
}
.weekRow:not(.head) .weekCell:nth-child(3),
.weekRow:not(.head) .weekCell:nth-child(4),
.weekRow:not(.head) .weekCell:nth-child(5){
  justify-content:center;
  text-align:center;
}
/* [WEB] margin 8px, radius 8px, padding 12px */
.miniNoteWrap{margin-top:8px; border:1px solid var(--border); border-radius:8px; background:rgba(16,22,29,.6)}
.miniNote{width:100%; min-height:72px; resize:vertical; background:transparent; border:none; color:var(--text); padding:12px; outline:none; font-family:inherit}
/* [UX_PRO] Chart wrapper - responsive height avec aspect ratio */
.chartWrap{height:auto; min-height:200px; margin-top:var(--sp-16); border-radius:var(--r); background:rgba(16,22,29,.4); padding:var(--sp-12); border:1px solid rgba(255,255,255,.04)}
#monthChart{width:100%; display:block; cursor:crosshair}

/* [UX_PRO] Chart Tooltip - glassmorphism + color-coded rows */
.chartTooltip{position:fixed;z-index:3000;min-width:220px;max-width:260px;padding:0;
  background:linear-gradient(165deg,rgba(16,20,28,.98),rgba(22,28,38,.98));
  backdrop-filter:blur(20px);-webkit-backdrop-filter:blur(20px);
  border:1px solid rgba(91,178,255,.15);border-radius:14px;
  box-shadow:0 20px 60px rgba(0,0,0,.6),0 0 0 1px rgba(255,255,255,.04) inset,0 0 30px rgba(91,178,255,.06);
  opacity:0;visibility:hidden;transform:translateY(6px) scale(0.97);
  transition:opacity .15s ease,transform .15s ease,visibility .15s ease;pointer-events:none;overflow:hidden}
.chartTooltip.visible{opacity:1;visibility:visible;transform:translateY(0) scale(1)}
.chartTooltip .ttHeader{padding:10px 14px 8px;font-weight:800;font-size:.8rem;color:rgba(231,237,243,.4);letter-spacing:.06em;text-transform:uppercase}
.chartTooltip .ttGrid{padding:2px 10px 8px}
.chartTooltip .ttRow{display:flex;align-items:center;gap:8px;padding:5px 6px;border-radius:8px;border-left:3px solid transparent}
.chartTooltip .ttRow--work{border-left-color:#ff2d8a}
.chartTooltip .ttRow--sleep{border-left-color:#3a6fff}
.chartTooltip .ttRow--sport{border-left-color:#00d672}
.chartTooltip .ttRow--marche{border-left-color:#00d672}
.chartTooltip .ttRow--reveil{border-left-color:#ffaa22}
.chartTooltip .ttRow.addiction{border-left-color:transparent;background:rgba(255,255,255,.03);margin-top:2px}
.chartTooltip .ttRow.addiction--clope{border-left-color:#ff4040}
.chartTooltip .ttRow.addiction--alc{border-left-color:#ffaa22}
.chartTooltip .ttIcon{font-size:.9rem;width:20px;text-align:center;flex-shrink:0}
.chartTooltip .ttLabel{font-size:.8rem;color:rgba(231,237,243,.5);flex:1}
.chartTooltip .ttVal{font-size:.85rem;font-weight:700;color:#fff;text-align:right;font-variant-numeric:tabular-nums}
.chartTooltip .ttTime{font-size:.7rem;color:var(--accent);font-variant-numeric:tabular-nums;margin-left:4px}
.chartTooltip .ttDivider{height:1px;background:linear-gradient(90deg,transparent,rgba(91,178,255,.15),transparent);margin:6px 10px}

/* [WEB.md §21,22] Legend - touch targets 44px WCAG 2.5.8, contraste */
.legend{
  display:flex;
  gap:var(--sp-12);
  flex-wrap:wrap;
  font-size:.875rem;
  /* [WEB.md §22] Meilleur contraste */
  color:#c5cdd5;
  margin-top:var(--sp-16);
  padding:var(--sp-16);
  background:rgba(16,22,29,.4);
  border-radius:var(--r);
  border:1px solid rgba(255,255,255,.06);
}
/* [WEB.md §21] Touch target min 44px */
.legend>span{
  display:inline-flex;
  align-items:center;
  min-height:44px;
  padding:var(--sp-8) var(--sp-12);
  border-radius:8px;
  transition:background var(--transition-fast) ease;
  cursor:pointer;
}
.legend>span:hover{background:rgba(255,255,255,.08)}
.legend>span:focus-visible{
  outline:2px solid var(--accent);
  outline-offset:2px;
}
.legendDot{
  width:14px;
  height:14px;
  border-radius:999px;
  display:inline-block;
  margin-right:var(--sp-8);
  box-shadow:0 0 10px currentColor;
  /* [WEB.md §22] Bordure pour contraste composant UI 3:1 */
  border:1px solid rgba(255,255,255,.2);
}
@media (prefers-reduced-motion:reduce){
  .legend>span{transition:none}
}

/* [WEB.md §16,21,36-40] KPI Grid - responsive avec touch targets WCAG 2.5.8 */
.kpiGrid{
  display:grid;
  /* [WEB.md §40] Grille responsive 12 colonnes adaptée */
  grid-template-columns:repeat(auto-fit,minmax(min(200px,100%),1fr));
  gap:var(--sp-16);
  margin-top:var(--sp-20);
}
/* [WEB.md §21] Touch target min 44px pour accessibilité */
.kpiTile{
  position:relative;
  /* [WEB.md §39] Card padding 16px, border-radius 8-12px */
  min-height:120px; /* assure touch target vertical */
  border:1px solid rgba(255,255,255,.1);
  border-radius:12px;
  padding:var(--sp-20);
  background:linear-gradient(145deg,rgba(22,28,38,.9),rgba(16,22,29,.7));
  backdrop-filter:blur(8px);
  -webkit-backdrop-filter:blur(8px);
  /* [WEB.md §41] Transition 200-300ms */
  transition:transform var(--transition-normal) ease,
             box-shadow var(--transition-normal) ease,
             border-color var(--transition-normal) ease;
  overflow:hidden;
}
.kpiTile::before{
  content:"";
  position:absolute;
  top:0;left:0;right:0;
  height:3px;
  background:linear-gradient(90deg,var(--accent),var(--blue));
  opacity:0;
  transition:opacity var(--transition-normal) ease;
}
/* [WEB.md §32-34] Hover: brightness+saturate */
.kpiTile:hover{
  transform:translateY(-4px);
  box-shadow:0 12px 32px rgba(0,0,0,.5);
  border-color:rgba(107,188,255,.3);
}
.kpiTile:hover::before{opacity:1}
/* [WEB.md §23] Focus visible WCAG 2.4.7/2.4.13 - outline 2px + offset 2px + contrast 3:1 */
.kpiTile:focus-visible{
  outline:2px solid var(--accent);
  outline-offset:2px;
  box-shadow:0 0 0 4px rgba(53,217,154,.25);
}

/* [WEB.md §42] KPI Icon - 24-32px pour lisibilité */
.kpiIcon{
  font-size:1.75rem;
  margin-bottom:var(--sp-12);
  filter:drop-shadow(0 2px 6px rgba(0,0,0,.4));
  line-height:1;
}

/* [WEB.md §22,38] KPI Label - contraste WCAG 1.4.3 (4.5:1 sur fond sombre) */
.kpiLabel{
  display:flex;
  align-items:center;
  gap:var(--sp-8);
  /* [WEB.md §38] text-xs = 12px minimum pour lisibilité */
  font-size:.75rem;
  /* Amélioration contraste: #c5cdd5 vs #121820 = ~8:1 */
  color:#c5cdd5;
  text-transform:uppercase;
  letter-spacing:.5px;
  margin-bottom:var(--sp-8);
  font-weight:600;
}

/* [WEB.md §38] KPI Value - text-2xl/3xl pour impact visuel */
.kpiVal{
  font-size:clamp(1.5rem, 4vw, 2rem);
  font-weight:800;
  /* Meilleur contraste: blanc pur sur fond sombre = ~15:1 */
  color:#fff;
  line-height:1.2;
  letter-spacing:-.5px;
}

/* [WEB.md §22] KPI Delta - indicateurs avec contraste WCAG 1.4.11 (3:1 composants) */
.kpiDelta{
  display:inline-flex;
  align-items:center;
  gap:var(--sp-4);
  font-size:.8125rem;
  font-weight:500;
  margin-top:var(--sp-12);
  padding:var(--sp-4) var(--sp-12);
  border-radius:999px;
  /* [WEB.md §22] Bordure pour non-text contrast 3:1 */
  border:1px solid transparent;
}
/* Amélioration = mauvais (moins de sommeil, plus de clopes) */
.kpiDelta.up{
  color:#ff8fa3;
  background:rgba(255,107,138,.12);
  border-color:rgba(255,107,138,.3);
}
.kpiDelta.up::before{content:"\2191 ";font-weight:700}
/* Amélioration = bon (plus de travail, moins de clopes) */
.kpiDelta.down{
  color:#6bffc0;
  background:rgba(107,255,192,.12);
  border-color:rgba(107,255,192,.3);
}
.kpiDelta.down::before{content:"\2193 ";font-weight:700}
/* Flat = neutre */
.kpiDelta.flat{
  color:#a7b3bf;
  background:rgba(255,255,255,.05);
  border-color:rgba(255,255,255,.1);
}
.kpiDelta.flat::before{content:"\2194 ";font-weight:700}

/* [WEB.md §27] Respect prefers-reduced-motion WCAG 2.3.3 */
@media (prefers-reduced-motion:reduce){
  .kpiTile,.kpiTile::before{transition:none}
  .kpiTile:hover{transform:none}
}

/* [WEB.md §22] Support forced-colors/high-contrast mode */
@media (forced-colors:active){
  .kpiTile{border:2px solid CanvasText}
  .kpiDelta{border:1px solid CanvasText}
  .kpiVal{color:CanvasText}
}

/* [WEB.md §2,18] Notes Box - insights avec empty states */
.notesBox{
  margin-top:var(--sp-20);
  border:1px solid rgba(255,255,255,.08);
  border-radius:12px;
  padding:var(--sp-20);
  background:linear-gradient(145deg,rgba(22,28,38,.8),rgba(16,22,29,.6));
  backdrop-filter:blur(4px);
  -webkit-backdrop-filter:blur(4px);
}
.notesBox .sectionLabel{
  display:flex;
  align-items:center;
  gap:var(--sp-8);
  font-size:.8125rem;
  text-transform:uppercase;
  letter-spacing:.5px;
  /* [WEB.md §22] Meilleur contraste */
  color:#c5cdd5;
  margin-bottom:var(--sp-16);
  padding-bottom:var(--sp-12);
  border-bottom:1px solid rgba(255,255,255,.08);
  font-weight:600;
}
/* [WEB.md §21] Touch target min 44px */
.notesLine{
  display:flex;
  align-items:flex-start;
  gap:var(--sp-12);
  font-size:.9375rem;
  color:var(--text);
  /* [WEB.md §21] Min-height 44px pour touch */
  min-height:44px;
  padding:var(--sp-12) var(--sp-16);
  margin:var(--sp-8) 0;
  background:rgba(255,255,255,.03);
  border-radius:8px;
  border-left:3px solid var(--accent);
  transition:background var(--transition-fast) ease;
}
.notesLine:hover{background:rgba(255,255,255,.06)}
.notesLine:focus-within{
  outline:2px solid var(--accent);
  outline-offset:2px;
}
.notesLine .noteIcon{
  flex-shrink:0;
  font-size:1.125rem;
  line-height:1.4;
}
.notesLine .noteText{
  flex:1;
  line-height:1.5;
}
@media (prefers-reduced-motion:reduce){
  .notesLine{transition:none}
}
.loadingBar{position:fixed; top:0; left:0; right:0; height:3px; background:rgba(255,255,255,.06); opacity:0; pointer-events:none; z-index:2000; transition:opacity .2s ease}
.loadingBar.active{opacity:1}
.loadingBarInner{height:100%; width:30%; background:linear-gradient(90deg, rgba(107,188,255,.2), rgba(107,188,255,.9), rgba(107,188,255,.2)); animation:loadingMove 1.2s linear infinite}
@keyframes loadingMove{0%{transform:translateX(-100%)}100%{transform:translateX(300%)}}
.offlineBanner{position:fixed; top:8px; left:50%; transform:translateX(-50%); background:rgba(255,122,122,.15); border:1px solid rgba(255,122,122,.45); color:#ffd6d6; padding:6px 12px; border-radius:999px; font-size:.875rem; display:none; z-index:2000}
.offlineBanner.show{display:block}
.offlineBanner .btn{min-height:1.75rem; padding:4px 10px; margin-left:8px}
.toastHost{position:fixed; right:16px; bottom:16px; display:flex; flex-direction:column; gap:8px; z-index:2000}
.toast{background:rgba(18,24,32,.95); border:1px solid var(--border); border-left:4px solid var(--blue); color:var(--text); padding:10px 12px; border-radius:10px; min-width:240px; box-shadow:0 8px 24px rgba(0,0,0,.35)}
.toast.success{border-left-color:var(--accent)}
.toast.error{border-left-color:var(--danger)}
.toast.warn{border-left-color:var(--warn)}
.toastTitle{font-weight:800; font-size:.9rem}
.toastMsg{font-size:.85rem; color:var(--muted); margin-top:2px}
/* [WEB.md §2] Empty States - structure standard */
.emptyState{
  border:1px dashed rgba(255,255,255,.15);
  border-radius:12px;
  padding:var(--sp-24);
  margin-top:var(--sp-16);
  background:rgba(16,22,29,.6);
  color:var(--muted);
  text-align:center;
}
/* [WEB.md §2] Illustration + titre + description + CTA */
.emptyTitle{
  color:var(--text);
  font-weight:700;
  font-size:1rem;
  margin-bottom:var(--sp-8);
}
.emptyDesc{
  font-size:.9375rem;
  line-height:1.5;
  max-width:320px;
  margin:0 auto;
}
/* [WEB.md §21] CTA avec touch target 44px */
.emptyCta{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  min-height:44px;
  margin-top:var(--sp-16);
  padding:var(--sp-8) var(--sp-16);
  font-size:.9375rem;
  color:var(--blue);
  border:1px solid var(--blue);
  border-radius:8px;
  transition:background var(--transition-fast) ease;
}
.emptyCta:hover{background:rgba(107,188,255,.1)}
.emptyCta:focus-visible{
  outline:2px solid var(--blue);
  outline-offset:2px;
}
/* [UX_BEHAVIORAL_PDF A5] Disabled States - feedback visuel clair */
.btn:disabled{cursor:not-allowed; opacity:.55; filter:grayscale(30%)}
.btn:disabled:hover{transform:none; box-shadow:none}
.btn:disabled[title]{position:relative}
.btn:disabled[title]:hover::after{
  content:attr(title); position:absolute; bottom:calc(100% + 8px); left:50%; transform:translateX(-50%);
  background:rgba(12,16,22,.95); color:var(--warn); padding:6px 10px; border-radius:6px; font-size:.75rem;
  white-space:nowrap; box-shadow:0 4px 12px rgba(0,0,0,.4); border:1px solid rgba(247,191,84,.35); z-index:1000;
}
.btn.ghost{background:transparent; border-color:rgba(255,255,255,.25); color:var(--text)}
.btn.ghost:hover{background:rgba(255,255,255,.08)}
.callout{
  border:1px solid rgba(91,178,255,.45);
  background:rgba(91,178,255,.08);
  border-radius:10px;
  padding:10px 12px;
  margin:10px 0;
}
.calloutTitle{font-weight:800}
.calloutDesc{font-size:.9rem; color:var(--muted)}
/* [UX] Help tooltip - hover (PC) + tap (mobile) */
.help{
  display:inline-flex; align-items:center; justify-content:center;
  width:16px; height:16px; border-radius:999px;
  border:1px solid rgba(255,255,255,.15); color:rgba(231,237,243,.35); font-size:.65rem; font-weight:600;
  margin-left:4px; vertical-align:middle;
  cursor:pointer; position:relative;
  -webkit-tap-highlight-color:transparent;
  user-select:none;
  transition:all 150ms ease;
}
.help:hover{color:var(--text); border-color:rgba(255,255,255,.5); background:rgba(255,255,255,.06)}
.help::after{
  content:attr(data-tip);
  position:absolute; bottom:calc(100% + 8px); left:50%;
  transform:translateX(-50%);
  background:rgba(18,24,32,.95); border:1px solid var(--border);
  border-radius:6px; padding:8px 12px;
  font-size:.8125rem; color:var(--text); white-space:nowrap;
  max-width:240px; white-space:normal; text-align:center;
  box-shadow:0 4px 12px rgba(0,0,0,.4);
  opacity:0; visibility:hidden;
  transition:opacity var(--transition-fast) ease, visibility var(--transition-fast) ease;
  pointer-events:none; z-index:1000;
}
.help::before{
  content:"";
  position:absolute; bottom:calc(100% + 2px); left:50%;
  transform:translateX(-50%);
  border:6px solid transparent; border-top-color:rgba(18,24,32,.95);
  opacity:0; visibility:hidden;
  transition:opacity var(--transition-fast) ease;
  z-index:1001;
}
/* PC: hover */
.help:hover::after,.help:hover::before{opacity:1;visibility:visible}
/* Mobile: tap (class toggled by JS) */
.help.active::after,.help.active::before{opacity:1;visibility:visible}
/* Position adjustment si tooltip depasse */
@media(max-width:480px){
  .help::after{left:auto;right:-8px;transform:none;max-width:200px}
  .help::before{left:auto;right:12px;transform:none}
}
.skeleton{position:relative; overflow:hidden; background:rgba(255,255,255,.05)}
/* [WEB §R Rule 91] Skeleton shimmer 1.5-2s cycle */
.skeleton::after{
  content:""; position:absolute; inset:0;
  background:linear-gradient(90deg, transparent, rgba(255,255,255,.12), transparent);
  transform:translateX(-100%); animation:skeletonMove 1.8s ease-in-out infinite;
}
@keyframes skeletonMove{0%{transform:translateX(-100%)}100%{transform:translateX(100%)}}
/* [UX_PRO] Skeleton lines pour loading states */
.skeleton-line{display:inline-block;background:rgba(255,255,255,.06);position:relative;overflow:hidden;border-radius:4px}
.skeleton-line::after{content:"";position:absolute;inset:0;background:linear-gradient(90deg,transparent,rgba(255,255,255,.1),transparent);transform:translateX(-100%);animation:skeletonMove 1.8s ease-in-out infinite}
.disclose{display:none}
.disclose.show{display:block}
/* [skip_link_wcag_2_4_1] skip link */
.skip-link{position:absolute;top:-40px;left:0;background:var(--accent);color:#000;padding:.5rem 1rem;z-index:100;border-radius:0 0 8px 0;font-weight:700;text-decoration:none}
.skip-link:focus{top:0}
/* [form_label_wcag_1_3_1] visually hidden labels */
.sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}
/* [reduced_motion_wcag] respect user preference */
@media(prefers-reduced-motion:reduce){
  *,*::before,*::after{animation-duration:.01ms!important;animation-iteration-count:1!important;transition-duration:.01ms!important;scroll-behavior:auto!important}
}
/* [UX_PDF] Ripple effect - feedback visuel immediat au clic */
.btn{position:relative;overflow:hidden}
.ripple{position:absolute;border-radius:50%;background:rgba(255,255,255,.4);transform:scale(0);animation:rippleAnim .5s ease-out;pointer-events:none}
@keyframes rippleAnim{to{transform:scale(4);opacity:0}}
/* [UX_PDF] Success pulse - confirmation visuelle */
.btn.success-pulse{animation:successPulse .4s ease}
@keyframes successPulse{
  0%{box-shadow:0 0 0 0 rgba(53,217,154,.7)}
  70%{box-shadow:0 0 0 12px rgba(53,217,154,0)}
  100%{box-shadow:0 0 0 0 rgba(53,217,154,0)}
}
/* [UX_PDF] Tooltip contextuel */
.tooltip{position:relative}
.tooltip::before{
  content:attr(data-tooltip);position:absolute;bottom:calc(100% + 8px);left:50%;transform:translateX(-50%);
  background:rgba(12,16,22,.95);color:var(--text);padding:6px 10px;border-radius:6px;font-size:.75rem;
  white-space:nowrap;opacity:0;visibility:hidden;transition:opacity .2s ease,visibility .2s ease;
  box-shadow:0 4px 12px rgba(0,0,0,.4);border:1px solid var(--border);z-index:1000;pointer-events:none;
}
.tooltip::after{
  content:"";position:absolute;bottom:calc(100% + 2px);left:50%;transform:translateX(-50%);
  border:6px solid transparent;border-top-color:rgba(12,16,22,.95);
  opacity:0;visibility:hidden;transition:opacity .2s ease,visibility .2s ease;
}
.tooltip:hover::before,.tooltip:hover::after{opacity:1;visibility:visible}
/* [UX_PDF] Micro-interaction checkmark */
.checkAnim{display:inline-block;width:20px;height:20px;position:relative}
.checkAnim::after{
  content:"";position:absolute;left:6px;top:2px;width:6px;height:12px;
  border:solid var(--accent);border-width:0 3px 3px 0;transform:rotate(45deg) scale(0);
  animation:checkPop .3s ease forwards;
}
@keyframes checkPop{to{transform:rotate(45deg) scale(1)}}
/* [UX_PDF] Badge notification */
.badge{
  position:absolute;top:-4px;right:-4px;min-width:18px;height:18px;
  background:var(--danger);color:#fff;font-size:.7rem;font-weight:800;
  border-radius:999px;display:flex;align-items:center;justify-content:center;
  box-shadow:0 2px 6px rgba(255,77,77,.4);
}
.badge.pulse{animation:badgePulse 1.5s ease-in-out infinite}
@keyframes badgePulse{0%,100%{transform:scale(1)}50%{transform:scale(1.1)}}
/* [UX_BEHAVIORAL_PDF] Shake effect pour inputs invalides */
.input.shake{animation:shakeInput .4s ease}
@keyframes shakeInput{
  0%,100%{transform:translateX(0)}
  20%{transform:translateX(-6px)}
  40%{transform:translateX(6px)}
  60%{transform:translateX(-4px)}
  80%{transform:translateX(4px)}
}
/* [UX_BEHAVIORAL_PDF] Loading spinner sur bouton */
.btn.loading{pointer-events:none;opacity:.7}
.btn.loading::after{
  content:"";position:absolute;width:16px;height:16px;
  border:2px solid rgba(255,255,255,.3);border-top-color:#fff;
  border-radius:50%;animation:btnSpin .6s linear infinite;
  right:8px;top:50%;margin-top:-8px;
}
@keyframes btnSpin{to{transform:rotate(360deg)}}
/* [UX_BEHAVIORAL_PDF] Focus glow améliore le feedback tactile */
.btn:active:not(:disabled){transform:scale(0.97)}
/* [UX_BEHAVIORAL_PDF] Transition douce pour les états */
.input,.btn,.card,.seg,.pill{transition:all var(--transition-normal,200ms) ease}

/* [WCAG_2.4.11] Focus Appearance - zone minimale 4px² */
:focus-visible{
  outline:2px solid var(--blue);
  outline-offset:2px;
  border-radius:inherit;
}
.btn:focus-visible,.pill:focus-visible,.input:focus-visible,select:focus-visible,textarea:focus-visible{
  outline:2px solid var(--accent);
  outline-offset:2px;
  box-shadow:0 0 0 4px rgba(53,217,154,.25);
}

/* [UI_RULEBOOK] High Contrast Mode - améliore lisibilité */
@media(prefers-contrast:more){
  :root{
    --bg:#000;
    --panel:#0a0a0a;
    --panel-2:#111;
    --border:#fff;
    --text:#fff;
    --muted:#ccc;
  }
  .btn,.pill,.card,.seg,.input,select,textarea{
    border-width:2px;
    border-color:#fff;
  }
  .btn:hover,.pill:hover{
    background:#fff;
    color:#000;
  }
  .btn:focus-visible,.pill:focus-visible,.input:focus-visible{
    outline-width:3px;
    outline-color:#fff;
  }
  .muted{color:#ccc}
  .progress{border:2px solid #fff}
  .progress div{background:#fff}
}

/* [UI_RULEBOOK] Forced Colors Mode - respect des couleurs système */
@media(forced-colors:active){
  .btn,.pill,.card,.seg,.input,select,textarea{
    border:2px solid CanvasText;
    background:Canvas;
    color:CanvasText;
  }
  .btn:hover,.pill:hover{
    background:Highlight;
    color:HighlightText;
  }
  .btn:focus-visible,.pill:focus-visible,.input:focus-visible{
    outline:3px solid Highlight;
  }
  .btn:disabled{
    opacity:1;
    border-style:dashed;
  }
  .progress{border:2px solid CanvasText}
  .progress div{background:Highlight}
  .status.ok{forced-color-adjust:none;background:green}
  .status.ko{forced-color-adjust:none;background:red}
}

/* [WEB §E Rule 21] Touch target 44px recommended - invisible padding extends hit area */
.help{min-width:16px;min-height:16px;width:16px;height:16px;padding:14px;box-sizing:content-box}
.legendDot{min-width:12px;min-height:12px}
a.pill,button.btn{min-width:44px;min-height:44px}
.recentItem{min-height:24px}

/* [WCAG_1.4.12] Text Spacing - support user overrides */
body{
  line-height:1.5;
  letter-spacing:normal;
  word-spacing:normal;
}

/* [UI_RULEBOOK] Scrollbar styling - better visibility */
::-webkit-scrollbar{width:8px;height:8px}
::-webkit-scrollbar-track{background:rgba(255,255,255,.05);border-radius:4px}
::-webkit-scrollbar-thumb{background:rgba(255,255,255,.2);border-radius:4px}
::-webkit-scrollbar-thumb:hover{background:rgba(255,255,255,.35)}
@supports(scrollbar-color:auto){
  *{scrollbar-color:rgba(255,255,255,.2) rgba(255,255,255,.05);scrollbar-width:thin}
}
</style>
</head>
<body>
<!-- [skip_link_wcag_2_4_1] -->
<a href="#main-content" class="skip-link">Aller au contenu</a>
<div id="globalLoading" class="loadingBar" aria-hidden="true"><div class="loadingBarInner"></div></div>
<div id="offlineBanner" class="offlineBanner" role="status" aria-live="polite">
  Hors ligne : mise a jour pausee
  <button class="btn ghost" id="offlineRetry" type="button">Reessayer</button>
  <button class="btn ghost" onclick="syncOfflineQueue();showToast('Sync lancé','info')">Sync queue</button>
</div>
<div id="toastHost" class="toastHost" aria-live="polite" aria-atomic="true"></div>
<!-- [landmark_wcag_1_3_1] -->
<div class="container">
  <!-- [landmark_wcag_1_3_1] nav - compact single line -->
  <nav class="topbar reveal d1" aria-label="Navigation principale">
    <div class="brand">
      <span class="hb-dot __HBCLASS__" title="Heartbeat: __HB__"></span>
      <h1 style="font-weight:800;font-size:.875rem;margin:0">InfernalWheel</h1>
      <span class="tag">__TODAY__</span>
      <span class="tag" style="opacity:.6">:__PORT__</span>
      <span id="offlineCount" class="tag" style="display:none;background:rgba(247,191,84,.15);color:var(--warn)"></span>
    </div>
    <div class="nav-links">
      <a class="nav-link nav-primary" href="/notes"><svg style="width:14px;height:14px;margin-right:4px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><path d="M14 2v6h6"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>Notes</a>
      <a class="nav-link nav-date" href="/?m=__PREVYM__">&larr; __PREVYM__</a>
      <a class="nav-link nav-date" href="/?m=__NEXTYM__">__NEXTYM__ &rarr;</a>
    </div>
  </nav>

  <!-- [landmark_wcag_1_3_1] main + [skip_link_wcag_2_4_1] target -->
  <main id="main-content">
  <div class="card reveal d2" id="liveCard">
    <h2>Live</h2>
    <div id="onboarding" class="callout" style="display:none">
      <div class="calloutTitle">Bienvenue</div>
      <div class="calloutDesc">Commence par START / WORK / DODO puis utilise les actions. Tu peux ecrire une note rapide ici.</div>
      <div class="row" style="margin-top:8px">
        <button class="btn ghost" id="onboardDismiss">Compris</button>
      </div>
    </div>
    <div id="firstsToday" class="firstsHero"></div>
    <div class="kpi">
      <div class="box" role="region" aria-label="Travail restant">
        <div class="box-header">
          <div class="box-title"><span class="box-title-icon progressEmoji" id="progressEmoji" aria-hidden="true">&#128564;</span><span>WORK Remaining</span></div>
          <span class="box-subtitle">minutes</span>
        </div>
        <div class="box-stats">
          <div class="box-stat"><div class="box-stat-icon" aria-hidden="true">&#127919;</div><div class="box-stat-value" id="statGoal">__GOALM__</div><div class="box-stat-label">Objectif</div></div>
          <div class="box-stat"><div class="box-stat-icon" aria-hidden="true">&#9989;</div><div class="box-stat-value accent" id="statDone">__DONEM__</div><div class="box-stat-label">Fait</div></div>
          <div class="box-stat"><div class="box-stat-icon" aria-hidden="true">&#9749;</div><div class="box-stat-value warn" id="statBreak">__OVERM__</div><div class="box-stat-label">Pause</div></div>
        </div>
        <div class="box-remain"><div class="box-remain-value" id="kRemain">__REM__m</div><div class="box-remain-label">restant</div></div>
        <div class="box-progress"><span class="box-progress-pct" id="progressPct">0%</span><div class="box-progress-bar" id="bar" style="width:0%"></div></div>
        <div class="box-divider"></div>
        <div class="miniNoteWrap">
          <label for="quickNote" class="sr-only">Note rapide</label>
          <textarea id="quickNote" class="miniNote" placeholder="Note rapide..." aria-label="Note rapide"></textarea>
          <small id="quickNoteStatus" class="muted" role="status" aria-live="polite">-</small>
        </div>
      </div>
      <div class="box currentBox" id="currentBox" role="region" aria-label="Action en cours">
        <div class="box-header">
          <div class="box-title"><span class="box-title-icon" aria-hidden="true">&#9654;&#65039;</span><span>Action en cours</span></div>
          <div class="box-action-flags" id="kSeg2"></div>
        </div>
        <div class="box-action-row"><div class="box-action-main" id="kSeg">-</div></div>
        <div class="box-timer" id="kTimerWrap">
          <div class="box-timer-item"><div class="box-timer-value" id="kTimerElapsed">-</div><div class="box-timer-label">Elapsed</div></div>
          <div class="box-timer-item"><div class="box-timer-value" id="kTimerRemain">-</div><div class="box-timer-label">Restant</div></div>
        </div>
        <div class="box-divider"></div>
        <div class="miniNoteWrap">
          <label for="scratchNote" class="sr-only">Note action</label>
          <textarea id="scratchNote" class="miniNote" placeholder="Note action..." aria-label="Note action"></textarea>
          <small id="actionNoteStatus" class="muted" role="status" aria-live="polite">-</small>
        </div>
      </div>
    <div class="box agendaBox" role="region" aria-label="Agenda du jour">
      <div class="agenda-header">
        <div class="agenda-title">
          <span aria-hidden="true">&#128337;</span>
          <span>Agenda du jour</span>
          <span class="help" data-tip="Timeline visuelle de votre journ&eacute;e.">?</span>
        </div>
        <div class="agenda-clock" id="agendaClock" aria-live="off">--:--</div>
      </div>
      <div id="agendaTimeline">__TIMELINE__</div>
      <div class="agenda-legend" aria-label="L&eacute;gende">
        <div class="agenda-legend-item"><span class="agenda-legend-dot work"></span><span>Work</span></div>
        <div class="agenda-legend-item"><span class="agenda-legend-dot sleep"></span><span>Sleep</span></div>
        <div class="agenda-legend-item"><span class="agenda-legend-dot break"></span><span>Pause</span></div>
        <div class="agenda-legend-item"><span class="agenda-legend-dot action"></span><span>Actions</span></div>
      </div>
      <button class="agenda-toggle" aria-expanded="false" aria-controls="agendaDetails" id="agendaToggle">
        <span class="agenda-toggle-label" id="agendaCount">D&eacute;tails</span>
        <span class="agenda-toggle-arrow" aria-hidden="true">&#9660;</span>
      </button>
      <div class="agenda-details" id="agendaDetails">
        <div id="actionsToday">__ACTIONS_TODAY__</div>
        <div id="drinkToday"></div>
        <div id="smokeToday"></div>
      </div>
    </div>
    </div>
  </div>

  <div class="card reveal d3 alcCard">
    <div class="alcHeader">
      <div class="alcHeader__left">
        <h2><span class="alcTitleIcon" aria-hidden="true">&#127864;</span>Alcool</h2>
      </div>
    </div>
    <div class="weeksTable">
      __ALC_WEEKS__
    </div>
  </div>

  <!-- [UX] Commandes PRO - cards glassmorphism, icons, spacing 4px, touch 44px -->
  <div class="card reveal d4 commandsCard">
    <div class="section-header">
      <h2>Commandes</h2>
      <span class="section-header-badge cmdBadge">Centre de controle</span>
    </div>

    <!-- [UX] Sub-card: Commandes principales -->
    <div class="cmdSubCard cmdSubCard--primary">
      <div class="cmdSubCard__header">
        <span class="cmdSubCard__icon" aria-hidden="true">&#9654;</span>
        <span class="cmdSubCard__title">Demarrage</span>
      </div>
      <div class="cmdGrid">
        <button class="btn cmd cmd-start tooltip cmdBtn" data-tooltip="Demarrer la journee" onclick="send('start', this)">
          <span class="cmdBtn__icon" aria-hidden="true">&#9654;</span>
          <span class="cmdBtn__label">START</span>
        </button>
        <button class="btn cmd cmd-work tooltip cmdBtn" data-tooltip="Commencer a travailler" onclick="send('work', this)">
          <span class="cmdBtn__icon" aria-hidden="true">&#128188;</span>
          <span class="cmdBtn__label">WORK</span>
        </button>
        <button class="btn cmd cmd-dodo tooltip cmdBtn" data-tooltip="Mode sommeil" onclick="send('dodo', this)">
          <span class="cmdBtn__icon" aria-hidden="true">&#127769;</span>
          <span class="cmdBtn__label">DODO</span>
        </button>
      </div>
    </div>

    <!-- [UX] Sub-card: Actions rapides -->
    <div class="cmdSubCard cmdSubCard--actions">
      <div class="cmdSubCard__header">
        <span class="cmdSubCard__icon" aria-hidden="true">&#9889;</span>
        <span class="cmdSubCard__title">Actions rapides</span>
        <span class="help" data-tip="Pauses, activites et routines.">?</span>
      </div>
      <div class="grid" id="actionsGrid"></div>
    </div>

    <!-- [UX] Sub-card: Comptage alcool -->
    <div class="cmdSubCard cmdSubCard--alcohol">
      <div class="cmdSubCard__header">
        <span class="cmdSubCard__icon" aria-hidden="true">&#127867;</span>
        <span class="cmdSubCard__title">Comptage alcool</span>
        <span class="help" data-tip="Ajoute ou ajuste les consommations du jour.">?</span>
      </div>
      <!-- [UX_BEHAVIORAL_PDF C11] Labels visibles au-dessus des champs -->
      <div class="fieldRow alcFieldRow">
        <div class="fieldGroup">
          <label for="drinkN" class="fieldLabel">Quantite</label>
          <input id="drinkN" class="input drinkInput" type="number" min="1" step="1" value="1" aria-describedby="drinkHint"/>
        </div>
        <button class="btn alcBtn tooltip" data-tooltip="Ajouter canette(s) de biere" data-drink-btn="1" onclick="addDrink('beer')">
          <span class="alcLabel"><span aria-hidden="true">&#127866;</span> BIERE</span>
          <span class="alcVol">1 can. = 0.5 L</span>
        </button>
        <button class="btn alcBtn alcBtn--wine tooltip" data-tooltip="Ajouter verre(s) de vin" data-drink-btn="1" onclick="addDrink('wine')">
          <span class="alcLabel"><span aria-hidden="true">&#127863;</span> VIN</span>
          <span class="alcVol">1 verre = 0.2 L</span>
        </button>
        <button class="btn alcBtn tooltip" data-tooltip="Ajouter verre(s) d'alcool fort" data-drink-btn="1" onclick="addDrink('strong')">
          <span class="alcLabel"><span aria-hidden="true">&#127864;</span> FORT</span>
          <span class="alcVol">1 verre = 0.2 L</span>
        </button>
        <small id="drinkStatus" role="status" aria-live="polite" class="alcStatus">-</small>
      </div>
      <small id="drinkHint" class="fieldHint">Quantite minimum : 1</small>
      <div class="alcAdjustToggle">
        <button class="btn ghost" id="adjustToggle" aria-expanded="false" aria-controls="adjustWrap">&#9881; Ajustements</button>
      </div>
      <div id="adjustWrap" class="disclose alcAdjustWrap">
        <!-- [UX_BEHAVIORAL_PDF C11] Labels visibles au-dessus des champs -->
        <div class="fieldRow">
          <div class="fieldGroup">
            <label for="adjustType" class="fieldLabel">Type</label>
            <select id="adjustType" class="input alcSelect">
              <option value="beer" selected>&#127866; Biere</option>
              <option value="wine">&#127863; Vin</option>
              <option value="strong">&#129380; Alcool fort</option>
            </select>
          </div>
          <div class="fieldGroup">
            <label for="adjustTotal" class="fieldLabel">Nouveau total</label>
            <input id="adjustTotal" class="input adjustInput" type="number" min="0" step="1" value="0" aria-describedby="adjustHint"/>
          </div>
          <button class="btn primary tooltip" data-tooltip="Ajuster le total du jour" data-adjust-btn="1" onclick="adjustDrink()">Ajuster</button>
          <small id="adjustStatus" role="status" aria-live="polite">-</small>
        </div>
        <small class="muted">Ajuste le total du jour (ajoute seulement la difference).</small>
        <small id="adjustHint" class="fieldHint">Total minimum : 0</small>
      </div>
      <div id="drinkRecent" class="recentList"></div>
    </div>

    <!-- [UX] Sub-card: Systeme -->
    <div class="cmdSubCard cmdSubCard--system">
      <div class="cmdSubCard__header">
        <span class="cmdSubCard__icon" aria-hidden="true">&#128736;</span>
        <span class="cmdSubCard__title">Systeme</span>
      </div>
      <div class="row">
        <button class="btn ghost tooltip" data-tooltip="Redemarrer le moteur de suivi" onclick="restartEngine()">&#128260; Restart Engine</button>
        <small id="engineStatus" role="status" aria-live="polite">-</small>
      </div>
      <div class="row cmdStatusRow">
        <span id="status" class="pill cmdStatusPill" role="status" aria-live="polite">-</span>
      </div>
    </div>
  </div>

  <!-- [UX PRO] Calendrier - sub-cards glassmorphism, icons, spacing 4px -->
  <div class="card reveal d5 calendarCard">
    <div class="cal-hero">
      <h2 class="cal-title">Calendrier</h2>
      <div class="cal-nav">
        <a class="cal-nav-btn" href="/?m=__PREVYM__" aria-label="Mois précédent">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
        </a>
        <span class="cal-month">__YM__</span>
        <a class="cal-nav-btn" href="/?m=__NEXTYM__" aria-label="Mois suivant">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 6 15 12 9 18"/></svg>
        </a>
      </div>
    </div>

    <!-- [UX] Sub-card: Grille calendrier -->
    <div class="calSubCard calSubCard--grid">
      <table role="grid" aria-label="Calendrier mensuel">
        <thead>
          <tr>
            <th scope="col"><span class="cal-day-pill">L</span></th>
            <th scope="col"><span class="cal-day-pill">M</span></th>
            <th scope="col"><span class="cal-day-pill">M</span></th>
            <th scope="col"><span class="cal-day-pill">J</span></th>
            <th scope="col"><span class="cal-day-pill">V</span></th>
            <th scope="col"><span class="cal-day-pill cal-day-pill--we">S</span></th>
            <th scope="col"><span class="cal-day-pill cal-day-pill--we">D</span></th>
          </tr>
        </thead>
        <tbody>
          __CALROWS__
        </tbody>
      </table>
    </div>

    <!-- [UX] Sub-card: Legende -->
    <div class="calSubCard calSubCard--legend">
      <div class="calLegend">
        <div class="calLegend__item">
          <span class="calLegend__icon" aria-hidden="true">&#9200;</span>
          <span class="calLegend__text">InfernalDay commence a <strong>04:00</strong></span>
        </div>
        <div class="calLegend__item">
          <span class="calLegend__icon" aria-hidden="true">&#127866;</span>
          <span class="calLegend__text">Biere</span>
        </div>
        <div class="calLegend__item">
          <span class="calLegend__icon" aria-hidden="true">&#127863;</span>
          <span class="calLegend__text">Vin</span>
        </div>
        <div class="calLegend__item">
          <span class="calLegend__icon" aria-hidden="true"><svg class="legend-whisky" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M4 4 L4 20 Q4 22 6 22 L18 22 Q20 22 20 20 L20 4 Z" fill="rgba(255,255,255,.08)" stroke="rgba(255,255,255,.4)" stroke-width="1.2"/><path d="M5 14 L5 20 Q5 21 6 21 L18 21 Q19 21 19 20 L19 14 Z" fill="#c17f24"/><rect x="5.5" y="6" width="7" height="9" rx="1.5" fill="#a8e0f0"/><rect x="11" y="8" width="7" height="8" rx="1.5" fill="#8ed0e8"/><path d="M6 7 L11.5 7 L11 12 L6.5 12 Z" fill="rgba(255,255,255,.55)"/><path d="M11.5 9 L17 9 L16.5 14 L12 14 Z" fill="rgba(255,255,255,.45)"/></svg></span>
          <span class="calLegend__text">Alcool fort</span>
        </div>
        <div class="calLegend__item">
          <span class="calLegend__icon" aria-hidden="true">&#128187;</span>
          <span class="calLegend__text">Travail</span>
        </div>
        <div class="calLegend__item">
          <span class="calLegend__icon" aria-hidden="true">&#127769;</span>
          <span class="calLegend__text">Sommeil</span>
        </div>
      </div>
    </div>
  </div>

  <div class="card reveal d6">
    <div class="section-header">
      <h2>Rapport mensuel</h2>
      <div class="section-nav">
        <a class="cal-nav-btn" href="/?m=__PREVYM__" aria-label="Mois precedent">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
        </a>
        <span class="section-header-badge">__YM__</span>
        <a class="cal-nav-btn" href="/?m=__NEXTYM__" aria-label="Mois suivant">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 6 15 12 9 18"/></svg>
        </a>
      </div>
    </div>
    <div class="chartWrap" role="img" aria-label="Graphique mensuel des tendances">
      <canvas id="monthChart" aria-hidden="true"></canvas>
      <div id="monthChartFallback" class="sr-only" role="table" aria-label="Donnees du graphique mensuel"></div>
    </div>
    <div class="legend" id="monthLegend" role="list" aria-label="L&eacute;gende"></div>
    <div class="kpiGrid" id="monthKpis" role="list" aria-label="Indicateurs"></div>
    <div class="notesBox" id="monthNotes"></div>
  </div>

  <!-- [UX_BEHAVIORAL_PDF E19] Trust Pattern - Transparence sur le stockage des donnees -->
  <footer class="card reveal" style="margin-top:24px; padding:12px 16px; border-color:rgba(255,255,255,.08)">
    <div style="display:flex; align-items:center; gap:12px; flex-wrap:wrap">
      <span style="font-size:1.25rem">&#128274;</span>
      <div>
        <div style="font-weight:700; font-size:.875rem">Donnees 100% locales</div>
        <div class="muted" style="font-size:.8125rem">Toutes vos donnees sont stockees sur votre machine dans <code style="background:rgba(255,255,255,.08); padding:2px 6px; border-radius:4px">C:\Users\ludov\.infernal_wheel</code>. Aucune donnee n'est envoyee a un serveur externe. Vous gardez le controle total.</div>
      </div>
    </div>
  </footer>
  </main>

</div>

<script>
let currentBoxClass = "";
let currentBoxExtra = "";
let pendingReq = 0;
let lastNetErrorAt = 0;

/* [OFFLINE] Queue pour stocker les actions hors ligne */
const OFFLINE_KEY = "iw_offline_queue";
function getOfflineQueue(){ try { return JSON.parse(localStorage.getItem(OFFLINE_KEY)) || []; } catch { return []; } }
function saveOfflineQueue(q){ localStorage.setItem(OFFLINE_KEY, JSON.stringify(q)); updateOfflineCount(); console.log("[OFFLINE] Queue saved:", q.length, "items"); }
function queueOfflineAction(url, data){ const q = getOfflineQueue(); q.push({ url, data, ts: Date.now() }); saveOfflineQueue(q); console.log("[OFFLINE] Queued:", url, data); }
function updateOfflineCount(){
  const q = getOfflineQueue();
  const badge = document.getElementById("offlineCount");
  console.log("[OFFLINE] Queue count:", q.length);
  if (badge) { badge.textContent = q.length > 0 ? q.length + " en attente" : ""; badge.style.display = q.length > 0 ? "inline" : "none"; }
}
async function syncOfflineQueue(){
  const q = getOfflineQueue();
  console.log("[OFFLINE] Sync check - queue:", q.length, "online:", navigator.onLine);
  if (!q.length) return;
  if (!navigator.onLine) { console.log("[OFFLINE] Still offline, skipping sync"); return; }
  let synced = 0;
  for (const item of q) {
    try {
      console.log("[OFFLINE] Syncing:", item.url);
      const r = await fetch(item.url, { method:"POST", headers:{"Content-Type":"application/json"}, body:JSON.stringify(item.data) });
      if (r.ok) { synced++; console.log("[OFFLINE] Synced OK"); }
      else { console.log("[OFFLINE] Sync failed:", r.status); break; }
    } catch(e) { console.log("[OFFLINE] Sync error:", e); break; }
  }
  if (synced > 0) {
    saveOfflineQueue(q.slice(synced));
    showToast(synced + " action(s) synchronisée(s)", "success", "Sync");
  }
}
window.addEventListener("online", ()=>{ setOffline(false); syncOfflineQueue(); });
window.addEventListener("offline", ()=>{ setOffline(true); });
function setLoading(on){
  const bar = document.getElementById("globalLoading");
  if (!bar) return;
  if (on) { bar.classList.add("active"); }
  else { bar.classList.remove("active"); }
}
function requestStart(){ pendingReq++; setLoading(true); }
function requestEnd(){ pendingReq = Math.max(0, pendingReq - 1); if (pendingReq === 0) { setLoading(false); } }
/* [UX_PDF] Ripple effect - feedback visuel immediat au clic */
function createRipple(event){
  const btn = event.currentTarget;
  if(!btn || btn.disabled) return;
  const circle = document.createElement("span");
  const diameter = Math.max(btn.clientWidth, btn.clientHeight);
  const radius = diameter / 2;
  const rect = btn.getBoundingClientRect();
  circle.style.width = circle.style.height = diameter + "px";
  circle.style.left = (event.clientX - rect.left - radius) + "px";
  circle.style.top = (event.clientY - rect.top - radius) + "px";
  circle.classList.add("ripple");
  const existingRipple = btn.querySelector(".ripple");
  if(existingRipple){ existingRipple.remove(); }
  btn.appendChild(circle);
  setTimeout(()=>{ if(circle.parentNode) circle.remove(); }, 500);
}
/* [UX_PDF] Initialiser ripple sur tous les boutons */
function initRippleEffects(){
  document.querySelectorAll(".btn").forEach(btn=>{
    btn.addEventListener("click", createRipple);
  });
}
/* [I1/I5] Tap-to-toggle activity tooltips on mobile + backdrop dismiss */
function initActivityTooltips(){
  /* Create backdrop element */
  let backdrop = document.querySelector(".dacts-backdrop");
  if (!backdrop) {
    backdrop = document.createElement("div");
    backdrop.className = "dacts-backdrop";
    document.body.appendChild(backdrop);
  }
  function closeAll(){
    document.querySelectorAll(".dacts-details.open").forEach(d => d.classList.remove("open"));
    backdrop.classList.remove("show");
  }
  backdrop.addEventListener("click", closeAll);
  backdrop.addEventListener("touchstart", closeAll, {passive:true});
  document.querySelectorAll(".dacts-toggle").forEach(toggle => {
    toggle.addEventListener("click", (e) => {
      e.stopPropagation();
      const details = toggle.closest(".dacts").querySelector(".dacts-details");
      if (!details) return;
      const wasOpen = details.classList.contains("open");
      closeAll();
      if (!wasOpen) {
        details.classList.add("open");
        backdrop.classList.add("show");
      }
    });
  });
}
/* [UX_PDF] Success pulse sur bouton */
function pulseSuccess(btn){
  if(!btn) return;
  btn.classList.add("success-pulse");
  setTimeout(()=>{ btn.classList.remove("success-pulse"); }, 400);
}
/* [UX_BEHAVIORAL_PDF] Shake effect sur input invalide */
function shakeInput(input){
  if(!input) return;
  input.classList.add("shake");
  setTimeout(()=>{ input.classList.remove("shake"); }, 400);
}
function setOffline(isOff){
  const b = document.getElementById("offlineBanner");
  if (!b) return;
  if (isOff) { b.classList.add("show"); }
  else { b.classList.remove("show"); }
}
function showToast(message, type="info", title="", actionLabel="", actionFn=null){
  const host = document.getElementById("toastHost");
  if (!host) return;
  const t = document.createElement("div");
  t.className = "toast " + type;
  const ttl = title ? ("<div class='toastTitle'>" + title + "</div>") : "";
  t.innerHTML = ttl + "<div class='toastMsg'>" + message + "</div>";
  if (actionLabel && typeof actionFn === "function") {
    const btn = document.createElement("button");
    btn.className = "btn ghost";
    btn.style.marginTop = "6px";
    btn.textContent = actionLabel;
    btn.addEventListener("click", ()=>{
      actionFn();
      if (t.parentNode) t.parentNode.removeChild(t);
    });
    t.appendChild(btn);
  }
  host.appendChild(t);
  /* [DESIGN_TREE Phase 4] Toast auto 4s */
  setTimeout(()=>{ t.style.opacity = "0"; t.style.transform = "translateY(6px)"; }, 3600);
  setTimeout(()=>{ if (t.parentNode) t.parentNode.removeChild(t); }, 4200);
}
function notifyNetError(){
  setOffline(true);
  const now = Date.now();
  if (now - lastNetErrorAt > 30000) {
    showToast("Connexion impossible. Verifie le serveur.", "error", "Reseau");
    lastNetErrorAt = now;
  }
}
window.addEventListener("online", ()=>{ setOffline(false); showToast("Connexion retablie.", "success", "Reseau"); });
window.addEventListener("offline", ()=>{ setOffline(true); showToast("Hors ligne.", "error", "Reseau"); });
setOffline(navigator && navigator.onLine === false);
const retryBtn = document.getElementById("offlineRetry");
if (retryBtn) {
  retryBtn.addEventListener("click", ()=>{
    showToast("Tentative de reconnexion...", "warn", "Reseau");
    refreshLive();
    loadMonthlySummary();
    loadSettings();
  });
}
async function postJSON(url, obj, canQueue=true){
  /* [OFFLINE] Si offline et action queueable, stocker localement */
  const queueableUrls = ["/api/cmd", "/api/drinks/add", "/api/drinks/adjust", "/api/note/save", "/api/quicknote", "/api/actionnote"];
  if (!navigator.onLine && canQueue && queueableUrls.some(u => url.includes(u))) {
    queueOfflineAction(url, obj);
    showToast("Action mise en file (hors ligne)", "warn", "Offline");
    return {ok:true, queued:true};
  }
  requestStart();
  try{
    const r = await fetch(url, {method:"POST", headers:{"Content-Type":"application/json"}, body:JSON.stringify(obj)});
    if (!r.ok) { notifyNetError(); return {ok:false, error:"http"}; }
    return await r.json();
  } catch(e){
    /* [OFFLINE] Si échec réseau, tenter de queue */
    if (canQueue && queueableUrls.some(u => url.includes(u))) {
      queueOfflineAction(url, obj);
      showToast("Action mise en file (erreur réseau)", "warn", "Offline");
      return {ok:true, queued:true};
    }
    notifyNetError();
    return {ok:false, error:"network"};
  } finally {
    requestEnd();
  }
}
async function getJSON(url){
  requestStart();
  try{
    const r = await fetch(url, {method:"GET", cache:"no-store"});
    if(!r.ok){ notifyNetError(); return {ok:false}; }
    return await r.json();
  } catch(e){
    notifyNetError();
    return {ok:false}; 
  } finally {
    requestEnd();
  }
}
function setStatus(t){
  document.getElementById("status").textContent = t;
}
function setAdjustStatus(t){
  const el = document.getElementById("adjustStatus");
  if (el) { el.textContent = t; }
}
function setButtonBusy(btn, busy, title){
  if (!btn) return;
  btn.disabled = !!busy;
  btn.setAttribute("aria-busy", busy ? "true" : "false");
  /* [UX_BEHAVIORAL_PDF A1] Loading spinner sur bouton */
  if (busy) { btn.classList.add("loading"); }
  else { btn.classList.remove("loading"); }
  if (title) { btn.setAttribute("title", title); }
  else { btn.removeAttribute("title"); }
}
async function send(cmd, btn){
  if (btn) { setButtonBusy(btn, true, "Envoi..."); }
  agendaScrollUntil = Date.now() + 4000;
  const j = await postJSON("/api/cmd", {cmd:cmd});
  if (btn) { setButtonBusy(btn, false, ""); }
  setStatus(j.ok ? ("sent: " + cmd) : ("error: " + (j.error||"")));
  if (j && j.ok) { showToast("Commande envoyee : " + cmd, "success", "Action"); if(btn) pulseSuccess(btn); }
  else { showToast("Erreur commande : " + (j.error||"unknown"), "error", "Action"); }
  refreshLive();
  setTimeout(refreshLive, 1200);
}
function fmtMin(sec){ return Math.max(0, Math.round((sec||0)/60)); }

let SETTINGS = null;
let agendaScrollUntil = 0;
const drinkInput = document.getElementById("drinkN");
const drinkHint = document.getElementById("drinkHint");
const adjustInput = document.getElementById("adjustTotal");
const adjustHint = document.getElementById("adjustHint");

function validateDrinkInput(){
  if (!drinkInput) return;
  const v = parseInt(drinkInput.value || "0", 10);
  const wasValid = drinkInputValid;
  drinkInputValid = !isNaN(v) && v >= 1;
  drinkInput.classList.toggle("invalid", !drinkInputValid);
  /* [UX_BEHAVIORAL_PDF] Shake si devient invalide */
  if (wasValid && !drinkInputValid) { shakeInput(drinkInput); }
  if (drinkHint) {
    drinkHint.classList.toggle("error", !drinkInputValid);
    drinkHint.textContent = drinkInputValid ? "Quantite minimum : 1" : "Quantite invalide (>= 1)";
  }
  setDrinkButtonsDisabled(drinkBusy);
}

function validateAdjustInput(){
  if (!adjustInput) return;
  const v = parseInt(adjustInput.value || "0", 10);
  const wasValid = adjustInputValid;
  adjustInputValid = !isNaN(v) && v >= 0;
  adjustInput.classList.toggle("invalid", !adjustInputValid);
  /* [UX_BEHAVIORAL_PDF] Shake si devient invalide */
  if (wasValid && !adjustInputValid) { shakeInput(adjustInput); }
  if (adjustHint) {
    adjustHint.classList.toggle("error", !adjustInputValid);
    adjustHint.textContent = adjustInputValid ? "Total minimum : 0" : "Total invalide (>= 0)";
  }
  setAdjustButtonsDisabled(adjustBusy);
}

async function loadSettings(){
  try{
    const r = await fetch("/api/settings");
    if (!r.ok) { throw new Error("http"); }
    SETTINGS = await r.json();
    const grid = document.getElementById("actionsGrid");
    grid.innerHTML = "";
    const acts = (SETTINGS.actions || []).filter(a => (a.mode||"break")==="break");
    if (!acts.length) {
      grid.innerHTML = "<div class='emptyState' style='grid-column:1/-1'><div class='emptyTitle'>Aucune action</div><div class='emptyDesc'>Ajoute des actions dans settings.json.</div></div>";
      return;
    }
    for(const a of acts){
      const key = (a.key||"").trim(); if(!key) continue;
      const label = (a.label||key);
      const b = document.createElement("button");
      b.className = "btn action action-" + key;
      b.textContent = label;
      b.onclick = function(){ send(key, b); };
      grid.appendChild(b);
    }
  } catch(e){
    const grid = document.getElementById("actionsGrid");
    if (grid) {
      grid.innerHTML = "<div class='emptyState' style='grid-column:1/-1'><div class='emptyTitle'>Impossible de charger les actions</div><div class='emptyDesc'>Verifie le serveur.</div></div>";
    }
    showToast("Erreur chargement actions.", "error", "Actions");
  }
}

function initOnboarding(){
  const el = document.getElementById("onboarding");
  const btn = document.getElementById("onboardDismiss");
  if (!el || !btn) return;
  const seen = localStorage.getItem("iw_onboarded");
  if (!seen) { el.style.display = "block"; }
  btn.addEventListener("click", ()=>{
    localStorage.setItem("iw_onboarded","1");
    el.style.display = "none";
  });
}

function initAdjustToggle(){
  const t = document.getElementById("adjustToggle");
  const w = document.getElementById("adjustWrap");
  if (!t || !w) return;
  const open = localStorage.getItem("iw_adjust_open") === "1";
  if (open) { w.classList.add("show"); t.setAttribute("aria-expanded","true"); t.textContent = "Masquer ajustements"; }
  t.addEventListener("click", ()=>{
    const isOpen = w.classList.toggle("show");
    t.setAttribute("aria-expanded", isOpen ? "true" : "false");
    t.textContent = isOpen ? "Masquer ajustements" : "Afficher ajustements";
    localStorage.setItem("iw_adjust_open", isOpen ? "1" : "0");
  });
}

function val(id){ return document.getElementById(id).value || ""; }
function setDrinkStatus(t){ document.getElementById("drinkStatus").textContent = t; }
let drinkBusy = false;
let adjustBusy = false;
let drinkInputValid = true;
let adjustInputValid = true;
function setDrinkButtonsDisabled(dis){
  drinkBusy = !!dis;
  document.querySelectorAll("[data-drink-btn]").forEach(b=>{
    const disabled = drinkBusy || !drinkInputValid;
    b.disabled = disabled;
    b.style.opacity = disabled ? "0.55" : "1";
    /* [UX_BEHAVIORAL_PDF A1+A5] Loading spinner + tooltip explicatif */
    if (drinkBusy) { b.classList.add("loading"); b.setAttribute("title", "Envoi en cours, veuillez patienter..."); }
    else { b.classList.remove("loading"); if (!drinkInputValid) { b.setAttribute("title", "Entrez une quantite >= 1 pour activer"); } else { b.removeAttribute("title"); } }
  });
}
function setAdjustButtonsDisabled(dis){
  adjustBusy = !!dis;
  document.querySelectorAll("[data-adjust-btn]").forEach(b=>{
    const disabled = adjustBusy || !adjustInputValid;
    b.disabled = disabled;
    b.style.opacity = disabled ? "0.55" : "1";
    /* [UX_BEHAVIORAL_PDF A1+A5] Loading spinner + tooltip explicatif */
    if (adjustBusy) { b.classList.add("loading"); b.setAttribute("title", "Envoi en cours, veuillez patienter..."); }
    else { b.classList.remove("loading"); if (!adjustInputValid) { b.setAttribute("title", "Entrez un total >= 0 pour activer"); } else { b.removeAttribute("title"); } }
  });
}
function renderRecentDrinks(list){
  const el = document.getElementById("drinkRecent");
  if (!el) return;
  if (!list || !list.length) {
    el.innerHTML = "<div class='emptyState'><div class='emptyTitle'>Aucune boisson enregistree</div><div class='emptyDesc'>Utilise les boutons ci-dessus pour enregistrer.</div></div>";
    return;
  }
  el.innerHTML = list.map(r => {
    const at = escapeHtml(r.at || "");
    const label = escapeHtml(r.label || "");
    return "<div class='recentItem'><span>" + at + "</span><b>" + label + "</b></div>";
  }).join("");
}

async function undoDrink(type, n, totals){
  const map = {beer:"beer", wine:"wine", strong:"strong"};
  const key = map[type] || type;
  const current = Number(totals[key] || 0);
  const target = Math.max(0, current - n);
  setAdjustStatus("undo...");
  setDrinkButtonsDisabled(true);
  setAdjustButtonsDisabled(true);
  const j = await postJSON("/api/drinks/adjust", {type:key, total:target});
  setDrinkButtonsDisabled(false);
  setAdjustButtonsDisabled(false);
  if (j && j.ok) {
    setAdjustStatus("ok: undo");
    showToast("Annule : -" + n + " " + (key==="beer"?"biere":(key==="wine"?"vin":"alcool fort")), "success", "Alcool");
    refreshLive();
    setTimeout(refreshLive, 1200);
  } else {
    setAdjustStatus("error");
    showToast("Impossible d'annuler.", "error", "Alcool");
  }
}

async function addDrink(type){
  if (!drinkInputValid) {
    setDrinkStatus("error: quantite invalide");
    showToast("Quantite invalide (>= 1).", "warn", "Alcool");
    return;
  }
  const n = Math.max(1, parseInt(val("drinkN") || "1", 10));
  setDrinkStatus("sending...");
  setDrinkButtonsDisabled(true);
  setAdjustButtonsDisabled(true);
  const j = await postJSON("/api/drinks/add", {type:type, n:n});
  setDrinkButtonsDisabled(false);
  setAdjustButtonsDisabled(false);
    if (j && j.ok) {
      const t = j.totals || {};
      const totals = "B" + (t.beer||0) + " V" + (t.wine||0) + " AF" + (t.strong||0);
      const labelMap = { beer: "bi\u00e8re", wine: "vin", strong: "alcool fort" };
      const label = labelMap[type] || type;
      setDrinkStatus("ok: +" + n + " " + label + " (" + totals + ")");
      showToast("Ajoute : +" + n + " " + label, "success", "Alcool", "Annuler", ()=> undoDrink(type, n, t));
      refreshLive();
      setTimeout(refreshLive, 1200);
  } else {
    const err = (j && j.error) ? j.error : "unknown";
    setDrinkStatus("error: " + err);
    showToast("Erreur ajout boisson : " + err, "error", "Alcool");
  }
}
async function adjustDrink(){
  if (!adjustInputValid) {
    setAdjustStatus("error: total invalide");
    showToast("Total invalide (>= 0).", "warn", "Alcool");
    return;
  }
  const type = val("adjustType");
  let total = parseInt(val("adjustTotal") || "0", 10);
  if (isNaN(total) || total < 0) {
    setAdjustStatus("error: total invalide");
    showToast("Total invalide (>= 0).", "warn", "Alcool");
    return;
  }
  setAdjustStatus("sending...");
  setDrinkButtonsDisabled(true);
  setAdjustButtonsDisabled(true);
  const j = await postJSON("/api/drinks/adjust", {type:type, total:total});
  setDrinkButtonsDisabled(false);
  setAdjustButtonsDisabled(false);
  if (j && j.ok) {
    setAdjustStatus("ok: +" + j.added + " (now " + j.total + ")");
    showToast("Ajuste : +" + j.added + " (total " + j.total + ")", "success", "Alcool");
    refreshLive();
    setTimeout(refreshLive, 1200);
  } else {
    const err = (j && j.error) ? j.error : "unknown";
    setAdjustStatus("error: " + err);
    showToast("Erreur ajustement : " + err, "error", "Alcool");
  }
}

function setEngineStatus(t){ document.getElementById("engineStatus").textContent = t; }

async function restartEngine(){
  if (!confirm("Redemarrer l'engine ?")) { return; }
  const j = await postJSON("/api/engine/restart", {});
  if (j && j.ok) {
    setEngineStatus("restarted");
    showToast("Engine redemarre", "success", "Engine");
  } else {
    setEngineStatus("error");
    showToast("Erreur restart engine", "error", "Engine");
  }
}

/* [UX_PRO] Palette HSB espacée sur cercle chromatique - WCAG 1.4.1 distinction couleurs
   Work:      320° Magenta/Rose - productivité, énergie
   Sleep:     220° Bleu profond - nuit, calme
   Healthy:   145° Vert vif - santé, sport
   Chill:      40° Jaune/Orange - détente, repas
   Addiction:   0° Rouge - danger, alerte
*/
const CHART_COLORS = {
  work: "#E639A3",        // Magenta vif (320°, 75%, 90%)
  sleep: "#4169D9",       // Bleu profond (220°, 70%, 85%)
  sport: "#39BF6E",       // Vert vif (145°, 70%, 75%) - healthy
  marche: "#39BF6E",      // Vert (même - healthy)
  manger: "#F2B83D",      // Jaune/orange (40°, 75%, 95%) - chill
  reveille: "#F2B83D",    // Jaune (même - chill)
  glandouille: "#F2B83D", // Jaune (même - chill)
  clope: "#E64545",       // Rouge vif (0°, 70%, 90%) - addiction
  alcohol: "#FF8C42"      // Orange (25°, 75%, 100%) - addiction ligne
};

function escapeHtml(s){
  return String(s)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;");
}

function fmtHoursFromMin(min){
  const h = (Number(min) || 0) / 60;
  return h.toFixed(1) + "h";
}
function fmtMinVal(min){
  return Math.round(Number(min) || 0) + "m";
}
function fmtDelta(val, unit, precision){
  if (val == null) { return "flat vs last month"; }
  const abs = Math.abs(Number(val) || 0);
  if (abs < 0.01) { return "flat vs last month"; }
  const sign = val > 0 ? "+" : "-";
  return sign + abs.toFixed(precision) + " " + unit + " vs last month";
}

function renderMonthlyLegend(){
  const el = document.getElementById("monthLegend");
  if (!el) return;
  // [WEB.md §31] Retirer aria-busy apres chargement
  el.removeAttribute("aria-busy");
  // [Sparkline Rows] Legend hidden - labels are integrated in chart rows
  el.innerHTML = "";
  el.style.display = "none";
}

/* [UX_PRO] Stockage des hitboxes pour le tooltip */
let CHART_HITBOXES = [];
let CHART_HOVER_INDEX = -1;

function renderMonthlyChart(data){
  const canvas = document.getElementById("monthChart");
  if (!canvas) return;
  const ctx = canvas.getContext("2d");
  const rect = canvas.getBoundingClientRect();
  const width = rect.width || 800;
  const dpr = window.devicePixelRatio || 1;
  /* Set canvas pixel width immediately for proper rendering */
  canvas.width = Math.round(width * dpr);

  const allDays = data.days || [];
  if (!allDays.length) return;

  CHART_HITBOXES = [];

  /* ═══ SPARKLINE ROWS ═══ */

  /* Only days with actual data */
  const days = allDays.filter(d =>
    (d.workMin||0) > 0 || (d.sleepMin||0) > 0 || (d.sportMin||0) > 0 ||
    (d.marcheMin||0) > 0 || (d.clopeCount||0) > 0 || (d.alcoholCount||0) > 0
  );
  if (days.length < 2) return;

  const n = days.length;
  const labelW = 80;   /* left label column */
  const valueW = 56;   /* right value column */
  const sparkL = labelW;
  const sparkR = width - valueW;
  const sparkW = sparkR - sparkL;

  /* Row config */
  const rowH = 64;     /* height per sparkline row - generous */
  const rowGap = 6;    /* [F.36] 4px grid multiple - better row separation */
  const rows = [
    { key: "work",  label: "Travail",  icon: "\ud83d\udcbb", color: "#ff2d8a", bright: "#ff8ec4", values: days.map(d => (d.workMin||0)/60), unit: "h", type: "area" },
    { key: "sleep", label: "Sommeil",  icon: "\ud83c\udf19", color: "#3a6fff", bright: "#82b4ff", values: days.map(d => (d.sleepMin||0)/60), unit: "h", type: "area" },
    { key: "phys",  label: "Physique", icon: "\ud83c\udfc3", color: "#00d672", bright: "#5fffaa", values: days.map(d => ((d.sportMin||0)+(d.marcheMin||0))/60), unit: "h", type: "area" },
    { key: "clope", label: "Clopes",   icon: "\ud83d\udeac", color: "#ff4040", bright: "#ff8080", values: days.map(d => d.clopeCount||0), unit: "", type: "bars", hslGradient: true },
    { key: "alc",   label: "Alcool",   icon: "\ud83c\udf7a", color: "#ffaa22", bright: "#ffd080", values: days.map(d => d.pureAlcoholG||0), unit: "g", type: "bars", hslGradient: true },
  ];

  /* Filter out rows with zero data */
  const activeRows = rows.filter(r => r.values.some(v => v > 0));

  /* HSL→hex helper: returns #rrggbb so alpha hex suffix works (+"80" etc.) */
  function hslToHex(h, s, l) {
    s /= 100; l /= 100;
    const a = s * Math.min(l, 1 - l);
    const f = n => {
      const k = (n + h / 30) % 12;
      const c = l - a * Math.max(Math.min(k - 3, 9 - k, 1), -1);
      return Math.round(255 * c).toString(16).padStart(2, "0");
    };
    return "#" + f(0) + f(8) + f(4);
  }
  /* Score 0→1 maps to hue 120(green)→60(yellow)→0(red), same as weekly table */
  function hslBar(ratio) { return hslToHex(Math.round(120 - ratio * 120), 85, 55); }
  function hslBarBright(ratio) { return hslToHex(Math.round(120 - ratio * 120), 90, 72); }

  /* Total canvas height */
  let totalH = 8; /* top padding */
  for (const r of activeRows) totalH += rowH + rowGap;
  totalH += 24; /* bottom for day labels */

  canvas.height = Math.round(totalH * dpr);
  canvas.style.height = totalH + "px";
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  ctx.clearRect(0, 0, width, totalH);

  function hex(a) {
    return Math.round(Math.min(1, Math.max(0, a)) * 255).toString(16).padStart(2, "0");
  }

  function xOf(i) { return sparkL + (i / (n - 1 || 1)) * sparkW; }

  /* ─── Monotone cubic (Fritsch-Carlson) ─── */
  function monotonePath(pts) {
    const path = new Path2D();
    if (pts.length < 2) return path;
    const nn = pts.length;
    const dx = [], dy = [], m = [];
    for (let k = 0; k < nn - 1; k++) {
      dx[k] = pts[k+1].x - pts[k].x;
      dy[k] = (pts[k+1].y - pts[k].y) / (dx[k] || 1);
    }
    m[0] = dy[0];
    for (let k = 1; k < nn - 1; k++) {
      m[k] = (dy[k-1] * dy[k] <= 0) ? 0 : (dy[k-1] + dy[k]) / 2;
    }
    m[nn-1] = dy[nn-2];
    for (let k = 0; k < nn - 1; k++) {
      if (Math.abs(dy[k]) < 1e-6) { m[k] = 0; m[k+1] = 0; continue; }
      const ak = m[k]/dy[k], bk = m[k+1]/dy[k];
      const s = ak*ak + bk*bk;
      if (s > 9) { const t = 3/Math.sqrt(s); m[k] = t*ak*dy[k]; m[k+1] = t*bk*dy[k]; }
    }
    path.moveTo(pts[0].x, pts[0].y);
    for (let k = 0; k < nn - 1; k++) {
      const d = dx[k] / 3;
      path.bezierCurveTo(pts[k].x+d, pts[k].y+m[k]*d, pts[k+1].x-d, pts[k+1].y-m[k+1]*d, pts[k+1].x, pts[k+1].y);
    }
    return path;
  }

  /* ─── Draw each row ─── */
  let curY = 8;

  for (const row of activeRows) {
    const rh = rowH;
    const top = curY;
    const bot = curY + rh;
    const mid = curY + rh / 2;
    const maxVal = Math.max(0.1, ...row.values);
    const avg = row.values.reduce((a,b) => a+b, 0) / n;

    /* Row background on hover */
    const isRowHover = CHART_HOVER_INDEX >= 0 && CHART_HOVER_INDEX < n;

    /* [WEB.md §F6] Row band - subtle colored tint for category identification */
    ctx.fillStyle = row.color + "08";
    ctx.fillRect(0, top, width, rh);

    /* Separator line - visible */
    if (curY > 8) {
      ctx.strokeStyle = "rgba(255,255,255,0.08)";
      ctx.lineWidth = 1;
      ctx.beginPath(); ctx.moveTo(0, top - rowGap/2); ctx.lineTo(width, top - rowGap/2); ctx.stroke();
    }

    /* Left: colored bar indicator + label */
    ctx.fillStyle = row.color;
    ctx.fillRect(0, top + 4, 3, rh - 8);
    ctx.fillStyle = row.color + "dd";
    ctx.font = "bold 12px 'Space Grotesk', sans-serif"; /* [K.64] ≥12pt labels */
    ctx.textAlign = "left";
    ctx.fillText(row.icon + " " + row.label, 8, mid + 4);

    /* Right: average value chip - [WEB.md §K64] min 16px labels, contrast ≥3:1 */
    const avgText = row.unit === "h" ? avg.toFixed(1) : Math.round(avg);
    const avgLabel = "~" + avgText + (row.unit || "") + "/j";
    ctx.font = "bold 12px 'Space Grotesk', sans-serif";
    const tw = ctx.measureText(avgLabel).width;
    const chipW = tw + 14;
    const chipH = 22;
    const chipX = width - chipW - 4;
    const chipY = mid - chipH / 2;
    /* HSL chip color for gradient rows */
    const chipColor = row.hslGradient ? hslBar(0.5) : row.color;
    const chipBright = row.hslGradient ? hslBarBright(0.5) : row.bright;
    /* Chip background */
    ctx.fillStyle = chipColor + "18";
    ctx.beginPath(); ctx.roundRect(chipX, chipY, chipW, chipH, 6); ctx.fill();
    ctx.strokeStyle = chipColor + "30";
    ctx.lineWidth = 1;
    ctx.stroke();
    /* Chip text */
    ctx.fillStyle = chipBright;
    ctx.textAlign = "center";
    ctx.fillText(avgLabel, chipX + chipW / 2, mid + 4);
    /* "moy" micro-label above chip */
    ctx.fillStyle = chipColor + "60";
    ctx.font = "9px 'Space Grotesk', sans-serif";
    ctx.fillText("moy.", chipX + chipW / 2, chipY - 3);

    if (row.type === "area") {
      /* ─── Area sparkline with glow ─── min-max scaling for ondulation */
      const areaNZ = row.values.filter(v => v > 0);
      const areaMin = areaNZ.length > 1 ? Math.min(...areaNZ) : 0;
      const areaRange = maxVal - areaMin;
      const areaFloor = 0.18; /* minimum 18% height for lowest non-zero value */
      function areaY(v) {
        if (v <= 0) return top + rh - 4;
        if (areaRange < 0.01) return top + rh / 2;
        const norm = Math.max(0, Math.min(1, (v - areaMin) / areaRange));
        return top + rh - 4 - (areaFloor + norm * (1 - areaFloor)) * (rh - 8);
      }

      const pts = row.values.map((v, i) => ({
        x: xOf(i),
        y: areaY(v)
      }));

      /* Build area path */
      const curve = monotonePath(pts);
      const area = new Path2D();
      area.addPath(curve);
      area.lineTo(pts[pts.length-1].x, bot - 2);
      area.lineTo(pts[0].x, bot - 2);
      area.closePath();

      /* Gradient fill */
      const grad = ctx.createLinearGradient(0, top, 0, bot);
      grad.addColorStop(0, row.color + "50");
      grad.addColorStop(0.5, row.color + "20");
      grad.addColorStop(1, row.color + "00");
      ctx.fillStyle = grad;
      ctx.fill(area);

      /* Glow halo */
      ctx.save();
      ctx.shadowColor = row.color;
      ctx.shadowBlur = 16;
      ctx.strokeStyle = row.color + "60";
      ctx.lineWidth = 3;
      ctx.stroke(curve); ctx.stroke(curve);
      ctx.restore();

      /* Bright core line */
      ctx.save();
      ctx.shadowColor = row.bright;
      ctx.shadowBlur = 4;
      ctx.strokeStyle = row.bright;
      ctx.lineWidth = 1.5;
      ctx.stroke(curve);
      ctx.restore();

      /* Average reference line (dashed, very subtle) */
      const avgY = areaY(avg);
      ctx.strokeStyle = row.color + "30";
      ctx.lineWidth = 1;
      ctx.setLineDash([3, 5]);
      ctx.beginPath(); ctx.moveTo(sparkL, avgY); ctx.lineTo(sparkR, avgY); ctx.stroke();
      ctx.setLineDash([]);

      /* Hover dot */
      if (isRowHover) {
        const hi = CHART_HOVER_INDEX;
        const pt = pts[hi];
        ctx.save();
        ctx.shadowColor = row.bright;
        ctx.shadowBlur = 12;
        ctx.fillStyle = row.bright;
        ctx.beginPath(); ctx.arc(pt.x, pt.y, 4, 0, Math.PI * 2); ctx.fill();
        ctx.restore();
        ctx.fillStyle = "#fff";
        ctx.beginPath(); ctx.arc(pt.x, pt.y, 2, 0, Math.PI * 2); ctx.fill();

        /* Value label at hover point - matches tooltip format */
        const val = row.values[hi];
        if (val > 0) {
          let vt;
          if (row.unit === "h") {
            const hrs = Math.floor(val);
            const mins = Math.round((val - hrs) * 60);
            vt = hrs + "h" + (mins > 0 ? String(mins).padStart(2, "0") : "");
          } else {
            vt = val.toFixed(1) + row.unit;
          }
          ctx.fillStyle = "#fff";
          ctx.font = "bold 10px 'Space Grotesk', sans-serif";
          ctx.textAlign = "center";
          ctx.fillText(vt, pt.x, pt.y - 8);
        }
      }

    } else if (row.type === "bars") {
      /* ─── Bar row (clopes / alcohol) ─── full height like area rows */
      const barMaxH = rh - 16;
      const barBase = bot - 6;
      const colW = sparkW / n;
      const barW = Math.max(6, Math.min(16, colW * 0.5));

      /* Min-max scaling for better visual differentiation */
      const nonZero = row.values.filter(v => v > 0);
      const minVal = nonZero.length > 0 ? Math.min(...nonZero) : 0;
      const rangeVal = maxVal - minVal;
      const minBarH = barMaxH * 0.2;
      function barH(v) {
        if (v <= 0) return 0;
        if (rangeVal < 0.01) return barMaxH * 0.6;
        return minBarH + ((v - minVal) / rangeVal) * (barMaxH - minBarH);
      }

      /* Average dashed line */
      const avgH = barH(avg);
      const avgBarY = barBase - avgH;
      ctx.strokeStyle = (row.hslGradient ? "rgba(255,255,255,0.15)" : row.color + "30");
      ctx.lineWidth = 1;
      ctx.setLineDash([3, 5]);
      ctx.beginPath(); ctx.moveTo(sparkL, avgBarY); ctx.lineTo(sparkR, avgBarY); ctx.stroke();
      ctx.setLineDash([]);

      for (let i = 0; i < n; i++) {
        const v = row.values[i];
        if (v <= 0) continue;
        const x = xOf(i);
        const h = barH(v);
        const bx = x - barW / 2;
        const by = barBase - h;
        const ratio = rangeVal > 0.01 ? (v - minVal) / rangeVal : 0.5;

        ctx.save();
        if (row.hslGradient) {
          const barColor = hslBar(ratio);
          const barBright = hslBarBright(ratio);
          ctx.shadowColor = barColor;
          ctx.shadowBlur = 8;
          const bGrad = ctx.createLinearGradient(0, by, 0, barBase);
          bGrad.addColorStop(0, barBright);
          bGrad.addColorStop(1, barColor + "80");
          ctx.fillStyle = bGrad;
        } else {
          ctx.shadowColor = row.color;
          ctx.shadowBlur = 6;
          const bGrad = ctx.createLinearGradient(0, by, 0, barBase);
          bGrad.addColorStop(0, row.bright);
          bGrad.addColorStop(1, row.color + "80");
          ctx.fillStyle = bGrad;
        }
        ctx.beginPath(); ctx.roundRect(bx, by, barW, h, 2); ctx.fill();
        ctx.restore();
      }

      /* Hover highlight */
      if (isRowHover && row.values[CHART_HOVER_INDEX] > 0) {
        const hi = CHART_HOVER_INDEX;
        const x = xOf(hi);
        const v = row.values[hi];
        const h = barH(v);
        const bx = x - barW / 2;
        const by = barBase - h;
        ctx.save();
        ctx.shadowColor = "#fff";
        ctx.shadowBlur = 8;
        ctx.strokeStyle = "#fff";
        ctx.lineWidth = 1.5;
        ctx.beginPath(); ctx.roundRect(bx - 1, by - 1, barW + 2, h + 2, 3); ctx.stroke();
        ctx.restore();
        const hLabel = row.unit === "g" ? Math.round(v) + "g" : String(v);
        ctx.fillStyle = "#fff";
        ctx.font = "bold 11px 'Space Grotesk', sans-serif";
        ctx.textAlign = "center";
        ctx.fillText(hLabel, x, by - 7);
      }
    }

    curY += rh + rowGap;
  }

  /* ─── Day labels at bottom ─── [K.64] readable labels */
  ctx.font = "11px 'Space Grotesk', sans-serif";
  ctx.textAlign = "center";
  for (let i = 0; i < n; i++) {
    const day = days[i].day;
    const show = n <= 20 || day === 1 || i === n - 1 || day % 5 === 0;
    if (show) {
      ctx.fillStyle = "rgba(231,237,243,0.5)";
      ctx.fillText(String(day), xOf(i), curY + 14);
    }
  }

  /* ─── Hover vertical line across all rows ─── */
  if (CHART_HOVER_INDEX >= 0 && CHART_HOVER_INDEX < n) {
    const hx = xOf(CHART_HOVER_INDEX);
    ctx.save();
    ctx.strokeStyle = "rgba(255,255,255,0.08)";
    ctx.lineWidth = 1;
    ctx.setLineDash([2, 4]);
    ctx.beginPath(); ctx.moveTo(hx, 0); ctx.lineTo(hx, curY); ctx.stroke();
    ctx.setLineDash([]);
    ctx.restore();
  }

  /* ─── Hitboxes (full column width for each day) ─── */
  const step = sparkW / n;
  for (let i = 0; i < n; i++) {
    CHART_HITBOXES.push({
      x: sparkL + i * step - step/2,
      x2: sparkL + (i + 1) * step,
      dayIndex: i,
      dayData: days[i]
    });
  }

  /* [WEB §K Rule 64] Fallback table for screen readers */
  const fb = document.getElementById("monthChartFallback");
  if (fb) {
    let html = "<table><caption>Rapport mensuel</caption><thead><tr><th>Jour</th><th>Travail</th><th>Sommeil</th><th>Physique</th><th>Clopes</th><th>Alcool</th></tr></thead><tbody>";
    for (const d of allDays) {
      html += "<tr><td>" + d.day + "</td><td>" + (d.workMin||0) + "m</td><td>" + (d.sleepMin||0) + "m</td><td>" + ((d.sportMin||0)+(d.marcheMin||0)) + "m</td><td>" + (d.clopeCount||0) + "</td><td>" + (d.alcoholCount||0) + "</td></tr>";
    }
    html += "</tbody></table>";
    fb.innerHTML = html;
  }
}

/* [UX_PRO] Tooltip pour le graphique mensuel */
function showChartTooltip(dayData, x, y) {
  let tooltip = document.getElementById("chartTooltip");
  if (!tooltip) {
    tooltip = document.createElement("div");
    tooltip.id = "chartTooltip";
    tooltip.className = "chartTooltip";
    document.body.appendChild(tooltip);
  }

  const d = dayData;
  const fmtTime = (h, m) => {
    if (h === undefined) return "-";
    const hh = String(Math.floor(h)).padStart(2, "0");
    const mm = String(m || 0).padStart(2, "0");
    return hh + ":" + mm;
  };
  const fmtDur = (min) => {
    if (!min) return "-";
    const hrs = Math.floor(min / 60);
    const mins = min % 60;
    return hrs > 0 ? hrs + "h" + (mins > 0 ? String(mins).padStart(2, "0") : "") : mins + "min";
  };

  /* Wake-up time from segments */
  const reveilSeg = (d.segments||[]).find(s => s.name === "reveille");
  const reveilStr = reveilSeg ? (function() {
    const h = Math.floor(reveilSeg.start); const m = Math.round((reveilSeg.start - h) * 60);
    return String(h).padStart(2,"0") + ":" + String(m).padStart(2,"0");
  })() : null;

  tooltip.innerHTML = ""
    + "<div class='ttHeader'>Jour " + d.day + "</div>"
    + "<div class='ttGrid'>"
    + (d.workMin ? "<div class='ttRow ttRow--work'><span class='ttIcon'>\ud83d\udcbb</span><span class='ttLabel'>Travail</span><span class='ttVal'>" + fmtDur(d.workMin) + "</span></div>" : "")
    + (d.sleepMin ? "<div class='ttRow ttRow--sleep'><span class='ttIcon'>\ud83d\udca4</span><span class='ttLabel'>Sommeil</span><span class='ttVal'>" + fmtDur(d.sleepMin) + "</span></div>" : "")
    + (d.sportMin ? "<div class='ttRow ttRow--sport'><span class='ttIcon'>\ud83c\udfc3</span><span class='ttLabel'>Sport</span><span class='ttVal'>" + fmtDur(d.sportMin) + "</span></div>" : "")
    + (d.marcheMin ? "<div class='ttRow ttRow--marche'><span class='ttIcon'>\ud83d\udeb6</span><span class='ttLabel'>Marche</span><span class='ttVal'>" + fmtDur(d.marcheMin) + "</span></div>" : "")
    + (reveilStr ? "<div class='ttRow ttRow--reveil'><span class='ttIcon'>\u2600\ufe0f</span><span class='ttLabel'>Reveil</span><span class='ttVal'>" + reveilStr + "</span></div>" : "")
    + "</div>"
    + ((d.clopeCount || d.pureAlcoholG) ? "<div class='ttDivider'></div><div class='ttGrid'>"
    + (d.clopeCount ? "<div class='ttRow addiction addiction--clope'><span class='ttIcon'>\ud83d\udeac</span><span class='ttLabel'>Clopes</span><span class='ttVal'>" + d.clopeCount + "</span></div>" : "")
    + (d.pureAlcoholG ? "<div class='ttRow addiction addiction--alc'><span class='ttIcon'>\ud83c\udf7a</span><span class='ttLabel'>Alcool</span><span class='ttVal'>" + Math.round(d.pureAlcoholG) + "g</span></div>" : "")
    + "</div>" : "");

  /* [UX_PRO] Positionner le tooltip */
  const ttRect = tooltip.getBoundingClientRect();
  const vw = window.innerWidth;
  const vh = window.innerHeight;
  let left = x + 16;
  let top = y - 20;
  if (left + 260 > vw) left = x - 260 - 16;
  if (top + 300 > vh) top = vh - 300 - 16;
  if (top < 8) top = 8;

  tooltip.style.left = left + "px";
  tooltip.style.top = top + "px";
  tooltip.classList.add("visible");
}

function hideChartTooltip() {
  const tooltip = document.getElementById("chartTooltip");
  if (tooltip) tooltip.classList.remove("visible");
}

/* [UX_PRO] Event listeners pour le canvas */
function initChartInteraction() {
  const canvas = document.getElementById("monthChart");
  if (!canvas || canvas.dataset.interactionInit) return;
  canvas.dataset.interactionInit = "1";

  canvas.addEventListener("mousemove", (e) => {
    const rect = canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    let foundIndex = -1;
    for (const hb of CHART_HITBOXES) {
      if (x >= hb.x && x <= hb.x2) {
        foundIndex = hb.dayIndex;
        showChartTooltip(hb.dayData, e.clientX, e.clientY);
        break;
      }
    }

    if (foundIndex !== CHART_HOVER_INDEX) {
      CHART_HOVER_INDEX = foundIndex;
      if (MONTHLY_DATA) renderMonthlyChart(MONTHLY_DATA);
    }

    if (foundIndex === -1) hideChartTooltip();
    canvas.style.cursor = foundIndex >= 0 ? "pointer" : "default";
  });

  canvas.addEventListener("mouseleave", () => {
    if (CHART_HOVER_INDEX !== -1) {
      CHART_HOVER_INDEX = -1;
      if (MONTHLY_DATA) renderMonthlyChart(MONTHLY_DATA);
    }
    hideChartTooltip();
  });

  /* [UX_PRO] Touch support pour mobile */
  canvas.addEventListener("touchstart", (e) => {
    const touch = e.touches[0];
    const rect = canvas.getBoundingClientRect();
    const x = touch.clientX - rect.left;

    for (const hb of CHART_HITBOXES) {
      if (x >= hb.x && x <= hb.x2) {
        CHART_HOVER_INDEX = hb.dayIndex;
        showChartTooltip(hb.dayData, touch.clientX, touch.clientY);
        if (MONTHLY_DATA) renderMonthlyChart(MONTHLY_DATA);
        break;
      }
    }
  }, { passive: true });

  canvas.addEventListener("touchend", () => {
    setTimeout(() => {
      CHART_HOVER_INDEX = -1;
      hideChartTooltip();
      if (MONTHLY_DATA) renderMonthlyChart(MONTHLY_DATA);
    }, 2000);
  });
}

let MONTHLY_DATA = null;
function renderMonthlyKpis(data){
  const s = data.summary || {};
  const d = data.delta || {};
  const alc = s.alcohol || {};
  const el = document.getElementById("monthKpis");
  if (!el) return;
  // [WEB.md §31] Retirer aria-busy apres chargement
  el.removeAttribute("aria-busy");

  const deltaSleepHr = (d.avgSleepMin || 0) / 60;
  const deltaWorkHr = (d.avgWorkMin || 0) / 60;

  // [UX_PRO] Icons + labels avec emojis semantiques
  const items = [
    { icon: "\ud83d\udca4", label: "Sommeil / jour", val: fmtHoursFromMin(s.avgSleepMin), delta: fmtDelta(deltaSleepHr, "h/jour", 1), deltaRaw: deltaSleepHr },
    { icon: "\ud83d\udcbb", label: "Travail / jour", val: fmtHoursFromMin(s.avgWorkMin), delta: fmtDelta(deltaWorkHr, "h/jour", 1), deltaRaw: deltaWorkHr },
    { icon: "\u23f1\ufe0f", label: "Session travail", val: fmtMinVal(s.avgWorkSessionMin), delta: fmtDelta(d.avgWorkSessionMin, "min", 1), deltaRaw: d.avgWorkSessionMin },
    { icon: "\ud83c\udfc3", label: "Sport / jour", val: fmtMinVal(s.avgSportMin), delta: fmtDelta(d.avgSportMin, "min/jour", 1), deltaRaw: d.avgSportMin },
    { icon: "\ud83d\udeac", label: "Clopes / jour", val: (Number(s.avgClopeCount) || 0).toFixed(2), delta: fmtDelta(d.avgClopeCount, "par jour", 2), deltaRaw: d.avgClopeCount, invertDelta: true },
    { icon: "\ud83c\udf7a", label: "Alcool total", val: (Number(alc.totalLiters) || 0).toFixed(2) + " L", delta: "-", deltaRaw: 0 },
    { icon: "\ud83c\udf77", label: "Alcool / jour", val: (Number(alc.avgDrinksPerDay) || 0).toFixed(2), delta: fmtDelta(d.avgAlcoholPerDay, "par jour", 2), deltaRaw: d.avgAlcoholPerDay, invertDelta: true },
    { icon: "\ud83d\udcc8", label: "Total travail", val: fmtHoursFromMin(s.totalWorkMin), delta: "-", deltaRaw: 0 },
    { icon: "\u2705", label: "Jours sans clope", val: String(s.clopeFreeDays || 0), delta: "-", deltaRaw: 0 }
  ];

  // [UX_PRO] Delta class: up/down/flat avec inversion pour addictions
  function getDeltaClass(raw, invert) {
    if (raw === undefined || raw === null || raw === 0) return "flat";
    const isUp = invert ? raw < 0 : raw > 0;
    const isDown = invert ? raw > 0 : raw < 0;
    if (isUp) return "up";
    if (isDown) return "down";
    return "flat";
  }

  // [WEB.md §29,31] ARIA: role, accessible name, live regions
  el.innerHTML = items.map(it => {
    const deltaClass = getDeltaClass(it.deltaRaw, it.invertDelta);
    // [WEB.md §29] Description accessible complete pour screen readers
    const ariaLabel = it.label + ": " + it.val + (it.delta !== "-" ? ", " + it.delta : "");
    // [WEB.md §22] Texte alternatif pour delta (pas juste fleche)
    const deltaText = deltaClass === "up" ? "hausse" : deltaClass === "down" ? "baisse" : "stable";
    return "<article class='kpiTile' role='listitem' tabindex='0' aria-label='" + escapeHtml(ariaLabel) + "'>"
      + "<div class='kpiIcon' aria-hidden='true'>" + it.icon + "</div>"
      + "<div class='kpiLabel' id='kpi-label-" + escapeHtml(it.label.replace(/\s/g,'-')) + "'>" + escapeHtml(it.label) + "</div>"
      + "<div class='kpiVal' aria-describedby='kpi-label-" + escapeHtml(it.label.replace(/\s/g,'-')) + "'>" + escapeHtml(it.val) + "</div>"
      + (it.delta !== "-" ? "<div class='kpiDelta " + deltaClass + "' role='status'><span class='sr-only'>" + deltaText + ": </span>" + escapeHtml(it.delta) + "</div>" : "")
      + "</article>";
  }).join("");
}

function renderMonthlyNotes(data){
  const el = document.getElementById("monthNotes");
  if (!el) return;
  // [WEB.md §31] Retirer aria-busy apres chargement
  el.removeAttribute("aria-busy");
  const notes = data.insights || [];
  // [WEB.md §2] Empty States - structure: illustration + titre + desc + CTA optionnel
  if (!notes.length) {
    el.innerHTML = "<div class='emptyState' role='status'>"
      + "<div style='font-size:2.5rem;margin-bottom:var(--sp-12);opacity:.8' aria-hidden='true'>\ud83d\udcca</div>"
      + "<div class='emptyTitle'>Aucun insight disponible</div>"
      + "<div class='emptyDesc'>Les analyses et tendances apparaitront automatiquement apres quelques jours de donnees.</div>"
      + "</div>";
    return;
  }
  // [UX_PRO] Section label + notes avec icones contextuelles
  const noteIcons = ["\ud83d\udca1", "\ud83d\udcca", "\u2728", "\ud83c\udfaf", "\ud83d\udd0d"];
  el.innerHTML = "<div class='sectionLabel'>\ud83d\udca1 Insights du mois</div>"
    + notes.map((n, i) => {
      const icon = noteIcons[i % noteIcons.length];
      return "<div class='notesLine'><span class='noteIcon' aria-hidden='true'>" + icon + "</span><span class='noteText'>" + escapeHtml(n) + "</span></div>";
    }).join("");
}

function showMonthlyLoading(){
  // [WEB.md §1] Skeleton screens refletant la structure finale - pas de layout shift
  /* [N4] Skeleton for chart canvas */
  const cw = document.querySelector(".chartWrap");
  if (cw) { cw.classList.add("skeleton"); cw.setAttribute("aria-busy", "true"); }
  const k = document.getElementById("monthKpis");
  if (k) {
    // [WEB.md §31] aria-busy pour indiquer le chargement aux screen readers
    k.setAttribute("aria-busy", "true");
    k.innerHTML = Array(6).fill(0).map(() =>
      "<div class='kpiTile skeleton' style='min-height:120px' aria-hidden='true'>"
      + "<div class='skeleton-line' style='width:36px;height:36px;border-radius:8px;margin-bottom:var(--sp-12)'></div>"
      + "<div class='skeleton-line' style='width:65%;height:14px;margin-bottom:var(--sp-8)'></div>"
      + "<div class='skeleton-line' style='width:45%;height:28px;margin-bottom:var(--sp-8)'></div>"
      + "<div class='skeleton-line' style='width:55%;height:14px'></div>"
      + "</div>"
    ).join("");
  }
  const n = document.getElementById("monthNotes");
  if (n) {
    n.setAttribute("aria-busy", "true");
    n.innerHTML = "<div class='skeleton-line' style='width:35%;height:14px;margin-bottom:var(--sp-16)' aria-hidden='true'></div>"
      + "<div class='skeleton-line' style='width:100%;min-height:44px;margin-bottom:var(--sp-8);border-radius:8px' aria-hidden='true'></div>"
      + "<div class='skeleton-line' style='width:90%;min-height:44px;margin-bottom:var(--sp-8);border-radius:8px' aria-hidden='true'></div>"
      + "<div class='skeleton-line' style='width:75%;min-height:44px;border-radius:8px' aria-hidden='true'></div>";
  }
  const l = document.getElementById("monthLegend");
  if (l) {
    l.setAttribute("aria-busy", "true");
    l.innerHTML = Array(5).fill(0).map(() =>
      "<span style='min-height:44px' aria-hidden='true'><span class='skeleton-line' style='width:14px;height:14px;border-radius:50%;margin-right:8px'></span><span class='skeleton-line' style='width:56px;height:16px'></span></span>"
    ).join("");
  }
}

async function loadMonthlySummary(){
  const monthKey = "__YM__";
  showMonthlyLoading();
  const data = await getJSON("/api/monthly-summary?m=" + encodeURIComponent(monthKey));
  if (!data || !data.ok) { showToast("Erreur chargement rapport mensuel.", "error", "Rapport"); return; }
  MONTHLY_DATA = data;
  /* [N4] Remove chart skeleton */
  const cw = document.querySelector(".chartWrap");
  if (cw) { cw.classList.remove("skeleton"); cw.removeAttribute("aria-busy"); }
  renderMonthlyLegend();
  renderMonthlyChart(data);
  initChartInteraction(); /* [UX_PRO] Init tooltip + hover */
  renderMonthlyKpis(data);
  renderMonthlyNotes(data);
}

async function refreshLive(){
  try{
    const r = await fetch("/api/state");
    if (!r.ok) {
      notifyNetError();
      setEngineStatus("offline");
      return;
    }
    const j = await r.json();
    if(!j.ok){
      document.getElementById("kSeg").textContent = "OFFLINE";
      document.getElementById("kSeg2").innerHTML = "<span class='box-action-flag'>Start timer</span>";
      const elapsedEl = document.getElementById("kTimerElapsed");
      const remainEl = document.getElementById("kTimerRemain");
      if(elapsedEl) elapsedEl.textContent = "-";
      if(remainEl) remainEl.textContent = "-";
      document.getElementById("liveCard").classList.remove("alert");
      setEngineStatus("offline");
      notifyNetError();
      return;
    }
    setEngineStatus("running");
    setOffline(false);

    document.getElementById("kRemain").textContent = fmtMin(j.remWorkSec) + "m";
    const doneSec = (j.totalWorkSec || 0) + (j.totalOverrunSec || 0);
    const breakSec = j.totalBreakSec || 0;
    document.getElementById("statGoal").textContent = fmtMin(j.goalWorkSec) + "m";
    document.getElementById("statDone").textContent = fmtMin(doneSec) + "m";
    document.getElementById("statBreak").textContent = fmtMin(breakSec) + "m";

    const denom = (j.goalWorkSec || 0);
    const pct = denom > 0 ? Math.min(100, (doneSec/denom)*100) : 0;
    document.getElementById("bar").style.width = pct.toFixed(1) + "%";
    const pctEl = document.getElementById("progressPct");
    if(pctEl) pctEl.textContent = pct.toFixed(0) + "%";

    // Dynamic emoji based on progress
    const emojiEl = document.getElementById("progressEmoji");
    if(emojiEl) {
      let emoji = "\u{1F634}"; // 0-25%: sleeping
      if(pct >= 25 && pct < 50) emoji = "\u{1F525}"; // 25-50%: fire
      else if(pct >= 50 && pct < 75) emoji = "\u{26A1}"; // 50-75%: lightning
      else if(pct >= 75 && pct < 100) emoji = "\u{1F680}"; // 75-99%: rocket
      else if(pct >= 100) emoji = "\u{1F389}"; // 100%: party
      emojiEl.textContent = emoji;
    }

    const seg = (j.currentName || "idle").toUpperCase();
    document.getElementById("kSeg").textContent = seg;
    const currentBox = document.getElementById("currentBox");
    if(currentBox){
      const raw = (j.currentName || "idle").toLowerCase();
      const key = raw.replace(/[^a-z0-9_-]/g, "");
      let cls = "";
      let extra = "";
      if(key === "work" || key === "sleep" || key === "idle"){
        cls = key;
      } else if(key === "wait_ok" || key === "waitok" || key === "wait-ok"){
        cls = "wait-ok";
      } else {
        cls = "action-" + key;
        extra = "break";
      }
      if(currentBoxClass){ currentBox.classList.remove(currentBoxClass); }
      if(currentBoxExtra){ currentBox.classList.remove(currentBoxExtra); }
      if(cls){ currentBox.classList.add(cls); }
      if(extra){ currentBox.classList.add(extra); }
      currentBoxClass = cls;
      currentBoxExtra = extra;
    }
    let flags = [];
    if(j.awaitOk) flags.push("<span class='box-action-flag'>WAIT_OK</span>");
    if(j.paused) flags.push("<span class='box-action-flag'>PAUSED</span>");
    if(j.resumeDetected) flags.push("<span class='box-action-flag'>RESUME_GAP</span>");
    document.getElementById("kSeg2").innerHTML = flags.length ? flags.join("") : "<span class='box-action-flag active'>RUN</span>";

    // Timer display
    const elapsedEl = document.getElementById("kTimerElapsed");
    const remainEl = document.getElementById("kTimerRemain");
    if(elapsedEl) elapsedEl.textContent = fmtMin(j.elapsedSec) + "m";
    if(remainEl){
      if(j.overtimeSec > 0){
        remainEl.textContent = "+" + fmtMin(j.overtimeSec) + "m";
        remainEl.classList.add("overtime");
        document.getElementById("liveCard").classList.add("alert");
      } else if(j.remainSec != null){
        remainEl.textContent = fmtMin(j.remainSec) + "m";
        remainEl.classList.remove("overtime");
        document.getElementById("liveCard").classList.remove("alert");
      } else {
        remainEl.textContent = "-";
        remainEl.classList.remove("overtime");
        document.getElementById("liveCard").classList.remove("alert");
      }
    }

    if(j.dailyAlcohol){
      const d = j.dailyAlcohol;
      const line = "Alcool (jour) - Vin: " + (d.wine||0) + " - Bi\u00e8re: " + (d.beer||0) + " - Alcool fort: " + (d.strong||0);
      document.getElementById("drinkToday").innerHTML = "<div class='seg break'><div><b>Alcool (jour)</b></div><div class='muted'>" + line.replace('Alcool (jour) - ','') + "</div></div>";
    }

    if(j.recentDrinks){
      renderRecentDrinks(j.recentDrinks);
    }

    if(j.firsts){
      const f = j.firsts;
      const c = (f.clope || "-");
      const a = (f.any || "-");
      const w = (f.wake || "-");
      const fmtDelta = (v)=>{
        if(v === null || v === undefined || isNaN(Number(v))) return "";
        const n = Number(v);
        if(n === 0) return " (0m vs hier)";
        if(n > 0) return " (+" + n + "m vs hier)";
        return " (" + n + "m vs hier)";
      };
      const fmtSinceWake = (delta)=>{
        if(delta !== null && delta !== undefined && !isNaN(Number(delta))){
          return " | +" + Number(delta) + "m depuis r\u00e9veil";
        }
        if(f.sinceWakeMin !== null && f.sinceWakeMin !== undefined && !isNaN(Number(f.sinceWakeMin))){
          return " | " + Number(f.sinceWakeMin) + "m depuis r\u00e9veil (pas encore)";
        }
        return "";
      };
      const fmtSoberBadge = (label, cur, best, cls)=>{
        if(cur === null || cur === undefined || isNaN(Number(cur))) return "";
        const n = Math.max(0, Math.round(Number(cur)));
        let t = label + ": " + n + "m";
        const cap = Math.floor(n / 1440);
        if (cap >= 1) { t += " (cap 24h x" + cap + ")"; }
        if (best !== null && best !== undefined && !isNaN(Number(best)) && Number(best) > 0) {
          t += " (record: " + Number(best) + "m)";
        }
        return "<span class='firstsBadge " + cls + "'>" + t + "</span>";
      };
      const dC = fmtDelta(f.deltaClopeMin);
      const dA = fmtDelta(f.deltaAnyMin);
      const sW = fmtSinceWake(f.deltaClopeFromWakeMin);
      const sA = fmtSinceWake(f.deltaAnyFromWakeMin);
      const badgeAlc = fmtSoberBadge("Sans alcool", f.soberMin, f.bestSoberMin, "alcohol");
      const badgeClope = fmtSoberBadge("Sans clope", f.soberClopeMin, f.bestClopeSoberMin, "clope");
      const badges = [badgeAlc, badgeClope].filter(x => x).join("");
      const recC = (Number(f.bestClopeFromWakeMin) > 0) ? (Number(f.bestClopeFromWakeMin) + "m (" + (f.bestClopeDate || "-") + ")") : "-";
      const recA = (Number(f.bestBeerFromWakeMin) > 0) ? (Number(f.bestBeerFromWakeMin) + "m (" + (f.bestBeerDate || "-") + ")") : "-";

      let praise = "";
      const positives = [];
      if (Number(f.deltaClopeMin) > 0) positives.push({label:"Clope", val:Number(f.deltaClopeMin)});
      if (Number(f.deltaAnyMin) > 0) positives.push({label:"Alcool", val:Number(f.deltaAnyMin)});
      if (positives.length) {
        positives.sort((x,y)=>y.val-x.val);
        praise = "Bravo: " + positives[0].label + " +" + positives[0].val + "m vs hier";
      }

      let html = "<div class='seg break'><div class='firstsHead'><b>Premiers du jour</b>";
      if (badges) { html += "<div class='firstsBadges'>" + badges + "</div>"; }
      html += "</div>";
      html += "<div class='firstsList'>";
      html += "<div class='firstCol'>";
      html += "<div class='firstRow'><span class='firstLabel'>R\u00e9veille</span><span class='firstValue'>" + w + "</span></div>";
      html += "<div class='firstRow'><span class='firstLabel'>Clope</span><span class='firstValue'>" + c + sW + dC + "</span></div>";
      html += "<div class='firstRow'><span class='firstLabel'>Alcool</span><span class='firstValue'>" + a + sA + dA + "</span></div>";
      html += "</div>";
      html += "<div class='firstCol'>";
      html += "<div class='firstRow'><span class='firstLabel'>Record clope</span><span class='firstValue'>" + recC + "</span></div>";
      html += "<div class='firstRow'><span class='firstLabel'>Record alcool</span><span class='firstValue'>" + recA + "</span></div>";
      if (praise) {
        html += "<div class='firstRow'><span class='firstLabel'>Bravo</span><span class='firstValue'>" + praise.replace('Bravo: ','') + "</span></div>";
      }
      html += "</div></div></div>";
      document.getElementById("firstsToday").innerHTML = html;
    }

    if(j.dailyActions){
      if (!j.dailyActions.length) {
        document.getElementById("actionsToday").innerHTML = "<div class='emptyState'><div class='emptyTitle'>Aucune action (jour)</div><div class='emptyDesc'>Les actions s'afficheront ici.</div></div>";
      } else {
        let html = "<div class='seg break'><div><b>Actions (jour)</b></div><div class='actionList'>";
        for(const a of j.dailyActions){
          const sec = Math.max(0, Number(a.durSec || 0));
          const min = sec > 0 ? Math.ceil(sec / 60) : 0;
          html += "<div class='chip'><span class='chipLabel'>" + (a.label || a.key) + "</span><span class='chipValue'>" + min + "m</span></div>";
        }
        html += "</div></div>";
        document.getElementById("actionsToday").innerHTML = html;
      }
    }

    if(j.timelineHtml != null){
      const tl = document.getElementById("agendaTimeline");
      if(tl){
        tl.innerHTML = j.timelineHtml || "";
        if (agendaScrollUntil > Date.now()) {
          const box = tl.closest ? tl.closest(".agendaBox") : tl.parentElement;
          if (box) { box.scrollTop = box.scrollHeight; }
        }
      }
    }

    if(j.dailyClopeSec != null){
      const sec = Math.max(0, Number(j.dailyClopeSec || 0));
      const min = sec > 0 ? Math.ceil(sec / 60) : 0;
      document.getElementById("smokeToday").innerHTML = "<div class='seg break'><div><b>Cigarettes (jour)</b></div><div class='muted'>Clope: " + min + "m</div></div>";
    }

  } catch(e){ notifyNetError(); }
}

// Agenda: clock + toggle
function updateAgendaClock(){
  const el = document.getElementById("agendaClock");
  if(el){ const n = new Date(); el.textContent = n.getHours().toString().padStart(2,"0") + ":" + n.getMinutes().toString().padStart(2,"0"); }
}
function initAgendaToggle(){
  const btn = document.getElementById("agendaToggle");
  const box = document.getElementById("agendaDetails");
  if(btn && box){
    btn.addEventListener("click", ()=>{
      const exp = btn.getAttribute("aria-expanded") === "true";
      btn.setAttribute("aria-expanded", (!exp).toString());
      box.classList.toggle("open", !exp);
    });
  }
}
updateAgendaClock();
initAgendaToggle();
setInterval(updateAgendaClock, 1000);

setInterval(refreshLive, 1000);
refreshLive();
loadSettings();
loadMonthlySummary();
initOnboarding();
initAdjustToggle();
initRippleEffects();
initActivityTooltips();
updateOfflineCount();
syncOfflineQueue();
if (drinkInput) { drinkInput.addEventListener("input", validateDrinkInput); }
if (adjustInput) { adjustInput.addEventListener("input", validateAdjustInput); }
validateDrinkInput();
validateAdjustInput();
window.addEventListener("resize", ()=>{ if (MONTHLY_DATA) { renderMonthlyChart(MONTHLY_DATA); } });

/* [N3] Pause infinite animations when tab is hidden (GPU optimization) */
document.addEventListener("visibilitychange", () => {
  document.body.style.animationPlayState = document.hidden ? "paused" : "running";
  document.querySelectorAll(".currentBox, .currentWeek, .hb-dot, .progress > div, .progress > div::before").forEach(el => {
    el.style.animationPlayState = document.hidden ? "paused" : "running";
  });
});

// Quick note (persisted)
const qn = document.getElementById("quickNote");
const qns = document.getElementById("quickNoteStatus");
let qDirty = false;
let qLast = "";
getJSON("/api/quicknote").then(j=>{
  if(j && j.ok){
    qn.value = j.content || "";
    qLast = qn.value;
    if(qns) qns.textContent = "loaded";
  } else {
    if(qns) qns.textContent = "error";
    showToast("Impossible de charger la note rapide.", "error", "Notes");
  }
});
qn.addEventListener("input", ()=>{
  qDirty = true;
  if(qns) qns.textContent = "saving...";
});
setInterval(async ()=>{
  const current = qn.value || "";
  if(!qDirty && current === qLast){ return; }
  const j = await postJSON("/api/quicknote",{content:current});
  if(j && j.ok){
    qLast = current;
    qDirty = false;
    if(qns) qns.textContent = "saved";
  } else {
    if(qns) qns.textContent = "error";
    showToast("Erreur sauvegarde note rapide.", "error", "Notes");
  }
}, 2000);

// Action note (persisted)
const an = document.getElementById("scratchNote");
const ans = document.getElementById("actionNoteStatus");
if(an){
  let aDirty = false;
  let aLast = "";
  getJSON("/api/actionnote").then(j=>{
    if(j && j.ok){
      an.value = j.content || "";
      aLast = an.value;
      if(ans) ans.textContent = "loaded";
    } else {
      if(ans) ans.textContent = "error";
      showToast("Impossible de charger la note action.", "error", "Notes");
    }
  });
  an.addEventListener("input", ()=>{ aDirty = true; if(ans) ans.textContent = "saving..."; });
  setInterval(async ()=>{
    const current = an.value || "";
    if(!aDirty && current === aLast){ return; }
    const j = await postJSON("/api/actionnote",{content:current});
    if(j && j.ok){
      aLast = current;
      aDirty = false;
      if(ans) ans.textContent = "saved";
    } else {
      if(ans) ans.textContent = "error";
      showToast("Erreur sauvegarde note action.", "error", "Notes");
    }
  }, 2000);
}

// [UX] Help tooltips - tap to toggle on mobile
document.querySelectorAll('.help[data-tip]').forEach(el => {
  el.addEventListener('click', (e) => {
    e.stopPropagation();
    // Fermer les autres tooltips ouverts
    document.querySelectorAll('.help.active').forEach(other => {
      if (other !== el) other.classList.remove('active');
    });
    // Toggle celui-ci
    el.classList.toggle('active');
  });
});
// Fermer tooltip si on clique ailleurs
document.addEventListener('click', () => {
  document.querySelectorAll('.help.active').forEach(el => el.classList.remove('active'));
});

// ═══ AJAX Calendar Navigation ═══
(function() {
  function bindCalNav() {
    document.querySelectorAll('.cal-hero .cal-nav-btn').forEach(btn => {
      btn.addEventListener('click', async (e) => {
        e.preventDefault();
        const url = btn.getAttribute('href');
        const hero = document.querySelector('.cal-hero');
        const grid = document.querySelector('.calSubCard--grid');
        if (!hero || !grid) { window.location = url; return; }
        // Fade out
        grid.style.opacity = '0.3';
        grid.style.transition = 'opacity .15s ease';
        try {
          const resp = await fetch(url);
          const html = await resp.text();
          const parser = new DOMParser();
          const doc = parser.parseFromString(html, 'text/html');
          const newHero = doc.querySelector('.cal-hero');
          const newGrid = doc.querySelector('.calSubCard--grid');
          if (newHero && newGrid) {
            hero.innerHTML = newHero.innerHTML;
            grid.innerHTML = newGrid.innerHTML;
            grid.style.opacity = '1';
            // Re-bind nav buttons + activity tooltips
            bindCalNav();
            bindActTooltips();
            // Update URL without reload
            history.pushState(null, '', url);
          } else {
            window.location = url;
          }
        } catch {
          window.location = url;
        }
      });
    });
  }
  function bindActTooltips() {
    let backdrop = document.querySelector('.dacts-backdrop');
    function closeAll() {
      document.querySelectorAll('.dacts-details.open').forEach(d => d.classList.remove('open'));
      if (backdrop) backdrop.classList.remove('show');
    }
    document.querySelectorAll('.calSubCard--grid .dacts-toggle').forEach(toggle => {
      toggle.addEventListener('click', (e) => {
        e.stopPropagation();
        const details = toggle.closest('.dacts').querySelector('.dacts-details');
        const isOpen = details.classList.contains('open');
        closeAll();
        if (!isOpen) {
          details.classList.add('open');
          if (backdrop) backdrop.classList.add('show');
        }
      });
    });
  }
  bindCalNav();
})();
</script>
</body>
</html>
'@

  $prevYm = $first.AddDays(-1).ToString("yyyy-MM")
  $nextYm = $next.ToString("yyyy-MM")

  $html = $tpl.
    Replace("__HB__", $hb.status).
    Replace("__HBCLASS__", $hbClass).
    Replace("__TODAY__", $todayKey).
    Replace("__PORT__", "$Port").
    Replace("__YM__", $ym).
    Replace("__PREVYM__", $prevYm).
    Replace("__NEXTYM__", $nextYm).
    Replace("__CALROWS__", $rowsHtml).
    Replace("__TIMELINE__", $timelineHtml).
    Replace("__ACTIONS_TODAY__", $actionsTodayHtml).
    Replace("__WINE_G__", ($monthly.WineGlasses).ToString()).
    Replace("__WINE_L__", ($monthly.WineLiters).ToString()).
    Replace("__WINE_B__", ($monthly.WineBottles).ToString()).
    Replace("__BEER_G__", ($monthly.BeerCans).ToString()).
    Replace("__BEER_L__", ($monthly.BeerLiters).ToString()).
    Replace("__STRONG_G__", ($monthly.StrongGlasses).ToString()).
    Replace("__STRONG_L__", ($monthly.StrongLiters).ToString()).
    Replace("__STRONG_B__", ($monthly.StrongBottles).ToString()).
    Replace("__ALC_TOTAL__", ($monthly.TotalLiters).ToString()).
    Replace("__ALC_WEEKS__", $weeksHtml).
    Replace("__WINE_UNIT__", $wineUnit).
    Replace("__BEER_UNIT__", $beerUnit).
    Replace("__STRONG_UNIT__", $strongUnit).
    Replace("__WINE_BTL__", $wineBottle).
    Replace("__STRONG_BTL__", $strongBottle).
    Replace("__REM__", (ConvertTo-Minutes $remSec).ToString()).
    Replace("__GOALM__", (ConvertTo-Minutes $goalSec).ToString()).
    Replace("__DONEM__", (ConvertTo-Minutes $doneSec).ToString()).
    Replace("__OVERM__", (ConvertTo-Minutes $overSec).ToString())

  return $html
}
