// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:collection/collection.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call.dart';
import 'package:matrix/matrix_api_lite/utils/try_get_map_extension.dart';

class MatrixRtcCallMember {
  static const String eventType = 'org.matrix.msc3401.call.member';

  final String application;
  final String callId;
  final String? deviceId;
  final DateTime? createdAt;
  final Duration expires;
  final List<MatrixRtcFocusPreferred> fociPreferred;
  final MatrixRtcFocusActive? focusActive;
  final MatrixRtcCallIntent callIntent;
  final String? membershipId;
  final String scope;

  const MatrixRtcCallMember({
    required this.application,
    required this.callId,
    required this.deviceId,
    required this.expires,
    required this.fociPreferred,
    required this.focusActive,
    required this.callIntent,
    required this.membershipId,
    required this.scope,
    required this.createdAt,
  });

  factory MatrixRtcCallMember.fromJson(Map<String, Object?> json) =>
      MatrixRtcCallMember(
        application: json.tryGet<String>('application') ?? '',
        callId: json.tryGet<String>('call_id') ?? '',
        deviceId: json.tryGet<String>('device_id'),
        createdAt: json.tryGet<int>('created_at') == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                json.tryGet<int>('created_at')!,
              ),
        expires: Duration(milliseconds: json.tryGet<int>('expires') ?? 0),
        fociPreferred:
            (json['foci_preferred'] as List?)
                ?.whereType<Map>()
                .map(
                  (e) => MatrixRtcFocusPreferred.fromJson(
                    Map<String, Object?>.from(e),
                  ),
                )
                .toList() ??
            [],
        focusActive: json['focus_active'] is Map
            ? MatrixRtcFocusActive.fromJson(
                Map<String, Object?>.from(json['focus_active'] as Map),
              )
            : null,
        callIntent:
            MatrixRtcCallIntent.values.singleWhereOrNull(
              (intent) => intent.name == json.tryGet<String>('m.call.intent'),
            ) ??
            MatrixRtcCallIntent.video,
        membershipId: json.tryGet<String>('membershipID'),
        scope: json.tryGet<String>('scope') ?? 'm.room',
      );

  Map<String, Object?> toJson() => {
    'application': application,
    'call_id': callId,
    if (deviceId != null) 'device_id': deviceId,
    'expires': expires.inMilliseconds,
    'foci_preferred': fociPreferred.map((f) => f.toJson()).toList(),
    if (focusActive != null) 'focus_active': focusActive!.toJson(),
    'm.call.intent': callIntent.name,
    if (membershipId != null) 'membershipID': membershipId,
    'scope': scope,
    'created_at': ?createdAt?.millisecondsSinceEpoch,
  };
}

class MatrixRtcFocusPreferred {
  final String type;
  final String livekitServiceUrl;
  final String livekitAlias;

  const MatrixRtcFocusPreferred({
    required this.type,
    required this.livekitServiceUrl,
    required this.livekitAlias,
  });

  factory MatrixRtcFocusPreferred.fromJson(Map<String, Object?> json) =>
      MatrixRtcFocusPreferred(
        type: json.tryGet<String>('type') ?? '',
        livekitServiceUrl: json.tryGet<String>('livekit_service_url') ?? '',
        livekitAlias: json.tryGet<String>('livekit_alias') ?? '',
      );

  Map<String, Object?> toJson() => {
    'type': type,
    'livekit_service_url': livekitServiceUrl,
    'livekit_alias': livekitAlias,
  };
}

class MatrixRtcFocusActive {
  final String type;
  final String focusSelection;

  const MatrixRtcFocusActive({
    required this.type,
    required this.focusSelection,
  });

  factory MatrixRtcFocusActive.fromJson(Map<String, Object?> json) =>
      MatrixRtcFocusActive(
        type: json.tryGet<String>('type') ?? '',
        focusSelection: json.tryGet<String>('focus_selection') ?? '',
      );

  Map<String, Object?> toJson() => {
    'type': type,
    'focus_selection': focusSelection,
  };
}
