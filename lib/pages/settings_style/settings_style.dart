import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/account_config.dart';
import 'package:fluffychat/widgets/app_lock.dart';
import 'package:fluffychat/widgets/theme_builder.dart';
import '../../widgets/matrix.dart';
import 'settings_style_view.dart';

class SettingsStyle extends StatefulWidget {
  const SettingsStyle({super.key});

  @override
  SettingsStyleController createState() => SettingsStyleController();
}

class SettingsStyleController extends State<SettingsStyle> {
  void setChatColor(Color? color) async {
    AppConfig.colorSchemeSeed = color;
    ThemeController.of(context).setPrimaryColor(color);
  }

  void setWallpaper() async {
    final client = Matrix.of(context).client;
    final picked = await AppLock.of(context).pauseWhile(
      FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      ),
    );
    final pickedFile = picked?.files.firstOrNull;
    if (pickedFile == null) return;

    await showFutureLoadingDialog(
      context: context,
      future: () async {
        final url = await client.uploadContent(
          pickedFile.bytes!,
          filename: pickedFile.name,
        );
        await client.updateApplicationAccountConfig(
          ApplicationAccountConfig(wallpaperUrl: url),
        );
      },
    );
  }

  void setChatWallpaperOpacity(double opacity) {
    final client = Matrix.of(context).client;
    showFutureLoadingDialog(
      context: context,
      future: () => client.updateApplicationAccountConfig(
        ApplicationAccountConfig(wallpaperOpacity: opacity),
      ),
    );
  }

  void deleteChatWallpaper() => showFutureLoadingDialog(
        context: context,
        future: () => Matrix.of(context).client.setApplicationAccountConfig(
              const ApplicationAccountConfig(
                wallpaperUrl: null,
                wallpaperOpacity: null,
              ),
            ),
      );

  ThemeMode get currentTheme => ThemeController.of(context).themeMode;
  Color? get currentColor => ThemeController.of(context).primaryColor;

  static final List<Color?> customColors = [
    null,
    AppConfig.chatColor,
    Colors.indigo,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.blueGrey,
  ];

  void switchTheme(ThemeMode? newTheme) {
    if (newTheme == null) return;
    switch (newTheme) {
      case ThemeMode.light:
        ThemeController.of(context).setThemeMode(ThemeMode.light);
        break;
      case ThemeMode.dark:
        ThemeController.of(context).setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.system:
        ThemeController.of(context).setThemeMode(ThemeMode.system);
        break;
    }
    setState(() {});
  }

  void changeFontSizeFactor(double d) {
    setState(() => AppConfig.fontSizeFactor = d);
    Matrix.of(context).store.setString(
          SettingKeys.fontSizeFactor,
          AppConfig.fontSizeFactor.toString(),
        );
  }

  @override
  Widget build(BuildContext context) => SettingsStyleView(this);
}
