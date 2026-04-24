import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class FluffyThemes {
  static const double columnWidth = 380.0;

  static const double maxTimelineWidth = columnWidth * 2;

  static const double navRailWidth = 80.0;

  static bool isColumnModeByWidth(double width) =>
      width > columnWidth * 2 + navRailWidth;

  static bool isColumnMode(BuildContext context) =>
      isColumnModeByWidth(MediaQuery.sizeOf(context).width);

  static bool isThreeColumnMode(BuildContext context) =>
      MediaQuery.sizeOf(context).width > FluffyThemes.columnWidth * 3.5;

  static LinearGradient backgroundGradient(BuildContext context, int alpha) {
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
      seedColor: seed ?? Color(AppSettings.colorSchemeSeedInt.value),
    );
    final isColumnMode = FluffyThemes.isColumnMode(context);
    final isApple = PlatformInfos.isCupertinoStyle;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      // SF Pro Text on Apple platforms; Material default elsewhere.
      // 'CupertinoSystemText' is resolved by the Flutter engine to
      // .AppleSystemUIFont, with the Display↔Text split handled natively
      // at the 20pt boundary.
      fontFamily: isApple ? 'CupertinoSystemText' : null,
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
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
        shadowColor: isColumnMode
            ? colorScheme.surfaceContainer.withAlpha(128)
            : null,
        surfaceTintColor: isColumnMode ? colorScheme.surface : null,
        backgroundColor: isColumnMode ? colorScheme.surface : null,
        actionsPadding: isColumnMode
            ? const EdgeInsets.symmetric(horizontal: 16.0)
            : null,
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
          side: BorderSide(width: 1, color: colorScheme.primary),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        strokeCap: StrokeCap.round,
        color: colorScheme.primary,
        refreshBackgroundColor: colorScheme.primaryContainer,
      ),
      snackBarTheme: isColumnMode
          ? const SnackBarThemeData(
              showCloseIcon: true,
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
      textTheme: isApple
          ? _appleTextTheme(null, isIOS: PlatformInfos.isIOS)
          : null,
    );
  }

  /// Applies Apple HIG letter-spacing to Material 3 text styles so SF Pro
  /// renders with native tracking on iOS/macOS. Sizes and weights stay at
  /// Material 3 defaults; only [TextStyle.letterSpacing] is replaced.
  ///
  /// When [base] is null, an empty [TextTheme] is used; `ThemeData` merges
  /// the resulting styles on top of the default Material 3 [TextTheme], so
  /// every Material-size remains intact.
  static TextTheme _appleTextTheme(TextTheme? base, {required bool isIOS}) {
    // Values from Apple HIG:
    //   iOS: https://developer.apple.com/design/human-interface-guidelines/typography
    //   macOS: same page, macOS typography table.
    final titleLarge = isIOS ? -0.41 : 0.34;
    final titleMedium = isIOS ? -0.32 : 0.38;
    final titleSmall = isIOS ? -0.24 : 0.0;
    final bodyLarge = isIOS ? -0.41 : 0.08;
    final bodyMedium = isIOS ? -0.08 : 0.0;
    final bodySmall = isIOS ? 0.0 : 0.06;
    final labelLarge = isIOS ? -0.41 : -0.08;
    final labelMedium = isIOS ? 0.06 : 0.12;
    final labelSmall = isIOS ? 0.06 : 0.4;
    final b = base ?? const TextTheme();
    return b.copyWith(
      titleLarge: (b.titleLarge ?? const TextStyle()).copyWith(
        letterSpacing: titleLarge,
      ),
      titleMedium: (b.titleMedium ?? const TextStyle()).copyWith(
        letterSpacing: titleMedium,
      ),
      titleSmall: (b.titleSmall ?? const TextStyle()).copyWith(
        letterSpacing: titleSmall,
      ),
      bodyLarge: (b.bodyLarge ?? const TextStyle()).copyWith(
        letterSpacing: bodyLarge,
      ),
      bodyMedium: (b.bodyMedium ?? const TextStyle()).copyWith(
        letterSpacing: bodyMedium,
      ),
      bodySmall: (b.bodySmall ?? const TextStyle()).copyWith(
        fontSize: 13,
        letterSpacing: bodySmall,
      ),
      labelLarge: (b.labelLarge ?? const TextStyle()).copyWith(
        letterSpacing: labelLarge,
      ),
      labelMedium: (b.labelMedium ?? const TextStyle()).copyWith(
        letterSpacing: labelMedium,
      ),
      labelSmall: (b.labelSmall ?? const TextStyle()).copyWith(
        fontSize: 12,
        letterSpacing: labelSmall,
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
