"""
Regression tests for round 13 audits — BUG+055, BUG+056, BUG+057, BUG+058.

  BUG+055: index.html autosave intervals (quicknote, actionnote) had no
           in-flight guard. Slow network → two concurrent POSTs racing.

  BUG+056: test_integration.py simulated bar trajectory had `bar_lon -
           bar_lon` (always 0) instead of `bar_lon - home_lon` — degenerate
           N-only path that masked any real 2-D clustering bug.

  BUG+057: test_compression.test_daily_storage had ZERO assert statements
           — pytest false positive that always passes. Added 2 real
           sanity assertions.

  BUG+058: docs (README.md, PRIVACY_POLICY.md) claimed AES-256 encryption
           but BUG+018 proves crypto is not wired. Inaccurate marketing/
           legal claims removed.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INDEX_HTML = os.path.join(
    REPO_ROOT, "infernal-app", "assets", "web", "index.html"
)
TEST_INTEGRATION = os.path.join(
    REPO_ROOT, "trilateration", "test_integration.py"
)
TEST_COMPRESSION = os.path.join(
    REPO_ROOT, "trilateration", "test_compression.py"
)
README = os.path.join(REPO_ROOT, "README.md")
PRIVACY = os.path.join(REPO_ROOT, "infernal-app", "PRIVACY_POLICY.md")


def _read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# BUG+055 — autosave in-flight guard
# ============================================================================

def test_quicknote_has_in_flight_guard():
    src = _read(INDEX_HTML)
    # qSaving flag must be declared
    assert re.search(r"let\s+qSaving\s*=\s*false", src), (
        "BUG+055 regression: qSaving flag removed for quicknote autosave"
    )
    # And the autosave loop must check + set it
    assert "if(qSaving) return;" in src, (
        "BUG+055 regression: quicknote autosave no longer skips on in-flight"
    )


def test_actionnote_has_in_flight_guard():
    src = _read(INDEX_HTML)
    assert re.search(r"let\s+aSaving\s*=\s*false", src), (
        "BUG+055 regression: aSaving flag removed for actionnote autosave"
    )
    assert "if(aSaving) return;" in src, (
        "BUG+055 regression: actionnote autosave no longer skips on in-flight"
    )


def test_bug_055_marker_present():
    assert "BUG+055" in _read(INDEX_HTML)


def test_notes_autosave_has_in_flight_guard():
    """BUG+060: notes.html had the same race as BUG+055."""
    notes_html = os.path.join(
        REPO_ROOT, "infernal-app", "assets", "web", "notes.html"
    )
    src = _read(notes_html)
    assert re.search(r"var\s+noteSaving\s*=\s*false", src), (
        "BUG+060 regression: noteSaving flag removed for notes.html autosave"
    )
    assert "if (noteSaving) return;" in src, (
        "BUG+060 regression: notes.html autosave no longer skips on in-flight"
    )


def test_bug_060_marker_present():
    notes_html = os.path.join(
        REPO_ROOT, "infernal-app", "assets", "web", "notes.html"
    )
    assert "BUG+060" in _read(notes_html)


# ============================================================================
# BUG+056 — test_integration.py degenerate trajectory
# ============================================================================

def test_no_self_subtraction_in_integration_trajectory():
    """The bug was `bar_lon - bar_lon` in actual code (not comments)."""
    src = _read(TEST_INTEGRATION)
    # Strip comments so the BUG+056 fix marker (which mentions the old
    # buggy expression as documentation) doesn't trigger this test.
    code_only = "\n".join(
        re.sub(r"\s*#.*$", "", line) for line in src.splitlines()
    )
    bad = re.search(r"bar_lon\s*-\s*bar_lon", code_only)
    assert bad is None, (
        "BUG+056 regression: degenerate `bar_lon - bar_lon` reappeared in code"
    )


def test_integration_uses_correct_lon_diff():
    """The fix: `(bar_lon - home_lon)` for the eastward motion."""
    src = _read(TEST_INTEGRATION)
    assert "bar_lon - home_lon" in src, (
        "BUG+056 regression: trajectory no longer moves eastward"
    )


def test_bug_056_marker_present():
    assert "BUG+056" in _read(TEST_INTEGRATION)


# ============================================================================
# BUG+057 — false positive test had no asserts
# ============================================================================

def test_compression_daily_storage_has_asserts():
    """test_daily_storage must contain at least 2 assert statements
    (the OLD version had zero, making it a pytest false positive)."""
    src = _read(TEST_COMPRESSION)
    idx = src.find("def test_daily_storage")
    assert idx >= 0
    # Find the next def to bound the function body
    next_def = src.find("\ndef ", idx + 1)
    body = src[idx:next_def] if next_def > 0 else src[idx:]
    asserts = re.findall(r"^\s+assert\s", body, re.MULTILINE)
    assert len(asserts) >= 2, (
        f"BUG+057 regression: test_daily_storage has only {len(asserts)} "
        f"assert(s); must have >= 2 (compression ratio + storage size)"
    )


def test_bug_057_marker_present():
    assert "BUG+057" in _read(TEST_COMPRESSION)


# ============================================================================
# BUG+058 — docs no longer make false AES-256 claims
# ============================================================================

def test_privacy_policy_claims_encryption_now_wired():
    """BUG+018 is now fixed — PRIVACY_POLICY.md CAN and SHOULD claim
    AES-256-GCM encryption truthfully. (This test was inverted from its
    BUG+058 version which expected the claim to be absent; the underlying
    reality changed when BUG+018 shipped.)"""
    src = _read(PRIVACY)
    assert "AES-256-GCM" in src, (
        "BUG+018 regression: PRIVACY_POLICY.md no longer mentions the "
        "AES-256-GCM encryption that is actually wired"
    )
    # The BUG+058 disclaimer text ("claim was inaccurate") should be gone
    # now that the claim is actually accurate.
    assert "claim was inaccurate" not in src, (
        "BUG+058 disclaimer text still in PRIVACY_POLICY even though BUG+018 "
        "has shipped — remove the disclaimer to reflect the current truth"
    )


def test_readme_restores_aes256_architecture_line():
    """Architecture diagram can show 'AES-256-GCM store' again (or similar
    wording) now that the encryption is wired."""
    src = _read(README)
    # Just assert AES-256-GCM is mentioned somewhere in the architecture
    # region or security section (we deliberately leave the exact wording
    # flexible so the test doesn't force a specific diagram format).
    assert "AES-256-GCM" in src, (
        "BUG+018 regression: README no longer mentions AES-256-GCM even "
        "though encryption is now active"
    )


def test_readme_security_section_claims_active_encryption():
    """README Security section must state encryption IS active (not deferred)."""
    src = _read(README)
    idx = src.find("## Security")
    assert idx >= 0
    sec = src[idx:idx + 2500]
    assert "AES-256-GCM" in sec
    # The Security section should reference the BUG+018 fix, not leave the
    # old "deferred" caveat.
    assert "BUG+018 fix" in sec or "Encryption at rest" in sec, (
        "BUG+018 regression: README Security section doesn't document that "
        "encryption at rest is now active"
    )
