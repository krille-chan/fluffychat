// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:fluffychat/utils/error_reporter.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:matrix/matrix.dart';

// Workaround until https://github.com/famedly/matrix-dart-sdk/pull/2360
Future<void> onSoftLogout(Client client) async {
  try {
    await client.refreshAccessToken();
  } on MatrixException catch (_) {
    rethrow;
  } on IOException catch (_) {
    rethrow;
  } catch (e, s) {
    final context =
        FluffyChatApp.router.routerDelegate.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      ErrorReporter(
        context,
        'Error on refresh access token!',
      ).onErrorCallback(e, s);
    }
    rethrow;
  }
}
