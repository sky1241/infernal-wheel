"""
Gaussian hour pattern tests -- Python port of GaussianHourPattern.kt.

Scenarios:
  1. Empty pattern: returns 0 everywhere
  2. Under-trained pattern (< MIN_SAMPLES): returns 0
  3. Single peak at 9h: score is high at 9h, low at 15h
  4. Double peak at 9h + 15h: both hours score high
  5. Smooth transitions: 8h55 and 9h05 score similarly to 9h00
  6. Wrap-around: 23h30 and 00h30 score similarly for a midnight smoker
  7. Score is always in [0, 1]
"""

import math
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
# Python port of GaussianHourPattern.kt
# ============================================================================
class GaussianHourPattern:
    DEFAULT_SIGMA_MINUTES = 30.0
    MIN_SAMPLES_FOR_PATTERN = 5

    def __init__(self, hour_counts, sigma_minutes=DEFAULT_SIGMA_MINUTES):
        self.hour_counts = hour_counts
        self.sigma = sigma_minutes
        self.total_samples = sum(hour_counts.values())
        self.learned = self.total_samples >= self.MIN_SAMPLES_FOR_PATTERN
        self.peak_density = self._compute_peak_density()

    def _raw_density(self, minute_of_day):
        t = float(minute_of_day)
        two_sigma_sq = 2 * self.sigma * self.sigma
        s = 0.0
        for hour, count in self.hour_counts.items():
            mu = hour * 60 + 30
            delta = t - mu
            if delta > 720:
                wrap = delta - 1440
            elif delta < -720:
                wrap = delta + 1440
            else:
                wrap = delta
            s += count * math.exp(-(wrap * wrap) / two_sigma_sq)
        return s

    def _compute_peak_density(self):
        peak = 0.0
        for m in range(0, 1440, 5):
            d = self._raw_density(m)
            if d > peak:
                peak = d
        return peak

    def score(self, minute_of_day):
        if not self.learned or self.peak_density <= 0:
            return 0.0
        return min(1.0, max(0.0, self._raw_density(minute_of_day) / self.peak_density))

    def is_high_smoking_minute(self, minute_of_day):
        return self.score(minute_of_day) > 0.5

    def is_learned(self):
        return self.learned


# ============================================================================
# Scenario 1 -- Empty pattern
# ============================================================================
section("1. Empty pattern")

p = GaussianHourPattern({})
_check("empty pattern is not learned", not p.is_learned())
_check("empty pattern scores 0 at all hours",
     all(p.score(m) == 0 for m in range(0, 1440, 60)))


# ============================================================================
# Scenario 2 -- Under-trained
# ============================================================================
section("2. Under-trained pattern (< 5 samples)")

p = GaussianHourPattern({9: 2.0, 15: 1.0})
_check("under-trained pattern is not learned", not p.is_learned())
_check("under-trained pattern scores 0", p.score(9 * 60 + 30) == 0)


# ============================================================================
# Scenario 3 -- Single peak at 9h
# ============================================================================
section("3. Single peak at 9h")

p = GaussianHourPattern({9: 10.0})
_check("pattern is learned", p.is_learned())
score_9h = p.score(9 * 60 + 30)  # 9:30
score_15h = p.score(15 * 60 + 30)  # 15:30
print(f"  score at 9:30 = {score_9h:.3f}")
print(f"  score at 15:30 = {score_15h:.3f}")
_check("9:30 scores high (>0.9)", score_9h > 0.9)
_check("15:30 scores low (<0.1)", score_15h < 0.1)
_check("is_high_smoking_minute true at 9:30", p.is_high_smoking_minute(9 * 60 + 30))
_check("is_high_smoking_minute false at 15:30", not p.is_high_smoking_minute(15 * 60 + 30))


# ============================================================================
# Scenario 4 -- Double peak at 9h + 15h
# ============================================================================
section("4. Double peak at 9h + 15h")

p = GaussianHourPattern({9: 5.0, 15: 5.0})
score_9h = p.score(9 * 60 + 30)
score_12h = p.score(12 * 60 + 30)
score_15h = p.score(15 * 60 + 30)
print(f"  score at 9:30  = {score_9h:.3f}")
print(f"  score at 12:30 = {score_12h:.3f}")
print(f"  score at 15:30 = {score_15h:.3f}")
_check("9:30 is high", score_9h > 0.9)
_check("15:30 is high", score_15h > 0.9)
_check("12:30 is low (mid-morning gap)", score_12h < 0.2)


# ============================================================================
# Scenario 5 -- Smooth symmetric transitions around the peak
# ============================================================================
section("5. Smooth symmetric transitions around 9:30 peak")

p = GaussianHourPattern({9: 10.0})
# The peak for hour 9 is at 9:30 (hour_start + 30 min). Use symmetric points.
score_9h00 = p.score(9 * 60)         # 30 min before peak
score_9h30 = p.score(9 * 60 + 30)    # peak
score_10h00 = p.score(10 * 60)       # 30 min after peak
score_9h15 = p.score(9 * 60 + 15)    # 15 min before peak
score_9h45 = p.score(9 * 60 + 45)    # 15 min after peak
print(f"  9:00  = {score_9h00:.3f}")
print(f"  9:15  = {score_9h15:.3f}")
print(f"  9:30  = {score_9h30:.3f} (peak)")
print(f"  9:45  = {score_9h45:.3f}")
print(f"  10:00 = {score_10h00:.3f}")
_check("9:30 is the peak (score=1.0)",
     abs(score_9h30 - 1.0) < 0.01,
     f"score={score_9h30:.4f}")
_check("9:00 and 10:00 (symmetric around peak) score identically",
     abs(score_9h00 - score_10h00) < 0.01,
     f"9:00={score_9h00:.4f} 10:00={score_10h00:.4f}")
_check("9:15 and 9:45 (symmetric around peak) score identically",
     abs(score_9h15 - score_9h45) < 0.01,
     f"9:15={score_9h15:.4f} 9:45={score_9h45:.4f}")
_check("closer to peak -> higher score (9:15 > 9:00)", score_9h15 > score_9h00)
_check("no cliff at hour boundary (9:59 ~ 10:00)",
     abs(p.score(9 * 60 + 59) - p.score(10 * 60)) < 0.03,
     f"9:59={p.score(9 * 60 + 59):.4f} 10:00={p.score(10 * 60):.4f}")


# ============================================================================
# Scenario 6 -- Wrap-around at midnight
# ============================================================================
section("6. Midnight wrap-around (23h peak)")

p = GaussianHourPattern({23: 10.0})
score_23h00 = p.score(23 * 60)
score_23h30 = p.score(23 * 60 + 30)  # peak (mu = 23*60+30)
score_0h00 = p.score(0)
score_0h30 = p.score(30)
score_12h00 = p.score(12 * 60)
print(f"  23:00 = {score_23h00:.3f}")
print(f"  23:30 = {score_23h30:.3f} (peak)")
print(f"  00:00 = {score_0h00:.3f}")
print(f"  00:30 = {score_0h30:.3f}")
print(f"  12:00 = {score_12h00:.3f}")
_check("23:30 is the peak", score_23h30 > 0.9)
_check("00:00 (midnight, 30 min from peak) scores similar to 23:00",
     abs(score_0h00 - score_23h00) < 0.1,
     f"23:00={score_23h00:.3f} 00:00={score_0h00:.3f}")
_check("12:00 is far from peak, low score", score_12h00 < 0.1)


# ============================================================================
# Scenario 7 -- Score always in [0, 1]
# ============================================================================
section("7. Score bounded [0, 1]")

p = GaussianHourPattern({9: 100.0, 15: 50.0})
all_bounded = all(0.0 <= p.score(m) <= 1.0 for m in range(0, 1440))
_check("all scores are in [0, 1]", all_bounded)


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