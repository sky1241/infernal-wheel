"""
Regression test for DetectionService.kt BUG+031 — debounce race condition.

The Kotlin pattern can't run from Python, so this test combines:
  1. Static-grep assertions that the fix is in place (AtomicLong + CAS loop).
  2. A Python port of the CAS-based debounce that proves the algorithm is
     race-safe under concurrent access.

The bug: `if (now - lastDetectionTime < 120_000) return; lastDetectionTime = now`
is a non-atomic check-then-set. 3 inference paths (periodic 30s, boost listener,
Samsung 25Hz callback) can concurrently call handleCigaretteDetected and BOTH
pass the check before either updates the timestamp.

The fix: AtomicLong.compareAndSet in a retry loop — only one thread per
debounce window succeeds.
"""
import os
import re
import threading
import time

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DETECTION_SERVICE = os.path.join(
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
    "DetectionService.kt",
)


@pytest.fixture(scope="module")
def source():
    with open(DETECTION_SERVICE, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# Static-grep: fix is in place
# ============================================================================

def test_last_detection_time_is_atomic(source):
    """lastDetectionTime must be an AtomicLong, not a plain Long."""
    assert re.search(
        r"val\s+lastDetectionTime\s*=\s*java\.util\.concurrent\.atomic\.AtomicLong",
        source,
    ), "BUG+031 regression: lastDetectionTime is no longer AtomicLong"


def test_last_drink_detection_time_is_atomic(source):
    assert re.search(
        r"val\s+lastDrinkDetectionTime\s*=\s*java\.util\.concurrent\.atomic\.AtomicLong",
        source,
    ), "BUG+031 regression: lastDrinkDetectionTime is no longer AtomicLong"


def test_handle_cigarette_uses_compare_and_set(source):
    """The cigarette debounce must use compareAndSet, not naive assignment."""
    idx = source.find("private fun handleCigaretteDetected")
    assert idx >= 0
    body = source[idx:idx + 2000]
    assert "lastDetectionTime.compareAndSet" in body, (
        "BUG+031 regression: handleCigaretteDetected no longer uses compareAndSet"
    )


def test_handle_drink_uses_compare_and_set(source):
    idx = source.find("private fun handleDrinkDetected")
    assert idx >= 0
    body = source[idx:idx + 2000]
    assert "lastDrinkDetectionTime.compareAndSet" in body, (
        "BUG+031 regression: handleDrinkDetected no longer uses compareAndSet"
    )


def test_no_naive_assignment_to_last_detection_time(source):
    """The buggy pattern `lastDetectionTime = currentTime` must not reappear."""
    # Match only direct assignment (not method calls like .set())
    bad = re.findall(r"lastDetectionTime\s*=\s*currentTime", source)
    assert not bad, "BUG+031 regression: naive assignment reintroduced"


def test_bug_031_marker_present(source):
    assert "BUG+031" in source, "BUG+031 fix marker missing"


# ============================================================================
# Python port of the CAS-loop debounce — race safety proof
# ============================================================================

class AtomicLong:
    """Minimal AtomicLong port for testing the CAS-loop algorithm."""
    def __init__(self, value=0):
        self._value = value
        self._lock = threading.Lock()

    def get(self):
        with self._lock:
            return self._value

    def compare_and_set(self, expect, new):
        with self._lock:
            if self._value == expect:
                self._value = new
                return True
            return False


def debounce_kotlin_port(atomic: AtomicLong, now_ms: int, window_ms: int = 120_000):
    """Direct port of the Kotlin fixed code:

        while (true) {
            val prev = lastDetectionTime.get()
            if (currentTime - prev < 120_000) return false
            if (lastDetectionTime.compareAndSet(prev, currentTime)) return true
        }

    Returns True if the caller should proceed (debounce passed), False if debounced.
    """
    while True:
        prev = atomic.get()
        if now_ms - prev < window_ms:
            return False
        if atomic.compare_and_set(prev, now_ms):
            return True


def debounce_naive_BROKEN(atomic: AtomicLong, now_ms: int, window_ms: int = 120_000):
    """The BUGGY pre-fix version — check then assign, non-atomically."""
    prev = atomic.get()
    if now_ms - prev < window_ms:
        return False
    # Artificial delay to make the race more likely in the naive version —
    # simulates the Kotlin instructions between the check and the write.
    time.sleep(0.0001)
    # Non-atomic set (bypasses the CAS): just overwrite.
    with atomic._lock:
        atomic._value = now_ms
    return True


def test_cas_debounce_single_winner_under_concurrency():
    """Under 50 concurrent threads all hitting the debounce at the same ms,
    exactly ONE must be allowed through."""
    atomic = AtomicLong(0)
    now = 1_000_000  # well past the initial 0
    winners = []
    winners_lock = threading.Lock()

    def worker():
        if debounce_kotlin_port(atomic, now):
            with winners_lock:
                winners.append(threading.current_thread().name)

    threads = [threading.Thread(target=worker) for _ in range(50)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

    assert len(winners) == 1, (
        f"CAS debounce must let exactly 1 thread through; got {len(winners)}"
    )


def test_naive_debounce_lets_multiple_through_BROKEN_BASELINE():
    """Proves the bug: the pre-fix naive pattern lets multiple threads
    through under concurrency.

    This test is inherently timing-sensitive — Python's GIL scheduling
    can occasionally serialize the threads and let only 1 winner through
    on a single run. We retry the scenario up to 3 times before giving
    up; if ALL 3 attempts show only 1 winner, the Python port is
    shielding us from reproducing the race. In that case the test is
    marked xfail (expected-fail) so the baseline knowledge is preserved
    without causing CI flakes.

    On real Kotlin/JVM with 3 inference coroutines and millisecond-scale
    time deltas, the race is reliably reproducible — this Python port is
    a proof-of-concept, not a literal reproduction.
    """
    max_winners_seen = 0
    for attempt in range(3):
        atomic = AtomicLong(0)
        now = 1_000_000
        winners = []
        winners_lock = threading.Lock()

        def worker():
            if debounce_naive_BROKEN(atomic, now):
                with winners_lock:
                    winners.append(1)

        # Bump to 100 threads and pre-start them via a start_barrier to
        # maximize contention relative to the sleep(0.0001) inside
        # debounce_naive_BROKEN.
        start_barrier = threading.Event()

        def barrier_worker():
            start_barrier.wait()
            worker()

        threads = [threading.Thread(target=barrier_worker) for _ in range(100)]
        for t in threads:
            t.start()
        start_barrier.set()
        for t in threads:
            t.join()

        max_winners_seen = max(max_winners_seen, len(winners))
        if max_winners_seen >= 2:
            return  # bug reproduced, test passes

    pytest.xfail(
        f"Python port could not reliably reproduce the race over 3 attempts "
        f"(max winners = {max_winners_seen}). The bug is real on Kotlin/JVM — "
        f"see DetectionService.kt BUG+031 fix comments."
    )


def test_cas_debounce_blocks_second_call_within_window():
    """Single-threaded: second call within 120s must be rejected."""
    atomic = AtomicLong(0)

    assert debounce_kotlin_port(atomic, 1_000_000) is True
    assert debounce_kotlin_port(atomic, 1_000_000 + 60_000) is False  # 60s later
    assert debounce_kotlin_port(atomic, 1_000_000 + 119_999) is False  # just inside
    assert debounce_kotlin_port(atomic, 1_000_000 + 120_000) is True   # exactly at boundary
