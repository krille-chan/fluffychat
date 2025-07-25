import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class TextMessage extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final TextStyle linkStyle;
  final void Function(LinkableElement) onOpen;
  final bool limitHeight;

  const TextMessage({
    super.key,
    required this.text,
    required this.fontSize,
    required this.linkStyle,
    required this.onOpen,
    this.textColor = Colors.black,
    this.limitHeight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      LinkifySpan(
        text: text,
        options: const LinkifyOptions(humanize: false),
        linkStyle: linkStyle,
        onOpen: onOpen,
      ),
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
      ),
      maxLines: limitHeight ? 64 : null,
      overflow: TextOverflow.fade,
    );
  }
}
