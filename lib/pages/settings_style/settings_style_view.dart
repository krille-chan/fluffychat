import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import '../../config/app_config.dart';
import '../../widgets/matrix.dart';
import 'settings_style.dart';

class SettingsStyleView extends StatelessWidget {
  final SettingsStyleController controller;

  const SettingsStyleView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    const colorPickerSize = 32.0;
    final wallpaper = Matrix.of(context).wallpaper;
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(L10n.of(context)!.changeTheme),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: MaxWidthBody(
        child: Column(
          children: [
            ListTile(
              title: Text(
                L10n.of(context)!.setColorTheme,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                                  elevation: 6,
                                  shadowColor: AppConfig.colorSchemeSeed,
                                  borderRadius:
                                      BorderRadius.circular(colorPickerSize),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        colorPickerSize,
                                      ),
                                      gradient: FluffyThemes.backgroundGradient(
                                        context,
                                        255,
                                      ),
                                    ),
                                    child: SizedBox(
                                      height: colorPickerSize,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (controller.currentColor ==
                                                  null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 8.0,
                                                  ),
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 16,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                  ),
                                                ),
                                              Text(
                                                L10n.of(context)!.systemTheme,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
            const SizedBox(height: 8),
            const Divider(height: 1),
            ListTile(
              title: Text(
                L10n.of(context)!.setTheme,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                L10n.of(context)!.messagesStyle,
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
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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
          ],
        ),
      ),
    );
  }
}
