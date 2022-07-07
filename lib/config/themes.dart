import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'app_config.dart';

abstract class FluffyThemes {
  static const double columnWidth = 360.0;
  static bool isColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width > columnWidth * 2;

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

  static ThemeData light([ColorScheme? colorScheme]) => ThemeData(
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: AppConfig.colorSchemeSeed ??
            colorScheme?.primary ??
            AppConfig.chatColor,
        textTheme: PlatformInfos.isDesktop
            ? Typography.material2018().black.merge(fallbackTextTheme)
            : null,
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        dividerColor: Colors.blueGrey.shade50,
        inputDecorationTheme: const InputDecorationTheme(
          border: UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          filled: true,
        ),
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      );

  static ThemeData dark([ColorScheme? colorScheme]) => ThemeData(
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: AppConfig.colorSchemeSeed ??
            colorScheme?.primary ??
            AppConfig.chatColor,
        textTheme: PlatformInfos.isDesktop
            ? Typography.material2018().white.merge(fallbackTextTheme)
            : null,
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          filled: true,
        ),
        dividerColor: Colors.blueGrey.shade900,
      );

  static Color blackWhiteColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black;

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
