import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service de notifications locales
/// Envoie des alertes quand un timer expire (WAIT_OK)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'infernal_alerts';
  static const _channelName = 'Alertes InfernalWheel';
  static const _channelDesc = 'Notifications quand un timer expire';

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  /// Notification quand un timer de pause expire (WAIT_OK)
  Future<void> notifyTimerExpired(String actionName) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.alarm,
      autoCancel: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      100, // ID fixe pour timer expired
      'Pause terminee !',
      '$actionName est fini — appuie sur OK pour reprendre le travail',
      details,
    );
  }

  /// Notification de rappel quand en overtime depuis longtemps
  Future<void> notifyOvertime(int overtimeMinutes) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      playSound: false,
      autoCancel: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      101, // ID fixe pour overtime
      'Overtime: ${overtimeMinutes}min',
      'Tu es en depassement depuis ${overtimeMinutes} minutes',
      details,
    );
  }

  /// Annule toutes les notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  void _onNotificationTap(NotificationResponse response) {
    // L'app est deja ouverte en WebView — pas besoin de navigation
  }
}
