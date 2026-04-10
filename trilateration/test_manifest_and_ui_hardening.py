"""
Regression tests for BUG+039 (MainActivity double-tap debounce),
BUG+040 (DetectionService exported) and BUG+041 (allowBackup privacy).

These are all static-grep assertions on the watch manifest and Kotlin
source files. They fail loudly if any of the fixes regress.

BUG+039 — MainActivity onLogCigarette/onLogDrink had no debounce. Rapid
double-tap on the +1 button created duplicate DB rows, duplicate BT
syncs, and re-triggered boost mode mid-countdown. Fix: AtomicLong CAS
debounce with MANUAL_LOG_DEBOUNCE_MS window.

BUG+040 — DetectionService was android:exported="true" in the MAIN
manifest. Any other app on the watch could fire ACTION_START/STOP/BOOST
Intents. Fix: exported="false".

BUG+041 — android:allowBackup="true" meant the cigarette/drink SQLite
DB synced to Google Drive without explicit consent. Fix: allowBackup="false".
"""
import os
import re
import xml.etree.ElementTree as ET

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WATCH_MANIFEST = os.path.join(
    REPO_ROOT,
    "trilateration",
    "wear-os-app",
    "app",
    "src",
    "main",
    "AndroidManifest.xml",
)
MAIN_ACTIVITY = os.path.join(
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
    "MainActivity.kt",
)


@pytest.fixture(scope="module")
def manifest_source():
    with open(WATCH_MANIFEST, encoding="utf-8") as f:
        return f.read()


@pytest.fixture(scope="module")
def main_activity_source():
    with open(MAIN_ACTIVITY, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# BUG+039 — MainActivity manual log debounce
# ============================================================================

def test_main_activity_has_manual_log_debounce_const(main_activity_source):
    """The debounce window constant must be declared in the companion object."""
    assert "MANUAL_LOG_DEBOUNCE_MS" in main_activity_source, (
        "BUG+039 regression: MANUAL_LOG_DEBOUNCE_MS constant removed"
    )


def test_main_activity_uses_atomic_long_for_last_click(main_activity_source):
    """Must use AtomicLong + compareAndSet — not a plain Long."""
    assert re.search(
        r"lastManualLogMs\s*=\s*java\.util\.concurrent\.atomic\.AtomicLong",
        main_activity_source,
    ), "BUG+039 regression: lastManualLogMs no longer AtomicLong"


def test_consume_manual_click_uses_compare_and_set(main_activity_source):
    """The consume function must implement the CAS retry loop, identical
    in spirit to DetectionService BUG+031."""
    idx = main_activity_source.find("private fun consumeManualClick")
    assert idx >= 0, "consumeManualClick function missing"
    body = main_activity_source[idx:idx + 600]
    assert "compareAndSet" in body, (
        "BUG+039 regression: consumeManualClick no longer uses compareAndSet"
    )


def test_cigarette_lambda_calls_consume_manual_click(main_activity_source):
    """onLogCigarette lambda must consume the click early and return on fail."""
    # Find the onLogCigarette lambda body
    idx = main_activity_source.find("onLogCigarette = {")
    assert idx >= 0
    body = main_activity_source[idx:idx + 1500]
    assert "consumeManualClick()" in body, (
        "BUG+039 regression: onLogCigarette no longer debounced"
    )


def test_drink_lambda_calls_consume_manual_click(main_activity_source):
    idx = main_activity_source.find("onLogDrink = {")
    assert idx >= 0
    body = main_activity_source[idx:idx + 1500]
    assert "consumeManualClick()" in body, (
        "BUG+039 regression: onLogDrink no longer debounced"
    )


def test_bug_039_marker_present(main_activity_source):
    assert "BUG+039" in main_activity_source


# ============================================================================
# BUG+040 — DetectionService must NOT be exported
# ============================================================================

def test_detection_service_is_not_exported(manifest_source):
    """Parse the manifest and verify android:exported is false for the
    DetectionService declaration."""
    ns = {"android": "http://schemas.android.com/apk/res/android"}
    root = ET.fromstring(manifest_source)
    services = root.findall(".//service", ns)
    assert services, "No <service> declarations found in watch manifest"
    for svc in services:
        name = svc.get("{http://schemas.android.com/apk/res/android}name")
        if name and "DetectionService" in name:
            exported = svc.get("{http://schemas.android.com/apk/res/android}exported")
            assert exported == "false", (
                f"BUG+040 regression: DetectionService exported={exported!r} "
                f"(must be false)"
            )
            return
    pytest.fail("DetectionService declaration not found in manifest")


def test_bug_040_marker_present(manifest_source):
    assert "BUG+040" in manifest_source


def test_exported_true_only_via_debug_override_comment(manifest_source):
    """The inline comment must explain that any exported=true must come
    from a debug-variant override, not a blanket flag in main."""
    # Find the service declaration and check nearby comment
    svc_idx = manifest_source.find("DetectionService")
    assert svc_idx >= 0
    window = manifest_source[max(0, svc_idx - 600):svc_idx + 100]
    assert "src/debug/AndroidManifest.xml" in window or "debug build variant" in window


# ============================================================================
# BUG+041 — allowBackup must be false
# ============================================================================

def test_allow_backup_is_false(manifest_source):
    """Parse the manifest and verify android:allowBackup is false."""
    ns = {"android": "http://schemas.android.com/apk/res/android"}
    root = ET.fromstring(manifest_source)
    app = root.find("application", ns)
    assert app is not None, "No <application> element found"
    allow_backup = app.get("{http://schemas.android.com/apk/res/android}allowBackup")
    assert allow_backup == "false", (
        f"BUG+041 regression: allowBackup={allow_backup!r} (must be false)"
    )


def test_bug_041_marker_present(manifest_source):
    assert "BUG+041" in manifest_source
