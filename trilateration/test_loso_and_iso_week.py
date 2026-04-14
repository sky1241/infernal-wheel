"""
Regression tests for BUG+053 (proximity_smoking label leak) and
BUG+054 (ISO week computation in data_store.dart).

BUG+053: test_loso.py and train_baseline.py both passed
         `proximity_smoking = 0.5 if gesture == 'cigarette' else 0.1`,
         a perfect label leak that made the reported LOSO F1 meaningless
         — the classifier only needed to learn `proximity > 0.3 → cig`.
         Fix: proximity is drawn uniformly in [0, 1] regardless of gesture.

BUG+054: data_store.dart getDrinksWeeks used a naive formula
         `((dayOfYear - weekday + 10) / 7).floor()` combined with
         `dt.year` for the week key. Produced week 0 for early January
         dates and mislabeled year-boundary weeks (e.g. 2025-12-29 Mon
         got "2025-W53" instead of the real ISO "2026-W01").
         Fix: proper ISO 8601 algorithm — find Thursday of the week,
         use its year as the ISO year.
"""
import os
import re
from datetime import date, datetime, timedelta

import numpy as np
import pytest


REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TEST_LOSO = os.path.join(REPO_ROOT, "trilateration", "test_loso.py")
TRAIN_BASELINE = os.path.join(REPO_ROOT, "trilateration", "train_baseline.py")
DATA_STORE = os.path.join(
    REPO_ROOT, "infernal-app", "lib", "server", "data_store.dart"
)


@pytest.fixture(scope="module")
def test_loso_source():
    with open(TEST_LOSO, encoding="utf-8") as f:
        return f.read()


@pytest.fixture(scope="module")
def train_baseline_source():
    with open(TRAIN_BASELINE, encoding="utf-8") as f:
        return f.read()


@pytest.fixture(scope="module")
def data_store_source():
    with open(DATA_STORE, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# BUG+053 — proximity_smoking must not leak the label
# ============================================================================

def test_test_loso_no_conditional_proximity_leak(test_loso_source):
    """The bad pattern was `proximity_smoking=0.5 if gesture == 'cigarette'
    else 0.1`. Must be gone."""
    bad = re.search(
        r"proximity_smoking\s*=\s*0\.5\s+if\s+gesture\s*==\s*['\"]cigarette['\"]\s+else\s+0\.1",
        test_loso_source,
    )
    assert bad is None, (
        "BUG+053 regression: proximity_smoking label leak in test_loso.py"
    )


def test_test_loso_uses_random_proximity(test_loso_source):
    """The fix uses np.random.uniform to break the label-leak correlation."""
    assert re.search(
        r"np\.random\.uniform\([^)]*\)",
        test_loso_source,
    ), "BUG+053 regression: test_loso.py no longer uses random proximity"


def test_train_baseline_no_conditional_proximity_leak(train_baseline_source):
    bad = re.search(
        r"proximity_smoking\s*=\s*0\.5\s+if\s+gesture\s*==\s*['\"]cigarette['\"]\s+else\s+0\.1",
        train_baseline_source,
    )
    assert bad is None, (
        "BUG+053 regression: proximity_smoking label leak in train_baseline.py"
    )


def test_bug_053_markers_present(test_loso_source, train_baseline_source):
    assert "BUG+053" in test_loso_source
    assert "BUG+053" in train_baseline_source


def test_proximity_is_label_independent_under_random():
    """Logic proof: with random proximity in [0,1], there's no correlation
    between proximity and the gesture label. Under the OLD buggy pattern
    the correlation was 1.0 (perfect separation at proximity=0.3)."""
    rng = np.random.default_rng(0)
    n = 500
    gestures = ['cigarette'] * (n // 2) + ['other'] * (n // 2)

    # Old buggy generator
    old = [0.5 if g == 'cigarette' else 0.1 for g in gestures]
    # New generator
    new = [float(rng.uniform(0.0, 1.0)) for _ in gestures]

    # For the old pattern, `proximity > 0.3` is a perfect label predictor
    is_cig_old = [p > 0.3 for p in old]
    is_cig_true = [g == 'cigarette' for g in gestures]
    old_accuracy = sum(
        1 for a, b in zip(is_cig_old, is_cig_true) if a == b
    ) / n
    assert old_accuracy == 1.0, "old pattern should be a perfect leak"

    # For the new pattern, a proximity > 0.3 threshold should be near random
    is_cig_new = [p > 0.3 for p in new]
    new_accuracy = sum(
        1 for a, b in zip(is_cig_new, is_cig_true) if a == b
    ) / n
    # Expect something close to 50% (chance), certainly not above 70%
    assert new_accuracy < 0.7, (
        f"new pattern should NOT be a label leak, got accuracy={new_accuracy:.3f}"
    )


# ============================================================================
# BUG+054 — proper ISO 8601 week computation
# ============================================================================

def _iso_week_python(d: date) -> tuple[int, int]:
    """Python's canonical ISO week (reference implementation)."""
    cal = d.isocalendar()
    return (cal.year, cal.week)


def _iso_week_port_of_dart_fix(dt: datetime) -> tuple[int, int]:
    """Python port of the Dart _isoWeek helper added in the fix."""
    # Find Thursday of the same ISO week.
    # dt.weekday() in Python is 0=Mon .. 6=Sun; Dart DateTime.weekday is
    # 1=Mon .. 7=Sun. We use Python's +1 convention to match Dart.
    dart_weekday = dt.weekday() + 1
    thursday = dt + timedelta(days=4 - dart_weekday)
    iso_year = thursday.year
    jan1 = datetime(iso_year, 1, 1)
    jan1_dart_weekday = jan1.weekday() + 1
    first_thursday = jan1 + timedelta(days=(4 - jan1_dart_weekday) % 7)
    days_between = (thursday - first_thursday).days
    week_num = 1 + (days_between // 7)
    return (iso_year, week_num)


@pytest.mark.parametrize("d", [
    date(2026, 1, 1),    # Thursday → ISO 2026-W01
    date(2026, 1, 4),    # Sunday → ISO 2026-W01
    date(2026, 1, 5),    # Monday → ISO 2026-W02
    date(2025, 12, 29),  # Monday → ISO 2026-W01 (year rolls forward!)
    date(2024, 12, 30),  # Monday → ISO 2025-W01 (year rolls forward!)
    date(2024, 1, 1),    # Monday → ISO 2024-W01
    date(2020, 12, 31),  # Thursday → ISO 2020-W53 (53-week year)
    date(2021, 1, 1),    # Friday → ISO 2020-W53
    date(2021, 1, 4),    # Monday → ISO 2021-W01
])
def test_port_matches_python_iso_calendar(d):
    """Our Python port of the Dart algorithm must match Python's built-in
    ISO calendar on all the tricky dates."""
    dt = datetime(d.year, d.month, d.day)
    ours = _iso_week_port_of_dart_fix(dt)
    reference = _iso_week_python(d)
    assert ours == reference, (
        f"ISO week mismatch on {d}: got {ours}, expected {reference}"
    )


def test_port_catches_year_boundary_correctly():
    """Specific regression: 2025-12-29 was mislabeled 2025-W53 by the
    OLD formula, should be 2026-W01."""
    dt = datetime(2025, 12, 29)
    year, week = _iso_week_port_of_dart_fix(dt)
    assert (year, week) == (2026, 1), (
        f"BUG+054 regression demo: 2025-12-29 must be ISO 2026-W01, "
        f"got {year}-W{week:02d}"
    )


def test_port_catches_week_zero_bug():
    """Specific regression: 2026-01-01 was W0 under old formula, should be W01."""
    dt = datetime(2026, 1, 1)
    year, week = _iso_week_port_of_dart_fix(dt)
    assert (year, week) == (2026, 1), (
        f"BUG+054 regression demo: 2026-01-01 must be ISO 2026-W01, "
        f"got {year}-W{week:02d}"
    )


def test_dart_has_iso_week_helper(data_store_source):
    """The Dart _isoWeek helper must be defined."""
    assert re.search(
        r"\(int,\s*int\)\s+_isoWeek\(DateTime\s+dt\)",
        data_store_source,
    ), "BUG+054 regression: _isoWeek helper removed"


def test_dart_uses_iso_week_in_getDrinksWeeks(data_store_source):
    """getDrinksWeeks must call _isoWeek and use its output for the key."""
    # Find getDrinksWeeks body
    idx = data_store_source.find("getDrinksWeeks()")
    assert idx >= 0
    body = data_store_source[idx:idx + 3000]
    assert "_isoWeek(dt)" in body
    # And the weekKey must use isoYear, not dt.year
    assert "isoYear" in body
    # The bad pattern '${dt.year}-W' must be gone from the weekKey assembly
    bad = re.search(r"\$\{dt\.year\}-W\$\{", body)
    assert bad is None, (
        "BUG+054 regression: getDrinksWeeks still uses dt.year for weekKey"
    )


def test_dart_does_not_use_old_broken_formula(data_store_source):
    """The old formula `((dayOfYear - weekday + 10) / 7).floor()` must
    not reappear in getDrinksWeeks."""
    idx = data_store_source.find("getDrinksWeeks()")
    body = data_store_source[idx:idx + 3000]
    bad = re.search(
        r"\(\s*dayOfYear\s*-\s*dt\.weekday\s*\+\s*10\s*\)\s*/\s*7",
        body,
    )
    assert bad is None, (
        "BUG+054 regression: old broken formula reintroduced"
    )


def test_bug_054_marker_in_data_store(data_store_source):
    assert "BUG+054" in data_store_source
