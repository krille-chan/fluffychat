// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/matrix_live_kit_calls/matrix_live_kit_call.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

CallKitParams buildFluffyChatCallKitParams(
  Room room,
  L10n l10n, {
  MatrixRtcCallIntent intent = .video,
}) => CallKitParams(
  id: Uuid().v4(),
  extra: {'roomId': room.id, 'clientName': room.client.clientName},
  appName: AppSettings.applicationName.value,
  nameCaller: room.getLocalizedDisplayname(),
  handle: l10n.incomingCall,
  type: intent.callKitType,
  duration: 30000,
  android: AndroidParams(textAccept: l10n.accept, textDecline: l10n.decline),
  ios: const IOSParams(
    iconName: 'LaunchImage',
    handleType: 'generic',
    supportsVideo: true,
    maximumCallGroups: 1,
    maximumCallsPerCallGroup: 1,
    audioSessionMode: 'default',
    audioSessionActive: true,
  ),
);
