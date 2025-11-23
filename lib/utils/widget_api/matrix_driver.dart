import 'dart:async';
import 'dart:typed_data';

import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

import 'capabilities/capability_matcher.dart';
import 'models/models.dart';

const _uuid = Uuid();

/// Internal event types that should be filtered from widgets
const _internalEventTypes = [
  'm.room_key',
  'm.room_key_request',
  'm.forwarded_room_key',
  'm.key.verification.request',
  'm.key.verification.start',
  'm.key.verification.accept',
  'm.key.verification.key',
  'm.key.verification.mac',
  'm.key.verification.cancel',
  'm.key.verification.done',
  'm.dummy',
];

/// Call signaling types (exempt from E2EE enforcement)
const _callSignalingTypes = [
  'm.call.invite',
  'm.call.candidates',
  'm.call.answer',
  'm.call.hangup',
  'm.call.select_answer',
  'm.call.reject',
  'm.call.negotiate',
  'org.matrix.call.sdp_stream_metadata_changed',
];

/// Delayed event info
class _DelayedEventInfo {
  _DelayedEventInfo({
    required this.timer,
    required this.roomId,
    required this.eventType,
    required this.content,
    required this.stateKey,
    required this.delay,
  });

  Timer timer;
  final String roomId;
  final String eventType;
  final Map<String, dynamic> content;
  final String? stateKey;
  final int delay;
}

/// Executes Matrix operations for widgets with security enforcement
class MatrixDriver {
  MatrixDriver({
    required this.client,
    required this.room,
    required this.capabilities,
  });

  final Client client;
  final Room room;
  final CapabilityMatcher capabilities;

  final Map<String, _DelayedEventInfo> _delayedEvents = {};

  /// Dispose and clean up delayed events
  void dispose() {
    for (final event in _delayedEvents.values) {
      event.timer.cancel();
    }
    _delayedEvents.clear();
  }

  /// Execute Matrix request
  Future<Map<String, dynamic>> execute(MatrixRequest request) async {
    return switch (request) {
      GetOpenId() => await _getOpenId(),
      ReadEvents(
        :final eventType,
        :final limit,
        :final roomIds,
        :final stateKey,
        :final relationType,
        :final eventId
      ) =>
        await _readEvents(
          eventType,
          limit,
          roomIds,
          stateKey,
          relationType,
          eventId,
        ),
      SendEvent(
        :final roomId,
        :final eventType,
        :final content,
        :final stateKey
      ) =>
        await _sendEvent(roomId, eventType, content, stateKey),
      SendToDevice(:final eventType, :final messages, :final encrypted) =>
        await _sendToDevice(eventType, messages, encrypted),
      SendDelayedEvent(
        :final roomId,
        :final eventType,
        :final content,
        :final delay,
        :final stateKey,
        :final parentDelayId
      ) =>
        await _sendDelayedEvent(
          roomId,
          eventType,
          content,
          delay,
          stateKey,
          parentDelayId,
        ),
      UpdateDelayedEvent(:final delayId, :final action) =>
        await _updateDelayedEvent(delayId, action),
      GetTurnServers() => await _getTurnServers(),
      SearchUsers(:final searchTerm, :final limit) =>
        await _searchUsers(searchTerm, limit),
      UploadFile(:final file, :final filename, :final mimetype) =>
        await _uploadFile(file, filename, mimetype),
      DownloadFile(:final mxcUri) => await _downloadFile(mxcUri),
    };
  }

  Future<Map<String, dynamic>> _getOpenId() async {
    // Request OpenID token from homeserver
    final response = await client.request(
      RequestType.POST,
      '/client/v3/user/${client.userID}/openid/request_token',
      data: {},
    );

    return {
      'access_token': response['access_token'] as String,
      'token_type': response['token_type'] as String,
      'matrix_server_name': response['matrix_server_name'] as String,
      'expires_in': response['expires_in'] as int,
      'state':
          'allowed', // Auto-approve for trusted widgets (OpenID uses separate permission model per MSC1960)
    };
  }

  Future<Map<String, dynamic>> _readEvents(
    String eventType,
    int? limit,
    List<String>? roomIds,
    String? stateKey,
    String? relationType,
    String? eventId,
  ) async {
    // Check capability
    if (!capabilities.canRead(eventType, stateKey: stateKey)) {
      throw WidgetErrors.capabilityNotGranted;
    }

    // Filter internal types
    if (_internalEventTypes.contains(eventType)) {
      throw WidgetErrors.forbidden;
    }

    final events = <Map<String, dynamic>>[];

    if (stateKey != null) {
      // State events
      final stateEvent = room.getState(eventType, stateKey);
      if (stateEvent != null) {
        events.add(stateEvent.toJson());
      }
    } else if (relationType != null || eventId != null) {
      // MSC3869: Read relations
      if (eventId != null) {
        final timeline = await room.getTimeline();
        final targetEvent =
            timeline.events.where((e) => e.eventId == eventId).firstOrNull;

        if (targetEvent != null) {
          final relations = timeline.events.where((e) {
            final rel = e.relationshipType;
            if (relationType != null && rel != relationType) return false;
            return e.relationshipEventId == eventId;
          });

          events.addAll(relations.map((e) => e.toJson()));
        }
      }
    } else {
      // Timeline events
      final timeline = await room.getTimeline();
      final matchingEvents =
          timeline.events.where((e) => e.type == eventType).take(limit ?? 100);

      events.addAll(matchingEvents.map((e) => e.toJson()));
    }

    return {'events': events};
  }

  Future<Map<String, dynamic>> _sendEvent(
    String roomId,
    String eventType,
    Map<String, dynamic> content,
    String? stateKey,
  ) async {
    // Check capability
    if (!capabilities.canSend(eventType, stateKey: stateKey)) {
      throw WidgetErrors.capabilityNotGranted;
    }

    // Filter internal types
    if (_internalEventTypes.contains(eventType)) {
      throw WidgetErrors.forbidden;
    }

    final String? eventId;
    if (stateKey != null) {
      eventId = await client.setRoomStateWithKey(
        roomId,
        eventType,
        stateKey,
        content,
      );
    } else {
      eventId = await room.sendEvent(
        content,
        type: eventType,
      );
    }

    if (eventId == null) {
      throw const WidgetError('Failed to send event');
    }

    return {'event_id': eventId, 'room_id': roomId};
  }

  Future<Map<String, dynamic>> _sendToDevice(
    String eventType,
    Map<String, Map<String, Map<String, dynamic>>> messages,
    bool encrypted,
  ) async {
    // Check capability
    if (!capabilities.canSendToDevice(eventType)) {
      throw WidgetErrors.capabilityNotGranted;
    }

    // E2EE enforcement (unless call signaling)
    if (room.encrypted &&
        !encrypted &&
        !_callSignalingTypes.contains(eventType)) {
      throw WidgetErrors.encryptionRequired;
    }

    // Send to-device messages
    if (encrypted) {
      // For encrypted, use encryption methods
      for (final userId in messages.keys) {
        for (final deviceId in messages[userId]!.keys) {
          final content = messages[userId]![deviceId]!;

          // Get device keys
          final userDeviceKeys = client.userDeviceKeys[userId];
          if (userDeviceKeys != null) {
            final deviceKey = userDeviceKeys.deviceKeys[deviceId];
            if (deviceKey != null) {
              await client.sendToDeviceEncrypted(
                [deviceKey],
                eventType,
                content,
              );
            }
          }
        }
      }
    } else {
      // For unencrypted, send directly
      await client.sendToDevice(eventType, '', messages);
    }

    return {};
  }

  Future<Map<String, dynamic>> _sendDelayedEvent(
    String roomId,
    String eventType,
    Map<String, dynamic> content,
    int delay,
    String? stateKey,
    String? parentDelayId,
  ) async {
    // Check capability
    if (!capabilities.canSend(eventType, stateKey: stateKey)) {
      throw WidgetErrors.capabilityNotGranted;
    }

    // Filter internal types
    if (_internalEventTypes.contains(eventType)) {
      throw WidgetErrors.forbidden;
    }

    // Generate delay_id
    final delayId = _uuid.v4();

    // Schedule event to be sent after delay
    final timer = Timer(Duration(milliseconds: delay), () async {
      try {
        // Send the event
        if (stateKey != null) {
          await client.setRoomStateWithKey(
            roomId,
            eventType,
            stateKey,
            content,
          );
        } else {
          await room.sendEvent(
            content,
            type: eventType,
          );
        }
      } catch (e) {
        Logs().e('MatrixDriver: Failed to send delayed event $delayId', e);
      } finally {
        // Clean up
        _delayedEvents.remove(delayId);
      }
    });

    // Track delayed event
    _delayedEvents[delayId] = _DelayedEventInfo(
      timer: timer,
      roomId: roomId,
      eventType: eventType,
      content: content,
      stateKey: stateKey,
      delay: delay,
    );

    return {'delay_id': delayId};
  }

  Future<Map<String, dynamic>> _updateDelayedEvent(
    String delayId,
    String action,
  ) async {
    final delayedEvent = _delayedEvents[delayId];
    if (delayedEvent == null) {
      throw const WidgetError('Delayed event not found');
    }

    switch (action) {
      case 'send':
        // Send immediately
        delayedEvent.timer.cancel();
        try {
          if (delayedEvent.stateKey != null) {
            await client.setRoomStateWithKey(
              delayedEvent.roomId,
              delayedEvent.eventType,
              delayedEvent.stateKey!,
              delayedEvent.content,
            );
          } else {
            await room.sendEvent(
              delayedEvent.content,
              type: delayedEvent.eventType,
            );
          }
        } finally {
          _delayedEvents.remove(delayId);
        }

      case 'cancel':
        // Cancel the event
        delayedEvent.timer.cancel();
        _delayedEvents.remove(delayId);

      case 'restart':
        // Restart the timer with original delay
        delayedEvent.timer.cancel();

        final newTimer =
            Timer(Duration(milliseconds: delayedEvent.delay), () async {
          try {
            // Send the event
            if (delayedEvent.stateKey != null) {
              await client.setRoomStateWithKey(
                delayedEvent.roomId,
                delayedEvent.eventType,
                delayedEvent.stateKey!,
                delayedEvent.content,
              );
            } else {
              await room.sendEvent(
                delayedEvent.content,
                type: delayedEvent.eventType,
              );
            }
          } catch (e) {
            Logs().e('MatrixDriver: Failed to send delayed event $delayId', e);
          } finally {
            // Clean up
            _delayedEvents.remove(delayId);
          }
        });

        delayedEvent.timer = newTimer;

      default:
        throw WidgetError('Unknown action: $action');
    }

    return {};
  }

  Future<Map<String, dynamic>> _getTurnServers() async {
    if (!capabilities.canGetTurnServers()) {
      throw WidgetErrors.capabilityNotGranted;
    }

    final response = await client.request(
      RequestType.GET,
      '/client/v3/voip/turnServer',
    );

    return {
      'uris': response['uris'] as List<dynamic>,
      'username': response['username'] as String,
      'password': response['password'] as String,
      'ttl': response['ttl'] as int,
    };
  }

  Future<Map<String, dynamic>> _searchUsers(
    String searchTerm,
    int? limit,
  ) async {
    // MSC3973: User directory search
    final results = await client.searchUserDirectory(
      searchTerm,
      limit: limit ?? 10,
    );

    return {
      'results': results.results
          .map(
            (user) => {
              'user_id': user.userId,
              'display_name': user.displayName,
              'avatar_url': user.avatarUrl?.toString(),
            },
          )
          .toList(),
      'limited': results.limited,
    };
  }

  Future<Map<String, dynamic>> _uploadFile(
    List<int> file,
    String? filename,
    String? mimetype,
  ) async {
    // MSC4039: Media upload
    final uri = await client.uploadContent(
      Uint8List.fromList(file),
      filename: filename,
      contentType: mimetype,
    );

    return {'content_uri': uri.toString()};
  }

  Future<Map<String, dynamic>> _downloadFile(String mxcUri) async {
    // MSC4039: Media download
    final uri = Uri.parse(mxcUri);

    // Download via HTTP client
    final downloadUri = await uri.getDownloadUri(client);
    final response = await client.httpClient.get(downloadUri);

    return {
      'file': response.bodyBytes,
      'content_type':
          response.headers['content-type'] ?? 'application/octet-stream',
    };
  }
}
