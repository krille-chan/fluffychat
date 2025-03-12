import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';

class FullWidthDialog extends StatelessWidget {
  final Widget dialogContent;
  final double maxWidth;
  final double maxHeight;

  const FullWidthDialog({
    required this.dialogContent,
    required this.maxWidth,
    required this.maxHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: FluffyThemes.isColumnMode(context)
          ? BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            )
          : BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              maxHeight: MediaQuery.of(context).size.height,
            ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: dialogContent,
      ),
    );

    return FluffyThemes.isColumnMode(context)
        ? Dialog(child: content)
        : Dialog.fullscreen(child: content);
  }
}
