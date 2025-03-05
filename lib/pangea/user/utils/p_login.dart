import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/login/login.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/pangea/login/widgets/p_sso_button.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

void pLoginAction({
  required LoginController controller,
  required BuildContext context,
}) async {
  final valid = controller.formKey.currentState!.validate();
  if (!valid) return;

  await showFutureLoadingDialog(
    context: context,
    future: () => _loginFuture(
      controller: controller,
      context: context,
    ),
    onError: (e, s) {
      controller.setLoadingSignIn(false);
      controller.setLoadingSSO(false, SSOProvider.apple);
      controller.setLoadingSSO(false, SSOProvider.google);
      return e is MatrixException
          ? e.errorMessage
          : L10n.of(context).oopsSomethingWentWrong;
    },
  );
}

Future<void> _loginFuture({
  required LoginController controller,
  required BuildContext context,
}) async {
  final matrix = Matrix.of(context);
  controller.setLoadingSignIn(true);

  String username = controller.usernameController.text.trim();
  if (RegExp(r'^@(\w+):').hasMatch(username)) {
    username = RegExp(r'^@(\w+):').allMatches(username).elementAt(0).group(1)!;
  }

  AuthenticationIdentifier identifier;
  if (username.isEmail) {
    identifier = AuthenticationThirdPartyIdentifier(
      medium: 'email',
      address: username,
    );
  } else if (username.isPhoneNumber) {
    identifier = AuthenticationThirdPartyIdentifier(
      medium: 'msisdn',
      address: username,
    );
  } else {
    identifier = AuthenticationUserIdentifier(user: username);
  }

  final loginRes = await matrix.getLoginClient().login(
    LoginType.mLoginPassword,
    identifier: identifier,
    // To stay compatible with older server versions
    // ignore: deprecated_member_use
    user: identifier.type == AuthenticationIdentifierTypes.userId
        ? username
        : null,
    password: controller.passwordController.text.trim(),
    initialDeviceDisplayName: PlatformInfos.clientName,
    onInitStateChanged: (state) {
      if (state == InitState.settingUpEncryption) {
        context.go("/rooms");
      }
    },
  );
  GoogleAnalytics.login("pangea", loginRes.userId);
}
