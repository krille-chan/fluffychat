import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:flutter/material.dart';

import 'chat_list.dart';

const String defaultHomeserver = "https://matrix.org";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController serverController =
      TextEditingController(text: "matrix.org");
  String usernameError;
  String passwordError;
  String serverError;
  bool loading = false;
  bool showPassword = false;

  void login(BuildContext context) async {
    MatrixState matrix = Matrix.of(context);
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = "Please enter your username.");
    } else {
      setState(() => usernameError = null);
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = "Please enter your password.");
    } else {
      setState(() => passwordError = null);
    }
    serverError = null;

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    String homeserver = serverController.text;
    if (homeserver.isEmpty) homeserver = defaultHomeserver;
    if (!homeserver.startsWith("https://")) {
      homeserver = "https://" + homeserver;
    }

    try {
      print("[Login] Check server...");
      setState(() => loading = true);
      if (!await matrix.client.checkServer(homeserver)) {
        setState(() => serverError = "Homeserver is not compatible.");

        return setState(() => loading = false);
      }
    } catch (exception) {
      setState(() => serverError = "Connection attempt failed!");
      return setState(() => loading = false);
    }
    try {
      print("[Login] Try to login...");
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
    try {
      print("[Login] Setup Firebase...");
      await matrix.setupFirebase();
    } catch (exception) {
      print("[Login] Failed to setup Firebase. Logout now...");
      await matrix.client.logout();
      matrix.clean();
      setState(() => passwordError = exception.toString());
      return setState(() => loading = false);
    }
    print("[Login] Store account and go to ChatListView");
    await Matrix.of(context).saveAccount();
    setState(() => loading = false);
    await Navigator.of(context).pushAndRemoveUntil(
        AppRoute.defaultRoute(context, ChatListView()), (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: serverController,
          decoration: InputDecoration(
              icon: Icon(Icons.domain),
              hintText: "matrix.org",
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
              controller: usernameController,
              decoration: InputDecoration(
                  hintText: "@username:domain",
                  errorText: usernameError,
                  labelText: "Username"),
            ),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.yellow,
              child: Icon(Icons.lock),
            ),
            title: TextField(
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
                  labelText: "Password"),
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
                      "Login",
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
