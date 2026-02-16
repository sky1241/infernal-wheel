#!/usr/bin/env python3
"""
LOSO Cross-Validation (Leave-One-Subject-Out)

Gold standard validation for wearable ML:
- Train on N-1 subjects
- Test on 1 held-out subject
- Repeat for all subjects
- Average performance across all folds

Why LOSO:
- Tests generalization across individuals
- Prevents data leakage (K-fold has -13% gap lab→field)
- Realistic field performance estimate

Target:
- Lab: 85-92% F1-score
- Field (LOSO): 80-86% F1-score

References:
- [docs/VALIDATION_TESTING.md]
- HAR Validation 2024: LOSO vs K-fold → -13% gap
"""

import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import f1_score, classification_report, confusion_matrix
import warnings
warnings.filterwarnings('ignore')

# Import feature extraction
from feature_extraction import extract_all_features
from train_baseline import generate_synthetic_gesture


# ============================================================================
# GENERATE MULTI-SUBJECT DATASET
# ============================================================================

def generate_subject_dataset(subject_id: int, n_samples_per_class: int = 5) -> pd.DataFrame:
    """
    Generate dataset for one subject with inter-individual variability.

    Args:
        subject_id: Subject identifier
        n_samples_per_class: Number of samples per gesture class

    Returns:
        DataFrame with features + labels + subject_id
    """
    gestures = ['cigarette', 'eating', 'drinking', 'other']
    dataset = []

    # Add subject-specific variability
    np.random.seed(subject_id * 42)  # Reproducible but different per subject

    # Subject-specific characteristics
    hr_baseline = np.random.uniform(60, 80)  # Resting HR varies by person
    movement_speed = np.random.uniform(0.8, 1.2)  # Some people move faster
    regularity_factor = np.random.uniform(0.9, 1.1)  # Smoking pattern consistency

    for gesture in gestures:
        for i in range(n_samples_per_class):
            # Generate gesture with subject-specific characteristics
            accel_3d, gyro_3d, timestamps, _, hr_current, gps_cluster = \
                generate_synthetic_gesture(gesture, n_samples=1000)

            # Apply subject-specific modulation
            accel_3d *= movement_speed
            gyro_3d *= movement_speed

            # HR with subject baseline
            if gesture == 'cigarette':
                hr_current = hr_baseline + np.random.uniform(7, 15)  # Nicotine effect
            elif gesture == 'drinking':
                hr_current = hr_baseline + np.random.uniform(0, 5)  # Alcohol effect
            else:
                hr_current = hr_baseline

            # Extract features
            features = extract_all_features(
                accel_3d=accel_3d,
                gyro_3d=gyro_3d,
                timestamps=timestamps,
                hr_baseline=hr_baseline,
                hr_current=hr_current,
                gps_cluster=gps_cluster,
                proximity_smoking=0.5 if gesture == 'cigarette' else 0.1
            )

            features['label'] = gesture
            features['subject_id'] = subject_id
            dataset.append(features)

    return pd.DataFrame(dataset)


def generate_multi_subject_dataset(n_subjects: int = 5, n_samples_per_class: int = 5) -> pd.DataFrame:
    """
    Generate dataset with multiple subjects.

    Args:
        n_subjects: Number of subjects
        n_samples_per_class: Samples per class per subject

    Returns:
        Combined DataFrame with all subjects
    """
    print(f"[INFO] Generating multi-subject dataset...")
    print(f"       Subjects: {n_subjects}")
    print(f"       Samples per class per subject: {n_samples_per_class}")
    print()

    all_subjects = []

    for subject_id in range(1, n_subjects + 1):
        print(f"   Generating Subject {subject_id}...")
        subject_df = generate_subject_dataset(subject_id, n_samples_per_class)
        all_subjects.append(subject_df)

    df = pd.concat(all_subjects, ignore_index=True)

    print()
    print(f"[OK] Generated {len(df)} total samples")
    print(f"     Subjects: {df['subject_id'].nunique()}")
    print(f"     Samples per subject: {len(df) // df['subject_id'].nunique()}")
    print(f"     Class distribution:")
    for gesture in ['cigarette', 'eating', 'drinking', 'other']:
        count = len(df[df['label'] == gesture])
        print(f"       {gesture:12s}: {count:3d} samples")

    return df


# ============================================================================
# LOSO CROSS-VALIDATION
# ============================================================================

def loso_cross_validation(df: pd.DataFrame) -> dict:
    """
    Perform Leave-One-Subject-Out cross-validation.

    Args:
        df: DataFrame with features, labels, and subject_id

    Returns:
        Dict with results per subject and overall metrics
    """
    print()
    print("=" * 80)
    print("LOSO CROSS-VALIDATION")
    print("=" * 80)
    print()

    subjects = sorted(df['subject_id'].unique())
    n_subjects = len(subjects)

    print(f"[INFO] Running LOSO with {n_subjects} subjects...")
    print()

    results = []
    all_y_true = []
    all_y_pred = []

    for i, test_subject in enumerate(subjects):
        print(f"[FOLD {i+1}/{n_subjects}] Testing on Subject {test_subject}...")

        # Split train/test
        train_df = df[df['subject_id'] != test_subject]
        test_df = df[df['subject_id'] == test_subject]

        # Prepare features
        X_train = train_df.drop(['label', 'subject_id'], axis=1)
        y_train = train_df['label']
        X_test = test_df.drop(['label', 'subject_id'], axis=1)
        y_test = test_df['label']

        # Train model
        clf = RandomForestClassifier(
            n_estimators=100,
            max_depth=10,
            random_state=42,
            n_jobs=-1
        )
        clf.fit(X_train, y_train)

        # Predict
        y_pred = clf.predict(X_test)

        # Metrics
        f1_macro = f1_score(y_test, y_pred, average='macro')
        f1_weighted = f1_score(y_test, y_pred, average='weighted')

        print(f"   Train samples: {len(X_train)}, Test samples: {len(X_test)}")
        print(f"   F1-score (macro):    {f1_macro:.3f}")
        print(f"   F1-score (weighted): {f1_weighted:.3f}")
        print()

        results.append({
            'subject_id': test_subject,
            'f1_macro': f1_macro,
            'f1_weighted': f1_weighted,
            'n_test_samples': len(X_test)
        })

        all_y_true.extend(y_test)
        all_y_pred.extend(y_pred)

    # Overall metrics
    overall_f1_macro = f1_score(all_y_true, all_y_pred, average='macro')
    overall_f1_weighted = f1_score(all_y_true, all_y_pred, average='weighted')

    print("=" * 80)
    print("LOSO RESULTS SUMMARY")
    print("=" * 80)
    print()

    # Per-subject results
    print("[SUBJECTS] Per-subject F1-scores:")
    for res in results:
        print(f"   Subject {res['subject_id']}: F1 (macro) = {res['f1_macro']:.3f}, "
              f"F1 (weighted) = {res['f1_weighted']:.3f}")

    print()

    # Overall results
    avg_f1_macro = np.mean([r['f1_macro'] for r in results])
    std_f1_macro = np.std([r['f1_macro'] for r in results])

    print(f"[OVERALL] F1-score (macro):    {overall_f1_macro:.3f}")
    print(f"[OVERALL] F1-score (weighted): {overall_f1_weighted:.3f}")
    print(f"[AVERAGE] Mean F1 across subjects: {avg_f1_macro:.3f} (+/- {std_f1_macro:.3f})")
    print()

    # Classification report
    print("[REPORT] Overall Classification Report:")
    print()
    print(classification_report(all_y_true, all_y_pred, digits=3))

    # Confusion matrix
    print("[CONFUSION] Overall Confusion Matrix:")
    print()
    cm = confusion_matrix(all_y_true, all_y_pred, labels=['cigarette', 'eating', 'drinking', 'other'])
    print("              cigarette  eating  drinking  other")
    labels_list = ['cigarette', 'eating', 'drinking', 'other']
    for i, label in enumerate(labels_list):
        print(f"   {label:12s}", end="")
        for j in range(len(labels_list)):
            print(f"   {cm[i, j]:4d}", end="")
        print()
    print()

    # Compare to literature
    print("=" * 80)
    print("COMPARISON TO LITERATURE")
    print("=" * 80)
    print()
    print("[BENCHMARKS] Published results:")
    print("   Lab (controlled):       F1 = 0.850-0.920")
    print("   Field (LOSO):           F1 = 0.800-0.860")
    print("   StopWatch 2019 (SVM):   F1 = 0.780")
    print("   Sense2Quit 2025:        F1 = 0.975 (confounding resilient)")
    print()
    print(f"[THIS STUDY] LOSO F1-score:  {overall_f1_macro:.3f}")
    print()

    if overall_f1_macro >= 0.80:
        print("[OK] Model EXCEEDS field validation target (F1 >= 0.80)!")
    elif overall_f1_macro >= 0.70:
        print("[WARNING] Model below target but acceptable for prototype")
    else:
        print("[WARNING] Model needs improvement (F1 < 0.70)")

    print()

    return {
        'per_subject_results': results,
        'overall_f1_macro': overall_f1_macro,
        'overall_f1_weighted': overall_f1_weighted,
        'avg_f1_macro': avg_f1_macro,
        'std_f1_macro': std_f1_macro,
        'all_y_true': all_y_true,
        'all_y_pred': all_y_pred
    }


# ============================================================================
# MAIN
# ============================================================================

def main():
    print("=" * 80)
    print("LOSO CROSS-VALIDATION - LEAVE-ONE-SUBJECT-OUT")
    print("=" * 80)
    print()

    # Generate multi-subject dataset
    df = generate_multi_subject_dataset(n_subjects=5, n_samples_per_class=5)
    # 5 subjects × 4 classes × 5 samples = 100 total samples

    # Run LOSO
    results = loso_cross_validation(df)

    print()
    print("=" * 80)
    print("[SUCCESS] LOSO VALIDATION COMPLETED!")
    print("=" * 80)
    print()

    print("[SUMMARY] Key Findings:")
    print(f"   - LOSO F1-score: {results['overall_f1_macro']:.3f}")
    print(f"   - Mean F1 across subjects: {results['avg_f1_macro']:.3f} (+/- {results['std_f1_macro']:.3f})")
    print(f"   - Total subjects: {len(results['per_subject_results'])}")
    print()

    print("[INTERPRETATION]")
    print("   LOSO simulates field deployment (new unseen subjects)")
    print("   K-fold would overestimate by ~13% due to data leakage")
    print("   LOSO is gold standard for wearable ML validation")
    print()

    print("[NEXT STEPS]")
    print("   1. Collect real data (WESAD dataset or own collection)")
    print("   2. Retrain with real accelerometer + HR data")
    print("   3. Deploy model to Wear OS (convert to TFLite)")
    print("   4. Field validation with real users (7-14 days)")


if __name__ == "__main__":
    main()
