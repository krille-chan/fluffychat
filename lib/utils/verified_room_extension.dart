// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';

extension VerifiedRoomExtension on Room {
  bool get allUsersVerified {
    final users = getParticipants();
    return !users.any(
      (user) => client.userDeviceKeys[user.id]?.masterKey?.verified != true,
    );
  }
}
