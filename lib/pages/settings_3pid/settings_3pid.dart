import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import 'settings_3pid_view.dart';

class Settings3Pid extends StatefulWidget {
  static int sendAttempt = 0;

  const Settings3Pid({super.key});

  @override
  Settings3PidController createState() => Settings3PidController();
}

class Settings3PidController extends State<Settings3Pid> {
  Future<void> add3PidAction() async {
    final l10n = L10n.of(context);
    final matrix = Matrix.of(context);
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: l10n.enterAnEmailAddress,
      okLabel: l10n.ok,
      cancelLabel: l10n.cancel,
      hintText: l10n.enterAnEmailAddress,
      keyboardType: TextInputType.emailAddress,
    );
    if (input == null) return;
    if (!mounted) return;
    final clientSecret = DateTime.now().millisecondsSinceEpoch.toString();
    final response = await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.requestTokenToRegisterEmail(
        clientSecret,
        input,
        Settings3Pid.sendAttempt++,
      ),
    );
    if (response.error != null) return;
    if (!mounted) return;
    final ok = await showOkAlertDialog(
      useRootNavigator: false,
      context: context,
      title: l10n.weSentYouAnEmail,
      message: l10n.pleaseClickOnLink,
      okLabel: l10n.iHaveClickedOnLink,
    );
    if (ok != OkCancelResult.ok) return;
    if (!mounted) return;
    final success = await showFutureLoadingDialog(
      context: context,
      delay: false,
      future: () => matrix.client.uiaRequestBackground(
        (auth) => matrix.client.add3PID(
          clientSecret,
          response.result!.sid,
          auth: auth,
        ),
      ),
    );
    if (success.error != null) return;
    setState(() => request = null);
  }

  Future<List<ThirdPartyIdentifier>?>? request;

  Future<void> delete3Pid(ThirdPartyIdentifier identifier) async {
    final l10n = L10n.of(context);
    final matrix = Matrix.of(context);
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: l10n.areYouSure,
          okLabel: l10n.yes,
          cancelLabel: l10n.cancel,
        ) !=
        OkCancelResult.ok) {
      return;
    }
    if (!mounted) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.delete3pidFromAccount(
        identifier.address,
        identifier.medium,
      ),
    );
    if (success.error != null) return;
    setState(() => request = null);
  }

  @override
  Widget build(BuildContext context) => Settings3PidView(this);
}
