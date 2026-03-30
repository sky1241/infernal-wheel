# Privacy Policy — InfernalWheel

**Last updated**: 2026-03-30

## Overview

InfernalWheel is a personal addiction tracking app. **All your data stays on your device.** We do not collect, transmit, or store any data on external servers.

## Data Collection

**We collect NO data.** The app:
- Does NOT connect to any external server
- Does NOT require an internet connection
- Does NOT have user accounts
- Does NOT use analytics or tracking
- Does NOT share data with third parties
- Does NOT display ads

## Data Storage

All data is stored locally on your device:
- **Encryption**: All data is encrypted with AES-256-GCM
- **PIN protection**: A 4-6 digit PIN protects access to your data
- **Key storage**: Encryption keys are stored in the Android Keystore (hardware-backed)
- **No cloud sync**: There is no cloud backup or synchronization

## Data Types Stored (locally only)

- Time tracking (work, sleep, breaks)
- Cigarette/addiction counts
- Alcohol consumption logs
- Personal notes
- App settings and preferences

## Data Export

You can export your data as an encrypted backup file for device migration. This file is protected by a password you choose.

## Data Deletion

Uninstalling the app permanently deletes all data. There is no way to recover it.

## Permissions

- **INTERNET**: Required only for the local HTTP server (localhost communication between app components). No external network traffic.
- **FOREGROUND_SERVICE**: Required to keep the timer running when the app is in the background.
- **POST_NOTIFICATIONS**: Required to alert you when a timer expires.
- **WAKE_LOCK**: Required for accurate timer operation when the screen is off.

## Children's Privacy

This app is not intended for use by children under 18.

## Changes

We may update this policy. Changes will be reflected in the app's next update.

## Contact

For questions about this privacy policy, open an issue at:
https://github.com/sky1241/infernal-wheel/issues
