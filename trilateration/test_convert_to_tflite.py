"""
Regression tests for convert_to_tflite.py — BUG+013/014/015 fixes.

  BUG+013: pickle.load() RCE vector. Fix: documented as trusted-internal-only,
           added isinstance() type check on the deserialized object so a
           swapped/corrupted .pkl is rejected before doing damage.
  BUG+014: distill_knowledge() trained the student NN on np.random.randn(1000, 30).
           sklearn RF.predict_proba on Gaussian noise returns near-uniform
           distributions, so the student learned ~uniform output everywhere.
           Root cause of v3/v4 broken TFLite models. Fix: distill_knowledge
           now requires real X_train as a parameter and raises ValueError if
           missing/empty/wrong-shape.
  BUG+015: load_model() called open() without a file-exists check, producing
           an opaque FileNotFoundError mid-pipeline. Fix: explicit os.path.isfile
           with a clear error message.
"""
import os
import sys

import numpy as np
import pytest

# Make trilateration importable when run from repo root
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


# ============================================================================
# BUG+015 — file existence check
# ============================================================================

def test_load_model_raises_clear_error_on_missing_file(tmp_path):
    """Old code: open() raised FileNotFoundError with no context.
    New code: explicit FileNotFoundError naming the file + remediation."""
    from convert_to_tflite import load_model

    missing = str(tmp_path / "does_not_exist.pkl")
    with pytest.raises(FileNotFoundError) as exc_info:
        load_model(missing)
    # The error message must mention the path so the user can fix it
    assert "does_not_exist.pkl" in str(exc_info.value)


# ============================================================================
# BUG+013 — type guard against pickle returning the wrong object
# ============================================================================

def test_load_model_rejects_non_random_forest_pickle(tmp_path):
    """If someone swaps the .pkl with arbitrary pickled data, load_model
    must refuse it instead of silently accepting whatever pickle returns."""
    import pickle
    from convert_to_tflite import load_model

    bad_path = tmp_path / "fake_model.pkl"
    with open(bad_path, 'wb') as f:
        pickle.dump({"not": "a model"}, f)

    with pytest.raises(TypeError) as exc_info:
        load_model(str(bad_path))
    assert "RandomForestClassifier" in str(exc_info.value)


# ============================================================================
# BUG+014 — distillation rejects synthetic / missing data
# ============================================================================

class _FakeRF:
    """Minimal stub mimicking sklearn RandomForestClassifier."""
    def __init__(self, n_features=30):
        self.n_features_in_ = n_features

    def predict_proba(self, X):
        n = len(X)
        return np.full((n, 4), 0.25, dtype=np.float32)


def test_distill_knowledge_rejects_none():
    pytest.importorskip("tensorflow")
    from convert_to_tflite import distill_knowledge

    rf = _FakeRF()
    with pytest.raises(ValueError) as exc_info:
        distill_knowledge(rf, tf_model=None, X_real=None)
    assert "X_real is required" in str(exc_info.value)
    assert "BUG+014" in str(exc_info.value)


def test_distill_knowledge_rejects_empty_array():
    pytest.importorskip("tensorflow")
    from convert_to_tflite import distill_knowledge

    rf = _FakeRF()
    with pytest.raises(ValueError):
        distill_knowledge(rf, tf_model=None, X_real=np.empty((0, 30), dtype=np.float32))


def test_distill_knowledge_rejects_wrong_feature_count():
    """Mismatched feature pipeline must abort, not silently distill on wrong shapes."""
    pytest.importorskip("tensorflow")
    from convert_to_tflite import distill_knowledge

    rf = _FakeRF(n_features=30)
    wrong_shape = np.random.randn(100, 17).astype(np.float32)
    with pytest.raises(ValueError) as exc_info:
        distill_knowledge(rf, tf_model=None, X_real=wrong_shape)
    assert "30" in str(exc_info.value) and "17" in str(exc_info.value)


# ============================================================================
# Smoke test — full pipeline still works with REAL data shape
# ============================================================================

def test_distill_signature_accepts_valid_real_data():
    """Type/shape validation must pass for a properly-shaped real array.
    We can't actually train without TF compile, so just verify the guards
    don't fire on valid input by patching tf_model.compile/fit."""
    pytest.importorskip("tensorflow")
    from convert_to_tflite import distill_knowledge

    rf = _FakeRF(n_features=30)
    X_real = np.random.randn(50, 30).astype(np.float32)

    # Stub tf_model that records calls
    class _StubTF:
        def compile(self, **kw): pass
        def fit(self, X, y, **kw):
            class _H:
                history = {'accuracy': [0.42]}
            return _H()

    result = distill_knowledge(rf, tf_model=_StubTF(), X_real=X_real)
    assert result is not None
