import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../config/app_config.dart';
import 'image_bubble.dart';

class Sticker extends StatefulWidget {
  final Event event;

  const Sticker(this.event, {Key key}) : super(key: key);

  @override
  _StickerState createState() => _StickerState();
}

class _StickerState extends State<Sticker> {
  bool animated;

  @override
  Widget build(BuildContext context) {
    // stickers should default to a ratio of 1:1
    var ratio = 1.0;
    // if a width and a height is specified for stickers, use those!
    if (widget.event.infoMap['w'] is int && widget.event.infoMap['h'] is int) {
      ratio = widget.event.infoMap['w'] / widget.event.infoMap['h'];
      // make sure the ratio is within 0.9 - 2.0
      if (ratio > 2.0) {
        ratio = 2.0;
      }
      if (ratio < 0.9) {
        ratio = 0.9;
      }
    }
    return ImageBubble(
      widget.event,
      width: 400,
      height: 400 / ratio,
      fit: ratio <= 1.0 ? BoxFit.contain : BoxFit.cover,
      onTap: () {
        setState(() => animated = true);
        showOkAlertDialog(
          context: context,
          message: widget.event.body,
          okLabel: L10n.of(context).ok,
        );
      },
      animated: animated ?? AppConfig.autoplayImages,
    );
  }
}
