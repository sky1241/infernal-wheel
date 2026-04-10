"""
Regression test for sleep_service.dart BUG+029.

Static-analysis test that verifies sleep_service.dart returns the correct
3-field sleep model (durationMinutes / inBedMinutes / asleepMinutes) where
asleepMinutes is NEVER the in-bed fallback.

Before the fix, the code did:
  if (asleepMinutes > 0) totalMinutes = asleepMinutes;
  ...
  'asleepMinutes': asleepMinutes > 0 ? asleepMinutes : totalMinutes,

which meant `asleepMinutes` would silently report in-bed time as a fallback.
The dashboard couldn't distinguish "in bed 8h, slept 5h" from "in bed 8h,
slept 8h" — both rendered identically because the two fields collapsed.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SLEEP_SERVICE = os.path.join(
    REPO_ROOT, "infernal-app", "lib", "services", "sleep_service.dart"
)


@pytest.fixture(scope="module")
def source():
    with open(SLEEP_SERVICE, encoding="utf-8") as f:
        return f.read()


def test_no_overwrite_of_totalMinutes_with_asleep(source):
    """The bug was: `if (asleepMinutes > 0) totalMinutes = asleepMinutes;`
    which mutated the in-bed total. The fix introduces a separate
    durationMinutes variable so totalMinutes/inBedMinutes is preserved."""
    # The bad pattern must be gone.
    assert "totalMinutes = asleepMinutes" not in source, (
        "BUG+029 regression: totalMinutes is still being overwritten with asleepMinutes"
    )


def test_asleep_minutes_field_no_fallback_to_total(source):
    """The bug was the ternary `asleepMinutes > 0 ? asleepMinutes : totalMinutes`
    on the asleepMinutes JSON field. The fix returns asleepMinutes directly."""
    bad_pattern = re.search(
        r"['\"]asleepMinutes['\"]\s*:\s*asleepMinutes\s*>\s*0\s*\?",
        source,
    )
    assert bad_pattern is None, (
        "BUG+029 regression: asleepMinutes field still uses the totalMinutes fallback"
    )


def test_asleep_minutes_field_present(source):
    """The asleepMinutes JSON field must still exist (not accidentally removed)."""
    assert re.search(r"['\"]asleepMinutes['\"]\s*:", source), (
        "asleepMinutes field missing from getLastNightSleep output"
    )


def test_in_bed_minutes_field_present(source):
    """inBedMinutes must still exist as a separate field."""
    assert re.search(r"['\"]inBedMinutes['\"]\s*:", source)


def test_duration_minutes_field_present(source):
    """durationMinutes is the primary field the dashboard reads."""
    assert re.search(r"['\"]durationMinutes['\"]\s*:", source)


def test_bug_marker_in_source(source):
    """The fix should be self-documenting so a future contributor doesn't
    re-collapse the fields trying to "simplify"."""
    assert "BUG+029" in source, "BUG+029 fix marker missing from sleep_service.dart"
