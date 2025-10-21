import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/gain_points_animation.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_zoom/lemma_meaning_builder.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaHighlightEmojiRow extends StatefulWidget {
  final LemmaMeaningBuilderState controller;
  final ConstructIdentifier cId;

  const LemmaHighlightEmojiRow({
    super.key,
    required this.controller,
    required this.cId,
  });

  @override
  LemmaHighlightEmojiRowState createState() => LemmaHighlightEmojiRowState();
}

class LemmaHighlightEmojiRowState extends State<LemmaHighlightEmojiRow> {
  String? displayEmoji;
  bool _showShimmer = true;
  bool _hasShimmered = false;

  @override
  void initState() {
    super.initState();
    displayEmoji = widget.cId.userSetEmoji.firstOrNull;
    _showShimmer = (displayEmoji == null);
  }

  void _startShimmer() {
    if (!widget.controller.isLoading && _showShimmer) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() => _showShimmer = false);
          setState(() => _hasShimmered = true);
        }
      });
    }
  }

  @override
  didUpdateWidget(LemmaHighlightEmojiRow oldWidget) {
    //Reset shimmer state for diff constructs in 2 column mode
    if (oldWidget.cId != widget.cId) {
      setState(() {
        displayEmoji = widget.cId.userSetEmoji.firstOrNull;
        _showShimmer = (displayEmoji == null);
        _hasShimmered = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String transformTargetId(String emoji) =>
      "emoji-choice-item-$emoji-${widget.cId.lemma}";

  Future<void> setEmoji(String emoji, BuildContext context) async {
    try {
      final String? userSetEmoji = widget.cId.userSetEmoji.firstOrNull;
      setState(() => displayEmoji = emoji);
      await widget.cId.setEmojiWithXP(
        emoji: emoji,
        isFromCorrectAnswer: false,
      );
      if (userSetEmoji == null) {
        OverlayUtil.showOverlay(
          overlayKey: "${transformTargetId(emoji)}_points",
          followerAnchor: Alignment.bottomCenter,
          targetAnchor: Alignment.bottomCenter,
          context: context,
          child: PointsGainedAnimation(
            points: 2,
            targetID: transformTargetId(emoji),
          ),
          transformTargetId: transformTargetId(emoji),
          closePrevOverlay: false,
          backDropToDismiss: false,
          ignorePointer: true,
        );
      }
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
    _startShimmer();

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
                    onSelectEmoji: () => setEmoji(emoji, context),
                    isDisplay: (displayEmoji == emoji),
                    showShimmer: (_showShimmer && !_hasShimmered),
                    transformTargetId: transformTargetId(emoji),
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
  final bool showShimmer;
  final String transformTargetId;

  const EmojiChoiceItem({
    super.key,
    required this.emoji,
    required this.isDisplay,
    required this.onSelectEmoji,
    required this.showShimmer,
    required this.transformTargetId,
  });

  @override
  EmojiChoiceItemState createState() => EmojiChoiceItemState();
}

class EmojiChoiceItemState extends State<EmojiChoiceItem> {
  bool _isHovered = false;

  LayerLink get layerLink =>
      MatrixState.pAnyState.layerLinkAndKey(widget.transformTargetId).link;

  @override
  Widget build(BuildContext context) {
    final shimmerColor = (Theme.of(context).brightness == Brightness.dark)
        ? Colors.white
        : Theme.of(context).colorScheme.primary;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onSelectEmoji,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            children: [
              CompositedTransformTarget(
                link: layerLink,
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
              if (widget.showShimmer)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                    child: Shimmer.fromColors(
                      baseColor: shimmerColor.withValues(alpha: 0.1),
                      highlightColor: shimmerColor.withValues(alpha: 0.6),
                      direction: ShimmerDirection.ltr,
                      child: Container(
                        decoration: BoxDecoration(
                          color: shimmerColor.withValues(alpha: 0.3),
                          borderRadius:
                              BorderRadius.circular(AppConfig.borderRadius),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
