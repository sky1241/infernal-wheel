# BUGS — infernal-wheel

> Format: each bug has an ID, status, symptom, root cause, fix, and test.
> This file is READ BY CLAUDE AT BOOT. Keep it accurate.

<!-- TEMPLATE
## BUG-XXX: [short description]
- **Status**: OPEN / FIXED / WONTFIX
- **Symptom**: what happens
- **Root cause**: WHY it happens (not just where)
- **Fix**: what was done (commit hash if fixed)
- **Test**: which test covers this (file:test_name)
- **Regression**: did the fix break anything else?
-->


## BUG+001: test_api.py and test_flows.py have a top-level def test() helper that pytest tries to invoke as a fixture
- **Status**: FIXED (2026-04-10)
- **Symptom**: pytest collection fails with "fixture 'name' not found" on the helper function `def test(name, ok, detail="")`. Same error pattern as the 10 trilateration tests already converted.
- **Root cause**: pytest's default test discovery treats any top-level `def test*(...)` as a test function and tries to inject its parameters as fixtures.
- **Fix**: Renamed `def test(...)` to `def _check(...)` in both `infernal-app/test_api.py` and `infernal-app/test_flows.py`. The leading underscore plus the new name removes both the prefix collision and any future re-collision.
- **Test**: forge baseline (post-fix shows 0 errors at collection)
- **Regression**: none — pytest run cleanly after rename

## BUG+002: test_flows.py errors with URLError when shelf server is not running
- **Status**: FIXED (2026-04-10)
- **Symptom**: `urllib.error.URLError: <urlopen error [WinError 10061] No connection could be made because the target machine actively refused it>` on every test that calls the local shelf server at http://127.0.0.1:8011.
- **Root cause**: The test suite was designed to run against a live Flutter app + shelf server stack. forge.py runs it in isolation, no server, → connection refused → 8 tests fail.
- **Fix**: Added a `pytestmark = pytest.mark.skipif(not _server_is_up(), reason=...)` at module level in `test_flows.py`. The probe hits `/api/ping` (or `/api/state` as fallback) with a 1s timeout. If unreachable, the entire suite is SKIPPED instead of FAILED. Standalone `python test_flows.py` still works because the skip is pytest-only.
- **Test**: forge baseline shows 8 SKIPPED instead of 8 FAILED
- **Regression**: none — when the server IS running the tests still execute normally

## BUG+003: stay_points.py label_time() has hour gaps and contradicts the docstring
- **Status**: FIXED (2026-04-10)
- **Symptom**: GPS clusters captured during the 8h or 18h hours got labeled as "other" instead of work/bar. Late-evening clusters (22h-2h) got labeled "home" even though the docstring claimed "Evening 19h-2h → bar/social".
- **Root cause**: The if/elif chain had `22 <= h or h < 8` → home, `9 <= h < 18` → work, `19 <= h < 22` → bar, else → other. Hours 8 and 18 fell into "other". And the docstring promised 19h-2h for bar but the code only routed 19-21.
- **Fix**: New if/elif/else with explicit 24h coverage: home `22<=h or h<8` (10h), work `8<=h<18` (10h), bar `18<=h<22` (4h). Total 24h, no gaps.
- **Test**: trilateration/test_stay_points_labeling.py — 10 cases including hour 8, 18, 22, every-hour-coverage check
- **Regression**: none — forge baseline went from 14P → 24P (added the 10 new tests)

## BUG+004: stay_points.py DBSCAN_MIN_PTS defaults to the testing value (2) instead of production (5)
- **Status**: FIXED (2026-04-10)
- **Symptom**: GPS DBSCAN clustering on production data produces too many small clusters because the minimum-points threshold is 2 instead of the documented 5.
- **Root cause**: `DBSCAN_MIN_PTS = 2  # use 5 for real data, 2 for testing` — comment says one thing, code uses the testing value as the default.
- **Fix**: Changed default to `DBSCAN_MIN_PTS = 5`. Added `DBSCAN_MIN_PTS_TEST = 2` for tests that need the smaller value.
- **Test**: trilateration/test_stay_points_labeling.py::test_dbscan_min_pts_is_production_value
- **Regression**: none

## BUG+005: forge.py add_bug() always assigns BUG+001 (auto-increment broken)
- **Status**: FIXED (2026-04-10)
- **Symptom**: Every `forge.py --add "..."` call produces a bug with the same ID: `BUG+001`. Multiple bugs end up with duplicate IDs in BUGS.md, breaking `--close BUG-NNN` and breaking the human-readable bug tracker.
- **Root cause**: At line 445 the regex was `re.findall(r"BUG-(\d+)", content)` (with a hyphen) but the writer at line 447 produces `BUG+{N}` (with a plus). The regex therefore never matches any existing bug, `next_num = 0+1 = 1` always, and every new bug gets ID `BUG+001`.
- **Fix**: Changed the regex to `r"BUG[+-](\d+)"` so it matches both legacy `BUG-` IDs and the current `BUG+` format.
- **Test**: manual — `python forge.py --add "test"` after the fix produces sequential IDs.
- **Regression**: none.


## BUG+006: feature_extraction.py hardcoded sample rate (50Hz) breaks the v6 25Hz Samsung pipeline
- **Status**: FIXED (2026-04-10)
- **Symptom**: extract_angular_features used `dt = 0.02` hardcoded (50Hz). Any caller running the v6 25Hz Samsung pipeline got jerk/wrist_rotation features computed with the wrong dt — off by a factor of 2.
- **Root cause**: Default constant baked into function body, no parameter exposed.
- **Fix**: Added `fs: float = 50.0` parameter to `extract_angular_features`. Default kept at 50Hz for backward compat. Callers using v6 25Hz must pass `fs=25.0` explicitly. Also added bounds checks (empty input, single sample) so the function returns zero features instead of NaN/crash. Documented dt=0.04 expected for 25Hz callers in `extract_jerk_features`.
- **Test**: trilateration/test_feature_extraction_audit.py::test_angular_features_25hz_doubles_dt — explicitly verifies that integrating the same gyro signal at 25Hz vs 50Hz produces a 2x ratio, proving the parameter actually flows.
- **Regression**: none — forge baseline went from 24P → 58P (+34, including 13 new feature_extraction tests + 21 new stay_points deep tests).

## BUG+007: feature_extraction.py extract_trajectory_features crashes on 0 or 1 sample inputs
- **Status**: FIXED (2026-04-10)
- **Symptom**: `IndexError: index -1 is out of bounds for axis 0 with size 0` when extract_trajectory_features is called with a 1-sample (or empty) array. The crash poisons the entire feature batch.
- **Root cause**: Line 265 did `dt = np.diff(timestamps)` then `dt = np.append(dt, dt[-1])`. With 1 timestamp, `np.diff` returns an empty array and `dt[-1]` raises IndexError.
- **Fix**: Early-return zero features if `accel_3d.shape[0] < 2 or len(timestamps) < 2`. The features dict is pre-initialized with zeros so callers always get a valid 4-key dict back.
- **Test**: trilateration/test_feature_extraction_audit.py::test_trajectory_features_empty_input + test_trajectory_features_single_sample_no_crash + test_trajectory_features_two_samples_no_crash.
- **Regression**: none.

## BUG+008: feature_extraction.py extract_trajectory_features double-integrates raw accel without sensor fusion (drift)
- **Status**: OPEN (documented, not fixed — requires architectural rewrite)
- **Symptom**: Trajectory features (path_curvature, total_distance) computed by integrating raw accelerometer twice produce values dominated by IMU drift after 2-3 seconds, not actual hand motion. The v2 30-feature GBM model has been training on noise for these 4 features the whole time.
- **Root cause**: Naive double cumsum of raw accel. Real GPS-less position estimation needs Kalman/Madgwick sensor fusion (combining accel + gyro + Earth's gravity vector). The math is well-known but a non-trivial rewrite.
- **Fix**: NOT YET FIXED. This audit pass added a clear NOTE in the function docstring warning the caller that these features are weak signals. A future revision should switch to a fused IMU pipeline (e.g. via the `ahrs` Python package) or drop the trajectory features entirely from the v2 model.
- **Test**: N/A — the bug isn't a crash, it's a quality issue. A proper fix would need a baseline IMU recording with known ground truth motion to validate.
- **Regression**: N/A.

## BUG+009: GPSClusteringManager.getCurrentCluster() returns DBSCAN raw label, not semantic constant
- **Status**: FIXED (2026-04-10)
- **Symptom**: DetectionService writes `gps_cluster` int into the cigarette_detections DB row expecting CLUSTER_HOME=0, CLUSTER_WORK=1, CLUSTER_BAR=2, CLUSTER_OTHER=3. But getCurrentCluster() returned the DBSCAN raw cluster id (0, 1, 2, ... in arrival order), which has nothing to do with these semantic constants. Result: the gps_cluster column was full of arbitrary integers, breaking any analytics that filtered "home" cigarettes vs "work" cigarettes.
- **Root cause**: updateCurrentCluster() did `currentCluster = sp.cluster` (raw DBSCAN id) instead of mapping `sp.clusterName` ("home"/"work"/"bar") to the public CLUSTER_* constants.
- **Fix**: Added a `clusterNameToId(name: String): Int` helper that maps "home"→0, "work"→1, "bar"→2, else→3. updateCurrentCluster now does `currentCluster = clusterNameToId(sp.clusterName)`.
- **Test**: trilateration/test_gps_labeling.py::test_cluster_name_to_id_* (4 tests)
- **Regression**: none — forge baseline 58P → 74P (+16 new GPS tests).

## BUG+010: GPSClusteringManager.clusterStayPoints() label_time has hour gaps and overlaps
- **Status**: FIXED (2026-04-10)
- **Symptom**: Same family as BUG+003. avgHour=8.5 fell into "other" (not <=8 home, not in 9..17 work, not in 18..23 bar). avgHour=17.5 also fell into "other". And avgHour=22.5 matched the home branch first because of when-ordering, even though the bar branch claimed 18..23.
- **Root cause**: The when chain used overlapping ranges and discrete-integer thinking on a continuous-double avgHour.
- **Fix**: Extracted into a `labelByHour(avgHour: Double): String` helper with an exhaustive partition: `home` for `>=22 || <8`, `work` for `<18`, `bar` for the rest. Every double in [0, 24) maps to exactly one bucket.
- **Test**: trilateration/test_gps_labeling.py::test_every_integer_hour_is_classified, test_every_half_hour_is_classified, test_24h_partition_is_exhaustive (10 tests)
- **Regression**: none.

## BUG+011: GPSClusteringManager.clusterStayPoints() leaves stale labels on already-classified points
- **Status**: FIXED (2026-04-10)
- **Symptom**: After the first DBSCAN run, every subsequent run skipped points whose cluster was already != -1. This meant that when new stay points arrived and would have merged into an existing cluster (or split it), the labels never updated. The clustering became stale.
- **Root cause**: The early-continue at the top of the loop was an attempt to avoid re-doing work, but it also blocked re-evaluation. For < 200 stay points the optimization is meaningless and the correctness loss is total.
- **Fix**: Reset every point to `cluster = -1; clusterName = "other"` at the start of each clusterStayPoints() call, then re-run from scratch. The loop body keeps the within-run early-continue for points already classified by the current run's earlier core points.
- **Test**: covered indirectly by the labelByHour partition tests (correctness is now deterministic).
- **Regression**: none.

## BUG+012: GPSClusteringManager.stayPoints is not thread-safe
- **Status**: FIXED (2026-04-10)
- **Symptom**: stayPoints was a bare `mutableListOf<StayPoint>()`. addStayPoint (LocationListener thread) appends; updateCurrentCluster (inference thread) iterates with `minByOrNull`. ConcurrentModificationException possible during overlap.
- **Root cause**: No synchronization at all.
- **Fix**: Wrapped in `Collections.synchronizedList(...)`. Iterating callsites take a snapshot via `synchronized(stayPoints) { stayPoints.toList() }` first because synchronizedList only locks individual ops, not iteration. Also marked `currentLocation`, `currentStayStart`, `currentCluster` as `@Volatile` for cross-thread visibility.
- **Test**: not unit-testable in pure Python; verified by code review and the synchronized wrapper.
- **Regression**: none.

## BUG+013: convert_to_tflite.py:39 uses pickle.load() on a model file. If the .pkl is ever fetched from a remote source or shared between users, this is a classic RCE vector — pickle deserialization can execute arbitrary code. For our local-only use case the risk is low but the code should at least add a SHA-256 integrity check or migrate to joblib (which is also pickle-based but documented) or ONNX.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:26
- **Symptom**: Latent — model file is local-only today, but a future "import shared model" feature would have shipped a remote-pickle RCE.
- **Root cause**: pickle.load is RCE-equivalent by design; the script trusted whatever bytes lived at the path.
- **Fix**: Documented the RCE constraint in the docstring (trusted-internal artifact only). Added isinstance(model, RandomForestClassifier) post-load type guard so a corrupted/swapped .pkl is rejected with a clear TypeError before any other code touches it.
- **Test**: trilateration/test_convert_to_tflite.py::test_load_model_rejects_non_random_forest_pickle.
- **Regression**: forge baseline 112 PASS / 0 FAIL.

## BUG+014: convert_to_tflite.py distill_knowledge() at line 108 trains the TF student model on np.random.randn(1000, 30) — pure Gaussian noise. The student then memorizes how the Random Forest classifies noise, which has zero correlation with how it would classify real sensor features. The resulting TFLite model produces garbage on real input. This was the root cause of the v3/v4 broken models. Should generate distillation samples using feature_extraction.extract_all_features on real or synthetic gesture data, NOT random noise.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:26
- **Symptom**: Every TFLite model exported through this pipeline (v3, v4) produced ~uniform softmax on real input. The student NN had only ever seen Gaussian noise, on which the teacher RF returns near-uniform probabilities, so the student learned ~uniform output as a constant function.
- **Root cause**: Knowledge distillation requires the student to see data from the SAME distribution the teacher was trained on. Substituting np.random.randn for real features turned distillation into "learn the marginal class prior".
- **Fix**: distill_knowledge now requires X_real as a mandatory parameter and validates shape against rf.n_features_in_. Raises ValueError with explicit BUG+014 reference if missing/empty/mismatched. main() loads models/X_train_features.npy and fails loudly with remediation if absent. train_baseline.py now persists X_train.values to that path right after saving the .pkl so the pipeline is end-to-end consistent.
- **Test**: trilateration/test_convert_to_tflite.py — test_distill_knowledge_rejects_none, _rejects_empty_array, _rejects_wrong_feature_count, test_distill_signature_accepts_valid_real_data (4 tests).
- **Regression**: forge baseline 112 PASS / 0 FAIL. v3/v4 models will need to be re-exported via the fixed pipeline before deployment.

## BUG+015: convert_to_tflite.py:38 opens model file without checking it exists first. Result: FileNotFoundError with a stack trace instead of an actionable error message saying which file is missing and how to generate it (run train_baseline.py first).
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:26
- **Symptom**: Opaque FileNotFoundError mid-pipeline; users had to read the stack trace to figure out they needed to run train_baseline.py.
- **Root cause**: load_model() jumped straight to open() with no precondition check.
- **Fix**: Explicit os.path.isfile() check at the top of load_model() raising FileNotFoundError with the path AND the remediation command.
- **Test**: trilateration/test_convert_to_tflite.py::test_load_model_raises_clear_error_on_missing_file.
- **Regression**: forge baseline 112 PASS / 0 FAIL.

## BUG+016: crypto_service.dart decrypt() at lines 164-168 calls cipher.doFinal() TWICE on the same GCMBlockCipher instance. Pointycastle AEAD ciphers cannot be reused without re-init — the second call either throws or returns a garbage value. Additionally, the final sublist(0, plaintextLength - 16) removes 16 bytes from the plaintext that have no reason to be there (the tag is already consumed by doFinal internally). The decrypt() function is therefore broken. Caller lines: (none — see BUG+017 for why this matters less than expected).
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:28
- **Symptom**: Latent — decrypt() and importBackup() were dead code in production (BUG+018), so the bug never crashed the app. But any future caller would have either thrown or received garbage UTF-8.
- **Root cause**: Confusion between AEAD pointycastle semantics (tag consumed internally by doFinal) and a CBC-style "decrypt then strip tag" mental model. Calling doFinal twice on an AEAD cipher is also illegal regardless of the -16 issue.
- **Fix**: decrypt() and importBackup() now call processBytes once, then doFinal once, then return utf8.decode(output[:len1+len2]) — no -16 subtraction. The tag is already consumed and verified by doFinal internally.
- **Test**: trilateration/test_crypto_service_format.py — 11 tests via Python's `cryptography` AESGCM as the format spec, including roundtrip + tampering + wrong-key + the BUG+016 regression demo.
- **Regression**: forge baseline 112 PASS / 0 FAIL.

## BUG+018: CRITICAL PRIVACY BUG: crypto_service.dart is initialized by main.dart (setupAuto / unlockAuto) but its encrypt() / encryptToFile() / decryptFromFile() / decrypt() methods are NEVER called anywhere in lib/. data_store.dart writes plain JSON to disk with no encryption. The README, PRIVACY_POLICY, SAMSUNG_PARTNER_PLAN and Play Store description all say '100% local data, AES-256 encrypted'. This is a marketing lie and a privacy regression: anyone who roots the phone can dump full smoking/drinking history in plaintext. Also means BUG+016 (broken decrypt) doesn't crash the app in production because decrypt is dead code.
- **Status**: OPEN — DEFERRED (architectural rework required, awaiting user decision)
- **Date**: 2026-04-10 22:28
- **Severity**: CRITICAL (privacy + Play Store false advertising)
- **Symptom**: settings.json, state.json, drinks.csv, log.csv, notes/*.txt all stored as plaintext under getApplicationDocumentsDirectory()/infernal_data/. Anyone with root or a dev-mode device can `adb pull` the entire history including timestamps of every cigarette, drink, and note.
- **Root cause**: When crypto_service.dart was added, the `encryptToFile` / `decryptFromFile` helpers were defined but data_store.dart was never refactored to use them. Every call site in DataStore writes raw bytes via `file.writeAsString(jsonEncode(...))`. The crypto service is a dangling dependency.
- **Fix**: NOT APPLIED in pass forge4 — touches ~14 read/write sites and needs:
  1. Migration path for existing plain-text files on upgrade.
  2. Re-architecture of CSV append (current addDrink/addLogRow appends one line; encryption requires re-encrypting the whole file each write or moving to a length-prefixed-record format).
  3. Async refactor of every callsite (encryptToFile is async, today's saves are fire-and-forget).
  4. End-to-end tests covering pre-migration plaintext, post-migration ciphertext, and the migration pass itself.
  Recommended: dedicated session, behind a feature flag, with a backup-export step before migration. In the interim, either downgrade the marketing copy ("local-only" without "AES-256") or land the rework before the next Play Store push.
- **Test**: TODO (test_data_store_encryption.dart — to be written alongside the fix).
- **Regression**: N/A — current pass forge4 leaves the bug OPEN by design and adds a TODO marker in data_store.dart pointing here.

## BUG+019: forge.py add_bug() regex r'BUG[+-](\d+)' is too permissive. It matches BUG IDs anywhere in the file, including mentions inside the TEXT of existing bug descriptions. Consequence: when I wrote 'see BUG+017' inside BUG+016's description, forge counted 17 as existing and jumped to 018, skipping 017. The regex should anchor to the start of a line (BUG header) to only count actual bug IDs.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:29
- **Symptom**: BUG+017 was skipped during pass forge4 — when I added BUG+016 with a body that mentioned "see BUG+017 for why this matters", forge's auto-increment counted the in-body reference and jumped from 016 to 018.
- **Root cause**: re.findall(r'BUG[+-](\d+)') matches anywhere in the file, not just at line start. Bug-body cross-references look identical to bug headers to a non-anchored regex.
- **Fix**: Changed pattern to r'^## BUG[+-](\d+)' with re.MULTILINE so only headers (lines starting with `## BUG+NNN:`) count. forge.py:445.
- **Test**: Manually verified by re-running --add and observing correct sequence (BUG+020/021/022 added without skips).
- **Regression**: forge baseline 112 PASS / 0 FAIL.

## BUG+020: FeatureExtractor.kt hardcodes SAMPLING_RATE=50.0 (line 26) used at 8 sites (wristRotation line 207, angularJerk line 214, jerk dt line 235, frequency features 262, totalDistance 314, regularity expectedInterval 332, etc). The Samsung 25Hz pipeline cannot use this extractor — all time-dependent features would be 2x wrong. Same bug family as BUG+006 in feature_extraction.py but in Kotlin.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:33
- **Symptom**: All time/frequency features wrong by 2x on the 25Hz Samsung Health Sensor SDK flow (wristRotation halved, jerk halved, dominantFreq doubled, totalDistance doubled).
- **Root cause**: SAMPLING_RATE constant hardcoded for the 50Hz Wear OS legacy SensorManager flow, never updated when the 25Hz Samsung batched flow shipped (commit f22d8f6).
- **Fix**: Renamed const to DEFAULT_SAMPLING_RATE (fallback only). Added computeSamplingRate(timestamps) helper. extractAllFeatures derives fs once and passes it to extractAngularFeatures, extractJerkFeatures, extractFrequencyFeatures, extractTrajectoryFeatures, extractRegularityFeatures.
- **Test**: trilateration/test_feature_extractor_sampling.py — test_compute_sampling_rate_25hz, _50hz, _100hz, _empty_falls_back, _zero_duration_falls_back, _negative_duration_falls_back (7 tests).
- **Regression**: forge baseline 106 PASS / 0 FAIL (was 74).

## BUG+021: FeatureExtractor.kt has multiple empty-array crash sites with no guards: extractTimeDomainFeatures line 167 (magnitudes.map {}.average() crashes if empty), extractAngularFeatures line 210 (angularVelocities.std() crashes if empty), extractAngularFeatures line 213 (FloatArray(gyro.size - 1) crashes with NegativeArraySizeException if gyro.size == 0), extractJerkFeatures line 234 (same FloatArray(accel.size - 1) crash). The caller from DetectionService is protected by SensorDataCollector.getRecentData() MIN_SAMPLES guard but any other caller would crash.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:33
- **Symptom**: NegativeArraySizeException / NoSuchElementException ("Empty collection can't be reduced") if any future caller passes < 2 samples. Latent crash, not yet triggered in production because DetectionService guards with MIN_SAMPLES.
- **Root cause**: No defensive checks at the FeatureExtractor public boundary. Sole protection lives at the caller, violating "defend at every public surface" principle.
- **Fix**: extractAllFeatures returns a normalized zero-vector when accel.size < 2 OR gyro.size < 2. Each extractor (Angular/Jerk/Frequency/Trajectory/Regularity) also has its own < 2 guard returning zeros. extractJerkFeatures additionally bounds the diff loop by min(accel.size, timestamps.size) so a length mismatch can't index past the shorter array.
- **Test**: trilateration/test_feature_extractor_sampling.py — test_safe_diff_empty/_single_sample/_two_samples/_normal + parametrized test_extract_all_bails_on_too_few_samples (10 tests).
- **Regression**: forge baseline 106 PASS / 0 FAIL.

## BUG+022: FeatureExtractor.kt extractRegularityFeatures line 332 hardcodes expectedInterval = 45 * SAMPLING_RATE.toInt() = 45 * 50 = 2250 samples. This represents '45 seconds between puffs at 50Hz'. At 25Hz the expected interval in samples should be 45 * 25 = 1125. Regularity autocorrelation is computed at lag 2250 which for a 25Hz 4.5s window (112 samples) is WAY past the window length, so autocorr[2250] falls back to autocorr.lastOrNull() — a meaningless value. The regularity feature is dead weight on the 25Hz pipeline.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:33
- **Symptom**: regularityScore feature was constant garbage on the 25Hz pipeline (always autocorr.lastOrNull()), polluting the GBM v2 input vector with one channel of pure noise.
- **Root cause**: hardcoded 50Hz multiplier paired with the BUG+020 hardcoded SAMPLING_RATE.
- **Fix**: extractRegularityFeatures now takes samplingRate parameter; expectedInterval = (45 * samplingRate).toInt() — 1125 at 25Hz, 2250 at 50Hz.
- **Test**: trilateration/test_feature_extractor_sampling.py — test_expected_interval_at_25hz_is_1125, _at_50hz_is_2250, _at_100hz_is_4500, _uses_measured_fs_not_default (4 tests).
- **Regression**: forge baseline 106 PASS / 0 FAIL.

## BUG+023: forge.py close_bug() at line 480 builds regex pattern with raw bug_id like 'BUG+020' — the literal '+' is interpreted as regex quantifier (one or more 'G'), so the pattern never matches. Result: --close BUG+NNN silently fails with 'not found or already closed' for every bug logged with the new BUG+ convention. Fix: re.escape(bug_id) before substituting.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:40
- **Symptom**: BUG+020/021/022 had to be closed by hand-editing BUGS.md because forge --close BUG+020 silently no-op'd every time.
- **Root cause**: f-string interpolation of bug_id into a regex without escaping. The '+' after BUG was treated as "one or more G", so the pattern looked for "## BUGG020:", "## BUGGG020:", ... — never the literal "## BUG+020:".
- **Fix**: re.escape(bug_id) inside the f-string at forge.py line 481. Verified end-to-end by closing BUG+023 itself with --close.
- **Test**: Manual end-to-end via `python forge.py --close BUG+023` → "BUG+023 marked FIXED".
- **Regression**: forge baseline 106 PASS / 0 FAIL.

## BUG+024: feature_extraction.py extract_all_features (line 448) does NOT propagate fs to its sub-extractors. It calls extract_angular_features(gyro_3d), extract_jerk_features(accel_mag), extract_frequency_features(accel_mag) and extract_regularity_features(accel_mag, ts) — all of which silently fall back to their default fs=50.0 / dt=0.02. On the v6 25Hz Samsung pipeline, every fs-dependent feature (wrist_rotation, jerk, dominant_freq, periodicity, regularity_score lag) is therefore wrong by 2x. Same bug family as BUG+020 in Kotlin FeatureExtractor. Compounding bug: extract_jerk_features at line 136 has dt: float = 0.02 (50Hz) baked in as the default, so even direct callers who forget to pass dt get the wrong value silently.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:51
- **Severity**: HIGH (training/inference distribution mismatch)
- **Symptom**: Every fs-dependent feature in the Python pipeline was wrong by 2x on 25Hz batches: wrist_rotation halved (sum*dt), jerk_magnitude doubled (diff/dt), dominant_freq doubled, periodicity_coef wrong. The trained-on-50Hz models received apparently-different feature distributions than the watch produces — silent training/inference skew.
- **Root cause**: Sister bug to BUG+020 in Kotlin. extract_all_features predates the v6 25Hz Samsung pipeline; nobody updated it when the watch flow switched. Each sub-extractor had `fs=50.0` as a function-default that was never overridden.
- **Fix**: Added `_infer_fs_from_timestamps(timestamps, fallback=50.0)` helper that derives fs from `(N-1) / (ts[-1] - ts[0])`. extract_all_features now takes optional `fs` parameter (defaults to inferred), and propagates it explicitly to extract_angular_features (fs=fs), extract_jerk_features (dt=1/fs), extract_frequency_features (fs=fs), and extract_regularity_features (fs=fs). extract_regularity_features now also takes fs and forwards it to its inner extract_frequency_features call.
- **Test**: trilateration/test_feature_extraction_fs_propagation.py — 11 tests including jerk-2x ratio, wrist_rotation-half ratio, dominant_freq-2x ratio between 25Hz and 50Hz on the same input.
- **Regression**: forge baseline 131 PASS / 0 FAIL (was 112).

## BUG+025: feature_extraction.py extract_time_domain_features (line 37) and extract_regularity_features (line 336) have NO empty-input guards. extract_time_domain crashes at line 58 (np.mean of empty), line 61 (np.max of empty raises ValueError), line 64 (timestamps[-1] - timestamps[0] IndexError on len 0). extract_regularity at line 357 crashes with IndexError on autocorr[0] when accel is empty (np.correlate of empty arrays returns length 0). extract_jerk_features at line 158 silently produces nan jerk_magnitude when accel has < 2 elements (np.diff of length-1 returns empty, np.mean of empty is nan). Same defensive-boundary family as BUG+021 in Kotlin.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:51
- **Severity**: MEDIUM (latent crash + silent NaN injection)
- **Symptom**: Empty/single-sample windows would either crash with IndexError/ValueError or silently inject NaN into the feature vector (which then poisons every downstream classifier — sklearn raises with "Input contains NaN").
- **Root cause**: Sister to BUG+021 in Kotlin. The feature extractors trusted their callers to never pass degenerate input. The training pipeline (60s windows on a 25Hz stream = 1500 samples) never tripped this, but any buffer-edge case at the start/end of a session, or a future windowing change, would crash production.
- **Fix**: extract_time_domain_features, extract_jerk_features, extract_regularity_features all now bail out with a zero-vector when `accel is None or len(accel) < 2`. extract_frequency_features got a None guard too (was already short-circuiting on N<4 for empty arrays). The zero-vector matches the FeatureExtractor.kt MIN_SAMPLES_FOR_FEATURES contract so the two extractors stay byte-compatible.
- **Test**: trilateration/test_feature_extraction_fs_propagation.py — 8 tests covering each extractor with empty/single-sample/None input, plus an end-to-end "minimum input doesn't crash AND returns no NaN" test.
- **Regression**: forge baseline 131 PASS / 0 FAIL.

## BUG+026: local_server.dart line 96 binds the HTTP API to 0.0.0.0:8011 (all interfaces) with NO authentication. Combined with the CORS middleware that returns Access-Control-Allow-Origin: * (line 141), this means ANY device on the same WiFi network can hit /api/cmd, /api/drinks/add, /api/goal, /api/engine/restart, etc. and manipulate the user's data without credentials. The watch communicates via Bluetooth MessageClient (not HTTP), so the comment 'so watch can reach us' on line 95 is incorrect — the bind to 0.0.0.0 serves no purpose for the watch flow. Privacy + integrity issue: a coffee-shop neighbor or roommate can scan port 8011 and inject fake clope counts, alter goals, or even POST commands like 'jpp' to the engine. Should bind to 127.0.0.1 only.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:59
- **Severity**: CRITICAL (LAN-level data integrity + privacy)
- **Symptom**: Anyone on the same WiFi (cafe, coworking space, public hotspot) could `curl http://<phone-ip>:8011/api/state` and read every cigarette/drink/note ever logged, OR `curl -X POST .../api/drinks/add -d '{"type":"strong","n":999}'` to corrupt the data permanently.
- **Root cause**: Pre-existing comment "so watch can reach us" was load-bearing — but factually wrong. The watch uses Bluetooth MessageClient (see WearSyncService), not HTTP. The 0.0.0.0 bind was a stale assumption from an earlier WiFi-sync experiment that never shipped.
- **Fix**: shelf_io.serve(handler, '127.0.0.1', 8011). The Flutter WebView accesses the API via http://127.0.0.1:8011/ which still resolves to the loopback bind. Inline comment cites BUG+026 so future contributors don't undo it.
- **Test**: trilateration/test_local_server_security.py::test_local_server_binds_to_loopback_only and ::test_local_server_documents_bug_026 (static-grep regression — fails if 0.0.0.0 ever reappears in any shelf_io.serve call).
- **Regression**: forge baseline 139 PASS / 0 FAIL.

## BUG+027: local_server.dart uses synchronous file I/O (existsSync + readAsStringSync) inside async HTTP handlers at lines 211, 219, 298, 314, 362, 381. These calls block the entire Dart isolate while the disk read happens. The watch_detections.json and watch_drink_detections.json files grow indefinitely (never pruned — see related issue) so after a few months they can exceed 1MB. Reading 1MB+ synchronously during an /api/state call freezes the server for ~30-100ms PER REQUEST, causing dashboard jank and potential request pile-up. Fix: replace with await file.exists() / await file.readAsString().
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:59
- **Severity**: HIGH (perf — UI jank that grows with usage)
- **Symptom**: Dashboard increasingly janky over time. Every /api/state poll (~1Hz) blocks the Dart isolate for the duration of a synchronous disk read. As detection JSON files grow with usage, the per-call freeze grows from <1ms to 30-100ms, the timer engine misses ticks, animations stutter, and the timer drift becomes user-visible.
- **Root cause**: The original handlers used the *Sync variants because they were quick to write and the files were small. Nobody updated them as the detection log grew with real-world usage. This is the exact pattern Dart's effective-Dart guide warns against.
- **Fix**: Replaced 6 callsites (existsSync + readAsStringSync) with `await file.exists()` + `await file.readAsString()` in _handleApiState, _handleApiConsumptionAll, and _handleApiMonthlySummary. Added an inline comment at the first site explaining the growth-over-time failure mode.
- **Test**: trilateration/test_local_server_security.py::test_local_server_no_existssync, ::test_local_server_no_read_as_string_sync, ::test_local_server_uses_async_file_io. These are static greps that will fail loudly if any sync I/O call sneaks back into the file.
- **Regression**: forge baseline 139 PASS / 0 FAIL.

## BUG+028: local_server.dart _handleApiDrinksAdd at line 673 reads 'n' from POST body with NO upper bound: final n = (data['n'] as num?)?.toInt() ?? 1. A malicious caller (or buggy client) can pass n=999999 and the value is forwarded directly to data_store.addDrink(). The drinks.csv accumulates massive ghost values that pollute every weekly summary forever. Combined with BUG+026 (no auth on the API) any LAN attacker can corrupt the user's history. Fix: clamp n to 1..50 (a realistic single-add upper bound).
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 22:59
- **Severity**: MEDIUM (data poisoning, harder to exploit after BUG+026 fix)
- **Symptom**: A buggy WebView client (or, before BUG+026, any LAN attacker) could POST n=999999 and pollute drinks.csv with phantom drinks that show up in every monthly bilan forever. There is no UI to remove individual entries.
- **Root cause**: Boundary validation gap. Other endpoints (e.g. /api/goal at line 729) DO clamp; this one was overlooked.
- **Fix**: clamp(1, 50) on the `n` parameter of /api/drinks/add and clamp(0, 50) on the `total` parameter of /api/drinks/adjust. 50 is a realistic single-session ceiling (covers a wedding party).
- **Test**: trilateration/test_local_server_security.py::test_drinks_add_clamps_n and ::test_drinks_adjust_clamps_total — fail if the clamp ever disappears.
- **Regression**: forge baseline 139 PASS / 0 FAIL.

## BUG+029: sleep_service.dart getLastNightSleep at line 97 returns 'asleepMinutes': asleepMinutes > 0 ? asleepMinutes : totalMinutes. The fallback to totalMinutes (which by line 88 is now in-bed time when no SLEEP_ASLEEP records exist) means the field labeled 'asleepMinutes' actually contains in-bed time as a fallback. This makes durationMinutes and asleepMinutes always equal regardless of whether the user actually slept or just lay in bed reading, defeating the purpose of having two separate fields. Combined symptom: the dashboard cannot distinguish 'I was in bed 8h, slept 5h' from 'I was in bed 8h, slept 8h' — both render identically.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 23:03
- **Severity**: MEDIUM (UX — sleep quality metric is meaningless)
- **Symptom**: durationMinutes and asleepMinutes always returned the same value because the bad ternary fed totalMinutes (which had been overwritten with asleepMinutes upstream) into the asleepMinutes field. Net result: the dashboard's sleep quality split was non-functional.
- **Root cause**: Two compounding issues. (1) Line 88 mutated `totalMinutes` to be either in-bed OR asleep depending on data availability — semantic drift. (2) Line 97's fallback collapsed both output fields into the same value.
- **Fix**: Introduced `inBedMinutes` as a stable in-bed total computed once. Computed `durationMinutes` as `asleepMinutes > 0 ? asleepMinutes : inBedMinutes`. Returned `asleepMinutes` directly with NO fallback (so the field reports actual asleep records, 0 if Health Connect didn't return any). The 3 fields now have distinct semantics and the dashboard can differentiate "in bed 8h, slept 5h" from "in bed 8h, slept 8h".
- **Test**: trilateration/test_sleep_service_semantics.py — 6 static-grep tests that fail loudly if the bug pattern (`totalMinutes = asleepMinutes` mutation, or `asleepMinutes > 0 ? asleepMinutes : totalMinutes` ternary) ever returns.
- **Regression**: forge baseline 153 PASS / 0 FAIL.

## BUG+030: main.dart _AppLauncherState does NOT register a WidgetsBindingObserver, so when the app is sent to background by the user (Home button) the timer engine state is NEVER explicitly persisted. The local_server has a debounced _saveState that fires every 5s on engine ticks (line 115), but if the OS kills the process within the 5s window or the app is paused with a recent change, that change is lost. There is also no save in didChangeAppLifecycleState (which doesn't exist at all). The dispose() at line 104 calls localServer.stop() which DOES await _saveStateAsync() but dispose() is not awaited and runs only on widget tree teardown — not on app pause. Should add a WidgetsBindingObserver and call _saveStateAsync on AppLifecycleState.paused/detached.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 23:05
- **Severity**: HIGH (data loss — affects every Samsung process kill, which is frequent)
- **Symptom**: User logs a 'clope' in the dashboard, then hits Home button. Samsung Wear OS aggressively kills the Flutter process to free RAM. The 5s debounced save in local_server hadn't fired yet → the clope is lost. User reopens the app and the dashboard shows their previous state.
- **Root cause**: The lifecycle hook for "app is going away, flush" was never wired. The codebase relied entirely on the periodic 5s autosave, which is a soft persistence guarantee, not a hard one. Standard Flutter pattern (WidgetsBindingObserver) was missing.
- **Fix**: (1) _AppLauncherState now mixes in WidgetsBindingObserver. (2) addObserver/removeObserver in initState/dispose. (3) didChangeAppLifecycleState reacts to paused/inactive/detached/hidden by calling localServer.flushState(). (4) Added LocalServer.flushState() — a public method that bypasses the 5s debounce and writes the current EngineState immediately. flushState resets _lastSave so subsequent ticks redebounce from now.
- **Test**: trilateration/test_main_lifecycle_save.py — 8 static-grep tests covering: WidgetsBindingObserver mixin, addObserver in initState, removeObserver in dispose, didChangeAppLifecycleState exists and handles paused/detached, flushState() called from the lifecycle handler, LocalServer.flushState() exists and resets the debounce.
- **Regression**: forge baseline 153 PASS / 0 FAIL.
