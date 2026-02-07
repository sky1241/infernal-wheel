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

  $rowsHtml = ""
  $week = ""
  for ($i=0; $i -lt $startWeekday; $i++) {
    $week += "<td class='day muted empty'></td>"
  }
  for ($day=1; $day -le $daysInMonth; $day++) {
    $d = Get-Date -Year $first.Year -Month $first.Month -Day $day -Hour 0 -Minute 0 -Second 0
    $dk = $d.ToString("yyyy-MM-dd")
    $ws = if ($daily.ContainsKey($dk)) { $daily[$dk] } else { @{work=0;sleep=0;clope=0} }
    $da = Get-DailyAlcoholTotals $dk
    $alc = ""
    if (($da.wine + $da.beer + $da.strong) -gt 0) {
      $alc = "<div class='dmeta'>Alcool: Vin $($da.wine) | Bi&egrave;re $($da.beer) | Alcool fort $($da.strong)</div>"
    }
    $smk = ""
    $clopeCount = [int]($ws.clope ?? 0)
    if ($dk -eq $todayKey) {
      if ($state -and $null -ne $state.DayClopeCount) {
        $clopeCount = [Math]::Max($clopeCount, [int]$state.DayClopeCount)
      }
      if ($state -and $state.Current -and [string]$state.Current.Name -eq "clope") {
        $clopeCount++
      }
    }
    if ($clopeCount -gt 0) {
      $smk = "<div class='dmeta'>Clope: $clopeCount</div>"
    }
    $actsHtml = ""
    foreach ($k in $actionKeys) {
      $label = if ($labelMap.ContainsKey($k)) { $labelMap[$k] } else { $k }
      $durSec = 0
      if ($dk -eq $todayCalKey) {
        if ($todayActions.ContainsKey($k)) { $durSec = [int]$todayActions[$k] }
      } elseif ($dailyActions.ContainsKey($dk) -and $dailyActions[$dk].ContainsKey($k)) {
        $durSec = [int]$dailyActions[$dk][$k]
      }
      if ($durSec -gt 0) {
        $dur = Format-DurationShort $durSec
        $actsHtml += "<div class='dmeta'>${label}: $dur</div>"
      }
    }
    # Build Work/Sleep display only if > 0
    $workSleepHtml = ""
    $workMin = [int](ConvertTo-Minutes $ws.work)
    $sleepMin = [int](ConvertTo-Minutes $ws.sleep)
    $wsParts = @()
    if ($workMin -gt 0) { $wsParts += "Work: <b>${workMin}m</b>" }
    if ($sleepMin -gt 0) { $wsParts += "Sleep: ${sleepMin}m" }
    if ($wsParts.Count -gt 0) { $workSleepHtml = "<div class='dmeta'>" + ($wsParts -join "<br/>") + "</div>" }
    $week += "<td class='day'><div class='dnum'>$($d.Day)</div>$workSleepHtml$alc$smk$actsHtml<div class='dlink'><a href='/notes?d=$dk'>Notes</a></div></td>"
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
    for ($i=0; $i -lt $pad; $i++) { $week += "<td class='day muted empty'></td>" }
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
  $weeksTail = @($weeks | Select-Object -First 6)
  $weeksHtml = ""
  if ($weeksTail.Count -eq 0) {
    $weeksHtml = "<div class='muted'>Aucune entree.</div>"
  } else {
    $weeksHtml = "<div class='weeksWrap'><div class='weeksTable'>"
    $whiskySvg = "<svg class='whisky-icon' viewBox='0 0 24 24' fill='none' xmlns='http://www.w3.org/2000/svg'><rect x='5' y='6' width='14' height='16' rx='2' fill='none' stroke='currentColor' stroke-width='1.5'/><path d='M5 14 L19 14 L19 20 Q19 22 17 22 L7 22 Q5 22 5 20 Z' fill='url(%23wg)'/><rect x='7' y='15' width='4' height='3' rx='1' fill='%2377ccff' opacity='.7'/><rect x='12' y='16' width='3' height='2' rx='.5' fill='%2399ddff' opacity='.6'/><defs><linearGradient id='wg' x1='0' y1='0' x2='0' y2='1'><stop offset='0%' stop-color='%23d4a04a'/><stop offset='100%' stop-color='%23a67c32'/></linearGradient></defs></svg>"
    $weeksHtml += "<div class='weekLine headLine'><div class='weekRow head'><div class='weekCell'>Semaine</div><div class='weekCell'>P&eacute;riode</div><div class='weekCell num'><span class='alc-icon'>&#127863;</span>Vin</div><div class='weekCell num'><span class='alc-icon'>&#127866;</span>Bi&egrave;re</div><div class='weekCell num'>$whiskySvg Fort</div><div class='weekCell num doseHead'><span class='doseBox'>Dose pure</span></div></div><div class='weekDelta headDelta'></div></div>"
    $i = 0
    foreach ($w in $weeksTail) {
      $range = if ($w.WeekRange) { $w.WeekRange } else { "-" }
      $deltaVal = $null
      try { $deltaVal = [double]$w.DeltaPure } catch { $deltaVal = $null }
      $deltaLabel = "—"
      $deltaClass = "deltaFlat"
      if ($null -ne $deltaVal) {
        if ($deltaVal -gt 0) {
          $deltaLabel = "+" + $deltaVal.ToString("0.###")
          if ($deltaVal -lt 0.5) { $deltaClass = "deltaUp delta-low" }
          elseif ($deltaVal -lt 1.5) { $deltaClass = "deltaUp delta-mid" }
          else { $deltaClass = "deltaUp delta-high" }
        }
        elseif ($deltaVal -lt 0) { $deltaLabel = $deltaVal.ToString("0.###"); $deltaClass = "deltaDown" }
        else { $deltaLabel = "0"; $deltaClass = "deltaFlat" }
      }
      $isOlder = ($i -ge 1)
      $rowClass = if ($isOlder) { "weekRow" } else { "weekRow currentWeek" }
      $cellClass = if ($isOlder) { "weekCell olderWeek" } else { "weekCell" }
      $cellNumClass = if ($isOlder) { "weekCell num olderWeek" } else { "weekCell num" }
      $cellDoseClass = if ($isOlder) { "weekCell num doseCell olderWeek" } else { "weekCell num doseCell" }
      $weeksHtml += "<div class='weekLine'><div class='$rowClass'><div class='$cellClass'>$($w.WeekKey)</div><div class='$cellClass'>$range</div><div class='$cellNumClass'><span class='wkCount'>$($w.WineGlasses)</span></div><div class='$cellNumClass'><span class='wkCount'>$($w.BeerCans)</span></div><div class='$cellNumClass'><span class='wkCount'>$($w.StrongGlasses)</span></div><div class='$cellDoseClass'><span class='doseBox'>$($w.PureLiters)</span></div></div><div class='weekDelta $deltaClass'>$deltaLabel</div></div>"
      $i++
    }
    $weeksHtml += "</div></div>"
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
  --week-gap:8px; --delta-col:96px;
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
.alcStat{
  /* [WEB] padding 8px, radius 8px */
  padding:8px 12px; border:1px solid var(--border); border-radius:8px;
  background:rgba(16,22,29,.55); color:var(--muted); font-size:.875rem; letter-spacing:.2px;
  box-shadow:0 0 0 1px rgba(255,255,255,.03) inset;
  text-align:center;
}
.alcStat.unitStat{color:var(--muted)}
.alcHeaderGrid{
  display:grid; width:100%;
  grid-template-columns:repeat(6, minmax(0,1fr));
  column-gap:var(--week-gap);
  align-items:baseline;
  padding:0 8px;
  box-sizing:border-box;
  margin-bottom:4px;
}
.alcTitle{
  grid-column:1 / 4;
  margin:4px 0 6px;
}
.alcDate{
  /* [WEB] padding 8px 12px, radius 8px */
  grid-column:4;
  font-weight:800; font-size:1rem; letter-spacing:.3px;
  color:var(--text); line-height:1;
  justify-self:center; text-align:center;
  padding:8px 12px; border-radius:8px;
  border:1px solid rgba(255,255,255,.14);
  background:rgba(12,18,26,.7);
  box-shadow:0 1px 3px rgba(0,0,0,.1);
  display:inline-flex; align-items:center; justify-content:center;
}
.alcStatsGrid{
  display:grid; width:100%;
  grid-template-columns:repeat(6, minmax(0,1fr));
  column-gap:var(--week-gap); row-gap:8px;
  padding:6px 8px; box-sizing:border-box; border:1px solid transparent;
}
.alcCard{
  border-color:rgba(91,178,255,.4);
  box-shadow:0 16px 50px rgba(0,0,0,.5), 0 0 40px rgba(91,178,255,.15), 0 0 0 1px rgba(91,178,255,.12) inset;
  background:linear-gradient(135deg, rgba(91,178,255,.08), rgba(91,178,255,.02));
}
.alcCard::after{
  background:radial-gradient(closest-side, rgba(91,178,255,.12), transparent 70%);
  opacity:.55;
}
.alcCard .alcTitle{
  font-size:1.375rem; letter-spacing:.4px;
}
.alcCard .alcSectionLabel{
  font-size:.75rem; color:rgba(255,255,255,.9);
}
.alcCard .alcStat{
  background:rgba(12,18,26,.7);
  border-color:rgba(255,255,255,.14);
  box-shadow:0 0 0 1px rgba(255,255,255,.05) inset, 0 4px 10px rgba(0,0,0,.25);
}
.alcSectionLabel{
  padding:0 8px 2px;
  font-size:.8125rem; color:var(--text); letter-spacing:.3px;
  font-weight:700; text-transform:uppercase;
}
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
.card:hover{
  border-color:rgba(91,178,255,.5);
  transform:translateY(-4px);
  box-shadow:0 20px 50px rgba(0,0,0,.5), 0 0 30px rgba(91,178,255,.15), 0 0 0 1px rgba(91,178,255,.15) inset;
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
.progress > div{
  height:100%; width:0%;
  background-image:
    linear-gradient(180deg, rgba(255,255,255,.38), rgba(255,255,255,0) 55%, rgba(255,255,255,.28)),
    linear-gradient(90deg, rgba(107,255,133,.98), rgba(91,178,255,.95), rgba(255,79,216,.95), rgba(246,183,60,.95));
  position:relative; overflow:hidden;
  box-shadow:0 0 12px rgba(255,255,255,.55), 0 0 26px rgba(255,255,255,.32), inset 0 0 10px rgba(255,255,255,.22);
  animation:pulseHalo 3.6s ease-in-out infinite;
}
.progress > div::before{
  content:""; position:absolute; inset:0;
  background:linear-gradient(90deg, rgba(255,255,255,0) 0%, rgba(255,255,255,.65) 45%, rgba(255,255,255,0) 80%);
  opacity:.9; mix-blend-mode:screen; transform:translateX(-70%);
  animation:shine 2.4s ease-in-out infinite; pointer-events:none;
}
.progress > div::after{
  content:""; position:absolute; inset:-60% -20%;
  background:
    radial-gradient(circle at 20% 50%, rgba(255,255,255,.35), transparent 60%),
    radial-gradient(circle at 60% 50%, rgba(255,255,255,.22), transparent 65%),
    linear-gradient(120deg, rgba(255,255,255,.25) 0%, rgba(255,255,255,0) 40%, rgba(255,255,255,.25) 70%, rgba(255,255,255,0) 100%);
  opacity:.7; transform:translateX(-30%);
  animation:waterFlow 4.2s ease-in-out infinite;
}
@keyframes waterFlow{
  0%{transform:translateX(-30%)}
  50%{transform:translateX(10%)}
  100%{transform:translateX(30%)}
}
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
/* [reflow_wcag_1_4_10] responsive table */
table{border-collapse:collapse;width:100%;table-layout:fixed}
td,th{border:1px solid var(--border); padding:.5rem; vertical-align:top; width:14.285%}
th{background:rgba(16,22,29,.6); text-align:left; color:var(--muted)}
.day{min-height:5.75rem; height:auto; overflow:hidden}
@media(max-width:640px){
  table,thead,tbody,tr,td,th{display:block;width:100%}
  thead tr{position:absolute;top:-9999px;left:-9999px}
  td.day{min-height:auto;height:auto;padding:.75rem;margin-bottom:.5rem;border-radius:8px}
  td.day.empty{display:none}
}
.dnum{font-weight:900}
.dmeta{margin-top:6px; font-size:.75rem; color:var(--muted); overflow-wrap:anywhere}
.dlink{margin-top:6px; font-size:.75rem; overflow-wrap:anywhere}
.day.empty{background:transparent}
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
.agendaBox{max-height:360px; overflow:auto}
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
.weeksWrap{overflow-x:auto; margin-top:8px; padding-bottom:4px; width:100%}
.weeksTable{
  --week-gap:8px;
  --delta-col:96px;
  --delta-pill:72px;
  display:flex; flex-direction:column; gap:8px;
  width:100%;
}
.weekLine{
  display:grid; grid-template-columns:minmax(0,1fr) var(--delta-col);
  column-gap:8px; align-items:stretch;
}
.weekRow{
  /* [WEB] padding 8px, radius 8px */
  display:grid; width:100%;
  grid-template-columns:repeat(6, minmax(0,1fr));
  column-gap:var(--week-gap); align-items:center; padding:8px;
  border:1px solid var(--border); border-radius:8px;
  background:rgba(16,22,29,.55);
  position:relative;
}
.weekRow.head{
  background:rgba(16,22,29,.7); border-color:rgba(255,255,255,.08);
}
.weekLine.headLine .weekDelta{visibility:hidden}
/* [WEB] font-size .875rem */
.weekCell{font-size:.875rem; color:var(--text)}
.weekCell.num{
  font-variant-numeric:lining-nums tabular-nums;
  font-feature-settings:"lnum" 1, "tnum" 1;
  text-align:left;
  display:flex; align-items:baseline; gap:2px; justify-content:flex-start;
}
.weekCell.doseCell{
  display:flex;
  justify-content:flex-end;
}
.weekCell.doseHead{
  display:flex;
  justify-content:flex-end;
}
.wkCount{min-width:12px; display:inline-block; text-align:center}
.wkLiters{min-width:0; color:var(--muted)}
.doseBox{display:inline-block; width:13ch}
.weekCell.doseHead .doseBox{
  text-align:right;
}
.weekCell.doseCell .doseBox{
  text-align:center;
}
.weekDelta{
  /* [WEB] padding 8px, radius 8px, font .75rem */
  display:flex; align-items:center; padding:8px; border-radius:8px;
  font-size:.75rem; font-weight:800; letter-spacing:.2px;
  border:1px solid rgba(255,255,255,.15);
  width:100%; justify-content:center; text-align:center;
  justify-self:stretch; box-sizing:border-box;
}
.weekDelta.deltaUp{
  color:rgba(255,77,77,.95);
  border-color:rgba(255,77,77,.55);
  background:rgba(255,77,77,.12);
  box-shadow:0 0 10px rgba(255,77,77,.22);
}
.weekDelta.deltaUp.delta-low{
  color:rgba(255,210,60,.95);
  border-color:rgba(255,210,60,.5);
  background:rgba(255,210,60,.12);
  box-shadow:0 0 10px rgba(255,210,60,.2);
}
.weekDelta.deltaUp.delta-mid{
  color:rgba(255,150,50,.95);
  border-color:rgba(255,150,50,.5);
  background:rgba(255,150,50,.12);
  box-shadow:0 0 10px rgba(255,150,50,.2);
}
.weekDelta.deltaUp.delta-high{
  color:rgba(255,77,77,.95);
  border-color:rgba(255,77,77,.6);
  background:rgba(255,77,77,.15);
  box-shadow:0 0 15px rgba(255,77,77,.3);
}
.whisky-icon{display:inline-block;width:18px;height:18px;vertical-align:middle;margin-right:2px}
.alc-icon{font-size:1rem;margin-right:2px}
.weekDelta.deltaDown{
  color:rgba(60,255,122,.95);
  border-color:rgba(60,255,122,.55);
  background:rgba(60,255,122,.12);
  box-shadow:0 0 10px rgba(60,255,122,.2);
}
.weekDelta.deltaFlat{
  color:var(--muted);
  border-color:rgba(255,255,255,.15);
  background:rgba(255,255,255,.05);
}
.weekRow.head .weekCell{color:var(--text); font-weight:700; letter-spacing:.3px}
.weekRow:not(.head) .weekCell{color:var(--text)}
.weekRow:not(.head) .weekCell.olderWeek{color:var(--muted)}
.weekRow.currentWeek{
  border-color:rgba(91,178,255,.35);
  box-shadow:0 0 0 1px rgba(91,178,255,.08) inset, 0 8px 20px rgba(0,0,0,.25);
}
.weekRow.currentWeek::before{
  content:""; position:absolute; left:0; top:8px; bottom:8px; width:3px;
  background:linear-gradient(180deg, rgba(91,178,255,.8), rgba(91,178,255,.2));
  border-radius:3px;
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
.chartWrap{height:240px; margin-top:8px}
#monthChart{width:100%; height:100%; display:block}
/* [WEB] gap 16px, margin 8px */
.legend{display:flex; gap:16px; flex-wrap:wrap; font-size:.875rem; color:var(--muted); margin-top:8px}
.legendDot{width:8px; height:8px; border-radius:999px; display:inline-block; margin-right:8px}
.kpiGrid{display:grid; grid-template-columns:repeat(auto-fit,minmax(168px,1fr)); gap:8px; margin-top:8px}
.kpiTile{border:1px solid var(--border); border-radius:8px; padding:12px; background:rgba(16,22,29,.6)}
.kpiLabel{font-size:.875rem; color:var(--muted)}
.kpiVal{font-size:1.125rem; font-weight:800}
.kpiDelta{font-size:.875rem; color:var(--muted)}
.notesBox{margin-top:8px; border:1px solid var(--border); border-radius:8px; padding:12px; background:rgba(16,22,29,.6)}
.notesLine{font-size:.875rem; color:var(--muted); margin:4px 0}
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
.emptyState{border:1px dashed var(--border); border-radius:10px; padding:12px; margin-top:8px; background:rgba(16,22,29,.5); color:var(--muted)}
.emptyTitle{color:var(--text); font-weight:800; margin-bottom:4px}
.emptyDesc{font-size:.875rem}
.emptyCta{margin-top:6px; font-size:.85rem; color:var(--blue)}
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
  width:18px; height:18px; border-radius:999px;
  border:1px solid rgba(255,255,255,.35); color:var(--muted); font-size:.75rem;
  margin-left:6px; vertical-align:middle;
  cursor:pointer; position:relative;
  -webkit-tap-highlight-color:transparent;
  user-select:none;
}
.help:hover{color:var(--text); border-color:rgba(255,255,255,.6)}
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
.skeleton::after{
  content:""; position:absolute; inset:0;
  background:linear-gradient(90deg, transparent, rgba(255,255,255,.12), transparent);
  transform:translateX(-100%); animation:skeletonMove 1.2s ease-in-out infinite;
}
@keyframes skeletonMove{0%{transform:translateX(-100%)}100%{transform:translateX(100%)}}
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

/* [UI_RULEBOOK_WEB] Touch target minimum 24x24px */
.help{min-width:24px;min-height:24px;width:24px;height:24px}
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
      <div class="box">
        <div><b>WORK Remaining</b> <small>(en minutes)</small></div>
        <div class="big" id="kRemain">__REM__m</div>
        <small id="kRemain2">Goal: __GOALM__m - Done: __DONEM__m - Break: __OVERM__m</small>
        <div class="progress" style="margin-top:10px"><div id="bar" style="width:0%"></div></div>
      <div class="miniNoteWrap" style="margin-top:18px">
          <label for="quickNote" class="sr-only">Note rapide</label>
          <textarea id="quickNote" class="miniNote" placeholder="Note rapide..." aria-label="Note rapide"></textarea>
          <small id="quickNoteStatus" class="muted" role="status" aria-live="polite">-</small>
        </div>
      </div>
    <div class="box currentBox" id="currentBox">
      <div><b>Action en cours</b></div>
      <div class="big" id="kSeg">-</div>
      <div class="row" style="gap:8px">
        <small id="kSeg2">-</small>
        <small id="kTimer">-</small>
      </div>
      <div style="height:18px"></div>
      <div class="miniNoteWrap" style="margin-top:18px">
          <label for="scratchNote" class="sr-only">Note action</label>
          <textarea id="scratchNote" class="miniNote" placeholder="Note action..." aria-label="Note action"></textarea>
          <small id="actionNoteStatus" class="muted" role="status" aria-live="polite">-</small>
        </div>
      </div>
    <div class="box agendaBox">
      <div><b>Agenda du jour</b><span class="help" data-tip="Timeline des actions du jour.">?</span></div>
      <div id="agendaTimeline">__TIMELINE__</div>
      <div id="actionsToday">__ACTIONS_TODAY__</div>
      <div id="drinkToday"></div>
      <div id="smokeToday"></div>
    </div>
    </div>
  </div>

  <div class="card reveal d3 alcCard">
    <div class="weekLine alcHeaderLine">
      <div class="alcHeaderGrid">
        <h2 class="alcTitle">Alcool : semaine en cours</h2>
        <div class="alcDate">__TODAY__</div>
      </div>
      <div></div>
    </div>
    <div class="alcSectionLabel">Unit&eacute;s de mesure</div>
    <div class="weekLine alcStatsLine">
      <div class="alcStatsGrid">
        <div class="alcStat unitStat" style="grid-column:3">1 verre = __WINE_UNIT__ L</div>
        <div class="alcStat unitStat" style="grid-column:4">1 canette = __BEER_UNIT__ L</div>
        <div class="alcStat unitStat" style="grid-column:5">1 verre = __STRONG_UNIT__ L</div>
      </div>
      <div></div>
    </div>
    <div class="alcDivider"></div>
    <div style="margin-top:10px">
      __ALC_WEEKS__
    </div>
  </div>

  <div class="card reveal d4">
    <h2>Commandes</h2>
    <div class="grid">
      <button class="btn cmd cmd-start tooltip" data-tooltip="Démarrer la journée" onclick="send('start', this)">START</button>
      <button class="btn cmd cmd-work tooltip" data-tooltip="Commencer à travailler" onclick="send('work', this)">WORK</button>
      <button class="btn cmd cmd-dodo tooltip" data-tooltip="Mode sommeil" onclick="send('dodo', this)">DODO</button>
    </div>

    <div style="margin-top:12px">
      <b>Actions</b><span class="help" data-tip="Actions rapides (pauses, activites).">?</span><br/>
      <div class="grid" id="actionsGrid" style="margin-top:10px"></div>
    </div>

    <div style="margin-top:12px">
      <b>Comptage alcool</b><span class="help" data-tip="Ajoute ou ajuste les consommations du jour.">?</span>
      <!-- [UX_BEHAVIORAL_PDF C11] Labels visibles au-dessus des champs -->
      <div class="fieldRow" style="margin-top:10px">
        <div class="fieldGroup">
          <label for="drinkN" class="fieldLabel">Quantite</label>
          <input id="drinkN" class="input drinkInput" type="number" min="1" step="1" value="1" style="width:90px" aria-describedby="drinkHint"/>
        </div>
        <button class="btn tooltip" data-tooltip="Ajouter canette(s) de biere" data-drink-btn="1" onclick="addDrink('beer')">+ BIERE</button>
        <button class="btn tooltip" data-tooltip="Ajouter verre(s) d'alcool fort" data-drink-btn="1" onclick="addDrink('strong')">+ ALCOOL FORT</button>
        <button class="btn tooltip" data-tooltip="Ajouter verre(s) de vin" data-drink-btn="1" onclick="addDrink('wine')">+ VIN</button>
        <small id="drinkStatus" role="status" aria-live="polite">-</small>
      </div>
      <small id="drinkHint" class="fieldHint">Quantite minimum : 1</small>
      <div style="margin-top:8px">
        <button class="btn ghost" id="adjustToggle" aria-expanded="false" aria-controls="adjustWrap">Afficher ajustements</button>
      </div>
      <div id="adjustWrap" class="disclose" style="margin-top:8px">
        <!-- [UX_BEHAVIORAL_PDF C11] Labels visibles au-dessus des champs -->
        <div class="fieldRow">
          <div class="fieldGroup">
            <label for="adjustType" class="fieldLabel">Type</label>
            <select id="adjustType" class="input" style="width:140px">
              <option value="beer" selected>Total biere</option>
              <option value="wine">Total vin</option>
              <option value="strong">Total alcool fort</option>
            </select>
          </div>
          <div class="fieldGroup">
            <label for="adjustTotal" class="fieldLabel">Nouveau total</label>
            <input id="adjustTotal" class="input adjustInput" type="number" min="0" step="1" value="0" style="width:90px" aria-describedby="adjustHint"/>
          </div>
          <button class="btn tooltip" data-tooltip="Ajuster le total du jour" data-adjust-btn="1" onclick="adjustDrink()">Ajuster</button>
          <small id="adjustStatus" role="status" aria-live="polite">-</small>
        </div>
        <small class="muted">Ajuste le total du jour (ajoute seulement la difference).</small>
        <small id="adjustHint" class="fieldHint">Total minimum : 0</small>
      </div>
      <div id="drinkRecent" class="recentList"></div>
    </div>

    <div class="row" style="margin-top:10px">
      <button class="btn tooltip" data-tooltip="Redémarrer le moteur de suivi" onclick="restartEngine()">Restart Engine</button>
      <small id="engineStatus" role="status" aria-live="polite">-</small>
    </div>

    <div class="row" style="margin-top:10px">
      <span id="status" class="pill" role="status" aria-live="polite">-</span>
    </div>
  </div>

  <div class="card reveal d5">
    <h2>Calendrier - __YM__</h2>
    <table>
      <tr><th>Lun</th><th>Mar</th><th>Mer</th><th>Jeu</th><th>Ven</th><th>Sam</th><th>Dim</th></tr>
      __CALROWS__
    </table>
    <small>InfernalDay commence a 04:00.</small>
  </div>

  <div class="card reveal d6">
    <h2>Rapport mensuel - __YM__ <span class="help" data-tip="Vue d'ensemble du mois avec tendances et variations.">?</span></h2>
    <div class="chartWrap">
      <canvas id="monthChart"></canvas>
    </div>
    <div class="legend" id="monthLegend"></div>
    <div class="kpiGrid" id="monthKpis"></div>
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
  setTimeout(()=>{ t.style.opacity = "0"; t.style.transform = "translateY(6px)"; }, 2600);
  setTimeout(()=>{ if (t.parentNode) t.parentNode.removeChild(t); }, 3200);
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

const CHART_COLORS = {
  work: "#35d99a",
  sleep: "#6bbcff",
  sport: "#f7bf54",
  marche: "#ffffff",
  manger: "#ff5d8f",
  reveille: "#00d4ff",
  glandouille: "#9b5cff",
  clope: "#ff7a7a",
  alcohol: "#f2a75c"
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
  el.innerHTML = ""
    + "<span><span class='legendDot' style='background:" + CHART_COLORS.work + "'></span>Work</span>"
    + "<span><span class='legendDot' style='background:" + CHART_COLORS.sleep + "'></span>Sleep</span>"
    + "<span><span class='legendDot' style='background:" + CHART_COLORS.sport + "'></span>Sport</span>"
    + "<span><span class='legendDot' style='background:" + CHART_COLORS.marche + "'></span>Marche</span>"
    + "<span><span class='legendDot' style='background:" + CHART_COLORS.manger + "'></span>Manger</span>"
    + "<span><span class='legendDot' style='background:" + CHART_COLORS.reveille + "'></span>R\u00e9veille</span>"
    + "<span><span class='legendDot' style='background:" + CHART_COLORS.glandouille + "'></span>Glandouille</span>"
    + "<span><span class='legendDot' style='background:" + CHART_COLORS.clope + "'></span>Clope (line)</span>"
    + "<span><span class='legendDot' style='background:" + CHART_COLORS.alcohol + "'></span>Alcool (line)</span>";
}

function renderMonthlyChart(data){
  const canvas = document.getElementById("monthChart");
  if (!canvas) return;
  const ctx = canvas.getContext("2d");
  const rect = canvas.getBoundingClientRect();
  const width = rect.width || 800;
  const height = rect.height || 240;
  const dpr = window.devicePixelRatio || 1;
  canvas.width = Math.round(width * dpr);
  canvas.height = Math.round(height * dpr);
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);

  const days = data.days || [];
  if (!days.length) { return; }

  const pad = { left: 36, right: 24, top: 14, bottom: 24 };
  const w = width - pad.left - pad.right;
  const h = height - pad.top - pad.bottom;

  const yMax = 24;
  const yTicks = [0, 3, 6, 9, 12, 15, 18, 21, 24];

  ctx.clearRect(0, 0, width, height);
  ctx.strokeStyle = "rgba(255,255,255,0.22)";
  ctx.lineWidth = 1.2;
  ctx.fillStyle = "rgba(231,237,243,0.8)";
  ctx.font = "10px 'Space Grotesk', sans-serif";
  for (const t of yTicks) {
    const y = pad.top + h - (t / yMax) * h;
    ctx.beginPath();
    ctx.moveTo(pad.left, y);
    ctx.lineTo(pad.left + w, y);
    ctx.stroke();
    ctx.fillText(String(t), 6, y + 3);
  }
  ctx.strokeStyle = "rgba(231,237,243,0.6)";
  ctx.lineWidth = 1.4;
  ctx.beginPath();
  ctx.moveTo(pad.left, pad.top);
  ctx.lineTo(pad.left, pad.top + h);
  ctx.stroke();

  const step = w / days.length;
  const barW = Math.max(2, step * 0.65);

  for (let i = 0; i < days.length; i++) {
    const d = days[i];
    const x = pad.left + i * step + (step - barW) / 2;
    let y = pad.top + h;
    const segs = [
      { v: (d.workMin || 0) / 60, c: CHART_COLORS.work },
      { v: (d.sleepMin || 0) / 60, c: CHART_COLORS.sleep },
      { v: (d.sportMin || 0) / 60, c: CHART_COLORS.sport },
      { v: (d.marcheMin || 0) / 60, c: CHART_COLORS.marche },
      { v: (d.mangerMin || 0) / 60, c: CHART_COLORS.manger },
      { v: (d.reveilleMin || 0) / 60, c: CHART_COLORS.reveille },
      { v: (d.glandouilleMin || 0) / 60, c: CHART_COLORS.glandouille }
    ];
    const total = segs.reduce((sum, s) => sum + s.v, 0);
    const scale = total > yMax ? (yMax / total) : 1;
    for (const s of segs) {
      const segH = ((s.v * scale) / yMax) * h;
      if (segH <= 0) { continue; }
      y -= segH;
      ctx.fillStyle = s.c;
      ctx.fillRect(x, y, barW, segH);
    }
  }

  ctx.strokeStyle = CHART_COLORS.clope;
  ctx.lineWidth = 1.6;
  ctx.setLineDash([]);
  ctx.beginPath();
  for (let i = 0; i < days.length; i++) {
    const d = days[i];
    const x = pad.left + i * step + step / 2;
    const y = pad.top + h - (Math.min(yMax, (d.clopeCount || 0)) / yMax) * h;
    if (i === 0) { ctx.moveTo(x, y); } else { ctx.lineTo(x, y); }
  }
  ctx.stroke();
  ctx.fillStyle = CHART_COLORS.clope;
  for (let i = 0; i < days.length; i++) {
    const d = days[i];
    const x = pad.left + i * step + step / 2;
    const y = pad.top + h - (Math.min(yMax, (d.clopeCount || 0)) / yMax) * h;
    ctx.beginPath();
    ctx.arc(x, y, 2.2, 0, Math.PI * 2);
    ctx.fill();
  }

  ctx.strokeStyle = CHART_COLORS.alcohol;
  ctx.lineWidth = 1.4;
  ctx.setLineDash([4, 4]);
  ctx.beginPath();
  for (let i = 0; i < days.length; i++) {
    const d = days[i];
    const x = pad.left + i * step + step / 2;
    const y = pad.top + h - (Math.min(yMax, (d.alcoholCount || 0)) / yMax) * h;
    if (i === 0) { ctx.moveTo(x, y); } else { ctx.lineTo(x, y); }
  }
  ctx.stroke();
  ctx.setLineDash([]);

  ctx.fillStyle = "rgba(231,237,243,0.5)";
  ctx.font = "10px 'Space Grotesk', sans-serif";
  for (let i = 0; i < days.length; i++) {
    const day = days[i].day;
    if (day === 1 || day === days.length || day % 5 === 0) {
      const x = pad.left + i * step + step / 2 - 4;
      ctx.fillText(String(day), x, pad.top + h + 14);
    }
  }
}

let MONTHLY_DATA = null;
function renderMonthlyKpis(data){
  const s = data.summary || {};
  const d = data.delta || {};
  const alc = s.alcohol || {};
  const el = document.getElementById("monthKpis");
  if (!el) return;

  const deltaSleepHr = (d.avgSleepMin || 0) / 60;
  const deltaWorkHr = (d.avgWorkMin || 0) / 60;

  const items = [
    { label: "Avg sleep / day", val: fmtHoursFromMin(s.avgSleepMin), delta: fmtDelta(deltaSleepHr, "h/day", 1) },
    { label: "Avg work / day", val: fmtHoursFromMin(s.avgWorkMin), delta: fmtDelta(deltaWorkHr, "h/day", 1) },
    { label: "Avg work session", val: fmtMinVal(s.avgWorkSessionMin), delta: fmtDelta(d.avgWorkSessionMin, "min", 1) },
    { label: "Avg sport / day", val: fmtMinVal(s.avgSportMin), delta: fmtDelta(d.avgSportMin, "min/day", 1) },
    { label: "Clope avg / day", val: (Number(s.avgClopeCount) || 0).toFixed(2), delta: fmtDelta(d.avgClopeCount, "per day", 2) },
    { label: "Alcool total", val: (Number(alc.totalLiters) || 0).toFixed(2) + " L", delta: "-" },
    { label: "Alcool avg / day", val: (Number(alc.avgDrinksPerDay) || 0).toFixed(2), delta: fmtDelta(d.avgAlcoholPerDay, "per day", 2) },
    { label: "Total work", val: fmtHoursFromMin(s.totalWorkMin), delta: "-" },
    { label: "Clope-free days", val: String(s.clopeFreeDays || 0), delta: "-" }
  ];

  el.innerHTML = items.map(it =>
    "<div class='kpiTile'>"
    + "<div class='kpiLabel'>" + escapeHtml(it.label) + "</div>"
    + "<div class='kpiVal'>" + escapeHtml(it.val) + "</div>"
    + "<div class='kpiDelta'>" + escapeHtml(it.delta || "-") + "</div>"
    + "</div>"
  ).join("");
}

function renderMonthlyNotes(data){
  const el = document.getElementById("monthNotes");
  if (!el) return;
  const notes = data.insights || [];
  if (!notes.length) {
    el.innerHTML = "<div class='emptyState'><div class='emptyTitle'>Aucun insight</div><div class='emptyDesc'>Les notes apparaitront apres analyse des donnees.</div></div>";
    return;
  }
  el.innerHTML = notes.map(n => "<div class='notesLine'>- " + escapeHtml(n) + "</div>").join("");
}

function showMonthlyLoading(){
  const k = document.getElementById("monthKpis");
  if (k) {
    k.innerHTML = "<div class='kpiTile skeleton'></div><div class='kpiTile skeleton'></div><div class='kpiTile skeleton'></div>";
  }
  const n = document.getElementById("monthNotes");
  if (n) { n.innerHTML = "<div class='muted'>Chargement...</div>"; }
  const l = document.getElementById("monthLegend");
  if (l) { l.innerHTML = "<span class='muted'>Chargement...</span>"; }
}

async function loadMonthlySummary(){
  const monthKey = "__YM__";
  showMonthlyLoading();
  const data = await getJSON("/api/monthly-summary?m=" + encodeURIComponent(monthKey));
  if (!data || !data.ok) { showToast("Erreur chargement rapport mensuel.", "error", "Rapport"); return; }
  MONTHLY_DATA = data;
  renderMonthlyLegend();
  renderMonthlyChart(data);
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
      document.getElementById("kSeg2").textContent = "Start timer";
      document.getElementById("kTimer").textContent = "-";
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
    document.getElementById("kRemain2").textContent =
      "Goal: " + fmtMin(j.goalWorkSec) + "m - Done: " + fmtMin(doneSec) + "m - Break: " + fmtMin(breakSec) + "m";

    const denom = (j.goalWorkSec || 0);
    const pct = denom > 0 ? Math.min(100, (doneSec/denom)*100) : 0;
    document.getElementById("bar").style.width = pct.toFixed(1) + "%";

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
    if(j.awaitOk) flags.push("WAIT_OK");
    if(j.paused) flags.push("PAUSED");
    if(j.resumeDetected) flags.push("RESUME_GAP");
    document.getElementById("kSeg2").textContent = flags.length ? flags.join(" - ") : "RUN";

    let tline = "elapsed " + fmtMin(j.elapsedSec) + "m";
    if(j.remainSec != null) tline = "remaining " + fmtMin(j.remainSec) + "m - " + tline;

    if(j.overtimeSec > 0){
      document.getElementById("kTimer").innerHTML = "OVERTIME <span class='alertText'>+" + fmtMin(j.overtimeSec) + "m</span> - " + tline;
      document.getElementById("liveCard").classList.add("alert");
    } else {
      document.getElementById("kTimer").textContent = tline;
      document.getElementById("liveCard").classList.remove("alert");
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
      const recA = (Number(f.bestAnyFromWakeMin) > 0) ? (Number(f.bestAnyFromWakeMin) + "m (" + (f.bestAnyDate || "-") + ")") : "-";

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

setInterval(refreshLive, 1000);
refreshLive();
loadSettings();
loadMonthlySummary();
initOnboarding();
initAdjustToggle();
initRippleEffects();
updateOfflineCount();
syncOfflineQueue();
if (drinkInput) { drinkInput.addEventListener("input", validateDrinkInput); }
if (adjustInput) { adjustInput.addEventListener("input", validateAdjustInput); }
validateDrinkInput();
validateAdjustInput();
window.addEventListener("resize", ()=>{ if (MONTHLY_DATA) { renderMonthlyChart(MONTHLY_DATA); } });

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
