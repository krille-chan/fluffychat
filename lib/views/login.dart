import 'dart:async';
import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/firebase_controller.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'chat_list.dart';

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
    var matrix = Matrix.of(context);
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
      await matrix.client.login(
          user: usernameController.text,
          password: passwordController.text,
          initialDeviceDisplayName: matrix.widget.clientName);
    } on MatrixException catch (exception) {
      setState(() => passwordError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      setState(() => passwordError = exception.toString());
      return setState(() => loading = false);
    }
    if (!kIsWeb) {
      try {
        await FirebaseController.setupFirebase(
          matrix,
          matrix.widget.clientName,
        );
      } catch (exception) {
        await matrix.client.logout();
        matrix.clean();
        setState(() => passwordError = exception.toString());
        return setState(() => loading = false);
      }
    }
    setState(() => loading = false);
    await Navigator.of(context).pushAndRemoveUntil(
        AppRoute.defaultRoute(context, ChatListView()), (r) => false);
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
        await SimpleDialogs(context).tryRequestWithErrorToast(
            Matrix.of(context).client.checkHomeserver(newDomain));
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
      textFields: [
        DialogTextField(
          hintText: L10n.of(context).enterAnEmailAddress,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
    if (input == null) return;
    final clientSecret = DateTime.now().millisecondsSinceEpoch.toString();
    final response = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context).client.resetPasswordUsingEmail(
            input.single,
            clientSecret,
            sendAttempt++,
          ),
    );
    if (response == false) return;
    final ok = await showOkAlertDialog(
      context: context,
      title: L10n.of(context).weSentYouAnEmail,
      message: L10n.of(context).pleaseClickOnLink,
      okLabel: L10n.of(context).iHaveClickedOnLink,
    );
    if (ok == null) return;
    final password = await showTextInputDialog(
      context: context,
      title: L10n.of(context).chooseAStrongPassword,
      textFields: [
        DialogTextField(
          hintText: '******',
          obscureText: true,
        ),
      ],
    );
    if (password == null) return;
    final threepidCreds = {
      'client_secret': clientSecret,
      'sid': (response as RequestTokenResponse).sid,
    };
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context).client.changePassword(password.single, auth: {
        'type': 'm.login.email.identity',
        'threepidCreds': threepidCreds, // Don't ask... >.<
        'threepid_creds': threepidCreds,
      }),
    );
    if (success != false) {
      FlushbarHelper.createSuccess(
          message: L10n.of(context).passwordHasBeenChanged);
    }
  }

  static int sendAttempt = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: loading ? Container() : null,
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
          padding: EdgeInsets.symmetric(
              horizontal:
                  max((MediaQuery.of(context).size.width - 600) / 2, 0)),
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.account_box,
                    color: Theme.of(context).primaryColor),
              ),
              title: TextField(
                readOnly: loading,
                autocorrect: false,
                autofocus: true,
                onChanged: (t) => _checkWellKnownWithCoolDown(t, context),
                controller: usernameController,
                decoration: InputDecoration(
                    hintText:
                        '@${L10n.of(context).username.toLowerCase()}:domain',
                    errorText: usernameError,
                    labelText: L10n.of(context).username),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xff121212)
                    : Colors.white,
                child: Icon(Icons.lock, color: Theme.of(context).primaryColor),
              ),
              title: TextField(
                readOnly: loading,
                autocorrect: false,
                controller: passwordController,
                obscureText: !showPassword,
                onSubmitted: (t) => login(context),
                decoration: InputDecoration(
                    hintText: '****',
                    errorText: passwordError,
                    suffixIcon: IconButton(
                      icon: Icon(showPassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => showPassword = !showPassword),
                    ),
                    labelText: L10n.of(context).password),
              ),
            ),
            SizedBox(height: 20),
            Hero(
              tag: 'loginButton',
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: RaisedButton(
                  elevation: 7,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: loading
                      ? CircularProgressIndicator()
                      : Text(
                          L10n.of(context).login.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                  onPressed: loading ? null : () => login(context),
                ),
              ),
            ),
            Center(
              child: FlatButton(
                child: Text(
                  L10n.of(context).passwordForgotten,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onPressed: () => _passwordForgotten(context),
              ),
            ),
          ],
        );
      }),
    );
  }
}
