import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:famedlysdk/famedlysdk.dart';

import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/platform_infos.dart';

class SignUpPassword extends StatefulWidget {
  final MatrixFile avatar;
  final String username;
  final String displayname;
  const SignUpPassword(this.username, {this.avatar, this.displayname});
  @override
  _SignUpPasswordState createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final TextEditingController passwordController = TextEditingController();
  String passwordError;
  String _lastAuthWebViewStage;
  bool loading = false;
  bool showPassword = true;

  void _signUpAction(BuildContext context, {AuthenticationData auth}) async {
    var matrix = Matrix.of(context);
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
      var waitForLogin = matrix.client.onLoginStateChanged.stream.first;
      await matrix.client.register(
        username: widget.username,
        password: passwordController.text,
        initialDeviceDisplayName: PlatformInfos.clientName,
        auth: auth,
      );
      await waitForLogin;
    } on MatrixException catch (exception) {
      if (exception.requireAdditionalAuthentication) {
        final stages = exception.authenticationFlows
            .firstWhere((a) => !a.stages.contains('m.login.email.identity'))
            .stages;

        final currentStage = exception.completedAuthenticationFlows == null
            ? stages.first
            : stages.firstWhere((stage) =>
                !exception.completedAuthenticationFlows.contains(stage) ??
                true);

        if (currentStage == 'm.login.dummy') {
          _signUpAction(
            context,
            auth: AuthenticationData(
              type: currentStage,
              session: exception.session,
            ),
          );
        } else {
          if (_lastAuthWebViewStage == currentStage) {
            _lastAuthWebViewStage = null;
            setState(
                () => passwordError = L10n.of(context).oopsSomethingWentWrong);
            return setState(() => loading = false);
          }
          _lastAuthWebViewStage = currentStage;
          await launch(
            Matrix.of(context).client.homeserver.toString() +
                '/_matrix/client/r0/auth/$currentStage/fallback/web?session=${exception.session}',
          );
          if (OkCancelResult.ok ==
              await showOkCancelAlertDialog(
                message: L10n.of(context).pleaseFollowInstructionsOnWeb,
                context: context,
                okLabel: L10n.of(context).next,
                cancelLabel: L10n.of(context).cancel,
                useRootNavigator: false,
              )) {
            _signUpAction(
              context,
              auth: AuthenticationData(session: exception.session),
            );
          } else {
            setState(() {
              loading = false;
              passwordError = null;
            });
          }
          return;
        }
      } else {
        setState(() => passwordError = exception.errorMessage);
        return setState(() => loading = false);
      }
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
      await FlushbarHelper.createError(
              message: L10n.of(context).couldNotSetDisplayname)
          .show(context);
    }
    if (widget.avatar != null) {
      try {
        await matrix.client.setAvatar(widget.avatar);
      } catch (exception) {
        await FlushbarHelper.createError(
                message: L10n.of(context).couldNotSetAvatar)
            .show(context);
      }
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: loading ? Container() : BackButton(),
        title: Text(
          L10n.of(context).chooseAStrongPassword,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: max((MediaQuery.of(context).size.width - 600) / 2, 0)),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: passwordController,
              obscureText: !showPassword,
              autofocus: true,
              readOnly: loading,
              autocorrect: false,
              onSubmitted: (t) => _signUpAction(context),
              autofillHints: loading ? null : [AutofillHints.newPassword],
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outlined),
                  hintText: '****',
                  errorText: passwordError,
                  suffixIcon: IconButton(
                    tooltip: L10n.of(context).showPassword,
                    icon: Icon(showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                  labelText: L10n.of(context).password),
            ),
          ),
          SizedBox(height: 12),
          Hero(
            tag: 'loginButton',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ElevatedButton(
                onPressed: loading ? null : () => _signUpAction(context),
                child: loading
                    ? LinearProgressIndicator()
                    : Text(
                        L10n.of(context).createAccountNow.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
