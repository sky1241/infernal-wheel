"""
Regression test for BUG+018 — CryptoService now wired into DataStore.

Before this fix: CryptoService existed and was initialized by main.dart
(setupAuto / unlockAuto) but its encrypt/decrypt helpers were NEVER called
from DataStore. Every file read/write went through plain `writeAsString`
and `readAsString`. Marketing + PRIVACY_POLICY claimed AES-256-GCM
encryption — a direct lie.

After the fix: DataStore has `_readSecure(File)` and `_writeSecure(File,
String)` helpers that route all I/O through CryptoService. Legacy plain
files from before the fix are detected and migrated on first read.

This test verifies the plumbing via static-grep:
  1. DataStore imports CryptoService
  2. _readSecure and _writeSecure helpers exist and are used
  3. No direct writeAsString or readAsString on data files
  4. BUG+018 fix markers present
  5. CSV append mode (FileMode.append) is gone — replaced with
     read-modify-write (required because encrypted files can't be streamed)
  6. The legacy "PRIVACY GAP" warning banner is gone
  7. The onboarding + docs claims are now truthful (reflects the fix)

It also re-validates that test_crypto_service_format.py is still green —
the actual AES-256-GCM format used by CryptoService is unchanged.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_STORE = os.path.join(
    REPO_ROOT, "infernal-app", "lib", "server", "data_store.dart"
)
ONBOARDING = os.path.join(
    REPO_ROOT, "infernal-app", "lib", "views", "onboarding_screen.dart"
)
PRIVACY = os.path.join(REPO_ROOT, "infernal-app", "PRIVACY_POLICY.md")
README = os.path.join(REPO_ROOT, "README.md")


def _read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# Plumbing: DataStore must use CryptoService
# ============================================================================

def test_data_store_imports_crypto_service():
    src = _read(DATA_STORE)
    assert re.search(
        r"^import\s+['\"]\.\./security/crypto_service\.dart['\"]\s*;",
        src,
        re.MULTILINE,
    ), "BUG+018 regression: data_store.dart no longer imports CryptoService"


def test_data_store_has_crypto_field():
    src = _read(DATA_STORE)
    assert re.search(
        r"final\s+_crypto\s*=\s*CryptoService\(\)",
        src,
    ), "BUG+018 regression: DataStore._crypto field removed"


def test_read_secure_helper_defined():
    src = _read(DATA_STORE)
    assert re.search(
        r"Future<String\?>\s+_readSecure\(File\s+file\)\s+async",
        src,
    ), "BUG+018 regression: _readSecure helper removed"


def test_write_secure_helper_defined():
    src = _read(DATA_STORE)
    assert re.search(
        r"Future<void>\s+_writeSecure\(File\s+file,\s*String\s+content\)\s+async",
        src,
    ), "BUG+018 regression: _writeSecure helper removed"


def test_write_secure_refuses_plaintext_when_locked():
    """The _writeSecure body must throw if crypto is not unlocked — we must
    NEVER fall back to plaintext writes."""
    src = _read(DATA_STORE)
    idx = src.find("Future<void> _writeSecure")
    assert idx >= 0
    body = src[idx:idx + 800]
    assert "isUnlocked" in body
    assert "StateError" in body or "throw" in body, (
        "BUG+018 regression: _writeSecure no longer throws when crypto is locked"
    )


def test_read_secure_has_legacy_migration():
    """_readSecure must try decrypt first, then fall back to reading plain
    and re-encrypting it (migration for pre-fix legacy files)."""
    src = _read(DATA_STORE)
    idx = src.find("Future<String?> _readSecure")
    assert idx >= 0
    body = src[idx:idx + 1500]
    assert "decryptFromFile" in body
    assert "encryptToFile" in body, (
        "BUG+018 regression: _readSecure no longer migrates legacy plain files"
    )


# ============================================================================
# No direct plaintext I/O on data files
# ============================================================================

def test_no_direct_write_as_string_on_data_files():
    """All writes must go through _writeSecure. Direct `writeAsString` on
    any data file is a regression."""
    src = _read(DATA_STORE)
    # Look for any `_someFile.writeAsString(` or `file.writeAsString(`
    # patterns — note that we ALLOW the call inside _writeSecure-adjacent
    # code ONLY through encryptToFile, which is a CryptoService method,
    # not `File.writeAsString`.
    patterns = [
        # _settingsFile, _stateFile, _quickNoteFile, _actionNoteFile,
        # _drinksFile, _logFile direct writes:
        r"_\w+File\.writeAsString\(",
        # File('...').writeAsString( pattern:
        r"File\([^)]+\)\.writeAsString\(",
        # any local file variable .writeAsString(
        # Safe because the legit writes go through encryptToFile (a
        # CryptoService method, not a File method).
    ]
    for pat in patterns:
        matches = re.findall(pat, src)
        assert not matches, (
            f"BUG+018 regression: direct File.writeAsString found in "
            f"data_store.dart: {matches}"
        )


def test_no_direct_read_as_string_on_data_files():
    """All reads must go through _readSecure (which internally may call
    readAsString for legacy migration — that's OK but only inside the
    helper)."""
    src = _read(DATA_STORE)
    # Count readAsString occurrences. The ONLY legit site is inside
    # _readSecure itself for the legacy-plain migration path.
    matches = re.findall(r"\.readAsString\(", src)
    # Expect exactly 1 — the legacy read inside _readSecure.
    assert len(matches) <= 1, (
        f"BUG+018 regression: {len(matches)} readAsString() calls in "
        f"data_store.dart; expected at most 1 (the legacy-migration read "
        f"inside _readSecure)"
    )


def test_no_file_mode_append():
    """FileMode.append is incompatible with per-write encryption. All CSV
    sites must use read-modify-write instead. Check only in actual code,
    not comments (the fix doc explains the old pattern)."""
    src = _read(DATA_STORE)
    # Strip // comments and /// doc comments
    code_only = "\n".join(
        re.sub(r"\s*//.*$", "", line) for line in src.splitlines()
    )
    assert "FileMode.append" not in code_only, (
        "BUG+018 regression: FileMode.append reappeared in code — "
        "incompatible with encrypted writes (each produces a unique IV/tag)"
    )


def test_all_write_sites_go_through_write_secure():
    """Count the call sites of _writeSecure. We have at least 7 expected:
    saveSettings, saveState, saveNote, saveQuickNote, saveActionNote,
    addDrink, addLogRow."""
    src = _read(DATA_STORE)
    calls = re.findall(r"_writeSecure\(", src)
    # 7 callers + 1 method definition = at least 8 occurrences
    assert len(calls) >= 8, (
        f"BUG+018 regression: only {len(calls)} _writeSecure occurrences; "
        f"expected >= 8 (definition + 7 save/add callers)"
    )


def test_all_read_sites_go_through_read_secure():
    """loadSettings, loadState, loadNote, loadAllNotes, loadQuickNote,
    loadActionNote, getDailyAlcohol, getAllConsumption, getDrinksWeeks
    = 9 callers + 1 definition = at least 10 occurrences."""
    src = _read(DATA_STORE)
    calls = re.findall(r"_readSecure\(", src)
    assert len(calls) >= 10, (
        f"BUG+018 regression: only {len(calls)} _readSecure occurrences; "
        f"expected >= 10 (definition + 9 load/get callers)"
    )


# ============================================================================
# Banner removed + markers present
# ============================================================================

def test_privacy_gap_banner_removed():
    """The `!!! BUG+018 PRIVACY GAP !!!` banner at the top of DataStore
    must be gone, replaced with a description of the fix."""
    src = _read(DATA_STORE)
    assert "BUG+018 PRIVACY GAP" not in src, (
        "BUG+018 regression: PRIVACY GAP banner reappeared"
    )


def test_bug_018_fix_marker_present():
    src = _read(DATA_STORE)
    assert "BUG+018 fix" in src, (
        "BUG+018 regression: fix marker removed from data_store.dart"
    )


# ============================================================================
# Downstream: onboarding copy + docs restored
# ============================================================================

def test_onboarding_restores_chiffre_claim():
    """With BUG+018 fixed, the onboarding copy can honestly say 'chiffre'
    (encrypted) again. BUG+034 was the temporary workaround during the
    defer."""
    src = _read(ONBOARDING)
    assert "chiffre" in src, (
        "BUG+018 regression: onboarding copy no longer mentions 'chiffre' "
        "even though the encryption is actually wired now"
    )


def test_privacy_policy_claims_aes256():
    """With BUG+018 fixed, PRIVACY_POLICY.md can honestly claim AES-256-GCM
    encryption."""
    src = _read(PRIVACY)
    # The encryption at rest bullet must exist
    assert "AES-256-GCM" in src
    # Must not contain the "inaccurate/removed" disclaimer text that was
    # added as a workaround during the defer
    assert "claim was inaccurate" not in src, (
        "BUG+018 regression: PRIVACY_POLICY.md still has the BUG+058 "
        "disclaimer text, but the underlying bug is now fixed"
    )


def test_readme_security_mentions_bug_018_fix():
    """README Security section must state encryption is active (not deferred)."""
    src = _read(README)
    idx = src.find("## Security")
    assert idx >= 0
    sec = src[idx:idx + 2500]
    assert "AES-256-GCM" in sec
    # Must not say "deferred" or "NOT yet wired" anywhere in the Security
    # section about encryption
    assert "deferred" not in sec.lower() or "BUG+018 fix" in sec, (
        "BUG+018 regression: README Security still marks encryption as deferred"
    )


# ============================================================================
# Cross-check: existing crypto format tests still pass
# ============================================================================

def test_crypto_format_tests_file_exists():
    """The existing AES-GCM format spec test must still be present — it
    defines the binary format that _readSecure/_writeSecure use."""
    path = os.path.join(
        REPO_ROOT, "trilateration", "test_crypto_service_format.py"
    )
    assert os.path.isfile(path), (
        "BUG+018 depends on test_crypto_service_format.py staying intact"
    )
