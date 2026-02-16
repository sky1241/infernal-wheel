//
// SensorManager.mc
// Sensor data collection (accelerometer + gyroscope)
//

using Toybox.Sensor;
using Toybox.System;

class SensorManager {

    // Circular buffer (7500 samples = 5 minutes @ 25Hz)
    const BUFFER_SIZE = 7500;

    var accelBuffer;
    var gyroBuffer;
    var bufferIndex = 0;
    var samplesCollected = 0;

    function initialize() {
        accelBuffer = new [BUFFER_SIZE];
        gyroBuffer = new [BUFFER_SIZE];

        // Initialize buffers
        for (var i = 0; i < BUFFER_SIZE; i++) {
            accelBuffer[i] = [0.0, 0.0, 0.0];
            gyroBuffer[i] = [0.0, 0.0, 0.0];
        }

        System.println("[SensorManager] Initialized");
    }

    // Start sensor monitoring
    function start() {
        var options = {
            :period => 1,  // Max update rate
            :accelerometer => {
                :enabled => true,
                :sampleRate => 25  // 25 Hz (Garmin limitation)
            },
            :gyroscope => {
                :enabled => true,
                :sampleRate => 25
            }
        };

        Sensor.setEnabledSensors([Sensor.SENSOR_ACCEL, Sensor.SENSOR_GYRO]);
        Sensor.registerSensorDataListener(method(:onSensorData), options);

        System.println("[SensorManager] Started @ 25 Hz");
    }

    // Stop sensor monitoring
    function stop() {
        Sensor.unregisterSensorDataListener();
        System.println("[SensorManager] Stopped. Samples: " + samplesCollected);
    }

    // Handle sensor data callback
    function onSensorData(sensorInfo) {
        if (sensorInfo.accelerometerData != null) {
            var accel = sensorInfo.accelerometerData.value;
            accelBuffer[bufferIndex] = [accel[0], accel[1], accel[2]];
        }

        if (sensorInfo.gyroscopeData != null) {
            var gyro = sensorInfo.gyroscopeData.value;
            gyroBuffer[bufferIndex] = [gyro[0], gyro[1], gyro[2]];
        }

        // Advance buffer (circular)
        bufferIndex = (bufferIndex + 1) % BUFFER_SIZE;
        samplesCollected++;
    }

    // Get recent data (last N samples)
    function getRecentData(numSamples) {
        if (numSamples > BUFFER_SIZE) {
            numSamples = BUFFER_SIZE;
        }

        if (samplesCollected < numSamples) {
            return null;  // Not enough data
        }

        var startIndex = (bufferIndex - numSamples + BUFFER_SIZE) % BUFFER_SIZE;

        var accel = new [numSamples];
        var gyro = new [numSamples];

        for (var i = 0; i < numSamples; i++) {
            var idx = (startIndex + i) % BUFFER_SIZE;
            accel[i] = accelBuffer[idx];
            gyro[i] = gyroBuffer[idx];
        }

        return {
            :accel => accel,
            :gyro => gyro
        };
    }

    // Calculate RMS of accelerometer magnitude
    function calculateRMS(numSamples) {
        var data = getRecentData(numSamples);
        if (data == null) {
            return 0.0;
        }

        var sumSq = 0.0;
        for (var i = 0; i < numSamples; i++) {
            var ax = data[:accel][i][0];
            var ay = data[:accel][i][1];
            var az = data[:accel][i][2];
            var mag = Math.sqrt(ax*ax + ay*ay + az*az);
            sumSq += mag * mag;
        }

        return Math.sqrt(sumSq / numSamples);
    }
}
