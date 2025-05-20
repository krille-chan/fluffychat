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
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

const double tokenButtonHeight = 40.0;
const double tokenButtonDefaultFontSize = 10;
const int maxEmojisPerLemma = 1;
const double estimatedEmojiWidthRatio = 2;

class MessageTokenButton extends StatefulWidget {
  final MessageOverlayController? overlayController;
  final PangeaToken token;
  final TextStyle textStyle;
  final double width;
  final bool animateIn;
  final PracticeTarget? practiceTargetForToken;

  const MessageTokenButton({
    super.key,
    required this.overlayController,
    required this.token,
    required this.textStyle,
    required this.width,
    required this.practiceTargetForToken,
    this.animateIn = false,
  });

  @override
  MessageTokenButtonState createState() => MessageTokenButtonState();
}

class MessageTokenButtonState extends State<MessageTokenButton>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _heightAnimation;

  // New controller and animation for icon size
  AnimationController? _iconSizeController;
  Animation<double>? _iconSizeAnimation;

  bool _isHovered = false;
  bool _isSelected = false;
  bool _finishedInitialAnimation = false;
  bool _wasEmpty = false;

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
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeOut));

    // Initialize the new icon size controller and animation
    _iconSizeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _iconSizeAnimation = Tween<double>(
      begin: 24, // Default icon size
      end: 30, // Enlarged icon size
    ).animate(
      CurvedAnimation(parent: _iconSizeController!, curve: Curves.easeInOut),
    );

    _setSelected(); // Call _setSelected after initializing _iconSizeController

    _wasEmpty = _isEmpty;

    if (!_isEmpty) {
      _controller?.forward().then((_) {
        if (mounted) setState(() => _finishedInitialAnimation = true);
      });
    } else {
      setState(() => _finishedInitialAnimation = true);
    }
  }

  @override
  void didUpdateWidget(covariant MessageTokenButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setSelected();
    if (_isEmpty != _wasEmpty) {
      if (_isEmpty && _animate) {
        _controller?.reverse();
      } else if (!_isEmpty && _animate) {
        _controller?.forward();
      }
      setState(() => _wasEmpty = _isEmpty);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _iconSizeController?.dispose(); // Dispose the new controller
    super.dispose();
  }

  bool get _animate => widget.animateIn || _finishedInitialAnimation;

  PracticeTarget? get _activity => widget.practiceTargetForToken;

  bool get _isActivityCompleteOrNullForToken =>
      _activity?.isCompleteByToken(
        widget.token,
        _activity!.morphFeature,
      ) ==
      true;

  void _setSelected() {
    final selected =
        widget.overlayController?.selectedMorph?.token == widget.token &&
            widget.overlayController?.selectedMorph?.morph ==
                _activity?.morphFeature;

    if (selected != _isSelected) {
      setState(() {
        _isSelected = selected;
      });

      _isSelected
          ? _iconSizeController?.forward()
          : _iconSizeController?.reverse();
    }
  }

  void _setHovered(bool isHovered) {
    if (isHovered != _isHovered) {
      setState(() {
        _isHovered = isHovered;
      });

      if (!_isHovered && _isSelected) {
        return;
      }

      _isHovered
          ? _iconSizeController?.forward()
          : _iconSizeController?.reverse();
    }
  }

  void _onMatch(PracticeChoice form) {
    if (widget.overlayController?.activity == null) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "should not be in onAcceptWithDetails with null activity",
        data: {"details": form},
      );
      return;
    }
    widget.overlayController!.onChoiceSelect(null);
    widget.overlayController!.activity!.onMatch(
      widget.token,
      form,
      widget.overlayController!.pangeaMessageEvent,
      () => widget.overlayController!.setState(() {}),
    );
  }

  bool get _isEmpty {
    final mode = widget.overlayController?.toolbarMode;
    if (MessageMode.wordEmoji == mode &&
        widget.token.vocabConstructID.userSetEmoji.firstOrNull != null) {
      return false;
    }

    return _activity == null ||
        (_isActivityCompleteOrNullForToken &&
            ![MessageMode.wordEmoji, MessageMode.wordMorph].contains(mode)) ||
        (MessageMode.wordMorph == mode && _activity?.morphFeature == null);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.overlayController == null) {
      return const SizedBox.shrink();
    }

    if (!_animate && _iconSizeAnimation != null) {
      return MessageTokenButtonContent(
        activity: _activity,
        messageMode: widget.overlayController!.toolbarMode,
        token: widget.token,
        selectedChoice: widget.overlayController?.selectedChoice,
        isActivityCompleteOrNullForToken: _isActivityCompleteOrNullForToken,
        isSelected: _isSelected,
        height: tokenButtonHeight,
        width: widget.width,
        textStyle: widget.textStyle,
        sizeAnimation: _iconSizeAnimation!,
        onHover: _setHovered,
        onTap: () => widget.overlayController!.onMorphActivitySelect(
          MorphSelection(widget.token, _activity!.morphFeature!),
        ),
        onMatch: _onMatch,
      );
    }

    if (_heightAnimation != null && _iconSizeAnimation != null) {
      return AnimatedBuilder(
        animation: _heightAnimation!,
        builder: (context, child) {
          return MessageTokenButtonContent(
            activity: _activity,
            messageMode: widget.overlayController!.toolbarMode,
            token: widget.token,
            selectedChoice: widget.overlayController?.selectedChoice,
            isActivityCompleteOrNullForToken: _isActivityCompleteOrNullForToken,
            isSelected: _isSelected,
            height: _heightAnimation!.value,
            width: widget.width,
            textStyle: widget.textStyle,
            sizeAnimation: _iconSizeAnimation!,
            onHover: _setHovered,
            onTap: () => widget.overlayController!.onMorphActivitySelect(
              MorphSelection(widget.token, _activity!.morphFeature!),
            ),
            onMatch: _onMatch,
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}

class MessageTokenButtonContent extends StatelessWidget {
  final PracticeTarget? activity;
  final MessageMode messageMode;
  final PangeaToken token;
  final PracticeChoice? selectedChoice;

  final bool isActivityCompleteOrNullForToken;
  final bool isSelected;
  final double height;
  final double width;
  final TextStyle textStyle;
  final Animation<double> sizeAnimation;

  final Function(bool)? onHover;
  final Function()? onTap;
  final Function(PracticeChoice)? onMatch;

  const MessageTokenButtonContent({
    super.key,
    required this.activity,
    required this.messageMode,
    required this.token,
    required this.selectedChoice,
    required this.isActivityCompleteOrNullForToken,
    required this.isSelected,
    required this.height,
    required this.width,
    required this.textStyle,
    required this.sizeAnimation,
    this.onHover,
    this.onTap,
    this.onMatch,
  });

  TextStyle get _emojiStyle => textStyle.copyWith(
        fontSize: (textStyle.fontSize ?? tokenButtonDefaultFontSize) + 4,
      );

  static final _borderRadius =
      BorderRadius.circular(AppConfig.borderRadius - 4);

  Color _color(BuildContext context) {
    if (activity == null) {
      return Theme.of(context).colorScheme.primary;
    }
    if (isActivityCompleteOrNullForToken) {
      return AppConfig.gold;
    }
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    if (isActivityCompleteOrNullForToken || activity == null) {
      if (MessageMode.wordEmoji == messageMode) {
        return SizedBox(
          height: height,
          child: Text(
            token.vocabConstructID.userSetEmoji.firstOrNull ?? '',
            style: _emojiStyle,
          ),
        );
      }
      if (MessageMode.wordMorph == messageMode && activity != null) {
        final morphFeature = activity!.morphFeature!;
        final morphTag = token.morphIdByFeature(morphFeature);
        if (morphTag != null) {
          return Tooltip(
            message: getGrammarCopy(
              category: morphFeature.toShortString(),
              lemma: morphTag.lemma,
              context: context,
            ),
            child: SizedBox(
              width: 24.0,
              child: Center(
                child: MorphIcon(
                  morphFeature: morphFeature,
                  morphTag: morphTag.lemma,
                ),
              ),
            ),
          );
        }
      } else {
        return SizedBox(height: height);
      }
    }

    if (MessageMode.wordMorph == messageMode) {
      if (activity?.morphFeature == null) {
        return SizedBox(height: height);
      }

      return InkWell(
        onHover: onHover,
        onTap: onTap,
        borderRadius: _borderRadius,
        child: SizedBox(
          height: height,
          child: Opacity(
            opacity: isSelected ? 1.0 : 0.4,
            child: AnimatedBuilder(
              animation: sizeAnimation,
              builder: (context, child) {
                return Icon(
                  Symbols.toys_and_games,
                  color: _color(context),
                  size: sizeAnimation.value, // Use the new animation
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
            (selectedChoice != null ? 0.4 : 0.0) +
            (accepted.isNotEmpty ? 0.3 : 0.0);

        return InkWell(
          onTap: selectedChoice != null
              ? () => onMatch?.call(selectedChoice!)
              : null,
          borderRadius: _borderRadius,
          child: CustomPaint(
            painter: DottedBorderPainter(
              color: Theme.of(context)
                  .colorScheme
                  .primary
                  .withAlpha((colorAlpha * 255).toInt()),
              borderRadius: _borderRadius,
            ),
            child: Container(
              height: height,
              padding: const EdgeInsets.only(top: 10.0),
              width: max(width, 24.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withAlpha((max(0, colorAlpha - 0.7) * 255).toInt()),
                borderRadius: _borderRadius,
              ),
            ),
          ),
        );
      },
      onAcceptWithDetails: (details) => onMatch?.call(details.data),
    );
  }
}
