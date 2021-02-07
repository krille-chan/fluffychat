import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/utils/platform_infos.dart';

import '../app_config.dart';

abstract class FluffyThemes {
  static const double columnWidth = 360.0;

  static const fallback_text_style =
      TextStyle(fontFamily: 'NotoSans', fontFamilyFallback: ['NotoEmoji']);

  static var fallback_text_theme = PlatformInfos.isDesktop
      ? TextTheme(
          bodyText1: fallback_text_style,
          bodyText2: fallback_text_style,
          button: fallback_text_style,
          caption: fallback_text_style,
          overline: fallback_text_style,
          headline1: fallback_text_style,
          headline2: fallback_text_style,
          headline3: fallback_text_style,
          headline4: fallback_text_style,
          headline5: fallback_text_style,
          headline6: fallback_text_style,
          subtitle1: fallback_text_style,
          subtitle2: fallback_text_style)
      : TextTheme();

  static ThemeData light = ThemeData(
    primaryColorDark: Colors.white,
    primaryColorLight: Color(0xff121212),
    brightness: Brightness.light,
    primaryColor: AppConfig.primaryColor,
    accentColor: AppConfig.primaryColor,
    backgroundColor: Colors.white,
    secondaryHeaderColor: AppConfig.primaryColor.withAlpha(16),
    scaffoldBackgroundColor: Colors.white,
    textTheme: Typography.material2018().black.merge(fallback_text_theme),
    snackBarTheme: SnackBarThemeData(
      behavior: kIsWeb ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
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
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        borderSide: BorderSide(
          color: AppConfig.primaryColor.withAlpha(16),
        ),
      ),
      filled: true,
      fillColor: AppConfig.primaryColor.withAlpha(16),
    ),
    appBarTheme: AppBarTheme(
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
    primaryColorDark: Color(0xff121212),
    primaryColorLight: Colors.white,
    primaryColor: AppConfig.primaryColor,
    errorColor: Color(0xFFCF6679),
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    accentColor: AppConfig.primaryColorLight,
    secondaryHeaderColor: AppConfig.primaryColorLight.withAlpha(32),
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppConfig.primaryColor,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius)),
      filled: true,
      fillColor: AppConfig.primaryColorLight.withAlpha(32),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        borderSide: BorderSide(
          color: AppConfig.primaryColor.withAlpha(16),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
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
}
