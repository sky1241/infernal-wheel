# Local libraries — Samsung Health Sensor SDK

## What goes here

Drop the **Samsung Health Sensor SDK** AAR file into this folder to enable
parasitic 25Hz accelerometer access on Galaxy Watch.

Expected file name: `samsung-health-sensor-sdk.aar`
(any `*.aar` works — the gradle script picks them all up via `fileTree`)

## How to get the AAR

1. Create a free Samsung developer account: https://developer.samsung.com
2. Go to https://developer.samsung.com/health/sensor/overview.html
3. Click "Download SDK"
4. Accept the license agreement
5. Extract the zip and copy the `.aar` into this folder
6. Re-sync gradle in Android Studio

## What happens if the AAR is missing

The build still works. `SamsungHealthAccelerometer.kt` detects the missing
SDK at runtime via `Class.forName()` reflection and logs a warning. Phase 1
(SensorManager 50Hz boost mode) keeps working. Phase 2 (Samsung 25Hz flow)
silently disables itself.

## After adding the AAR

You also need to:
1. Open `SamsungHealthAccelerometer.kt`
2. Uncomment the imports + REAL IMPLEMENTATION blocks
3. Rebuild

The wrapper class is intentionally a stub today so the project compiles
out of the box for any contributor without a Samsung dev account.
