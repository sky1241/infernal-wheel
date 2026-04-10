"""
Regression test for BUG+037 — XSS in notes.html export.

The exportable HTML journal in notes.html line 1407 (now 1425) built the
output by concatenating user-authored note.content directly into innerHTML,
with only `\n → <br>` rewriting. A note containing `<script>alert(1)</script>`
(or any other markup) was embedded verbatim into the exported file. When the
user opened the file in a browser (file:// context), the script executed.

The fix: add an escapeHtml helper (index.html has one; notes.html didn't)
and apply it before the \n → <br> rewrite. This test is a static-grep
over notes.html.
"""
import os
import re

import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NOTES_HTML = os.path.join(
    REPO_ROOT, "infernal-app", "assets", "web", "notes.html"
)


@pytest.fixture(scope="module")
def source():
    with open(NOTES_HTML, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# escapeHtml helper must exist
# ============================================================================

def test_escape_html_helper_defined(source):
    """The helper must exist — BEFORE this fix, notes.html had no escapeHtml."""
    assert re.search(r"function\s+escapeHtml\s*\(", source), (
        "BUG+037 regression: escapeHtml helper missing from notes.html"
    )


def test_escape_html_covers_all_5_chars(source):
    """The helper must escape & < > \" '  — the standard 5 HTML special chars.
    Missing ' is a common oversight."""
    idx = source.find("function escapeHtml")
    assert idx >= 0
    body = source[idx:idx + 500]
    assert "&amp;" in body, "escapeHtml must escape &"
    assert "&lt;" in body, "escapeHtml must escape <"
    assert "&gt;" in body, "escapeHtml must escape >"
    assert "&quot;" in body, "escapeHtml must escape \""
    assert "&#39;" in body or "&apos;" in body, "escapeHtml must escape '"


# ============================================================================
# Export path must use escapeHtml on note.content
# ============================================================================

def test_export_escapes_note_content(source):
    """The journal export must call escapeHtml on note.content BEFORE the
    \\n → <br> replace. The fix pattern is:
        escapeHtml(note.content || "").replace(/\\n/g, "<br>")
    """
    assert re.search(
        r"escapeHtml\s*\(\s*note\.content\s*\|\|\s*[\"']\"[^)]*\)\.replace",
        source,
    ) or re.search(
        # Alternative form with single quotes or different whitespace
        r"escapeHtml\s*\(\s*note\.content",
        source,
    ), "BUG+037 regression: note.content no longer escaped in export"


def test_no_raw_note_content_in_export_html(source):
    """The bad pattern was:
        html += "<div class='notes'>" + (note.content || "").replace(/\\n/g, "<br>")
    i.e. note.content concatenated into HTML with NO escapeHtml wrapping."""
    # Any occurrence of `(note.content || "").replace` without an escapeHtml
    # around it is the buggy pattern.
    bad = re.findall(
        r"\(\s*note\.content\s*\|\|\s*[\"'][\"']\s*\)\s*\.replace\(",
        source,
    )
    # Must be zero — every call should be wrapped in escapeHtml().
    for match_text in bad:
        ctx_idx = source.find(match_text)
        preamble = source[max(0, ctx_idx - 50):ctx_idx]
        assert "escapeHtml" in preamble, (
            f"BUG+037 regression: raw note.content.replace without "
            f"escapeHtml wrapper near: {preamble!r}"
        )


def test_export_also_escapes_day_info(source):
    """Defense-in-depth: date display fields (info.dayName, info.dateDisplay)
    come from formatDateDisplay which reads the dayKey. Should also be
    escaped to protect against any future change in that function."""
    # Look for escapeHtml(info.dayName) or similar in the export
    assert "escapeHtml(info.dayName)" in source or "escapeHtml(info" in source


def test_bug_037_marker_present(source):
    """Self-documenting fix so future contributors know WHY escapeHtml was added."""
    assert "BUG+037" in source
