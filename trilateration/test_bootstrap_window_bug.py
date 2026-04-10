"""
Regression test for the BUG #1 bootstrap window bug in DetectionService.

THE BUG (before fix):
---------------------
DetectionService.onSamsung25HzBatch had a single counter `batchCountForLog`
serving two roles:
  1. Throttle the diagnostic log to the first 10 batches
  2. Drive the bootstrap window (skip temporal filter for first 50 batches)

The counter was only incremented INSIDE the log throttle block:

    if (batchCountForLog < BOOTSTRAP_LOG_BATCHES) {  // < 10
        Log.i(...)
        batchCountForLog++
    }

    val isBootstrap = batchCountForLog < BOOTSTRAP_BATCHES  // < 50

After 10 batches, `batchCountForLog == 10` and stops incrementing forever.
The condition `10 < 50` stays TRUE indefinitely → bootstrap never ends →
the temporal filter (smoking-hour gating) is NEVER applied. The CNN runs
on every single batch 24/7, wasting CPU and battery, and the gaussian
hour pattern is bypassed entirely.

THE FIX:
--------
Two separate counters, both with explicit and unconditional update:

    private var totalBatchesReceived: Long = 0L  // drives bootstrap
    private var loggedBatchCount: Int = 0        // drives log throttle

    totalBatchesReceived++  // every batch
    if (loggedBatchCount < BOOTSTRAP_LOG_BATCHES) {
        Log.i(...)
        loggedBatchCount++
    }
    val isBootstrap = totalBatchesReceived < BOOTSTRAP_BATCHES

This test simulates the buggy logic vs the fixed logic on a 100-batch
stream and asserts that:
  - Buggy logic: bootstrap never ends (always returns isBootstrap=true)
  - Fixed logic: bootstrap ends exactly after BOOTSTRAP_BATCHES=50 batches
"""
import sys

GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"
passed = 0
failed = 0


def test(name, condition, detail=""):
    global passed, failed
    if condition:
        print(f"  {GREEN}OK{RESET}  {name}" + (f"  ({detail})" if detail else ""))
        passed += 1
    else:
        print(f"  {RED}FAIL{RESET}  {name}" + (f"  ({detail})" if detail else ""))
        failed += 1


def section(title):
    print(f"\n=== {title} ===")


BOOTSTRAP_LOG_BATCHES = 10
BOOTSTRAP_BATCHES = 50


def buggy_simulation(n_batches):
    """Reproduces the bug: a single counter that stops at LOG_BATCHES."""
    counter = 0
    bootstrap_ended_at = None
    for batch_idx in range(n_batches):
        # The bug: increment is gated on the log throttle
        if counter < BOOTSTRAP_LOG_BATCHES:
            counter += 1

        is_bootstrap = counter < BOOTSTRAP_BATCHES
        if not is_bootstrap and bootstrap_ended_at is None:
            bootstrap_ended_at = batch_idx
    return bootstrap_ended_at, counter


def fixed_simulation(n_batches):
    """The fix: two independent counters."""
    total = 0
    logged = 0
    bootstrap_ended_at = None
    for batch_idx in range(n_batches):
        total += 1
        if logged < BOOTSTRAP_LOG_BATCHES:
            logged += 1

        is_bootstrap = total < BOOTSTRAP_BATCHES
        if not is_bootstrap and bootstrap_ended_at is None:
            bootstrap_ended_at = batch_idx
    return bootstrap_ended_at, total, logged


# ============================================================================
section("1. Reproduce the bug — 100 batches with the buggy counter")

ended_at, final_counter = buggy_simulation(100)
print(f"  Counter after 100 batches: {final_counter}")
print(f"  Bootstrap ended at batch: {ended_at}")
test("buggy counter caps at 10",
     final_counter == BOOTSTRAP_LOG_BATCHES,
     f"capped at {final_counter}")
test("buggy bootstrap NEVER ends",
     ended_at is None,
     f"ended_at={ended_at}")


# ============================================================================
section("2. Verify the fix — same 100 batches with two counters")

ended_at, total, logged = fixed_simulation(100)
print(f"  Total batches received: {total}")
print(f"  Logged batches: {logged}")
print(f"  Bootstrap ended at batch index: {ended_at}")
test("fix: total counter reaches 100",
     total == 100)
test("fix: logged counter still capped at 10",
     logged == BOOTSTRAP_LOG_BATCHES)
test("fix: bootstrap ends after exactly BOOTSTRAP_BATCHES batches",
     ended_at is not None and ended_at == BOOTSTRAP_BATCHES - 1,
     f"ended_at={ended_at} (after batch {(ended_at or 0) + 1})")


# ============================================================================
section("3. Operational impact — before vs after on 24h of 25Hz batches")

# Samsung delivers ~5 batches/min → 7200 batches per day
batches_per_day = 7200

ended_at_buggy, _ = buggy_simulation(batches_per_day)
ended_at_fixed, _, _ = fixed_simulation(batches_per_day)

print(f"  Buggy: bootstrap ended at batch {ended_at_buggy} of {batches_per_day}")
print(f"  Fixed: bootstrap ended at batch {ended_at_fixed} of {batches_per_day}")
test("buggy: full day still in bootstrap (CNN runs 100% of the time)",
     ended_at_buggy is None)
test("fixed: bootstrap ends in first ~10 minutes",
     ended_at_fixed == BOOTSTRAP_BATCHES - 1)


print("\n" + "=" * 50)
print(f"  Tests passed: {GREEN}{passed}{RESET}")
print(f"  Tests failed: {RED if failed > 0 else GREEN}{failed}{RESET}")
print("=" * 50)

sys.exit(0 if failed == 0 else 1)
