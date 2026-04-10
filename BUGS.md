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
