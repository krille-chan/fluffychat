import 'dart:io';
import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'chat_list.dart';

class SignUpPassword extends StatefulWidget {
  final File avatar;
  final String username;
  final String displayname;
  const SignUpPassword(this.username, {this.avatar, this.displayname});
  @override
  _SignUpPasswordState createState() => _SignUpPasswordState();
}

class _SignUpPasswordState extends State<SignUpPassword> {
  final TextEditingController passwordController = TextEditingController();
  String passwordError;
  bool loading = false;
  bool showPassword = true;

  void _signUpAction(BuildContext context, {Map<String, dynamic> auth}) async {
    MatrixState matrix = Matrix.of(context);
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = "Please enter your password.");
    } else {
      setState(() => passwordError = null);
    }

    if (passwordController.text.isEmpty) {
      return;
    }

    try {
      print("[Sign Up] Create account...");
      Future<LoginState> waitForLogin =
          matrix.client.onLoginStateChanged.stream.first;
      await matrix.client.register(
        username: widget.username,
        password: passwordController.text,
        initialDeviceDisplayName: matrix.widget.clientName,
        auth: auth,
      );
      await waitForLogin;
    } on MatrixException catch (exception) {
      if (exception.requireAdditionalAuthentication) {
        print(exception.raw);

        if (exception.authenticationFlows.indexWhere((a) =>
                a.stages.length == 1 && a.stages.first == "m.login.dummy") !=
            -1) {
          _signUpAction(context, auth: {
            "type": "m.login.dummy",
            "session": exception.session,
          });
        } else {
          setState(() => passwordError =
              "The server requires unsupported authentication flows");
          setState(() => loading = false);
          return;
        }
      } else {
        setState(() => passwordError = exception.errorMessage);
        return setState(() => loading = false);
      }
    } catch (exception) {
      print(exception);
      setState(() => passwordError = exception.toString());
      return setState(() => loading = false);
    }
    try {
      await matrix.client.jsonRequest(
        type: HTTPType.PUT,
        action: "/client/r0/profile/${matrix.client.userID}/displayname",
        data: {"displayname": widget.displayname},
      );
    } catch (exception) {
      Toast.show("Could not set displayname", context, duration: 5);
    }
    try {
      await matrix.client.setAvatar(
        MatrixFile(
          bytes: await widget.avatar.readAsBytes(),
          path: widget.avatar.path,
        ),
      );
    } catch (exception) {
      Toast.show("Could not set profile picture", context, duration: 5);
    }
    await Navigator.of(context).pushAndRemoveUntil(
        AppRoute.defaultRoute(context, ChatListView()), (r) => false);

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secure your account with a password"),
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
              backgroundColor: Colors.yellow,
              child: Icon(Icons.lock),
            ),
            title: TextField(
              controller: passwordController,
              obscureText: !showPassword,
              autofocus: true,
              autocorrect: false,
              onSubmitted: (t) => _signUpAction(context),
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
                      "Create account now",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
              onPressed: () => loading ? null : _signUpAction(context),
            ),
          ),
        ],
      ),
    );
  }
}
