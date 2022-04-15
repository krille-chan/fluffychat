import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'app_config.dart';

abstract class FluffyThemes {
  static const double columnWidth = 360.0;
  static bool isColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width > columnWidth * 2;

  static const fallbackTextStyle =
      TextStyle(fontFamily: 'Roboto', fontFamilyFallback: ['NotoEmoji']);

  static InputDecoration loginTextFieldDecoration({
    String? errorText,
    String? labelText,
    String? hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) =>
      InputDecoration(
        fillColor: Colors.white.withAlpha(200),
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        errorText: errorText,
        errorStyle: TextStyle(
          color: Colors.red.shade200,
          shadows: const [
            Shadow(
              color: Colors.black,
              offset: Offset(0, 0),
              blurRadius: 5,
            ),
          ],
        ),
        labelStyle: const TextStyle(
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black,
              offset: Offset(0, 0),
              blurRadius: 5,
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(16),
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

  static ThemeData get light => ThemeData(
        visualDensity: VisualDensity.standard,
        primaryColorDark: Colors.white,
        primaryColorLight: const Color(0xff121212),
        brightness: Brightness.light,
        primaryColor: AppConfig.chatColor,
        colorScheme: ThemeData.light().colorScheme.copyWith(
              primary: AppConfig.chatColor,
              secondary: AppConfig.chatColor,
              surface: FluffyThemes.lighten(AppConfig.chatColor, 0.535),
            ),
        backgroundColor: Colors.white,
        secondaryHeaderColor: Colors.blueGrey.shade50,
        scaffoldBackgroundColor: Colors.white,
        textTheme: PlatformInfos.isDesktop
            ? Typography.material2018().black.merge(fallbackTextTheme)
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
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppConfig.chatColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppConfig.chatColor,
            onPrimary: Colors.white,
            textStyle: const TextStyle(fontSize: 16),
            elevation: 6,
            shadowColor: const Color(0x44000000),
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            ),
            padding: const EdgeInsets.all(12),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 6,
          shadowColor: const Color(0x44000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
          clipBehavior: Clip.hardEdge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            borderSide: BorderSide(
              color: lighten(AppConfig.chatColor, .51),
              width: 1,
            ),
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 6,
          shadowColor: Color(0x44000000),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
      );

  static ThemeData get dark => ThemeData.dark().copyWith(
        visualDensity: VisualDensity.standard,
        primaryColorDark: const Color(0xff121212),
        primaryColorLight: Colors.white,
        primaryColor: AppConfig.chatColor,
        errorColor: const Color(0xFFCF6679),
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              primary: FluffyThemes.lighten(AppConfig.chatColor, 0.33),
              secondary: FluffyThemes.lighten(AppConfig.chatColor, 0.33),
              surface: FluffyThemes.darken(AppConfig.chatColor, 0.35),
            ),
        secondaryHeaderColor: Colors.blueGrey.shade900,
        textTheme: PlatformInfos.isDesktop
            ? Typography.material2018().white.merge(fallbackTextTheme)
            : null,
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
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppConfig.chatColor,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius)),
          filled: true,
          fillColor: Colors.blueGrey.shade900,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            borderSide: BorderSide(
              color: FluffyThemes.darken(AppConfig.chatColor, .31),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppConfig.chatColor,
            onPrimary: Colors.white,
            minimumSize: const Size.fromHeight(48),
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            ),
            padding: const EdgeInsets.all(12),
          ),
        ),
        snackBarTheme:
            const SnackBarThemeData(behavior: SnackBarBehavior.floating),
        appBarTheme: const AppBarTheme(
          elevation: 6,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Color(0xff1D1D1D),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cupertinoOverrideTheme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(),
        ),
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
