import 'dart:math';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/login.dart';
import 'package:fluffychat/views/sign_up_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memoryfilepicker/memoryfilepicker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  String usernameError;
  bool loading = false;
  MemoryFile avatar;

  void setAvatarAction() async {
    var file = await MemoryFilePicker.getImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 50,
    );
    if (file != null) setState(() => avatar = file);
  }

  void signUpAction(BuildContext context) async {
    var matrix = Matrix.of(context);
    if (usernameController.text.isEmpty) {
      setState(() => usernameError = L10n.of(context).pleaseChooseAUsername);
    } else {
      setState(() => usernameError = null);
    }

    if (usernameController.text.isEmpty) {
      return;
    }
    setState(() => loading = true);

    final preferredUsername =
        usernameController.text.toLowerCase().replaceAll(' ', '-');

    try {
      await matrix.client.api.usernameAvailable(preferredUsername);
    } on MatrixException catch (exception) {
      setState(() => usernameError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      setState(() => usernameError = exception.toString());
      return setState(() => loading = false);
    }
    setState(() => loading = false);
    await Navigator.of(context).push(
      AppRoute(
        SignUpPassword(preferredUsername,
            avatar: avatar, displayname: usernameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: loading ? Container() : null,
        title: Text(
          Matrix.of(context)
              .client
              .api
              .homeserver
              .toString()
              .replaceFirst('https://', ''),
        ),
      ),
      body: ListView(
          padding: EdgeInsets.symmetric(
              horizontal:
                  max((MediaQuery.of(context).size.width - 600) / 2, 0)),
          children: <Widget>[
            Hero(
              tag: 'loginBanner',
              child: Image.asset('assets/fluffychat-banner.png'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    avatar == null ? null : MemoryImage(avatar.bytes),
                backgroundColor: avatar == null
                    ? Theme.of(context).brightness == Brightness.dark
                        ? Color(0xff121212)
                        : Colors.white
                    : Theme.of(context).secondaryHeaderColor,
                child: avatar == null
                    ? Icon(Icons.camera_alt,
                        color: Theme.of(context).primaryColor)
                    : null,
              ),
              trailing: avatar == null
                  ? null
                  : Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
              title: Text(avatar == null
                  ? L10n.of(context).setAProfilePicture
                  : L10n.of(context).discardPicture),
              onTap: avatar == null
                  ? setAvatarAction
                  : () => setState(() => avatar = null),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xff121212)
                    : Colors.white,
                child: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: TextField(
                autocorrect: false,
                controller: usernameController,
                onSubmitted: (s) => signUpAction(context),
                decoration: InputDecoration(
                    hintText: L10n.of(context).username,
                    errorText: usernameError,
                    labelText: L10n.of(context).chooseAUsername),
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
                          L10n.of(context).signUp.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                  onPressed: () => loading ? null : signUpAction(context),
                ),
              ),
            ),
            Center(
              child: FlatButton(
                child: Text(
                  L10n.of(context).alreadyHaveAnAccount,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
                onPressed: () => Navigator.of(context).push(
                  AppRoute(Login()),
                ),
              ),
            ),
          ]),
    );
  }
}
