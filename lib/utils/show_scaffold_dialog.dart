import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';

Future<void> showScaffoldDialog({
  required BuildContext context,
  Color? barrierColor,
  Color? containerColor,
  double maxWidth = 480,
  double maxHeight = 720,
  required Widget Function(BuildContext context) builder,
}) =>
    showDialog(
      context: context,
      useSafeArea: false,
      builder: FluffyThemes.isColumnMode(context)
          ? (context) => Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppConfig.borderRadius,
                    ),
                    color: containerColor ??
                        Theme.of(context).scaffoldBackgroundColor,
                  ),
                  clipBehavior: Clip.hardEdge,
                  margin: const EdgeInsets.all(16),
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                  ),
                  child: builder(context),
                ),
              )
          : builder,
    );
