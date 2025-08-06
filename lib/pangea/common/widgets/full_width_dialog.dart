import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';

class FullWidthDialog extends StatelessWidget {
  final Widget dialogContent;
  final double maxWidth;
  final double maxHeight;
  final Color? backgroundColor;

  const FullWidthDialog({
    required this.dialogContent,
    required this.maxWidth,
    required this.maxHeight,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);
    final content = AnimatedSize(
      duration: FluffyThemes.animationDuration,
      child: ConstrainedBox(
        constraints: isColumnMode
            ? BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: maxHeight,
              )
            : BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height,
              ),
        child: ClipRRect(
          borderRadius:
              isColumnMode ? BorderRadius.circular(20.0) : BorderRadius.zero,
          child: dialogContent,
        ),
      ),
    );

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: isColumnMode
          ? Dialog(
              backgroundColor: backgroundColor,
              child: content,
            )
          : Dialog.fullscreen(
              backgroundColor: backgroundColor,
              child: content,
            ),
    );
  }
}
