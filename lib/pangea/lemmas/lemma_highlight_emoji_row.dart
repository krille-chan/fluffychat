import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/lemmas/user_set_lemma_info.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_builder.dart';

class LemmmaHighlightEmojiRow extends StatefulWidget {
  final LemmaMeaningBuilderState controller;
  final ConstructIdentifier cId;
  final VoidCallback? onTapOverride;
  final bool isSelected;
  final double? iconSize;

  const LemmmaHighlightEmojiRow({
    super.key,
    required this.controller,
    required this.cId,
    required this.onTapOverride,
    required this.isSelected,
    this.iconSize,
  });

  @override
  LemmmaHighlightEmojiRowState createState() => LemmmaHighlightEmojiRowState();
}

class LemmmaHighlightEmojiRowState extends State<LemmmaHighlightEmojiRow> {
  String? displayEmoji;

  @override
  void initState() {
    super.initState();
    displayEmoji = widget.cId.userSetEmoji.firstOrNull;
  }

  @override
  didUpdateWidget(LemmmaHighlightEmojiRow oldWidget) {
    if (oldWidget.isSelected != widget.isSelected ||
        widget.cId.userSetEmoji != oldWidget.cId.userSetEmoji) {
      setState(() => displayEmoji = widget.cId.userSetEmoji.firstOrNull);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setEmoji(String emoji) async {
    try {
      setState(() => displayEmoji = emoji);
      await widget.cId.setUserLemmaInfo(
        UserSetLemmaInfo(
          emojis: [emoji],
        ),
      );
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(data: widget.cId.toJson(), e: e, s: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.isLoading) {
      return const CircularProgressIndicator.adaptive();
    }

    final emojis = widget.controller.lemmaInfo?.emoji;
    if (widget.controller.error != null || emojis == null || emojis.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      borderRadius: BorderRadius.circular(AppConfig.borderRadius),
      child: Container(
        padding: const EdgeInsets.all(8),
        height: 80,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: emojis
                .map(
                  (emoji) => EmojiChoiceItem(
                    emoji: emoji,
                    onSelectEmoji: () => setEmoji(emoji),
                    // will highlight selected emoji, or the first emoji if none are selected
                    isDisplay: (displayEmoji == emoji ||
                        (displayEmoji == null && emoji == emojis.first)),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class EmojiChoiceItem extends StatefulWidget {
  final String emoji;
  final VoidCallback onSelectEmoji;
  final bool isDisplay;

  const EmojiChoiceItem({
    super.key,
    required this.emoji,
    required this.isDisplay,
    required this.onSelectEmoji,
  });

  @override
  EmojiChoiceItemState createState() => EmojiChoiceItemState();
}

class EmojiChoiceItemState extends State<EmojiChoiceItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onSelectEmoji,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isHovered
                  ? Theme.of(context).colorScheme.primary.withAlpha(50)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              border: widget.isDisplay
                  ? Border.all(
                      color: AppConfig.goldLight,
                      width: 4,
                    )
                  : null,
            ),
            child: Text(
              widget.emoji,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    );
  }
}
