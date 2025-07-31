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
      primaryFixed: Color(0xFFE0E444),
      primaryContainer: Color(0xFF82893F),
      onPrimaryContainer: Color(0xFF212529),
      secondary: Color(0xFFEE7F4B),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFEE7F4B),
      onSecondaryContainer: Color(0xFFADB5BD),
      tertiary: Color(0xFF3D3D3D),
      onTertiary: Color.fromARGB(255, 82, 82, 82),
      tertiaryContainer: Color(0xFF3D3D3D),
      onTertiaryContainer: Color(0xFFADB5BD),
      surface: Color(0xFF212529),
      onSurface: Color(0xFFADB5BD),
      surfaceContainerLow: Color.fromARGB(255, 27, 29, 29),
      surfaceContainer: Color(0xFF212529),
      surfaceContainerHighest: Color.fromARGB(255, 59, 63, 66),
      error: Color.fromARGB(255, 243, 117, 117),
      onError: Color.fromARGB(255, 243, 117, 117),
      errorContainer: Color.fromARGB(255, 243, 117, 117),
      onErrorContainer: Color(0xFF000000),
      surfaceTint: Color(0xFFE3ED55),
      outline: Color(0xFFE3ED55),
    );

    final isColumnMode = FluffyThemes.isColumnMode(context);
    return ThemeData(
      textTheme: GoogleFonts.fredokaTextTheme(
        Theme.of(context).textTheme.copyWith(
              bodyMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: colorScheme.onSurface,
              ),
              bodySmall: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: colorScheme.onSurface,
              ),
              headlineSmall: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              titleLarge: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              titleSmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
      ),
      splashColor: colorScheme.primary.withValues(alpha: 0.1),
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      dividerColor: colorScheme.tertiary,
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
          iconColor: colorScheme.onPrimary,
          selectedBackgroundColor: colorScheme.primary,
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
        backgroundColor: colorScheme.tertiary,
        selectedColor: colorScheme.primary.withValues(alpha: 0.2),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
        labelStyle: TextStyle(
          color: colorScheme.onSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        toolbarHeight: isColumnMode ? 72 : 56,
        shadowColor: null,
        surfaceTintColor: Colors.transparent,
        backgroundColor: isColumnMode ? colorScheme.surface : null,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness.reversed,
          statusBarBrightness: brightness,
          systemNavigationBarIconBrightness: brightness.reversed,
          systemNavigationBarColor: colorScheme.surface,
        ),
        foregroundColor: colorScheme.onSurface,
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
      : colorScheme.primary.withValues(alpha: 0.1);

  Color get onBubbleColor => colorScheme.onSecondary;

  Color get secondaryBubbleColor => brightness == Brightness.light
      ? colorScheme.tertiary
      : colorScheme.secondary.withValues(alpha: 0.5);
}
