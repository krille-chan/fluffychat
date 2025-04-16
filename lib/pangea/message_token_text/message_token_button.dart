import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/message_token_text/dotted_border_painter.dart';
import 'package:fluffychat/pangea/morphs/get_grammar_copy.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/practice_activities/practice_choice.dart';
import 'package:fluffychat/pangea/practice_activities/practice_target.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/morph_selection.dart';
import 'package:fluffychat/pangea/toolbar/utils/shrinkable_text.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

const double tokenButtonHeight = 40.0;
const double tokenButtonDefaultFontSize = 10;
const int maxEmojisPerLemma = 1;
const double estimatedEmojiWidthRatio = 2;
const double estimatedEmojiHeightRatio = 1.3;

class MessageTokenButton extends StatefulWidget {
  final MessageOverlayController? overlayController;
  final PangeaToken token;
  final TextStyle textStyle;
  final double width;
  final bool animate;
  final PracticeTarget? practiceTarget;

  const MessageTokenButton({
    super.key,
    required this.overlayController,
    required this.token,
    required this.textStyle,
    required this.width,
    required this.practiceTarget,
    this.animate = false,
  });

  @override
  MessageTokenButtonState createState() => MessageTokenButtonState();
}

class MessageTokenButtonState extends State<MessageTokenButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  // New controller and animation for icon size
  late AnimationController _iconSizeController;
  late Animation<double> _iconSizeAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: AppConfig.overlayAnimationDuration,
      ),
    );

    _heightAnimation = Tween<double>(
      begin: 0,
      end: tokenButtonHeight,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Initialize the new icon size controller and animation
    _iconSizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _iconSizeAnimation = Tween<double>(
      begin: 24, // Default icon size
      end: 30, // Enlarged icon size
    ).animate(
      CurvedAnimation(parent: _iconSizeController, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _controller.forward();
    }
  }

  double get topPadding => 10.0;

  double get height =>
      widget.animate ? _heightAnimation.value : tokenButtonHeight;

  @override
  void didUpdateWidget(covariant MessageTokenButton oldWidget) {
    if (oldWidget.overlayController?.toolbarMode !=
            widget.overlayController?.toolbarMode ||
        oldWidget.overlayController?.selectedToken !=
            widget.overlayController?.selectedToken ||
        oldWidget.overlayController?.selectedMorph !=
            widget.overlayController?.selectedMorph ||
        widget.token.vocabConstructID.constructUses.points !=
            widget.token.vocabConstructID.constructUses.points) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    _iconSizeController.dispose(); // Dispose the new controller
    super.dispose();
  }

  double get textSize =>
      widget.textStyle.fontSize ?? tokenButtonDefaultFontSize;

  double get emojiSize => textSize * estimatedEmojiWidthRatio;

  TextStyle get emojiStyle => widget.textStyle.copyWith(
        fontSize: textSize + 4,
      );

  PracticeTarget? get activity => widget.practiceTarget;

  onMatch(PracticeChoice form) {
    if (widget.overlayController?.activity == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "should not be in onAcceptWithDetails with null activity",
        data: {"details": form},
      );
      return;
    }
    widget.overlayController!.selectedChoice = null;
    widget.overlayController!.setState(() {});

    widget.overlayController!.activity!.onMatch(
      widget.token,
      form,
      widget.overlayController!.pangeaMessageEvent,
      () => widget.overlayController!.setState(() {}),
    );
  }

  Widget get emojiView {
    // if (widget.token.text.content.length == 1 || maxEmojisPerLemma == 1) {
    return ShrinkableText(
      text: widget.token.vocabConstructID.userSetEmoji.firstOrNull ?? '',
      maxWidth: widget.width,
      style: emojiStyle,
    );
    // }
    // return Stack(
    //   alignment: Alignment.center,
    //   children: widget.token.vocabConstructID.userSetEmoji
    //       .take(maxEmojisPerLemma)
    //       .mapIndexed(
    //         (index, emoji) => Positioned(
    //           left: min(
    //             index /
    //                 widget.token.vocabConstructID.userSetEmoji.length *
    //                 totalAvailableWidth,
    //             index * emojiSize,
    //           ),
    //           child: Text(
    //             emoji,
    //             style: emojiStyle,
    //           ),
    //         ),
    //       )
    //       .toList()
    //       .reversed
    //       .toList(),
    // );
  }

  bool get isActivityCompleteForToken =>
      activity?.isCompleteByToken(
        widget.token,
        activity!.morphFeature,
      ) ==
      true;

  Color get color {
    if (activity == null) {
      return Theme.of(context).colorScheme.primary;
    }
    if (isActivityCompleteForToken) {
      return AppConfig.gold;
    }
    return Theme.of(context).colorScheme.primary;
  }

  Widget get content {
    final tokenActivity = activity;
    if (tokenActivity == null || isActivityCompleteForToken) {
      if (MessageMode.wordEmoji == widget.overlayController?.toolbarMode) {
        return SizedBox(height: height, child: emojiView);
      }
      if (MessageMode.wordMorph == widget.overlayController?.toolbarMode &&
          activity?.morphFeature != null) {
        final morphFeature = activity!.morphFeature!;
        final morphTag = widget.token.morphIdByFeature(morphFeature);
        if (morphTag != null) {
          return Tooltip(
            message: getGrammarCopy(
              category: morphFeature.toShortString(),
              lemma: morphTag.lemma,
              context: context,
            ),
            child: SizedBox(
              width: widget.width,
              height: height,
              child: Center(
                child: MorphIcon(
                  morphFeature: morphFeature,
                  morphTag: morphTag.lemma,
                  size: const Size(24.0, 24.0),
                ),
              ),
            ),
          );
        }
      }
      return SizedBox(height: height);
    }

    if (MessageMode.wordMorph == widget.overlayController?.toolbarMode) {
      if (activity?.morphFeature == null) {
        return SizedBox(height: height);
      }

      final bool isSelected =
          (widget.overlayController?.selectedMorph?.token == widget.token &&
                  widget.overlayController?.selectedMorph?.morph ==
                      activity?.morphFeature) ||
              _isHovered;

      // Trigger the icon size animation based on hover or selection
      if (isSelected) {
        _iconSizeController.forward();
      } else {
        _iconSizeController.reverse();
      }

      return InkWell(
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        onTap: () => widget.overlayController!.onMorphActivitySelect(
          MorphSelection(widget.token, activity!.morphFeature!),
        ),
        borderRadius: borderRadius,
        child: Container(
          height: height,
          width: min(widget.width, height),
          alignment: Alignment.center,
          child: Opacity(
            opacity: isSelected ? 1.0 : 0.4,
            child: AnimatedBuilder(
              animation: _iconSizeAnimation,
              builder: (context, child) {
                return Icon(
                  Symbols.toys_and_games,
                  color: color,
                  size: _iconSizeAnimation.value, // Use the new animation
                );
              },
            ),
          ),
        ),
      );
    }

    return DragTarget<PracticeChoice>(
      builder: (BuildContext context, accepted, rejected) {
        final double colorAlpha = 0.3 +
            (widget.overlayController?.selectedChoice != null ? 0.4 : 0.0) +
            (accepted.isNotEmpty || _isHovered ? 0.3 : 0.0);

        return InkWell(
          onHover: (isHovered) => setState(() => _isHovered = isHovered),
          onTap: widget.overlayController?.selectedChoice != null
              ? () => onMatch(widget.overlayController!.selectedChoice!)
              : null,
          borderRadius: borderRadius,
          child: CustomPaint(
            painter: DottedBorderPainter(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withAlpha((colorAlpha * 255).toInt()),
              borderRadius: borderRadius,
            ),
            child: Container(
              height: height,
              padding: EdgeInsets.only(top: topPadding),
              width: MessageMode.wordMeaning ==
                      widget.overlayController?.toolbarMode
                  ? widget.width
                  : min(widget.width, height),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha((max(0, colorAlpha - 0.7) * 255).toInt()),
                borderRadius: borderRadius,
              ),
            ),
          ),
        );
      },
      onAcceptWithDetails: (details) => onMatch(details.data),
    );
  }

  static final borderRadius = BorderRadius.circular(AppConfig.borderRadius - 4);

  @override
  Widget build(BuildContext context) {
    if (widget.overlayController == null) {
      return const SizedBox.shrink();
    }

    if (!widget.animate) {
      return content;
    }

    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) => content,
    );
  }
}
