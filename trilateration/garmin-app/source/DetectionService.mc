//
// DetectionService.mc
// Heuristic-based cigarette detection (no ML model)
//

using Toybox.System;
using Toybox.Timer;
using Toybox.Attention;

class DetectionService {

    var sensorManager;
    var inferenceTimer;
    var cigarettesDetected = 0;
    var lastDetectionTime = 0;

    // Thresholds (heuristic detection)
    const RMS_THRESHOLD = 5.0;       // m/s² (hand movement)
    const DEBOUNCE_SECONDS = 120;    // 2 minutes

    function initialize() {
        sensorManager = new SensorManager();
    }

    // Start detection service
    function start() {
        System.println("[DetectionService] Starting...");

        // Start sensor monitoring
        sensorManager.start();

        // Start periodic inference (every 30 seconds)
        inferenceTimer = new Timer.Timer();
        inferenceTimer.start(method(:runInference), 30000, true);

        System.println("[DetectionService] Started");
    }

    // Stop detection service
    function stop() {
        System.println("[DetectionService] Stopping...");

        if (inferenceTimer != null) {
            inferenceTimer.stop();
        }

        sensorManager.stop();

        System.println("[DetectionService] Stopped");
    }

    // Run heuristic inference
    function runInference() {
        System.println("[DetectionService] Running inference...");

        // Get 500 samples (20 seconds @ 25Hz)
        var data = sensorManager.getRecentData(500);
        if (data == null) {
            System.println("[DetectionService] Not enough data");
            return;
        }

        // Heuristic detection (no ML model)
        var score = 0;

        // 1. RMS threshold (hand movement)
        var rms = sensorManager.calculateRMS(500);
        if (rms > RMS_THRESHOLD) {
            score++;
            System.println("[DetectionService] RMS check: PASS (" + rms + ")");
        } else {
            System.println("[DetectionService] RMS check: FAIL (" + rms + ")");
        }

        // 2. Frequency analysis (cigarette-like motion ~0.5 Hz)
        var freq = estimateFrequency(data[:accel]);
        if (freq > 0.4 && freq < 0.6) {
            score++;
            System.println("[DetectionService] Frequency check: PASS (" + freq + " Hz)");
        } else {
            System.println("[DetectionService] Frequency check: FAIL (" + freq + " Hz)");
        }

        // 3. Heart rate spike (TODO: integrate HR sensor)
        // For now, assume HR spike is not available on all devices
        // score += checkHRSpike();

        // Detection: 2/3 conditions met
        var isCigarette = (score >= 2);

        System.println("[DetectionService] Inference complete: cigarette=" + isCigarette + ", score=" + score);

        if (isCigarette) {
            handleDetection();
        }
    }

    // Handle cigarette detection
    function handleDetection() {
        var now = Time.now().value();

        // Debounce
        if (now - lastDetectionTime < DEBOUNCE_SECONDS) {
            System.println("[DetectionService] Detection debounced");
            return;
        }

        lastDetectionTime = now;
        cigarettesDetected++;

        System.println("[DetectionService] CIGARETTE DETECTED! Count: " + cigarettesDetected);

        // Vibration notification
        if (Attention has :vibrate) {
            var vibeData = [
                new Attention.VibeProfile(50, 200),  // 50% intensity, 200ms
                new Attention.VibeProfile(0, 100),   // Pause
                new Attention.VibeProfile(100, 200)  // 100% intensity, 200ms
            ];
            Attention.vibrate(vibeData);
        }

        // TODO: Show notification on watch face
    }

    // Estimate dominant frequency (zero-crossing method)
    function estimateFrequency(accel) {
        // Calculate magnitude
        var magnitudes = new [accel.size()];
        var mean = 0.0;

        for (var i = 0; i < accel.size(); i++) {
            var ax = accel[i][0];
            var ay = accel[i][1];
            var az = accel[i][2];
            magnitudes[i] = Math.sqrt(ax*ax + ay*ay + az*az);
            mean += magnitudes[i];
        }
        mean /= accel.size();

        // Count zero-crossings
        var crossings = 0;
        for (var i = 1; i < magnitudes.size(); i++) {
            if ((magnitudes[i] - mean) * (magnitudes[i-1] - mean) < 0) {
                crossings++;
            }
        }

        // Frequency = crossings / 2 * sampling_rate / samples
        var frequency = (crossings / 2.0) * 25.0 / accel.size();
        return frequency;
    }

    // Get total count
    function getTotalCount() {
        return cigarettesDetected;
    }
}
