# Wear OS Navigation & State Management Patterns

> Official patterns from developer.android.com. Researched 2026-03-05.

---

## Table of Contents

1. [SwipeDismissableNavHost](#1-swipedismissablenavhost)
2. [HorizontalPager & Page Indicators](#2-horizontalpager--page-indicators)
3. [Ongoing Activity API](#3-ongoing-activity-api)
4. [Deep Linking](#4-deep-linking)
5. [State Restoration](#5-state-restoration)
6. [Offline-First Patterns](#6-offline-first-patterns)
7. [App Shortcuts & Tiles](#7-app-shortcuts--tiles)
8. [Rotary Input](#8-rotary-input)

---

## 1. SwipeDismissableNavHost

**Source:** [Navigation with Compose for Wear OS](https://developer.android.com/training/wearables/compose/navigation)

### Dependency

```kotlin
dependencies {
    // Use THIS, NOT androidx.navigation:navigation-compose
    val wear_compose_version = "1.5.6"
    implementation("androidx.wear.compose:compose-navigation:$wear_compose_version")
}
```

### Core APIs

| API | Purpose |
|-----|---------|
| `rememberSwipeDismissableNavController()` | Creates `WearNavigator` (Wear OS `NavController`) |
| `SwipeDismissableNavHost` | Wear OS navigation host with swipe-to-dismiss |
| `AppScaffold` | Top-level container (time, scroll/position indicators, page indicator) |
| `ScreenScaffold` | Screen-level composable adding `TimeText` and `PositionIndicator` |

### Complete Example

```kotlin
AppScaffold {
    val navController = rememberSwipeDismissableNavController()
    SwipeDismissableNavHost(
        navController = navController,
        startDestination = "message_list"
    ) {
        composable("message_list") {
            MessageList(onMessageClick = { id ->
                navController.navigate("message_detail/$id")
            })
        }
        composable("message_detail/{id}") {
            MessageDetail(id = it.arguments?.getString("id")!!)
        }
    }
}

@Composable
fun MessageDetail(id: String) {
    val scrollState = rememberTransformingLazyColumnState()
    val padding = rememberResponsiveColumnPadding(
        first = ColumnItemType.BodyText
    )
    ScreenScaffold(
        scrollState = scrollState,
        contentPadding = padding
    ) { scaffoldPaddingValues ->
        // Screen content goes here
    }
}
```

### Key Rules

- Always wrap `SwipeDismissableNavHost` inside `AppScaffold`
- Use `ScreenScaffold` inside each screen composable
- The `startDestination` must be provided in the navigation graph builder

---

## 2. HorizontalPager & Page Indicators

**Source:** [Page indicators](https://developer.android.com/training/wearables/compose/pagination) | [Wear Compose releases](https://developer.android.com/jetpack/androidx/releases/wear-compose)

### Core APIs (Material 3)

| API | Purpose |
|-----|---------|
| `HorizontalPagerScaffold` | Coordinates pager + page indicator + time text |
| `VerticalPagerScaffold` | Same, vertical orientation |
| `HorizontalPageIndicator` | Curved dot indicator on round displays |
| `AnimatedPage` | Wraps page content with enter/exit animations |
| `rememberPagerState()` | State holder for pager |

### HorizontalPagerScaffold Signature (M3)

```kotlin
androidx.wear.compose.material3.HorizontalPagerScaffold(
    pagerState: PagerState,
    modifier: Modifier = Modifier,
    pageIndicator: @Composable () -> Unit,
    animationSpec: AnimationSpec = ...,
    rotaryScrollableBehavior: RotaryScrollableBehavior,
    content: @Composable (page: Int) -> Unit
)
```

### AnimatedPage Signature (M3)

```kotlin
androidx.wear.compose.material3.AnimatedPage(
    page: Int,
    pagerState: PagerState,
    backgroundColor: Color,
    content: @Composable () -> Unit
)
```

### VerticalPagerScaffold Example

```kotlin
AppScaffold {
    val pagerState = rememberPagerState(pageCount = { 10 })
    VerticalPagerScaffold(pagerState = pagerState) {
        VerticalPager(state = pagerState) { page ->
            AnimatedPage(pageIndex = page, pagerState = pagerState) {
                ScreenScaffold {
                    // Page content
                }
            }
        }
    }
}
```

### HorizontalPageIndicator Rules

- On round displays, indicator is **curved**
- **Maximum 6 dots** regardless of screen size
- Centre of dot circumference aligns near circular grid for optical balance
- Curve angle changes slightly as screen size increases
- Anatomy: active indicator (B) + inactive indicators (A)

### Navigation Notes

- Horizontal paging uses horizontal swipe
- Must support **swipe-to-dismiss for the left edge**
- Rotary input navigates pagers automatically with scaffolds

---

## 3. Ongoing Activity API

**Source:** [Display ongoing activities](https://developer.android.com/training/wearables/notifications/ongoing-activity) | [Ongoing Activity codelab](https://developer.android.com/codelabs/ongoing-activity)

### Dependencies

```kotlin
dependencies {
    implementation("androidx.wear:wear-ongoing:1.1.0")
    implementation("androidx.core:core:1.17.0")
}
```

### Core APIs

| API | Purpose |
|-----|---------|
| `OngoingActivity.Builder` | Creates ongoing activity |
| `OngoingActivity.apply()` | Applies activity data to notification |
| `OngoingActivity.update()` | Updates existing activity |
| `OngoingActivity.recoverOngoingActivity()` | Static: recovers existing activity |
| `Status.Builder` | Builds dynamic status text |
| `Status.TextPart` | Static text in status |
| `Status.StopwatchPart` | Dynamic timer in status |

### Notification Categories

`CATEGORY_CALL`, `CATEGORY_NAVIGATION`, `CATEGORY_TRANSPORT`, `CATEGORY_ALARM`, `CATEGORY_WORKOUT`, `CATEGORY_LOCATION_SHARING`, `CATEGORY_STOPWATCH`

### Step 1: Create Notification

```kotlin
val pendingIntent = PendingIntent.getActivity(
    this,
    0,
    Intent(this, AlwaysOnActivity::class.java).apply {
        flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
    },
    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
)

val notificationBuilder = NotificationCompat.Builder(this, CHANNEL_ID)
    .setContentTitle("Always On Service")
    .setContentText("Service is running in background")
    .setSmallIcon(R.drawable.animated_walk)
    .setCategory(NotificationCompat.CATEGORY_WORKOUT)
    .setContentIntent(pendingIntent)
    .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
    .setOngoing(true)
```

### Step 2: Create OngoingActivity

```kotlin
val ongoingActivity = OngoingActivity.Builder(
    applicationContext, NOTIFICATION_ID, notificationBuilder
)
    .setAnimatedIcon(R.drawable.animated_walk)
    .setStaticIcon(R.drawable.ic_walk)
    .setTouchIntent(pendingIntent)
    .build()
```

### Step 3: Apply & Post

```kotlin
ongoingActivity.apply(applicationContext)
startForeground(NOTIFICATION_ID, notificationBuilder.build())
```

### Dynamic Status Text

```kotlin
val statusTemplate = "#type# for #time#"
val runStartTime = SystemClock.elapsedRealtime()

val ongoingActivityStatus = Status.Builder()
    .addTemplate(statusTemplate)
    .addPart("type", Status.TextPart("Run"))
    .addPart("time", Status.StopwatchPart(runStartTime))
    .build()

val ongoingActivity = OngoingActivity.Builder(
    applicationContext, NOTIFICATION_ID, notificationBuilder
)
    .setAnimatedIcon(R.drawable.animated_walk)
    .setStaticIcon(R.drawable.ic_walk)
    .setTouchIntent(pendingIntent)
    .setStatus(ongoingActivityStatus)
    .build()
```

### Updating an Ongoing Activity

```kotlin
ongoingActivity.update(context, newStatus)

// Or recover existing:
OngoingActivity.recoverOngoingActivity(context)
    ?.update(context, newStatus)
```

### Requirements

- **Must** set static icon (explicit or from notification) -- `IllegalArgumentException` if missing
- **Must** set touch intent (explicit or from notification) -- `IllegalArgumentException` if missing
- Use **black and white vector icons** with transparent backgrounds
- Only works on **API level 30+** (Wear OS 3+). Below that, falls back to normal ongoing notification
- Don't update too frequently; a few updates per minute is reasonable
- Use `LocusId` to associate launcher shortcuts with ongoing activities

---

## 4. Deep Linking

**Source:** [Navigation Compose](https://developer.android.com/develop/ui/compose/navigation) | [Navigation for Wear OS](https://developer.android.com/training/wearables/compose/navigation)

### Deep Link in composable()

```kotlin
@Serializable data class Profile(val id: String)
val uri = "https://www.example.com"

composable<Profile>(
    deepLinks = listOf(
        navDeepLink<Profile>(basePath = "$uri/profile")
    )
) { backStackEntry ->
    ProfileScreen(id = backStackEntry.toRoute<Profile>().id)
}
```

### Manifest Intent Filter

```xml
<activity ...>
    <intent-filter>
        ...
        <data android:scheme="https" android:host="www.example.com" />
    </intent-filter>
</activity>
```

### Building PendingIntent from Deep Link

```kotlin
val id = "exampleId"
val context = LocalContext.current
val deepLinkIntent = Intent(
    Intent.ACTION_VIEW,
    "https://www.example.com/profile/$id".toUri(),
    context,
    MyActivity::class.java
)

val deepLinkPendingIntent: PendingIntent? = TaskStackBuilder.create(context).run {
    addNextIntentWithParentStack(deepLinkIntent)
    getPendingIntent(0, PendingIntent.FLAG_UPDATE_CURRENT)
}
```

### Key Rules

- Deep links are **not exposed to external apps** by default
- Must add `<intent-filter>` in manifest to make them externally available
- `navDeepLink()` accepts `basePath` parameter
- Same deep links can create `PendingIntent` for notifications or Ongoing Activity touch intents
- On Wear OS, use `androidx.wear.compose:compose-navigation` (NOT the mobile version)

---

## 5. State Restoration

**Source:** [Save UI state in Compose](https://developer.android.com/develop/ui/compose/state-saving) | [SavedStateHandle](https://developer.android.com/topic/libraries/architecture/viewmodel/viewmodel-savedstate)

### Summary Table

| Event | UI Logic | Business Logic (ViewModel) |
|-------|----------|---------------------------|
| Configuration changes | `rememberSaveable` | Automatic |
| System-initiated process death | `rememberSaveable` | `SavedStateHandle` |

### rememberSaveable (UI Layer)

```kotlin
@Composable
fun ChatBubble(message: Message) {
    var showDetails by rememberSaveable { mutableStateOf(false) }

    ClickableText(
        text = AnnotatedString(message.content),
        onClick = { showDetails = !showDetails }
    )

    if (showDetails) {
        Text(message.timestamp)
    }
}
```

### SavedStateHandle with Compose State (ViewModel)

```kotlin
class ConversationViewModel(
    savedStateHandle: SavedStateHandle
) : ViewModel() {

    var message by savedStateHandle.saveable(stateSaver = TextFieldValue.Saver) {
        mutableStateOf(TextFieldValue(""))
    }
        private set

    fun update(newMessage: TextFieldValue) {
        message = newMessage
    }
}
```

### SavedStateHandle with StateFlow (ViewModel)

```kotlin
private const val CHANNEL_FILTER_SAVED_STATE_KEY = "ChannelFilterKey"

class ChannelViewModel(
    channelsRepository: ChannelsRepository,
    private val savedStateHandle: SavedStateHandle
) : ViewModel() {

    private val savedFilterType: StateFlow<ChannelsFilterType> =
        savedStateHandle.getStateFlow(
            key = CHANNEL_FILTER_SAVED_STATE_KEY,
            initialValue = ChannelsFilterType.ALL_CHANNELS
        )

    private val filteredChannels: Flow<List<Channel>> =
        combine(channelsRepository.getAll(), savedFilterType) { channels, type ->
            filter(channels, type)
        }.onStart { emit(emptyList()) }

    fun setFiltering(requestType: ChannelsFilterType) {
        savedStateHandle[CHANNEL_FILTER_SAVED_STATE_KEY] = requestType
    }
}

enum class ChannelsFilterType {
    ALL_CHANNELS, RECENT_CHANNELS, ARCHIVED_CHANNELS
}
```

### LazyListState with rememberSaveable

```kotlin
@Composable
fun rememberLazyListState(
    initialFirstVisibleItemIndex: Int = 0,
    initialFirstVisibleItemScrollOffset: Int = 0
): LazyListState {
    return rememberSaveable(saver = LazyListState.Saver) {
        LazyListState(
            initialFirstVisibleItemIndex,
            initialFirstVisibleItemScrollOffset
        )
    }
}
```

### Key Rules

- `SavedStateHandle` only saves data when Activity is **stopped**
- Writes while Activity is stopped aren't saved unless `onStart` -> `onStop` occurs again
- Saved state is tied to task stack -- force stop / reboot clears it
- Use `StateRestorationTester` API for testing
- On Wear OS, process death is **more frequent** due to constrained memory

---

## 6. Offline-First Patterns

**Source:** [Standalone apps](https://developer.android.com/training/wearables/apps/standalone-apps) | [Disconnection indicators](https://developer.android.com/design/ui/wear/guides/m2-5/behaviors-and-patterns/disconnect) | [Discover devices](https://developer.android.com/training/wearables/data/discover-devices)

### Standalone vs Non-Standalone Manifest

```xml
<!-- Standalone: works without phone -->
<meta-data
    android:name="com.google.android.wearable.standalone"
    android:value="true" />

<!-- Non-standalone: requires phone for core features -->
<meta-data
    android:name="com.google.android.wearable.standalone"
    android:value="false" />
```

### Capability Advertisement (wear.xml)

**Phone module** -- `res/values/wear.xml`:
```xml
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@array/android_wear_capabilities">
    <string-array name="android_wear_capabilities">
        <item>verify_remote_example_phone_app</item>
    </string-array>
</resources>
```

**Watch module** -- `res/values/wear.xml`:
```xml
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@array/android_wear_capabilities">
    <string-array name="android_wear_capabilities">
        <item>verify_remote_example_wear_app</item>
    </string-array>
</resources>
```

### Phone Device Type Detection

```kotlin
var phoneDeviceType: Int = PhoneTypeHelper.getPhoneDeviceType(this)
// Returns: DEVICE_TYPE_ANDROID, DEVICE_TYPE_IOS, DEVICE_TYPE_UNKNOWN, DEVICE_TYPE_ERROR
```

### CapabilityClient -- Check Phone App Installed

```kotlin
private const val VOICE_TRANSCRIPTION_CAPABILITY_NAME = "voice_transcription"

private fun setupVoiceTranscription() {
    val capabilityInfo = Tasks.await(
        Wearable.getCapabilityClient(context).getCapability(
            VOICE_TRANSCRIPTION_CAPABILITY_NAME,
            CapabilityClient.FILTER_REACHABLE
        )
    )
    updateTranscriptionCapability(capabilityInfo)
}
```

### Lifecycle-Aware Data Layer Observer

```kotlin
class WearDataLayerObserver(
    private val dataClient: DataClient,
    private val onDataReceived: (DataEventBuffer) -> Unit
) : DefaultLifecycleObserver, DataClient.OnDataChangedListener {

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        onDataReceived(dataEvents)
    }

    override fun onResume(owner: LifecycleOwner) {
        dataClient.addListener(this)
    }

    override fun onPause(owner: LifecycleOwner) {
        dataClient.removeListener(this)
    }
}

// Usage in Activity:
class DataLayerLifecycleActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val dataClient = Wearable.getDataClient(this)
        val wearObserver = WearDataLayerObserver(dataClient) { dataEvents ->
            handleDataEvents(dataEvents)
        }
        lifecycle.addObserver(wearObserver)
    }
}
```

### CapabilityClient Listener (register/unregister)

```kotlin
// In onResume:
Wearable.getCapabilityClient(this)
    .addListener(
        this,
        Uri.parse("wear://"),
        CapabilityClient.FILTER_REACHABLE
    )

// In onPause:
Wearable.getCapabilityClient(this).removeListener(this)
```

### RemoteActivityHelper -- Open Phone App

```kotlin
// Open Play Store on Android phone:
RemoteActivityHelper.startRemoteActivity(
    Intent(Intent.ACTION_VIEW)
        .setData(Uri.parse("market://details?id=com.example.myapp")),
    nodeId
)

// Open App Store on iPhone:
RemoteActivityHelper.startRemoteActivity(
    Intent(Intent.ACTION_VIEW)
        .setData(Uri.parse("https://itunes.apple.com/us/app/yourappname")),
    nodeId
)
```

### Disconnection UI Guidelines

| Placement | Use Case |
|-----------|----------|
| **Top of view** | Some functionality unavailable (gray out disabled features) |
| **Bottom of scrollable list** | No more content can be loaded while disconnected |

### Key APIs

| API | Purpose |
|-----|---------|
| `CapabilityClient` | Advertise/detect app capabilities across devices |
| `NodeClient` | Identify all connected Android devices |
| `PhoneTypeHelper.getPhoneDeviceType()` | Android vs iOS vs unknown |
| `RemoteActivityHelper` | Open apps/URLs on paired phone |
| `CapabilityClient.FILTER_REACHABLE` | Only reachable nodes |
| `CapabilityClient.FILTER_ALL` | All nodes (for standalone detection) |

### Network Behavior

- Bluetooth connected to phone: traffic proxied through phone
- Phone unavailable: Wi-Fi and cellular used (if hardware supports)
- Bluetooth LE bandwidth: **~4 KB/s** -- shrink images, audit requests
- Wear OS handles network transitions automatically

---

## 7. App Shortcuts & Tiles

**Source:** [Tiles](https://developer.android.com/training/wearables/tiles) | [Get started with tiles](https://developer.android.com/training/wearables/tiles/get_started?version=3)

### Tile Dependencies

```kotlin
dependencies {
    implementation("androidx.wear.tiles:tiles:1.5.0")
    implementation("androidx.wear.protolayout:protolayout:1.3.0")
    implementation("androidx.wear.protolayout:protolayout-material:1.3.0")
    implementation("androidx.wear.protolayout:protolayout-expression:1.3.0")
    debugImplementation("androidx.wear.tiles:tiles-renderer:1.5.0")
    testImplementation("androidx.wear.tiles:tiles-testing:1.5.0")
}
```

### TileService Implementation

```kotlin
class MyTileService : TileService() {

    override fun onTileRequest(requestParams: RequestBuilders.TileRequest) =
        Futures.immediateFuture(
            Tile.Builder()
                .setResourcesVersion(RESOURCES_VERSION)
                .setTileTimeline(
                    Timeline.fromLayoutElement(
                        materialScope(this, requestParams.deviceConfiguration) {
                            primaryLayout(
                                mainSlot = {
                                    text("Hello, World!".layoutString,
                                        typography = BODY_LARGE)
                                }
                            )
                        }
                    )
                )
                .build()
        )

    override fun onTileResourcesRequest(requestParams: ResourcesRequest) =
        Futures.immediateFuture(
            Resources.Builder()
                .setVersion(RESOURCES_VERSION)
                .build()
        )
}
```

### Manifest Registration

```xml
<service
    android:name=".MyTileService"
    android:label="@string/tile_label"
    android:description="@string/tile_description"
    android:icon="@mipmap/ic_launcher"
    android:exported="true"
    android:permission="com.google.android.wearable.permission.BIND_TILE_PROVIDER">
    <intent-filter>
        <action android:name="androidx.wear.tiles.action.BIND_TILE_PROVIDER" />
    </intent-filter>
    <meta-data android:name="androidx.wear.tiles.PREVIEW"
        android:resource="@drawable/tile_preview" />
</service>
```

### Material Scope & Layout

```kotlin
materialScope(
    context = context,
    deviceConfiguration = requestParams.deviceConfiguration,
    defaultColorScheme = myFallbackColorScheme
) {
    primaryLayout(
        titleSlot = { text(text = "Title".layoutString) },
        mainSlot = { text(text = "Main Content".layoutString) },
        bottomSlot = {
            textEdgeButton(
                labelContent = { text("Action".layoutString) },
                onClick = clickable()
            )
        }
    )
}
```

### Image Resources

```kotlin
override fun onTileResourcesRequest(requestParams: ResourcesRequest) =
    Futures.immediateFuture(
        Resources.Builder()
            .setVersion("1")
            .addIdToImageMapping(
                "image_from_resource",
                ResourceBuilders.ImageResource.Builder()
                    .setAndroidResourceByResId(
                        ResourceBuilders.AndroidImageResourceByResId.Builder()
                            .setResourceId(R.drawable.ic_walk)
                            .build()
                    ).build()
            )
            .addIdToImageMapping(
                "image_inline",
                ResourceBuilders.ImageResource.Builder()
                    .setInlineResource(
                        ResourceBuilders.InlineImageResource.Builder()
                            .setData(imageAsByteArray)
                            .setWidthPx(48)
                            .setHeightPx(48)
                            .setFormat(ResourceBuilders.IMAGE_FORMAT_RGB_565)
                            .build()
                    ).build()
            ).build()
    )
```

### Available UI Components (M3 Tiles)

**Buttons:** `textButton()`, `iconButton()`, `avatarButton()`, `imageButton()`, `compactButton()`, `button()`
**Edge Buttons:** `iconEdgeButton()`, `textEdgeButton()`
**Cards:** `titleCard()`, `appCard()`, `textDataCard()`, `iconDataCard()`, `graphicDataCard()`
**Progress:** `circularProgressIndicator()`, `segmentedCircularProgressIndicator()`
**Layout:** `buttonGroup()`, `primaryLayout()`
**Arc:** `ArcLine`, `ArcText`, `ArcAdapter`

### Best Practices

- Tiles are rendered in a **separate, remote environment** (not your app process)
- Use **WorkManager** for background tasks, not long-running async in tile services
- Don't fetch content frequently in tile services
- Cache results locally
- Don't overcrowd tiles

### Wear OS 5 Launcher

- Built-in system-provided grid launcher
- App launcher entries help users start and return to experiences
- Tiles provide **contextual shortcuts** into specific screens (different from launcher)

---

## 8. Rotary Input

**Source:** [Rotary input with Compose](https://developer.android.com/training/wearables/compose/rotary-input)

### Core APIs

| API | Purpose |
|-----|---------|
| `Modifier.onRotaryScrollEvent` | Handle raw rotary scroll events |
| `Modifier.focusRequester()` | Assign focus requester to composable |
| `Modifier.focusable()` | Make composable focusable for rotary input |
| `FocusRequester` | Programmatically request focus |
| `ScrollIndicator` | Visual indicator for scroll position |
| `RotaryScrollableBehavior` | Configure scroll vs snap behavior |

### Scroll Indicator with ScreenScaffold

```kotlin
val listState = rememberTransformingLazyColumnState()
ScreenScaffold(
    scrollState = listState,
    scrollIndicator = {
        ScrollIndicator(state = listState)
    }
) {
    // Content
}
```

### ScalingLazyColumn with Snap Behavior

```kotlin
val listState = rememberScalingLazyListState()
ScreenScaffold(
    scrollState = listState,
    scrollIndicator = {
        ScrollIndicator(state = listState)
    }
) {
    val state = rememberScalingLazyListState()
    ScalingLazyColumn(
        modifier = Modifier.fillMaxWidth(),
        state = state,
        flingBehavior = ScalingLazyColumnDefaults.snapFlingBehavior(state = state)
    ) {
        // Content
    }
}
```

### Custom Rotary Input Handler (Volume Example)

```kotlin
class VolumeRange(val max: Int = 10, val min: Int = 0)

private object VolumeViewModel {
    class MyViewModel : ViewModel() {
        private val _volumeState = mutableIntStateOf(0)
        val volumeState: State<Int>
            get() = _volumeState

        fun onVolumeChangeByScroll(pixels: Float) {
            _volumeState.value = when {
                pixels > 0 -> minOf(volumeState.value + 1, VolumeRange().max)
                pixels < 0 -> maxOf(volumeState.value - 1, VolumeRange().min)
                else -> volumeState.value
            }
        }
    }
}
```

### onRotaryScrollEvent with TransformingLazyColumn

```kotlin
val focusRequester: FocusRequester = remember { FocusRequester() }
val volumeViewModel: VolumeViewModel.MyViewModel = viewModel()
val volumeState by volumeViewModel.volumeState

TransformingLazyColumn(
    modifier = Modifier
        .fillMaxSize()
        .onRotaryScrollEvent {
            volumeViewModel.onVolumeChangeByScroll(it.verticalScrollPixels)
            true
        }
        .focusRequester(focusRequester)
        .focusable(),
) {
    item {
        Text("Volume: $volumeState")
    }
}
```

### Key Rules

- **Modifier order matters:** `.onRotaryScrollEvent {}` -> `.focusRequester()` -> `.focusable()`
- `it.verticalScrollPixels` gives scroll direction and magnitude
- `ScalingLazyColumn` and `Picker` support rotary input **by default**
- `TransformingLazyColumn` integrates with `ScreenScaffold` for automatic rotary support
- Use `RotaryScrollableBehavior` parameter in scaffolds to configure scroll vs snap

---

## Cross-Cutting: WearableListenerService

**Source:** [Handle Data Layer events](https://developer.android.com/training/wearables/data/events)

For background event handling (data sync, messages, capability changes):

```kotlin
class DataLayerListenerService : WearableListenerService() {

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        dataEvents
            .map { it.dataItem.uri }
            .forEach { uri ->
                val nodeId: String = uri.host!!
                val payload: ByteArray = uri.toString().toByteArray()
                Wearable.getMessageClient(this)
                    .sendMessage(nodeId, DATA_ITEM_RECEIVED_PATH, payload)
            }
    }
}
```

### Manifest

```xml
<service
    android:name=".DataLayerListenerService"
    android:exported="true"
    tools:ignore="ExportedService">
    <intent-filter>
        <action android:name="com.google.android.gms.wearable.DATA_CHANGED" />
        <data android:scheme="wear" android:host="*" android:path="/start-activity" />
    </intent-filter>
</service>
```

---

## Quick Reference: All Dependencies

```kotlin
dependencies {
    // BOM
    val composeBom = platform("androidx.compose:compose-bom:2026.02.01")
    implementation(composeBom)

    // Wear Compose (M3)
    implementation("androidx.wear.compose:compose-material3:1.5.6")
    implementation("androidx.wear.compose:compose-foundation:1.5.6")
    implementation("androidx.wear.compose:compose-navigation:1.5.6")
    implementation("androidx.wear.compose:compose-ui-tooling:1.5.6")

    // Activity
    implementation("androidx.activity:activity-compose:1.12.4")

    // Ongoing Activity
    implementation("androidx.wear:wear-ongoing:1.1.0")
    implementation("androidx.core:core:1.17.0")

    // Tiles
    implementation("androidx.wear.tiles:tiles:1.5.0")
    implementation("androidx.wear.protolayout:protolayout:1.3.0")
    implementation("androidx.wear.protolayout:protolayout-material:1.3.0")
    implementation("androidx.wear.protolayout:protolayout-expression:1.3.0")
}
```
