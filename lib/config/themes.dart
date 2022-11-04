import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'app_config.dart';

abstract class FluffyThemes {
  static const double columnWidth = 360.0;

  static bool isColumnModeByWidth(double width) => width > columnWidth * 2 + 64;

  static bool isColumnMode(BuildContext context) =>
      isColumnModeByWidth(MediaQuery.of(context).size.width);

  static bool getDisplayNavigationRail(BuildContext context) =>
      !VRouter.of(context).path.startsWith('/settings');

  static const fallbackTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontFamilyFallback: ['NotoEmoji'],
  );

  static var fallbackTextTheme = const TextTheme(
    bodyText1: fallbackTextStyle,
    bodyText2: fallbackTextStyle,
    button: fallbackTextStyle,
    caption: fallbackTextStyle,
    overline: fallbackTextStyle,
    headline1: fallbackTextStyle,
    headline2: fallbackTextStyle,
    headline3: fallbackTextStyle,
    headline4: fallbackTextStyle,
    headline5: fallbackTextStyle,
    headline6: fallbackTextStyle,
    subtitle1: fallbackTextStyle,
    subtitle2: fallbackTextStyle,
  );

  static ThemeData buildTheme(Brightness brightness,
          [ColorScheme? colorScheme]) =>
      ThemeData(
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        brightness: brightness,
        colorSchemeSeed: AppConfig.colorSchemeSeed ??
            colorScheme?.primary ??
            AppConfig.chatColor,
        textTheme: PlatformInfos.isDesktop
            ? brightness == Brightness.light
                ? Typography.material2018().black.merge(fallbackTextTheme)
                : Typography.material2018().white.merge(fallbackTextTheme)
            : null,
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        dividerColor: brightness == Brightness.light
            ? Colors.blueGrey.shade50
            : Colors.blueGrey.shade900,
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          filled: true,
        ),
        appBarTheme: AppBarTheme(
          surfaceTintColor:
              brightness == Brightness.light ? Colors.white : Colors.black,
          shadowColor: Colors.black.withAlpha(64),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: brightness.reversed,
            statusBarBrightness: brightness,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      );
}

extension on Brightness {
  Brightness get reversed =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}
