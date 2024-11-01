import 'package:flutter/material.dart';

class IconNumberWidget extends StatelessWidget {
  final IconData icon;
  final String number;
  final Color? iconColor;
  final double? iconSize;
  final String? toolTip;
  final VoidCallback? onPressed;

  const IconNumberWidget({
    super.key,
    required this.icon,
    required this.number,
    this.toolTip,
    this.iconColor,
    this.iconSize,
    this.onPressed,
  });

  Widget _content(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(
            icon,
            color: iconColor ?? Theme.of(context).iconTheme.color,
            size: iconSize ?? Theme.of(context).iconTheme.size,
          ),
          onPressed: onPressed,
        ),
        const SizedBox(width: 5),
        Text(
          number.toString(),
          style: TextStyle(
            fontSize:
                iconSize ?? Theme.of(context).textTheme.bodyMedium?.fontSize,
            color: iconColor ?? Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return toolTip != null
        ? Tooltip(message: toolTip!, child: _content(context))
        : _content(context);
  }
}
