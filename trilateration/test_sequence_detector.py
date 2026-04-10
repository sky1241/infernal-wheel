"""
Sequence detector tests — replicate the Kotlin SequenceDetector in Python
and validate its behavior against realistic scenarios.

The Kotlin class is in
  wear-os-app/app/src/main/java/com/infernal/smokingdetector/SequenceDetector.kt

We reimplement its core logic here so we can run hundreds of simulated
scenarios without having to boot the watch. The Kotlin and Python versions
share the exact same constants and algorithm — a bug in one is a bug in both.

Scenarios tested
----------------
  1. Real cigarette from the 20:18 on-device log (4 peaks at ~0.60-0.65)
  2. Coffee break (1 isolated peak)
  3. Meal (2 isolated peaks over 10 minutes)
  4. Random noise (no peaks)
  5. Two cigarettes in a row (both should trigger, debounce respected)
  6. High-smoking hour (2 peaks should trigger instead of 3)
  7. Cooldown — a peak 30 seconds after a trigger does NOT re-trigger
  8. Sliding window eviction — peaks older than 6 min don't count
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
# Python port of SequenceDetector.kt — must stay in sync
# ============================================================================
class SequenceDetector:
    WINDOW_MS = 6 * 60 * 1000       # 6 min sliding window
    PEAK_THRESHOLD = 0.50
    MIN_PEAKS = 3
    MIN_PEAKS_SMOKING_HOUR = 2
    COOLDOWN_MS = 2 * 60 * 1000     # post-trigger cooldown

    def __init__(self):
        self.samples = []  # list of (timestamp_ms, probability)
        self.last_trigger_ms = -1  # -1 = no trigger yet, cooldown never applies

    def push(self, probability, now_ms, is_high_smoking_hour=False):
        # Prune old samples
        self.samples = [s for s in self.samples if now_ms - s[0] <= self.WINDOW_MS]
        self.samples.append((now_ms, probability))

        peak_count = sum(1 for _, p in self.samples if p >= self.PEAK_THRESHOLD)
        required = self.MIN_PEAKS_SMOKING_HOUR if is_high_smoking_hour else self.MIN_PEAKS
        in_cooldown = (self.last_trigger_ms >= 0 and
                       (now_ms - self.last_trigger_ms) < self.COOLDOWN_MS)

        triggered = (not in_cooldown) and peak_count >= required
        if triggered:
            self.last_trigger_ms = now_ms
            self.samples = []  # reset on trigger

        return {
            "triggered": triggered,
            "peak_count": peak_count,
            "required": required,
        }


# ============================================================================
# Scenario 1 — Real cigarette from on-device log (20:18 test)
# ============================================================================
section("1. Real cigarette from 20:18 on-device log")

det = SequenceDetector()
# Simulated inference stream from the real log: timestamps 12s apart,
# probabilities as observed on the watch
stream = [
    (0,       0.25),    # 20:18:32 rest
    (12_000,  0.18),    # 20:18:44 rest
    (24_000,  0.60),    # 20:18:56 puff 1
    (36_000,  0.61),    # 20:19:08 puff 1 still
    (48_000,  0.49),    # 20:19:20
    (60_000,  0.23),
    (72_000,  0.36),
    (84_000,  0.65),    # 20:19:56 puff 2
    (96_000,  0.57),    # 20:20:08 puff 3
    (108_000, 0.30),
    (120_000, 0.45),
]

triggered = False
trigger_index = -1
for i, (t, p) in enumerate(stream):
    r = det.push(p, t, is_high_smoking_hour=False)
    if r["triggered"]:
        triggered = True
        trigger_index = i
        break

_check("real cigarette triggers the detector",
     triggered,
     f"triggered at sample {trigger_index}")
_check("trigger happens within 120 seconds of start",
     triggered and stream[trigger_index][0] <= 120_000,
     f"t={stream[trigger_index][0] / 1000:.0f}s" if triggered else "never")


# ============================================================================
# Scenario 2 — Coffee break (1 isolated peak)
# ============================================================================
section("2. Coffee break (1 isolated peak)")

det = SequenceDetector()
stream = [
    (0,       0.10),
    (12_000,  0.12),
    (24_000,  0.60),    # bringing cup to mouth
    (36_000,  0.15),
    (48_000,  0.11),
]
any_trigger = any(det.push(p, t)["triggered"] for t, p in stream)
_check("coffee break does NOT trigger", not any_trigger)


# ============================================================================
# Scenario 3 — Meal (2 isolated bouchees spread apart)
# ============================================================================
section("3. Meal (2 bouchees over 5 minutes)")

det = SequenceDetector()
stream = [
    (0,       0.15),
    (60_000,  0.55),    # first bite
    (120_000, 0.25),
    (180_000, 0.28),
    (240_000, 0.55),    # second bite
    (300_000, 0.20),
]
any_trigger = any(det.push(p, t)["triggered"] for t, p in stream)
_check("meal with 2 peaks does NOT trigger", not any_trigger)


# ============================================================================
# Scenario 4 — Random noise
# ============================================================================
section("4. Random sub-threshold noise")

det = SequenceDetector()
import random
random.seed(42)
any_trigger = False
for i in range(100):
    p = 0.10 + random.random() * 0.35  # random in [0.10, 0.45], never reaching 0.50
    if det.push(p, i * 12_000)["triggered"]:
        any_trigger = True
        break
_check("random sub-threshold noise never triggers", not any_trigger)


# ============================================================================
# Scenario 5 — Two consecutive cigarettes
# ============================================================================
section("5. Two consecutive cigarettes (debounce respected)")

det = SequenceDetector()
triggers = []
# Cigarette 1: 4 peaks at t=0..48s
for t, p in [(0, 0.60), (12_000, 0.60), (24_000, 0.62), (36_000, 0.55)]:
    if det.push(p, t)["triggered"]:
        triggers.append(t)

# 30 more seconds of "low" values (inside cooldown)
for t in range(48_000, 148_000, 12_000):
    if det.push(0.20, t)["triggered"]:
        triggers.append(t)

# Cigarette 2: 4 peaks at t=180_000..228_000 (3 min after trigger 1, past cooldown)
for t, p in [(180_000, 0.60), (192_000, 0.60), (204_000, 0.62), (216_000, 0.55)]:
    if det.push(p, t)["triggered"]:
        triggers.append(t)

_check("both cigarettes trigger separately",
     len(triggers) == 2,
     f"{len(triggers)} trigger(s)")
_check("second trigger is > 2 min after first",
     len(triggers) == 2 and (triggers[1] - triggers[0]) > 120_000,
     f"gap = {(triggers[1] - triggers[0]) / 1000:.0f}s" if len(triggers) == 2 else "")


# ============================================================================
# Scenario 6 — High smoking hour (2 peaks suffice)
# ============================================================================
section("6. High smoking hour lowers the bar to 2 peaks")

det = SequenceDetector()
# Only 2 peaks in 48s
stream = [(0, 0.15), (12_000, 0.60), (24_000, 0.25), (36_000, 0.62)]
triggered = any(det.push(p, t, is_high_smoking_hour=True)["triggered"] for t, p in stream)
_check("2 peaks in smoking hour -> trigger", triggered)

# Same stream outside smoking hour -> should NOT trigger
det2 = SequenceDetector()
triggered_normal = any(det2.push(p, t, is_high_smoking_hour=False)["triggered"] for t, p in stream)
_check("same 2 peaks outside smoking hour -> NO trigger", not triggered_normal)


# ============================================================================
# Scenario 7 — Cooldown blocks re-trigger
# ============================================================================
section("7. Cooldown — re-trigger within 2 min is blocked")

det = SequenceDetector()
# Trigger once
for t, p in [(0, 0.60), (12_000, 0.60), (24_000, 0.62)]:
    det.push(p, t)

# 30 seconds later, another peak burst
triggered_again = any(
    det.push(p, t)["triggered"]
    for t, p in [(54_000, 0.70), (66_000, 0.70), (78_000, 0.70)]
)
_check("re-trigger 30s after first -> blocked by cooldown",
     not triggered_again)


# ============================================================================
# Scenario 8 — Sliding window eviction
# ============================================================================
section("8. Sliding window eviction")

det = SequenceDetector()
# 2 peaks at the beginning
det.push(0.60, 0)
det.push(0.60, 12_000)

# Wait 7 minutes — those peaks should be evicted
# Push 1 new peak; total active peaks = 1, not 3 -> no trigger
r = det.push(0.60, 7 * 60 * 1000)
_check("peaks older than 6 min are evicted",
     r["peak_count"] == 1,
     f"peak_count={r['peak_count']}")
_check("single remaining peak does NOT trigger",
     not r["triggered"])


# ============================================================================
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