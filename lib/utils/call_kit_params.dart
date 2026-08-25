// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call.dart';
import 'package:fluffychat/utils/notification_avatar_extension.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

Future<CallKitParams> buildFluffyChatCallKitParams(
  Room room,
  L10n l10n, {
  MatrixRtcCallIntent intent = .video,
  Duration timeout = RtcNotificationContent.defaultLifetime,
}) async {
  final avatarUrl = await room.avatar?.getThumbnailUri(
    room.client,
    width: notificationAvatarDimension,
    height: notificationAvatarDimension,
    method: ThumbnailMethod.crop,
  );

  return CallKitParams(
    id: Uuid().v4(),
    extra: {
      'roomId': room.id,
      'clientName': room.client.clientName,
      'intent': intent.name,
    },
    appName: AppSettings.applicationName.value,
    nameCaller: room.getLocalizedDisplayname(),
    avatar: avatarUrl?.toString(),
    handle: switch (intent) {
      MatrixRtcCallIntent.voice => l10n.voiceCall,
      MatrixRtcCallIntent.video => l10n.videoCall,
    },
    type: intent.callKitType,
    duration: timeout.inMilliseconds,
    headers: avatarUrl == null
        ? null
        : {'authorization': 'Bearer ${room.client.accessToken}'},
    missedCallNotification: NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: l10n.missedCall,
      callbackText: l10n.callBack,
    ),
    callingNotification: NotificationParams(
      showNotification: true,
      isShowCallback: true,
      subtitle: l10n.waitingForParticipant,
      callbackText: l10n.hangUp,
    ),
    android: AndroidParams(
      textAccept: l10n.accept,
      textDecline: l10n.decline,
      ringtonePath: 'system_ringtone_default',
      incomingCallNotificationChannelName: l10n.incomingCall,
      missedCallNotificationChannelName: l10n.missedCall,
    ),
    ios: IOSParams(
      iconName: 'LaunchImage',
      handleType: 'generic',
      supportsVideo: intent == .video,
      maximumCallGroups: 1,
      maximumCallsPerCallGroup: 1,
      supportsDTMF: false,
      supportsHolding: false,
      supportsGrouping: false,
      supportsUngrouping: false,
      includesCallsInRecents: true,
      ringtonePath: 'system_ringtone_default',
      audioSessionMode: switch (intent) {
        .video => 'videoChat',
        .voice => 'voiceChat',
      },
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
    ),
  );
}
