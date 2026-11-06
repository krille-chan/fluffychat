// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/call_keys_event_content.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_rtc_call_member.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_rtc_room_client_extensions.dart';
import 'package:matrix/matrix.dart';

typedef MatrixRtcKey = ({Uint8List key, int index, String participantId});

/// An active MatrixRTC call. Handles the membership state, the key sharing
/// and hand raising. Knows nothing about LiveKit.
class MatrixRtcCall {
  final Room room;
  final MatrixRtcCallIntent intent;
  late final MatrixRtcCredentials credentials;

  // Not broadcast, so keys arriving before anyone listens are buffered.
  final _onNewKey = StreamController<MatrixRtcKey>();
  final _onChanged = StreamController<void>.broadcast();
  final _onHandRaised = StreamController<String>.broadcast();

  /// Own and remote keys. Own keys have `participantId == ownMembershipId`.
  Stream<MatrixRtcKey> get onNewKey => _onNewKey.stream;

  /// Call members or raised hands have changed.
  Stream<void> get onChanged => _onChanged.stream;

  /// The user ID of a participant who just raised their hand.
  Stream<String> get onHandRaised => _onHandRaised.stream;

  StreamSubscription? _onCallEncryptionKeysSub, _onCallMembersChanged;
  Timer? _resendCallMemberState;
  Timeline? _timeline;

  Set<String> _lastSharedParticipants = {};
  DateTime? _keyCreatedAt;
  Uint8List? _lastKey;
  int _keyIndex = 0;

  String get ownMembershipId => '${room.client.userID}:${room.client.deviceID}';

  MatrixRtcCall._(this.room, this.intent) {
    _onCallEncryptionKeysSub = room.client.onCallEncryptionKeys.listen(
      _onCallEncryptionKeys,
    );
  }

  static Future<MatrixRtcCall> join(
    Room room, {
    MatrixRtcCallIntent intent = MatrixRtcCallIntent.video,
    List<String>? urls,
  }) async {
    final call = MatrixRtcCall._(room, intent);
    try {
      await call._join(urls);
      return call;
    } catch (_) {
      call.dispose();
      rethrow;
    }
  }

  Future<void> _join(List<String>? urls) async {
    await room.postLoad();
    if (room.ownMatrixRtcMembership != null) {
      Logs().w(
        'User has already an active rtc membership state in this room. Resetting it now...',
      );
    }
    Logs().d('[Join MatrixRtc Call] (1/5) Get LiveKit Backend Urls...');

    final hasActiveMatrixRtcCall = room.hasActiveMatrixRtcCall;

    urls ??= room
        .getActiveMatrixRtcMembers()
        .map(
          (state) =>
              state.fociPreferred.map((focus) => focus.livekitServiceUrl),
        )
        .fold<List<String>>([], (urls, foci) => [...urls, ...foci]);

    if (urls.isEmpty) {
      urls.addAll(await room.client.getLiveKitServiceUrls());
    }

    Logs().v('Available SFUs', urls);
    if (urls.isEmpty) {
      throw Exception('This server does not support livekit calls!');
    }

    Logs().d(
      '[Join MatrixRtc Call] (2/5) Set "${MatrixRtcCallMember.eventType}" State event...',
    );
    await _setMembershipState(
      urls
          .map(
            (url) => MatrixRtcFocusPreferred(
              type: 'livekit',
              livekitServiceUrl: url,
              livekitAlias: room.id,
            ),
          )
          .toList(),
    );

    if (!hasActiveMatrixRtcCall) {
      final dmUserId = room.directChatMatrixID;
      if (dmUserId != null) {
        await room.sendRtcNotification(type: .ring, userIds: [dmUserId]);
      } else {
        await room.sendRtcNotification(type: .notification, mentionRoom: true);
      }
    }

    credentials = await _authenticate(urls, hasActiveMatrixRtcCall);

    _timeline = await room.getTimeline(onInsert: _onNewTimelineEvent);
    _onCallMembersChanged = room.client.onSync.stream
        .where(
          (syncUpdate) => [
            ...?syncUpdate.rooms?.join?[room.id]?.timeline?.events,
            ...?syncUpdate.rooms?.join?[room.id]?.state,
          ].any((event) => event.type == MatrixRtcCallMember.eventType),
        )
        .listen((_) {
          _onChanged.add(null);
          _createKeyAndShare();
        });
    await _createKeyAndShare();

    _resendCallMemberState = Timer.periodic(const Duration(hours: 1), (_) {
      final ownMembership = room.ownMatrixRtcMembership;
      if (ownMembership == null) {
        _resendCallMemberState?.cancel();
        return;
      }
      _setMembershipState(ownMembership.fociPreferred);
    });
  }

  Future<MatrixRtcCredentials> _authenticate(
    List<String> urls,
    bool hasActiveMatrixRtcCall,
  ) async {
    Logs().v('[Join MatrixRtc Call] (3/5) Request OpenId Token...');
    final openIdCredentials = await room.client.requestOpenIdToken(
      room.client.userID!,
      {},
    );

    for (final url in urls) {
      try {
        Logs().d(
          '[Join MatrixRtc Call] (4/5) Try authenticate to LiveKit instance $url...',
        );
        final response = await room.client.httpClient.post(
          Uri.parse('${url.replaceAll(RegExp(r'/+$'), '')}/sfu/get'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'room': room.id,
            'openid_token': openIdCredentials.toJson(),
            'device_id': room.client.deviceID,
          }),
        );
        if (response.statusCode != 200) {
          throw Exception(response.reasonPhrase ?? response.body);
        }
        final json =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, Object?>;
        Logs().d('Use SFU', url);
        return MatrixRtcCredentials.fromJson(json);
      } catch (e) {
        Logs().v(
          '[Join MatrixRtc Call] (4/4) Unable to authenticate to $url',
          e,
        );
      }
    }
    throw Exception(
      'Unable to authenticate to any of the visible LiveKit instances!\nSFU list: $urls\nActive Call: $hasActiveMatrixRtcCall',
    );
  }

  Future<void> _setMembershipState(
    List<MatrixRtcFocusPreferred> fociPreferred,
  ) => room.client.setRoomStateWithKey(
    room.id,
    MatrixRtcCallMember.eventType,
    room.ownMatrixRtcMembershipStateKey,
    MatrixRtcCallMember(
      application: 'm.call',
      callId: '',
      deviceId: room.client.deviceID,
      expires: Duration(hours: 4),
      createdAt: DateTime.now(),
      fociPreferred: fociPreferred,
      focusActive: MatrixRtcFocusActive(
        focusSelection: 'oldest_membership',
        type: 'livekit',
      ),
      callIntent: intent,
      membershipId: ownMembershipId,
      scope: 'm.room',
      senderId: null,
    ).toJson(),
  );

  void _onCallEncryptionKeys(CallKeysEvent event) {
    final callKeys = event.callKeysContent;
    final knownCallId = room.ownMatrixRtcMembership?.callId;
    if (callKeys.roomId != room.id ||
        (knownCallId != null && callKeys.session.callId != knownCallId)) {
      Logs().d('Received call key for wrong group call.');
      return;
    }
    if (_onNewKey.isClosed) return;
    _onNewKey.add((
      key: base64Decode(callKeys.keys.key),
      index: callKeys.keys.index,
      participantId: '${event.sender}:${callKeys.member.claimedDeviceId}',
    ));
  }

  Future<void> _createKeyAndShare() async {
    final currentParticipants =
        room
            .getActiveMatrixRtcMembers()
            .map((member) => member.membershipId)
            .whereType<String>()
            .toSet()
          ..remove(ownMembershipId);

    if (const SetEquality<String>().equals(
          currentParticipants,
          _lastSharedParticipants,
        ) &&
        currentParticipants.isNotEmpty) {
      Logs().d(
        'Participant list has not changed. No need to share keys again!',
      );
      return;
    }

    final keyCreatedAt = _keyCreatedAt;
    final canJustForwardToNewUsers =
        keyCreatedAt != null &&
        DateTime.now().difference(keyCreatedAt).inSeconds < 15 &&
        _lastSharedParticipants.difference(currentParticipants).isEmpty;

    var key = _lastKey;
    if (key == null || !canJustForwardToNewUsers) {
      final rng = Random.secure();
      if (key != null) _keyIndex = (_keyIndex + 1) % 256;
      key = Uint8List.fromList(List.generate(16, (_) => rng.nextInt(256)));
      _keyCreatedAt = DateTime.now();
      _lastKey = key;
      if (_onNewKey.isClosed) return;
      _onNewKey.add((
        key: key,
        index: _keyIndex,
        participantId: ownMembershipId,
      ));
    }

    final forwardParticipants = canJustForwardToNewUsers
        ? currentParticipants.difference(_lastSharedParticipants)
        : currentParticipants;
    final deviceKeys = <DeviceKeys>[];
    for (final membershipId in forwardParticipants) {
      final membershipParts = membershipId.split(':');
      final deviceId = membershipParts.removeLast();
      final userId = membershipParts.join(':');
      final keys = room.client.userDeviceKeys[userId]?.deviceKeys[deviceId];
      if (keys == null) {
        Logs().w('No device keys found for $membershipId');
        continue;
      }
      deviceKeys.add(keys);
    }

    _lastSharedParticipants = currentParticipants;
    await _shareKey(key, _keyIndex, deviceKeys);
  }

  Future<void> _shareKey(
    Uint8List key,
    int index,
    List<DeviceKeys> deviceKeys,
  ) async {
    if (deviceKeys.isEmpty) {
      Logs().d('No devices to share call keys with');
      return;
    }
    Logs().d(
      'Share call keys with',
      deviceKeys.map((key) => '${key.userId}:${key.deviceId}'),
    );

    final doNotEncryptTo = deviceKeys.where((d) => !d.encryptToDevice);
    if (doNotEncryptTo.isNotEmpty) {
      Logs().w(
        'Not sharing keys with ${doNotEncryptTo.length} device(s) because of key sharing restrictions!',
      );
      deviceKeys.removeWhere((d) => !d.encryptToDevice);
    }

    await room.client.sendToDeviceEncrypted(
      deviceKeys,
      CallKeysEventContent.eventType,
      CallKeysEventContent(
        keys: CallKeysEntry(index: index, key: base64Encode(key)),
        member: CallKeysMember(
          id: ownMembershipId,
          claimedDeviceId: room.client.deviceID!,
        ),
        roomId: room.id,
        sentTs: DateTime.now().millisecondsSinceEpoch,
        session: CallKeysSession(
          application: 'm.call',
          callId: '',
          scope: 'm.room',
        ),
      ).toJson(),
    );
  }

  static bool _isRaiseHandReaction(Event event) =>
      event.content
          .tryGetMap<String, Object?>('m.relates_to')
          ?.tryGet<String>('key') ==
      '🖐️';

  Event? get _ownMemberStateEvent =>
      room.states[MatrixRtcCallMember.eventType]?[room
              .ownMatrixRtcMembershipStateKey]
          as Event?;

  Future<void> _onNewTimelineEvent(int i) async {
    final timeline = _timeline;
    final event = timeline?.events[i];
    if (timeline == null || event == null) return;
    switch (event.type) {
      case 'io.element.call.reaction':
        Logs().d(
          'Call reactions are not yet handled',
          event.content.tryGet<String>('emoji'),
        );
        // TODO: handle reaction
        break;
      case EventTypes.Reaction:
        final reactedEvent = await timeline.getEventById(
          event.relationshipEventId!,
        );
        if (reactedEvent != null &&
            reactedEvent.type == MatrixRtcCallMember.eventType &&
            event.senderId == reactedEvent.senderId &&
            _isRaiseHandReaction(event) &&
            !_onHandRaised.isClosed) {
          Logs().d('User raised hand!');
          _onHandRaised.add(event.senderId);
          _onChanged.add(null);
        }
        break;
      case EventTypes.Redaction:
        if (!_onChanged.isClosed) _onChanged.add(null);
        break;
    }
  }

  bool userHasHandRaised(String userId) {
    final timeline = _timeline;
    if (timeline == null) return false;
    // A user raises their hand by reacting to their own member state event.
    return room.states[MatrixRtcCallMember.eventType]?.values.any(
          (state) =>
              state is Event &&
              state.senderId == userId &&
              (timeline.aggregatedEvents[state.eventId]?['m.annotation']?.any(
                    (event) =>
                        event.senderId == userId && _isRaiseHandReaction(event),
                  ) ??
                  false),
        ) ??
        false;
  }

  Future<String?> raiseHand() async {
    final ownMemberStateEvent = _ownMemberStateEvent;
    if (ownMemberStateEvent == null) return null;
    return await room.sendReaction(ownMemberStateEvent.eventId, '🖐️');
  }

  Future<String?> lowerHand() async {
    final ownMemberStateEvent = _ownMemberStateEvent;
    if (ownMemberStateEvent == null) return null;
    final reaction = _timeline?.events.firstWhereOrNull(
      (event) =>
          event.type == EventTypes.Reaction &&
          event.relationshipEventId == ownMemberStateEvent.eventId &&
          event.senderId == room.client.userID &&
          event.status.isSent &&
          _isRaiseHandReaction(event),
    );
    if (reaction == null) {
      throw Exception('Hand raise reaction event not found!');
    }
    return await reaction.redactEvent();
  }

  /// Sends the empty member state event and then disposes the call.
  Future<void> leave() async {
    dispose();
    if (room.ownMatrixRtcMembership == null) return;
    await room.client.setRoomStateWithKey(
      room.id,
      MatrixRtcCallMember.eventType,
      room.ownMatrixRtcMembershipStateKey,
      {},
    );
  }

  /// Stops all listeners and closes the streams. Does NOT leave the call.
  void dispose() {
    _onCallEncryptionKeysSub?.cancel();
    _onCallMembersChanged?.cancel();
    _resendCallMemberState?.cancel();
    _timeline?.cancelSubscriptions();
    _onNewKey.close();
    _onChanged.close();
    _onHandRaised.close();
  }
}
