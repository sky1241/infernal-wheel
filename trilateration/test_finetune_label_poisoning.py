"""
Regression test for finetune_cnn_v7.py BUG+036 — label poisoning.

The fine-tune script mapped every non-'false_positive' label to the
cigarette-positive soft target [0.90, 0.03, 0.03, 0.04]. This meant:

  - corrupt JSON with missing 'label' field → "unknown" → cigarette
  - new label category not added to the mapping → cigarette
  - typo in a label (e.g. 'auto_detected ' with trailing space) → cigarette

On a 20-50 window personal dataset, one bad file is 2-5% of the gradient.

The fix uses an explicit LABEL_TO_TARGET dict + drops unknown labels with a
warning. This test is a static-grep over finetune_cnn_v7.py plus a small
logic test of the label-to-target mapping extracted from the script.
"""
import os
import re

import numpy as np
import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FINETUNE = os.path.join(REPO_ROOT, "trilateration", "finetune_cnn_v7.py")


@pytest.fixture(scope="module")
def source():
    with open(FINETUNE, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# Static-grep: the explicit allow-list pattern must be in place
# ============================================================================

def test_label_to_target_dict_exists(source):
    """The fix introduces a LABEL_TO_TARGET dict with explicit entries."""
    assert "LABEL_TO_TARGET" in source, (
        "BUG+036 regression: LABEL_TO_TARGET dict removed"
    )


def test_label_to_target_has_all_4_known_labels(source):
    """Every documented label must have a target."""
    for known in [
        "auto_detected",
        "auto_confirmed_by_manual",
        "manual_only",
        "false_positive",
    ]:
        assert f'"{known}"' in source, f"known label {known} missing from LABEL_TO_TARGET"


def test_no_default_to_cigarette_pattern(source):
    """The bad pattern was `if lbl == 'false_positive': ... else: cigarette`.
    Look for any `else:` followed within ~100 chars by the cigarette target."""
    # The cigarette target numbers [0.90, 0.03, 0.03, 0.04]
    # Search for a direct assignment inside an `else:` block.
    bad_pattern = re.search(
        r"else\s*:\s*y_cat\[i\]\s*=\s*\[\s*0\.9(?:0)?\s*,\s*0\.03",
        source,
    )
    assert bad_pattern is None, (
        "BUG+036 regression: else-branch still assigns cigarette target directly"
    )


def test_unknown_labels_are_dropped(source):
    """The fix must drop unknown labels, not silently label them."""
    assert "DROPPING" in source or "Dropped" in source
    assert "unknown_count" in source


def test_bug_036_marker_present(source):
    assert "BUG+036" in source, "BUG+036 fix marker missing"


def test_uses_dict_get_not_else(source):
    """The fix uses .get(lbl) to look up the target — not a branch on
    a single special case."""
    assert "LABEL_TO_TARGET.get(lbl)" in source


# ============================================================================
# Logic test: replicate the fixed algorithm in Python and prove it
# drops unknown labels instead of treating them as cigarette.
# ============================================================================

class _MockLabelMapper:
    """Standalone port of the fixed label-to-target logic from finetune_cnn_v7.py."""

    CIGARETTE_TARGET = np.array([0.90, 0.03, 0.03, 0.04], dtype=np.float32)
    OTHER_TARGET = np.array([0.05, 0.15, 0.10, 0.70], dtype=np.float32)
    LABEL_TO_TARGET = {
        "auto_detected": CIGARETTE_TARGET,
        "auto_confirmed_by_manual": CIGARETTE_TARGET,
        "manual_only": CIGARETTE_TARGET,
        "false_positive": OTHER_TARGET,
    }

    @classmethod
    def map_labels(cls, labels):
        """Returns (y_cat, keep_mask)."""
        y_cat = np.zeros((len(labels), 4), dtype=np.float32)
        keep_mask = np.ones(len(labels), dtype=bool)
        for i, lbl in enumerate(labels):
            target = cls.LABEL_TO_TARGET.get(lbl)
            if target is None:
                keep_mask[i] = False
                continue
            y_cat[i] = target
        return y_cat, keep_mask


def test_unknown_label_is_dropped_not_labeled_cigarette():
    """Direct proof of the fix: feed a mix of good + unknown labels,
    confirm the unknown ones are DROPPED (keep_mask False) and NOT given
    the cigarette target."""
    labels = [
        "auto_detected",        # cigarette
        "unknown",              # corrupt — must be dropped
        "manual_only",          # cigarette
        "",                     # empty — must be dropped
        "false_positive",       # other
        "new_category_foo",     # future label — must be dropped
        "auto_confirmed_by_manual",  # cigarette
    ]
    y_cat, keep_mask = _MockLabelMapper.map_labels(labels)

    # Exactly the 4 known-good labels survive
    assert keep_mask.sum() == 4
    assert keep_mask.tolist() == [True, False, True, False, True, False, True]

    # The dropped rows must still be zero (no accidental cigarette target)
    assert np.all(y_cat[1] == 0)
    assert np.all(y_cat[3] == 0)
    assert np.all(y_cat[5] == 0)

    # The surviving rows have correct targets
    assert y_cat[0, 0] == 0.90  # cigarette
    assert y_cat[2, 0] == 0.90  # cigarette
    assert y_cat[4, 3] == 0.70  # false_positive → other
    assert y_cat[6, 0] == 0.90  # cigarette


def test_old_buggy_behavior_shows_label_poisoning_baseline():
    """Reproduce the PRE-fix behavior in isolation to prove the bug
    actually existed: one 'unknown' label silently becomes cigarette."""
    def buggy_map(labels):
        y_cat = np.zeros((len(labels), 4), dtype=np.float32)
        CIGARETTE = [0.90, 0.03, 0.03, 0.04]
        OTHER = [0.05, 0.15, 0.10, 0.70]
        for i, lbl in enumerate(labels):
            if lbl == "false_positive":
                y_cat[i] = OTHER
            else:
                y_cat[i] = CIGARETTE
        return y_cat

    labels = ["unknown", "false_positive", "", "typo_label"]
    y_cat = buggy_map(labels)

    # The bug: 3 of 4 labels get the cigarette target
    cigarette_count = sum(1 for i in range(len(labels)) if y_cat[i, 0] == 0.90)
    assert cigarette_count == 3, (
        "buggy baseline should label 3/4 unknown inputs as cigarette"
    )
