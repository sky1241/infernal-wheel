"""
HR confirmation tests — replicates HealthServicesManager.getHRRiseOverLast
in Python and validates the rise-detection logic.

We simulate a 5-minute timeline of HR readings and ask the detector whether
HR rose by >= 5 bpm between the 3-5 min window and the last 2 min.

Scenarios:
  1. Real smoker: baseline 72, rises to 82 during puffs, detector says YES
  2. Sedentary (no change): baseline 70, stays 70, detector says NO
  3. Slow walker (gradual rise): baseline 70, climbs to 74, detector says NO
     (rise < 5 bpm threshold)
  4. Coffee drinker: baseline 70, single spike at +3 bpm, detector says NO
  5. Not enough data: only 1 sample in the timeline, detector returns 0
  6. Empty timeline: returns 0
"""

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


# ============================================================================
# Python port of HealthServicesManager HR rise logic
# ============================================================================
class HrRiseDetector:
    HISTORY_WINDOW_MS = 5 * 60 * 1000  # keep last 5 min of HR readings

    def __init__(self):
        self.timeline = []  # list of (timestamp_ms, bpm)

    def push(self, bpm, now_ms):
        self.timeline.append((now_ms, bpm))
        cutoff = now_ms - self.HISTORY_WINDOW_MS
        self.timeline = [s for s in self.timeline if s[0] >= cutoff]

    def get_hr_rise(self, now_ms, lookback_start_ms=3 * 60 * 1000, lookback_end_ms=2 * 60 * 1000):
        """Returns the rise between baseline (3-5 min ago) and recent (last 2 min)."""
        if len(self.timeline) < 2:
            return 0.0

        baseline_window_start = now_ms - lookback_start_ms
        baseline_window_end = now_ms - lookback_end_ms
        recent_window_start = now_ms - lookback_end_ms

        baseline_samples = [bpm for ts, bpm in self.timeline
                            if baseline_window_start <= ts <= baseline_window_end]
        recent_samples = [bpm for ts, bpm in self.timeline if ts >= recent_window_start]

        if not baseline_samples or not recent_samples:
            return 0.0

        baseline_avg = sum(baseline_samples) / len(baseline_samples)
        recent_avg = sum(recent_samples) / len(recent_samples)
        return recent_avg - baseline_avg


THRESHOLD = 5.0  # bpm — from DetectionService.HR_CONFIRMATION_DELTA_BPM


# ============================================================================
# Scenario 1 — Real smoker
# ============================================================================
section("1. Real smoker: HR rises 10 bpm during puffs")

det = HrRiseDetector()
NOW = 5 * 60 * 1000  # simulate "now" = 5 minutes into the session

# Minutes 0-3: baseline ~72 bpm
for minute in range(0, 3):
    for sec in range(0, 60, 10):
        det.push(72.0 + (sec % 3), minute * 60_000 + sec * 1000)

# Minutes 3-5: smoking, HR rises to ~82 bpm (the smoking HR response)
for minute in range(3, 5):
    for sec in range(0, 60, 10):
        det.push(82.0 + (sec % 3), minute * 60_000 + sec * 1000)

rise = det.get_hr_rise(NOW)
_check("HR rise detected", rise >= THRESHOLD,
     f"rise = {rise:.2f} bpm (threshold {THRESHOLD})")


# ============================================================================
# Scenario 2 — Sedentary (no change)
# ============================================================================
section("2. Sedentary: HR stays at baseline")

det = HrRiseDetector()
for minute in range(0, 5):
    for sec in range(0, 60, 10):
        det.push(70.0, minute * 60_000 + sec * 1000)

rise = det.get_hr_rise(NOW)
_check("No HR rise", rise < THRESHOLD, f"rise = {rise:.2f} bpm")


# ============================================================================
# Scenario 3 — Gradual walker (sub-threshold rise)
# ============================================================================
section("3. Gradual walker: +4 bpm over 5 min")

det = HrRiseDetector()
for minute in range(0, 5):
    # Linear climb from 70 to 74
    bpm = 70.0 + minute * 0.8
    for sec in range(0, 60, 10):
        det.push(bpm, minute * 60_000 + sec * 1000)

rise = det.get_hr_rise(NOW)
_check("sub-threshold rise NOT flagged", rise < THRESHOLD,
     f"rise = {rise:.2f} bpm")


# ============================================================================
# Scenario 4 — Coffee drinker (single small spike)
# ============================================================================
section("4. Coffee: one small +3 bpm spike")

det = HrRiseDetector()
for minute in range(0, 5):
    for sec in range(0, 60, 10):
        # Baseline 70, spike to 73 at minute 4
        bpm = 73.0 if (minute == 4 and sec < 20) else 70.0
        det.push(bpm, minute * 60_000 + sec * 1000)

rise = det.get_hr_rise(NOW)
_check("coffee spike NOT flagged", rise < THRESHOLD,
     f"rise = {rise:.2f} bpm")


# ============================================================================
# Scenario 5 — Not enough data (1 sample)
# ============================================================================
section("5. Single-sample timeline")

det = HrRiseDetector()
det.push(75.0, NOW)
rise = det.get_hr_rise(NOW)
_check("returns 0 with 1 sample", rise == 0.0, f"rise = {rise}")


# ============================================================================
# Scenario 6 — Empty timeline
# ============================================================================
section("6. Empty timeline")

det = HrRiseDetector()
rise = det.get_hr_rise(NOW)
_check("returns 0 with no samples", rise == 0.0)


# ============================================================================
# Scenario 7 — Missing baseline window
# ============================================================================
section("7. Only recent samples (no baseline window)")

det = HrRiseDetector()
# Only samples from last 90 seconds → baseline window (3-5 min ago) is empty
for sec in range(0, 90, 10):
    det.push(80.0, NOW - sec * 1000)

rise = det.get_hr_rise(NOW)
_check("returns 0 when baseline window is empty", rise == 0.0,
     f"rise = {rise}")


# ============================================================================
# Scenario 8 — HR timeline pruning
# ============================================================================
section("8. Timeline pruning keeps only last 5 min")

det = HrRiseDetector()
# Push 10 minutes of data
for minute in range(0, 10):
    det.push(70.0 + minute, minute * 60_000)

# After the last push at minute 9, anything > 5 min old should be dropped
oldest = min(ts for ts, _ in det.timeline) if det.timeline else 0
_check("oldest sample is within 5 min of last push",
     (9 * 60_000 - oldest) <= 5 * 60_000,
     f"oldest at t={oldest / 1000:.0f}s")


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