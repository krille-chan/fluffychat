import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'ui/settings_3pid_ui.dart';

class Settings3Pid extends StatefulWidget {
  static int sendAttempt = 0;

  @override
  Settings3PidController createState() => Settings3PidController();
}

class Settings3PidController extends State<Settings3Pid> {
  void add3PidAction() async {
    final input = await showTextInputDialog(
      context: context,
      title: L10n.of(context).enterAnEmailAddress,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      useRootNavigator: false,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).enterAnEmailAddress,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
    if (input == null) return;
    final clientSecret = DateTime.now().millisecondsSinceEpoch.toString();
    final response = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.requestEmailToken(
            input.single,
            clientSecret,
            Settings3Pid.sendAttempt++,
          ),
    );
    if (response.error != null) return;
    final ok = await showOkAlertDialog(
      context: context,
      title: L10n.of(context).weSentYouAnEmail,
      message: L10n.of(context).pleaseClickOnLink,
      okLabel: L10n.of(context).iHaveClickedOnLink,
      useRootNavigator: false,
    );
    if (ok == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.uiaRequestBackground(
            (auth) => Matrix.of(context).client.add3PID(
                  clientSecret,
                  response.result.sid,
                  auth: auth,
                ),
          ),
    );
    if (success.error != null) return;
    setState(() => request = null);
  }

  Future<List<ThirdPartyIdentifier>> request;

  void delete3Pid(ThirdPartyIdentifier identifier) async {
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
          useRootNavigator: false,
        ) !=
        OkCancelResult.ok) {
      return;
    }
    final success = await showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context).client.delete3pidFromAccount(
              identifier.address,
              identifier.medium,
            ));
    if (success.error != null) return;
    setState(() => request = null);
  }

  @override
  Widget build(BuildContext context) => Settings3PidUI(this);
}
