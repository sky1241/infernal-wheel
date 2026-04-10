"""
Regression tests for the MessageSyncManager buffer eviction strategy.

THE BUG (before fix):
---------------------
When the offline buffer hits MAX_BUFFER_SIZE (500) the oldest events are
dropped FIFO. This is wrong because the buffer mixes two kinds of events:

  - "cigarette" / "drink" — critical, drives the user-visible counter
  - "training_window"     — optional ground truth for fine-tuning

A burst of training_window events (every detection captures one, plus
test floods, plus an offline period of several hours) can flood the
buffer and evict cigarette events that have been queued patiently for
hours waiting for the phone to come back.

THE FIX:
--------
trimBufferPreservingDetections() drops training_window events FIRST
(oldest first), then falls back to FIFO over remaining critical events
only if there are no training events left to drop.

This Python port re-implements the algorithm and verifies its behavior
on several scenarios.
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


MAX_BUFFER_SIZE = 500


def trim_buffer(buffer):
    """Python port of MessageSyncManager.trimBufferPreservingDetections."""
    need_to_drop = len(buffer) - MAX_BUFFER_SIZE
    if need_to_drop <= 0:
        return list(buffer)

    keep = [True] * len(buffer)
    dropped = 0

    # Pass 1 — drop oldest training_window events
    for i in range(len(buffer)):
        if dropped >= need_to_drop:
            break
        if buffer[i].get("type") == "training_window":
            keep[i] = False
            dropped += 1

    # Pass 2 — fall back to FIFO over remaining events
    for i in range(len(buffer)):
        if dropped >= need_to_drop:
            break
        if keep[i]:
            keep[i] = False
            dropped += 1

    return [b for b, k in zip(buffer, keep) if k]


# ============================================================================
section("1. Buffer under cap — no eviction")

buf = [{"type": "cigarette", "id": i} for i in range(100)]
result = trim_buffer(buf)
_check("buffer of 100 with cap 500 stays at 100", len(result) == 100)


# ============================================================================
section("2. Buffer at exactly the cap — no eviction")

buf = [{"type": "cigarette", "id": i} for i in range(MAX_BUFFER_SIZE)]
result = trim_buffer(buf)
_check(f"buffer of {MAX_BUFFER_SIZE} stays at {MAX_BUFFER_SIZE}",
     len(result) == MAX_BUFFER_SIZE)


# ============================================================================
section("3. Overflow with mixed events — training_window dropped first")

# 100 cigarette events + 450 training_window events = 550 total
# Need to drop 50. Should drop 50 oldest training_windows, keep all 100 cigs.
buf = []
for i in range(100):
    buf.append({"type": "cigarette", "id": f"cig{i}"})
for i in range(450):
    buf.append({"type": "training_window", "id": f"tw{i}"})

result = trim_buffer(buf)
print(f"  After eviction: {len(result)} events")
n_cig = sum(1 for e in result if e["type"] == "cigarette")
n_tw = sum(1 for e in result if e["type"] == "training_window")
print(f"  cigarettes kept: {n_cig}/100")
print(f"  training_window kept: {n_tw}/450")

_check("buffer trimmed to MAX_BUFFER_SIZE", len(result) == MAX_BUFFER_SIZE)
_check("ALL cigarette events preserved", n_cig == 100)
_check("training_window count = 400 (450 - 50 dropped)", n_tw == 400)


# ============================================================================
section("4. Overflow with no training events — falls back to FIFO")

# 600 cigarette events, no training. Need to drop 100, should drop oldest 100.
buf = [{"type": "cigarette", "id": i} for i in range(600)]
result = trim_buffer(buf)
_check("buffer trimmed to cap", len(result) == MAX_BUFFER_SIZE)
_check("oldest 100 dropped (FIFO fallback)",
     result[0]["id"] == 100 and result[-1]["id"] == 599)


# ============================================================================
section("5. Overflow with too few training events — partial fallback")

# 480 cigarettes + 30 training = 510. Need to drop 10.
# Should drop all 30 training? No — only need to drop 10. Drop 10 training.
buf = []
for i in range(480):
    buf.append({"type": "cigarette", "id": f"cig{i}"})
for i in range(30):
    buf.append({"type": "training_window", "id": f"tw{i}"})

result = trim_buffer(buf)
n_cig = sum(1 for e in result if e["type"] == "cigarette")
n_tw = sum(1 for e in result if e["type"] == "training_window")
_check("buffer at cap", len(result) == MAX_BUFFER_SIZE)
_check("all cigarettes preserved", n_cig == 480)
_check("10 training dropped, 20 remain", n_tw == 20)


# ============================================================================
section("6. Catastrophic overflow — all training drops + FIFO fallback")

# 550 cigarettes + 100 training = 650. Need to drop 150.
# Drop all 100 training first, then 50 oldest cigs.
buf = []
for i in range(550):
    buf.append({"type": "cigarette", "id": f"cig{i}"})
for i in range(100):
    buf.append({"type": "training_window", "id": f"tw{i}"})

result = trim_buffer(buf)
n_cig = sum(1 for e in result if e["type"] == "cigarette")
n_tw = sum(1 for e in result if e["type"] == "training_window")
_check("buffer at cap", len(result) == MAX_BUFFER_SIZE)
_check("all training dropped", n_tw == 0)
_check("50 oldest cigarettes dropped, 500 remain", n_cig == 500)
# The first cigarette kept should be cig50 (oldest 50 dropped)
remaining_cigs = [e for e in result if e["type"] == "cigarette"]
_check("oldest kept cig is cig50", remaining_cigs[0]["id"] == "cig50")


# ============================================================================
section("7. Order preserved within type after eviction")

buf = []
for i in range(300):
    buf.append({"type": "cigarette", "id": i})
# Interleave 300 training events
final = []
for i in range(300):
    final.append({"type": "cigarette", "id": i})
    final.append({"type": "training_window", "id": i})

result = trim_buffer(final)  # 600 events, drop 100
n_cig = sum(1 for e in result if e["type"] == "cigarette")
n_tw = sum(1 for e in result if e["type"] == "training_window")
_check("interleaved buffer trimmed correctly",
     len(result) == MAX_BUFFER_SIZE and n_cig == 300 and n_tw == 200)

# Check order preservation
cigs = [e["id"] for e in result if e["type"] == "cigarette"]
_check("cigarette order preserved",
     cigs == sorted(cigs))


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