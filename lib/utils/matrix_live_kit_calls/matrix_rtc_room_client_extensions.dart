// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:async/async.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/call_keys_event_content.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_rtc_call.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_rtc_call_member.dart';
import 'package:matrix/matrix.dart' hide Result;

extension MatrixRtcClientExtension on Client {
  Future<List<String>> getLiveKitServiceUrls() async {
    final wellKnown = await getWellknown();

    final rtcTransportsResult = await Result.capture(
      request(
        .GET,
        '/_matrix/client/unstable/org.matrix.msc4143/rtc/transports',
      ),
    );
    final rtcTransports =
        rtcTransportsResult.asValue?.value
            .tryGetList<Map<String, Object?>>('transports')
            ?.where((map) => map.tryGet<String>('type') == 'm.livekit')
            .map((map) => map.tryGet<String>('url'))
            .whereType<String>()
            .toList() ??
        [];
    if (rtcTransports.isNotEmpty) return rtcTransports;

    final rtcFociMap = wellKnown.additionalProperties
        .tryGetMap<String, Object?>(
          'org.matrix.msc4143.rtc_foci',
          TryGet.silent,
        ); // Famedly style
    if (rtcFociMap != null) {
      return [?rtcFociMap.tryGet<String>('livekit_service_url')];
    }

    return wellKnown.additionalProperties
            .tryGetList<Map<String, Object?>>('org.matrix.msc4143.rtc_foci')
            ?.map((foci) => foci.tryGet<String>('livekit_service_url'))
            .whereType<String>()
            .toList() ??
        [
          if (AppSettings.fallbackLiveKitInstance.value.isNotEmpty)
            AppSettings.fallbackLiveKitInstance.value,
        ];
  }

  Stream<CallKeysEvent> get onCallEncryptionKeys => onToDeviceEvent.stream
      .where((event) => event.type == CallKeysEventContent.eventType)
      .map(CallKeysEvent.fromToDeviceEvent);
}

extension MatrixRtcRoomExtension on Room {
  bool get hasActiveMatrixRtcCall => getActiveMatrixRtcMembers().isNotEmpty;

  MatrixRtcCallIntent? get activeMatrixRtcCallIntent {
    final members = getActiveMatrixRtcMembers();
    if (members.isEmpty) return null;
    if (members.any((member) => member.callIntent == .video)) return .video;
    return .voice;
  }

  bool get hasPermissionForMatrixRtcCall =>
      canChangeStateEvent(MatrixRtcCallMember.eventType);

  List<MatrixRtcCallMember> getActiveMatrixRtcMembers() {
    final states = this.states[MatrixRtcCallMember.eventType];
    if (states == null) return [];
    // Empty content {} means the member has left — filter those out
    final activeMemberStates = states.values.where((event) {
      if (event.content.isEmpty) return false;
      if (event is! Event) return false;
      try {
        final validContent = MatrixRtcCallMember.fromJson(
          event.content,
          senderId: event.senderId,
        );
        if (validContent.focusActive?.type != 'livekit') return false;
        final expiresAt = (validContent.createdAt ?? event.originServerTs).add(
          validContent.expires,
        );
        if (expiresAt.isBefore(DateTime.now())) return false;
        return true;
      } catch (e, s) {
        Logs().d('Invalid "org.matrix.msc3401.call.member" event!', e, s);
        return false;
      }
    });
    return activeMemberStates
        .map(
          (state) => MatrixRtcCallMember.fromJson(
            state.content,
            senderId: state.senderId,
          ),
        )
        .toList();
  }

  String get ownMatrixRtcMembershipStateKey =>
      '_${client.userID}_${client.deviceID}_m.call';

  MatrixRtcCallMember? get ownMatrixRtcMembership {
    final state = getState(
      MatrixRtcCallMember.eventType,
      ownMatrixRtcMembershipStateKey,
    );
    if (state == null || state.content.isEmpty) return null;
    try {
      return MatrixRtcCallMember.fromJson(
        state.content,
        senderId: state.senderId,
      );
    } catch (e, s) {
      Logs().d(
        'Unknown format for ${MatrixRtcCallMember.eventType} event',
        e,
        s,
      );
      return null;
    }
  }

  Future<MatrixRtcCall> joinMatrixRtcCall({
    MatrixRtcCallIntent intent = MatrixRtcCallIntent.video,
    List<String>? urls,
  }) => MatrixRtcCall.join(this, intent: intent, urls: urls);
}

class MatrixRtcCredentials {
  final String url, jwt;
  const MatrixRtcCredentials({required this.url, required this.jwt});
  factory MatrixRtcCredentials.fromJson(Map<String, Object?> json) =>
      MatrixRtcCredentials(
        url: json['url'] as String,
        jwt: json['jwt'] as String,
      );
}

enum MatrixRtcCallIntent {
  voice(callKitType: 0),
  video(callKitType: 1);

  final int callKitType;
  const MatrixRtcCallIntent({required this.callKitType});
}
