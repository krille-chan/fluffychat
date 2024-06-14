import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/app_lock.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../bootstrap/bootstrap_dialog.dart';
import 'settings_security_view.dart';

class SettingsSecurity extends StatefulWidget {
  const SettingsSecurity({super.key});

  @override
  SettingsSecurityController createState() => SettingsSecurityController();
}

class SettingsSecurityController extends State<SettingsSecurity> {
  void setAppLockAction() async {
    if (AppLock.of(context).isActive) {
      AppLock.of(context).showLockScreen();
    }
    final newLock = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.pleaseChooseAPasscode,
      message: L10n.of(context)!.pleaseEnter4Digits,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          validator: (text) {
            if (text!.isEmpty ||
                (text.length == 4 && int.tryParse(text)! >= 0)) {
              return null;
            }
            return L10n.of(context)!.pleaseEnter4Digits;
          },
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLines: 1,
          minLines: 1,
          maxLength: 4,
        ),
      ],
    );
    if (newLock != null) {
      await AppLock.of(context).changePincode(newLock.single);
    }
  }

  void deleteAccountAction() async {
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context)!.warning,
          message: L10n.of(context)!.deactivateAccountWarning,
          okLabel: L10n.of(context)!.ok,
          cancelLabel: L10n.of(context)!.cancel,
          isDestructiveAction: true,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    final supposedMxid = Matrix.of(context).client.userID!;
    final mxids = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.confirmMatrixId,
      textFields: [
        DialogTextField(
          validator: (text) => text == supposedMxid
              ? null
              : L10n.of(context)!.supposedMxid(supposedMxid),
        ),
      ],
      isDestructiveAction: true,
      okLabel: L10n.of(context)!.delete,
      cancelLabel: L10n.of(context)!.cancel,
    );
    if (mxids == null || mxids.length != 1 || mxids.single != supposedMxid) {
      return;
    }
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.pleaseEnterYourPassword,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      isDestructiveAction: true,
      textFields: [
        const DialogTextField(
          obscureText: true,
          hintText: '******',
          minLines: 1,
          maxLines: 1,
        ),
      ],
    );
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.deactivateAccount(
            auth: AuthenticationPassword(
              password: input.single,
              identifier: AuthenticationUserIdentifier(
                user: Matrix.of(context).client.userID!,
              ),
            ),
          ),
    );
  }

  void showBootstrapDialog(BuildContext context) async {
    await BootstrapDialog(
      client: Matrix.of(context).client,
    ).show(context);
  }

  Future<void> dehydrateAction() => Matrix.of(context).dehydrateAction();

  @override
  Widget build(BuildContext context) => SettingsSecurityView(this);
}
