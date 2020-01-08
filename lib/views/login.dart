import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:flutter/material.dart';

import 'chat_list.dart';

const String defaultHomeserver = "https://matrix.org";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController serverController =
      TextEditingController(text: "matrix.org");
  String usernameError;
  String passwordError;
  String serverError;
  bool loading = false;

  void login(BuildContext context) async {
    MatrixState matrix = Matrix.of(context);
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = "Please enter your username.");
      print("Please enter your username.");
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
      await matrix.client
          .login(usernameController.text, passwordController.text);
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
          Image.asset("assets/fluffychat-banner.png"),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
                hintText: "@username:domain",
                icon: Icon(Icons.account_box),
                errorText: usernameError,
                labelText: "Username"),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            onSubmitted: (t) => login(context),
            decoration: InputDecoration(
                icon: Icon(Icons.vpn_key),
                hintText: "****",
                errorText: passwordError,
                labelText: "Password"),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              width: 120.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[
                    Colors.blue,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
              child: RawMaterialButton(
                onPressed: () => loading ? null : login(context),
                splashColor: Colors.grey,
                child: loading
                    ? CircularProgressIndicator()
                    : Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
