#!/usr/bin/env python3
"""
API Integration Tests — verify every endpoint returns correct format.

Runs against the shelf server on the phone via ADB port forwarding.
Usage:
    adb forward tcp:8011 tcp:8011
    python test_api.py

Tests every endpoint the dashboard JS calls and validates the response
matches what the JS expects.
"""

import json
import sys
import urllib.request
import urllib.error
import time

BASE = "http://127.0.0.1:8011"
PASS = 0
FAIL = 0
WARN = 0


def _check(name, url, method="GET", body=None, checks=None):
    """Run a test against an API endpoint."""
    global PASS, FAIL, WARN
    try:
        req = urllib.request.Request(url, method=method)
        if body:
            req.add_header("Content-Type", "application/json")
            req.data = json.dumps(body).encode()

        with urllib.request.urlopen(req, timeout=5) as resp:
            data = json.loads(resp.read().decode())

        errors = []
        warnings = []
        if checks:
            for check_name, check_fn in checks.items():
                try:
                    result = check_fn(data)
                    if result is False:
                        errors.append(f"  FAIL: {check_name}")
                    elif result == "WARN":
                        warnings.append(f"  WARN: {check_name}")
                except Exception as e:
                    errors.append(f"  FAIL: {check_name} — {e}")

        if errors:
            FAIL += 1
            print(f"FAIL {name}")
            for e in errors:
                print(e)
            for w in warnings:
                print(w)
        elif warnings:
            WARN += 1
            print(f"WARN {name}")
            for w in warnings:
                print(w)
        else:
            PASS += 1
            print(f"  OK {name}")

    except urllib.error.URLError as e:
        FAIL += 1
        print(f"FAIL {name} — connection error: {e}")
    except Exception as e:
        FAIL += 1
        print(f"FAIL {name} — {e}")


def has(data, *keys):
    """Check nested key exists."""
    d = data
    for k in keys:
        if not isinstance(d, dict) or k not in d:
            return False
        d = d[k]
    return True


def main():
    print("=" * 60)
    print("  API Integration Tests — Dashboard Compatibility")
    print("=" * 60)
    print()

    # ── GET /api/state ──
    # JS: refreshLive() reads these fields
    _check("GET /api/state — basic", f"{BASE}/api/state", checks={
        "ok field": lambda d: d.get("ok") == True,
        "currentName": lambda d: "currentName" in d,
        "remWorkSec": lambda d: "remWorkSec" in d,
        "goalWorkSec": lambda d: "goalWorkSec" in d,
        "totalWorkSec": lambda d: "totalWorkSec" in d,
        "totalBreakSec": lambda d: "totalBreakSec" in d,
        "totalOverrunSec": lambda d: "totalOverrunSec" in d,
        "elapsedSec": lambda d: "elapsedSec" in d,
        "remainSec": lambda d: "remainSec" in d,
        "overtimeSec": lambda d: "overtimeSec" in d,
        "started": lambda d: "started" in d,
        "startedAtStr": lambda d: "startedAtStr" in d,
        "awaitOk": lambda d: "awaitOk" in d,
        "paused": lambda d: "paused" in d,
        "dayClopeCount": lambda d: "dayClopeCount" in d,
        "dailyAlcohol": lambda d: isinstance(d.get("dailyAlcohol"), dict),
        "dailyAlcohol.wine": lambda d: "wine" in d.get("dailyAlcohol", {}),
        "dailyAlcohol.beer": lambda d: "beer" in d.get("dailyAlcohol", {}),
        "dailyAlcohol.strong": lambda d: "strong" in d.get("dailyAlcohol", {}),
        "todayKey": lambda d: "todayKey" in d,
        "dailyActions": lambda d: isinstance(d.get("dailyActions"), list),
        "firsts": lambda d: isinstance(d.get("firsts"), dict),
    })

    # ── GET /api/settings ──
    _check("GET /api/settings — basic", f"{BASE}/api/settings", checks={
        "is dict": lambda d: isinstance(d, dict),
    })

    # ── GET /api/consumption/all ──
    # JS: loadCalendar() reads j.days, d.date, d.clopeCount
    _check("GET /api/consumption/all — format", f"{BASE}/api/consumption/all", checks={
        "ok field": lambda d: d.get("ok") == True,
        "has 'days' (not 'data')": lambda d: "days" in d,
        "days is list": lambda d: isinstance(d.get("days"), list),
    })

    # ── GET /api/monthly-summary ──
    # JS: renderMonthlyBilan reads data.summary.*, data.delta.*, data.days
    _check("GET /api/monthly-summary — nested structure", f"{BASE}/api/monthly-summary", checks={
        "ok field": lambda d: d.get("ok") == True,
        "has summary": lambda d: isinstance(d.get("summary"), dict),
        "summary.avgClopeCount": lambda d: "avgClopeCount" in d.get("summary", {}),
        "summary.totalWorkMin": lambda d: "totalWorkMin" in d.get("summary", {}),
        "summary.avgSleepMin": lambda d: "avgSleepMin" in d.get("summary", {}),
        "summary.alcohol": lambda d: isinstance(d.get("summary", {}).get("alcohol"), dict),
        "summary.alcohol.avgDrinksPerDay": lambda d: "avgDrinksPerDay" in d.get("summary", {}).get("alcohol", {}),
        "summary.alcohol.totalLiters": lambda d: "totalLiters" in d.get("summary", {}).get("alcohol", {}),
        "has delta": lambda d: isinstance(d.get("delta"), dict),
        "has insights": lambda d: isinstance(d.get("insights"), list),
        "has days": lambda d: isinstance(d.get("days"), list),
    })

    # ── GET /api/drinks/weeks ──
    # JS: loadAlcoholWeeks reads j.weeks
    _check("GET /api/drinks/weeks — format", f"{BASE}/api/drinks/weeks", checks={
        "ok field": lambda d: d.get("ok") == True,
        "has weeks": lambda d: "weeks" in d,
        "weeks is list": lambda d: isinstance(d.get("weeks"), list),
    })

    # ── GET /api/watch/summary ──
    _check("GET /api/watch/summary — format", f"{BASE}/api/watch/summary", checks={
        "ok field": lambda d: d.get("ok") == True,
        "cigaretteCount": lambda d: "cigaretteCount" in d,
        "drinkCount": lambda d: "drinkCount" in d,
    })

    # ── POST /api/cmd ──
    _check("POST /api/cmd start", f"{BASE}/api/cmd", method="POST",
         body={"cmd": "start"}, checks={
        "ok": lambda d: d.get("ok") == True,
    })

    # ── POST /api/drinks/add ──
    _check("POST /api/drinks/add beer", f"{BASE}/api/drinks/add", method="POST",
         body={"type": "beer", "n": 1}, checks={
        "ok": lambda d: d.get("ok") == True,
        "has totals": lambda d: isinstance(d.get("totals"), dict),
        "totals.beer": lambda d: "beer" in d.get("totals", {}),
        "totals.wine": lambda d: "wine" in d.get("totals", {}),
        "totals.strong": lambda d: "strong" in d.get("totals", {}),
    })

    # ── Verify drink was recorded in state ──
    time.sleep(0.5)
    _check("GET /api/state after drink add — beer counted", f"{BASE}/api/state", checks={
        "dailyAlcohol.beer >= 1": lambda d: d.get("dailyAlcohol", {}).get("beer", 0) >= 1,
    })

    # ── Verify drink shows in consumption ──
    _check("GET /api/consumption/all after drink — has data", f"{BASE}/api/consumption/all", checks={
        "days not empty": lambda d: len(d.get("days", [])) > 0,
        "today has beer": lambda d: any(
            (x.get("beer", 0) > 0) for x in d.get("days", [])
        ) if d.get("days") else False,
    })

    # ── Verify weekly table ──
    _check("GET /api/drinks/weeks after drink — has data", f"{BASE}/api/drinks/weeks", checks={
        "weeks not empty": lambda d: len(d.get("weeks", [])) > 0,
    })

    # ── POST /api/cmd clope ──
    _check("POST /api/cmd clope", f"{BASE}/api/cmd", method="POST",
         body={"cmd": "clope"}, checks={
        "ok": lambda d: d.get("ok") == True,
    })

    # Wait for clope segment to register
    time.sleep(1)

    # ── POST /api/cmd ok (end clope) ──
    _check("POST /api/cmd ok", f"{BASE}/api/cmd", method="POST",
         body={"cmd": "ok"}, checks={
        "ok": lambda d: d.get("ok") == True,
    })

    # ── Verify clope was counted ──
    time.sleep(0.5)
    _check("GET /api/state after clope — count > 0", f"{BASE}/api/state", checks={
        "dayClopeCount > 0": lambda d: d.get("dayClopeCount", 0) > 0,
    })

    # ── Monthly summary has data ──
    _check("GET /api/monthly-summary after adds — has activity", f"{BASE}/api/monthly-summary", checks={
        "summary exists": lambda d: isinstance(d.get("summary"), dict),
    })

    # ── Notes ──
    _check("POST /api/note save", f"{BASE}/api/note", method="POST",
         body={"day": "2026-04-07", "content": "Test note from API test"}, checks={
        "ok": lambda d: d.get("ok") == True,
    })
    _check("GET /api/note read", f"{BASE}/api/note?d=2026-04-07", checks={
        "ok": lambda d: d.get("ok") == True,
        "has content": lambda d: "content" in d,
    })

    # ── Summary ──
    print()
    print("=" * 60)
    total = PASS + FAIL + WARN
    print(f"  Results: {PASS} passed, {FAIL} FAILED, {WARN} warnings / {total} total")
    if FAIL == 0:
        print("  ALL TESTS PASSED")
    else:
        print(f"  {FAIL} TESTS FAILED — fix before deploying")
    print("=" * 60)

    return 1 if FAIL > 0 else 0


if __name__ == "__main__":
    sys.exit(main())
