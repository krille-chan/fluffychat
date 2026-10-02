// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/oauth_manager.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

import '../../utils/platform_infos.dart';
import 'login_view.dart';

class Login extends StatefulWidget {
  final Client client;
  const Login({required this.client, super.key});

  @override
  LoginController createState() => LoginController();
}

class LoginController extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? usernameError;
  String? passwordError;
  bool loading = false;
  bool showPassword = false;

  void toggleShowPassword() =>
      setState(() => showPassword = !loading && !showPassword);

  Future<void> loginWithGoogle() async {
    setState(() => loading = true);
    try {
      final result = await OAuthManager.signInWithGoogle();
      if (!mounted) return;
      if (result == null) {
        setState(() => usernameError = 'Google sign-in was cancelled');
        return;
      }
      if (result.email != null && result.email!.isNotEmpty) {
        usernameController.text = result.email!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Google account connected. Complete the Matrix login with your account details.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google sign-in failed.')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> loginWithApple() async {
    setState(() => loading = true);
    try {
      final result = await OAuthManager.signInWithApple();
      if (!mounted) return;
      if (result == null) {
        setState(() => usernameError = 'Apple sign-in was cancelled');
        return;
      }
      if (result.email != null && result.email!.isNotEmpty) {
        usernameController.text = result.email!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Apple account connected. Complete the Matrix login with your account details.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Apple sign-in failed.')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> login() async {
    final matrix = Matrix.of(context);
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = L10n.of(context).pleaseEnterYourUsername);
    } else {
      setState(() => usernameError = null);
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = L10n.of(context).pleaseEnterYourPassword);
    } else {
      setState(() => passwordError = null);
    }

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    setState(() => loading = true);

    _coolDown?.cancel();

    try {
      final username = usernameController.text;
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
      final client = await matrix.getLoginClient();
      await client.login(
        LoginType.mLoginPassword,
        identifier: identifier,
        user: identifier.type == AuthenticationIdentifierTypes.userId
            ? username
            : null,
        password: passwordController.text,
        initialDeviceDisplayName: PlatformInfos.appDisplayName,
      );
      if (mounted) {
        context.go('/backup');
      }
    } on MatrixException catch (exception) {
      setState(() => passwordError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      setState(() => passwordError = exception.toString());
      return setState(() => loading = false);
    }

    if (mounted) setState(() => loading = false);
  }

  Timer? _coolDown;

  void checkWellKnownWithCoolDown(String userId) {
    _coolDown?.cancel();
    _coolDown = Timer(
      const Duration(seconds: 1),
      () => _checkWellKnown(userId),
    );
  }

  Future<void> _checkWellKnown(String userId) async {
    if (userId.isEmpty) return;
    final matrix = Matrix.of(context);
    try {
      await matrix.getLoginClient();
    } catch (_) {}
  }

  Future<void> passwordForgotten() async {
    final matrix = Matrix.of(context);
    final user = usernameController.text.trim();
    if (user.isEmpty) {
      setState(() => usernameError = L10n.of(context).pleaseEnterYourUsername);
      return;
    }

    final client = await matrix.getLoginClient();
    final homeserver = client.homeserver?.toString();
    if (homeserver == null) return;

    final ok = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context).passwordForgotten,
      message: L10n.of(context).passwordForgottenDescription,
      okLabel: L10n.of(context).continue,
      cancelLabel: L10n.of(context).cancel,
    );
    if (ok) {
      await showTextInputDialog(
        title: L10n.of(context).passwordForgotten,
        context: context,
        initialValue: user,
        label: L10n.of(context).matrixId,
      );
    }
  }
}
