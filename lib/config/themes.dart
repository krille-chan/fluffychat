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

  static const TextStyle loginTextFieldStyle = TextStyle(color: Colors.black);

  static InputDecoration loginTextFieldDecoration({
    String? errorText,
    String? labelText,
    String? hintText,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) =>
      InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
        fillColor: Colors.white.withAlpha(200),
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffixIconColor: Colors.black,
        prefixIconColor: Colors.black,
        iconColor: Colors.black,
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
        hintStyle: TextStyle(color: Colors.grey.shade700),
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
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: AppConfig.colorSchemeSeed,
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
        dividerColor: Colors.blueGrey.shade50,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
            elevation: 6,
            shadowColor: const Color(0x44000000),
            minimumSize: const Size.fromHeight(48),
            padding: const EdgeInsets.all(12),
          ),
        ),
        cardTheme: const CardTheme(
          elevation: 6,
          // shadowColor: Color(0x44000000),
          clipBehavior: Clip.hardEdge,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 6,
          shadowColor: Color(0x44000000),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
        ),
      );

  static ThemeData get dark => ThemeData(
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: AppConfig.colorSchemeSeed,
        scaffoldBackgroundColor: Colors.black,
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
        dividerColor: Colors.blueGrey.shade600,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: AppConfig.chatColor,
            onPrimary: Colors.white,
            minimumSize: const Size.fromHeight(48),
            textStyle: const TextStyle(fontSize: 16),
            padding: const EdgeInsets.all(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 6,
          backgroundColor: Color(0xff1D1D1D),
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
