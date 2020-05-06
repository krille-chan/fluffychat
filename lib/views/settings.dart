import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/settings_themes.dart';
import 'package:fluffychat/views/homeserver_picker.dart';
import 'package:fluffychat/views/settings_devices.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_info.dart';
import 'chat_list.dart';
import '../components/adaptive_page_layout.dart';
import '../components/dialogs/simple_dialogs.dart';
import '../components/content_banner.dart';
import '../components/matrix.dart';
import '../i18n/i18n.dart';
import '../utils/app_route.dart';

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
    await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(matrix.client.logout());
    matrix.clean();
    await Navigator.of(context).pushAndRemoveUntil(
        AppRoute.defaultRoute(context, HomeserverPicker()), (r) => false);
  }

  void setJitsiInstanceAction(BuildContext context) async {
    var jitsi = await SimpleDialogs(context).enterText(
      titleText: I18n.of(context).editJitsiInstance,
      hintText: Matrix.of(context).jitsiInstance,
      labelText: I18n.of(context).editJitsiInstance,
    );
    if (jitsi == null) return;
    if (!jitsi.endsWith('/')) {
      jitsi += '/';
    }
    final MatrixState matrix = Matrix.of(context);
    await matrix.client.storeAPI.setItem('chat.fluffy.jitsi_instance', jitsi);
    matrix.jitsiInstance = jitsi;
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
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
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
    final success = await SimpleDialogs(context).tryRequestWithLoadingDialog(
      matrix.client.setAvatar(
        MatrixFile(
          bytes: await tempFile.readAsBytes(),
          path: tempFile.path,
        ),
      ),
    );
    if (success != false) {
      setState(() {
        profileFuture = null;
        profile = null;
      });
    }
  }

  void setWallpaperAction(BuildContext context) async {
    final wallpaper = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (wallpaper == null) return;
    Matrix.of(context).wallpaper = wallpaper;
    await Matrix.of(context)
        .client
        .storeAPI
        .setItem("chat.fluffy.wallpaper", wallpaper.path);
    setState(() => null);
  }

  void deleteWallpaperAction(BuildContext context) async {
    Matrix.of(context).wallpaper = null;
    await Matrix.of(context)
        .client
        .storeAPI
        .setItem("chat.fluffy.wallpaper", null);
    setState(() => null);
  }

  @override
  Widget build(BuildContext context) {
    final Client client = Matrix.of(context).client;
    profileFuture ??= client.ownProfile;
    profileFuture.then((p) {
      if (mounted) setState(() => profile = p);
    });
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            backgroundColor: Theme.of(context).appBarTheme.color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                I18n.of(context).settings,
                style: TextStyle(
                    color: Theme.of(context)
                        .appBarTheme
                        .textTheme
                        .headline6
                        .color),
              ),
              background: ContentBanner(
                profile?.avatarUrl,
                height: 300,
                defaultIcon: Icons.account_circle,
                loading: profile == null,
                onEdit: () => setAvatarAction(context),
              ),
            ),
          ),
        ],
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                I18n.of(context).changeTheme,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ThemesSettings(),
            if (!kIsWeb && client.storeAPI != null) Divider(thickness: 1),
            if (!kIsWeb && client.storeAPI != null)
              ListTile(
                title: Text(
                  I18n.of(context).wallpaper,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (Matrix.of(context).wallpaper != null)
              ListTile(
                title: Image.file(
                  Matrix.of(context).wallpaper,
                  height: 38,
                  fit: BoxFit.cover,
                ),
                trailing: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                onTap: () => deleteWallpaperAction(context),
              ),
            if (!kIsWeb && client.storeAPI != null)
              Builder(builder: (context) {
                return ListTile(
                  title: Text(I18n.of(context).changeWallpaper),
                  trailing: Icon(Icons.wallpaper),
                  onTap: () => setWallpaperAction(context),
                );
              }),
            Divider(thickness: 1),
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
              trailing: Icon(Icons.phone),
              title: Text(I18n.of(context).editJitsiInstance),
              subtitle: Text(Matrix.of(context).jitsiInstance),
              onTap: () => setJitsiInstanceAction(context),
            ),
            ListTile(
              trailing: Icon(Icons.devices_other),
              title: Text(I18n.of(context).devices),
              onTap: () async => await Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  DevicesSettingsView(),
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.account_circle),
              title: Text(I18n.of(context).accountInformations),
              onTap: () => Navigator.of(context).push(
                AppRoute.defaultRoute(
                  context,
                  AppInfoView(),
                ),
              ),
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
              trailing: Icon(Icons.help),
              title: Text(I18n.of(context).help),
              onTap: () => launch(
                  "https://gitlab.com/ChristianPauly/fluffychat-flutter/issues"),
            ),
            ListTile(
              trailing: Icon(Icons.link),
              title: Text(I18n.of(context).license),
              onTap: () => launch(
                  "https://gitlab.com/ChristianPauly/fluffychat-flutter/raw/master/LICENSE"),
            ),
            ListTile(
              trailing: Icon(Icons.code),
              title: Text(I18n.of(context).sourceCode),
              onTap: () => launch(
                  "https://gitlab.com/ChristianPauly/fluffychat-flutter"),
            ),
          ],
        ),
      ),
    );
  }
}
