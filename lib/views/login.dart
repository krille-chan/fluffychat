import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/material.dart';

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
      matrix.showLoadingDialog(context);
      if (!await matrix.client.checkServer(homeserver)) {
        setState(() => serverError = "Homeserver is not compatible.");

        return matrix.hideLoadingDialog();
      }
    } catch (exception) {
      setState(() => serverError = "Connection attempt failed!");
      return matrix.hideLoadingDialog();
    }
    try {
      await matrix.client
          .login(usernameController.text, passwordController.text);
    } on MatrixException catch (exception) {
      setState(() => passwordError = exception.errorMessage);
      return matrix.hideLoadingDialog();
    } catch (exception) {
      setState(() => passwordError = exception.toString());
      return matrix.hideLoadingDialog();
    }
    await Matrix.of(context).saveAccount();
    matrix.hideLoadingDialog();
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
                    Color(0xFF5625BA),
                  ],
                ),
              ),
              child: RawMaterialButton(
                onPressed: () => login(context),
                splashColor: Colors.grey,
                child: Text(
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
