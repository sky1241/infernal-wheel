"""
Regression test for BUG+046 — offline queue race in syncOfflineQueue.

The JS function syncOfflineQueue in index.html cached the offline queue
into a local `const q` at the start, awaited each fetch, then wrote
`q.slice(synced)` back to localStorage at the end. If the connection
dropped mid-sync and the user triggered a new offline action during one
of the awaits, that new action was appended to localStorage by
queueOfflineAction — but the final save overwrote localStorage with the
stale `q.slice(synced)`, silently dropping the new item.

This test combines:
  1. Static-grep on index.html to verify the fix pattern is in place.
  2. A Python port of the fixed algorithm with a simulated interleaved
     "new item arrives during sync" scenario, proving the fix preserves
     the new item while the buggy version would lose it.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INDEX_HTML = os.path.join(
    REPO_ROOT, "infernal-app", "assets", "web", "index.html"
)


@pytest.fixture(scope="module")
def source():
    with open(INDEX_HTML, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# Static-grep: the fix pattern must be in place
# ============================================================================

def test_no_slice_based_final_save(source):
    """The bad pattern was `saveOfflineQueue(q.slice(synced))` at the end
    of the loop. Must be gone."""
    # Look for saveOfflineQueue(...slice...) specifically inside syncOfflineQueue
    idx = source.find("async function syncOfflineQueue")
    assert idx >= 0
    body = source[idx:idx + 2500]
    bad = re.search(r"saveOfflineQueue\([^)]*\.slice\(", body)
    assert bad is None, (
        f"BUG+046 regression: syncOfflineQueue still uses .slice on a "
        f"stale snapshot: {bad.group(0) if bad else '?'}"
    )


def test_per_item_remove_by_ts_and_url(source):
    """The fix pattern removes each item after a successful fetch by
    matching ts + url in the CURRENT queue (re-read from localStorage)."""
    idx = source.find("async function syncOfflineQueue")
    body = source[idx:idx + 2500]
    # Must find the findIndex with ts/url match
    assert re.search(
        r"findIndex\(x\s*=>\s*x\.ts\s*===\s*item\.ts\s*&&\s*x\.url\s*===\s*item\.url\)",
        body,
    ), "BUG+046 regression: per-item ts+url findIndex removed"


def test_uses_getOfflineQueue_inside_loop(source):
    """The fixed loop must call getOfflineQueue() AFTER each successful
    fetch to re-read any items queued during the await."""
    idx = source.find("async function syncOfflineQueue")
    body = source[idx:idx + 2500]
    # Count getOfflineQueue calls inside the function: should be >= 2
    # (one initial, one per-successful-fetch inside the loop)
    count = body.count("getOfflineQueue()")
    assert count >= 2, (
        f"BUG+046 regression: getOfflineQueue() only called {count} time(s) "
        f"in syncOfflineQueue — the fix needs 2+ (initial + per-success)"
    )


def test_bug_046_marker_present(source):
    assert "BUG+046" in source


# ============================================================================
# Python port: prove the fix preserves the new item, buggy version drops it
# ============================================================================

def _fixed_sync(storage, fetch_results):
    """Port of the fixed syncOfflineQueue.

    storage is a dict with key 'queue' whose value is the list of items.
    fetch_results is a list of booleans — True means the fetch for that
    item succeeded, False means it failed.

    Returns the number of items successfully synced.
    """
    initial_q = list(storage['queue'])
    synced = 0
    for i, item in enumerate(initial_q):
        if i < len(fetch_results) and fetch_results[i]:
            # SIMULATE interleaved new item arrival during the await:
            # before removing the synced item, a new offline action
            # appends to the queue.
            if item.get('_inject_new_here'):
                storage['queue'].append({'ts': 9999, 'url': '/api/injected'})

            # Re-read and remove the synced item
            current = list(storage['queue'])
            idx = next(
                (j for j, x in enumerate(current)
                 if x['ts'] == item['ts'] and x['url'] == item['url']),
                -1,
            )
            if idx >= 0:
                current.pop(idx)
                storage['queue'] = current
            synced += 1
        else:
            break
    return synced


def _buggy_sync(storage, fetch_results):
    """Port of the ORIGINAL buggy syncOfflineQueue — caches the snapshot
    and writes q.slice(synced) at the end."""
    q = list(storage['queue'])
    synced = 0
    for i, item in enumerate(q):
        if i < len(fetch_results) and fetch_results[i]:
            if item.get('_inject_new_here'):
                storage['queue'].append({'ts': 9999, 'url': '/api/injected'})
            synced += 1
        else:
            break
    if synced > 0:
        storage['queue'] = q[synced:]
    return synced


def test_fixed_version_preserves_items_queued_during_sync():
    """Feed 3 items, mark the second with _inject_new_here (simulates a
    new queue item arriving while await fetch yields). After sync, the
    injected item must still be in the queue."""
    storage = {'queue': [
        {'ts': 1, 'url': '/api/drinks', '_inject_new_here': False},
        {'ts': 2, 'url': '/api/cmd', '_inject_new_here': True},
        {'ts': 3, 'url': '/api/goal', '_inject_new_here': False},
    ]}
    synced = _fixed_sync(storage, [True, True, True])
    assert synced == 3

    # The injected item should still be in the queue
    remaining_urls = [x['url'] for x in storage['queue']]
    assert '/api/injected' in remaining_urls, (
        "BUG+046 regression: item queued during sync was LOST by fixed version"
    )


def test_buggy_version_loses_items_queued_during_sync():
    """Baseline: demonstrate that the old pattern LOSES the new item.
    This test is the proof that the bug actually existed and that
    the fixed version above actually fixes it."""
    storage = {'queue': [
        {'ts': 1, 'url': '/api/drinks', '_inject_new_here': False},
        {'ts': 2, 'url': '/api/cmd', '_inject_new_here': True},
        {'ts': 3, 'url': '/api/goal', '_inject_new_here': False},
    ]}
    synced = _buggy_sync(storage, [True, True, True])
    assert synced == 3

    remaining_urls = [x['url'] for x in storage['queue']]
    # The bug: /api/injected is NOT in the final queue — it was overwritten.
    assert '/api/injected' not in remaining_urls, (
        "Baseline assertion failed: the buggy version was supposed to LOSE "
        "the injected item. If this passes, the test port is broken."
    )


def test_fixed_version_handles_partial_sync():
    """Only the first 2 of 3 items sync successfully. The failed third
    item must remain in the queue."""
    storage = {'queue': [
        {'ts': 1, 'url': '/api/a'},
        {'ts': 2, 'url': '/api/b'},
        {'ts': 3, 'url': '/api/c'},
    ]}
    synced = _fixed_sync(storage, [True, True, False])
    assert synced == 2
    remaining_urls = [x['url'] for x in storage['queue']]
    assert remaining_urls == ['/api/c']
