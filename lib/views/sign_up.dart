import 'dart:math';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

import 'package:fluffychat/components/matrix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  String usernameError;
  bool loading = false;
  MatrixFile avatar;

  void setAvatarAction() async {
    var file =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    if (file != null) {
      setState(
        () => avatar = MatrixFile(
          bytes: file.toUint8List(),
          name: file.fileName,
        ),
      );
    }
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
      await matrix.client.usernameAvailable(preferredUsername);
    } on MatrixException catch (exception) {
      setState(() => usernameError = exception.errorMessage);
      return setState(() => loading = false);
    } catch (exception) {
      setState(() => usernameError = exception.toString());
      return setState(() => loading = false);
    }
    setState(() => loading = false);
    await AdaptivePageLayout.of(context).pushNamed(
      '/signup/password/${Uri.encodeComponent(preferredUsername)}/${Uri.encodeComponent(usernameController.text)}',
      arguments: avatar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: loading ? Container() : BackButton(),
        title: Text(
          Matrix.of(context)
              .client
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
              child: Image.asset('assets/banner.png'),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                autocorrect: false,
                controller: usernameController,
                onSubmitted: (s) => signUpAction(context),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  hintText: L10n.of(context).username,
                  errorText: usernameError,
                  labelText: L10n.of(context).chooseAUsername,
                ),
              ),
            ),
            SizedBox(height: 8),
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
                    ? Icon(Icons.camera_alt_outlined,
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
            SizedBox(height: 16),
            Hero(
              tag: 'loginButton',
              child: Container(
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: RaisedButton(
                  elevation: 7,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: loading
                      ? LinearProgressIndicator()
                      : Text(
                          L10n.of(context).signUp.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                  onPressed: loading ? null : () => signUpAction(context),
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
                onPressed: () =>
                    AdaptivePageLayout.of(context).pushNamed('/login'),
              ),
            ),
          ]),
    );
  }
}
