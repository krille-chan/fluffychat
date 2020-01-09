import 'dart:io';
import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:flutter/material.dart';

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
      final Map<String, dynamic> response = await matrix.client.register(
        username: widget.username,
        password: passwordController.text,
        initialDeviceDisplayName: matrix.widget.clientName,
        auth: auth,
      );
      if (response.containsKey("user_id") &&
          response.containsKey("access_token") &&
          response.containsKey("device_id")) {
        await Navigator.of(context).pushAndRemoveUntil(
            AppRoute.defaultRoute(context, ChatListView()), (r) => false);
      } else if (response.containsKey("flows")) {
        final List<String> stages = response["flows"]["stages"];
        for (int i = 0; i < stages.length;) {
          if (stages[i] == "m.login.dummy") {
            print("[Sign Up] Process m.login.dummy stage");
            _signUpAction(context, auth: {
              "type": stages[i],
              "session": response["session"],
            });
            break;
          } else if (stages[i] == "m.login.recaptcha") {
            print("[Sign Up] Process m.login.recaptcha stage");
            final String publicKey = response["params"]["public_key"];

            _signUpAction(context, auth: {
              "type": stages[i],
              "session": response["session"],
            });
            break;
          }
        }
      }
    } on MatrixException catch (exception) {
      setState(() => passwordError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      print(exception);
      setState(() => passwordError = exception.toString());
      return setState(() => loading = false);
    }
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
