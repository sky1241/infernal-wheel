"""
Regression test for SmokingDetector.kt BUG+032 — interpreter thread safety.

TFLite Interpreter.run() is not thread-safe. DetectionService has 3 inference
coroutines (periodic 50Hz, boost, 25Hz Samsung callback) running on
Dispatchers.Default (a thread pool), so two concurrent inference calls would
crash natively or return corrupted results.

This test is a static grep over SmokingDetector.kt that asserts every
interpreter.run() call is wrapped in synchronized(interpreterLock).
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SMOKING_DETECTOR = os.path.join(
    REPO_ROOT,
    "trilateration",
    "wear-os-app",
    "app",
    "src",
    "main",
    "java",
    "com",
    "infernal",
    "smokingdetector",
    "SmokingDetector.kt",
)


@pytest.fixture(scope="module")
def source():
    with open(SMOKING_DETECTOR, encoding="utf-8") as f:
        return f.read()


def test_interpreter_lock_declared(source):
    """A dedicated lock object must exist for serializing interpreter.run()."""
    assert re.search(
        r"private\s+val\s+interpreterLock\s*=\s*Object\(\)",
        source,
    ), "BUG+032 regression: interpreterLock no longer declared"


def test_all_run_calls_wrapped_in_synchronized(source):
    """Every `interp.run(...)` must appear inside a `synchronized(interpreterLock) { ... }` block."""
    run_calls = list(re.finditer(r"\binterp\.run\s*\(", source))
    assert len(run_calls) >= 3, (
        f"expected at least 3 interp.run() calls (features + 50Hz + 25Hz); "
        f"found {len(run_calls)}"
    )

    for match in run_calls:
        # Look at the 200 chars before this call — the synchronized block
        # should open there.
        window_start = max(0, match.start() - 200)
        preamble = source[window_start:match.start()]
        assert "synchronized(interpreterLock)" in preamble, (
            f"BUG+032 regression: interp.run() at offset {match.start()} "
            f"is not wrapped in synchronized(interpreterLock).\n"
            f"Preamble: ...{preamble[-120:]!r}"
        )


def test_bug_032_marker_present(source):
    assert "BUG+032" in source, "BUG+032 fix marker missing from SmokingDetector.kt"


def test_no_raw_interpreter_run_outside_lock(source):
    """Count: interp.run() calls should equal the number of synchronized
    interp.run blocks."""
    run_calls = len(re.findall(r"\binterp\.run\s*\(", source))
    # Pattern: synchronized(interpreterLock) { ...optional... interp.run(...)
    synced_run_calls = len(
        re.findall(
            r"synchronized\(interpreterLock\)\s*\{\s*interp\.run\s*\(",
            source,
        )
    )
    assert run_calls == synced_run_calls, (
        f"BUG+032 regression: {run_calls} interp.run() calls but only "
        f"{synced_run_calls} are wrapped in synchronized(interpreterLock)"
    )
