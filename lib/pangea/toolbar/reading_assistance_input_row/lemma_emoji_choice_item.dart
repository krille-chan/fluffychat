import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';

class LemmaEmojiChoiceItem extends StatefulWidget {
  const LemmaEmojiChoiceItem({
    super.key,
    required this.content,
    required this.onTap,
  });

  final String content;
  final Function onTap;

  @override
  LemmaEmojiChoiceItemState createState() => LemmaEmojiChoiceItemState();
}

class LemmaEmojiChoiceItemState extends State<LemmaEmojiChoiceItem> {
  bool _isHovered = false;

  Color color(BuildContext context) {
    if (_isHovered) {
      return Theme.of(context).colorScheme.primaryContainer;
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color(context).withAlpha((0.4 * 255).toInt()),
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
      child: InkWell(
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        onTap: () {
          if (!mounted) {
            return;
          }
          widget.onTap();
        },
        child: Text(
          widget.content,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
