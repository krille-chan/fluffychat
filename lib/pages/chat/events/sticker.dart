import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../../config/app_config.dart';
import 'image_bubble.dart';

class Sticker extends StatefulWidget {
  final Event event;
  final BorderRadius borderRadius;

  const Sticker(this.event, {required this.borderRadius, super.key});

  @override
  StickerState createState() => StickerState();
}

class StickerState extends State<Sticker> {
  bool? animated;

  @override
  Widget build(BuildContext context) {
    return ImageBubble(
      widget.event,
      width: 256,
      height: 256,
      fit: BoxFit.contain,
      borderRadius: widget.borderRadius,
      onTap: () {
        setState(() => animated = true);
        showOkAlertDialog(
          context: context,
          message: widget.event.body,
          okLabel: L10n.of(context)!.ok,
        );
      },
      animated: animated ?? AppConfig.autoplayImages,
    );
  }
}
