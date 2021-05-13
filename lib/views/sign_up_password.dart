import 'package:adaptive_page_layout/adaptive_page_layout.dart';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/ui/sign_up_password_ui.dart';

import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../utils/platform_infos.dart';

class SignUpPassword extends StatefulWidget {
  final MatrixFile avatar;
  final String username;
  final String displayname;
  const SignUpPassword(this.username, {this.avatar, this.displayname});
  @override
  SignUpPasswordController createState() => SignUpPasswordController();
}

class SignUpPasswordController extends State<SignUpPassword> {
  final TextEditingController passwordController = TextEditingController();
  String passwordError;
  bool loading = false;
  bool showPassword = true;

  void toggleShowPassword() => setState(() => showPassword = !showPassword);

  void signUpAction() async {
    final matrix = Matrix.of(context);
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = L10n.of(context).pleaseEnterYourPassword);
    } else {
      setState(() => passwordError = null);
    }

    if (passwordController.text.isEmpty) {
      return;
    }

    try {
      setState(() => loading = true);
      final waitForLogin = matrix.client.onLoginStateChanged.stream.first;
      await matrix.client.uiaRequestBackground((auth) => matrix.client.register(
            username: widget.username,
            password: passwordController.text,
            initialDeviceDisplayName: PlatformInfos.clientName,
            auth: auth,
          ));
      await waitForLogin;
    } catch (exception) {
      setState(() => passwordError = exception.toString());
      return setState(() => loading = false);
    }
    await matrix.client.onLoginStateChanged.stream
        .firstWhere((l) => l == LoginState.logged);
    try {
      await matrix.client
          .setDisplayname(matrix.client.userID, widget.displayname);
    } catch (exception) {
      AdaptivePageLayout.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).couldNotSetDisplayname)));
    }
    if (widget.avatar != null) {
      try {
        await matrix.client.setAvatar(widget.avatar);
      } catch (exception) {
        AdaptivePageLayout.of(context).showSnackBar(
            SnackBar(content: Text(L10n.of(context).couldNotSetAvatar)));
      }
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => SignUpPasswordUI(this);
}
