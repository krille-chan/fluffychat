import 'package:flutter/material.dart';

class ShrinkableText extends StatelessWidget {
  final String text;
  final double maxWidth;
  final TextStyle? style;

  const ShrinkableText({
    super.key,
    required this.text,
    required this.maxWidth,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: style,
            ),
          ),
        );
      },
    );
  }
}
