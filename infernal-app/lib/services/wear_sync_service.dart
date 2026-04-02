import 'package:flutter/services.dart';

/// Service to communicate with the native Wear Data Layer receiver.
/// Provides watch sync data (detections, daily summaries) to Flutter.
class WearSyncService {
  static const _channel = MethodChannel('com.infernal.wheel/wear_sync');

  /// Callback invoked when the watch sends new data.
  /// Set this to react to incoming watch data in real time.
  void Function()? onWatchDataChanged;

  WearSyncService() {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    if (call.method == 'onWatchDataChanged') {
      onWatchDataChanged?.call();
    }
  }

  /// Returns the latest sync state: summary + last detection + total count.
  Future<Map<String, dynamic>> getLatestSync() async {
    final result = await _channel.invokeMethod<Map>('getLatestSync');
    return Map<String, dynamic>.from(result ?? {});
  }

  /// Returns today's daily summary from the watch.
  /// Keys: date, cigaretteCount, totalDetections, receivedAt
  Future<Map<String, dynamic>> getDailySummary() async {
    final result = await _channel.invokeMethod<Map>('getDailySummary');
    return Map<String, dynamic>.from(result ?? {});
  }

  /// Returns all synced detections as a list of maps.
  /// Each map has: timestamp, confidence, gpsCluster, hrBaseline, hrCurrent, hrDelta, receivedAt
  Future<List<Map<String, dynamic>>> getDetectionHistory() async {
    final result = await _channel.invokeMethod<List>('getDetectionHistory');
    if (result == null) return [];
    return result
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }
}
