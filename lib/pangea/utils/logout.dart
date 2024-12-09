import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

void pLogoutAction(BuildContext context, {bool? isDestructiveAction}) async {
  if (await showOkCancelAlertDialog(
        useRootNavigator: false,
        context: context,
        title: L10n.of(context).areYouSureYouWantToLogout,
        message: L10n.of(context).noBackupWarning,
        isDestructiveAction: isDestructiveAction ?? false,
        okLabel: L10n.of(context).logout,
        cancelLabel: L10n.of(context).cancel,
      ) ==
      OkCancelResult.cancel) {
    return;
  }
  final matrix = Matrix.of(context);

  // before wiping out locally cached construct data, save it to the server
  await MatrixState.pangeaController.putAnalytics
      .sendLocalAnalyticsToAnalyticsRoom(onLogout: true);

  await showFutureLoadingDialog(
    context: context,
    future: () => matrix.client.logout(),
  );
}
