// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:matrix/matrix.dart';

// Workaround until https://github.com/famedly/matrix-dart-sdk/pull/2360
Future<void> onSoftLogout(Client client) async {
  try {
    await client.refreshAccessToken();
  } on MatrixException catch (_) {
    rethrow;
  } catch (e, s) {
    Logs().w('Unable to refresh the access token. Try again...', e, s);
  }
}
