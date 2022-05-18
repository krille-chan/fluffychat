import 'dart:io';

import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import '../../widgets/matrix.dart';
import 'settings_style_view.dart';

class SettingsStyle extends StatefulWidget {
  const SettingsStyle({Key? key}) : super(key: key);

  @override
  SettingsStyleController createState() => SettingsStyleController();
}

class SettingsStyleController extends State<SettingsStyle> {
  void setWallpaperAction() async {
    final wallpaper =
        await FilePickerCross.importFromStorage(type: FileTypeCross.image);
    final path = wallpaper.path;
    if (path == null) return;
    Matrix.of(context).wallpaper = File(path);
    await Matrix.of(context)
        .store
        .setItem(SettingKeys.wallpaper, wallpaper.path);
    setState(() {});
  }

  void deleteWallpaperAction() async {
    Matrix.of(context).wallpaper = null;
    await Matrix.of(context).store.deleteItem(SettingKeys.wallpaper);
    setState(() {});
  }

  void setChatColor(Color? color) async {
    await Matrix.of(context).store.setItem(
          SettingKeys.chatColor,
          color?.value.toString(),
        );
    AppConfig.colorSchemeSeed = color;
    AdaptiveTheme.of(context).setTheme(
      light: FluffyThemes.light,
      dark: FluffyThemes.dark,
    );
  }

  AdaptiveThemeMode? currentTheme;

  static final List<Color?> customColors = [
    AppConfig.primaryColor,
    Colors.blue.shade800,
    Colors.green.shade800,
    Colors.orange.shade700,
    Colors.pink.shade700,
    Colors.blueGrey.shade600,
    null,
  ];

  void switchTheme(AdaptiveThemeMode? newTheme) {
    if (newTheme == null) return;
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

  void changeBubbleSizeFactor(double d) {
    setState(() => AppConfig.bubbleSizeFactor = d);
    Matrix.of(context).store.setItem(
          SettingKeys.bubbleSizeFactor,
          AppConfig.bubbleSizeFactor.toString(),
        );
  }

  @override
  Widget build(BuildContext context) => SettingsStyleView(this);
}
