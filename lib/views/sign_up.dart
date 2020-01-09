import 'dart:io';
import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/login.dart';
import 'package:fluffychat/views/sign_up_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController serverController =
      TextEditingController(text: "matrix.org");
  String usernameError;
  String serverError;
  bool loading = false;
  File avatar;

  void setAvatarAction() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 50,
    );
    if (file != null) setState(() => avatar = file);
  }

  void signUpAction(BuildContext context) async {
    MatrixState matrix = Matrix.of(context);
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = "Please choose a username.");
    } else {
      setState(() => usernameError = null);
    }
    serverError = null;

    if (usernameController.text.isEmpty) {
      return;
    }

    final String preferredUsername =
        usernameController.text.toLowerCase().replaceAll(" ", "-");

    String homeserver = serverController.text;
    if (homeserver.isEmpty) homeserver = defaultHomeserver;
    if (!homeserver.startsWith("https://")) {
      homeserver = "https://" + homeserver;
    }

    try {
      print("[Sign Up] Check server...");
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
      print("[Sign Up] Check if username is available...");
      await matrix.client.usernameAvailable(preferredUsername);
    } on MatrixException catch (exception) {
      setState(() => usernameError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      setState(() => usernameError = exception.toString());
      return setState(() => loading = false);
    }
    setState(() => loading = false);
    await Navigator.of(context).push(
      AppRoute.defaultRoute(
        context,
        SignUpPassword(preferredUsername,
            avatar: avatar, displayname: usernameController.text),
      ),
    );
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
              horizontal:
                  max((MediaQuery.of(context).size.width - 600) / 2, 16)),
          children: <Widget>[
            Image.asset("assets/fluffychat-banner.png"),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: avatar == null ? null : FileImage(avatar),
                backgroundColor: avatar == null
                    ? Colors.green
                    : Theme.of(context).secondaryHeaderColor,
                child: avatar == null ? Icon(Icons.camera_alt) : null,
              ),
              trailing: avatar == null
                  ? null
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              title: Text(
                  avatar == null ? "Set a profile picture" : "Discard picture"),
              onTap: avatar == null
                  ? setAvatarAction
                  : () => setState(() => avatar = null),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.account_box),
              ),
              title: TextField(
                controller: usernameController,
                onSubmitted: (s) => signUpAction(context),
                decoration: InputDecoration(
                    hintText: "Username",
                    errorText: usernameError,
                    labelText: "Choose a username"),
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
                        "Sign up",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                onPressed: () => signUpAction(context),
              ),
            ),
            Center(
              child: FlatButton(
                child: Text(
                  "Already have an account?",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () => Navigator.of(context).push(
                  AppRoute.defaultRoute(
                    context,
                    Login(),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
