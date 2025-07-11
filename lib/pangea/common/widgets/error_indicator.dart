import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final String message;
  final double? iconSize;
  final TextStyle? style;

  const ErrorIndicator({
    super.key,
    required this.message,
    this.iconSize,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.error,
          size: iconSize ?? 24.0,
        ),
        const SizedBox(width: 8),
        Text(
          message,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
