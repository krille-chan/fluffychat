import 'dart:convert';

import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists CallKit call state across app restarts
class CallStatePersistence {
  static CallStatePersistence? _instance;
  static CallStatePersistence get instance {
    _instance ??= CallStatePersistence._();
    return _instance!;
  }

  CallStatePersistence._();

  static const String _keyPrefix = 'callkit_call_';
  static const String _keyAllCalls = 'callkit_all_calls';

  /// Save call state
  Future<void> saveCall({
    required String callUuid,
    required String roomId,
    required String state,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final callData = {
        'callUuid': callUuid,
        'roomId': roomId,
        'state': state,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // Save individual call
      await prefs.setString(
        '$_keyPrefix$callUuid',
        jsonEncode(callData),
      );

      // Update list of all calls
      final allCallsJson = prefs.getString(_keyAllCalls);
      final allCalls = allCallsJson != null
          ? List<String>.from(jsonDecode(allCallsJson))
          : [];

      if (!allCalls.contains(callUuid)) {
        allCalls.add(callUuid);
        await prefs.setString(_keyAllCalls, jsonEncode(allCalls));
      }

      Logs().d(
        '[CallStatePersistence] Saved call: callUuid=$callUuid, roomId=$roomId, state=$state',
      );
    } catch (e, s) {
      Logs().e('[CallStatePersistence] Failed to save call', e, s);
    }
  }

  /// Update call state
  Future<void> updateCallState({
    required String callUuid,
    required String state,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final callJson = prefs.getString('$_keyPrefix$callUuid');

      if (callJson == null) {
        Logs().w(
          '[CallStatePersistence] updateCallState: call not found: $callUuid',
        );
        return;
      }

      final callData = jsonDecode(callJson) as Map<String, dynamic>;
      callData['state'] = state;
      callData['timestamp'] = DateTime.now().millisecondsSinceEpoch;

      await prefs.setString(
        '$_keyPrefix$callUuid',
        jsonEncode(callData),
      );

      Logs().d(
        '[CallStatePersistence] Updated call state: callUuid=$callUuid, state=$state',
      );
    } catch (e, s) {
      Logs().e('[CallStatePersistence] Failed to update call state', e, s);
    }
  }

  /// Get call data
  Future<Map<String, dynamic>?> getCall(String callUuid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final callJson = prefs.getString('$_keyPrefix$callUuid');

      if (callJson == null) return null;

      return jsonDecode(callJson) as Map<String, dynamic>;
    } catch (e, s) {
      Logs().e('[CallStatePersistence] Failed to get call', e, s);
      return null;
    }
  }

  /// Get all persisted calls
  Future<List<Map<String, dynamic>>> getAllCalls() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allCallsJson = prefs.getString(_keyAllCalls);

      if (allCallsJson == null) return [];

      final callUuids = List<String>.from(jsonDecode(allCallsJson));
      final calls = <Map<String, dynamic>>[];

      for (final callUuid in callUuids) {
        final call = await getCall(callUuid);
        if (call != null) {
          calls.add(call);
        }
      }

      return calls;
    } catch (e, s) {
      Logs().e('[CallStatePersistence] Failed to get all calls', e, s);
      return [];
    }
  }

  /// Remove call
  Future<void> removeCall(String callUuid) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove individual call
      await prefs.remove('$_keyPrefix$callUuid');

      // Update list of all calls
      final allCallsJson = prefs.getString(_keyAllCalls);
      if (allCallsJson != null) {
        final allCalls = List<String>.from(jsonDecode(allCallsJson));
        allCalls.remove(callUuid);
        await prefs.setString(_keyAllCalls, jsonEncode(allCalls));
      }

      Logs().d('[CallStatePersistence] Removed call: callUuid=$callUuid');
    } catch (e, s) {
      Logs().e('[CallStatePersistence] Failed to remove call', e, s);
    }
  }

  /// Clear all persisted calls
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final allCallsJson = prefs.getString(_keyAllCalls);

      if (allCallsJson != null) {
        final callUuids = List<String>.from(jsonDecode(allCallsJson));
        for (final callUuid in callUuids) {
          await prefs.remove('$_keyPrefix$callUuid');
        }
      }

      await prefs.remove(_keyAllCalls);

      Logs().d('[CallStatePersistence] Cleared all calls');
    } catch (e, s) {
      Logs().e('[CallStatePersistence] Failed to clear all calls', e, s);
    }
  }
}
