import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter/material.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

import 'views/settings_style_view.dart';
import '../widgets/matrix.dart';

class SettingsStyle extends StatefulWidget {
  @override
  SettingsStyleController createState() => SettingsStyleController();
}

class SettingsStyleController extends State<SettingsStyle> {
  void setWallpaperAction() async {
    final wallpaper =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    if (wallpaper == null) return;
    Matrix.of(context).wallpaper = File(wallpaper.path);
    await Matrix.of(context)
        .store
        .setItem(SettingKeys.wallpaper, wallpaper.path);
    setState(() => null);
  }

  void deleteWallpaperAction() async {
    Matrix.of(context).wallpaper = null;
    await Matrix.of(context).store.deleteItem(SettingKeys.wallpaper);
    setState(() => null);
  }

  AdaptiveThemeMode currentTheme;

  void switchTheme(AdaptiveThemeMode newTheme) {
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
    setState(() => currentTheme = newTheme);
  }

  void changeFontSizeFactor(double d) {
    setState(() => AppConfig.fontSizeFactor = d);
    Matrix.of(context).store.setItem(
          SettingKeys.fontSizeFactor,
          AppConfig.fontSizeFactor.toString(),
        );
  }

  @override
  Widget build(BuildContext context) => SettingsStyleView(this);
}
