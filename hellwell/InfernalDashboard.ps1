param(
  [string]$HostAddr = "127.0.0.1",
  [int]$Port = 8011
)

$ErrorActionPreference = "Stop"
Import-Module (Join-Path $PSScriptRoot "InfernalIO.psm1") -Force


. (Join-Path $PSScriptRoot "dashboard" "Dashboard.Functions.ps1")
. (Join-Path $PSScriptRoot "dashboard" "Dashboard.Page.ps1")

if (Test-PsesHost) {
  $pwsh = Join-Path $PSHOME "pwsh.exe"
  if (-not (Test-Path $pwsh)) { $pwsh = "pwsh" }
  Start-Process $pwsh -ArgumentList @("-NoProfile","-ExecutionPolicy","Bypass","-File",$PSCommandPath,"-HostAddr",$HostAddr,"-Port",$Port) -WindowStyle Hidden | Out-Null
  Write-Host "Dashboard spawned in separate process to avoid EditorServices conflict." -ForegroundColor Yellow
  return
}

$M_STATE    = "Local\InfernalWheel_State"
$M_SETTINGS = "Local\InfernalWheel_Settings"
$M_NOTES    = "Local\InfernalWheel_Notes"

$DataDir       = Join-Path $env:USERPROFILE ".infernal_wheel"
$StatePath     = Join-Path $DataDir "state.json"
$StateBakPath  = Join-Path $DataDir "state.json.bak"
$HeartbeatPath = Join-Path $DataDir "heartbeat.txt"
$CmdFile       = Join-Path $DataDir "commands.in"
$SettingsPath  = Join-Path $DataDir "settings.json"
$SettingsBak   = Join-Path $DataDir "settings.json.bak"
$LogPath       = Join-Path $DataDir "log.csv"
$NotesDir      = Join-Path $DataDir "notes"
$DrinksPath    = Join-Path $DataDir "drinks.csv"
$DrinksLogPath = Join-Path $DataDir "drinks.log"
$RecordsPath   = Join-Path $DataDir "records.json"
$RecordsBak    = Join-Path $DataDir "records.json.bak"
$QuickNotePath = Join-Path $DataDir "quicknote.txt"
$ActionNotePath = Join-Path $DataDir "actionnote.txt"
$CmdSentLogPath = Join-Path $DataDir "commands.sent.log"
$PidPath       = Join-Path $DataDir "dashboard.pid"
$TimerPidPath  = Join-Path $DataDir "timer.pid"
$DashPortPath  = Join-Path $DataDir "dashboard.port"
$DashLogPath   = Join-Path $DataDir "dashboard_error.log"

New-Item -ItemType Directory -Path $DataDir -Force | Out-Null
New-Item -ItemType Directory -Path $NotesDir -Force | Out-Null
if (-not (Test-Path $CmdFile)) { Write-TextAtomic -Path $CmdFile -Text "" }
if (-not (Test-Path $DrinksPath)) {
  Write-TextAtomic -Path $DrinksPath -Text "At,InfernalDay,Wine,Beer,Strong"
}

try { Write-TextAtomic -Path $PidPath -Text "$PID" } catch {}

$WINE_L   = 0.2
$BEER_L   = 0.5
$STRONG_L = 0.2
$WINE_ABV = 0.13
$BEER_ABV = 0.05
$STRONG_ABV = 0.40
$WINE_BOTTLE_L = 0.75
$STRONG_BOTTLE_L = 0.70

$dashMutex = [System.Threading.Mutex]::new($false, "Local\InfernalWheel_Dashboard")
if (-not $dashMutex.WaitOne(0)) {
  Write-Host "InfernalDashboard already running." -ForegroundColor Yellow
  return
}

$listenerInfo = $null
try {
  $listenerInfo = Start-HttpListenerFixed -HostAddr $HostAddr -Port $Port
} catch {
  Write-ErrorLog -Path $DashLogPath -Context "HttpListener.Start" -Exception $_.Exception
  return
}
$listener = $listenerInfo.Listener
$Port = [int]$listenerInfo.Port
$prefix = $listenerInfo.Prefix
try { Write-TextAtomic -Path $DashPortPath -Text "$Port" } catch {}
Write-Host "InfernalDashboard running on $prefix" -ForegroundColor Green

while ($true) {
  $ctx = $listener.GetContext()
  try {
    $path = $ctx.Request.Url.AbsolutePath
    $qs = ConvertFrom-QueryString $ctx.Request.Url.Query

    if ($ctx.Request.HttpMethod -eq "GET") {
      if ($path -eq "/") {
        $m = $null
        if ($qs.ContainsKey("m")) { $m = $qs["m"] }
        $html = New-PageHtml $m
        try { $ctx.Response.Headers["Cache-Control"] = "no-store, no-cache, must-revalidate" } catch {}
        Write-HttpResponse $ctx 200 "text/html; charset=utf-8" (ConvertTo-HttpBytes $html)
        continue
      }
      if ($path -eq "/api/state") {
        $payload = Get-LiveStatePayload
        if ($payload.ok) {
          $todayKey = Get-InfernalDayKey (Get-Date)
          $payload.dailyAlcohol = Get-DailyAlcoholTotals $todayKey
        }
        Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes ($payload | ConvertTo-Json -Depth 12))
        continue
      }
      if ($path -eq "/api/note") {
        $d = if ($qs.ContainsKey("d")) { $qs["d"] } else { (Get-Date).ToString("yyyy-MM-dd") }
        $content = Get-NoteContent $d
        Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true; day=$d; content=$content} | ConvertTo-Json -Depth 6))
        continue
      }
      if ($path -eq "/api/quicknote") {
        $content = Get-QuickNote
        Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true; content=$content} | ConvertTo-Json -Depth 6))
        continue
      }
      if ($path -eq "/api/actionnote") {
        $content = Get-ActionNote
        Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true; content=$content} | ConvertTo-Json -Depth 6))
        continue
      }
      if ($path -eq "/api/settings") {
        $s = Invoke-WithMutexRetry -Name $M_SETTINGS -TimeoutMs 1200 -Retries 10 -Script {
          Read-JsonSafe -Path $SettingsPath -BackupPath $SettingsBak
        }
        if (-not $s) { $s = @{ penalty=@{ enableOvertimeCounter=$true }; actions=@() } }
        Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes ($s | ConvertTo-Json -Depth 12))
        continue
      }
      if ($path -eq "/api/drinks/weeks") {
        $weeks = Get-WeeklyAlcoholLiters
        Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes ($weeks | ConvertTo-Json -Depth 6))
        continue
      }
      if ($path -eq "/api/monthly-summary") {
        $m = if ($qs.ContainsKey("m")) { $qs["m"] } else { (Get-Date).ToString("yyyy-MM") }
        $payload = Get-MonthlySummary $m
        Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes ($payload | ConvertTo-Json -Depth 8))
        continue
      }
      if ($path -eq "/ux") {
        $page = @'
<!doctype html>
<html><head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>UX Lab</title>
<style>
body{margin:0;font-family:system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;background:#0b0f14;color:#e5e7eb;line-height:1.5}
a{color:#6bbcff;text-decoration:none}
.wrap{max-width:1200px;margin:0 auto;padding:16px}
.top{position:sticky;top:0;background:rgba(11,15,20,.9);backdrop-filter:blur(8px);border-bottom:1px solid #1f2937;z-index:1000}
.top .row{display:flex;gap:12px;flex-wrap:wrap;align-items:center;justify-content:space-between;padding:12px 16px}
.pill{border:1px solid #1f2937;border-radius:999px;padding:6px 10px;font-size:.85rem;color:#a7b3bf}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:16px}
.card{border:1px solid #1f2937;border-radius:10px;background:rgba(255,255,255,.03);padding:14px}
.btn{border:1px solid #1f2937;background:rgba(255,255,255,.04);color:#e5e7eb;border-radius:8px;padding:8px 12px;cursor:pointer}
.btn.ghost{background:transparent;border-color:rgba(255,255,255,.25)}
.btn:disabled{opacity:.6;cursor:not-allowed}
.help{display:inline-flex;align-items:center;justify-content:center;width:18px;height:18px;border-radius:999px;border:1px solid rgba(255,255,255,.35);color:#a7b3bf;font-size:.75rem;margin-left:6px}
.row{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
.muted{color:#9ca3af}
.toastHost{position:fixed;right:16px;bottom:16px;display:flex;flex-direction:column;gap:8px;z-index:2000}
.toast{background:rgba(18,24,32,.95);border:1px solid #1f2937;border-left:4px solid #6bbcff;color:#e5e7eb;padding:10px 12px;border-radius:10px;min-width:240px;box-shadow:0 8px 24px rgba(0,0,0,.35)}
.toast.success{border-left-color:#35d99a}
.toast.error{border-left-color:#ff7a7a}
.toast.warn{border-left-color:#f7bf54}
.toastTitle{font-weight:800;font-size:.9rem}
.toastMsg{font-size:.85rem;color:#a7b3bf;margin-top:2px}
.loadingBar{height:6px;border-radius:999px;background:#111827;overflow:hidden;border:1px solid #1f2937}
.loadingInner{height:100%;width:30%;background:linear-gradient(90deg, rgba(107,188,255,.2), rgba(107,188,255,.9), rgba(107,188,255,.2));animation:load 1.2s linear infinite}
@keyframes load{0%{transform:translateX(-100%)}100%{transform:translateX(300%)}}
.skeleton{height:14px;background:rgba(255,255,255,.06);border-radius:6px;position:relative;overflow:hidden}
.skeleton::after{content:"";position:absolute;inset:0;background:linear-gradient(90deg, transparent, rgba(255,255,255,.12), transparent);transform:translateX(-100%);animation:sk 1.2s ease-in-out infinite}
@keyframes sk{0%{transform:translateX(-100%)}100%{transform:translateX(100%)}}
.emptyState{border:1px dashed #1f2937;border-radius:8px;padding:10px;color:#9ca3af}
.table{width:100%;border-collapse:collapse}
.table th,.table td{padding:6px;border-bottom:1px solid #1f2937;text-align:left}
.badge{padding:2px 6px;border-radius:6px;border:1px solid #1f2937}
.wizard{display:grid;gap:8px}
.step{display:none}
.step.active{display:block}
.progress{height:6px;background:#111827;border-radius:999px;overflow:hidden;border:1px solid #1f2937}
.progress > div{height:100%;background:#6bbcff;width:0%}
.dragList{display:grid;gap:6px}
.dragItem{padding:8px;border:1px solid #1f2937;border-radius:8px;background:rgba(255,255,255,.03);cursor:grab}
.input{border:1px solid #1f2937;background:rgba(255,255,255,.04);color:#e5e7eb;border-radius:6px;padding:6px 8px}
.input.invalid{border-color:#ff7a7a}
.fieldHint{font-size:.8rem;color:#9ca3af}
.fieldHint.error{color:#ffb3b3}
.navcol{position:sticky;top:70px}
.navcol a{display:block;padding:4px 0;color:#a7b3bf}
.section{scroll-margin-top:80px}
</style></head>
<body>
<div class="top"><div class="row">
  <div class="row"><b>UX Lab</b> <span class="pill">Patterns appliques</span></div>
  <div class="row"><a class="pill" href="/">Dashboard</a></div>
</div></div>
<div class="wrap">
  <div class="grid" style="grid-template-columns:220px 1fr">
    <div class="navcol">
      <div class="card">
        <b>Navigation</b>
        <a href="#loading">Loading</a>
        <a href="#empty">Empty</a>
        <a href="#error">Error</a>
        <a href="#success">Success</a>
        <a href="#disabled">Disabled</a>
        <a href="#onboarding">Onboarding</a>
        <a href="#disclosure">Disclosure</a>
        <a href="#wizard">Wizard</a>
        <a href="#search">Search</a>
        <a href="#selection">Selection</a>
        <a href="#drag">Drag</a>
        <a href="#data">Data display</a>
        <a href="#notifications">Notifications</a>
        <a href="#help">Help</a>
        <a href="#trust">Trust</a>
        <a href="#privacy">Privacy</a>
      </div>
    </div>
    <div>
      <div id="loading" class="card section">
        <h3>Loading states</h3>
        <div class="row"><button class="btn" id="btnLoad">Simuler chargement</button><span class="muted">progress determinate + skeleton</span></div>
        <div class="loadingBar" id="loadingBar" style="margin-top:8px;display:none"><div class="loadingInner"></div></div>
        <div id="skelWrap" style="margin-top:8px;display:none">
          <div class="skeleton"></div><div class="skeleton" style="margin-top:6px"></div>
        </div>
      </div>

      <div id="empty" class="card section">
        <h3>Empty states</h3>
        <div class="emptyState">Aucun element. <span class="muted">Ajoute un item pour commencer.</span></div>
      </div>

      <div id="error" class="card section">
        <h3>Error states</h3>
        <div class="row">
          <input id="email" class="input" placeholder="email@exemple.com"/>
          <button class="btn" id="btnValidate">Valider</button>
        </div>
        <div id="emailHint" class="fieldHint">Format requis : nom@domaine</div>
      </div>

      <div id="success" class="card section">
        <h3>Success feedback</h3>
        <button class="btn" id="btnSuccess">Action OK</button>
      </div>

      <div id="disabled" class="card section">
        <h3>Disabled states</h3>
        <button class="btn" disabled title="Completez les champs">Valider</button>
      </div>

      <div id="onboarding" class="card section">
        <h3>Onboarding</h3>
        <div class="muted">Coach mark simple sur un bouton.</div>
        <button class="btn" id="btnTip">Afficher tips</button>
        <div id="tipBox" class="emptyState" style="display:none;margin-top:8px">Tip: Commence par une action principale.</div>
      </div>

      <div id="disclosure" class="card section">
        <h3>Progressive disclosure</h3>
        <button class="btn ghost" id="toggleAdvanced">Afficher options avancees</button>
        <div id="advanced" class="emptyState" style="display:none;margin-top:8px">Options avancees ici.</div>
      </div>

      <div id="wizard" class="card section">
        <h3>Wizard / multi-step</h3>
        <div class="progress"><div id="wizBar"></div></div>
        <div class="wizard">
          <div class="step active" data-step="1">
            <div class="row"><input class="input" placeholder="Nom"/></div>
          </div>
          <div class="step" data-step="2">
            <div class="row"><input class="input" placeholder="Email"/></div>
          </div>
          <div class="step" data-step="3">
            <div class="emptyState">Resume avant validation.</div>
          </div>
          <div class="row">
            <button class="btn ghost" id="wizPrev">Retour</button>
            <button class="btn" id="wizNext">Suivant</button>
          </div>
        </div>
      </div>

      <div id="search" class="card section">
        <h3>Search & filter</h3>
        <div class="row">
          <input id="q" class="input" placeholder="Rechercher..."/>
          <select id="f" class="input">
            <option value="">Tous</option>
            <option value="work">Work</option>
            <option value="break">Break</option>
          </select>
          <button class="btn ghost" id="reset">Reset</button>
        </div>
        <div id="list" style="margin-top:8px"></div>
      </div>

      <div id="selection" class="card section">
        <h3>Selections</h3>
        <div class="row"><input type="checkbox" id="selAll"/> <label for="selAll">Select all</label> <span id="selCount" class="badge">0 selected</span></div>
        <div id="selList" style="margin-top:6px"></div>
      </div>

      <div id="drag" class="card section">
        <h3>Drag & drop</h3>
        <div class="dragList" id="dragList"></div>
      </div>

      <div id="data" class="card section">
        <h3>Data display</h3>
        <div class="row"><button class="btn ghost" id="viewTable">Table</button><button class="btn ghost" id="viewCards">Cards</button></div>
        <div id="dataView" style="margin-top:8px"></div>
      </div>

      <div id="notifications" class="card section">
        <h3>Notifications</h3>
        <div class="row">
          <label><input type="checkbox" checked/> In-app</label>
          <label><input type="checkbox"/> Email</label>
          <label><input type="checkbox"/> Push</label>
        </div>
        <button class="btn" id="btnNotif">Envoyer notification</button>
      </div>

      <div id="help" class="card section">
        <h3>Help & support</h3>
        <div class="emptyState">Besoin d'aide ? Consulte le guide ou contacte le support.</div>
      </div>

      <div id="trust" class="card section">
        <h3>Trust patterns</h3>
        <div class="row"><span class="badge">Local only</span><span class="badge">Donnees sur ton PC</span></div>
      </div>

      <div id="privacy" class="card section">
        <h3>Privacy & consent</h3>
        <div class="row"><label><input type="checkbox" checked/> Sauvegarder mes donnees localement</label></div>
        <div class="row"><label><input type="checkbox"/> Partager donnees anonymes</label></div>
      </div>
    </div>
  </div>
</div>
<div class="toastHost" id="toastHost"></div>
<script>
const toastHost = document.getElementById("toastHost");
function toast(msg, type="info"){
  const t = document.createElement("div");
  t.className = "toast " + type;
  t.innerHTML = "<div class='toastTitle'>Notification</div><div class='toastMsg'>" + msg + "</div>";
  toastHost.appendChild(t);
  setTimeout(()=>{ t.style.opacity="0"; t.style.transform="translateY(6px)"; }, 2600);
  setTimeout(()=>{ if(t.parentNode) t.parentNode.removeChild(t); }, 3200);
}
// Loading
document.getElementById("btnLoad").onclick = ()=>{
  const bar = document.getElementById("loadingBar");
  const sk = document.getElementById("skelWrap");
  bar.style.display="block"; sk.style.display="block";
  setTimeout(()=>{ bar.style.display="none"; sk.style.display="none"; toast("Chargement termine","success"); }, 1800);
};
// Error validation
document.getElementById("btnValidate").onclick = ()=>{
  const email = document.getElementById("email");
  const hint = document.getElementById("emailHint");
  const ok = /.+@.+\\..+/.test(email.value||"");
  email.classList.toggle("invalid", !ok);
  hint.classList.toggle("error", !ok);
  hint.textContent = ok ? "OK" : "Email invalide (ex: nom@domaine)";
  if(ok) toast("Email valide","success"); else toast("Erreur de validation","error");
};
// Success
document.getElementById("btnSuccess").onclick = ()=> toast("Action reussie","success");
// Onboarding tip
document.getElementById("btnTip").onclick = ()=>{
  const t = document.getElementById("tipBox");
  t.style.display = (t.style.display==="none"||!t.style.display) ? "block" : "none";
};
// Disclosure
document.getElementById("toggleAdvanced").onclick = ()=>{
  const a = document.getElementById("advanced");
  const open = a.style.display === "block";
  a.style.display = open ? "none" : "block";
};
// Wizard
let step=1;
const steps=[...document.querySelectorAll(".step")];
function renderStep(){
  steps.forEach(s=>s.classList.remove("active"));
  const cur = steps.find(s=>s.dataset.step==step);
  if(cur) cur.classList.add("active");
  document.getElementById("wizBar").style.width = (step/3*100)+"%";
}
document.getElementById("wizPrev").onclick = ()=>{ step=Math.max(1,step-1); renderStep(); };
document.getElementById("wizNext").onclick = ()=>{ step=Math.min(3,step+1); renderStep(); };
renderStep();
// Search & filter
const items=[{name:"Work session",type:"work"},{name:"Clope break",type:"break"},{name:"Manger",type:"break"}];
function renderList(){
  const q = (document.getElementById("q").value||"").toLowerCase();
  const f = document.getElementById("f").value;
  const list = items.filter(i=>(!f||i.type===f) && i.name.toLowerCase().includes(q));
  const el = document.getElementById("list");
  if(!list.length){ el.innerHTML="<div class='emptyState'>Aucun resultat.</div>"; return; }
  el.innerHTML = list.map(i=>"<div class='card'><b>"+i.name+"</b> <span class='badge'>"+i.type+"</span></div>").join("");
}
document.getElementById("q").oninput = renderList;
document.getElementById("f").onchange = renderList;
document.getElementById("reset").onclick = ()=>{ document.getElementById("q").value=""; document.getElementById("f").value=""; renderList(); };
renderList();
// Selection
const selItems=["A","B","C"];
const selList=document.getElementById("selList");
const selAll=document.getElementById("selAll");
const selCount=document.getElementById("selCount");
selItems.forEach((x,i)=>{
  const id="sel_"+i;
  selList.innerHTML += "<div><input type='checkbox' id='"+id+"'> <label for='"+id+"'>Item "+x+"</label></div>";
});
function updateSel(){
  const boxes=[...selList.querySelectorAll("input[type=checkbox]")];
  const c=boxes.filter(b=>b.checked).length;
  selCount.textContent = c+" selected";
  selAll.checked = c===boxes.length;
}
selList.addEventListener("change", updateSel);
selAll.addEventListener("change", ()=>{
  const boxes=[...selList.querySelectorAll("input[type=checkbox]")];
  boxes.forEach(b=>b.checked=selAll.checked);
  updateSel();
});
updateSel();
// Drag & drop
const dlist=document.getElementById("dragList");
["Item 1","Item 2","Item 3"].forEach(t=>{
  const el=document.createElement("div");
  el.className="dragItem"; el.draggable=true; el.textContent=t;
  dlist.appendChild(el);
});
let dragSrc=null;
dlist.addEventListener("dragstart",(e)=>{ dragSrc=e.target; });
dlist.addEventListener("dragover",(e)=>{ e.preventDefault(); });
dlist.addEventListener("drop",(e)=>{
  e.preventDefault();
  if(dragSrc && e.target.classList.contains("dragItem") && dragSrc!==e.target){
    dlist.insertBefore(dragSrc, e.target.nextSibling);
  }
});
// Data display
const data=[{week:"W06",wine:0,beer:0},{week:"W05",wine:19,beer:14}];
const dv=document.getElementById("dataView");
function renderTable(){
  dv.innerHTML = "<table class='table'><tr><th>Semaine</th><th>Vin</th><th>Biere</th></tr>" + data.map(d=>"<tr><td>"+d.week+"</td><td>"+d.wine+"</td><td>"+d.beer+"</td></tr>").join("") + "</table>";
}
function renderCards(){
  dv.innerHTML = data.map(d=>"<div class='card'><b>"+d.week+"</b><div>Vin: "+d.wine+"</div><div>Biere: "+d.beer+"</div></div>").join("");
}
document.getElementById("viewTable").onclick = renderTable;
document.getElementById("viewCards").onclick = renderCards;
renderTable();
// Notifications
document.getElementById("btnNotif").onclick = ()=> toast("Nouvelle notification","warn");
</script>
</body></html>
'@
        Write-HttpResponse $ctx 200 "text/html; charset=utf-8" (ConvertTo-HttpBytes $page)
        continue
      }
      if ($path -eq "/notes") {
        $d = if ($qs.ContainsKey("d")) { $qs["d"] } else { (Get-Date).ToString("yyyy-MM-dd") }
        $content = Get-NoteContent $d

        # Récupérer les données du jour pour pré-remplir le template
        $alcTotals = Get-DailyAlcoholTotals $d
        $clopeCount = Get-DailyActionCount $d "clope"
        $workSleep = Get-DailyWorkSleep
        $dayWS = $workSleep[$d]
        $workMin = if ($dayWS) { [math]::Round($dayWS.work / 60) } else { 0 }
        $sleepMin = if ($dayWS) { [math]::Round($dayWS.sleep / 60) } else { 0 }
        $sleepH = [math]::Round($sleepMin / 60, 1)
        $workH = [math]::Round($workMin / 60, 1)

        # Première clope et première bière du jour
        $firstClope = Get-FirstActionTimeForDay $d "clope"
        $firstBeer = Get-FirstDrinkTimeForDay $d "beer"
        $firstClopeStr = if ($firstClope) { $firstClope.ToString("HH:mm") } else { "--:--" }
        $firstBeerStr = if ($firstBeer) { $firstBeer.ToString("HH:mm") } else { "--:--" }

        # Durées des actions
        $actionDurations = Get-DailyActionDurationsForDay $d $null
        $sportMin = if ($actionDurations["sport"]) { [math]::Round($actionDurations["sport"] / 60) } else { 0 }
        $glandouilleMin = if ($actionDurations["glandouille"]) { [math]::Round($actionDurations["glandouille"] / 60) } else { 0 }
        $mangerMin = if ($actionDurations["manger"]) { [math]::Round($actionDurations["manger"] / 60) } else { 0 }

        # Total alcool en unités
        $alcTotal = $alcTotals.beer + $alcTotals.wine + $alcTotals.strong
        $alcStr = if ($alcTotal -gt 0) { "$($alcTotals.beer)B $($alcTotals.wine)V $($alcTotals.strong)AF" } else { "0" }

        $page = @"
<!doctype html><html lang="fr"><head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>Notes $d - InfernalWheel</title>
<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700;800;900&display=swap" rel="stylesheet"/>
<style>
/* [UX_SPACING_PDF] Design tokens - 4px base system (4,8,12,16,20,24,32,40,48,64,80,96) */
:root{
  --bg:#0e1319; --panel:#121820; --panel-2:#141c25; --border:#24303c;
  --text:#e7edf3; --muted:#a7b3bf;
  --accent:#35d99a; --blue:#6bbcff; --warn:#f7bf54; --danger:#ff7a7a;
  --shadow:0 1px 3px rgba(0,0,0,.1); --r:8px; --r-lg:12px;
  /* [PDF] Spacing scale multiples of 4 */
  --sp-4:4px; --sp-8:8px; --sp-12:12px; --sp-16:16px;
  --sp-20:20px; --sp-24:24px; --sp-32:32px; --sp-40:40px;
  --sp-48:48px; --sp-64:64px; --sp-80:80px; --sp-96:96px;
  /* [PDF] Motion: fast 100-150ms, normal 200-300ms, slow >400ms */
  --transition-fast:150ms; --transition-normal:250ms; --transition-slow:400ms;
  /* [PDF] Typography scale */
  --text-sm:0.875rem; --text-base:1rem; --text-lg:1.125rem; --text-xl:1.25rem;
  --text-2xl:1.5rem; --text-3xl:1.875rem; --text-4xl:2.25rem;
}
*,*::before,*::after{box-sizing:border-box}
html{scroll-behavior:smooth}
body{
  margin:0;
  /* [PDF] Page margins: ~12px mobile, ~32px tablet, ~80px desktop */
  padding:var(--sp-12);
  font-family:'Space Grotesk',system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;
  background:var(--bg); color:var(--text); line-height:1.5; letter-spacing:normal; word-spacing:normal;
  min-height:100vh;
  font-size:var(--text-base);
}
@media(min-width:768px){body{padding:var(--sp-32)}}
@media(min-width:1024px){body{padding:var(--sp-80)}}

/* [skip_link_wcag_2_4_1] skip link */
.skip-link{position:absolute;top:-40px;left:0;background:var(--accent);color:#000;padding:.5rem 1rem;z-index:100;border-radius:0 0 8px 0;font-weight:700;text-decoration:none}
.skip-link:focus{top:0}

/* [form_label_wcag_1_3_1] visually hidden labels */
.sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}

/* [PDF] Container max-width ~1120px */
.container{max-width:1120px; margin:0 auto}

/* [WEB] Topbar navigation - height 56px mobile, 64px desktop */
.topbar{
  display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:var(--sp-16);
  padding:var(--sp-12) var(--sp-16); margin-bottom:var(--sp-24);
  min-height:56px;
  border:1px solid rgba(255,255,255,.12); border-radius:var(--r-lg);
  background:linear-gradient(135deg, rgba(255,255,255,.06), rgba(255,255,255,.02));
  backdrop-filter:blur(12px); -webkit-backdrop-filter:blur(12px);
  box-shadow:0 4px 20px rgba(0,0,0,.3);
}
@media(min-width:768px){.topbar{min-height:64px;padding:var(--sp-16) var(--sp-24)}}
.brand{display:flex; align-items:center; gap:var(--sp-12); flex-wrap:wrap}
.row{display:flex; gap:var(--sp-8); flex-wrap:wrap; align-items:center}

/* [PDF] Back button - prominent, touch target 48x48 */
.btn-back{
  display:inline-flex; align-items:center; justify-content:center; gap:var(--sp-8);
  min-width:48px; min-height:48px; padding:var(--sp-8) var(--sp-16);
  background:linear-gradient(135deg, rgba(53,217,154,.2), rgba(53,217,154,.1));
  border:2px solid rgba(53,217,154,.5); border-radius:var(--r-lg);
  color:var(--accent); font-weight:700; font-size:var(--text-base);
  text-decoration:none; cursor:pointer;
  box-shadow:0 0 20px rgba(53,217,154,.15), 0 4px 12px rgba(0,0,0,.2);
  transition:all var(--transition-normal) ease;
}
.btn-back:hover{
  background:linear-gradient(135deg, rgba(53,217,154,.3), rgba(53,217,154,.2));
  border-color:rgba(53,217,154,.8);
  transform:translateY(-2px);
  box-shadow:0 0 30px rgba(53,217,154,.25), 0 8px 20px rgba(0,0,0,.3);
}
.btn-back:active{transform:translateY(0) scale(0.98)}
.btn-back:focus-visible{outline:2px solid var(--accent);outline-offset:2px}
.btn-back svg{width:20px;height:20px;stroke:currentColor;stroke-width:2.5;fill:none}

/* Pills */
.pill{
  border:1px solid var(--border); border-radius:999px; padding:var(--sp-8) var(--sp-12);
  background:rgba(16,22,29,.6); color:var(--muted); font-size:.875rem; letter-spacing:.2px;
  backdrop-filter:blur(6px); display:inline-flex; align-items:center;
  transition:border-color var(--transition-normal) ease, background var(--transition-normal) ease;
  text-decoration:none; min-height:44px;
}
.pill:hover{border-color:rgba(91,178,255,.5); background:rgba(91,178,255,.08); color:var(--text)}

/* [PDF] Cards - Padding 16px, radius 8px, shadow 0 1px 3px */
.card{
  border:1px solid rgba(255,255,255,.12);
  background:linear-gradient(135deg, rgba(255,255,255,.08), rgba(255,255,255,.02));
  backdrop-filter:blur(12px); -webkit-backdrop-filter:blur(12px);
  /* [PDF] Padding 16px, radius 8px */
  border-radius:var(--r); padding:var(--sp-16); margin-bottom:var(--sp-24);
  box-shadow:var(--shadow), 0 8px 32px rgba(0,0,0,.4), 0 0 0 1px rgba(255,255,255,.05) inset;
  position:relative; overflow:hidden;
  transition:all var(--transition-slow) cubic-bezier(.4,0,.2,1);
}
@media(min-width:768px){.card{padding:var(--sp-24)}}
.card::after{
  content:""; position:absolute; left:-30%; top:-40%; width:120%; height:70%;
  background:radial-gradient(closest-side, rgba(91,178,255,.08), transparent 70%);
  opacity:.45; pointer-events:none;
}
.card:hover{
  border-color:rgba(91,178,255,.5);
  box-shadow:0 12px 40px rgba(0,0,0,.5), 0 0 20px rgba(91,178,255,.1);
}

/* [PDF] Layout - Gutters 16-24px, max-width 1120px */
.notesWrap{max-width:1120px;margin:0 auto}
/* [PDF] Gaps: 16px mobile, 24px desktop - MÊME HAUTEUR */
.notesRow{display:grid;grid-template-columns:1fr;gap:var(--sp-16);align-items:stretch}
@media(min-width:800px){.notesRow{grid-template-columns:1fr 1fr;gap:var(--sp-24)}}

/* Sidebar template - même hauteur que textarea */
.notesBox{
  background:rgba(16,22,29,.6); border:1px solid var(--border); border-radius:var(--r);
  padding:var(--sp-12); font-size:var(--text-sm); line-height:1.5;
  overflow-y:auto;
  display:flex; flex-direction:column; gap:var(--sp-8);
}
/* Template sections */
.tpl-section{
  background:rgba(0,0,0,.2); border:1px solid rgba(255,255,255,.08);
  border-radius:var(--r); padding:var(--sp-12);
  border-left:3px solid var(--accent);
}
.tpl-section.morning{border-left-color:#6bbcff}
.tpl-section.evening{border-left-color:#a78bfa}
.tpl-section.alert{border-left-color:#ff7a7a}
.tpl-section.neutral{border-left-color:var(--muted)}
.tpl-title{
  display:flex; align-items:center; gap:var(--sp-8);
  font-weight:700; font-size:var(--text-sm); color:var(--text);
  margin-bottom:var(--sp-8); padding-bottom:var(--sp-4);
  border-bottom:1px solid rgba(255,255,255,.1);
}
.tpl-title .icon{font-size:1rem}
.tpl-grid{
  display:grid; grid-template-columns:1fr 1fr; gap:var(--sp-4) var(--sp-8);
}
.tpl-grid.single{grid-template-columns:1fr}
.tpl-item{
  display:flex; justify-content:space-between; align-items:center;
  padding:var(--sp-4) 0; color:var(--muted); font-size:.8125rem;
}
.tpl-item .label{color:var(--text); font-weight:500}
.tpl-item .val{
  background:rgba(255,255,255,.08); padding:2px 8px; border-radius:4px;
  font-family:monospace; min-width:40px; text-align:center;
}
/* [UX] Rating field - input + suffix intégrés */
.rating-field{
  display:inline-flex; align-items:stretch;
  border:1px solid var(--border); border-radius:6px;
  background:rgba(255,255,255,.06);
  overflow:hidden;
  transition:all var(--transition-fast) ease;
  min-height:32px;
}
.rating-field:focus-within{
  border-color:var(--accent);
  box-shadow:0 0 0 3px rgba(53,217,154,.15);
}
.rating-field:hover:not(:focus-within){
  border-color:rgba(107,188,255,.4);
  background:rgba(255,255,255,.08);
}
/* Couleurs sémantiques sur le wrapper */
.rating-field.val-bad{border-color:#ff7a7a;background:rgba(255,122,122,.08)}
.rating-field.val-bad:focus-within{box-shadow:0 0 0 3px rgba(255,122,122,.15)}
.rating-field.val-mid{border-color:#f7bf54;background:rgba(247,191,84,.08)}
.rating-field.val-mid:focus-within{box-shadow:0 0 0 3px rgba(247,191,84,.15)}
.rating-field.val-good{border-color:#35d99a;background:rgba(53,217,154,.08)}
.rating-field.val-good:focus-within{box-shadow:0 0 0 3px rgba(53,217,154,.15)}
.rating-field.filled{border-color:var(--accent);background:rgba(53,217,154,.06)}

/* Input inside rating field */
.rating-field .tpl-input{
  width:40px; height:100%; min-height:30px;
  padding:4px 6px;
  background:transparent; border:none;
  color:var(--text); font-size:.875rem; font-weight:600;
  text-align:center; font-family:inherit;
  outline:none;
}
.rating-field .tpl-input::placeholder{color:var(--muted);opacity:.5}
.rating-field .tpl-input::-webkit-inner-spin-button,
.rating-field .tpl-input::-webkit-outer-spin-button{opacity:1;cursor:pointer;height:auto}
/* Couleur du texte selon valeur */
.rating-field.val-bad .tpl-input{color:#ffa0a0}
.rating-field.val-mid .tpl-input{color:#f7d794}
.rating-field.val-good .tpl-input{color:#35d99a}

/* Suffix intégré */
.rating-field .rating-suffix{
  display:flex; align-items:center; justify-content:center;
  padding:0 8px;
  background:rgba(0,0,0,.2);
  color:var(--muted); font-size:.75rem; font-weight:500;
  border-left:1px solid rgba(255,255,255,.08);
  user-select:none;
}
.rating-field.val-bad .rating-suffix{color:rgba(255,160,160,.7)}
.rating-field.val-mid .rating-suffix{color:rgba(247,215,148,.7)}
.rating-field.val-good .rating-suffix{color:rgba(53,217,154,.7)}

/* Fallback pour anciens .tpl-input sans wrapper */
.tpl-input:not(.rating-field .tpl-input){
  width:48px; height:26px; padding:2px 4px;
  background:rgba(255,255,255,.1); border:1px solid var(--border);
  border-radius:4px; color:var(--text); font-size:.8rem;
  text-align:center; font-family:inherit;
}
.tpl-input:not(.rating-field .tpl-input):focus{outline:none;border-color:var(--accent);background:rgba(53,217,154,.15)}
.tpl-suffix:not(.rating-suffix){color:var(--muted);font-size:.7rem;margin-left:2px}
.tpl-list{list-style:none; padding:0; margin:0; display:flex; flex-direction:column; gap:var(--sp-4)}
.tpl-list li{
  display:flex; align-items:center; gap:var(--sp-8);
  padding:var(--sp-4) var(--sp-8); background:rgba(255,255,255,.04);
  border-radius:4px; font-size:.8125rem; color:var(--muted);
}
.tpl-list li::before{content:""; width:12px; height:12px; border:1.5px solid var(--muted); border-radius:3px; flex-shrink:0}
.tpl-note{font-size:.75rem; color:var(--muted); font-style:italic; margin-top:var(--sp-4)}
.tpl-formula{
  background:rgba(107,188,255,.1); border:1px solid rgba(107,188,255,.3);
  padding:var(--sp-8); border-radius:4px; font-family:monospace; font-size:.75rem;
  color:var(--blue); margin-top:var(--sp-4);
}
.tpl-warn{
  background:rgba(255,122,122,.1); border:1px solid rgba(255,122,122,.3);
  padding:var(--sp-8); border-radius:4px; font-size:.75rem;
  color:#ffa0a0; margin-top:var(--sp-4);
}
/* Valeurs remplies par parsing */
.val.filled{background:rgba(53,217,154,.2);color:var(--accent);font-weight:700;border:1px solid rgba(53,217,154,.4)}
.val.empty{background:rgba(255,255,255,.08);color:var(--muted)}
.tpl-list li.checked{color:var(--accent)}
.tpl-list li.checked::before{background:var(--accent);border-color:var(--accent)}
/* Éléments cliquables */
.tpl-hint{font-size:.7rem;color:var(--muted);text-align:center;padding:var(--sp-4);margin-bottom:var(--sp-8);opacity:.7}
.clickable{cursor:pointer;transition:all var(--transition-fast) ease;border-radius:4px}
.clickable:hover{background:rgba(107,188,255,.15);transform:translateX(2px)}
.tpl-list li.clickable:hover{background:rgba(107,188,255,.2)}

/* [PDF] Textarea/Input - même hauteur que sidebar */
.notesTa{
  width:100%; height:100%; min-height:400px; resize:none;
  background:rgba(16,22,29,.6); border:1px solid var(--border); color:var(--text);
  padding:var(--sp-16); border-radius:var(--r); outline:none;
  font-family:inherit; font-size:var(--text-base); line-height:1.6;
  transition:all var(--transition-normal) ease;
}
.notesTa:hover{border-color:rgba(91,178,255,.3);background:rgba(16,22,29,.7)}
.notesTa:focus-visible{
  outline:2px solid var(--blue); outline-offset:2px;
  border-color:var(--blue);
  box-shadow:0 0 0 4px rgba(107,188,255,.15);
}
.notesTa::placeholder{color:var(--muted);opacity:.7}

/* [PDF] Buttons - Height min 40px, width min 64px, radius 4-8px, touch target 48x48 */
.btn{
  border:1px solid var(--border); background:rgba(16,22,29,.65); color:var(--text);
  font-family:inherit;
  /* [PDF] Min height 40px, padding 8px vertical 16px horizontal */
  min-height:40px; min-width:64px; padding:var(--sp-8) var(--sp-16);
  border-radius:var(--r); cursor:pointer; font-weight:600;
  font-size:var(--text-sm);
  box-shadow:0 1px 2px rgba(0,0,0,.18);
  transition:all var(--transition-normal) ease;
  position:relative; overflow:hidden;
}
/* [PDF] Touch target 48x48 for accessibility */
.btn::before{content:"";position:absolute;inset:-4px;z-index:-1}
.btn:hover{transform:translateY(-2px); box-shadow:0 6px 20px rgba(0,0,0,.35);border-color:rgba(91,178,255,.5)}
.btn:active{transform:translateY(0) scale(0.98)}
/* [PDF] Focus: outline 2px */
.btn:focus-visible{outline:2px solid var(--accent);outline-offset:2px;box-shadow:0 0 0 4px rgba(53,217,154,.25)}
.btn.ghost{background:transparent;border-color:rgba(255,255,255,.25)}
.btn.ghost:hover{background:rgba(255,255,255,.08)}
/* [PDF] Disabled: 38-50% opacity */
.btn:disabled{cursor:not-allowed;opacity:.38;filter:grayscale(30%)}
.btn:disabled:hover{transform:none;box-shadow:0 1px 2px rgba(0,0,0,.18)}

/* [UX_PDF] Ripple effect */
.btn{position:relative;overflow:hidden}
.ripple{position:absolute;border-radius:50%;background:rgba(255,255,255,.4);transform:scale(0);animation:rippleAnim .5s ease-out;pointer-events:none}
@keyframes rippleAnim{to{transform:scale(4);opacity:0}}

/* Links */
a{color:var(--blue);text-decoration:none;transition:color var(--transition-fast) ease}
a:hover{color:var(--accent)}
a:focus-visible{outline:2px solid var(--blue);outline-offset:2px}

/* Status indicators */
.status{font-size:.75rem;padding:var(--sp-4) var(--sp-8);border-radius:999px;font-weight:600}
.status.saved{background:rgba(53,217,154,.15);color:var(--accent);border:1px solid rgba(53,217,154,.3)}
.status.saving{background:rgba(247,191,84,.15);color:var(--warn);border:1px solid rgba(247,191,84,.3)}
.status.error{background:rgba(255,122,122,.15);color:var(--danger);border:1px solid rgba(255,122,122,.3)}

/* Header section */
.pageHeader{
  display:flex; justify-content:space-between; align-items:center; gap:var(--sp-16);
  flex-wrap:wrap; margin-bottom:var(--sp-16);
}
.pageTitle{font-weight:900;font-size:1.375rem;margin:0;letter-spacing:.3px}
.pageMeta{color:var(--muted);font-size:.875rem;display:flex;align-items:center;gap:var(--sp-8)}

/* Loading bar */
.loadingBar{position:fixed;top:0;left:0;right:0;height:3px;background:rgba(255,255,255,.06);opacity:0;pointer-events:none;z-index:2000;transition:opacity var(--transition-normal) ease}
.loadingBar.active{opacity:1}
.loadingBarInner{height:100%;width:30%;background:linear-gradient(90deg, rgba(107,188,255,.2), rgba(107,188,255,.9), rgba(107,188,255,.2));animation:loadingMove 1.2s linear infinite}
@keyframes loadingMove{0%{transform:translateX(-100%)}100%{transform:translateX(300%)}}

/* Offline banner */
.offlineBanner{position:fixed;top:var(--sp-8);left:50%;transform:translateX(-50%);background:rgba(255,122,122,.15);border:1px solid rgba(255,122,122,.45);color:#ffd6d6;padding:var(--sp-8) var(--sp-12);border-radius:999px;font-size:.875rem;display:none;z-index:2000}
.offlineBanner.show{display:block}
.offlineBanner .btn{min-height:1.75rem;padding:var(--sp-4) var(--sp-8);margin-left:var(--sp-8)}

/* Toast notifications */
.toastHost{position:fixed;right:var(--sp-16);bottom:var(--sp-16);display:flex;flex-direction:column;gap:var(--sp-8);z-index:2000}
.toast{
  background:rgba(18,24,32,.95);border:1px solid var(--border);border-left:4px solid var(--blue);
  color:var(--text);padding:var(--sp-12);border-radius:10px;min-width:240px;
  box-shadow:0 8px 24px rgba(0,0,0,.35);
  animation:toastIn var(--transition-slow) ease;
}
@keyframes toastIn{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}
.toast.success{border-left-color:var(--accent)}
.toast.error{border-left-color:var(--danger)}
.toast.warn{border-left-color:var(--warn)}
.toastTitle{font-weight:800;font-size:.9rem}
.toastMsg{font-size:.85rem;color:var(--muted);margin-top:2px}

/* [reduced_motion_wcag] respect user preference */
@media(prefers-reduced-motion:reduce){
  *,*::before,*::after{animation-duration:.01ms!important;animation-iteration-count:1!important;transition-duration:.01ms!important;scroll-behavior:auto!important}
}

/* [UI_RULEBOOK] High Contrast Mode */
@media(prefers-contrast:more){
  :root{--bg:#000;--panel:#0a0a0a;--border:#fff;--text:#fff;--muted:#ccc}
  .btn,.pill,.card,.notesTa,.notesBox{border-width:2px;border-color:#fff}
  .btn:hover,.pill:hover{background:#fff;color:#000}
  .btn:focus-visible,.pill:focus-visible,.notesTa:focus-visible{outline-width:3px;outline-color:#fff}
}

/* [UI_RULEBOOK] Forced Colors Mode */
@media(forced-colors:active){
  .btn,.pill,.card,.notesTa,.notesBox{border:2px solid CanvasText;background:Canvas;color:CanvasText}
  .btn:hover,.pill:hover{background:Highlight;color:HighlightText}
  .btn:focus-visible,.pill:focus-visible,.notesTa:focus-visible{outline:3px solid Highlight}
  .btn:disabled{opacity:1;border-style:dashed}
}

/* Scrollbar styling */
::-webkit-scrollbar{width:8px;height:8px}
::-webkit-scrollbar-track{background:rgba(255,255,255,.05);border-radius:4px}
::-webkit-scrollbar-thumb{background:rgba(255,255,255,.2);border-radius:4px}
::-webkit-scrollbar-thumb:hover{background:rgba(255,255,255,.35)}
@supports(scrollbar-color:auto){*{scrollbar-color:rgba(255,255,255,.2) rgba(255,255,255,.05);scrollbar-width:thin}}
</style>
</head>
<body>
<!-- [skip_link_wcag_2_4_1] -->
<a href="#main-content" class="skip-link">Aller au contenu</a>
<div id="globalLoading" class="loadingBar" aria-hidden="true"><div class="loadingBarInner"></div></div>
<div id="offlineBanner" class="offlineBanner" role="status" aria-live="polite">
  Hors ligne
  <button class="btn ghost" id="offlineRetry" type="button">Reessayer</button>
</div>
<div id="toastHost" class="toastHost" aria-live="polite" aria-atomic="true"></div>

<div class="container">
  <!-- [landmark_wcag_1_3_1] nav -->
  <nav class="topbar" aria-label="Navigation principale">
    <div class="brand">
      <!-- [PDF] Back button with icon - touch target 48x48 -->
      <a href="/" class="btn-back" title="Retour au Dashboard">
        <svg viewBox="0 0 24 24" aria-hidden="true"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
        <span>Dashboard</span>
      </a>
      <span class="pill" style="border-color:rgba(53,217,154,.4);background:rgba(53,217,154,.1);color:var(--accent)">
        <svg style="width:16px;height:16px;margin-right:6px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
        Notes
      </span>
    </div>
    <div class="row">
      <span style="font-weight:900;font-size:var(--text-lg);letter-spacing:.3px">InfernalWheel</span>
    </div>
  </nav>

  <!-- [landmark_wcag_1_3_1] main -->
  <main id="main-content">
    <div class="card">
      <div class="pageHeader">
        <h1 class="pageTitle">Notes - $d</h1>
        <div class="pageMeta">
          <span>Autosave 2s</span>
          <span>|</span>
          <span>$d.txt</span>
          <span id="noteStatus" class="status" role="status" aria-live="polite">-</span>
        </div>
      </div>

      <div class="notesRow">
        <div>
          <label for="t" class="sr-only">Notes du jour</label>
          <textarea id="t" class="notesTa" placeholder="Ecris tes notes ici..." aria-label="Notes du jour"></textarea>
        </div>
        <aside class="notesBox" aria-label="Template de check-in">
          <!-- DONNÉES AUTO -->
          <section class="tpl-section" style="border-left-color:var(--accent);background:rgba(53,217,154,.05)">
            <div class="tpl-title"><span class="icon">&#9889;</span> Données Auto</div>
            <div class="tpl-grid">
              <div class="tpl-item"><span class="label">Sommeil</span><span class="val">${sleepH}h</span></div>
              <div class="tpl-item"><span class="label">Travail</span><span class="val">${workH}h</span></div>
              <div class="tpl-item"><span class="label">Clopes</span><span class="val">$clopeCount</span></div>
              <div class="tpl-item"><span class="label">Alcool</span><span class="val">$alcStr</span></div>
              <div class="tpl-item"><span class="label">1ère clope</span><span class="val">$firstClopeStr</span></div>
              <div class="tpl-item"><span class="label">1ère bière</span><span class="val">$firstBeerStr</span></div>
              <div class="tpl-item"><span class="label">Sport</span><span class="val">${sportMin}m</span></div>
              <div class="tpl-item"><span class="label">Glandouille</span><span class="val">${glandouilleMin}m</span></div>
            </div>
          </section>

          <!-- MATIN -->
          <section class="tpl-section morning">
            <div class="tpl-title"><span class="icon">&#9728;</span> Check-in Matin</div>
            <div class="tpl-grid">
              <div class="tpl-item"><span class="label">Qualité sommeil</span><div class="rating-field"><input type="number" class="tpl-input" data-field="qualite" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Énergie</span><div class="rating-field"><input type="number" class="tpl-input" data-field="energie" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Motivation</span><div class="rating-field"><input type="number" class="tpl-input" data-field="motivation" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Douleur</span><div class="rating-field"><input type="number" class="tpl-input" data-field="douleur" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
            </div>
          </section>

          <section class="tpl-section morning">
            <div class="tpl-title"><span class="icon">&#129504;</span> État Mental</div>
            <div class="tpl-grid">
              <div class="tpl-item"><span class="label">Humeur</span><div class="rating-field"><input type="number" class="tpl-input" data-field="humeur" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Anxiété</span><div class="rating-field"><input type="number" class="tpl-input" data-field="anxiete" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Irritabilité</span><div class="rating-field"><input type="number" class="tpl-input" data-field="irritabilite" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Clarté</span><div class="rating-field"><input type="number" class="tpl-input" data-field="clarte" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
            </div>
          </section>

          <section class="tpl-section">
            <div class="tpl-title"><span class="icon">&#127919;</span> Plan TDAH</div>
            <div class="tpl-grid single">
              <div class="tpl-item"><span class="label">Priorité 1</span><input type="text" class="tpl-input" data-field="priorite1" style="flex:1;width:auto" placeholder="..."></div>
              <div class="tpl-item"><span class="label">Priorité 2</span><input type="text" class="tpl-input" data-field="priorite2" style="flex:1;width:auto" placeholder="..."></div>
              <div class="tpl-item"><span class="label">Priorité 3</span><input type="text" class="tpl-input" data-field="priorite3" style="flex:1;width:auto" placeholder="..."></div>
              <div class="tpl-item"><span class="label">Minimum vital</span><input type="text" class="tpl-input" data-field="minimum" style="flex:1;width:auto" placeholder="..."></div>
            </div>
          </section>

          <!-- SOIR -->
          <section class="tpl-section evening">
            <div class="tpl-title"><span class="icon">&#127769;</span> Journal Soir</div>
            <div class="tpl-grid">
              <div class="tpl-item"><span class="label">Humeur soir</span><div class="rating-field"><input type="number" class="tpl-input" data-field="humeur_soir" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Stress</span><div class="rating-field"><input type="number" class="tpl-input" data-field="stress" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Focus</span><div class="rating-field"><input type="number" class="tpl-input" data-field="focus" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Fatigue</span><div class="rating-field"><input type="number" class="tpl-input" data-field="fatigue" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Fierté</span><div class="rating-field"><input type="number" class="tpl-input" data-field="fierte" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
            </div>
          </section>

          <!-- COLÈRE -->
          <section class="tpl-section alert">
            <div class="tpl-title"><span class="icon">&#128293;</span> Colère / Explosions</div>
            <div class="tpl-grid">
              <div class="tpl-item"><span class="label">Épisodes</span><input type="number" class="tpl-input" data-field="episodes" min="0" max="99" placeholder="-"></div>
              <div class="tpl-item"><span class="label">Intensité</span><div class="rating-field"><input type="number" class="tpl-input" data-field="intensite" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
            </div>
            <div class="tpl-note" style="display:flex;gap:8px;align-items:center;flex-wrap:wrap">
              <span>Déclencheur:</span><input type="text" class="tpl-input" data-field="declencheur" style="flex:1;width:auto;min-width:80px" placeholder="...">
            </div>
            <div style="margin-top:8px;font-size:.75rem;color:var(--muted)">Compétences utilisées:</div>
            <ul class="tpl-list">
              <li data-check="pause90"><input type="checkbox" class="tpl-check" data-field="pause90"> Pause 90 secondes</li>
              <li data-check="respiration"><input type="checkbox" class="tpl-check" data-field="respiration"> Respiration 4-6</li>
              <li data-check="sortir"><input type="checkbox" class="tpl-check" data-field="sortir"> Sortir / marcher</li>
              <li data-check="ecrire"><input type="checkbox" class="tpl-check" data-field="ecrire"> Écrire au lieu de parler</li>
            </ul>
          </section>

          <!-- CBT -->
          <section class="tpl-section neutral">
            <div class="tpl-title"><span class="icon">&#128161;</span> CBT Rapide</div>
            <div class="tpl-grid single">
              <div class="tpl-item"><span class="label">Situation</span><input type="text" class="tpl-input" data-field="situation" style="flex:1;width:auto" placeholder="..."></div>
              <div class="tpl-item"><span class="label">Pensée auto</span><input type="text" class="tpl-input" data-field="pensee" style="flex:1;width:auto" placeholder="..."></div>
              <div class="tpl-item"><span class="label">Émotion</span><div class="rating-field"><input type="number" class="tpl-input" data-field="emotion" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Alternative</span><input type="text" class="tpl-input" data-field="alternative" style="flex:1;width:auto" placeholder="..."></div>
            </div>
          </section>

          <!-- BILAN -->
          <section class="tpl-section">
            <div class="tpl-title"><span class="icon">&#128200;</span> Bilan</div>
            <div class="tpl-grid">
              <div class="tpl-item"><span class="label">Score global</span><div class="rating-field"><input type="number" class="tpl-input" data-field="score" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
              <div class="tpl-item"><span class="label">Relations</span><div class="rating-field"><input type="number" class="tpl-input" data-field="relations" min="0" max="6" placeholder="-"><span class="rating-suffix">/6</span></div></div>
            </div>
            <div class="tpl-formula">Stabilité = (Sommeil + (10-Irrit) + (10-Colère) + Focus + Répar) / 5</div>
          </section>

          <!-- GARDE-FOU -->
          <section class="tpl-section alert">
            <div class="tpl-title"><span class="icon">&#128680;</span> Garde-fou</div>
            <div class="tpl-grid single">
              <div class="tpl-item"><span class="label">Idées noires</span><div class="rating-field"><input type="number" class="tpl-input" data-field="ideesnoires" min="0" max="10" placeholder="-"><span class="rating-suffix">/10</span></div></div>
            </div>
            <div class="tpl-warn">Si 8-10: parler à un pro ou quelqu'un de confiance</div>
          </section>
        </aside>
      </div>
    </div>
  </main>

  <!-- [UX_BEHAVIORAL_PDF E19] Trust Pattern -->
  <footer style="text-align:center;padding:var(--sp-16);color:var(--muted);font-size:.8125rem">
    <span style="margin-right:var(--sp-8)">&#128274;</span>
    Donnees 100% locales - Aucune donnee envoyee
  </footer>
</div>
<script>
const day = "$d";
const ta = document.getElementById("t");
const noteStatus = document.getElementById("noteStatus");
let pendingReq = 0;
let lastNetErrorAt = 0;

/* [UX_PDF] Status display with classes */
function setNoteStatus(text, type=""){
  noteStatus.textContent = text;
  noteStatus.className = "status" + (type ? " " + type : "");
}
setNoteStatus("loading...", "saving");

/* Loading bar */
function setLoading(on){
  const bar = document.getElementById("globalLoading");
  if (!bar) return;
  if (on) { bar.classList.add("active"); }
  else { bar.classList.remove("active"); }
}
function requestStart(){ pendingReq++; setLoading(true); }
function requestEnd(){ pendingReq = Math.max(0, pendingReq - 1); if (pendingReq === 0) { setLoading(false); } }

/* Offline handling */
function setOffline(isOff){
  const b = document.getElementById("offlineBanner");
  if (!b) return;
  if (isOff) { b.classList.add("show"); }
  else { b.classList.remove("show"); }
}

/* [UX_PDF] Toast notifications */
function showToast(message, type="info", title=""){
  const host = document.getElementById("toastHost");
  if (!host) return;
  const t = document.createElement("div");
  t.className = "toast " + type;
  const ttl = title ? ("<div class='toastTitle'>" + title + "</div>") : "";
  t.innerHTML = ttl + "<div class='toastMsg'>" + message + "</div>";
  host.appendChild(t);
  setTimeout(()=>{ t.style.opacity = "0"; t.style.transform = "translateY(6px)"; }, 2600);
  setTimeout(()=>{ if (t.parentNode) t.parentNode.removeChild(t); }, 3200);
}

function notifyNetError(){
  setOffline(true);
  const now = Date.now();
  if (now - lastNetErrorAt > 30000) {
    showToast("Connexion impossible.", "error", "Reseau");
    lastNetErrorAt = now;
  }
}

/* Network events */
window.addEventListener("online", ()=>{ setOffline(false); showToast("Connexion retablie.", "success", "Reseau"); });
window.addEventListener("offline", ()=>{ setOffline(true); showToast("Hors ligne.", "error", "Reseau"); });
setOffline(navigator && navigator.onLine === false);

const retryBtn = document.getElementById("offlineRetry");
if (retryBtn) {
  retryBtn.addEventListener("click", ()=>{ loadNote(); });
}

/* [UX_PDF] Ripple effect */
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
  const existing = btn.querySelector(".ripple");
  if(existing){ existing.remove(); }
  btn.appendChild(circle);
  setTimeout(()=>{ if(circle.parentNode) circle.remove(); }, 500);
}
function initRippleEffects(){
  document.querySelectorAll(".btn").forEach(btn=>{
    btn.addEventListener("click", createRipple);
  });
}

/* API helpers */
async function postJSON(url, obj){
  requestStart();
  try{
    const r = await fetch(url, {method:"POST", headers:{"Content-Type":"application/json"}, body:JSON.stringify(obj), cache:"no-store"});
    if(!r.ok){ notifyNetError(); return {ok:false}; }
    return await r.json();
  } catch(e){
    notifyNetError();
    return {ok:false};
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

/* Note loading */
async function loadNote(){
  setNoteStatus("loading...", "saving");
  const j = await getJSON("/api/note?d=" + encodeURIComponent(day));
  if(j && j.ok){
    ta.value = j.content || "";
    lastSent = ta.value || "";
    dirty = false;
    setNoteStatus("loaded", "saved");
  } else {
    setNoteStatus("error", "error");
    showToast("Erreur chargement note.", "error", "Notes");
  }
}
loadNote();

/* Autosave logic */
let dirty = false;
let lastSent = ta.value || "";
ta.addEventListener("input", ()=>{
  dirty = true;
  setNoteStatus("en cours...", "saving");
});
setInterval(async ()=>{
  const current = ta.value || "";
  if (!dirty && current === lastSent) { return; }
  const j = await postJSON("/api/note",{day:day,content:current});
  if(j && j.ok){
    lastSent = current;
    dirty = false;
    setNoteStatus("saved " + new Date().toLocaleTimeString().slice(0,5), "saved");
  } else {
    setNoteStatus("error", "error");
    showToast("Erreur sauvegarde note.", "error", "Notes");
  }
}, 2000);

/* Save on page leave */
window.addEventListener("beforeunload", ()=>{
  if(dirty){ postJSON("/api/note",{day:day,content:ta.value}); }
});

/* Parsing regex - synchronise textarea avec template */
const fieldMappings = {
  // Matin
  qualite: ['qualite', 'qualité', 'sommeil qualite', 'qual sommeil'],
  energie: ['energie', 'énergie', 'nrj'],
  motivation: ['motivation', 'motiv'],
  douleur: ['douleur', 'doul', 'mal'],
  // Mental
  humeur: ['humeur', 'mood'],
  anxiete: ['anxiete', 'anxiété', 'anx'],
  irritabilite: ['irritabilite', 'irritabilité', 'irrit'],
  clarte: ['clarte', 'clarté', 'clair'],
  // Soir
  humeur_soir: ['humeur soir', 'mood soir'],
  stress: ['stress'],
  focus: ['focus', 'concentration'],
  fatigue: ['fatigue', 'fatig'],
  fierte: ['fierte', 'fierté', 'fier'],
  // Colere
  episodes: ['episodes', 'épisodes', 'colere', 'colère'],
  intensite: ['intensite', 'intensité', 'intens'],
  declencheur: ['declencheur', 'déclencheur', 'trigger'],
  duree: ['duree', 'durée'],
  // CBT
  emotion: ['emotion', 'émotion'],
  // Bilan
  score: ['score', 'global', 'score global'],
  relations: ['relations', 'relation'],
  ideesnoires: ['idees noires', 'idées noires', 'noires'],
  // TDAH
  priorite1: ['priorite 1', 'priorité 1', 'prio 1', 'p1'],
  priorite2: ['priorite 2', 'priorité 2', 'prio 2', 'p2'],
  priorite3: ['priorite 3', 'priorité 3', 'prio 3', 'p3'],
  minimum: ['minimum', 'vital', 'minimum vital'],
  // CBT texte
  situation: ['situation', 'situ'],
  pensee: ['pensee', 'pensée', 'pensee auto'],
  alternative: ['alternative', 'alt'],
  decision: ['decision', 'décision', 'meilleure'],
  piege: ['piege', 'piège', 'pire']
};

const checkMappings = {
  pause90: ['pause 90', 'pause90', '90 sec'],
  respiration: ['respiration', 'respi', '4-6', '4 6'],
  sortir: ['sortir', 'marcher', 'sorti'],
  ecrire: ['ecrire', 'écrire', 'ecrit', 'écrit']
};

function parseNoteContent(text) {
  const lower = text.toLowerCase();
  const values = {};
  const checks = {};

  // Parse chaque field
  for (const [field, aliases] of Object.entries(fieldMappings)) {
    for (const alias of aliases) {
      // Pattern: "alias: valeur" ou "alias = valeur" ou "alias valeur"
      const patterns = [
        new RegExp(alias + '\\s*[:=]\\s*([\\d]+|[^\\n,;]+?)(?=[\\n,;]|$)', 'i'),
        new RegExp(alias + '\\s+(\\d+)(?:\\s|/|$)', 'i')
      ];
      for (const pattern of patterns) {
        const match = lower.match(pattern);
        if (match && match[1]) {
          values[field] = match[1].trim();
          break;
        }
      }
      if (values[field]) break;
    }
  }

  // Parse checkboxes
  for (const [check, aliases] of Object.entries(checkMappings)) {
    for (const alias of aliases) {
      if (lower.includes(alias)) {
        checks[check] = true;
        break;
      }
    }
  }

  return { values, checks };
}

function updateTemplate(values, checks) {
  // Update les valeurs (inputs et spans)
  document.querySelectorAll('[data-field]').forEach(el => {
    const field = el.dataset.field;
    const isInput = el.tagName === 'INPUT';

    if (values[field]) {
      if (isInput) {
        el.value = values[field];
        // Applique la couleur sémantique si fonction disponible
        if (el.type === 'number' && typeof applySemanticColor === 'function') {
          applySemanticColor(el);
        } else {
          const wrapper = el.closest('.rating-field');
          const target = wrapper || el;
          target.classList.add('filled');
        }
      } else {
        const suffix = el.dataset.suffix || '';
        el.textContent = values[field] + suffix;
        el.classList.add('filled');
        el.classList.remove('empty');
      }
    } else {
      if (isInput) {
        el.value = '';
        // Reset classes sur le wrapper si présent
        const wrapper = el.closest('.rating-field');
        const target = wrapper || el;
        target.classList.remove('filled', 'val-bad', 'val-mid', 'val-good');
      } else {
        const suffix = el.dataset.suffix || '';
        el.textContent = '__' + suffix;
        el.classList.remove('filled');
        el.classList.add('empty');
      }
    }
  });

  // Update les checkboxes
  document.querySelectorAll('.tpl-check').forEach(el => {
    const field = el.dataset.field;
    if (checks[field]) {
      el.checked = true;
    } else {
      el.checked = false;
    }
  });
}

function syncTemplate() {
  const text = ta.value || '';
  const { values, checks } = parseNoteContent(text);
  updateTemplate(values, checks);
}

// Sync au chargement et à chaque modification
ta.addEventListener('input', syncTemplate);
setTimeout(syncTemplate, 500); // Sync après chargement initial

/* Clic sur un champ = insère dans la textarea */
function initClickableFields() {
  document.querySelectorAll('.clickable').forEach(el => {
    el.addEventListener('click', () => {
      const insertText = el.dataset.insert;
      if (!insertText) return;

      // Ajoute une nouvelle ligne si besoin
      const current = ta.value;
      const needsNewline = current.length > 0 && !current.endsWith('\\n');
      const textToInsert = (needsNewline ? '\\n' : '') + insertText;

      // Insère à la fin
      ta.value += textToInsert;

      // Focus sur la textarea et place le curseur à la fin
      ta.focus();
      ta.selectionStart = ta.selectionEnd = ta.value.length;

      // Trigger l'événement input pour mettre à jour le template
      ta.dispatchEvent(new Event('input'));

      // Feedback visuel
      el.style.background = 'rgba(53,217,154,.3)';
      setTimeout(() => { el.style.background = ''; }, 200);
    });
  });
}

/* Sync inputs vers textarea */
function buildTextFromInputs() {
  const lines = [];

  // Récupère toutes les valeurs des inputs
  document.querySelectorAll('.tpl-input').forEach(input => {
    const field = input.dataset.field;
    const val = input.value;
    if (val && val.trim() !== '') {
      // Trouve le label correspondant
      const item = input.closest('.tpl-item');
      let label = field;
      if (item) {
        const labelEl = item.querySelector('.label');
        if (labelEl) label = labelEl.textContent;
      }
      lines.push(label + ': ' + val);
    }
  });

  // Récupère les checkboxes cochées
  document.querySelectorAll('.tpl-check:checked').forEach(cb => {
    const li = cb.closest('li');
    if (li) {
      const text = li.textContent.trim();
      lines.push(text);
    }
  });

  return lines.join('\\n');
}

function syncInputToTextarea() {
  const text = buildTextFromInputs();
  ta.value = text;
  dirty = true;
  setNoteStatus('en cours...', 'saving');
}

/* Champs inversés (bas = bien) */
const invertedFields = [
  'douleur', 'anxiete', 'irritabilite', 'stress', 'fatigue',
  'episodes', 'intensite', 'ideesnoires'
];

function applySemanticColor(input) {
  const field = input.dataset.field;
  const val = parseFloat(input.value);
  const max = parseFloat(input.max) || 10;

  // Trouver le wrapper .rating-field si présent
  const wrapper = input.closest('.rating-field');
  const target = wrapper || input;

  // Reset classes
  target.classList.remove('val-bad', 'val-mid', 'val-good', 'filled');

  if (isNaN(val) || input.value === '') {
    return; // Pas de valeur = pas de couleur
  }

  // Calcul du pourcentage
  const pct = val / max;
  const isInverted = invertedFields.includes(field);

  // Détermine si c'est bon ou mauvais
  let quality;
  if (pct <= 0.3) {
    quality = isInverted ? 'good' : 'bad';
  } else if (pct <= 0.6) {
    quality = 'mid';
  } else {
    quality = isInverted ? 'bad' : 'good';
  }

  target.classList.add('val-' + quality);
}

function initInputListeners() {
  // Écoute les changements sur les inputs number/text
  document.querySelectorAll('.tpl-input').forEach(input => {
    input.addEventListener('change', syncInputToTextarea);
    input.addEventListener('input', () => {
      if (input.type === 'number') {
        applySemanticColor(input);
      } else {
        // Pour les champs texte, juste filled
        const wrapper = input.closest('.rating-field');
        const target = wrapper || input;
        if (input.value) {
          target.classList.add('filled');
        } else {
          target.classList.remove('filled');
        }
      }
    });
    // Appliquer la couleur initiale si déjà rempli
    if (input.type === 'number' && input.value) {
      applySemanticColor(input);
    }
  });

  // Écoute les changements sur les checkboxes
  document.querySelectorAll('.tpl-check').forEach(cb => {
    cb.addEventListener('change', syncInputToTextarea);
  });
}

/* Init */
initRippleEffects();
initClickableFields();
initInputListeners();
</script>
</body></html>
"@
        try { $ctx.Response.Headers["Cache-Control"] = "no-store, no-cache, must-revalidate" } catch {}
        Write-HttpResponse $ctx 200 "text/html; charset=utf-8" (ConvertTo-HttpBytes $page)
        continue
      }
      Write-HttpResponse $ctx 404 "text/plain; charset=utf-8" (ConvertTo-HttpBytes "Not Found")
      continue
    }

    if ($ctx.Request.HttpMethod -eq "POST") {
      $body = Read-Body $ctx
      $data = $null
      try { $data = $body | ConvertFrom-Json } catch { $data = $null }

      if ($path -eq "/api/cmd") {
        $cmd = [string]($data.cmd ?? "")
        if (-not $cmd.Trim()) {
          Write-HttpResponse $ctx 400 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="empty cmd"} | ConvertTo-Json))
          continue
        }
        Start-TimerIfStopped
        Add-CommandLine $cmd
        Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true; cmd=$cmd} | ConvertTo-Json))
        continue
      }
      if ($path -eq "/api/drinks/add") {
        $type = [string]($data.type ?? "")
        $n = 1
        try { $n = [int]($data.n ?? 1) } catch { $n = 1 }
        if ($n -lt 1) { $n = 1 }

        try {
          Add-DrinkLog ("attempt type={0} n={1}" -f $type, $n)
          $line = $null
          switch ($type.ToLowerInvariant()) {
            "wine"   { $line = Add-DrinksEntry -Wine $n }
            "beer"   { $line = Add-DrinksEntry -Beer $n }
            "strong" { $line = Add-DrinksEntry -Strong $n }
            default  {
              Add-DrinkLog ("reject type={0} n={1}" -f $type, $n)
              Write-HttpResponse $ctx 400 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="type must be wine|beer|strong"} | ConvertTo-Json))
              continue
            }
          }

          if ($line) {
            Add-DrinkLog ("ok type={0} n={1} line={2}" -f $type, $n, $line)
          } else {
            Add-DrinkLog ("ok type={0} n={1}" -f $type, $n)
          }
          $dayKey = Get-InfernalDayKey (Get-Date)
          $currTotals = Get-DailyAlcoholTotals $dayKey
          Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true; type=$type; n=$n; day=$dayKey; totals=$currTotals; line=$line} | ConvertTo-Json))
        } catch {
          Add-DrinkLog ("error type={0} n={1} msg={2}" -f $type, $n, ($_.Exception.Message ?? "unknown"))
          Write-ErrorLog -Path $DashLogPath -Context "api/drinks/add" -Exception $_.Exception
          Write-HttpResponse $ctx 500 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="write failed"} | ConvertTo-Json))
        }
        continue
      }
      if ($path -eq "/api/drinks/adjust") {
        $type = [string]($data.type ?? "")
        $total = 0
        try { $total = [int]($data.total ?? 0) } catch { $total = 0 }
        if ($total -lt 0) { $total = 0 }

        try {
          $dayKey = Get-InfernalDayKey (Get-Date)
          $curr = Get-DailyAlcoholTotals $dayKey
          $current = 0
          switch ($type.ToLowerInvariant()) {
            "wine"   { $current = [int]($curr.wine ?? 0) }
            "beer"   { $current = [int]($curr.beer ?? 0) }
            "strong" { $current = [int]($curr.strong ?? 0) }
            default  {
              Add-DrinkLog ("adjust reject type={0} total={1}" -f $type, $total)
              Write-HttpResponse $ctx 400 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="type must be wine|beer|strong"} | ConvertTo-Json))
              continue
            }
          }

          $added = [Math]::Max(0, $total - $current)
          Add-DrinkLog ("adjust type={0} total={1} current={2} add={3} day={4}" -f $type, $total, $current, $added, $dayKey)
          if ($added -gt 0) {
            switch ($type.ToLowerInvariant()) {
              "wine"   { Add-DrinksEntry -Wine $added | Out-Null }
              "beer"   { Add-DrinksEntry -Beer $added | Out-Null }
              "strong" { Add-DrinksEntry -Strong $added | Out-Null }
            }
          }

          Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true; total=$total; current=$current; added=$added} | ConvertTo-Json))
        } catch {
          Add-DrinkLog ("adjust error type={0} total={1} msg={2}" -f $type, $total, ($_.Exception.Message ?? "unknown"))
          Write-ErrorLog -Path $DashLogPath -Context "api/drinks/adjust" -Exception $_.Exception
          Write-HttpResponse $ctx 500 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="write failed"} | ConvertTo-Json))
        }
        continue
      }

      if ($path -eq "/api/engine/restart") {
        try {
          Restart-Timer
          Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true} | ConvertTo-Json))
        } catch {
          Write-ErrorLog -Path $DashLogPath -Context "api/engine/restart" -Exception $_.Exception
          Write-HttpResponse $ctx 500 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="restart failed"} | ConvertTo-Json))
        }
        continue
      }

      if ($path -eq "/api/note") {
        $day = [string]($data.day ?? (Get-InfernalDayKey (Get-Date)))
        $content = [string]($data.content ?? "")
        try {
          Set-NoteContent $day $content
          Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true} | ConvertTo-Json))
        } catch {
          Write-ErrorLog -Path $DashLogPath -Context "api/note" -Exception $_.Exception
          Write-HttpResponse $ctx 500 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="write failed"} | ConvertTo-Json))
        }
        continue
      }
      if ($path -eq "/api/quicknote") {
        $content = [string]($data.content ?? "")
        try {
          Set-QuickNote $content
          Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true} | ConvertTo-Json))
        } catch {
          Write-ErrorLog -Path $DashLogPath -Context "api/quicknote" -Exception $_.Exception
          Write-HttpResponse $ctx 500 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="write failed"} | ConvertTo-Json))
        }
        continue
      }
      if ($path -eq "/api/actionnote") {
        $content = [string]($data.content ?? "")
        try {
          Set-ActionNote $content
          Write-HttpResponse $ctx 200 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$true} | ConvertTo-Json))
        } catch {
          Write-ErrorLog -Path $DashLogPath -Context "api/actionnote" -Exception $_.Exception
          Write-HttpResponse $ctx 500 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="write failed"} | ConvertTo-Json))
        }
        continue
      }

      Write-HttpResponse $ctx 404 "application/json; charset=utf-8" (ConvertTo-HttpBytes (@{ok=$false; error="not found"} | ConvertTo-Json))
      continue
    }

  } catch {
    Write-ErrorLog -Path $DashLogPath -Context "RequestLoop" -Exception $_.Exception
    try { Write-HttpResponse $ctx 500 "text/plain; charset=utf-8" (ConvertTo-HttpBytes $_.Exception.Message) } catch {}
  }
}
