import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/content_banner.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/app_info.dart';
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
    if (await SimpleDialogs(context).askConfirmation() == false) {
      return;
    }
    MatrixState matrix = Matrix.of(context);
    await matrix.tryRequestWithLoadingDialog(matrix.client.logout());
    matrix.clean();
    await Navigator.of(context).pushAndRemoveUntil(
        AppRoute.defaultRoute(context, SignUp()), (r) => false);
  }

  void setDisplaynameAction(BuildContext context) async {
    final String displayname = await SimpleDialogs(context).enterText(
      titleText: I18n.of(context).editDisplayname,
      hintText:
          profile?.displayname ?? Matrix.of(context).client.userID.localpart,
      labelText: I18n.of(context).enterAUsername,
    );
    if (displayname == null) return;
    final MatrixState matrix = Matrix.of(context);
    final success = await matrix.tryRequestWithLoadingDialog(
      matrix.client.setDisplayname(displayname),
    );
    if (success != false) {
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
            title: Text(
              I18n.of(context).account,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            trailing: Icon(Icons.edit),
            title: Text(I18n.of(context).editDisplayname),
            subtitle: Text(profile?.displayname ?? client.userID.localpart),
            onTap: () => setDisplaynameAction(context),
          ),
          ListTile(
            trailing: Icon(Icons.exit_to_app),
            title: Text(I18n.of(context).logout),
            onTap: () => logoutAction(context),
          ),
          Divider(thickness: 1),
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
            title: Container(
              alignment: Alignment.centerLeft,
              child: Image.asset("assets/kofi.png", width: 200),
            ),
            onTap: () => launch("https://ko-fi.com/V7V315112"),
          ),
          ListTile(
            leading: Icon(Icons.donut_large),
            title: Text("Liberapay " + I18n.of(context).donate),
            onTap: () =>
                launch("https://liberapay.com/KrilleChritzelius/donate"),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text(I18n.of(context).help),
            onTap: () => launch(
                "https://gitlab.com/ChristianPauly/fluffychat-flutter/issues"),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(I18n.of(context).accountInformations),
            onTap: () => Navigator.of(context).push(
              AppRoute.defaultRoute(
                context,
                AppInfoView(),
              ),
            ),
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
        ],
      ),
    );
  }
}
