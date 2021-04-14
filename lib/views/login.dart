import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/one_page_card.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/views/widgets/matrix.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../utils/platform_infos.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String usernameError;
  String passwordError;
  bool loading = false;
  bool showPassword = false;

  void login(BuildContext context) async {
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
      await matrix.client.login(
          identifier: identifier,
          // To stay compatible with older server versions
          // ignore: deprecated_member_use
          user: identifier.type == AuthenticationIdentifierTypes.userId
              ? username
              : null,
          password: passwordController.text,
          initialDeviceDisplayName: PlatformInfos.clientName);
    } on MatrixException catch (exception) {
      setState(() => passwordError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      setState(() => passwordError = exception.toString());
      return setState(() => loading = false);
    }

    if (mounted) setState(() => loading = false);
  }

  Timer _coolDown;

  void _checkWellKnownWithCoolDown(String userId, BuildContext context) async {
    _coolDown?.cancel();
    _coolDown = Timer(
      Duration(seconds: 1),
      () => _checkWellKnown(userId, context),
    );
  }

  void _checkWellKnown(String userId, BuildContext context) async {
    setState(() => usernameError = null);
    if (!userId.isValidMatrixId) return;
    try {
      final wellKnownInformations = await Matrix.of(context)
          .client
          .getWellKnownInformationsByUserId(userId);
      final newDomain = wellKnownInformations.mHomeserver?.baseUrl;
      if ((newDomain?.isNotEmpty ?? false) &&
          newDomain != Matrix.of(context).client.homeserver.toString()) {
        await showFutureLoadingDialog(
          context: context,
          future: () => Matrix.of(context).client.checkHomeserver(newDomain),
        );
        setState(() => usernameError = null);
      }
    } catch (e) {
      setState(() => usernameError = e.toString());
    }
  }

  void _passwordForgotten(BuildContext context) async {
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
      future: () => Matrix.of(context).client.resetPasswordUsingEmail(
            input.single,
            clientSecret,
            sendAttempt++,
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
    final password = await showTextInputDialog(
      context: context,
      title: L10n.of(context).chooseAStrongPassword,
      okLabel: L10n.of(context).ok,
      cancelLabel: L10n.of(context).cancel,
      useRootNavigator: false,
      textFields: [
        DialogTextField(
          hintText: '******',
          obscureText: true,
          minLines: 1,
          maxLines: 1,
        ),
      ],
    );
    if (password == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.changePassword(
            password.single,
            auth: AuthenticationThreePidCreds(
              type: AuthenticationTypes.emailIdentity,
              threepidCreds: [
                ThreepidCreds(
                  sid: (response as RequestTokenResponse).sid,
                  clientSecret: clientSecret,
                ),
              ],
            ),
          ),
    );
    if (success.error == null) {
      AdaptivePageLayout.of(context).showSnackBar(
          SnackBar(content: Text(L10n.of(context).passwordHasBeenChanged)));
    }
  }

  static int sendAttempt = 0;

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          leading: loading ? Container() : BackButton(),
          elevation: 0,
          title: Text(
            L10n.of(context).logInTo(Matrix.of(context)
                .client
                .homeserver
                .toString()
                .replaceFirst('https://', '')),
          ),
        ),
        body: Builder(builder: (context) {
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  readOnly: loading,
                  autocorrect: false,
                  autofocus: true,
                  onChanged: (t) => _checkWellKnownWithCoolDown(t, context),
                  controller: usernameController,
                  autofillHints: loading ? null : [AutofillHints.username],
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_box_outlined),
                      hintText:
                          '@${L10n.of(context).username.toLowerCase()}:domain',
                      errorText: usernameError,
                      labelText: L10n.of(context).username),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  readOnly: loading,
                  autocorrect: false,
                  autofillHints: loading ? null : [AutofillHints.password],
                  controller: passwordController,
                  obscureText: !showPassword,
                  onSubmitted: (t) => login(context),
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
                    onPressed: loading ? null : () => login(context),
                    child: loading
                        ? LinearProgressIndicator()
                        : Text(
                            L10n.of(context).login.toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => _passwordForgotten(context),
                  child: Text(
                    L10n.of(context).passwordForgotten,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

extension on String {
  static final RegExp _phoneRegex =
      RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  bool get isEmail => EmailValidator.validate(this);
  bool get isPhoneNumber => _phoneRegex.hasMatch(this);
}
