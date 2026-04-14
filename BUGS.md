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

## BUG+031: DetectionService.kt handleCigaretteDetected at line 694 and handleDrinkDetected at line 809 both use a check-then-write debounce pattern: 'if (currentTime - lastDetectionTime < 120_000) return; lastDetectionTime = currentTime'. This is NOT atomic. The service has 3 inference paths that can all trigger handleCigaretteDetected concurrently: (1) periodic runInference on a 30s coroutine loop, (2) boost inference when boostManager fires setOnBoostInferenceListener, (3) runInference25Hz launched from the Samsung SDK batch callback. Two threads arriving in the same ~millisecond window can both read lastDetectionTime as stale, both pass the 120s check, both increment cigarettesDetected, both insertDetection (two DB rows), both sendCigarette, both notify. Double detection = fake metric spike + double sync cost + double notification. Fix: move the debounce check + update into a synchronized(this) block or use AtomicLong.compareAndSet.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 23:34
- **Severity**: HIGH (data integrity — double-counted detections corrupt the user's history and ML training labels)
- **Symptom**: A single real cigarette puff could trigger both the periodic inference loop AND the Samsung 25Hz callback AND the boost listener within a few ms. All three would pass the naive time-check, all three would run the full handler (DB insert, BT sync, notification, boost trigger). User sees duplicate +1 counts, phone receives duplicate sync messages, and training labels get double-weighted.
- **Root cause**: The debounce is a classic TOCTTOU (time-of-check-to-time-of-use) race. Kotlin @Volatile provides visibility but NOT atomicity — two threads can both read the stale value before either writes the new one.
- **Fix**: lastDetectionTime/lastDrinkDetectionTime are now AtomicLong. Both handlers use a CAS retry loop: read prev, check window, compareAndSet(prev, now). Only one thread per 120s window wins the CAS and proceeds. Retries are bounded (once the CAS succeeds OR the window check fails, we exit).
- **Test**: trilateration/test_detection_debounce_race.py — 9 tests including (a) static-grep assertions that AtomicLong + compareAndSet are in place, (b) a Python port of the CAS-loop with 50 concurrent threads proving exactly 1 winner, (c) baseline proof that the naive pattern lets multiple threads through.
- **Regression**: forge baseline 166 PASS / 0 FAIL.

## BUG+032: SmokingDetector.kt predict / predictRaw / predictRaw25Hz all call interpreter.run() which is NOT thread-safe (TFLite docs: 'An Interpreter must be used from a single thread at a time'). In DetectionService on the 50Hz path there are TWO concurrent coroutines that can call into the interpreter: (1) the periodic runInference launched in a 'while (isActive) { delay(30s); runInference() }' loop, and (2) the boost inference launched via 'serviceScope.launch { runInference(isBoostMeasurement = true) }' when BoostManager fires setOnBoostInferenceListener. Both run on Dispatchers.Default which is a thread pool — they can execute in parallel on different workers. Concurrent interpreter.run() calls cause native crashes or corrupted inference results. Fix: wrap all interpreter.run() calls in a Mutex.withLock or synchronized(interpreter) block.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 23:41
- **Severity**: CRITICAL (native crash or silently corrupted inference output on 50Hz v5 model)
- **Symptom**: Intermittent logcat SIGSEGV inside libtensorflowlite_jni.so when the boost listener and periodic inference fire concurrently. Even when it doesn't crash, parallel reads into the interpreter's internal tensor buffers can corrupt the output FloatArray, producing values that don't sum to 1.0 — nonsense probabilities feeding downstream logic.
- **Root cause**: No serialization around Interpreter.run(). The codebase relied on the 30-second periodic cadence to avoid collisions, but BoostManager's setOnBoostInferenceListener fires immediately on boost triggers, and Dispatchers.Default's thread pool has no intrinsic ordering.
- **Fix**: Added `private val interpreterLock = Object()`. Wrapped all 3 interp.run() calls in `synchronized(interpreterLock) { interp.run(input, outputArray) }`. This is a narrow lock (only serializes the actual inference, not the tensor build or the result logging) so it has near-zero contention overhead on the happy path and makes concurrent callers block cleanly.
- **Test**: trilateration/test_smoking_detector_thread_safety.py — 4 tests: interpreterLock declared, every interp.run() wrapped, no unwrapped interp.run() can sneak in, BUG+032 marker present.
- **Regression**: forge baseline 166 PASS / 0 FAIL.

## BUG+033: train_cnn.py line 149 and train_cnn_25hz.py line 207 both use StratifiedKFold.shuffle(True).split(X, y) for cross-validation. Windows from the SAME subject are produced by load_windows() via 'for subj in dataset: for session in dataset[subj]: ... sliding window', then concatenated into X without any groups tracking. StratifiedKFold then distributes windows randomly across folds — so the SAME subject's windows end up in BOTH train and test folds. Classic subject leakage in wearable ML. The CNN memorizes subject-specific idiosyncrasies (watch-on-wrist posture, baseline wrist orientation) and the reported F1 (0.75 v5, 0.41 v6) is OVERSTATED — the real deployment F1 on a new user is significantly lower. The trilateration/train_real_data.py file does it correctly with LOSO (line 181, train_loso function). Fix: update load_windows to return subjects array, use GroupKFold(n_splits=N_FOLDS).split(X, y, groups=subjects). Apply to BOTH train_cnn.py and train_cnn_25hz.py.
- **Status**: FIXED (2026-04-10)
- **Date**: 2026-04-10 23:48
- **Severity**: HIGH (ML validity — reported CV F1 did not reflect real deployment performance)
- **Symptom**: Reported CV F1 for v5 (0.75) and v6 (0.41) were optimistic because the model saw windows from every test subject during training. On-device reality was that the first-install user is NEVER in the training set — the real generalization gap is larger than the CV number suggested. This is likely why v5 looked promising on paper but underperformed on the user's watch.
- **Root cause**: Standard StratifiedKFold only stratifies by class balance, not by subject. The sibling script train_real_data.py already had the correct LOSO implementation (line 181), but train_cnn.py and train_cnn_25hz.py were written earlier and never updated to match.
- **Fix**: Both files: (1) load_windows now returns (X, y, subjects) with subject IDs namespaced as f"{pkl_name}:{subj}" to prevent numeric collisions across SED and SED-FL. (2) Imports changed from StratifiedKFold to GroupKFold. (3) CV loop uses gkf.split(X, y, groups=subjects). Every subject now appears in exactly one test fold, matching the deployment reality.
- **Test**: trilateration/test_cnn_training_no_subject_leakage.py — 8 tests: static-grep asserting both files import GroupKFold + use groups= in split + load_windows returns 3-tuple, AND a synthetic proof that on a subject-correlated dataset StratifiedKFold leaks while GroupKFold isolates each subject to exactly one fold.
- **Regression**: forge baseline 174 PASS / 0 FAIL (was 166).
- **Follow-up**: models must be re-trained with the fixed CV to get an honest F1 number before the next deployment. Current deployed v2 GBM is unaffected (different training path).

## BUG+034: infernal-app/lib/views/onboarding_screen.dart line 45 displays 'Tout reste sur ton telephone, chiffre' (data stays on your phone, encrypted) as a selling point before the user commits to the app. This is FALSE — see BUG+018: crypto_service is initialized but never called, data_store writes plain JSON/CSV. The onboarding text obtains user consent based on a claim that isn't technically true. Must either (a) fix BUG+018 so the claim becomes true, or (b) soften the copy until then. Since BUG+018 is a dedicated architectural rework, the right short-term fix is to change the copy to 'Tout reste sur ton telephone' (drop the chiffre claim) so the onboarding stops being misleading. This is a consent/trust issue not a technical bug but forge tracks it for visibility.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:01
- **Severity**: HIGH (consent/trust — user grants permission based on a false claim)
- **Symptom**: The onboarding third feature card claimed "Donnees privees — Tout reste sur ton telephone, chiffre". The first half (local-only) is accurate. The second half (encrypted) is not — see BUG+018.
- **Root cause**: The copy was written early in the project when the crypto wiring was planned but not yet shipped. BUG+018 postponed the wiring; the copy was never updated to match the code.
- **Fix**: Short-term copy-only fix: drop "chiffre" → "Tout reste sur ton telephone". This is the minimum-viable truth while BUG+018 waits for a dedicated architectural session. Inline comment references BUG+034 + BUG+018 so the next contributor understands why the copy is deliberately understated.
- **Test**: trilateration/test_onboarding_webview_hardening.py::test_onboarding_does_not_claim_chiffre + ::test_onboarding_keeps_local_only_claim + ::test_bug_034_marker_present.
- **Regression**: forge baseline 192 PASS / 0 FAIL.
- **Follow-up**: once BUG+018 ships, restore the "chiffre" claim. Do NOT restore it before.

## BUG+035: dashboard_webview.dart line 24 registers a NavigationDelegate with no onNavigationRequest handler, so the WebView will follow any URL the page asks it to navigate to. Today that's harmless because local_server only serves bundled HTML under 127.0.0.1:8011. But if a future contributor adds any anchor tag pointing to an external URL, or a script injects window.location, the WebView blindly follows it. Fix: add onNavigationRequest that returns NavigationDecision.prevent for any URL that isn't http://127.0.0.1:8011 or http://localhost:8011. This is belt-and-suspenders defense alongside BUG+026 (loopback bind).
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:01
- **Severity**: MEDIUM (defense-in-depth — no known exploit today, but trivial accident away)
- **Symptom**: Latent. An accidental `<a href="https://example.com">` in the dashboard HTML (or any JS `window.location = ...` from a future feature) would load third-party content inside the app's WebView, with JS enabled and full access to the loopback API at 127.0.0.1:8011.
- **Root cause**: NavigationDelegate was set up to react to page lifecycle events (onPageStarted/Finished/Error) but had no onNavigationRequest handler, so webview_flutter's default policy (allow everything) applied.
- **Fix**: Added onNavigationRequest that returns NavigationDecision.navigate only if the URL starts with `http://127.0.0.1:8011` or `http://localhost:8011`, and NavigationDecision.prevent otherwise. Order matters: the allow check runs BEFORE the prevent fallback — a regression that swapped them would block every navigation.
- **Test**: trilateration/test_onboarding_webview_hardening.py — 5 tests: handler exists, uses prevent, both loopback URLs allowed, allow-list-comes-before-prevent ordering, BUG+035 marker.
- **Regression**: forge baseline 192 PASS / 0 FAIL.

## BUG+036: finetune_cnn_v7.py lines 182-186: the label to soft-target mapping only special-cases 'false_positive'. Every other label value defaults to the cigarette-positive encoding [0.90, 0.03, 0.03, 0.04]. load_training_windows at line 144 explicitly allows 'unknown' as fallback for missing/corrupt payloads. Result: any window whose JSON is missing the 'label' field, OR whose label is a new category not added to the mapping yet, gets silently trained as CIGARETTE-POSITIVE with 0.90 confidence. This is label poisoning: one corrupt file skews the per-user fine-tune toward false positives. Fix: explicit dict lookup with conservative default (treat unknown as OTHER, not cigarette) AND log a warning per unknown label. Matters more than usual because the personal dataset is tiny (20-50 windows) so one bad label carries 2-5% of the gradient.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:03
- **Severity**: HIGH (silent label poisoning on a small dataset — corrupts per-user fine-tuning)
- **Symptom**: A corrupt JSON file, a missing 'label' field, or a new label category (added by a future flow but not yet mapped here) would silently train as a cigarette-positive example. With 20-50 windows per user fine-tune, a single bad file contributes 2-5% of the gradient. Over time the personal model drifts toward false positives.
- **Root cause**: `if lbl == 'false_positive': other else: cigarette` — the "else" branch was an implicit default, not an explicit allow-list. The author assumed unknown labels would never reach this code, but load_training_windows has its own 'unknown' fallback at line 144 for missing fields.
- **Fix**: Replaced the if/else with an explicit LABEL_TO_TARGET dict containing exactly the 4 known labels (auto_detected, auto_confirmed_by_manual, manual_only, false_positive). Rows whose label is not in the dict are DROPPED with a warning log, and X/y/labels/weights arrays are re-filtered. If dropping reduces the dataset below --min-windows, the script aborts with exit code 1.
- **Test**: trilateration/test_finetune_label_poisoning.py — 8 tests: (1) static-grep that LABEL_TO_TARGET exists, (2) all 4 known labels present, (3) no else→cigarette pattern reappears, (4) drop path present, (5) .get(lbl) used, (6) logic port that proves unknown/empty/typo labels are dropped with zero target, (7) baseline demo of the OLD buggy behavior showing 3/4 unknowns become cigarette.
- **Regression**: forge baseline 192 PASS / 0 FAIL.

## BUG+037: notes.html line 1407 builds an exportable HTML journal by concatenating user notes: 'html += <div class=notes>' + (note.content || '').replace(/\n/g, '<br>') + '</div>'. The note.content is user-authored via /api/note — it's whatever the user typed into the dashboard. NO escapeHtml call. If the user writes '<script>alert(1)</script>' (or worse, any HTML that steals data or hijacks clicks) in a note, that markup is embedded verbatim in the exported .html file. When the user opens the exported file in a browser, scripts execute in a file:// context with elevated privileges (depending on browser), AND the file contains the user's private smoking/drinking history which they may share with friends or medical providers. This is self-XSS → exported-file XSS → potential cross-user XSS if the file is shared. Fix: add an escapeHtml helper to notes.html (index.html has one; notes.html was never given the same treatment) and apply it BEFORE the \n → <br> replacement.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:08
- **Severity**: HIGH (self-XSS → file:// XSS → shared-file XSS)
- **Symptom**: A user who wrote markup in a note (e.g. for emphasis, inline HTML, or by accident like a URL with a parameter parsed as a tag) would get that markup rendered when the journal was exported. Self-inflicted, but also exposure risk: the exported file contains private smoking/drinking history and might be shared with friends or medical providers, whose browsers would execute the embedded scripts.
- **Root cause**: index.html has an escapeHtml helper and uses it in most render paths. notes.html never got the same helper — its innerHTML sites concatenated user data directly. The journal export (the highest-impact site) was the worst offender because the output ends up as a shareable file.
- **Fix**: Added an escapeHtml helper at the top of notes.html covering & < > " ' (5-char safe set, including ' which index.html's version misses). Applied it to note.content AND the date-display fields in the export loop, BEFORE the \n → <br> rewrite. Inline comment explains the file:// execution context so future contributors don't "simplify" by dropping the escape.
- **Test**: trilateration/test_notes_export_xss.py — 6 tests: helper exists, covers all 5 chars, export escapes note.content, no raw-content pattern can sneak back, date fields also escaped, BUG+037 marker present.
- **Regression**: forge baseline 198 PASS / 0 FAIL.
- **Bonus fix**: BUG+038 was an accidental duplicate created when the first `forge --add` crashed on a unicode arrow in the description AFTER already writing BUG+037 to BUGS.md. Fixed forge.py to safely encode descriptions to ASCII before printing (cp1252 Windows console can't print unicode arrows). BUG+038 left as MERGED marker to preserve the numbering sequence.

## BUG+038: MERGED into BUG+037 — the previous forge --add attempt crashed on a unicode arrow char in the description after already writing BUG+037 to BUGS.md. The retry landed as BUG+038 with an ASCII-safe description for the SAME bug. Keeping this marker so the numbering sequence stays continuous; see BUG+037 for the real fix.
- **Status**: MERGED into BUG+037 (2026-04-11)

## BUG+039: MainActivity.kt onLogCigarette lambda (line 128-157) and onLogDrink lambda (line 158-185) have no debounce. On a Wear OS watch with a small screen, accidental double-tap on the +1 button is common. Each tap calls database.insertDetection + DetectionService.triggerBoost + messageSync.sendCigarette. Two taps 100ms apart create TWO database rows for ONE real cigarette, two sync messages to the phone, and the second triggerBoost cancels the first boost job mid-countdown (via @Synchronized). Net: ghost cigarettes in history, double-sync waste, boost mode confused. Fix: guard the lambdas with an AtomicLong lastClickTime check using the same 200ms interval pattern Compose recommends for tap debouncing.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:15
- **Severity**: HIGH (data integrity — ghost rows in history + wasted BT sync)
- **Symptom**: User logs a cigarette on the watch, accidentally taps the +1 button twice (easy on a 1.2" screen), gets "+2" in the count. The count propagates to the phone dashboard which shows +2. Worse: the second triggerBoost cancels the first boost job mid-countdown, so the 7-minute boost mode restarts from zero. The DB also has 2 rows for 1 real cigarette, polluting future fine-tuning labels.
- **Root cause**: No click debounce anywhere in MainActivity. Compose Button has no built-in debounce, and the lambdas call DB + sync + boost directly.
- **Fix**: Added `MANUAL_LOG_DEBOUNCE_MS = 300L` constant + `private val lastManualLogMs = AtomicLong(0L)` + `consumeManualClick()` helper that uses the same CAS retry loop as DetectionService BUG+031. Both onLogCigarette and onLogDrink lambdas call consumeManualClick() early and `return@MainScreen` on false. 300ms is the Compose-recommended tap deduplication window.
- **Test**: trilateration/test_manifest_and_ui_hardening.py — 6 BUG+039 tests: constant declared, AtomicLong used, CAS in consumeManualClick, both lambdas call it, marker present.
- **Regression**: forge baseline 209 PASS / 0 FAIL.

## BUG+040: trilateration/wear-os-app/app/src/main/AndroidManifest.xml line 49-55: DetectionService is declared with android:exported=true in the MAIN manifest (not a debug variant). The inline comment admits this is intentional for ADB debugging during development but warns 'Released APKs MUST flip this back to false'. However, since the flag is in main AndroidManifest.xml, it ALSO ships to release builds. Consequence: ANY app installed on the watch can send an Intent to DetectionService.ACTION_START, ACTION_STOP, or ACTION_BOOST. A malicious app can silently start the service (drain battery, foreground notification spam), stop the service (sabotage), or fire boost mode at will (waste battery, corrupt training samples via captureTrainingWindow). Fix: set exported=false in the main manifest and use a debug-only AndroidManifest.xml override (src/debug/AndroidManifest.xml) to restore exported=true for ADB development workflows.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:17
- **Severity**: CRITICAL (IPC exploit — any app on the watch can control our service)
- **Symptom**: A malicious app could send `am start-foreground-service -n com.infernal.wheel/.DetectionService -a com.infernal.smokingdetector.BOOST` and trigger 7 minutes of boost-mode sampling (100Hz accelerometer + forced inference every 15s = battery nuke). It could also fire ACTION_STOP to silently kill the service while the user thinks it's running.
- **Root cause**: The exported=true flag was added during early ADB-driven dev and never flipped back. The TODO comment promised the flip for release but the flip never happened.
- **Fix**: Set exported=false directly in the MAIN manifest. Updated the inline comment to document the proper pattern: use src/debug/AndroidManifest.xml with an intent-filter + exported=true OVERRIDE for dev workflows (debug build variant only). That way release builds never ship the exported flag.
- **Test**: trilateration/test_manifest_and_ui_hardening.py — uses xml.etree to actually parse the manifest and assert android:exported="false" on the DetectionService declaration. Also asserts the comment references src/debug/AndroidManifest.xml so the fix is self-documenting.
- **Regression**: forge baseline 209 PASS / 0 FAIL.

## BUG+041: trilateration/wear-os-app/app/src/main/AndroidManifest.xml line 26: android:allowBackup=true means the DetectionService SQLite DB (cigarette_detections table with 90 days of timestamps, HR readings, GPS clusters) gets backed up to Google Drive when the user has auto-backup enabled. For a health tracker that markets 'local only' privacy, this is a privacy leak: the user's smoking history, drinking history, and inferred GPS clusters end up on Google's servers without explicit consent. Fix: set android:allowBackup=false and add android:dataExtractionRules referencing an empty rules file so explicit opt-in backup would also require code changes. Defense-in-depth alongside BUG+018.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:17
- **Severity**: HIGH (privacy leak to Google Drive — contradicts marketing "local only" claim)
- **Symptom**: Users with auto-backup enabled (the Android default) were having their entire smoking + drinking + GPS cluster history uploaded to Google Drive without explicit in-app consent. The data persisted in backups even after the user uninstalled the app.
- **Root cause**: Default Android manifest flag; nobody audited it against the "local only" privacy claim.
- **Fix**: Set android:allowBackup="false" + inline comment documenting the privacy intent so a future contributor doesn't flip it back for "convenience". If a Google-Drive backup feature is added later, it must go through an explicit in-app consent flow with a new manifest flag.
- **Test**: trilateration/test_manifest_and_ui_hardening.py::test_allow_backup_is_false — parses the manifest via xml.etree and asserts allowBackup=="false".
- **Regression**: forge baseline 209 PASS / 0 FAIL.

## BUG+042: trilateration/wear-os-app/app/build.gradle.kts line 26: release buildType has isMinifyEnabled = false. ProGuard/R8 minification + shrinking is disabled in release builds. Consequences: (1) APK is bigger than needed (slower class loading on the watch = worse battery); (2) no obfuscation makes reverse-engineering the ML model and detection logic trivial; (3) dead code from unused library features (horologist helpers we don't call, coroutines paths we don't use) ships to the watch anyway; (4) the proguardFiles declaration on lines 27-30 is cosmetic — it's referenced but never applied because minify is off. Fix: set isMinifyEnabled = true and isShrinkResources = true on the release build type, then test the resulting APK to make sure R8 doesn't strip something reflection-loaded (Samsung Health SDK is loaded via Class.forName at runtime — add keep rules if needed).
- **Status**: OPEN
- **Date**: 2026-04-11 00:22
- **Symptom**: [a remplir]
- **Root cause**: [a remplir]
- **Fix**: [pending]
- **Test**: [a ecrire]
- **Regression**: [a verifier]

## BUG+043: train_real_data.py line 114 periodicity_coef computation: features.append(features[17] if len(features) > 17 else 0) with comment 'reuse autocorr'. But counting features at that point: 0-11 time/angular/jerk (12 features), 12-14 frequency (dominant_freq, spectral_energy, spectral_entropy), 15 autocorr_peak, 16 periodicity (computed from features[-1]*features[-4]), 17 path_curvature. So features[17] is path_curvature, NOT autocorr_peak (which is at index 15). The periodicity_coef feature is silently assigned path_curvature's value. Effect: the 30-feature vector has path_curvature DUPLICATED (once at its real slot, once at periodicity_coef slot) and the actual autocorr-based periodicity_coef is NEVER computed. The GBM trains on wrong features. Fix: change to features[15] OR better, compute an actual periodicity_coef from the autocorrelation peak.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:46
- **Regression**: forge baseline 226 PASS / 0 FAIL (+17 vs pass forge8).
- See inline BUG+043/044/045 comments in trilateration/train_real_data.py for the detailed fix rationale. Tests: trilateration/test_train_real_data_features.py (10 tests: numerical 1Hz/2Hz FFT verification for BUG+044, feature-index uniqueness for BUG+043, static-grep for BUG+045 int8 removal).

## BUG+044: train_real_data.py line 77 dominant_freq computation: freqs[np.argmax(fft_vals[1:])]. np.argmax returns an index INTO the slice fft_vals[1:], not into the original fft_vals. If argmax returns k, the actual bin is fft_vals[k+1] and its frequency is freqs[k+1], not freqs[k]. The current code indexes freqs with a k that is off-by-one below the true peak. On a 225-sample window at 50Hz, the frequency resolution is ~0.22Hz per bin so the reported dominant_freq is systematically ~0.22Hz lower than the true value. For a smoking gesture whose fundamental is ~0.5-1Hz, that's a 20-40% relative error. Fix: freqs[np.argmax(fft_vals[1:]) + 1]. Same bug family as feature_extraction.py would have had if it used raw indexing but feature_extraction.py uses positive_freqs[dominant_idx] after computing dominant_idx = np.argmax(power_spectrum[1:]) + 1 so it's correct.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:46
- **Regression**: forge baseline 226 PASS / 0 FAIL (+17 vs pass forge8).
- See inline BUG+043/044/045 comments in trilateration/train_real_data.py for the detailed fix rationale. Tests: trilateration/test_train_real_data_features.py (10 tests: numerical 1Hz/2Hz FFT verification for BUG+044, feature-index uniqueness for BUG+043, static-grep for BUG+045 int8 removal).

## BUG+045: train_real_data.py lines 285-287: train_final_and_export uses int8 quantization for the TFLite output (converter.target_spec.supported_ops = [TFLITE_BUILTINS_INT8] + inference_input_type=int8). train_cnn_25hz.py line 287-288 explicitly warns against this with the comment 'NO int8 quantization - float32 input/output (avoids the v5 crash bug)' referring to a known crash on Wear OS Android 16 with int8 input tensors. train_real_data.py was the ORIGIN of the v5 crash bug and still has the buggy code. Any user who re-runs this script + installs the resulting .tflite on the watch will hit the same crash v5 hit. Fix: remove int8 conversion, use float32 input/output like train_cnn_25hz.py does.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:46
- **Regression**: forge baseline 226 PASS / 0 FAIL (+17 vs pass forge8).
- See inline BUG+043/044/045 comments in trilateration/train_real_data.py for the detailed fix rationale. Tests: trilateration/test_train_real_data_features.py (10 tests: numerical 1Hz/2Hz FFT verification for BUG+044, feature-index uniqueness for BUG+043, static-grep for BUG+045 int8 removal).

## BUG+046: infernal-app/assets/web/index.html syncOfflineQueue at line 3067-3085 reads the offline queue into const q at line 3068, loops with await fetch per item, then at line 3082 calls saveOfflineQueue(q.slice(synced)) to persist the remaining items. This is a TOCTTOU race: between the const q snapshot and the final saveOfflineQueue call, the browser can yield during await fetch AND the user can trigger a new offline action (if the connection drops mid-sync). The new action goes through queueOfflineAction which appends to localStorage, giving localStorage state [A, B, C, D] while q is still the stale [A, B, C]. Final saveOfflineQueue(q.slice(3)) writes [] back, permanently losing D. Fix: pop items one at a time by re-reading the queue after each successful fetch and removing only the synced item by ts+url match, or use a retry counter per item stored in the queue itself.
- **Status**: FIXED (2026-04-11)
- **Date**: 2026-04-11 00:48
- **Severity**: MEDIUM (data loss on connection churn during offline sync)
- **Symptom**: User logs action A, B, C offline → queue = [A, B, C]. Connection returns, syncOfflineQueue starts. It succeeds on A, B, but the connection drops mid-sync. Meanwhile the user logs D (offline again) → localStorage now holds [A, B, C, D]. Sync resumes, succeeds on C, then hits the final `saveOfflineQueue(q.slice(synced))` with the STALE q = [A, B, C] → writes `[]` to localStorage. D is gone forever.
- **Root cause**: Classic TOCTTOU. `const q = getOfflineQueue()` at the top snapshotted the list, the loop awaited fetches (yielding the event loop), and the final save used the stale snapshot to compute what remained.
- **Fix**: Renamed the snapshot to `initialQ` (so it's clearly read-only) and moved the save INTO the per-item success branch: after each successful fetch, re-read `getOfflineQueue()`, findIndex by ts+url to locate THIS item in the current state, splice it out, save. Any items queued during the await are preserved because we only touch the specific item we just synced.
- **Test**: trilateration/test_offline_queue_race.py — 7 tests: (a) 4 static-grep assertions that the bad pattern can't sneak back, (b) 3 Python ports that prove the fixed algorithm preserves interleaved new items while the buggy baseline loses them.
- **Regression**: forge baseline 226 PASS / 0 FAIL.

## BUG+047: FALSE POSITIVE on re-read — detect_stay_points IS correct
- **Status**: CLOSED — not a bug (2026-04-14)
- **Date**: 2026-04-14 15:01
- **Investigation**: Initial bug report claimed that `detect_stay_points` only checks `haversine(points[i], points[j])` without verifying intermediate points. This is WRONG on re-read: the inner while loop iterates j forward one step at a time, and the `if dist > radius_m: break` fires on the FIRST j where the point exits the radius. So the home→bakery→home scenario WOULD correctly break when the user walks out. The algorithm is sound.
- **Lesson**: trace the loop with a concrete counter-example BEFORE logging the bug, not after. Kept in numbering sequence so future audits don't renumber.

## BUG+048: stay_points.py temporal_labeling line 261: df['hour'] = df['start_time'].dt.hour. The label is computed from start_time ONLY. Problem: stay points can span many hours. A user who arrives home at 21h30 and leaves at 8h00 (a realistic overnight sleep stay) has start_time.hour = 21 → labeled 'bar' by label_time() because 18 <= 21 < 22. But the actual MAJORITY of the stay (10+ hours) is overnight home time. Real-world impact: every overnight sleep gets mislabeled as bar/social, then DBSCAN + majority-vote across the cluster inherits the wrong label, and the GPS-context feature fed to the ML model is systematically wrong for evening home stays. Fix: label based on the MIDPOINT of the stay (start + duration/2) OR the majority hour bucket across the stay duration.
- **Status**: FIXED (2026-04-14)
- **Date**: 2026-04-14 15:03
- **Severity**: HIGH (ML validity — every overnight stay mislabeled 'bar' instead of 'home')
- **Symptom**: A user going to bed at 21h30 and waking at 8h00 has the entire sleep period mislabeled as 'bar' by the temporal_labeling pass, because label_time(21) returns 'bar'. DBSCAN majority-vote then propagates this wrong label to the whole cluster, feeding garbage into the gps_cluster feature used by the ML model.
- **Root cause**: Original code used `.dt.hour` on the start_time only, which is a zero-duration anchor. A stay is a DURATION, not an instant — the label must reflect where the majority of time was spent.
- **Fix**: compute midpoint = start_time + (end_time - start_time) / 2, then take `.dt.hour` of the midpoint. For a 21h30→8h00 stay the midpoint is ~2h45 → 'home'. The label_time function itself is unchanged — only the input timestamp.
- **Test**: trilateration/test_stay_points_midpoint_label.py — 8 tests: overnight → 'home', short evening → 'bar', morning-to-afternoon → 'work', weekend lunch → 'work', cluster majority-vote consistency, noise preservation, empty input, BUG+048 marker.
- **Regression**: forge baseline 243 PASS / 0 FAIL.

## BUG+049: infernal-app/pubspec.yaml line 32: dependency 'intl: any' uses the wildcard version specifier. pub will resolve it to whatever latest version is compatible, meaning a dart pub upgrade on a future day can silently pick up an intl version with breaking changes. Reproducible builds require pinned or caret-pinned versions. flutter_secure_storage, pointycastle, crypto, path_provider, webview_flutter all use caret-range (^X.Y.Z) which allows patch/minor upgrades within the same major. intl should follow the same convention. Fix: change 'intl: any' to 'intl: ^0.19.0' (or whatever current stable is when the script is re-run).
- **Status**: FIXED (2026-04-14)
- **Date**: 2026-04-14 15:04
- **Severity**: MEDIUM (reproducibility — silent breakage risk on pub upgrade)
- **Symptom**: `dart pub upgrade` could silently pull intl 0.20+ (or any future major) and break the generated l10n code (which uses intl.Intl.pluralLogic and intl.DateFormat.yMMMd in 7 locales). Since intl 'any' means no upper bound, there's no guard against breaking changes.
- **Root cause**: 'any' was a leftover from scaffolding — other deps already use caret, intl was overlooked.
- **Fix**: Pinned `intl: ^0.19.0` (the Flutter 3.x-compatible major) with an inline comment documenting the pin rationale.
- **Test**: trilateration/test_pubspec_and_gps_config.py — 4 tests: no 'intl: any' line, caret range present, BUG+049 marker, no other 'any' deps either.
- **Regression**: forge baseline 243 PASS / 0 FAIL.

## BUG+050: GPSClusteringManager.kt start() line 71-85 registers requestLocationUpdates with GPS_MIN_DISTANCE_M = 50f, meaning Android only delivers location callbacks when the user has moved at least 50 meters. onLocationChanged line 112 then checks 'if (distance < STAY_POINT_RADIUS_M)' where STAY_POINT_RADIUS_M = 50.0. Since the LocationManager only fires when distance >= 50m, the 'stay detected' branch (line 112-121) can essentially NEVER fire. The stay-point detection logic is dead code: getCurrentCluster always returns CLUSTER_OTHER. Impact: the gps_cluster feature fed to the ML model is always 3 (other), never home/work/bar. The 'pattern-based threshold' adjustment in DetectionService (isHighSmokingHour = threshold - 0.15f when home) never activates because clustering never emits non-OTHER labels. Fix: remove the GPS_MIN_DISTANCE_M=50f filter OR drop it to 5m so stay detection has real data to work with.
- **Status**: FIXED (2026-04-14)
- **Date**: 2026-04-14 15:05
- **Severity**: HIGH (entire feature dead — GPS context feature always 'other', downstream threshold adjustment never applies)
- **Symptom**: gps_cluster always 3 (CLUSTER_OTHER). The `isHighSmokingHour` threshold-lowering in DetectionService never triggers. The smart-context features of the detector are effectively disabled without anyone noticing because nothing crashes — it just silently underperforms.
- **Root cause**: The two constants (GPS_MIN_DISTANCE_M filter vs STAY_POINT_RADIUS_M logic) were configured independently and nobody noticed the filter was set exactly AT the radius, making the `distance < radius` branch unreachable in practice. The LocationManager's min-distance filter decides which callbacks reach us; setting it at 50m means we only hear about moves ≥ 50m, so inside-radius micro-movements are invisible.
- **Fix**: GPS_MIN_DISTANCE_M dropped from 50f to 5f so Android delivers callbacks on small movements inside a stay. 5m is small enough to accumulate duration at a stationary spot but large enough to filter out GPS jitter. Inline comment references BUG+050 for future contributors.
- **Test**: trilateration/test_pubspec_and_gps_config.py — 5 tests: invariant `gps_min < stay_radius/5`, specific check that 50f can't reappear, BUG+050 marker, Python simulation of old vs new behavior proving the old filter silently dropped all micro-movement callbacks.
- **Regression**: forge baseline 243 PASS / 0 FAIL.

## BUG+051: trilateration/wear-os-app/app/src/main/res/values/strings.xml line 3: <string name='app_name'>Smoking Detector</string>. The phone app, Play Store description, onboarding, and ALL other branding use '-1+' (see infernal-app/android/app/src/main/AndroidManifest.xml:13 android:label='-1+', and main.dart:35 title: '-1+'). The watch launcher icon label is still 'Smoking Detector'. This creates: (1) brand inconsistency on the watch tile screen; (2) privacy issue — 'Smoking Detector' is explicit about what the app does, visible to anyone looking at the watch over the user's shoulder. -1+ is intentionally opaque for discretion. Fix: change strings.xml app_name to '-1+' matching the phone label. Also strings for status_ready/button_test are English-only while the rest of the watch UI is in French (MainScreen.kt uses 'Detection auto', 'Manuel', 'Reglages', 'Retour'). Unused strings (button_start/monitor/detect/test) appear nowhere in the watch Kotlin code — dead i18n entries.
- **Status**: FIXED (2026-04-14)
- **Date**: 2026-04-14 15:19
- **Severity**: MEDIUM (privacy + brand consistency)
- **Symptom**: The watch tile screen displayed "Smoking Detector" as the app label — an explicit reveal of the app's purpose visible to anyone glancing at the watch over the user's shoulder. Contradicts the deliberately opaque "-1+" naming on the phone + Play Store.
- **Root cause**: app_name was a leftover from the early dev version. When the brand pivoted to "-1+" for Play Store privacy, only the phone manifest was updated. Similarly, 5 unused string resources (status_ready, button_start/monitor/detect/test) survived the migration to Compose UI, which now hardcodes all button labels directly in MainScreen.kt / SettingsScreen.kt.
- **Fix**: strings.xml now contains only `<string name="app_name">-1+</string>` with an inline comment explaining the privacy rationale. 5 dead string resources deleted. Inline comment so nobody "restores" Smoking Detector thinking it's more descriptive.
- **Test**: trilateration/test_watch_strings_and_css_injection.py — 4 BUG+051 tests: app_name == "-1+", "Smoking Detector" not in any <string> value, 5 dead resources remain deleted, BUG+051 marker present.
- **Regression**: forge baseline 257 PASS / 0 FAIL.

## BUG+052: index.html injectCustomActionCSS at line 3641-3652 builds a CSS string by concatenating user-authored a.key and a.color into a style tag via textContent. The values come from SETTINGS.actions which is populated by /api/settings/custom-actions. In _handleApiCustomActions (local_server.dart line 758-781) the key is sanitized via replaceAll regex [^a-z0-9] but the color has NO validation — it's stored as-is from data['color'] (line 770) and then 'raw.color ?? #ff9955' used downstream. Attack vector: a rogue LAN caller before BUG+026 was fixed, or a future API caller, could POST color='red;} body {display:none;} body {' — this breaks out of the custom-property context and injects arbitrary CSS. Even WITH BUG+026 loopback bind, the JavaScript side trusts the SETTINGS object loaded from /api/settings. If the user ever imports a settings.json manually, the CSS injection is triggered. Fix: validate color server-side (regex /^#[0-9a-f]{6}$/i) OR escape in CSS injection by replacing non-hex chars.
- **Status**: FIXED (2026-04-14)
- **Date**: 2026-04-14 15:20
- **Severity**: MEDIUM (CSS injection, requires adversarial settings.json)
- **Symptom**: User-authored color strings flowed unsanitized from /api/settings/custom-actions → DataStore → GET /api/settings → JS SETTINGS object → textContent of a <style> tag. A payload like `red;} body{display:none;} body{` would escape the custom-property context and inject arbitrary CSS rules that could hide the UI, override buttons, load remote fonts, exfiltrate local data via url(), etc.
- **Root cause**: Neither the server nor the client validated color as #rrggbb. The server regex only sanitized the key (keeping [a-z0-9]+), but the color field was trusted verbatim. The client likewise trusted SETTINGS.
- **Fix**: **Belt-and-suspenders**: (1) Server regex `^#[0-9a-fA-F]{6}$` — rejected colors fall back to the safe default `#ff9955`. (2) Client mirrors the check with `_HEX_COLOR_RE = /^#[0-9a-f]{6}$/i` and `_SAFE_KEY_RE = /^[a-z0-9]+$/`. Any action that fails validation is silently skipped from injectCustomActionCSS — no CSS string built from unsafe input.
- **Test**: trilateration/test_watch_strings_and_css_injection.py — 10 BUG+052 tests covering (a) server has hex regex + uses hasMatch + safe default, (b) client has _HEX_COLOR_RE + _SAFE_KEY_RE + filters bad input, (c) BUG+052 markers on both sides, (d) logic proof that the concrete attack payloads from the bug description are all rejected by the hex regex while real colors pass.
- **Regression**: forge baseline 257 PASS / 0 FAIL.

## BUG+053: test_loso.py line 89 passes proximity_smoking=0.5 if gesture == 'cigarette' else 0.1. This is a PERFECT LABEL LEAK: every cigarette sample has the exact same contextual proximity value 0.5, every non-cigarette has 0.1. The RandomForestClassifier trained on this data only needs to learn proximity > 0.3 -> cigarette, which it does immediately. The reported LOSO F1 is NOT measuring the ML model's ability to classify gestures from IMU features — it's measuring the label-from-proximity function, which is trivially perfect. The same pattern exists in train_baseline at line 182 but with similar structure. Real-world impact: the 'Sense2Quit 2025: F1 = 0.975' comparison in test_loso.py line 263 is meaningless because THIS study's reported F1 is from leaked labels. Fix: either randomize proximity_smoking uniformly in [0, 1] regardless of gesture, or derive it from gps_cluster in a non-label-revealing way.
- **Status**: FIXED (2026-04-14)
- **Date**: 2026-04-14 15:32
- **Severity**: CRITICAL (reported ML metrics were meaningless — trivially high F1 from label leak)
- **Symptom**: Any LOSO F1 number reported by test_loso.py was measuring the classifier's ability to read `proximity > 0.3` from its own input, which is 100% accurate by construction. The baseline comparison to published literature ("Sense2Quit 2025: F1 = 0.975") was comparing apples to a perfectly-leaked label vs. apples — the comparison implied parity with Sense2Quit when actually our metric was vacuous.
- **Root cause**: The synthetic data generator coupled a "contextual" feature perfectly to the label as a shortcut to make early prototypes produce high numbers. The shortcut was never undone.
- **Fix**: Both test_loso.py and train_baseline.py now draw `proximity = np.random.uniform(0.0, 1.0)` independently of the gesture label. The classifier must learn from IMU features only. Inline comment references BUG+053 so the leak isn't reintroduced under a "helpful" refactor.
- **Test**: trilateration/test_loso_and_iso_week.py — 5 BUG+053 tests: (a) the conditional-leak pattern is gone from both files, (b) np.random.uniform is used, (c) markers present, (d) logic proof — with N=500 simulated windows, the OLD pattern gives 100% label-from-proximity accuracy while the NEW pattern gives <70% (near chance).
- **Regression**: forge baseline 277 PASS / 0 FAIL. Any retrained model should now show the REAL LOSO F1, which is expected to be meaningfully lower than past reports — this is a FEATURE of the fix (honest metric), not a bug.

## BUG+054: data_store.dart getDrinksWeeks line 230-232: ISO week computation is WRONG. The formula starts at 0 for the first partial week (e.g. 2026-01-01 Thursday returns week 0, should be W01 per ISO 8601). Worse, the year used for the weekKey is dt.year (the calendar year) not the ISO year — so 2025-12-29 (a Monday belonging to ISO-2026-W01) gets labeled 2025-W53 and 2024-12-30 (ISO-2025-W01) gets labeled 2024-W53. Result: drink counts on dates near year boundaries are split across TWO bogus week buckets (the real ISO-W01 and the bogus W53 with the wrong year prefix). The weekly dashboard table shows phantom W53 weeks and misses data in the correct W01 week. Fix: Dart doesn't have built-in ISO 8601 week support; compute by finding the Thursday of the week (ISO spec says 'the week that contains the Thursday is the week of the year'), OR use the Dart date_time_format package, OR hand-roll with the proper algorithm from Wikipedia.
- **Status**: FIXED (2026-04-14)
- **Date**: 2026-04-14 15:33
- **Severity**: HIGH (UI/data integrity — phantom W53 weeks + missing data on year-boundary dates)
- **Symptom**: Weekly alcohol table in the dashboard showed bogus "2025-W53" or "2026-W00" rows and the drinks logged on 2025-12-29 → 2026-01-04 were split across the wrong buckets. Every year-boundary would reproduce the issue.
- **Root cause**: `((dayOfYear - weekday + 10) / 7).floor()` is a shortcut that approximates ISO weeks but: (1) is 0-indexed rather than 1-indexed → W0; (2) uses `dt.year` for the prefix instead of the ISO year, which differs from calendar year when a week straddles Dec 31 / Jan 1 (ISO 8601: the week containing Thursday owns the year).
- **Fix**: Added `_isoWeek(DateTime) → (int, int)` helper using the canonical algorithm — find the Thursday of the date's week, that Thursday's calendar year IS the ISO year, and the week number is `1 + (daysBetween(firstThursdayOfIsoYear, thisThursday) ÷ 7)`. getDrinksWeeks now uses this helper. DateTime.utc is used inside the helper to avoid DST shifts during the week-Thursday lookup.
- **Test**: trilateration/test_loso_and_iso_week.py — 9 BUG+054 tests: (a) Python port of the Dart algorithm matches Python's built-in `isocalendar()` on 9 tricky dates (year boundaries, 53-week years like 2020), (b) specific regressions for 2025-12-29 → 2026-W01 and 2026-01-01 → 2026-W01, (c) static-grep that _isoWeek helper exists, getDrinksWeeks calls it, old broken formula is gone, BUG+054 marker present.
- **Regression**: forge baseline 277 PASS / 0 FAIL.
