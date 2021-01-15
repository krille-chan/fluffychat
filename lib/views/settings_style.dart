import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
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

  AdaptiveThemeMode _currentTheme;

  void _switchTheme(AdaptiveThemeMode newTheme, BuildContext context) {
    switch (newTheme) {
      case AdaptiveThemeMode.light:
        AdaptiveTheme.of(context).setLight();
        break;
      case AdaptiveThemeMode.dark:
        AdaptiveTheme.of(context).setDark();
        break;
      case AdaptiveThemeMode.system:
        AdaptiveTheme.of(context).setSystem();
        break;
    }
    setState(() => _currentTheme = newTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).changeTheme),
      ),
      body: ListView(
        children: [
          RadioListTile<AdaptiveThemeMode>(
            groupValue: _currentTheme,
            value: AdaptiveThemeMode.system,
            title: Text(L10n.of(context).systemTheme),
            onChanged: (t) => _switchTheme(t, context),
          ),
          RadioListTile<AdaptiveThemeMode>(
            groupValue: _currentTheme,
            value: AdaptiveThemeMode.light,
            title: Text(L10n.of(context).lightTheme),
            onChanged: (t) => _switchTheme(t, context),
          ),
          RadioListTile<AdaptiveThemeMode>(
            groupValue: _currentTheme,
            value: AdaptiveThemeMode.dark,
            title: Text(L10n.of(context).darkTheme),
            onChanged: (t) => _switchTheme(t, context),
          ),
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
                Icons.delete_forever_outlined,
                color: Colors.red,
              ),
              onTap: () => deleteWallpaperAction(context),
            ),
          Builder(builder: (context) {
            return ListTile(
              title: Text(L10n.of(context).changeWallpaper),
              trailing: Icon(Icons.wallpaper_outlined),
              onTap: () => setWallpaperAction(context),
            );
          }),
        ],
      ),
    );
  }
}
