import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/content_banner.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: Settings(),
    );
  }
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future<dynamic> profileFuture;
  dynamic profile;
  void logoutAction(BuildContext context) async {
    await Navigator.of(context).popUntil((r) => r.isFirst);
    MatrixState matrix = Matrix.of(context);
    await matrix.tryRequestWithErrorToast(matrix.client.logout());
    matrix.clean();
  }

  void setDisplaynameAction(BuildContext context, String displayname) async {
    final MatrixState matrix = Matrix.of(context);
    final Map<String, dynamic> success =
        await matrix.tryRequestWithLoadingDialog(
      matrix.client.jsonRequest(
        type: HTTPType.PUT,
        action: "/client/r0/profile/${matrix.client.userID}/displayname",
        data: {"displayname": displayname},
      ),
    );
    if (success != null && success.isEmpty) {
      Toast.show(
        "Displayname has been changed",
        context,
        duration: Toast.LENGTH_LONG,
      );
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  void setAvatarAction(BuildContext context) async {
    final File tempFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 1600,
        maxHeight: 1600);
    if (tempFile == null) return;
    final MatrixState matrix = Matrix.of(context);
    final success = await matrix.tryRequestWithLoadingDialog(
      matrix.client.setAvatar(
        MatrixFile(
          bytes: await tempFile.readAsBytes(),
          path: tempFile.path,
        ),
      ),
    );
    print(success);
    if (success != false) {
      Toast.show(
        "Avatar has been changed",
        context,
        duration: Toast.LENGTH_LONG,
      );
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Client client = Matrix.of(context).client;
    profileFuture ??= client.getProfileFromUserId(client.userID);
    profileFuture.then((p) => setState(() => profile = p));
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ContentBanner(
            profile?.avatarUrl ?? MxContent(""),
            defaultIcon: Icons.account_circle,
            loading: profile == null,
          ),
          ListTile(
            title: Text(
              "Profile",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          kIsWeb
              ? Container()
              : ListTile(
                  title: Text("Upload avatar"),
                  leading: Icon(Icons.camera),
                  onTap: () => setAvatarAction(context),
                ),
          ListTile(
            leading: Icon(Icons.edit),
            title: TextField(
              readOnly: profile == null,
              textInputAction: TextInputAction.done,
              onSubmitted: (s) => setDisplaynameAction(context, s),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: "Edit displayname",
                labelStyle: TextStyle(color: Colors.black),
                hintText: (profile?.displayname ?? ""),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "About",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.help),
              title: Text("Help"),
              onTap: () => launch(
                  "https://gitlab.com/ChristianPauly/fluffychat-flutter/issues")),
          ListTile(
              leading: Icon(Icons.link),
              title: Text("License"),
              onTap: () => launch(
                  "https://gitlab.com/ChristianPauly/fluffychat-flutter/raw/master/LICENSE")),
          ListTile(
              leading: Icon(Icons.code),
              title: Text("Source code"),
              onTap: () => launch(
                  "https://gitlab.com/ChristianPauly/fluffychat-flutter")),
          ListTile(
            title: Text(
              "Logout",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            onTap: () => logoutAction(context),
          ),
        ],
      ),
    );
  }
}
