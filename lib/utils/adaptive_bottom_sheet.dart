import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';

Future<T?> showAdaptiveBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool isDismissible = true,
  bool isScrollControlled = true,
  bool useRootNavigator = true,
}) {
  if (FluffyThemes.isColumnMode(context)) {
    return showDialog<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      barrierDismissible: isDismissible,
      useSafeArea: true,
      builder: (context) => Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(
            maxWidth: 480,
            maxHeight: 720,
          ),
          child: Material(
            elevation: Theme.of(context).dialogTheme.elevation ?? 4,
            shadowColor: Theme.of(context).dialogTheme.shadowColor,
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            color: Theme.of(context).scaffoldBackgroundColor,
            clipBehavior: Clip.hardEdge,
            child: builder(context),
          ),
        ),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConfig.borderRadius / 2),
          topRight: Radius.circular(AppConfig.borderRadius / 2),
        ),
        child: builder(context),
      ),
    ),
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    constraints: BoxConstraints(
      maxHeight: min(MediaQuery.sizeOf(context).height - 32, 600),
      maxWidth: FluffyThemes.columnWidth * 1.25,
    ),
    backgroundColor: Colors.transparent,
    clipBehavior: Clip.hardEdge,
  );
}
