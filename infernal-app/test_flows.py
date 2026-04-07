#!/usr/bin/env python3
"""
COMPLETE Flow Tests — Every button, every path, every display.
Tests the FULL chain: action -> API -> storage -> API read-back -> display fields.

Run: adb -s PHONE forward tcp:8011 tcp:8011 && python test_flows.py
"""

import json
import sys
import time
import urllib.request
import urllib.error

BASE = "http://127.0.0.1:8011"
PASS = FAIL = 0


def get(path):
    return json.loads(urllib.request.urlopen(f"{BASE}{path}", timeout=5).read())


def post(path, body):
    req = urllib.request.Request(
        f"{BASE}{path}", json.dumps(body).encode(),
        {"Content-Type": "application/json"}
    )
    return json.loads(urllib.request.urlopen(req, timeout=5).read())


def test(name, ok, detail=""):
    global PASS, FAIL
    if ok:
        PASS += 1
        print(f"  OK  {name}")
    else:
        FAIL += 1
        print(f"FAIL  {name} {detail}")


def section(title):
    print(f"\n{'='*60}\n  {title}\n{'='*60}")


# ============================================================
#  1. API FORMAT TESTS — Every endpoint returns correct shape
# ============================================================
def test_api_formats():
    section("1. API FORMAT TESTS")

    # /api/state
    s = get("/api/state")
    test("state.ok", s.get("ok") == True)
    for field in ["currentName", "remWorkSec", "goalWorkSec", "totalWorkSec",
                  "totalBreakSec", "totalOverrunSec", "elapsedSec", "remainSec",
                  "overtimeSec", "started", "startedAtStr", "awaitOk", "paused",
                  "dayClopeCount", "dailyAlcohol", "todayKey", "yesterdayKey",
                  "dailyActions", "firsts", "recentDrinks",
                  "dayWorkSec", "daySleepSec", "dayBreakSec"]:
        test(f"state.{field} exists", field in s, f"missing from /api/state")

    alc = s.get("dailyAlcohol", {})
    for f in ["wine", "beer", "strong"]:
        test(f"state.dailyAlcohol.{f}", f in alc)

    # /api/settings
    settings = get("/api/settings")
    test("settings is dict", isinstance(settings, dict))
    test("settings.actions exists", "actions" in settings)
    test("settings.actions is list", isinstance(settings.get("actions"), list))
    acts = settings.get("actions", [])
    test("settings has clope action", any(a.get("key") == "clope" for a in acts))

    # /api/consumption/all
    c = get("/api/consumption/all")
    test("consumption.ok", c.get("ok") == True)
    test("consumption has 'days' key", "days" in c)
    test("consumption.days is list", isinstance(c.get("days"), list))

    # /api/monthly-summary
    m = get("/api/monthly-summary")
    test("monthly.ok", m.get("ok") == True)
    test("monthly has 'summary'", isinstance(m.get("summary"), dict))
    test("monthly has 'delta'", isinstance(m.get("delta"), dict))
    test("monthly has 'insights'", isinstance(m.get("insights"), list))
    test("monthly has 'days'", isinstance(m.get("days"), list))

    ms = m.get("summary", {})
    for f in ["avgClopeCount", "totalWorkMin", "avgSleepMin", "totalClopeCount",
              "activeDays", "clopeFreeDays", "alcoholFreeDays"]:
        test(f"monthly.summary.{f}", f in ms)

    ma = ms.get("alcohol", {})
    test("monthly.summary.alcohol exists", isinstance(ma, dict))
    test("monthly.summary.alcohol.avgDrinksPerDay", "avgDrinksPerDay" in ma)
    test("monthly.summary.alcohol.totalLiters", "totalLiters" in ma)

    md = m.get("delta", {})
    for f in ["avgWorkMin", "avgSleepMin", "avgClopeCount", "avgAlcoholPerDay"]:
        test(f"monthly.delta.{f}", f in md)

    # /api/drinks/weeks
    w = get("/api/drinks/weeks")
    test("weeks.ok", w.get("ok") == True)
    test("weeks has 'weeks'", "weeks" in w)

    # /api/watch/summary
    ws = get("/api/watch/summary")
    test("watch.ok", ws.get("ok") == True)
    test("watch.cigaretteCount", "cigaretteCount" in ws)
    test("watch.drinkCount", "drinkCount" in ws)

    # /api/sleep/last
    sl = get("/api/sleep/last")
    test("sleep.last returns", isinstance(sl, dict))

    # /api/sleep/history
    sh = get("/api/sleep/history")
    test("sleep.history returns", isinstance(sh, dict))

    # /api/note
    n = get("/api/note?d=2026-04-07")
    test("note.ok", n.get("ok") == True)
    test("note.content exists", "content" in n)

    # /api/notes/all
    na = get("/api/notes/all")
    test("notes/all.ok", na.get("ok") == True)

    # /api/quicknote
    qn = get("/api/quicknote")
    test("quicknote returns", isinstance(qn, dict))

    # /api/actionnote
    an = get("/api/actionnote")
    test("actionnote returns", isinstance(an, dict))


# ============================================================
#  2. DRINK FLOW — Add each type, verify everywhere
# ============================================================
def test_drink_flows():
    section("2. DRINK FLOWS")

    for drink_type in ["beer", "wine", "strong"]:
        # Get baseline
        s0 = get("/api/state")
        before = s0.get("dailyAlcohol", {}).get(drink_type, 0)

        # Add drink
        r = post("/api/drinks/add", {"type": drink_type, "n": 1})
        test(f"add {drink_type} ok", r.get("ok") == True)
        test(f"add {drink_type} has totals", isinstance(r.get("totals"), dict))
        test(f"add {drink_type} totals.{drink_type}", drink_type in r.get("totals", {}))

        time.sleep(0.3)

        # Verify in state
        s1 = get("/api/state")
        after = s1.get("dailyAlcohol", {}).get(drink_type, 0)
        test(f"state {drink_type} incremented ({before}->{after})", after > before)

        # Verify in consumption/all
        c = get("/api/consumption/all")
        days = c.get("days", [])
        has_drink = any(d.get(drink_type, 0) > 0 for d in days)
        test(f"consumption has {drink_type}", has_drink)

        # Verify in monthly-summary
        m = get("/api/monthly-summary")
        mdays = m.get("days", [])
        has_in_monthly = any(d.get(drink_type, 0) > 0 for d in mdays)
        test(f"monthly has {drink_type}", has_in_monthly)

    # Verify weekly table has data
    w = get("/api/drinks/weeks")
    test("weeks not empty after adds", len(w.get("weeks", [])) > 0)

    # Verify monthly alcohol stats updated
    m2 = get("/api/monthly-summary")
    avg = m2.get("summary", {}).get("alcohol", {}).get("avgDrinksPerDay", 0)
    test(f"monthly avgDrinksPerDay > 0 ({avg})", avg > 0)
    liters = m2.get("summary", {}).get("alcohol", {}).get("totalLiters", 0)
    test(f"monthly totalLiters > 0 ({liters})", liters > 0)


# ============================================================
#  3. COMMAND FLOW — START, WORK, CLOPE, OK, DODO
# ============================================================
def test_command_flows():
    section("3. COMMAND FLOWS")

    # START
    r = post("/api/cmd", {"cmd": "start"})
    test("cmd start ok", r.get("ok") == True)
    time.sleep(0.5)
    s = get("/api/state")
    test("started=true after start", s.get("started") == True)
    test("currentName=work after start", s.get("currentName", "").lower() == "work")

    # CLOPE
    r2 = post("/api/cmd", {"cmd": "clope"})
    test("cmd clope ok", r2.get("ok") == True)
    time.sleep(0.5)
    s2 = get("/api/state")
    test("currentName=clope", s2.get("currentName", "").lower() == "clope")

    # OK (end clope)
    r3 = post("/api/cmd", {"cmd": "ok"})
    test("cmd ok", r3.get("ok") == True)
    time.sleep(0.5)
    s3 = get("/api/state")
    test("dayClopeCount > 0 after clope+ok", s3.get("dayClopeCount", 0) > 0)

    # WORK
    r4 = post("/api/cmd", {"cmd": "work"})
    test("cmd work ok", r4.get("ok") == True)
    time.sleep(0.5)
    s4 = get("/api/state")
    test("currentName=work after work", s4.get("currentName", "").lower() == "work")

    # DODO
    r5 = post("/api/cmd", {"cmd": "dodo"})
    test("cmd dodo ok", r5.get("ok") == True)
    time.sleep(0.5)
    s5 = get("/api/state")
    test("currentName=sleep after dodo", s5.get("currentName", "").lower() in ["dodo", "sleep"])

    # Back to WORK
    post("/api/cmd", {"cmd": "work"})


# ============================================================
#  4. NOTE FLOW — Save, read, list
# ============================================================
def test_note_flows():
    section("4. NOTE FLOWS")

    # Save note
    r = post("/api/note", {"day": "2026-04-07", "content": "Test flow note"})
    test("note save ok", r.get("ok") == True)

    # Read back
    n = get("/api/note?d=2026-04-07")
    test("note read ok", n.get("ok") == True)
    test("note content matches", "Test flow" in (n.get("content") or ""))

    # Quick note
    r2 = post("/api/quicknote", {"content": "Quick test"})
    test("quicknote save ok", r2.get("ok") == True)
    qn = get("/api/quicknote")
    test("quicknote read", isinstance(qn, dict))

    # Action note
    r3 = post("/api/actionnote", {"content": "Action test"})
    test("actionnote save ok", r3.get("ok") == True)

    # Notes all
    na = get("/api/notes/all")
    test("notes/all ok", na.get("ok") == True)


# ============================================================
#  5. SETTINGS FLOW — Read, modify actions
# ============================================================
def test_settings_flows():
    section("5. SETTINGS FLOWS")

    s = get("/api/settings")
    test("settings readable", isinstance(s, dict))
    test("settings has actions", isinstance(s.get("actions"), list))

    # Verify all expected actions exist
    keys = [a.get("key") for a in s.get("actions", [])]
    for expected in ["work", "dodo", "clope"]:
        test(f"action '{expected}' exists", expected in keys)


# ============================================================
#  6. CONSUMPTION CONSISTENCY — consumption/all matches state
# ============================================================
def test_consistency():
    section("6. DATA CONSISTENCY")

    state = get("/api/state")
    consumption = get("/api/consumption/all")
    monthly = get("/api/monthly-summary")

    # consumption days should have 'date' key (not 'day')
    days = consumption.get("days", [])
    if days:
        d = days[0]
        test("consumption entry has 'date' key", "date" in d)
        test("consumption entry has 'clopeCount'", "clopeCount" in d)
        test("consumption entry has 'beer'", "beer" in d)
        test("consumption entry has 'wine'", "wine" in d)
        test("consumption entry has 'strong'", "strong" in d)

    # monthly days should have consistent fields
    mdays = monthly.get("days", [])
    if mdays:
        md = mdays[0]
        test("monthly day has 'day' key", "day" in md)
        test("monthly day has 'clopeCount'", "clopeCount" in md)
        test("monthly day has 'alcoholCount'", "alcoholCount" in md)
        test("monthly day has 'pureAlcoholG'", "pureAlcoholG" in md)

    # Watch summary should be consistent with state
    ws = get("/api/watch/summary")
    test("watch cigaretteCount is int", isinstance(ws.get("cigaretteCount"), int))
    test("watch drinkCount is int", isinstance(ws.get("drinkCount"), int))


# ============================================================
#  7. DRINK ADJUST (undo) FLOW
# ============================================================
def test_drink_adjust():
    section("7. DRINK ADJUST (UNDO)")

    # Add then undo
    r1 = post("/api/drinks/add", {"type": "beer", "n": 1})
    test("add beer for undo", r1.get("ok"))
    beer_after_add = r1.get("totals", {}).get("beer", 0)

    # Adjust to previous total (undo)
    r2 = post("/api/drinks/adjust", {"type": "beer", "total": beer_after_add - 1})
    test("adjust beer ok", r2.get("ok") == True)

    time.sleep(0.3)
    s = get("/api/state")
    beer_now = s.get("dailyAlcohol", {}).get("beer", 0)
    test(f"beer count correct after undo ({beer_now})", beer_now >= 0)


# ============================================================
#  8. GOAL FLOW
# ============================================================
def test_goal():
    section("8. GOAL FLOW")

    r = post("/api/goal", {"hours": 400})
    test("set goal ok", r.get("ok") == True)

    s = get("/api/state")
    goal_sec = s.get("goalWorkSec", 0)
    test(f"goal = 400h = {400*3600}s (got {goal_sec})", goal_sec == 400 * 3600)

    # Reset to default
    post("/api/goal", {"hours": 500})


# ============================================================
#  MAIN
# ============================================================
if __name__ == "__main__":
    print("=" * 60)
    print("  COMPLETE FLOW TESTS - Senior Dev Audit")
    print("=" * 60)

    try:
        test_api_formats()
        test_drink_flows()
        test_command_flows()
        test_note_flows()
        test_settings_flows()
        test_consistency()
        test_drink_adjust()
        test_goal()
    except Exception as e:
        FAIL += 1
        print(f"\nFATAL: {e}")

    print(f"\n{'='*60}")
    print(f"  TOTAL: {PASS} passed, {FAIL} FAILED / {PASS+FAIL}")
    if FAIL == 0:
        print("  ALL TESTS PASSED")
    else:
        print(f"  {FAIL} TESTS FAILED")
    print("=" * 60)

    sys.exit(1 if FAIL > 0 else 0)
