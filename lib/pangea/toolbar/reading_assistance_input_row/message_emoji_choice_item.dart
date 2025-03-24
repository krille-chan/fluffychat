import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';

const Size emojiButtonSize = Size(60, 60);
BoxDecoration emojiButtonDecoration = BoxDecoration(
  color: Colors.transparent,
  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
);

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
    required this.isGold,
    required this.token,
  });

  final Widget? topContent;
  final String content;
  final void Function() onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  final bool isSelected;
  final double textSize;
  final double contentOpacity;
  final PangeaToken? token;
  final bool? isGold;

  @override
  MessageEmojiChoiceItemState createState() => MessageEmojiChoiceItemState();
}

class MessageEmojiChoiceItemState extends State<MessageEmojiChoiceItem> {
  bool _isHovered = false;

  @override
  didUpdateWidget(MessageEmojiChoiceItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected ||
        oldWidget.isGold != widget.isGold) {
      setState(() {});
    }
  }

  Color get color {
    if (widget.isSelected) {
      debugPrint('widget.isGold: ${widget.isGold}');
      if (widget.isGold == null) {
        return AppConfig.primaryColor.withAlpha((0.4 * 255).toInt());
      } else {
        return widget.isGold!
            ? AppConfig.success.withAlpha((0.4 * 255).toInt())
            : AppConfig.warning.withAlpha((0.4 * 255).toInt());
      }
    }
    if (_isHovered) {
      return AppConfig.primaryColor.withAlpha((0.2 * 255).toInt());
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Opacity(
      opacity: widget.contentOpacity,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          child: Container(
            height: emojiButtonSize.height,
            width: emojiButtonSize.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            ),
            child: Text(
              widget.content,
              style: TextStyle(fontSize: widget.textSize - 2),
=======
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
>>>>>>> main
            ),
          ),
        ),
      ),
    );
  }
}
