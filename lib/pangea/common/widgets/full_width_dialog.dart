import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      constraints: kIsWeb
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

    return kIsWeb ? Dialog(child: content) : Dialog.fullscreen(child: content);
  }
}
