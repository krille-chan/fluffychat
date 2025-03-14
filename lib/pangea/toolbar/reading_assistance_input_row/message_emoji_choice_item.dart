import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';

class MessageEmojiChoiceItem extends StatefulWidget {
  const MessageEmojiChoiceItem({
    super.key,
    this.topContent,
    this.textSize = 20,
    required this.content,
    required this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    required this.isSelected,
    this.contentOpacity = 1.0,
    required this.greenHighlight,
  });

  final Widget? topContent;
  final String content;
  final void Function() onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final bool isSelected;
  final double textSize;
  final double contentOpacity;
  final bool greenHighlight;

  @override
  MessageEmojiChoiceItemState createState() => MessageEmojiChoiceItemState();
}

class MessageEmojiChoiceItemState extends State<MessageEmojiChoiceItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Align(
        alignment: Alignment.center,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withAlpha((0.2 * 255).toInt())
                    : _isHovered
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha((0.1 * 255).toInt())
                        : widget.greenHighlight
                            ? AppConfig.success.withAlpha((0.1 * 255).toInt())
                            : Colors.transparent,
                borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              ),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    if (widget.topContent != null)
                      Opacity(
                        opacity: widget.contentOpacity,
                        child: widget.topContent,
                      ),
                    Text(
                      widget.content,
                      style: TextStyle(fontSize: widget.textSize - 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
