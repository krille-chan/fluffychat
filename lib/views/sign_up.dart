import 'dart:io';
import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
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
      TextEditingController(text: "matrix-client.matrix.org");
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
      setState(() => usernameError = I18n.of(context).pleaseChooseAUsername);
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
              title: Text(avatar == null
                  ? I18n.of(context).setAProfilePicture
                  : I18n.of(context).discardPicture),
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
                autocorrect: false,
                controller: usernameController,
                onSubmitted: (s) => signUpAction(context),
                decoration: InputDecoration(
                    hintText: I18n.of(context).username,
                    errorText: usernameError,
                    labelText: I18n.of(context).chooseAUsername),
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
                        I18n.of(context).signUp,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                onPressed: () => signUpAction(context),
              ),
            ),
            Center(
              child: FlatButton(
                child: Text(
                  I18n.of(context).alreadyHaveAnAccount,
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
