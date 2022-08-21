import 'package:flutter/material.dart';

import 'app_config.dart';

abstract class FluffyThemes {
  static const double columnWidth = 360.0;
  static bool isColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width > columnWidth * 2;

  static ThemeData buildTheme(Brightness brightness,
          [ColorScheme? colorScheme]) =>
      ThemeData(
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        brightness: brightness,
        colorSchemeSeed: AppConfig.colorSchemeSeed ??
            colorScheme?.primary ??
            AppConfig.chatColor,
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        dividerColor: brightness == Brightness.light
            ? Colors.blueGrey.shade50
            : Colors.blueGrey.shade900,
        inputDecorationTheme: const InputDecorationTheme(
          border: UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          filled: true,
        ),
        appBarTheme: AppBarTheme(
          surfaceTintColor:
              brightness == Brightness.light ? Colors.white : Colors.black,
          shadowColor: Colors.black.withAlpha(64),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      );
}
