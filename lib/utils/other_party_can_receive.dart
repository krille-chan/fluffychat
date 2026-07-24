// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';

extension OtherPartyCanReceiveExtension on Room {
  Future<bool> otherPartyCanReceiveMessages() async {
    if (!encrypted) return true;
    final keys = await getUserDeviceKeys();
    final users = getParticipants()
        .map((u) => u.id)
        .where((userId) => userId != client.userID)
        .toSet();
    if (users.isEmpty) return true;

    return keys.any((key) => key.userId != client.userID);
  }
}

class OtherPartyCanNotReceiveMessages implements Exception {}
