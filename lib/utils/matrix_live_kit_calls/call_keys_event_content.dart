// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:matrix/matrix.dart';

class CallKeysEvent extends ToDeviceEvent {
  CallKeysEvent._({
    required super.sender,
    required super.type,
    required super.content,
  });

  factory CallKeysEvent.fromToDeviceEvent(ToDeviceEvent event) =>
      CallKeysEvent._(
        content: event.content,
        sender: event.sender,
        type: event.type,
      );

  CallKeysEventContent get callKeysContent =>
      CallKeysEventContent.fromJson(super.content);

  String get key =>
      String.fromCharCodes(base64Decode(callKeysContent.keys.key));
}

/// To-device event content for encryption key exchange (EncryptionKeysToDeviceEventContent).
class CallKeysEventContent {
  static const String eventType = 'io.element.call.encryption_keys';

  final CallKeysEntry keys;
  final CallKeysMember member;
  final String roomId;
  final CallKeysSession session;
  final int? sentTs;

  const CallKeysEventContent({
    required this.keys,
    required this.member,
    required this.roomId,
    required this.session,
    this.sentTs,
  });

  factory CallKeysEventContent.fromJson(Map<String, Object?> json) =>
      CallKeysEventContent(
        keys: CallKeysEntry.fromJson(
          Map<String, Object?>.from(json['keys'] as Map),
        ),
        member: CallKeysMember.fromJson(
          Map<String, Object?>.from(json['member'] as Map),
        ),
        roomId: json['room_id'] as String,
        session: CallKeysSession.fromJson(
          Map<String, Object?>.from(json['session'] as Map),
        ),
        sentTs: json['sent_ts'] as int?,
      );

  Map<String, Object?> toJson() => {
    'keys': keys.toJson(),
    'member': member.toJson(),
    'room_id': roomId,
    'session': session.toJson(),
    if (sentTs != null) 'sent_ts': sentTs,
  };
}

class CallKeysEntry {
  final int index;
  final String key;

  const CallKeysEntry({required this.index, required this.key});

  factory CallKeysEntry.fromJson(Map<String, Object?> json) =>
      CallKeysEntry(index: json['index'] as int, key: json['key'] as String);

  Map<String, Object?> toJson() => {'index': index, 'key': key};
}

class CallKeysMember {
  final String id;
  final String claimedDeviceId;

  const CallKeysMember({required this.id, required this.claimedDeviceId});

  factory CallKeysMember.fromJson(Map<String, Object?> json) => CallKeysMember(
    id: json['id'] as String,
    claimedDeviceId: json['claimed_device_id'] as String,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'claimed_device_id': claimedDeviceId,
  };
}

class CallKeysSession {
  final String application;
  final String callId;
  final String scope;

  const CallKeysSession({
    required this.application,
    required this.callId,
    required this.scope,
  });

  factory CallKeysSession.fromJson(Map<String, Object?> json) =>
      CallKeysSession(
        application: json['application'] as String,
        callId: json['call_id'] as String,
        scope: json['scope'] as String,
      );

  Map<String, Object?> toJson() => {
    'application': application,
    'call_id': callId,
    'scope': scope,
  };
}
