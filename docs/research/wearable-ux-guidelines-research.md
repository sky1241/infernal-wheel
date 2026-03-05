# Wearable UX Guidelines Research

> Compiled March 2026. Sources: Android Developer docs (fetched), Apple HIG (knowledge-based),
> Samsung One UI Watch docs (knowledge-based), industry best practices.

---

## 1. Accessibility on Wearables

### 1.1 TalkBack on Wear OS (Round Screens)

| Aspect | Detail |
|--------|--------|
| Navigation model | Linear swipe (left/right) to move between elements; double-tap to activate |
| List announcements | "In list" / "out of list" announcements are **removed** on Wear OS (assumes one list per screen) |
| Minimum list item height | **32 dp** (items < 32 dp may be skipped by TalkBack) |
| Off-screen handling | TalkBack avoids reading items near top/bottom edges or almost off-screen |
| Content descriptions | Avoid redundant words ("complication", "tile"); describe only visible info |
| Rotary input | Critical for TalkBack users — replaces two-finger scroll; uses RSB, rotating bezel, or touch bezel |
| Focus management | Use `PickerGroup` with focus coordinator for proper `Picker` focus assignment |
| Tiles & complications | Set `.contentDescription("text")` on tiles; use `setContentDescription()` on `ComplicationData.Builder` |

### 1.2 VoiceOver on watchOS

| Aspect | Detail |
|--------|--------|
| Navigation model | Swipe left/right with one finger to move between elements; double-tap to activate |
| Digital Crown | Acts as scroll/rotor control; VoiceOver rotor adjusts what Crown controls |
| Haptic feedback | Taptic Engine pulses on each element focus change |
| Screen curtain | Supported — turns off display for privacy while VoiceOver active |
| Handoff | Can hand off VoiceOver reading to paired iPhone for longer content |
| Complications | Each complication is a VoiceOver element with spoken label |
| AssistiveTouch | Enables one-handed gesture control (clench, double-clench, pinch) for motor disabilities |

### 1.3 Touch Target Sizes

| Platform | Standard minimum | Accessibility minimum | Notes |
|----------|------------------|-----------------------|-------|
| Wear OS | **48 x 48 dp** | **48 x 48 dp** (no exception) | Quality guideline WO-V2 mandates 48 dp |
| Wear OS (compact) | **40 x 40 dp** allowed | Must still have 48 dp tap target with padding | Per accessibility docs |
| watchOS | **38 x 38 pt** (Apple minimum) | **44 x 44 pt** recommended | Apple HIG for watch |
| Extra-small buttons | **32 x 32 dp** visual | **48 x 48 dp** tap target required via padding | Wear OS Material 3 |

### 1.4 High Contrast Mode

| Platform | Feature | Detail |
|----------|---------|--------|
| Wear OS | Material 3 Expressive | **28+ color roles** with built-in accessible color contrast relationships |
| Wear OS | Background | **Always black** (`#000000`) — all apps must use black backgrounds (WO-V13) |
| Wear OS | Semantic colors | Red = error, Green = success; must meet contrast compliance on small screens |
| watchOS | Bold Text | System-wide toggle increases font weight |
| watchOS | Increase Contrast | Reduces transparency, increases color contrast |
| watchOS | Reduce Motion | Simplifies animations and auto-play |
| watchOS | On/Off Labels | Adds I/O labels to toggles (not just color) |

### 1.5 Font Scaling on Watches

| Platform | Aspect | Value |
|----------|--------|-------|
| Wear OS | User setting | Settings > Accessibility > Font Size |
| Wear OS | Minimum essential text | **12 sp** (quality requirement WO-V14) |
| Wear OS | Minimum non-essential text | **10 sp** (quality requirement WO-V14) |
| Wear OS | Scaling cap | **Fonts >= 20 sp are NOT scaled** (limited screen space) |
| Wear OS | Implementation | Use `TextAutoSize` with explicit `minFontSize` and `maxFontSize` |
| Wear OS | Overflow | Use ellipsis (Material text elements use overflow ellipsis by default) |
| watchOS | Dynamic Type | Supported with limited range; system fonts scale automatically |
| watchOS | Scaling range | Roughly -2 to +5 steps from default (fewer steps than iPhone) |

### 1.6 Haptic Feedback as Accessibility Aid

| Platform | Feature | Use Case |
|----------|---------|----------|
| Wear OS | `VibrationEffect` | Confirm actions, alert errors, signal transitions |
| Wear OS | Rotary haptics | Detent-style ticks when scrolling via crown/bezel |
| watchOS | Taptic Engine | 9 haptic types: notification, directionUp, directionDown, success, failure, retry, start, stop, click |
| watchOS | VoiceOver haptics | Automatic pulse when focus changes between elements |
| watchOS | Crown haptics | Detent feedback during scrolling |
| Both | Best practice | Pair every visual state change with a haptic; never rely on haptics alone |

### 1.7 Screen Reader Navigation Patterns

| Pattern | Wear OS (TalkBack) | watchOS (VoiceOver) |
|---------|--------------------|--------------------|
| Linear navigation | Swipe left/right | Swipe left/right |
| Activate element | Double-tap | Double-tap |
| Scroll | Rotary input (RSB/bezel) | Digital Crown |
| Back/dismiss | Swipe right from left edge | Two-finger Z gesture |
| Read all | N/A (too much for watch) | Two-finger swipe down |
| Adjust values | Rotary after selecting | Crown after selecting via rotor |
| Container grouping | `contentDescription` on parent | `accessibilityElement(children: .combine)` |

### 1.8 Motor Disability Accommodations

| Feature | Platform | Detail |
|---------|----------|--------|
| Rotary input | Wear OS | Alternative to touch for users with tremors/limited dexterity |
| AssistiveTouch | watchOS | Hand gestures (clench, pinch) to navigate without touching screen |
| Touch accommodations | watchOS | Hold Duration, Ignore Repeat settings |
| Large touch targets | Both | 48 dp / 44 pt minimum; larger is always better |
| Swipe-to-dismiss | Wear OS | Full-screen swipe gesture (easier than finding small back button) |
| Button sizes | Wear OS | Large buttons: **60 x 60 dp**; Default: **52 x 52 dp** |
| Voice control | Both | Dictation input for text fields |
| Reduce motion | watchOS | Simplifies animations for vestibular sensitivity |

### 1.9 Color Blindness on Tiny Screens

| Guideline | Detail |
|-----------|--------|
| Never use color alone | Always pair with icons, patterns, or text labels |
| Semantic color + icon | Error: red + warning icon; Success: green + checkmark |
| Safe palette | Blue/orange is safest across all color blindness types |
| Avoid | Red/green adjacency without additional differentiation |
| OLED advantage | True black background provides maximum contrast with any accent |
| Testing | Simulate deuteranopia, protanopia, tritanopia; Wear OS emulator supports color filters |
| Minimum colors | Use 3-4 accent colors max on watch (screen too small for more) |
| Material 3 | Built-in accessible color relationships handle common cases |

---

## 2. Onboarding on Watches

### 2.1 First-Run Experience Patterns

| Pattern | Description | When to use |
|---------|-------------|-------------|
| Immediate value | Show primary function immediately, no onboarding screens | Utility apps, simple tools |
| Single welcome screen | One screen with app icon + brief tagline | Apps needing minimal context |
| Progressive disclosure | Reveal features as user encounters them | Complex apps |
| Inline education | Contextual hints overlaid on real UI | Feature discovery |
| Skip option | Always provide "Skip" or swipe-to-dismiss | All onboarding flows |
| Max screens | **2-3 screens maximum** for onboarding on watch | Industry best practice |

### 2.2 Permission Requests on Watch

| Principle | Detail |
|-----------|--------|
| Timing: Ask in context | Request when user triggers related feature (highest grant rate) |
| Timing: Educate in context | Show rationale when connection to feature isn't obvious |
| Deny handling | After 2 denials, system shows "Deny, don't show again"; future requests only via Settings |
| Cross-device | Watch permissions are **independent** from phone permissions; must request separately |
| Services | Cannot request permissions from services — must open an activity first |
| Watch faces | Do NOT request permissions directly; use complications instead |
| Companion profiles | Android 12+ (API 31+): Use `CompanionDeviceManager` to bundle permissions in one request |
| Graceful degradation | Provide meaningful functionality without permissions; show lock icons for disabled features |
| Check every use | Call `ContextCompat.checkSelfPermission()` before every use; user may have revoked |

### 2.3 Key Wearable Permissions

| Permission | Type | Notes |
|------------|------|-------|
| `BODY_SENSORS` | Dangerous (runtime) | Heart rate, SpO2; request only when user initiates health feature |
| `ACTIVITY_RECOGNITION` | Dangerous (runtime) | Step counting, activity detection; needed for background tracking |
| `ACCESS_FINE_LOCATION` | Dangerous (runtime) | GPS on watch; auto-syncs between phone and watch |
| `ACCESS_COARSE_LOCATION` | Dangerous (runtime) | Network-based location |
| `POST_NOTIFICATIONS` | Dangerous (API 33+) | Required for notifications on Wear OS 4+ |
| `WAKE_LOCK` | Normal | Keep processor awake during workouts |
| `FOREGROUND_SERVICE` | Normal | Required for ongoing activities |
| `RECEIVE_BOOT_COMPLETED` | Normal | Re-register sensors after reboot |

### 2.4 Pairing Flow (Watch + Phone)

| Step | Detail |
|------|--------|
| 1. Discovery | Watch broadcasts via BLE; phone discovers via Wear OS companion app |
| 2. Phone app detection | Use `PhoneTypeHelper.getPhoneDeviceType()`: returns `DEVICE_TYPE_ANDROID`, `DEVICE_TYPE_IOS`, `DEVICE_TYPE_UNKNOWN`, `DEVICE_TYPE_ERROR` |
| 3. Capability exchange | Define capability strings in `res/values/wear.xml` for mutual detection |
| 4. Bandwidth note | Bluetooth LE limited to **~4 KB/s**; audit requests, shrink images |
| 5. Standalone fallback | Standalone apps must work without phone; "Open on phone" only if alternative exists (shortlinks, QR codes) |
| 6. Missing companion | Non-standalone watch apps can install before companion; detect and prompt user |
| 7. Authentication | **No username/password input on watch** (quality requirement WO-P6); use phone-based OAuth, QR code, or companion auth |

### 2.5 Tutorial/Coach Marks on Tiny Screens

| Best Practice | Detail |
|---------------|--------|
| Keep it minimal | 1-2 sentences max per screen |
| Use animation | Short looping animation showing the gesture (e.g., swipe gesture demo) |
| Dismissible | Tap or swipe to dismiss; never block the UI |
| One concept per screen | Never combine multiple instructions |
| Show, don't tell | Prefer animated gesture demos over text instructions |
| Contextual timing | Show hint when user first encounters the feature, not at app launch |
| Don't repeat | Show once, or offer a "Help" section for re-discovery |

### 2.6 Progressive Disclosure on Wearables

| Level | Content | Example |
|-------|---------|---------|
| Glanceable | Primary metric + status | "3 cigarettes today" |
| Tap for detail | Secondary metrics, charts | Daily trend, time since last |
| Long-press / menu | Settings, configuration | Change goals, adjust alerts |
| Phone handoff | Complex configuration | Detailed history, export data |

### 2.7 Explaining ML Features to Users

| Guideline | Detail |
|-----------|--------|
| Transparent language | "We detect [action] using your watch sensors" |
| Accuracy framing | "This works best when..." + limitations |
| User control | Always allow manual correction/override |
| Privacy first | "Data stays on your watch" or "Data is processed on-device" |
| Opt-in | ML features should be opt-in, not opt-out, especially for sensitive detection |
| Feedback loop | "Was this correct?" after detection, with easy yes/no |
| Example phrasing | "Your watch uses motion and heart rate patterns to detect smoking. You can always add or remove entries manually." |

---

## 3. Internationalization on Tiny Screens

### 3.1 Text Truncation Strategies

| Strategy | When to use | Implementation |
|----------|-------------|----------------|
| Ellipsis (end) | Default for most text | `overflow: ellipsis` (Material default) |
| Ellipsis (middle) | File names, long identifiers | `TextOverflow.Ellipsis` with custom logic |
| Abbreviation | Known terms | "Mon" not "Monday"; "Jan" not "January" |
| Icon replacement | When universal symbol exists | Replace "Settings" with gear icon |
| Auto-sizing text | Headlines, primary metrics | `TextAutoSize` with `minFontSize` / `maxFontSize` |
| Multi-line wrap | Body text only | Max 2-3 lines on watch; then truncate |
| Scroll | Long content | `ScalingLazyColumn` for scrollable content |

### 3.2 RTL Layout on Round Screens

| Aspect | Guideline |
|--------|-----------|
| Mirroring | Mirror horizontal layouts (swap left/right alignment) |
| Navigation | Swipe directions should NOT mirror (back = swipe right universally) |
| Arc text | Direction reverses for RTL; text flows right-to-left along arc |
| Icons | Directional icons (arrows, back) mirror; symmetric icons do not |
| Lists | Text alignment flips; icons stay on leading edge (right side for RTL) |
| Complications | Position mirroring depends on watch face; data provider should be agnostic |
| Percentage margins | Work correctly for both LTR and RTL when using `start`/`end` instead of `left`/`right` |
| Testing | Test with Arabic/Hebrew on emulator; check for clipping on round edges |

### 3.3 Character Density Differences

| Language | Expansion vs English | Watch impact |
|----------|---------------------|--------------|
| German | +30-35% longer | Frequent truncation; heavy abbreviation needed |
| French | +15-20% longer | Moderate truncation risk |
| Finnish | +30-40% longer | Similar to German |
| Chinese | -30-50% shorter (characters) | Fits well; but characters need **larger font size** for legibility (~14 sp min) |
| Japanese | -20-40% shorter | Similar to Chinese; needs larger font |
| Korean | -10-20% shorter | Moderate density advantage |
| Arabic | -20-30% shorter | Connected script; needs adequate line height |
| Thai | Similar length | Requires extra vertical space for stacking diacritics |
| Design buffer | Plan for **+40% text expansion** from English baseline | Industry standard |

### 3.4 Date/Time Format on Complications

| Format | Example | Notes |
|--------|---------|-------|
| Short time | `3:45` / `15:45` | Respect system 12/24h setting |
| Short date | `3/5` / `5.3.` / `3月5日` | Use `DateFormat.getDateInstance(SHORT)` |
| Day of week | `Thu` / `Do` / `木` | Abbreviated; 1-3 chars depending on locale |
| Relative time | `2h ago` / `vor 2 Std.` | Compact relative formatters |
| Duration | `1:23:45` | Universal numeric format |
| Complication best practice | Numeric-heavy, minimal text | Reduces localization burden |
| Locale API | `DateTimeFormatter` / `NSDateFormatter` | Always use system formatters, never hardcode |

### 3.5 Number Formatting in Small Spaces

| Aspect | Detail |
|--------|--------|
| Decimal separator | `.` (English) vs `,` (German/French) vs `٫` (Arabic) |
| Thousands separator | `,` vs `.` vs ` ` (thin space) |
| Compact notation | `1.2K` / `1,2 Tsd.` — use `CompactDecimalFormat` |
| Percentage | `85%` — symbol position varies by locale (before or after) |
| Currency | Avoid on watch; if needed, use symbol not code (`$` not `USD`) |
| Units | Abbreviate: `km`, `mi`, `bpm`, `cal` |
| Tabular figures | Use monospaced/tabular numbers for animations and counters |
| Right-to-left digits | Arabic-Indic numerals (٠١٢٣٤٥٦٧٨٩) vs Western Arabic (0123456789) — respect locale |

### 3.6 Icon-First vs Text-First Design

| Approach | Pros | Cons | Best for |
|----------|------|------|----------|
| Icon-first | Language-independent; faster glance | Ambiguous without learning | Actions (play, stop, settings) |
| Text-first | Unambiguous | Truncation in long languages | Labels, status descriptions |
| Icon + short label | Best of both | Takes more space | Primary navigation, key actions |
| Recommended for watch | **Icon-first with optional label** | — | Most wearable UIs |
| Label sizing | Icon: **24-26 dp**; Label below: **12 sp** | — | Wear OS standard |

---

## 4. App Distribution

### 4.1 Google Play for Wear OS

| Requirement | Detail |
|-------------|--------|
| Target API level | **Android 14 (API 34+)** as of August 31, 2025 |
| `uses-feature` | `android.hardware.type.watch` (required, must NOT be `required="false"`) |
| Standalone metadata | `com.google.android.wearable.standalone` = `true` or `false` |
| Package name | **Same package name** as mobile app (if exists) |
| App signing | Same signing key for watch and phone APKs |
| Screenshots | At least **1 Wear OS screenshot**, **1:1 aspect ratio**, no device frames, no transparent backgrounds |
| Description | Must mention **"Wear OS"** (not "Android Wear"); list main features; mention tiles/complications; localized |
| Version code | Unique across all form factors; recommended scheme: `36[targetSdk][product][release][version]` |
| App bundle | Use Android App Bundle for optimized APK delivery |
| Testing | Firebase Test Lab supports Pixel Watch devices |
| Review process | Pending → Approved → Not Approved; check in Play Console under Pricing & Distribution |

### 4.2 App Size Limits

| Platform | Limit | Detail |
|----------|-------|--------|
| Wear OS APK | **No hard size limit** but strongly recommended < 30 MB | Bluetooth transfer is ~4 KB/s; larger = terrible install experience |
| Wear OS App Bundle | Optimized per-device APKs reduce size | Use density/ABI splits |
| Watch Face XML | **<= 10 MB** source file | Quality requirement WO-G11 |
| Watch Face assets (ambient) | **<= 10 MB** | Quality requirement WO-P8 |
| Watch Face assets (interactive) | **<= 100 MB** | Quality requirement WO-P8 |
| watchOS app | **< 75 MB** recommended (on-watch install limit was historically 50 MB, relaxed in watchOS 10+) | Apple Watch has limited storage |

### 4.3 Standalone vs Companion App

| Aspect | Standalone | Non-Standalone (Companion) |
|--------|-----------|---------------------------|
| Phone required | No | Yes, for core features |
| Untethered device support | Yes | No |
| Manifest value | `standalone = true` | `standalone = false` |
| Auth approach | QR code, shortlink, companion device profile | Phone-based OAuth flow |
| Installation order | Independent | Watch app can install before phone app |
| Play Store visibility | Full visibility | Not shown on untethered watches |
| Best practice | Preferred for all new apps | Only when phone interaction is essential |

### 4.4 Samsung Galaxy Store Specifics

| Aspect | Detail |
|--------|--------|
| Store | Samsung Galaxy Store (separate from Google Play) |
| Wear OS apps | Since Galaxy Watch 4+, Samsung uses Wear OS; submit to Google Play |
| One UI Watch | Samsung's design layer on top of Wear OS; apps should follow both Material and One UI guidelines |
| Exclusive features | Rotating bezel (Galaxy Watch hardware); support via rotary input APIs |
| Watch face distribution | Samsung Watch Face Studio or Watch Face Format (WFF) |
| Testing | Test on Galaxy Watch emulator images in Android Studio |
| Galaxy-specific APIs | Samsung Health SDK for deeper health integration |

### 4.5 App Review Guidelines Specific to Wearables

| Common Rejection Reason | Detail |
|------------------------|--------|
| Missing "Wear OS" in listing | Must appear in Play Store description |
| Broken round display rendering | Layout must work on round screens ≥ 192 dp |
| Screenshots don't match app | Must accurately reflect actual functionality |
| Missing Wear screenshot | At least 1 required |
| No `RemoteInput` for messaging | Messaging apps must support `RemoteInput` |
| Username/password on watch | Not allowed (WO-P6); must use alternative auth |
| No black background | All apps must use black backgrounds (WO-V13) |
| Always-on > 15% pixel illumination | Watch faces must not exceed 15% lit pixels in ambient (WO-P7) |

---

## 5. Design Systems for Wearables

### 5.1 Material Design for Wear OS (Material 3 Expressive)

| Component | Detail |
|-----------|--------|
| Library | `androidx.wear.compose:compose-material3:1.5.6` |
| Foundation | `androidx.wear.compose:compose-foundation:1.5.6` |
| Navigation | `androidx.wear.compose:compose-navigation:1.5.6` |
| UI Tooling | `androidx.wear.compose:compose-ui-tooling:1.5.6` |
| BOM | `androidx.compose:compose-bom:2026.02.01` |
| Minimum API | API 25 (Wear OS 2.0); Recommended API 30+ (Wear OS 3.0+) |
| Kotlin requirement | Kotlin 1.9.0+ |
| Design kit | Figma community file available |
| Key rule | **Never mix mobile and Wear Compose Material** in the same project |

### 5.2 Horologist Library

| Aspect | Detail |
|--------|--------|
| Purpose | Google's companion library adding missing Wear OS Compose functionality |
| Key modules | `horologist-compose-layout` — opinionated `ScalingLazyColumn` with correct margins |
| | `horologist-compose-material` — enhanced Material components (Chip, ToggleChip, Title) |
| | `horologist-media-ui` — media player UI components |
| | `horologist-auth-ui` — authentication UI screens |
| | `horologist-datalayer` — simplified phone↔watch communication |
| | `horologist-tiles` — tile building helpers |
| | `horologist-health-composables` — health/fitness UI components |
| Value add | Handles round screen margins, scroll indicators, font scaling correctly out of the box |
| Source | `github.com/google/horologist` |

### 5.3 Samsung One UI Watch Design System

| Aspect | Detail |
|--------|--------|
| Base | Wear OS + Samsung One UI overlay |
| Key difference | Rotating bezel support (physical hardware) |
| Typography | Samsung One font family; follows Material sizing but with Samsung metrics |
| Color | Samsung color palette; emphasizes blue accent (#1472FF) |
| Components | Samsung-specific extensions: circular progress, rotating bezel list |
| Device sizes | Galaxy Watch 4: 40mm (396x396 px, 1.2"), 44mm (450x450 px, 1.36") |
| | Galaxy Watch 5 Pro: 45mm (450x450 px, 1.36") |
| | Galaxy Watch 6: 40mm (432x432 px, 1.3"), 44mm (480x480 px, 1.43") |
| | Galaxy Watch Ultra: 47mm (480x480 px, 1.47") |

### 5.4 Apple Watch Design Resources

| Aspect | Detail |
|--------|--------|
| Framework | SwiftUI (primary), WatchKit (legacy) |
| Design tool | Sketch/Figma templates from Apple Design Resources |
| Screen sizes | Series 9/10 41mm: 352x430 px (176x215 pt @2x) |
| | Series 9/10 45mm: 396x484 px (198x242 pt @2x) |
| | Ultra 2 49mm: 410x502 px (205x251 pt @2x) |
| | SE 40mm: 324x394 px (162x197 pt @2x) |
| Navigation | `NavigationStack`, `TabView`, page-based |
| Minimum touch target | **44 x 44 pt** recommended (38 pt absolute minimum) |
| Complications | ClockKit (legacy) → WidgetKit (watchOS 10+) |
| Digital Crown | Primary scroll/adjust input; haptic detents |

### 5.5 Color Palettes for OLED

| Guideline | Detail |
|-----------|--------|
| Background | **Always true black (`#000000`)** — mandatory for Wear OS (WO-V13) |
| Reason | OLED pixels are physically off at `#000000`; saves battery, infinite contrast |
| Primary accent | Bright, saturated colors work best on black (Material 3 "Primary" role) |
| Secondary/tertiary | Use for hierarchy; less saturated than primary |
| Surface container | Slightly elevated gray (`#1C1C1E` to `#2C2C2E` range) for cards/dialogs |
| Error | Red tones (Material 3 "Error" role) |
| Success | Green tones |
| On-surface text | White or near-white on black |
| Ambient mode | Muted colors; max **15% pixel illumination** |
| Avoid | Pure white backgrounds (battery drain, eye strain); large bright color fills |
| Material 3 tokens | 28+ color roles with built-in dark theme and accessibility contrast |
| Dynamic color | Support system/watch face theme colors and image-based themes |
| Always-on display | Use outlines instead of fills; white/gray on black |

### 5.6 Typography Scale for Watches

| Role | Purpose | Approx. Size (sp) | Scaling behavior |
|------|---------|-------------------|-----------------|
| Display Large | Hero numbers (countdown, primary metric) | 40-50 sp | **No scaling** (≥ 20 sp) |
| Display Medium | Secondary hero | 34-40 sp | **No scaling** |
| Display Small | Tertiary hero | 28-34 sp | **No scaling** |
| Title Large | Page titles | 20-22 sp | **No scaling** (≥ 20 sp) |
| Title Medium | Section headers | 16-18 sp | Scales with user preference |
| Title Small | Subsection headers | 14-16 sp | Scales with user preference |
| Label Large | Button labels, chips | 15-16 sp | Partial scaling |
| Label Medium | Secondary labels | 12-14 sp | Partial scaling |
| Label Small | Tertiary labels | 11-12 sp | Partial scaling |
| Body Large | Primary body text | 16 sp | Scales with user preference |
| Body Medium | Standard body text | 14 sp | Scales with user preference |
| Body Small | Captions, footnotes | 12 sp | Scales with user preference |
| Arc | Curved page titles | 14-16 sp | Scales with user preference |
| Numeral Large | Animated number displays | 40-50 sp | **No scaling** |
| Numeral Medium | Counters, timers | 30-38 sp | **No scaling** |
| Numeral Small | Small data points | 20-24 sp | **No scaling** |
| **Minimum essential** | — | **12 sp** | Quality requirement |
| **Minimum non-essential** | — | **10 sp** | Quality requirement |
| Default typeface | Roboto Flex (variable font) | — | Supports dynamic weight/width axis |

**Key rule:** Fonts ≥ 20 sp are **never scaled** by user font size preference (Wear OS limitation for screen space).

### 5.7 Icon Sizes for Watch

#### Wear OS

| Icon type | Size | Notes |
|-----------|------|-------|
| Launcher icon | **48 x 48 dp** (rendered) | Adaptive icon: 108 x 108 dp full asset with safe zone |
| Splash screen icon | **48 x 48 dp** | Must match launcher icon; displayed on black background (WO-V15) |
| In-app action icons | **24 x 24 dp** (in default button) | Inside 52 x 52 dp button container |
| | **26 x 26 dp** (in default button) | Material 3 spec |
| | **30 x 30 dp** (in large button) | Inside 60 x 60 dp button container |
| | **24 x 24 dp** (in small/XS button) | Inside 48 or 32 dp button container |
| Complication icon (monochromatic) | **24 x 24 dp** recommended | Single-color tinted by watch face |
| Complication icon (small image) | Provider-dependent | Typically 48-64 dp |
| Status bar icon | **24 x 24 dp** | Monochrome, no padding |
| Notification icon | **24 x 24 dp** | Monochrome; large icon **48 x 48 dp** |

#### watchOS (Apple Watch)

| Icon type | Size (pt) | Size (px @2x) |
|-----------|-----------|----------------|
| App icon (38mm legacy) | 80 x 80 pt | 160 x 160 px |
| App icon (40-41mm) | 88 x 88 pt | 176 x 176 px |
| App icon (44-45mm) | 100 x 100 pt | 200 x 200 px |
| App icon (49mm Ultra) | 108 x 108 pt | 216 x 216 px |
| Complication (circular small) | 32 x 32 pt | 64 x 64 px |
| Complication (modular small) | 52 x 52 pt | 104 x 104 px |
| Complication (graphic circular) | 84 x 84 pt | 168 x 168 px |
| Short Look notification icon | 24 x 24 pt | 48 x 48 px |

---

## 6. Screen Size Reference

### Wear OS Devices

| Breakpoint | Range | Example devices |
|------------|-------|-----------------|
| Small round | **192 dp – 224 dp** | Pixel Watch (1.2"), older devices |
| Large round | **225 dp – 240+ dp** | Pixel Watch 2 (1.2"), Galaxy Watch 6 44mm (1.43") |
| Primary breakpoint | **225 dp** | Threshold between small and large |
| Emulator (small) | **192 dp** (1.2" round) | Minimum design target |
| Emulator (large) | **227 dp** (1.39" round) | Large device test target |

### watchOS Devices (px / pt)

| Device | Resolution | Density |
|--------|-----------|---------|
| Apple Watch SE (40mm) | 324 x 394 px | @2x |
| Apple Watch Series 9/10 (41mm) | 352 x 430 px | @2x |
| Apple Watch Series 9/10 (45mm) | 396 x 484 px | @2x |
| Apple Watch Ultra 2 (49mm) | 410 x 502 px | @2x |

---

## 7. Key Numerical Reference (Quick Lookup)

```
TOUCH TARGETS
  Wear OS minimum:          48 x 48 dp (quality requirement)
  Wear OS compact:          40 x 40 dp (with 48dp tap area)
  watchOS recommended:      44 x 44 pt
  Extra-small button visual: 32 x 32 dp (must have 48dp tap padding)

FONT SIZES
  Minimum essential text:   12 sp (Wear OS)
  Minimum non-essential:    10 sp (Wear OS)
  Scaling cap:              >= 20 sp fonts do NOT scale
  Body default:             14 sp
  Display (hero numbers):   40-50 sp

BUTTONS (Wear OS Material 3)
  Large:                    60 x 60 dp container, 30 x 30 dp icon
  Default:                  52 x 52 dp container, 26 x 26 dp icon
  Small:                    48 x 48 dp container, 24 x 24 dp icon
  Extra-small:              32 x 32 dp container, 24 x 24 dp icon

ICONS
  Launcher (Wear OS):       48 x 48 dp (adaptive: 108 x 108 dp asset)
  Action icons:             24-26 dp
  Complication mono:        24 x 24 dp

SCREEN SIZES
  Wear OS small:            192 dp
  Wear OS breakpoint:       225 dp
  Wear OS large:            227-240+ dp

LIST SPACING (Wear OS)
  Between sections:         16 dp
  Between titles/content:   12 dp
  Between slots:            16 dp
  Between groups:           8 dp
  Between elements:         4 dp
  Side margins:             5.2%
  Title internal margin:    7.3%
  Min list item height:     32 dp (TalkBack requirement)

CARDS (Wear OS)
  Max height before clip:   60% of screen height
  Gradient padding top:     68 dp
  Image overlay padding:    56 dp top, 24 dp bottom

APP DISTRIBUTION
  Target API:               Android 14 (API 34+)
  Screenshots:              >= 1, 1:1 aspect ratio
  Ambient pixel budget:     <= 15% illumination
  Watch face memory:        10 MB ambient / 100 MB interactive
  Max complication slots:   8
  XML source limit:         10 MB
  BLE bandwidth:            ~4 KB/s
  Recommended APK size:     < 30 MB

FONT SCALING RULE
  < 20 sp:                  Scales with user preference
  >= 20 sp:                 NEVER scales (fixed)
```

---

## Sources

- Android Developer: Wear OS Accessibility — https://developer.android.com/training/wearables/accessibility
- Android Developer: Wear OS App Quality Guidelines — https://developer.android.com/docs/quality-guidelines/wear-app-quality
- Android Developer: Wear OS Standalone Apps — https://developer.android.com/training/wearables/apps/standalone-apps
- Android Developer: Wear OS Permissions — https://developer.android.com/training/wearables/apps/permissions
- Android Developer: Wear OS Color Design — https://developer.android.com/design/ui/wear/guides/styles/color
- Android Developer: Wear OS Typography — https://developer.android.com/design/ui/wear/guides/styles/typography
- Android Developer: Wear OS Buttons — https://developer.android.com/design/ui/wear/guides/components/buttons
- Android Developer: Wear OS Cards — https://developer.android.com/design/ui/wear/guides/components/cards
- Android Developer: Wear OS Lists — https://developer.android.com/design/ui/wear/guides/components/lists
- Android Developer: Wear OS Screen Sizes — https://developer.android.com/design/ui/wear/guides/m2-5/foundations/screen-sizes
- Android Developer: Wear OS Compose — https://developer.android.com/training/wearables/compose
- Android Developer: Google Play Wear OS Distribution — https://developer.android.com/distribute/google-play/wear
- Apple Developer: Human Interface Guidelines (watchOS) — https://developer.apple.com/design/human-interface-guidelines/designing-for-watchos
- Google Horologist Library — https://github.com/google/horologist
