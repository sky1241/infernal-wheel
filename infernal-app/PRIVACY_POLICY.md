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
- **Local-only**: All data stays on your device — no server, no cloud, no sync.
- **Backup disabled**: Android auto-backup to Google Drive is OFF by default
  (allowBackup="false" in the manifest), so your data will NOT be uploaded
  to any third-party service even if you have Android backup enabled
  globally.
- **Note on encryption**: This release stores your data as plain JSON/CSV
  files in the app's private storage area (only your own apps with root
  access can read them). A previous version of this document stated
  "encrypted with AES-256-GCM" — that claim was inaccurate and has been
  removed. End-to-end encryption is on the roadmap and will be reinstated
  with explicit notice when shipped (BUG+018 in our internal tracker).

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
