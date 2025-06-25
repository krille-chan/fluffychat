import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_config.dart';

abstract class FluffyThemes {
  static const double columnWidth = 380.0;

  static const double maxTimelineWidth = columnWidth * 2;

  static const double navRailWidth = 80.0;

  static bool isColumnModeByWidth(double width) =>
      width > columnWidth * 2 + navRailWidth;

  static bool isColumnMode(BuildContext context) =>
      isColumnModeByWidth(MediaQuery.of(context).size.width);

  static bool isThreeColumnMode(BuildContext context) =>
      MediaQuery.of(context).size.width > FluffyThemes.columnWidth * 3.5;

  static LinearGradient backgroundGradient(
    BuildContext context,
    int alpha,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return LinearGradient(
      begin: Alignment.topCenter,
      colors: [
        colorScheme.primaryContainer.withAlpha(alpha),
        colorScheme.secondaryContainer.withAlpha(alpha),
        colorScheme.tertiaryContainer.withAlpha(alpha),
        colorScheme.primaryContainer.withAlpha(alpha),
      ],
    );
  }

  static const Duration animationDuration = Duration(milliseconds: 250);
  static const Curve animationCurve = Curves.easeInOut;

  static ThemeData buildTheme(
    BuildContext context,
    Brightness brightness, [
    Color? seed,
  ]) {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFE3ED55),
      onPrimary: Color(0xFF212529),
      secondary: Color(0xFFEE7F4B),
      onSecondary: Colors.white,
      primaryContainer: Color(0xFF3D3D3D),
      onPrimaryContainer: Colors.white,
      surface: Color(0xFF212529),
      onSurface: Color(0xFFADB5BD),
      error: Color.fromARGB(255, 145, 37, 37),
      onError: Color(0xFF212529),
    );

    final isColumnMode = FluffyThemes.isColumnMode(context);
    return ThemeData(
      textTheme: GoogleFonts.fredokaTextTheme(
        Theme.of(context).textTheme,
      ),
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      dividerColor: brightness == Brightness.dark
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainer,
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerLow,
        iconColor: colorScheme.onSurface,
        textStyle: TextStyle(color: colorScheme.onSurface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          iconColor: colorScheme.onSurface,
          disabledIconColor: colorScheme.onSurface,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colorScheme.onSurface.withAlpha(128),
        selectionHandleColor: colorScheme.secondary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: colorScheme.onSurface, width: 0.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: colorScheme.onSurface,
        ),
        prefixIconColor: colorScheme.onSurface,
      ),
      chipTheme: ChipThemeData(
        showCheckmark: false,
        backgroundColor: colorScheme.surfaceContainer,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
      ),
      appBarTheme: AppBarTheme(
        toolbarHeight: isColumnMode ? 72 : 56,
        shadowColor:
            isColumnMode ? colorScheme.surfaceContainer.withAlpha(128) : null,
        surfaceTintColor: isColumnMode ? colorScheme.surface : null,
        backgroundColor: isColumnMode ? colorScheme.surface : null,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness.reversed,
          statusBarBrightness: brightness,
          systemNavigationBarIconBrightness: brightness.reversed,
          systemNavigationBarColor: colorScheme.surface,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            width: 1,
            color: colorScheme.secondary,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.secondary),
            borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          ),
        ),
      ),
      snackBarTheme: isColumnMode
          ? const SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              width: FluffyThemes.columnWidth * 1.5,
            )
          : const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.surface,
          elevation: 0,
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surface,
        titleTextStyle:
            GoogleFonts.righteous(color: colorScheme.primary, fontSize: 18),
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
          decorationColor: colorScheme.onSurface,
        ),
      ),
    );
  }
}

extension on Brightness {
  Brightness get reversed =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}

extension BubbleColorTheme on ThemeData {
  Color get bubbleColor => brightness == Brightness.light
      ? colorScheme.primary
      : colorScheme.primaryContainer;

  Color get onBubbleColor => brightness == Brightness.light
      ? colorScheme.onPrimary
      : colorScheme.onPrimaryContainer;

  Color get secondaryBubbleColor => HSLColor.fromColor(
        brightness == Brightness.light
            ? colorScheme.tertiary
            : colorScheme.tertiaryContainer,
      ).withSaturation(0.5).toColor();
}
