/// MatrixRTC call service for managing group calls.
// ignore_for_file: require_trailing_commas

library;

import 'dart:async';
import 'dart:convert';
import 'package:matrix/matrix.dart';

/// Service for managing MatrixRTC group calls.
class CallService {
  static Timer? _expiryRefreshTimer;
  static Client? _activeClient;
  static Room? _activeRoom;

  /// Detect if group call is already started in room.
  static bool hasActiveCall(Room room) {
    Logs().v(
        '[ElementCall.CallService] hasActiveCall: checking roomId=${room.id}');
    final callMembers = room.states['org.matrix.msc3401.call.member'];
    if (callMembers == null || callMembers.isEmpty) {
      Logs()
          .v('[ElementCall.CallService] hasActiveCall: no call.member states');
      return false;
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    final hasActive = callMembers.values.any((event) {
      final content = event.content;
      if (content.isEmpty) return false;

      // Check expiry timestamp
      final expiresTs = content['expires_ts'];
      if (expiresTs != null && expiresTs is int && expiresTs < now) {
        return false; // Expired membership
      }

      // Legacy MSC3401 format: application as string, call_id at top level
      final app = content['application'];
      if (app is String && app == 'm.call' && content.containsKey('call_id')) {
        return true;
      }

      // MSC4143 format: application as object with type field
      if (app is Map && app['type'] == 'm.call') {
        return true;
      }

      return false;
    });

    Logs().d('[ElementCall.CallService] hasActiveCall: hasActive=$hasActive');
    return hasActive;
  }

  /// Create call.member state event to start group call.
  static Future<void> startGroupCall({
    required Client client,
    required Room room,
  }) async {
    Logs().i('[ElementCall.CallService] startGroupCall: roomId=${room.id}');

    final userId = client.userID!;
    final deviceId = client.deviceID ?? 'UNKNOWN';

    // Store references for refresh timer
    _activeClient = client;
    _activeRoom = room;

    // Get state key with correct prefix
    final stateKey = getStateKey(room, userId, deviceId);
    Logs().d('[ElementCall.CallService] startGroupCall: stateKey=$stateKey');

    // Get LiveKit URL
    final liveKitUrl = await _getLiveKitUrl(client);
    Logs()
        .d('[ElementCall.CallService] startGroupCall: liveKitUrl=$liveKitUrl');

    // Calculate expiry timestamp (now + 2 hours)
    final now = DateTime.now().millisecondsSinceEpoch;
    final expiresTs = now + (2 * 60 * 60 * 1000);

    // Create call.member content (Legacy MSC3401 format)
    final content = {
      'application': 'm.call',
      'call_id': room.id,
      'scope': 'm.room',
      'device_id': deviceId,
      'expires_ts': expiresTs,
      'm.encryption': 'perParticipantKeys', // Indicate encryption mode
      'focus_active': {
        'type': 'livekit',
        'focus_selection': 'oldest_membership',
      },
      'foci_preferred': [
        {
          'type': 'livekit',
          'livekit_service_url': liveKitUrl,
          'livekit_alias': room.id,
        }
      ],
    };

    // Post state event
    Logs().d(
        '[ElementCall.CallService] startGroupCall: setting call.member state');
    await client.setRoomStateWithKey(
      room.id,
      'org.matrix.msc3401.call.member',
      stateKey,
      content,
    );

    Logs().i(
        '[ElementCall.CallService] startGroupCall: started group call, stateKey=$stateKey, expires=$expiresTs');

    // Start periodic refresh timer (every 55 minutes)
    Logs().d(
        '[ElementCall.CallService] startGroupCall: starting 55min refresh timer');
    _expiryRefreshTimer?.cancel();
    _expiryRefreshTimer = Timer.periodic(
      const Duration(minutes: 55),
      (_) {
        Logs().d(
            '[ElementCall.CallService] startGroupCall: timer triggered, refreshing membership');
        _refreshMembership();
      },
    );
  }

  /// Leave group call (set empty content).
  static Future<void> leaveGroupCall({
    required Client client,
    required Room room,
  }) async {
    Logs().i('[ElementCall.CallService] leaveGroupCall: roomId=${room.id}');

    final userId = client.userID!;
    final deviceId = client.deviceID ?? 'UNKNOWN';
    final stateKey = getStateKey(room, userId, deviceId);

    Logs().d(
        '[ElementCall.CallService] leaveGroupCall: removing call.member state, stateKey=$stateKey');

    await client.setRoomStateWithKey(
      room.id,
      'org.matrix.msc3401.call.member',
      stateKey,
      {}, // Empty = left
    );

    // Cancel refresh timer
    _expiryRefreshTimer?.cancel();
    _expiryRefreshTimer = null;
    _activeClient = null;
    _activeRoom = null;

    Logs().i('[ElementCall.CallService] leaveGroupCall: left group call');
  }

  /// Refresh membership to extend expiry timestamp.
  static Future<void> _refreshMembership() async {
    if (_activeClient == null || _activeRoom == null) {
      Logs().w(
          '[ElementCall.CallService] _refreshMembership: no active client/room');
      return;
    }

    Logs().i(
        '[ElementCall.CallService] _refreshMembership: refreshing membership for roomId=${_activeRoom!.id}');

    try {
      final userId = _activeClient!.userID!;
      final deviceId = _activeClient!.deviceID ?? 'UNKNOWN';
      final stateKey = getStateKey(_activeRoom!, userId, deviceId);

      // Get LiveKit URL
      final liveKitUrl = await _getLiveKitUrl(_activeClient!);

      // Calculate new expiry timestamp (now + 2 hours)
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiresTs = now + (2 * 60 * 60 * 1000);

      // Update state with new expiry
      final content = {
        'application': 'm.call',
        'call_id': _activeRoom!.id,
        'scope': 'm.room',
        'device_id': deviceId,
        'expires_ts': expiresTs,
        'm.encryption': 'perParticipantKeys',
        'focus_active': {
          'type': 'livekit',
          'focus_selection': 'oldest_membership',
        },
        'foci_preferred': [
          {
            'type': 'livekit',
            'livekit_service_url': liveKitUrl,
            'livekit_alias': _activeRoom!.id,
          }
        ],
      };

      await _activeClient!.setRoomStateWithKey(
        _activeRoom!.id,
        'org.matrix.msc3401.call.member',
        stateKey,
        content,
      );

      Logs().i(
          '[ElementCall.CallService] _refreshMembership: refreshed successfully, new expiry=$expiresTs');
    } catch (e, s) {
      Logs().e('[ElementCall.CallService] _refreshMembership: error', e, s);
    }
  }

  /// Get state key with proper prefix for room version.
  static String getStateKey(Room room, String userId, String deviceId) {
    final roomVersion = room.getState('m.room.create')?.content['room_version'];
    final supportsMsc3779 =
        roomVersion?.toString().contains('org.matrix.msc3779') ?? false;

    final key = '${userId}_${deviceId}_m.call';
    final stateKey = supportsMsc3779 ? key : '_$key';
    Logs().v(
        '[ElementCall.CallService] getStateKey: userId=$userId, deviceId=$deviceId, stateKey=$stateKey, msc3779=$supportsMsc3779');
    return stateKey;
  }

  /// Get LiveKit service URL from .well-known or fallback.
  static Future<String> _getLiveKitUrl(Client client) async {
    Logs().v(
        '[ElementCall.CallService] _getLiveKitUrl: fetching from .well-known');
    try {
      final response = await client.httpClient.get(
        Uri.parse('${client.homeserver}/.well-known/matrix/client'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foci = data['org.matrix.msc4143.rtc_foci'];

        if (foci is List && foci.isNotEmpty) {
          final url = foci[0]['livekit_service_url'];
          Logs().i(
              '[ElementCall.CallService] _getLiveKitUrl: using LiveKit from .well-known: $url');
          return url;
        }
      }
    } catch (e, s) {
      Logs().e(
          '[ElementCall.CallService] _getLiveKitUrl: .well-known fetch failed',
          e,
          s);
    }

    // Fallback to Element's hosted LiveKit
    const fallbackUrl = 'https://livekit-jwt.call.element.io';
    Logs().i(
        '[ElementCall.CallService] _getLiveKitUrl: using fallback Element LiveKit: $fallbackUrl');
    return fallbackUrl;
  }
}
