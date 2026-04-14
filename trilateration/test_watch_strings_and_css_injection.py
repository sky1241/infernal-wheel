"""
Regression tests for BUG+051 (watch strings.xml branding + dead i18n)
and BUG+052 (CSS injection via custom action color).

BUG+051: The watch app_name was "Smoking Detector" — broke brand
         consistency with the "-1+" phone/Play Store label AND was a
         privacy leak (explicit label visible over user's shoulder on
         the watch tile). 5 unused string resources (status_ready +
         button_*) were dead i18n after the Compose UI migration.

BUG+052: injectCustomActionCSS in index.html concatenated user-authored
         a.key + a.color directly into a <style> block. The color had
         NO server-side validation. A malicious payload like
         "red;} body{display:none;} body{" could escape the custom-
         property context and inject arbitrary CSS. Fix: server-side
         strict hex regex + client-side defense-in-depth filter.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STRINGS_XML = os.path.join(
    REPO_ROOT,
    "trilateration",
    "wear-os-app",
    "app",
    "src",
    "main",
    "res",
    "values",
    "strings.xml",
)
INDEX_HTML = os.path.join(
    REPO_ROOT, "infernal-app", "assets", "web", "index.html"
)
LOCAL_SERVER = os.path.join(
    REPO_ROOT, "infernal-app", "lib", "server", "local_server.dart"
)


@pytest.fixture(scope="module")
def strings_source():
    with open(STRINGS_XML, encoding="utf-8") as f:
        return f.read()


@pytest.fixture(scope="module")
def index_source():
    with open(INDEX_HTML, encoding="utf-8") as f:
        return f.read()


@pytest.fixture(scope="module")
def server_source():
    with open(LOCAL_SERVER, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# BUG+051 — watch app_name + dead i18n
# ============================================================================

def test_watch_app_name_is_minus_one_plus(strings_source):
    """Branding must match phone/Play Store."""
    assert re.search(
        r'<string\s+name="app_name">\s*-1\+\s*</string>',
        strings_source,
    ), "BUG+051 regression: watch app_name is not '-1+'"


def test_watch_app_name_is_not_smoking_detector(strings_source):
    """Privacy + branding: the explicit 'Smoking Detector' label must not
    reappear IN A <string> VALUE (comments mentioning the history are
    fine — they explain why we changed it)."""
    # Look only inside <string> element content, not comments
    string_values = re.findall(
        r'<string[^>]*>(.*?)</string>',
        strings_source,
        re.DOTALL,
    )
    for value in string_values:
        assert "Smoking Detector" not in value, (
            "BUG+051 regression: explicit 'Smoking Detector' label reappeared "
            f"in a <string> value: {value!r}"
        )


def test_dead_i18n_strings_removed(strings_source):
    """status_ready, button_start/monitor/detect/test were unused in the
    Compose UI — dead i18n that should stay removed."""
    for dead in ["status_ready", "button_start", "button_monitor",
                 "button_detect", "button_test"]:
        assert f'name="{dead}"' not in strings_source, (
            f"BUG+051 regression: dead string resource '{dead}' reappeared"
        )


def test_bug_051_marker_present(strings_source):
    assert "BUG+051" in strings_source


# ============================================================================
# BUG+052 — CSS injection via custom action color (server side)
# ============================================================================

def test_server_validates_color_with_hex_regex(server_source):
    """Server must have a hex-color regex constant."""
    assert re.search(
        r"_hexColorRe\s*=\s*RegExp\(r'\^#\[0-9a-fA-F\]\{6\}\$'\)",
        server_source,
    ), "BUG+052 regression: server-side hex color regex removed"


def _find_handler_body(source, handler_name, max_len=2500):
    """Find the body of a Future<Response> handler. source.find returns
    the first occurrence which is usually the router registration
    (`..post('/api/foo', _handler)`), so we search forward to the
    `Future<Response> _handler(` signature."""
    sig = f"Future<Response> {handler_name}"
    idx = source.find(sig)
    if idx < 0:
        return None
    return source[idx:idx + max_len]


def test_server_rejects_non_hex_color(server_source):
    """Server must use hasMatch() on the rawColor before storing."""
    body = _find_handler_body(server_source, "_handleApiCustomActions")
    assert body is not None, "_handleApiCustomActions handler not found"
    assert "_hexColorRe.hasMatch" in body, (
        "BUG+052 regression: server no longer validates color before storing"
    )


def test_server_color_defaults_to_safe_value(server_source):
    """When validation fails, server must fall back to a known-safe hex value."""
    body = _find_handler_body(server_source, "_handleApiCustomActions")
    assert body is not None
    assert "#ff9955" in body, (
        "BUG+052 regression: safe default color removed from server"
    )


def test_bug_052_marker_in_server(server_source):
    assert "BUG+052" in server_source


# ============================================================================
# BUG+052 — defense-in-depth on the client (index.html)
# ============================================================================

def test_client_hex_regex_defined(index_source):
    """Client must have its own hex regex for defense-in-depth."""
    assert re.search(
        r"_HEX_COLOR_RE\s*=\s*/\^#\[0-9a-f\]\{6\}\$/i",
        index_source,
    ), "BUG+052 regression: client-side _HEX_COLOR_RE removed"


def test_client_safe_key_regex_defined(index_source):
    """Key regex ensures only safe [a-z0-9] characters reach the CSS."""
    assert re.search(
        r"_SAFE_KEY_RE\s*=\s*/\^\[a-z0-9\]\+\$/",
        index_source,
    ), "BUG+052 regression: client-side _SAFE_KEY_RE removed"


def test_injectCustomActionCSS_filters_bad_input(index_source):
    """The injection function must skip entries with non-hex color or
    non-safe key (using test() to reject silently)."""
    idx = index_source.find("function injectCustomActionCSS")
    assert idx >= 0
    body = index_source[idx:idx + 1000]
    assert "_HEX_COLOR_RE.test" in body and "_SAFE_KEY_RE.test" in body, (
        "BUG+052 regression: injectCustomActionCSS no longer validates inputs"
    )


def test_bug_052_marker_in_client(index_source):
    assert "BUG+052" in index_source


# ============================================================================
# Logic proof: the fix blocks the specific attack payload from BUGS.md
# ============================================================================

def test_malicious_color_payload_is_rejected_by_hex_regex():
    """The attack payload from the BUG+052 description must fail
    the hex regex we use on both sides."""
    import re as _re
    hex_re = _re.compile(r'^#[0-9a-fA-F]{6}$')
    attack_payloads = [
        "red;} body{display:none;} body{",
        "#ff9955; background-image: url('javascript:alert(1)')",
        "';}@import url('http://evil.example.com/evil.css');/*",
        "#fff",            # too short
        "#fffffff",        # too long
        "ff9955",          # missing #
        "",                # empty
        "#ff995g",         # non-hex char
    ]
    for payload in attack_payloads:
        assert hex_re.match(payload) is None, (
            f"hex regex should reject {payload!r} but accepted it"
        )


def test_hex_regex_accepts_valid_colors():
    """Sanity: real hex colors must pass."""
    import re as _re
    hex_re = _re.compile(r'^#[0-9a-fA-F]{6}$')
    for valid in ["#ff9955", "#000000", "#FFFFFF", "#abcdef", "#012345"]:
        assert hex_re.match(valid), f"hex regex rejected valid color {valid!r}"
