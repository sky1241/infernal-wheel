"""
Regression test for main.dart BUG+030 — app lifecycle state save.

Static-grep test that asserts main.dart wires the WidgetsBindingObserver
mixin and calls flushState() on lifecycle pause/detach. Without this, a
user action (clope, dodo, drink) can be lost if the OS kills the app
process within the 5s debounce window of the local_server _saveState.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MAIN_DART = os.path.join(REPO_ROOT, "infernal-app", "lib", "main.dart")
LOCAL_SERVER = os.path.join(
    REPO_ROOT, "infernal-app", "lib", "server", "local_server.dart"
)


@pytest.fixture(scope="module")
def main_source():
    with open(MAIN_DART, encoding="utf-8") as f:
        return f.read()


@pytest.fixture(scope="module")
def server_source():
    with open(LOCAL_SERVER, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# main.dart side: observer registered + lifecycle handler exists
# ============================================================================

def test_app_launcher_uses_widgets_binding_observer(main_source):
    """The state class must mix in WidgetsBindingObserver."""
    assert re.search(
        r"class _AppLauncherState extends State<AppLauncher>\s+with\s+WidgetsBindingObserver",
        main_source,
    ), "BUG+030 regression: _AppLauncherState no longer mixes in WidgetsBindingObserver"


def test_observer_added_in_init_state(main_source):
    """Must call addObserver(this) in initState so the OS sees us."""
    assert "addObserver(this)" in main_source, (
        "BUG+030 regression: addObserver(this) missing from initState"
    )


def test_observer_removed_in_dispose(main_source):
    """Must call removeObserver(this) in dispose to avoid leaks."""
    assert "removeObserver(this)" in main_source, (
        "BUG+030 regression: removeObserver(this) missing from dispose"
    )


def test_did_change_app_lifecycle_state_implemented(main_source):
    """The override must exist and react to paused/detached."""
    assert "didChangeAppLifecycleState" in main_source
    assert "AppLifecycleState.paused" in main_source
    assert "AppLifecycleState.detached" in main_source


def test_lifecycle_handler_calls_flush_state(main_source):
    """The lifecycle handler must actually persist state — calling
    flushState() (not the debounced _saveState path)."""
    assert "localServer.flushState()" in main_source, (
        "BUG+030 regression: lifecycle handler no longer calls flushState"
    )


def test_bug_030_marker_present(main_source):
    assert "BUG+030" in main_source, (
        "BUG+030 fix marker missing — future contributor may revert the observer"
    )


# ============================================================================
# local_server.dart side: flushState() exposed
# ============================================================================

def test_local_server_exposes_flush_state(server_source):
    """LocalServer must expose a public flushState that bypasses the 5s
    debounce — the whole point of BUG+030's fix."""
    assert re.search(
        r"Future<void>\s+flushState\(\)\s+async",
        server_source,
    ), "BUG+030 regression: LocalServer.flushState() removed"


def test_flush_state_resets_debounce(server_source):
    """flushState should reset _lastSave so subsequent saves are debounced
    from now (not from a stale time)."""
    # Find the flushState body
    idx = server_source.find("Future<void> flushState()")
    assert idx >= 0
    body = server_source[idx:idx + 300]
    assert "_lastSave" in body and "_saveStateAsync" in body
