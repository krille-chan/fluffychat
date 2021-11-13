import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import '../../config/app_config.dart';
import '../../widgets/matrix.dart';
import 'settings_style.dart';

class SettingsStyleView extends StatelessWidget {
  final SettingsStyleController controller;

  const SettingsStyleView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.currentTheme ??= AdaptiveTheme.of(context).mode;
    const colorPickerSize = 32.0;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(L10n.of(context).changeTheme),
      ),
      body: MaxWidthBody(
        withScrolling: true,
        child: Column(
          children: [
            Row(
              children: SettingsStyleController.customColors
                  .map(
                    (color) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(colorPickerSize),
                        onTap: () => controller.setChatColor(color),
                        child: Material(
                          color: color,
                          elevation: 6,
                          borderRadius: BorderRadius.circular(colorPickerSize),
                          child: SizedBox(
                              width: colorPickerSize,
                              height: colorPickerSize,
                              child: AppConfig.chatColor.value == color.value
                                  ? const Center(
                                      child: Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    ))
                                  : null),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Divider(height: 1),
            RadioListTile<AdaptiveThemeMode>(
              groupValue: controller.currentTheme,
              value: AdaptiveThemeMode.system,
              title: Text(L10n.of(context).systemTheme),
              onChanged: controller.switchTheme,
            ),
            RadioListTile<AdaptiveThemeMode>(
              groupValue: controller.currentTheme,
              value: AdaptiveThemeMode.light,
              title: Text(L10n.of(context).lightTheme),
              onChanged: controller.switchTheme,
            ),
            RadioListTile<AdaptiveThemeMode>(
              groupValue: controller.currentTheme,
              value: AdaptiveThemeMode.dark,
              title: Text(L10n.of(context).darkTheme),
              onChanged: controller.switchTheme,
            ),
            const Divider(height: 1),
            ListTile(
              title: Text(
                L10n.of(context).wallpaper,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
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
                trailing: const Icon(
                  CupertinoIcons.delete,
                  color: Colors.red,
                ),
                onTap: controller.deleteWallpaperAction,
              ),
            Builder(builder: (context) {
              return ListTile(
                title: Text(L10n.of(context).changeWallpaper),
                trailing: const Icon(CupertinoIcons.photo),
                onTap: controller.setWallpaperAction,
              );
            }),
            const Divider(height: 1),
            ListTile(
              title: Text(
                L10n.of(context).fontSize,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('(*${AppConfig.fontSizeFactor})'),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Material(
                color: Theme.of(context).primaryColor,
                elevation: 6,
                shadowColor:
                    Theme.of(context).secondaryHeaderColor.withAlpha(100),
                borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          AppConfig.messageFontSize * AppConfig.fontSizeFactor,
                    ),
                  ),
                ),
              ),
            ),
            Slider(
              min: 0.5,
              max: 2.5,
              divisions: 8,
              value: AppConfig.fontSizeFactor,
              semanticFormatterCallback: (d) => d.toString(),
              onChanged: controller.changeFontSizeFactor,
            ),
          ],
        ),
      ),
    );
  }
}
