"""
Regression tests for local_server.dart BUG+026/027/028.

The Dart server can't be unit-tested from Python directly, so this test acts
as a STATIC ANALYZER over the source file: it greps for the dangerous patterns
that were fixed and asserts they no longer appear (and the new patterns DO).

  BUG+026: 0.0.0.0 bind exposed the API to the entire LAN with no auth.
           Fix: bind to 127.0.0.1.
  BUG+027: existsSync / readAsStringSync inside async handlers blocked the
           Dart isolate. Fix: await file.exists() / await file.readAsString().
  BUG+028: drinks/add and drinks/adjust accepted unbounded n, allowing data
           pollution. Fix: clamp(1, 50) and clamp(0, 50).

If a future change reintroduces any of these patterns this test will fail
loudly so the bug doesn't sneak back in.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LOCAL_SERVER = os.path.join(
    REPO_ROOT, "infernal-app", "lib", "server", "local_server.dart"
)


@pytest.fixture(scope="module")
def source():
    with open(LOCAL_SERVER, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# BUG+026 — bind must be loopback only
# ============================================================================

def test_local_server_binds_to_loopback_only(source):
    """The shelf_io.serve call must bind to 127.0.0.1, never 0.0.0.0."""
    # Find the actual serve call (skip comments mentioning 0.0.0.0).
    serve_calls = re.findall(r"shelf_io\.serve\([^)]*\)", source)
    assert serve_calls, "no shelf_io.serve call found — file structure changed"
    for call in serve_calls:
        assert "0.0.0.0" not in call, (
            f"BUG+026 regression: shelf_io.serve still binds 0.0.0.0 → {call}"
        )
        assert "127.0.0.1" in call, (
            f"BUG+026 regression: shelf_io.serve doesn't bind 127.0.0.1 → {call}"
        )


def test_local_server_documents_bug_026(source):
    """The fix should be documented inline so a future contributor doesn't
    'helpfully' switch it back to 0.0.0.0 to make the watch HTTP path work."""
    assert "BUG+026" in source, "BUG+026 fix marker missing from local_server.dart"


# ============================================================================
# BUG+027 — no sync I/O inside async handlers
# ============================================================================

def test_local_server_no_existssync(source):
    """existsSync inside the file would block the Dart isolate."""
    matches = re.findall(r"\.existsSync\(\)", source)
    assert matches == [], (
        f"BUG+027 regression: {len(matches)} existsSync() call(s) reintroduced"
    )


def test_local_server_no_read_as_string_sync(source):
    """readAsStringSync inside the file would block the Dart isolate."""
    matches = re.findall(r"\.readAsStringSync\(\)", source)
    assert matches == [], (
        f"BUG+027 regression: {len(matches)} readAsStringSync() call(s) reintroduced"
    )


def test_local_server_uses_async_file_io(source):
    """The fixed handlers must use the await variants."""
    assert "await summaryFile.exists()" in source or "await detectFile.exists()" in source
    # At least one async readAsString should appear in the file.
    assert "await" in source and "readAsString()" in source


# ============================================================================
# BUG+028 — drinks endpoints must clamp n
# ============================================================================

def test_drinks_add_clamps_n(source):
    """The /api/drinks/add handler must clamp the incoming n to a sane range."""
    # Find the _handleApiDrinksAdd body via a simple slice between its
    # signature and the next 'Future<Response>' declaration.
    sig = "Future<Response> _handleApiDrinksAdd(Request request) async {"
    idx = source.find(sig)
    assert idx >= 0, "_handleApiDrinksAdd not found"
    next_handler = source.find("Future<Response>", idx + len(sig))
    body = source[idx:next_handler]
    assert ".clamp(" in body, (
        "BUG+028 regression: drinks/add no longer clamps n"
    )


def test_drinks_adjust_clamps_total(source):
    """The /api/drinks/adjust handler must clamp the incoming total."""
    sig = "Future<Response> _handleApiDrinksAdjust(Request request) async {"
    idx = source.find(sig)
    assert idx >= 0, "_handleApiDrinksAdjust not found"
    next_handler = source.find("Future<Response>", idx + len(sig))
    body = source[idx:next_handler]
    # Must clamp the total parameter (the bug was unbounded `total`)
    assert ".clamp(0, 50)" in body, (
        "BUG+028 regression: drinks/adjust no longer clamps total"
    )


# ============================================================================
# Sanity — file is still well-formed
# ============================================================================

def test_local_server_still_compiles_to_valid_dart(source):
    """Cheap sanity check: the file still has matching braces and a class decl."""
    assert "class LocalServer" in source
    assert source.count("{") == source.count("}")
