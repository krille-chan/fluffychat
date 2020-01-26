import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'chat_list.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController serverController =
      TextEditingController(text: "matrix-client.matrix.org");
  String usernameError;
  String passwordError;
  String serverError;
  bool loading = false;
  bool showPassword = false;

  void login(BuildContext context) async {
    MatrixState matrix = Matrix.of(context);
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = I18n.of(context).pleaseEnterYourUsername);
    } else {
      setState(() => usernameError = null);
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = I18n.of(context).pleaseEnterYourPassword);
    } else {
      setState(() => passwordError = null);
    }
    serverError = null;

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    String homeserver = serverController.text;
    if (homeserver.isEmpty) homeserver = "matrix-client.matrix.org";
    if (!homeserver.startsWith("https://")) {
      homeserver = "https://" + homeserver;
    }

    try {
      setState(() => loading = true);
      if (!await matrix.client.checkServer(homeserver)) {
        setState(
            () => serverError = I18n.of(context).homeserverIsNotCompatible);

        return setState(() => loading = false);
      }
    } catch (exception) {
      setState(() => serverError = I18n.of(context).connectionAttemptFailed);
      return setState(() => loading = false);
    }
    try {
      await matrix.client.login(
          usernameController.text, passwordController.text,
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
        await matrix.setupFirebase();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autocorrect: false,
          controller: serverController,
          decoration: InputDecoration(
              icon: Icon(Icons.domain),
              hintText: "matrix-client.matrix.org",
              errorText: serverError,
              errorMaxLines: 1,
              prefixText: "https://",
              labelText: serverError == null ? "Homeserver" : serverError),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: max((MediaQuery.of(context).size.width - 600) / 2, 16)),
        children: <Widget>[
          Container(
            height: 150,
            color: Theme.of(context).secondaryHeaderColor,
            child: Center(
              child: Icon(
                Icons.vpn_key,
                color: Theme.of(context).primaryColor,
                size: 40,
              ),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.account_box),
            ),
            title: TextField(
              autocorrect: false,
              controller: usernameController,
              decoration: InputDecoration(
                  hintText:
                      "@${I18n.of(context).username.toLowerCase()}:domain",
                  errorText: usernameError,
                  labelText: I18n.of(context).username),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.lock),
            ),
            title: TextField(
              autocorrect: false,
              controller: passwordController,
              obscureText: !showPassword,
              onSubmitted: (t) => login(context),
              decoration: InputDecoration(
                  hintText: "****",
                  errorText: passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                  labelText: I18n.of(context).password),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 50,
            child: RaisedButton(
              elevation: 7,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: loading
                  ? CircularProgressIndicator()
                  : Text(
                      I18n.of(context).login,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
              onPressed: () => loading ? null : login(context),
            ),
          ),
        ],
      ),
    );
  }
}
