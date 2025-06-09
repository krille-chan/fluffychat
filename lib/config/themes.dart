import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_config.dart';

abstract class FluffyThemes {
  static const double columnWidth = 380.0;

  // #Pangea
  // static const double navRailWidth = 80.0;
  static const double navRailWidth = 72.0;
  // Pangea#

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
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: seed ??
          AppConfig.colorSchemeSeed ??
          Theme.of(context).colorScheme.primary,
      // primary: AppConfig.primaryColor,
      // secondary: AppConfig.gold,
    );
    final isColumnMode = FluffyThemes.isColumnMode(context);
    return ThemeData(
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      dividerColor: brightness == Brightness.dark
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainer,
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
        contentPadding: const EdgeInsets.all(12),
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
            color: colorScheme.primary,
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.primary),
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
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: colorScheme.onSecondaryContainer,
          elevation: 0,
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
      // #Pangea
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(),
      ),
      // Pangea#
    );
  }

  // #Pangea
  // TextTheme scaleTextTheme(TextTheme base, Size size) {
  //   debugPrint("scaling text theme based on width ${size.width}");
  //   double factor = 1.0;
  //   if (size.width < 400) {
  //     factor = 0.7;
  //   } else if (size.width < 600) {
  //     factor = 1.25;
  //   } else if (size.width > 400) {
  //     factor = 1.1;
  //   }
  //   return base.copyWith(
  //     displayLarge: base.displayLarge?.copyWith(fontSize: base.displayLarge!.fontSize! * factor),
  //     displayMedium: base.displayMedium?.copyWith(fontSize: base.displayMedium!.fontSize! * factor),
  //     displaySmall: base.displaySmall?.copyWith(fontSize: base.displaySmall!.fontSize! * factor),
  //     headlineLarge: base.headlineLarge?.copyWith(fontSize: base.headlineLarge!.fontSize! * factor),
  //     headlineMedium: base.headlineMedium?.copyWith(fontSize: base.headlineMedium!.fontSize! * factor),
  //     headlineSmall: base.headlineSmall?.copyWith(fontSize: base.headlineSmall!.fontSize! * factor),
  //     titleLarge: base.titleLarge?.copyWith(fontSize: base.titleLarge!.fontSize! * factor),
  //     titleMedium: base.titleMedium?.copyWith(fontSize: base.titleMedium!.fontSize! * factor),
  //     titleSmall: base.titleSmall?.copyWith(fontSize: base.titleSmall!.fontSize! * factor),
  //     bodyLarge: base.bodyLarge?.copyWith(fontSize: base.bodyLarge!.fontSize! * factor),
  //     bodyMedium: base.bodyMedium?.copyWith(fontSize: base.bodyMedium!.fontSize! * factor),
  //     bodySmall: base.bodySmall?.copyWith(fontSize: base.bodySmall!.fontSize! * factor),
  //     labelLarge: base.labelLarge?.copyWith(fontSize: base.labelLarge!.fontSize! * factor),
  //     labelMedium: base.labelMedium?.copyWith(fontSize: base.labelMedium!.fontSize! * factor),
  //     labelSmall: base.labelSmall?.copyWith(fontSize: base.labelSmall!.fontSize! * factor),
  //   );
  // }
  // Pangea#
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
