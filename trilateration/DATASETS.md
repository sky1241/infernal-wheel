# ML Datasets — Smoking & Drinking Gesture Detection

> Sources for retraining the TFLite model with real IMU data from wrist-worn sensors.
> Last updated: 2026-04-06

## Current Model Status

The TFLite model (`smoking_detector.tflite`, 23KB) was trained on **synthetic data** generated
by `train_baseline.py`. Real-world detection accuracy is ~12% (cigarette) and ~24% (drinking)
— far below the 70% threshold needed for auto-detection.

**Goal:** Retrain with real wrist IMU data to achieve >70% detection accuracy.

## Confirmed Datasets

### 1. Tang et al. — Puffing Detection (FREE, GitHub)
- **URL:** https://github.com/qutang/tang_pervhealth_14
- **Paper:** "Automated Detection of Puffing and Smoking with Wrist Accelerometers" (PervasiveHealth 2014)
- **Sensors:** Actigraph GT3X wrist accelerometer (3-axis, ±4g, 10-bit)
- **Sampling rate:** ~30 Hz
- **Subjects:** ~6
- **Labels:** Puff-level annotations
- **Format:** Raw sensor data + annotation files + feature sets
- **Access:** FREE — direct GitHub download
- **Quality:** Good for puff detection baseline, small subject pool

### 2. IEEE DataPort — Smoking IMU Signals (SUBSCRIPTION)
- **URL:** https://ieee-dataport.org/documents/smoking-respiration-and-hand-gesture-imu-signals
- **Paper:** Senyurek, Imtiaz, Sazonov et al. — CNN-LSTM smoking recognition
- **Sensors:** Wrist IMU (accel XYZ + gyro XYZ) + RIP respiration
- **Sampling rate:** Not specified (likely 25-50 Hz)
- **Subjects:** 40
- **Labels:** Puffing labels (1 = puffing) in CSV
- **Format:** CSV (timestamp, air volume, accel XYZ, gyro XYZ, puff label)
- **Access:** IEEE DataPort subscription required
- **Quality:** EXCELLENT — 40 subjects, 6-axis IMU, puff labels, CSV format

### 3. ExtraSensory — UCSD (FREE)
- **URL:** http://extrasensory.ucsd.edu/
- **Kaggle mirror:** https://www.kaggle.com/datasets/yvaizman/the-extrasensory-dataset
- **Paper:** Vaizman et al. "Recognizing Detailed Human Context" (IEEE Pervasive Computing, 2017)
- **Sensors:** Phone accel + gyro + watch accelerometer + audio + location
- **Sampling rate:** 25-40 Hz
- **Subjects:** 60
- **Labels:** 51 activity labels (smoking and drinking labels need verification)
- **Format:** Per-user feature files
- **Access:** FREE — direct download, cite paper
- **Quality:** Large scale, real-world, but labels may be activity-level not puff-level

### 4. WISDM — Fordham (FREE)
- **URL:** https://www.cis.fordham.edu/wisdm/dataset.php
- **Paper:** Weiss et al. — smartphone and smartwatch activity recognition
- **Sensors:** Phone + watch accelerometer + gyroscope
- **Sampling rate:** 20 Hz
- **Subjects:** 51
- **Labels:** 18 activities (includes eating, drinking — NOT smoking)
- **Format:** CSV
- **Access:** FREE — direct download
- **Quality:** Good for drinking gesture baseline, no smoking class

### 5. puffMarker — MD2K Memphis (RESTRICTED)
- **URL:** https://md2k.org/
- **Paper:** Saleheen et al. "puffMarker" (UbiComp 2015)
- **Sensors:** Wrist accel + gyro (6-axis) + RIP
- **Sampling rate:** 16-64 Hz
- **Subjects:** 61
- **Events:** 470 annotated puffs in 32 smoking episodes
- **Format:** CSV
- **Access:** Data Use Agreement required
- **Quality:** GOLD STANDARD for puff detection, largest annotated puff dataset

### 6. RisQ — UMass Amherst (UNCERTAIN)
- **URL:** https://people.cs.umass.edu/~dganesan/papers/MobiSys14-RisQ.pdf
- **Paper:** Parate et al. "RisQ" (MobiSys 2014)
- **Sensors:** Wrist-worn IMU (accel + gyro)
- **Sampling rate:** 25-50 Hz
- **Subjects:** ~15+
- **Labels:** Smoking gesture recognition
- **Access:** Contact authors — dataset availability uncertain
- **Quality:** Focused on smoking, good methodology

## Resource Collections

- **Awesome-IMU-Sensing:** https://github.com/rh20624/Awesome-IMU-Sensing
  - Curated collection of datasets, papers, and resources for HAR + IMU sensing
- **Awesome-Human-Activity-Recognition:** https://github.com/haoranD/Awesome-Human-Activity-Recognition
  - IMU-based HAR papers, methods & resources

## Priority for Retraining

| Priority | Dataset | Why |
|----------|---------|-----|
| 1 | Tang et al. (GitHub) | Free, immediate, puff-level labels |
| 2 | ExtraSensory (UCSD/Kaggle) | Free, 60 subjects, watch data |
| 3 | IEEE DataPort Smoking IMU | Best quality, 40 subjects, 6-axis, needs subscription |
| 4 | WISDM | Free, 51 subjects, drinking gestures |
| 5 | puffMarker (MD2K) | Gold standard but restricted access |

## Retraining Plan

1. Download Tang et al. + ExtraSensory + WISDM (all free)
2. Extract our 30 features from raw accel + gyro data
3. Label: cigarette puffs, drinking gestures, eating, other
4. Train new model with real data (Random Forest → CNN → quantize to TFLite)
5. Target: >70% F1 for cigarette, >60% F1 for drinking
6. Replace `smoking_detector.tflite` (23KB) with retrained model
7. A/B test with manual +1 button as ground truth

## State of the Art (from literature)

| Paper | Method | F1 Smoking | F1 Drinking | Year |
|-------|--------|-----------|-------------|------|
| puffMarker | SVM + RIP + IMU | 96% (puff) | — | 2015 |
| RisQ | Random Forest + IMU | 85% (gesture) | — | 2014 |
| Senyurek et al. | CNN-LSTM + IMU | 90%+ (puff) | — | 2019 |
| Tang et al. | Random Forest + accel | 70-80% | — | 2014 |

Note: Most papers use RIP (respiration) + IMU. Our watch has IMU only (no RIP).
Expected ceiling without RIP: ~80% F1 for smoking, ~70% for drinking.
