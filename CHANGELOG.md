# Changelog

All notable changes to the Infernal Wheel / -1+ project are documented here.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

### Added
- **SequenceDetector** (Kotlin + Python port + tests) — replaces the single-
  threshold trigger with a sliding-window peak-counter. A detection now fires
  when at least 3 probabilities > 0.50 appear within a 6-minute window (2 in a
  learned smoking hour). This matches the real-world behavior of smoking
  (5-10 rhythmic puffs) while rejecting isolated hand-to-mouth gestures
  (coffee, food, face scratching).
- **HR confirmation recheck** — 2 minutes after a detection, the service
  queries `HealthServicesManager.getHRRiseOverLast()` and updates the DB
  record with `hr_rise` and `hr_confirmed`. A confirmed rise (≥ 5 bpm above
  the 3-5 min baseline) strongly corroborates the detection.
- **GaussianHourPattern** (Kotlin + Python port + tests) — replaces the
  binary `isHighSmokingHour()` with a continuous score computed as a sum
  of Gaussian kernels (σ = 30 min) centered on each hour's mid-point.
  Handles wrap-around at midnight and is smooth across hour boundaries.
- **`finetune_cnn_v7.py`** — script to fine-tune the base v6 CNN on
  per-user training windows pulled from the phone. Weighted by label:
  `manual_only` (user clicked but CNN missed) gets 3× the weight of a
  routine `auto_detected`.
- **Database schema v6** — added `hr_rise REAL` and `hr_confirmed INTEGER`
  columns to `cigarette_detections`, with a safe ALTER TABLE migration
  path from v5.
- **Python test suites** (all green):
  - `test_sequence_detector.py` (12 tests) — 8 scenarios from real cigarette
    to coffee / meal / random noise / cooldown / sliding window eviction.
  - `test_hr_confirmation.py` (8 tests) — smoker / sedentary / gradual walker
    / coffee / edge cases on HR rise detection.
  - `test_gaussian_pattern.py` (21 tests) — empty / untrained / single peak /
    double peak / symmetric transitions / midnight wrap-around / bounds.

### Changed
- `DetectionService.runInference25Hz()` now routes every CNN probability
  through `SequenceDetector.push()` instead of comparing against a fixed
  threshold. The `isHighSmokingHour` input to the sequence detector comes
  from `GaussianHourPattern.score() > 0.5`, not from the old binary check.
- `DatabaseManager.isHighSmokingHour()` is now a thin wrapper around
  `getGaussianPattern().isHighSmokingMinute()`. Old call sites keep working
  but they benefit from the smoother continuous model under the hood.
- `SequenceDetector.lastTriggerMs` is initialized to `-1L` (sentinel) so the
  very first trigger can't be blocked by a phantom cooldown at startup.

### Fixed
- Phantom cooldown bug where `lastTriggerMs = 0` caused the first 2 minutes
  after service startup to incorrectly report in-cooldown=true (discovered
  via test_sequence_detector.py scenario 5).

---

## [2026-04-10] — Real-world cigarette detected

### Added
- Full Samsung Health Sensor SDK 1.4.1 integration.
- CNN v6 (25Hz / 3-channel accel-only) trained on SED dataset.
- Training window collector: every CNN detection snapshots the ring buffer
  and ships it to the phone for future fine-tuning.
- FIFO cap on training windows (1000 files / ~1 MB on phone).
- `SAMSUNG_PARTNER_PLAN.md` — step-by-step guide to register the app with
  Samsung (free, 2-14 business days).
- `test_training_window_flow.py` — 27 tests validating the watch → phone
  offline buffer + flush-on-reconnect path.
- `test_v6_on_device_parity.py` — 11 tests verifying Python inference
  matches on-device watch output bit-for-bit.

### Fixed
- TFLite version bump 2.14.0 → 2.17.0 (Wear OS Android 16 runtime didn't
  support `FULLY_CONNECTED v12` from models exported with newer TF converter).
- Gradle `flatDir` moved from `app/build.gradle.kts` to `settings.gradle.kts`
  to comply with `FAIL_ON_PROJECT_REPOS`.
- DB schema v5 migration for training_samples + smoking_patterns tables.
- Periodic 50Hz inference path now silently skips when a 25Hz model is
  loaded (previously spammed `predictRaw on non-50Hz model` warnings every
  30 seconds).
- Samsung `SDK_POLICY_ERROR` worked around by enabling Health Platform
  developer mode on the watch; documented the partner-registration path
  for production.

### Verified on device
- 2026-04-10 19:00-19:05 — real cigarette detected at 19:03:58 with 66%
  confidence on Galaxy Watch 7. Logs: `test_logs_2026-04-10_REAL_SMOKE.txt`.
- 2026-04-10 20:18-20:22 — second cigarette produced 4 peaks at 0.60-0.65
  (correctly tracked but below the old 0.7 threshold, motivating the
  SequenceDetector rewrite above).
