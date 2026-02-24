import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';

class ErrorIndicator extends StatelessWidget {
  final String message;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? style;
  final VoidCallback? onTap;

  const ErrorIndicator({
    super.key,
    required this.message,
    this.iconSize,
    this.iconColor,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context).style;
    final style = defaultStyle.merge(this.style ?? defaultStyle);
    final content = RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(
              Icons.error,
              color: iconColor ?? AppConfig.error,
              size: iconSize ?? 24.0,
            ),
          ),
          TextSpan(text: '  '),
          TextSpan(text: message, style: style),
        ],
      ),
    );

    if (onTap != null) {
      return TextButton(onPressed: onTap, child: content);
    }

    return content;
  }
}
