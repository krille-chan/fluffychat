import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/services.dart';

import 'app_config.dart';

abstract class FluffyThemes {
  static const double columnWidth = 360.0;

  static const fallbackTextStyle =
      TextStyle(fontFamily: 'NotoSans', fontFamilyFallback: ['NotoEmoji']);

  static var fallback_text_theme = PlatformInfos.isDesktop
      ? TextTheme(
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
          subtitle2: fallbackTextStyle)
      : TextTheme();

  static ThemeData light = ThemeData(
    visualDensity: VisualDensity.standard,
    primaryColorDark: Colors.white,
    primaryColorLight: Color(0xff121212),
    brightness: Brightness.light,
    primaryColor: AppConfig.primaryColor,
    colorScheme: ThemeData.light().colorScheme.copyWith(
          primary: AppConfig.primaryColor,
          secondary: AppConfig.primaryColor,
        ),
    backgroundColor: Colors.white,
    secondaryHeaderColor: lighten(AppConfig.primaryColor, .51),
    scaffoldBackgroundColor: Colors.white,
    textTheme: Typography.material2018().black.merge(fallback_text_theme),
    snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppConfig.primaryColor,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: AppConfig.primaryColor,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
        padding: EdgeInsets.all(12),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
      clipBehavior: Clip.hardEdge,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        borderSide: BorderSide(
          color: lighten(AppConfig.primaryColor, .51),
        ),
      ),
      filled: true,
      fillColor: lighten(AppConfig.primaryColor, .51),
    ),
    appBarTheme: AppBarTheme(
      elevation: 2,
      brightness: Brightness.light,
      color: Colors.white,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );

  static ThemeData dark = ThemeData.dark().copyWith(
    visualDensity: VisualDensity.standard,
    primaryColorDark: Color(0xff121212),
    primaryColorLight: Colors.white,
    primaryColor: AppConfig.primaryColor,
    errorColor: Color(0xFFCF6679),
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: AppConfig.primaryColorLight,
          secondary: AppConfig.primaryColorLight,
        ),
    secondaryHeaderColor: FluffyThemes.darken(AppConfig.primaryColorLight, .65),
    textTheme: Typography.material2018().white.merge(fallback_text_theme),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
      clipBehavior: Clip.hardEdge,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppConfig.primaryColor,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius)),
      filled: true,
      fillColor: FluffyThemes.darken(AppConfig.primaryColorLight, .71),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        borderSide: BorderSide(
          color: FluffyThemes.darken(AppConfig.primaryColor, .31),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: AppConfig.primaryColor,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
        padding: EdgeInsets.all(12),
      ),
    ),
    snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating),
    appBarTheme: AppBarTheme(
      elevation: 2,
      brightness: Brightness.dark,
      color: Color(0xff1D1D1D),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );

  static Color chatListItemColor(
          BuildContext context, bool activeChat, bool selected) =>
      selected
          ? Theme.of(context).primaryColor.withAlpha(100)
          : Theme.of(context).brightness == Brightness.light
              ? activeChat
                  ? Color(0xFFE8E8E8)
                  : Colors.white
              : activeChat
                  ? Color(0xff121212)
                  : Colors.black;

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
