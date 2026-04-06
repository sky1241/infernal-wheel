# ML Datasets — Smoking & Drinking Gesture Detection

> Sources for retraining the TFLite model with real IMU data from wrist-worn sensors.
> Last updated: 2026-04-06 (ChatGPT Deep Research + Claude Web Search)

## Current Model Status

The TFLite model (`smoking_detector.tflite`, 23KB) was trained on **synthetic data**.
Real-world accuracy: ~12% cigarette, ~24% drinking — needs real data.

**Target:** >70% F1 cigarette, >60% F1 drinking.

---

## TIER 1 — Best Datasets (directly usable)

### Smoking

| Dataset | URL | Sensors | Hz | Subjects | Events | Labels | Format | Access | Paper |
|---------|-----|---------|---:|----------|--------|--------|--------|--------|-------|
| **SED + SED-FL** (Kirmizis 2021) | [Zenodo](https://doi.org/10.5281/zenodo.4507451) + [arXiv](https://arxiv.org/pdf/2109.03475) | Mobvoi TicWatch E: accel 3D + gyro 3D | 50 | 11 (SED) + 7 (SED-FL) | 276 puffs + 39 sessions | **Puff-level + session-level** | IMU signals + annotations | **FREE** (Zenodo) | F1 puff=0.863, session=0.878 |
| **StresSense** (Qadir 2024) | [Mendeley](https://data.mendeley.com/datasets/2dn3hpbm5m/1) | Samsung S5 wrist: accel+gyro+magneto | 50 | 40 | Full cigarette per subject | Activity-level (smoking, eating, nail-biting, face-touching) | CSV | **FREE** (CC BY 4.0) | Data in Brief 2024 |
| **Smoking Activity Dataset** (Shoaib 2016) | [UTwente](https://www.utwente.nl/en/eemcs/ps/research/dataset/) | Smartwatch + smartphone: accel+gyro | 50 | >40h total | Smoking + similar activities | Activity-level | Archive ~2GB | **FREE** | Healthcom 2016 |
| **Tang et al.** (2014) | [GitHub](https://github.com/qutang/tang_pervhealth_14) | Actigraph GT3X wrist accel | 30 | ~6 | Puff annotations | Puff-level | Raw + features | **FREE** | PervasiveHealth 2014 |

### Drinking

| Dataset | URL | Sensors | Hz | Subjects | Events | Labels | Format | Access | Paper |
|---------|-----|---------|---:|----------|--------|--------|--------|--------|-------|
| **FD-I + FD-II** (Wang 2024) | [KU Leuven](https://rdr.kuleuven.be/dataset.xhtml?persistentId=doi:10.48804/CN8VBB) | 2x Shimmer3 IMU (both wrists): accel+gyro | 64 | 61 (513h) | 2722 intake gestures (eat+drink) | **Gesture-level** (eating, drinking, others) | pkl/npy/txt | **FREE** (CC-BY-NC-ND 4.0) | IEEE JBHI 2024 |
| **DrinkingDetectionIJS** (Cergolj 2025) | [GitHub](https://github.com/simon2706/DrinkingDetectionIJS) | Smartwatch: accel+gyro | 50 | 19 (135h) | 2h30 drinking data | Event-level (drinking) | Drive download | **FREE** | F1 offline=89.4%, real-life=81.5% |
| **Clemson Cafeteria** | [Clemson](https://cecas.clemson.edu/~ahoover/cafeteria/) | Wrist accel+gyro + balance | 15 | 276 | Bite + drink gestures | **Gesture-level** (bite, drink, rest, utensiling) | Text files + video | **FREE** | Widely cited |

### Negatives / Hand-to-Mouth Confusion

| Dataset | URL | Sensors | Hz | Subjects | Use |
|---------|-----|---------|---:|----------|-----|
| **Clemson All-Day (CAD)** | [Clemson](https://cecas.clemson.edu/~ahoover/allday/) | Shimmer3 wrist: accel+gyro+magneto | 15 | 351 (354 days) | Massive negatives — "normal day" without smoking labels |
| **OREBA** | [arXiv](https://arxiv.org/abs/2007.15831) | 2x wrist IMU + video | — | 202 | 9069 intake gestures (4496 eating + 406 drinking) |
| **EatingDetectionIJS** | [GitHub](https://github.com/simon2706/EatingDetectionIJS) | Smartwatch: accel+gyro | 100 | 12 (481h) | Eating detection in-the-wild |

---

## TIER 2 — Restricted / Subscription

| Dataset | URL | Access | Subjects | Notes |
|---------|-----|--------|----------|-------|
| **IEEE DataPort Smoking IMU** | [IEEE](https://ieee-dataport.org/documents/smoking-respiration-and-hand-gesture-imu-signals) | IEEE subscription | 40 | 6-axis IMU + RIP, puff labels, CSV |
| **puffMarker (MD2K)** | [md2k.org](https://md2k.org/) | Data Use Agreement | 61 | 470 puffs, gold standard |
| **RisQ (UMass)** | [PDF](https://people.cs.umass.edu/~dganesan/papers/MobiSys14-RisQ.pdf) | Contact authors | ~15 | Smoking wristband |

---

## TIER 3 — General HAR (no smoking, useful for augmentation)

| Dataset | URL | Activities | Subjects | Hz |
|---------|-----|-----------|----------|---:|
| **ExtraSensory (UCSD)** | [Site](http://extrasensory.ucsd.edu/) / [Kaggle](https://www.kaggle.com/datasets/yvaizman/the-extrasensory-dataset) | 51 labels (smoking unverified) | 60 | 25-40 |
| **WISDM (Fordham)** | [Site](https://www.cis.fordham.edu/wisdm/dataset.php) | 18 activities (eating, drinking) | 51 | 20 |
| **Complex Activities (Shoaib 2016)** | [UTwente](https://www.utwente.nl/en/eemcs/ps/research/dataset/) | 13 classes (smoking + drinking coffee) | 10 | 50 |

---

## Synthetic Data Generation

| Tool | URL | Use |
|------|-----|-----|
| **IMUEval** | GitHub (search "IMUEval") | Generative models for synthetic IMU series (LGPL-3.0) |
| **SynHAR** (Uhlenberg 2024) | Paper | Synthetic inertial data from human surface models |
| **UserBoost** (2024) | Paper | Personalized synthetic watch gestures |

---

## State of the Art

| System | Method | F1 Smoking | F1 Drinking | Data Source | Year |
|--------|--------|-----------|-------------|-------------|------|
| SED/SED-FL | CNN (4.5s windows) | **0.863** (puff) / **0.878** (session) | — | Zenodo public | 2021 |
| DrinkingDetectionIJS | ML pipeline | — | **0.894** (offline) / **0.815** (real) | GitHub public | 2025 |
| puffMarker | SVM + RIP + IMU | 0.96 (puff) | — | Restricted | 2015 |
| RisQ | Random Forest | 0.85 | — | Restricted | 2014 |
| OREBA | TCN + attention | — | 0.852 (intake) | Semi-public | 2020 |

**Without RIP sensor:** expected ceiling ~80% F1 smoking, ~70% F1 drinking (IMU only).

---

## Retraining Plan

1. **Download** SED/SED-FL (Zenodo) + StresSense (Mendeley) + DrinkingDetectionIJS (GitHub)
2. **Augment** with Clemson Cafeteria (drink gestures) + Clemson All-Day (negatives)
3. **Extract** our 30 features from raw accel+gyro signals
4. **Train** CNN 1D + GRU (small, quantizable) with LOSO cross-validation
5. **Quantize** to int8 TFLite (<50KB target)
6. **Validate** on SED-FL free-living data (39 real sessions)
7. **Deploy** replace `smoking_detector.tflite` + A/B test vs manual button

---

## Resource Collections

- [Awesome-IMU-Sensing](https://github.com/rh20624/Awesome-IMU-Sensing) — curated datasets + papers
- [Awesome-Human-Activity-Recognition](https://github.com/haoranD/Awesome-Human-Activity-Recognition) — HAR methods + resources
- [Papers With Code — Activity Recognition](https://paperswithcode.com/task/activity-recognition)
