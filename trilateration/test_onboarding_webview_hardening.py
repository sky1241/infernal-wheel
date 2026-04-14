"""
Regression tests for BUG+034 (onboarding privacy copy) and BUG+035 (WebView
navigation allow-list).

BUG+034: The onboarding screen claimed "Tout reste sur ton telephone, chiffre"
before the user committed to the app, but BUG+018 proves the crypto is not
wired. Short-term fix: drop the "chiffre" claim until BUG+018 is resolved.

BUG+035: The dashboard WebView's NavigationDelegate had no onNavigationRequest
handler, so any in-page navigation (anchor tag, JS redirect) would be
followed unconditionally. Fix: explicit allow-list for 127.0.0.1:8011 and
localhost:8011.

These are static-grep tests that fail loudly if the fix regresses.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ONBOARDING = os.path.join(
    REPO_ROOT, "infernal-app", "lib", "views", "onboarding_screen.dart"
)
WEBVIEW = os.path.join(
    REPO_ROOT, "infernal-app", "lib", "views", "dashboard_webview.dart"
)


@pytest.fixture(scope="module")
def onboarding_source():
    with open(ONBOARDING, encoding="utf-8") as f:
        return f.read()


@pytest.fixture(scope="module")
def webview_source():
    with open(WEBVIEW, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# BUG+034 — onboarding must not claim encryption until BUG+018 is fixed
# ============================================================================

def test_onboarding_does_not_claim_chiffre(onboarding_source):
    """The displayed feature line must not say 'chiffre' (encrypted) until
    the underlying crypto is actually wired (BUG+018)."""
    # Look at _buildFeature calls that reference the privacy icon.
    lock_feature_calls = re.findall(
        r'_buildFeature\(\s*Icons\.lock_outline[^)]*\)',
        onboarding_source,
    )
    assert lock_feature_calls, "no lock_outline feature found — copy may have moved"
    # BUG+018 (crypto wiring) is now fixed, so the "chiffre" claim is truthful
    # again. The BUG+034 temporary workaround (strip "chiffre") is no longer
    # needed. This test now asserts the OPPOSITE: the chiffre claim IS present.
    for call in lock_feature_calls:
        assert "chiffre" in call.lower(), (
            f"BUG+018 regression: onboarding no longer claims encryption even "
            f"though BUG+018 fix wired CryptoService into DataStore: {call!r}"
        )


def test_onboarding_keeps_local_only_claim(onboarding_source):
    """The 'local only' claim is still true and should remain visible."""
    assert "Tout reste sur ton telephone" in onboarding_source


def test_bug_034_marker_present(onboarding_source):
    """The fix should be self-documenting so a future contributor doesn't
    'restore' the encryption copy without checking BUG+018."""
    assert "BUG+034" in onboarding_source


# ============================================================================
# BUG+035 — WebView must have an onNavigationRequest allow-list
# ============================================================================

def test_webview_has_on_navigation_request(webview_source):
    """NavigationDelegate must include onNavigationRequest."""
    assert "onNavigationRequest" in webview_source, (
        "BUG+035 regression: NavigationDelegate missing onNavigationRequest"
    )


def test_webview_uses_navigation_decision_prevent(webview_source):
    """The non-loopback branch must return NavigationDecision.prevent."""
    assert "NavigationDecision.prevent" in webview_source, (
        "BUG+035 regression: NavigationDecision.prevent no longer present"
    )


def test_webview_loopback_allow_list(webview_source):
    """Only loopback URLs should be allowed."""
    assert "127.0.0.1:8011" in webview_source
    assert "localhost:8011" in webview_source


def test_webview_allow_list_order_correct(webview_source):
    """The allow-list check must happen BEFORE the prevent fallback, not
    after — otherwise the prevent always fires first."""
    allow_idx = webview_source.find("NavigationDecision.navigate")
    prevent_idx = webview_source.find("NavigationDecision.prevent")
    assert allow_idx >= 0 and prevent_idx >= 0
    assert allow_idx < prevent_idx, (
        "BUG+035 regression: NavigationDecision.prevent comes before the "
        "allow-list check — every navigation will be blocked"
    )


def test_bug_035_marker_present(webview_source):
    assert "BUG+035" in webview_source


# ============================================================================
# Dead Dart code — logger.dart + result.dart must not be reintroduced
# ============================================================================

def test_logger_dart_stays_deleted():
    logger_path = os.path.join(
        REPO_ROOT, "infernal-app", "lib", "core", "logger.dart"
    )
    assert not os.path.exists(logger_path), (
        "logger.dart was readded — it has zero callers in lib/ and 180 LOC of "
        "dead code. Either wire it in or keep it deleted."
    )


def test_result_dart_stays_deleted():
    result_path = os.path.join(
        REPO_ROOT, "infernal-app", "lib", "core", "result.dart"
    )
    assert not os.path.exists(result_path), (
        "result.dart was readded — it has zero callers in lib/ and 141 LOC of "
        "dead code. Either wire it in or keep it deleted."
    )
