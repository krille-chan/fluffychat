import 'dart:developer';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/constructs/construct_form.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/practice_activities/target_tokens_and_activity_type.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/utils/shrinkable_text.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  final TargetTokensAndActivityType? activity;

  const MessageTokenButton({
    super.key,
    required this.overlayController,
    required this.token,
    required this.textStyle,
    required this.width,
    required this.activity,
    this.animate = false,
  });

  @override
  MessageTokenButtonState createState() => MessageTokenButtonState();
}

class MessageTokenButtonState extends State<MessageTokenButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: AppConfig.overlayAnimationDuration,
        // seconds: 5,
      ),
    );

    _heightAnimation = Tween<double>(
      begin: 0,
      end: tokenButtonHeight,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

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
        oldWidget.activity != widget.activity) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get textSize =>
      widget.textStyle.fontSize ?? tokenButtonDefaultFontSize;

  double get emojiSize => textSize * estimatedEmojiWidthRatio;

  TextStyle get emojiStyle => widget.textStyle.copyWith(
        fontSize: textSize + 4,
      );

  TargetTokensAndActivityType? get activity => widget.activity;

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

  Widget get content {
    final tokenActivity = activity;
    if (tokenActivity == null) {
      if (MessageMode.wordEmoji == widget.overlayController?.toolbarMode) {
        return SizedBox(height: height, child: emojiView);
      }
      return SizedBox(height: height);
    }

    if (MessageMode.wordMorph == widget.overlayController?.toolbarMode) {
      if (activity?.morphFeature == null) {
        debugger(when: kDebugMode);
        return SizedBox(height: height);
      }
      return InkWell(
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        onTap: () => widget.overlayController!
            .onMorphActivitySelect(widget.token, activity!.morphFeature!),
        borderRadius: borderRadius,
        child: Container(
          height: height,
          width: min(widget.width, height),
          alignment: Alignment.center,
          child: Opacity(
            opacity: (widget.overlayController?.selectedToken == widget.token &&
                        widget.overlayController?.selectedMorph ==
                            activity?.morphFeature) ||
                    _isHovered
                ? 1.0
                : 0.5,
            child: Icon(
              Symbols.toys_and_games,
              color: Theme.of(context).colorScheme.primary,
            ),
            // MorphIcon(morphFeature: activity!.morphFeature!, morphTag: null),
          ),
        ),
      );
    }

    return DragTarget<ConstructForm>(
      builder: (BuildContext context, accepted, rejected) {
        final double colorAlpha = 0.3 +
            (widget.overlayController?.selectedChoice != null ? 0.3 : 0.0);

        return InkWell(
          onHover: (isHovered) => setState(() => _isHovered = isHovered),
          onTap: widget.overlayController?.selectedChoice != null
              ? () => widget.overlayController!.onMatchAttempt(
                    widget.token,
                    widget.overlayController!.selectedChoice!,
                  )
              : null,
          borderRadius: borderRadius,
          child: Container(
            height: height,
            padding: EdgeInsets.only(top: topPadding),
            width:
                MessageMode.wordMeaning == widget.overlayController?.toolbarMode
                    ? widget.width
                    : min(widget.width, height),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withAlpha((colorAlpha * 255).toInt()),
              borderRadius: borderRadius,
              border: accepted.isNotEmpty ||
                      (widget.overlayController?.selectedChoice != null &&
                          _isHovered)
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
          ),
        );
      },
      onAcceptWithDetails: (details) =>
          widget.overlayController!.onMatchAttempt(widget.token, details.data),
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
