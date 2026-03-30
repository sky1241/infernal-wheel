import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'timer_engine.dart';

/// Configure et demarre le foreground service Android
/// Le timer engine tourne dans ce service — Android ne peut pas le tuer
class ForegroundService {
  static final ForegroundService _instance = ForegroundService._internal();
  factory ForegroundService() => _instance;
  ForegroundService._internal();

  bool _initialized = false;

  /// Initialise la configuration du foreground service
  void init() {
    if (_initialized) return;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'infernal_timer',
        channelName: 'InfernalWheel Timer',
        channelDescription: 'Suivi du temps de travail et pauses',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(1000), // tick 1s
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );

    _initialized = true;
  }

  /// Demarre le foreground service avec le timer engine
  Future<ServiceRequestResult> start() async {
    init();

    // Demander la permission de notification (Android 13+)
    final notifPermission = await FlutterForegroundTask.checkNotificationPermission();
    if (notifPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (await FlutterForegroundTask.isRunningService) {
      return const ServiceRequestSuccess();
    }

    return await FlutterForegroundTask.startService(
      notificationTitle: 'InfernalWheel',
      notificationText: 'Timer actif',
      callback: _startCallback,
    );
  }

  /// Arrete le foreground service
  Future<ServiceRequestResult> stop() async {
    return await FlutterForegroundTask.stopService();
  }

  /// Met a jour la notification
  Future<void> updateNotification(String title, String text) async {
    FlutterForegroundTask.updateService(
      notificationTitle: title,
      notificationText: text,
    );
  }
}

// --- Callback top-level (requis par flutter_foreground_task) ---

@pragma('vm:entry-point')
void _startCallback() {
  FlutterForegroundTask.setTaskHandler(_TimerTaskHandler());
}

/// Task handler qui tourne dans le foreground service
class _TimerTaskHandler extends TaskHandler {
  final _engine = TimerEngine();

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Demarrer le timer engine
    _engine.start();
    _engine.onStateChanged = _updateNotification;
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // Le tick est gere par le timer engine lui-meme
    // Ici on met juste a jour la notification
    _updateNotification();
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    _engine.stop();
  }

  void _updateNotification() {
    final s = _engine.state;
    final seg = s.current.name;
    final remainSec = (s.goalWorkSeconds - s.totalWorkSeconds - s.totalOverrunSeconds).clamp(0, 999999999);
    final remainMin = (remainSec / 60).round();
    final remainH = remainMin ~/ 60;
    final remainM = remainMin % 60;

    final title = seg == 'idle' ? 'InfernalWheel' : seg.toUpperCase();
    final text = 'Restant: ${remainH}h${remainM.toString().padLeft(2, '0')} | '
        'Jour: ${(s.dayWorkSeconds / 60).round()}m travail, '
        '${(s.daySleepSeconds / 60).round()}m sommeil';

    FlutterForegroundTask.updateService(
      notificationTitle: title,
      notificationText: text,
    );
  }
}
