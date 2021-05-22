import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../config/app_config.dart';
import '../../widgets/matrix.dart';
import '../settings_style.dart';

class SettingsStyleUI extends StatelessWidget {
  final SettingsStyleController controller;

  const SettingsStyleUI(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.currentTheme ??= AdaptiveTheme.of(context).mode;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).changeTheme),
      ),
      body: MaxWidthBody(
        withScrolling: true,
        child: Column(
          children: [
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
            Divider(height: 1),
            ListTile(
              title: Text(
                L10n.of(context).wallpaper,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
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
                onTap: controller.deleteWallpaperAction,
              ),
            Builder(builder: (context) {
              return ListTile(
                title: Text(L10n.of(context).changeWallpaper),
                trailing: Icon(Icons.wallpaper_outlined),
                onTap: controller.setWallpaperAction,
              );
            }),
            Divider(height: 1),
            ListTile(
              title: Text(
                L10n.of(context).fontSize,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text('(*${AppConfig.fontSizeFactor})'),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyText1.fontSize *
                        AppConfig.fontSizeFactor,
                  ),
                ),
              ),
            ),
            Slider(
              min: 0.5,
              max: 2.5,
              divisions: 4,
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
