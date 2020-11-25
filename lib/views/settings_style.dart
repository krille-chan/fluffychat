import 'dart:io';

import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/settings_themes.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:image_picker/image_picker.dart';

import '../components/matrix.dart';
import 'chat_list.dart';

class SettingsStyleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      primaryPage: FocusPage.SECOND,
      firstScaffold: ChatList(),
      secondScaffold: SettingsStyle(),
    );
  }
}

class SettingsStyle extends StatefulWidget {
  @override
  _SettingsStyleState createState() => _SettingsStyleState();
}

class _SettingsStyleState extends State<SettingsStyle> {
  void setWallpaperAction(BuildContext context) async {
    final wallpaper = await ImagePicker().getImage(source: ImageSource.gallery);
    if (wallpaper == null) return;
    Matrix.of(context).wallpaper = File(wallpaper.path);
    await Matrix.of(context)
        .store
        .setItem(SettingKeys.wallpaper, wallpaper.path);
    setState(() => null);
  }

  void deleteWallpaperAction(BuildContext context) async {
    Matrix.of(context).wallpaper = null;
    await Matrix.of(context).store.deleteItem(SettingKeys.wallpaper);
    setState(() => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).changeTheme),
      ),
      body: ListView(
        children: [
          ThemesSettings(),
          Divider(thickness: 1),
          ListTile(
            title: Text(
              L10n.of(context).wallpaper,
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
          Builder(builder: (context) {
            return ListTile(
              title: Text(L10n.of(context).changeWallpaper),
              trailing: Icon(Icons.wallpaper),
              onTap: () => setWallpaperAction(context),
            );
          }),
        ],
      ),
    );
  }
}
