import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import '../../config/app_config.dart';
import '../../widgets/matrix.dart';
import 'settings_style.dart';

class SettingsStyleView extends StatelessWidget {
  final SettingsStyleController controller;

  const SettingsStyleView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const colorPickerSize = 32.0;
    final wallpaper = Matrix.of(context).wallpaper;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(L10n.of(context)!.changeTheme),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: MaxWidthBody(
        withScrolling: true,
        child: Column(
          children: [
            SizedBox(
              height: colorPickerSize + 24,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: SettingsStyleController.customColors
                    .map(
                      (color) => Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(colorPickerSize),
                          onTap: () => controller.setChatColor(color),
                          child: color == null
                              ? Material(
                                  elevation:
                                      AppConfig.colorSchemeSeed?.value == null
                                          ? 100
                                          : 0,
                                  shadowColor: AppConfig.colorSchemeSeed,
                                  borderRadius:
                                      BorderRadius.circular(colorPickerSize),
                                  child: Image.asset(
                                    'assets/colors.png',
                                    width: colorPickerSize,
                                    height: colorPickerSize,
                                  ),
                                )
                              : Material(
                                  color: color,
                                  elevation: 6,
                                  borderRadius:
                                      BorderRadius.circular(colorPickerSize),
                                  child: SizedBox(
                                    width: colorPickerSize,
                                    height: colorPickerSize,
                                    child: controller.currentColor == color
                                        ? const Center(
                                            child: Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              groupValue: controller.currentTheme,
              value: ThemeMode.system,
              title: Text(L10n.of(context)!.systemTheme),
              onChanged: controller.switchTheme,
            ),
            RadioListTile<ThemeMode>(
              groupValue: controller.currentTheme,
              value: ThemeMode.light,
              title: Text(L10n.of(context)!.lightTheme),
              onChanged: controller.switchTheme,
            ),
            RadioListTile<ThemeMode>(
              groupValue: controller.currentTheme,
              value: ThemeMode.dark,
              title: Text(L10n.of(context)!.darkTheme),
              onChanged: controller.switchTheme,
            ),
            const Divider(height: 1),
            ListTile(
              title: Text(
                L10n.of(context)!.wallpaper,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (wallpaper != null)
              ListTile(
                title: Image.file(
                  wallpaper,
                  height: 38,
                  fit: BoxFit.cover,
                ),
                trailing: const Icon(
                  Icons.delete_outlined,
                  color: Colors.red,
                ),
                onTap: controller.deleteWallpaperAction,
              ),
            Builder(
              builder: (context) {
                return ListTile(
                  title: Text(L10n.of(context)!.changeWallpaper),
                  trailing: Icon(
                    Icons.photo_outlined,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  onTap: controller.setWallpaperAction,
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: Text(
                L10n.of(context)!.messages,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Material(
                color: Theme.of(context).colorScheme.primary,
                elevation: 6,
                shadowColor:
                    Theme.of(context).secondaryHeaderColor.withAlpha(100),
                borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                child: Padding(
                  padding: EdgeInsets.all(16 * AppConfig.bubbleSizeFactor),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize:
                          AppConfig.messageFontSize * AppConfig.fontSizeFactor,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(L10n.of(context)!.fontSize),
              trailing: Text('× ${AppConfig.fontSizeFactor}'),
            ),
            Slider.adaptive(
              min: 0.5,
              max: 2.5,
              divisions: 20,
              value: AppConfig.fontSizeFactor,
              semanticFormatterCallback: (d) => d.toString(),
              onChanged: controller.changeFontSizeFactor,
            ),
            ListTile(
              title: Text(L10n.of(context)!.bubbleSize),
              trailing: Text('× ${AppConfig.bubbleSizeFactor}'),
            ),
            Slider.adaptive(
              min: 0.5,
              max: 1.5,
              divisions: 4,
              value: AppConfig.bubbleSizeFactor,
              semanticFormatterCallback: (d) => d.toString(),
              onChanged: controller.changeBubbleSizeFactor,
            ),
          ],
        ),
      ),
    );
  }
}
