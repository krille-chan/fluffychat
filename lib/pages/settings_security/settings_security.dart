import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:intl/intl.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../bootstrap/bootstrap_dialog.dart';
import 'settings_security_view.dart';

class SettingsSecurity extends StatefulWidget {
  const SettingsSecurity({Key? key}) : super(key: key);

  @override
  SettingsSecurityController createState() => SettingsSecurityController();
}

class SettingsSecurityController extends State<SettingsSecurity> {
  void changePasswordAccountAction() async {
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.changePassword,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          hintText: L10n.of(context)!.chooseAStrongPassword,
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        ),
        DialogTextField(
          hintText: L10n.of(context)!.repeatPassword,
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        ),
      ],
    );
    if (input == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context)
          .client
          .changePassword(input.last, oldPassword: input.first),
    );
    if (success.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L10n.of(context)!.passwordHasBeenChanged)),
      );
    }
  }

  void setAppLockAction() async {
    final currentLock =
        await const FlutterSecureStorage().read(key: SettingKeys.appLockKey);
    if (currentLock?.isNotEmpty ?? false) {
      await AppLock.of(context)!.showLockScreen();
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
        )
      ],
    );
    if (newLock != null) {
      await const FlutterSecureStorage()
          .write(key: SettingKeys.appLockKey, value: newLock.single);
      if (newLock.single.isEmpty) {
        AppLock.of(context)!.disable();
      } else {
        AppLock.of(context)!.enable();
      }
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
      textFields: [
        const DialogTextField(
          obscureText: true,
          hintText: '******',
          minLines: 1,
          maxLines: 1,
        )
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

  Future<void> dehydrateAction() => dehydrateDevice(context);

  static Future<void> dehydrateDevice(BuildContext context) async {
    final response = await showOkCancelAlertDialog(
      context: context,
      isDestructiveAction: true,
      title: L10n.of(context)!.dehydrate,
      message: L10n.of(context)!.dehydrateWarning,
    );
    if (response != OkCancelResult.ok) {
      return;
    }
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        try {
          final export = await Matrix.of(context).client.exportDump();
          final filePickerCross = FilePickerCross(
            Uint8List.fromList(const Utf8Codec().encode(export!)),
            path:
                '/fluffychat-export-${DateFormat(DateFormat.YEAR_MONTH_DAY).format(DateTime.now())}.fluffybackup',
            fileExtension: 'fluffybackup',
          );
          await filePickerCross.exportToStorage(
            subject: L10n.of(context)!.dehydrateShare,
          );
        } catch (e, s) {
          Logs().e('Export error', e, s);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => SettingsSecurityView(this);
}
