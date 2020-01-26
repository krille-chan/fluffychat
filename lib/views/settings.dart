import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/content_banner.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:fluffychat/views/sign_up.dart';
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
    MatrixState matrix = Matrix.of(context);
    await matrix.tryRequestWithLoadingDialog(matrix.client.logout());
    matrix.clean();
    await Navigator.of(context).pushAndRemoveUntil(
        AppRoute.defaultRoute(context, SignUp()), (r) => false);
  }

  void setDisplaynameAction(BuildContext context, String displayname) async {
    final MatrixState matrix = Matrix.of(context);
    final Map<String, dynamic> success =
        await matrix.tryRequestWithLoadingDialog(
      matrix.client.setDisplayname(displayname),
    );
    if (success != null && success.isEmpty) {
      Toast.show(
        I18n.of(context).displaynameHasBeenChanged,
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
    if (success != false) {
      Toast.show(
        I18n.of(context).avatarHasBeenChanged,
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
    profileFuture ??= client.ownProfile;
    profileFuture.then((p) {
      if (mounted) setState(() => profile = p);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).settings),
      ),
      body: ListView(
        children: <Widget>[
          ContentBanner(
            profile?.avatarUrl ?? MxContent(""),
            defaultIcon: Icons.account_circle,
            loading: profile == null,
            onEdit: kIsWeb ? null : () => setAvatarAction(context),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: TextField(
              readOnly: profile == null,
              textInputAction: TextInputAction.done,
              onSubmitted: (s) => setDisplaynameAction(context, s),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: I18n.of(context).editDisplayname,
                labelStyle: TextStyle(color: Colors.black),
                hintText: (profile?.displayname ?? ""),
              ),
            ),
          ),
          Divider(thickness: 8),
          ListTile(
            title: Text(
              I18n.of(context).about,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.sentiment_very_satisfied),
            title: Text(I18n.of(context).donate),
            onTap: () => launch("https://ko-fi.com/krille"),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(I18n.of(context).help),
            onTap: () => launch(
                "https://gitlab.com/ChristianPauly/fluffychat-flutter/issues"),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(I18n.of(context).changelog),
            onTap: () => launch(
                "https://gitlab.com/ChristianPauly/fluffychat-flutter/blob/master/CHANGELOG.md"),
          ),
          ListTile(
            leading: Icon(Icons.link),
            title: Text(I18n.of(context).license),
            onTap: () => launch(
                "https://gitlab.com/ChristianPauly/fluffychat-flutter/raw/master/LICENSE"),
          ),
          ListTile(
            leading: Icon(Icons.code),
            title: Text(I18n.of(context).sourceCode),
            onTap: () =>
                launch("https://gitlab.com/ChristianPauly/fluffychat-flutter"),
          ),
          Divider(thickness: 8),
          ListTile(
            title: Text(
              I18n.of(context).logout,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(I18n.of(context).logout),
            onTap: () => logoutAction(context),
          ),
        ],
      ),
    );
  }
}
