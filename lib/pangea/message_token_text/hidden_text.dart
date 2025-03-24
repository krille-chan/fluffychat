import 'package:flutter/material.dart';

class HiddenText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const HiddenText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.size.width;
    final textHeight = textPainter.size.height;

    textPainter.dispose();

    return SizedBox(
      height: textHeight,
      child: Stack(
        children: [
          Container(
            width: textWidth,
            height: textHeight,
            color: Colors.transparent,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: textWidth,
              height: 1,
              color: style.color,
            ),
          ),
        ],
      ),
    );
  }
}
