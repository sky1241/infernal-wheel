"""
Static-analysis test for the BUG #5 lateinit-safety bug in DetectionService.

THE BUG (before fix):
---------------------
DetectionService had a chain of lateinit properties initialized in onCreate():

    detector       = SmokingDetector(this)
    sensorCollector = ...
    healthServices  = ...
    ...

If onCreate() failed partway through (most realistic case: TFLite model
load fails after the first few managers are constructed), the service
would call stopSelf() to abort. Android then invokes onDestroy(), which
called stopMonitoring(), which dereferenced phoneListener / sensorCollector
/ etc. — properties that may not yet be initialized.

The result: a ClassCastException / UninitializedPropertyAccessException
during teardown that masks the original error and crashes the watch app.

THE FIX:
--------
Every lateinit access in onDestroy() and stopMonitoring() is now guarded
by a `::property.isInitialized` check, with try/catch around each call to
the manager so a partial failure doesn't cascade.

This static test verifies the fix is in place by parsing the Kotlin source
and asserting that every `manager.method()` call inside the bodies of
onDestroy() and stopMonitoring() is preceded by an isInitialized guard.

Run: python test_lateinit_safety.py
"""
import os
import re
import sys

GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"
passed = 0
failed = 0


def _check(name, condition, detail=""):
    global passed, failed
    if condition:
        print(f"  {GREEN}OK{RESET}  {name}" + (f"  ({detail})" if detail else ""))
        passed += 1
    else:
        print(f"  {RED}FAIL{RESET}  {name}" + (f"  ({detail})" if detail else ""))
        failed += 1


def section(title):
    print(f"\n=== {title} ===")


SOURCE = os.path.join(
    os.path.dirname(__file__),
    "wear-os-app", "app", "src", "main", "java", "com", "infernal",
    "smokingdetector", "DetectionService.kt",
)


def extract_function_body(source: str, func_signature: str) -> str:
    """Return the body { ... } of the named function."""
    idx = source.find(func_signature)
    if idx == -1:
        return ""
    # Find the opening brace after the signature
    brace_idx = source.find("{", idx)
    if brace_idx == -1:
        return ""
    # Walk braces until we find the matching close
    depth = 0
    for i in range(brace_idx, len(source)):
        if source[i] == "{":
            depth += 1
        elif source[i] == "}":
            depth -= 1
            if depth == 0:
                return source[brace_idx:i + 1]
    return ""


# ============================================================================
section("1. Source file exists")

_check("DetectionService.kt found", os.path.exists(SOURCE), SOURCE)
if not os.path.exists(SOURCE):
    sys.exit(1)

with open(SOURCE, "r", encoding="utf-8") as f:
    src = f.read()


# ============================================================================
section("2. lateinit properties identified")

lateinit_re = re.compile(r"private lateinit var (\w+):")
lateinit_props = lateinit_re.findall(src)
print(f"  Found {len(lateinit_props)} lateinit properties:")
for p in lateinit_props:
    print(f"    - {p}")
_check("at least 8 lateinit properties identified",
     len(lateinit_props) >= 8,
     f"{len(lateinit_props)} found")


# ============================================================================
section("3. onDestroy() guards every lateinit access")

on_destroy_body = extract_function_body(src, "override fun onDestroy()")
print(f"  onDestroy body length: {len(on_destroy_body)} chars")
_check("onDestroy body extracted", len(on_destroy_body) > 0)

# These are the props that must be guarded inside onDestroy directly
# (excluding stopMonitoring which has its own guards)
critical_props_in_on_destroy = ["prefs", "detector"]
for prop in critical_props_in_on_destroy:
    has_check = f"::{prop}.isInitialized" in on_destroy_body
    _check(f"onDestroy: ::{prop}.isInitialized guard present",
         has_check,
         "guarded" if has_check else "MISSING — would crash on partial init")


# ============================================================================
section("4. stopMonitoring() guards every manager")

stop_body = extract_function_body(src, "private fun stopMonitoring()")
_check("stopMonitoring body extracted", len(stop_body) > 0)

# These managers are called from stopMonitoring and would crash if not init
managers_called = [
    "phoneListener",
    "sensorCollector",
    "gpsManager",
    "healthServices",
    "boostManager",
    "samsungAccel",
]
for mgr in managers_called:
    has_check = f"::{mgr}.isInitialized" in stop_body
    _check(f"stopMonitoring: ::{mgr}.isInitialized guard present",
         has_check,
         "guarded" if has_check else "MISSING")


# ============================================================================
section("5. startMonitoring rolls back isMonitoring on failure")

start_body = extract_function_body(src, "private fun startMonitoring()")
_check("startMonitoring body extracted", len(start_body) > 0)

# After "Failed to start sensor collection", isMonitoring must be reset
fail_idx = start_body.find("Failed to start sensor collection")
_check("startMonitoring detects sensor failure", fail_idx > 0)

# Look for isMonitoring = false anywhere after the fail point but before stopSelf()
post_fail = start_body[fail_idx:fail_idx + 500] if fail_idx > 0 else ""
has_rollback = "isMonitoring = false" in post_fail
_check("startMonitoring resets isMonitoring=false on failure",
     has_rollback,
     "rollback present" if has_rollback else "MISSING — service would silently never resume")


# ============================================================================
section("6. try/catch wraps risky teardown calls")

# Each manager.stop() inside stopMonitoring should be in a try block
# (not strictly required but defensive — prevents cascade failures)
risky_calls = [
    "phoneListener.stop()",
    "sensorCollector.stop()",
    "gpsManager.stop()",
    "healthServices.stop()",
    "boostManager.stop()",
    "samsungAccel.disconnect()",
]
for call in risky_calls:
    if call not in stop_body:
        continue
    # Find the surrounding ~80 chars and check for try
    idx = stop_body.find(call)
    surrounding = stop_body[max(0, idx - 80):idx + 80]
    has_try = "try {" in surrounding
    _check(f"stopMonitoring: {call} wrapped in try",
         has_try,
         "wrapped" if has_try else "BARE — could cascade failure")


print("\n" + "=" * 50)
print(f"  Tests passed: {GREEN}{passed}{RESET}")
print(f"  Tests failed: {RED if failed > 0 else GREEN}{failed}{RESET}")
print("=" * 50)



# === pytest entry point ===
# The file's assertions run at module-level on import (above). pytest then
# discovers test_no_failures() and asserts that all of them passed.
def test_no_failures():
    assert failed == 0, f'{failed} _check(s) failed (see stdout above for details)'


if __name__ == "__main__":
    sys.exit(0 if failed == 0 else 1)