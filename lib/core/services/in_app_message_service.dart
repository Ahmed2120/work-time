import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:work_time/core/services/telemetry_service.dart';
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/data/models/in_app_alert.dart';
import 'package:work_time/views/components/in_app_message_dialog.dart';

/// Service managing remote targeted & broadcast In-App Alerts.
/// Implements Offline-First with Two-Phase Acknowledgment (ACK):
/// - Phase 1: Immediate local response and pop-up dismissal.
/// - Phase 2: Remote server sync (with automatic batching at 5 items or on app resume/reconnect).
/// Once confirmed on the server, all temporary local records are cleaned up for zero storage overhead.
class InAppMessageService {
  static const String _firebaseDbUrl = 'https://worktime-33fa5-default-rtdb.firebaseio.com';
  static const String _keyPendingAcks = 'pending_in_app_acks';
  static const int _batchThreshold = 5;
  static bool _isShowingDialog = false;

  /// Checks for any unread alerts (targeted user alert first, then broadcast alert)
  /// and displays the pop-up modal seamlessly if found.
  /// Guarded by [_isShowingDialog] to prevent duplicate/stacked popups.
  static Future<void> checkAndShowAlert(BuildContext context) async {
    if (_isShowingDialog) return;
    _isShowingDialog = true;
    try {
      final alert = await fetchNextUnreadAlert();
      if (alert != null && context.mounted) {
        await InAppMessageDialog.show(context, alert);
      }
    } catch (e) {
      debugPrint('InAppMessageService: checkAndShowAlert error: $e');
    } finally {
      _isShowingDialog = false;
    }
  }

  /// Fetches the highest priority unread alert from Firebase Realtime Database.
  /// Excludes any alert already acknowledged locally in pending queue.
  /// Returns null if all messages have been read or none exist.
  static Future<InAppAlert?> fetchNextUnreadAlert() async {
    final uuid = TelemetryService.getOrCreateUuid();
    final pendingIds = _getPendingAcks().map((item) => item['id']?.toString()).toSet();

    // ─── Priority 1: User-targeted alert (/user_alerts/$uuid.json) ─────────
    try {
      final targetedUrl = Uri.parse('$_firebaseDbUrl/user_alerts/$uuid.json');
      final response = await http.get(targetedUrl).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200 && response.body != 'null' && response.body.isNotEmpty) {
        final decoded = json.decode(response.body);
        if (decoded is Map) {
          // If multiple alerts exist under user, find the first unread one
          // that is NOT already acknowledged locally in pending acks
          for (final entry in decoded.entries) {
            if (entry.value is Map) {
              final alertMap = Map<dynamic, dynamic>.from(entry.value as Map);
              final alert = InAppAlert.fromMap(entry.key.toString(), alertMap, isBroadcast: false);
              if (!alert.isRead && !pendingIds.contains(alert.id)) {
                return alert;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('InAppMessageService: Error fetching targeted alert: $e');
    }

    // ─── Priority 2: Broadcast alert (/broadcast_alert.json) ───────────────
    try {
      final broadcastUrl = Uri.parse('$_firebaseDbUrl/broadcast_alert.json');
      final response = await http.get(broadcastUrl).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200 && response.body != 'null' && response.body.isNotEmpty) {
        final decoded = json.decode(response.body);
        if (decoded is Map) {
          final alertMap = Map<dynamic, dynamic>.from(decoded);
          final alertId = alertMap['id']?.toString() ?? 'broadcast_active';

          if (!pendingIds.contains(alertId)) {
            final alert = InAppAlert.fromMap(alertId, alertMap, isBroadcast: true);

            // Verify if this user has already acknowledged this broadcast alert on the server
            final readCheckUrl = Uri.parse('$_firebaseDbUrl/broadcast_reads/$alertId/$uuid.json');
            final readRes = await http.get(readCheckUrl).timeout(const Duration(seconds: 3));

            if (readRes.statusCode == 200 && (readRes.body == 'null' || readRes.body.isEmpty)) {
              // User hasn't read this broadcast yet
              return alert;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('InAppMessageService: Error fetching broadcast alert: $e');
    }

    return null;
  }

  /// Phase 1: Local acknowledgment when user reads/dismisses an alert.
  /// Enqueues the acknowledgment and attempts immediate dispatch if online.
  static Future<void> markAlertAsRead(InAppAlert alert) async {
    final now = DateTime.now().toIso8601String();
    final ackItem = {
      'id': alert.id,
      'isBroadcast': alert.isBroadcast,
      'readAt': now,
    };

    // Load existing queue and add new ack
    final queue = _getPendingAcks();
    // Avoid duplicate acks for the same alert ID
    queue.removeWhere((item) => item['id'] == alert.id);
    queue.add(ackItem);
    await _savePendingAcks(queue);

    // Try immediate Phase 2 sync if online (forced for immediate server persistence)
    await syncPendingAcks(force: true);
  }

  /// Phase 2: Synchronizes pending read confirmations with Firebase Realtime Database.
  /// Runs automatically when:
  /// - The queue reaches [_batchThreshold] (5 items), OR
  /// - [force] is true (called on app startup, app resumed, or immediately after reading).
  /// Once confirmed by the server (200 OK), the temporary queue is emptied completely.
  static Future<void> syncPendingAcks({bool force = false}) async {
    final queue = _getPendingAcks();
    if (queue.isEmpty) return;

    // Only proceed if forced (e.g. app resume/start) or reached threshold
    if (!force && queue.length < _batchThreshold) {
      return;
    }

    final uuid = TelemetryService.getOrCreateUuid();
    final List<Map<String, dynamic>> remainingQueue = [];

    for (final item in queue) {
      final String alertId = item['id'].toString();
      final bool isBroadcast = item['isBroadcast'] == true;
      final String readAt = item['readAt'].toString();

      bool success = false;
      try {
        if (isBroadcast) {
          // Record read receipt for this user on the broadcast alert
          final url = Uri.parse('$_firebaseDbUrl/broadcast_reads/$alertId/$uuid.json');
          final response = await http
              .patch(
                url,
                headers: {'Content-Type': 'application/json'},
                body: json.encode({'readAt': readAt}),
              )
              .timeout(const Duration(seconds: 4));
          success = response.statusCode >= 200 && response.statusCode < 300;
        } else {
          // Update the targeted user alert to isRead: true
          final url = Uri.parse('$_firebaseDbUrl/user_alerts/$uuid/$alertId.json');
          final response = await http
              .patch(
                url,
                headers: {'Content-Type': 'application/json'},
                body: json.encode({
                  'isRead': true,
                  'readAt': readAt,
                }),
              )
              .timeout(const Duration(seconds: 4));
          success = response.statusCode >= 200 && response.statusCode < 300;
        }
      } catch (e) {
        success = false;
      }

      if (!success) {
        remainingQueue.add(item);
      }
    }

    if (remainingQueue.isEmpty) {
      // All pending acknowledgments confirmed by server!
      // Clean up local queue completely for zero device storage footprint.
      await CacheHelper.removeData(key: _keyPendingAcks);
      debugPrint('InAppMessageService: All pending ACKs synced and local queue cleared ✅');
    } else {
      await _savePendingAcks(remainingQueue);
      debugPrint('InAppMessageService: ${remainingQueue.length} ACKs remaining in queue.');
    }
  }

  // ─── Private Helpers ────────────────────────────────────────────────────────

  static List<Map<String, dynamic>> _getPendingAcks() {
    try {
      final raw = CacheHelper.getData(key: _keyPendingAcks);
      if (raw != null && raw is String && raw.isNotEmpty) {
        final decoded = json.decode(raw);
        if (decoded is List) {
          return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        }
      }
    } catch (_) {}
    return [];
  }

  static Future<void> _savePendingAcks(List<Map<String, dynamic>> queue) async {
    try {
      if (queue.isEmpty) {
        await CacheHelper.removeData(key: _keyPendingAcks);
      } else {
        await CacheHelper.saveData(key: _keyPendingAcks, value: json.encode(queue));
      }
    } catch (_) {}
  }
}
