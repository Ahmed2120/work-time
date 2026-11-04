import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:work_time/core/utils/cache_helper.dart';
import 'package:work_time/data/models/whats_new_item.dart';

/// Service managing dynamic What's New release announcements.
/// Controlled 100% remotely via Firebase Realtime Database and the Admin Dashboard.
/// Absolutely NO static or hardcoded default items. When empty, the section completely disappears.
class WhatsNewService {
  static const String _firebaseDbUrl = 'https://worktime-33fa5-default-rtdb.firebaseio.com';
  static const String _keyCache = 'whats_new_cached_json';
  static const String _keyLastFetch = 'whats_new_last_fetch_time';
  static const String _keyLastSeenId = 'whats_new_last_seen_id';
  static const int _throttleHours = 12;

  /// Loads What's New items dynamically from Firebase with local caching and request throttling.
  /// If Firebase has no updates (null or empty), it saves empty cache and returns empty list
  /// so that the section is hidden in the app.
  static Future<List<WhatsNewItem>> getWhatsNew({bool forceRefresh = false}) async {
    final cached = _getCachedItems();

    // 1. Throttling check: if not forcing refresh and cached recently, use cached
    if (!forceRefresh) {
      final String? lastFetchStr = CacheHelper.getData(key: _keyLastFetch) as String?;
      if (lastFetchStr != null) {
        final lastFetch = DateTime.tryParse(lastFetchStr);
        if (lastFetch != null &&
            DateTime.now().difference(lastFetch).inHours < _throttleHours) {
          debugPrint('WhatsNew: Using cached data (throttled for $_throttleHours h)');
          return cached;
        }
      }
    }

    // 2. Fetch live data from Firebase Realtime Database
    try {
      final response = await http
          .get(Uri.parse('$_firebaseDbUrl/whats_new.json'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body == 'null') {
          // Admin deleted/cleared all updates: clear cache so app hides the section
          await _saveToCache([]);
          await CacheHelper.saveData(
            key: _keyLastFetch,
            value: DateTime.now().toIso8601String(),
          );
          return [];
        }

        final decoded = json.decode(response.body);
        if (decoded is Map && decoded.isNotEmpty) {
          final List<WhatsNewItem> fetched = [];
          decoded.forEach((key, value) {
            if (value is Map) {
              fetched.add(WhatsNewItem.fromMap(key.toString(), value));
            }
          });

          // Sort newest date first
          fetched.sort((a, b) => b.date.compareTo(a.date));

          await _saveToCache(fetched);
          await CacheHelper.saveData(
            key: _keyLastFetch,
            value: DateTime.now().toIso8601String(),
          );
          return fetched;
        } else {
          // Empty map in Firebase
          await _saveToCache([]);
          await CacheHelper.saveData(
            key: _keyLastFetch,
            value: DateTime.now().toIso8601String(),
          );
          return [];
        }
      }
    } catch (e) {
      debugPrint('WhatsNew fetch error (silently using local cache if available): $e');
      return cached;
    }

    return cached;
  }

  /// Checks if there is a new update the user has not seen yet
  static bool hasUnseenUpdates(List<WhatsNewItem> items) {
    if (items.isEmpty) return false;
    final String? lastSeenId = CacheHelper.getData(key: _keyLastSeenId) as String?;
    if (lastSeenId == null || lastSeenId.isEmpty) {
      return true;
    }
    final newestId = items.first.id;
    return newestId != lastSeenId;
  }

  /// Mark newest item as seen so badge/modal doesn't show again
  static Future<void> markAsSeen(String newestId) async {
    try {
      await CacheHelper.saveData(key: _keyLastSeenId, value: newestId);
    } catch (e) {
      debugPrint('Error saving last seen id: $e');
    }
  }

  // ─── Local Cache Helpers ──────────────────────────────────────────────────
  static List<WhatsNewItem> _getCachedItems() {
    try {
      final String? jsonStr = CacheHelper.getData(key: _keyCache) as String?;
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final decoded = json.decode(jsonStr);
        if (decoded is List) {
          return decoded.map((e) => WhatsNewItem.fromMap(e['id'] ?? '', e as Map)).toList();
        }
      }
    } catch (e) {
      debugPrint('Error reading WhatsNew cache: $e');
    }
    return [];
  }

  static Future<void> _saveToCache(List<WhatsNewItem> items) async {
    try {
      final list = items.map((e) => e.toMap()).toList();
      await CacheHelper.saveData(key: _keyCache, value: json.encode(list));
    } catch (e) {
      debugPrint('Error saving WhatsNew cache: $e');
    }
  }
}
