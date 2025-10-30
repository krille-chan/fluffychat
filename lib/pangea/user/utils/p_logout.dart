import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

void pLogoutAction(
  BuildContext context, {
  bool? isDestructiveAction,
  bool bypassWarning = false,
}) async {
  if (!bypassWarning) {
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context).areYouSureYouWantToLogout,
          message: L10n.of(context).dontForgetPassword,
          okLabel: L10n.of(context).logout,
          cancelLabel: L10n.of(context).cancel,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
  }

  final client = Matrix.of(context).client;

  // before wiping out locally cached construct data, save it to the server
  await MatrixState.pangeaController.putAnalytics
      .sendLocalAnalyticsToAnalyticsRoom(onLogout: true);

  final redirect = client.onLoginStateChanged.stream
      .where((state) => state != LoginState.loggedIn)
      .first
      .then(
    (_) {
      final route = FluffyChatApp.router.state.fullPath;
      if (route == null || !route.contains("/home")) {
        context.go("/home");
      }
    },
  ).timeout(const Duration(seconds: 30));

  await showFutureLoadingDialog(
    context: context,
    future: () => client.logout(),
  );

  await redirect;
}
