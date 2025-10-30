import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final String message;
  final double? iconSize;
  final TextStyle? style;
  final VoidCallback? onTap;

  const ErrorIndicator({
    super.key,
    required this.message,
    this.iconSize,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.error,
          size: iconSize ?? 24.0,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message,
            style: style,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return TextButton(
        onPressed: onTap,
        child: content,
      );
    }

    return content;
  }
}
