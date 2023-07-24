import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'image_bubble.dart';

class Sticker extends StatefulWidget {
  final Event event;
  final Color watermarkColor;

  const Sticker(this.event, {super.key, required this.watermarkColor});

  @override
  StickerState createState() => StickerState();
}

class StickerState extends State<Sticker> {
  bool? animated;

  @override
  Widget build(BuildContext context) {
    return ImageBubble(
      widget.event,
      width: 400,
      height: 400,
      fit: BoxFit.contain,
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
