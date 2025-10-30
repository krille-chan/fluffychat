import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/config/app_config.dart';

class LemmaEmojiChoiceItem extends StatefulWidget {
  const LemmaEmojiChoiceItem({
    super.key,
    required this.content,
    required this.onTap,
  });

  final String content;
  final VoidCallback? onTap;

  @override
  LemmaEmojiChoiceItemState createState() => LemmaEmojiChoiceItemState();
}

class LemmaEmojiChoiceItemState extends State<LemmaEmojiChoiceItem> {
  bool _isHovered = false;

  Color color(BuildContext context) {
    if (_isHovered) {
      return Theme.of(context)
          .colorScheme
          .primaryContainer
          .withAlpha((0.4 * 255).toInt());
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color(context),
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      ),
      child: InkWell(
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        onTap: widget.onTap,
        child: Text(
          widget.content,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class LemmaEmojiChoicePlaceholder extends StatelessWidget {
  const LemmaEmojiChoicePlaceholder({
    super.key,
    this.size = 40,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor:
          Theme.of(context).colorScheme.primaryContainer.withAlpha(0xAA),
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(0x66),
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
      ),
    );
  }
}
