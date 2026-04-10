"""
Regression test for BUG+033 — subject leakage in CNN cross-validation.

train_cnn.py and train_cnn_25hz.py both loaded windows from multiple subjects,
concatenated them into X, then used StratifiedKFold(shuffle=True).split(X, y)
which randomly distributed SAME-SUBJECT windows across folds. The CNN memorized
subject-specific wrist posture and the reported CV F1 was overstated.

This test has two parts:
  1. Static-grep: assert both files import GroupKFold (not StratifiedKFold),
     use .split(X, y, groups=subjects), and load_windows returns subjects.
  2. Synthetic proof: construct a dataset with ONE perfect subject-ID leak
     (binary class matches subject ID parity) and show that StratifiedKFold
     gives F1=1.0 while GroupKFold correctly gives F1=0 (or nan). This is
     the ML bug pattern in isolation.
"""
import os
import re

import numpy as np
import pytest

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TRAIN_CNN = os.path.join(REPO_ROOT, "trilateration", "train_cnn.py")
TRAIN_CNN_25HZ = os.path.join(REPO_ROOT, "trilateration", "train_cnn_25hz.py")


@pytest.fixture(scope="module")
def train_cnn_source():
    with open(TRAIN_CNN, encoding="utf-8") as f:
        return f.read()


@pytest.fixture(scope="module")
def train_cnn_25hz_source():
    with open(TRAIN_CNN_25HZ, encoding="utf-8") as f:
        return f.read()


# ============================================================================
# train_cnn.py (v5)
# ============================================================================

def test_train_cnn_imports_group_kfold(train_cnn_source):
    assert "GroupKFold" in train_cnn_source, (
        "BUG+033 regression: train_cnn.py no longer imports GroupKFold"
    )


def test_train_cnn_does_not_use_stratified_kfold_for_splits(train_cnn_source):
    """StratifiedKFold can still be imported elsewhere, but the .split() call
    for the CV loop must use GroupKFold."""
    # Find every .split(...) call and check it uses groups=
    split_calls = re.findall(r"\.split\s*\(([^)]*)\)", train_cnn_source)
    cv_splits = [s for s in split_calls if "X" in s and "y" in s]
    assert cv_splits, "no CV split call found in train_cnn.py"
    for s in cv_splits:
        assert "groups=" in s, (
            f"BUG+033 regression: CV split without groups= → {s!r}"
        )


def test_train_cnn_load_windows_returns_subjects(train_cnn_source):
    """load_windows must return (X, y, subjects) not (X, y)."""
    assert re.search(
        r"def\s+load_windows\s*\(\s*\).*?return\s+X\s*,\s*y\s*,\s*subjects",
        train_cnn_source,
        re.DOTALL,
    ), "BUG+033 regression: train_cnn.py load_windows no longer returns subjects"


# ============================================================================
# train_cnn_25hz.py (v6)
# ============================================================================

def test_train_cnn_25hz_imports_group_kfold(train_cnn_25hz_source):
    assert "GroupKFold" in train_cnn_25hz_source


def test_train_cnn_25hz_uses_groups_in_split(train_cnn_25hz_source):
    split_calls = re.findall(r"\.split\s*\(([^)]*)\)", train_cnn_25hz_source)
    cv_splits = [s for s in split_calls if "X" in s and "y" in s]
    assert cv_splits
    for s in cv_splits:
        assert "groups=" in s, f"CV split without groups= → {s!r}"


def test_train_cnn_25hz_load_windows_returns_subjects(train_cnn_25hz_source):
    assert re.search(
        r"def\s+load_windows\s*\(\s*\).*?return\s+X\s*,\s*y\s*,\s*subjects",
        train_cnn_25hz_source,
        re.DOTALL,
    )


# ============================================================================
# Synthetic proof: the bug pattern produces measurably different results
# ============================================================================

def test_stratified_kfold_leaks_on_subject_correlated_labels():
    """Construct a dataset where the label is perfectly determined by
    the subject id. StratifiedKFold will randomly mix subjects across
    folds so the model can memorize the mapping and score F1≈1.0.
    GroupKFold will isolate subjects → the "test" subject has zero training
    examples with its label (class 0 or class 1 all in train) → F1 drops.

    This test doesn't train a model — it just counts the leakage directly
    by checking if the same subject appears in both train and test folds
    for each splitter.
    """
    from sklearn.model_selection import StratifiedKFold, GroupKFold

    # 10 subjects, 20 windows each. Label = subject_id % 2.
    n_subjects = 10
    windows_per_subject = 20
    subjects = np.repeat(np.arange(n_subjects), windows_per_subject)
    y = subjects % 2
    X = np.random.randn(len(y), 3)  # irrelevant features

    # StratifiedKFold — count cross-fold subject leakage.
    skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
    leaked_subjects_skf = 0
    for train_idx, test_idx in skf.split(X, y):
        train_subs = set(subjects[train_idx])
        test_subs = set(subjects[test_idx])
        leaked_subjects_skf += len(train_subs & test_subs)
    assert leaked_subjects_skf > 0, (
        "StratifiedKFold is supposed to leak subjects in this setup — "
        "if this assert fails the test itself is broken"
    )

    # GroupKFold — must have zero leakage by construction.
    gkf = GroupKFold(n_splits=5)
    leaked_subjects_gkf = 0
    for train_idx, test_idx in gkf.split(X, y, groups=subjects):
        train_subs = set(subjects[train_idx])
        test_subs = set(subjects[test_idx])
        leaked_subjects_gkf += len(train_subs & test_subs)
    assert leaked_subjects_gkf == 0, (
        f"GroupKFold must not leak subjects, got {leaked_subjects_gkf}"
    )


def test_group_kfold_isolates_subjects_per_fold():
    """Every subject must appear in exactly one test fold under GroupKFold."""
    from sklearn.model_selection import GroupKFold

    n_subjects = 12
    subjects = np.repeat(np.arange(n_subjects), 10)
    y = np.random.randint(0, 2, size=len(subjects))
    X = np.random.randn(len(y), 3)

    gkf = GroupKFold(n_splits=4)
    subject_fold = {}
    for fold_idx, (_, test_idx) in enumerate(gkf.split(X, y, groups=subjects)):
        for s in set(subjects[test_idx]):
            assert s not in subject_fold, (
                f"subject {s} appears in both fold {subject_fold[s]} and {fold_idx}"
            )
            subject_fold[s] = fold_idx

    # Every subject assigned exactly once
    assert set(subject_fold.keys()) == set(range(n_subjects))
