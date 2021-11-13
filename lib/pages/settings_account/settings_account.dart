import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/settings_account/settings_account_view.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SettingsAccount extends StatefulWidget {
  const SettingsAccount({Key key}) : super(key: key);

  @override
  SettingsAccountController createState() => SettingsAccountController();
}

class SettingsAccountController extends State<SettingsAccount> {
  Future<dynamic> profileFuture;
  Profile profile;
  bool profileUpdated = false;

  void updateProfile() => setState(() {
        profileUpdated = true;
        profile = profileFuture = null;
      });

  void setDisplaynameAction() async {
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context).editDisplayname,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      textFields: [
        DialogTextField(
          initialText: profile?.displayName ??
              Matrix.of(context).client.userID.localpart,
        )
      ],
    );
    if (input == null) return;
    final matrix = Matrix.of(context);
    final success = await showFutureLoadingDialog(
      context: context,
      future: () =>
          matrix.client.setDisplayName(matrix.client.userID, input.single),
    );
    if (success.error == null) {
      updateProfile();
    }
  }

  void logoutAction() async {
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context).areYouSureYouWantToLogout,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    final matrix = Matrix.of(context);
    await showFutureLoadingDialog(
      context: context,
      future: () => matrix.client.logout(),
    );
  }

  void deleteAccountAction() async {
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context).warning,
          message: L10n.of(context).deactivateAccountWarning,
          okLabel: L10n.of(context).ok,
          cancelLabel: L10n.of(context).cancel,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: L10n.of(context).areYouSure,
          okLabel: L10n.of(context).yes,
          cancelLabel: L10n.of(context).cancel,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context).pleaseEnterYourPassword,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
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
                  user: Matrix.of(context).client.userID),
            ),
          ),
    );
  }

  void addAccountAction() => VRouter.of(context).to('add');

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    profileFuture ??= client
        .getProfileFromUserId(
      client.userID,
      cache: !profileUpdated,
      getFromRooms: !profileUpdated,
    )
        .then((p) {
      if (mounted) setState(() => profile = p);
      return p;
    });
    return SettingsAccountView(this);
  }
}
