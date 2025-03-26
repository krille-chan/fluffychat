import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_form.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/match_feedback_model.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class MessageMatchActivityItem extends StatefulWidget {
  const MessageMatchActivityItem({
    super.key,
    required this.content,
    required this.constructForm,
    this.audioContent,
    required this.overlayController,
    required this.fixedSize,
  });

  final Widget content;
  final ConstructForm constructForm;
  final String? audioContent;
  final MessageOverlayController overlayController;
  final double? fixedSize;

  @override
  MessageMatchActivityItemState createState() =>
      MessageMatchActivityItemState();
}

class MessageMatchActivityItemState extends State<MessageMatchActivityItem> {
  bool _isHovered = false;
  bool _isPlaying = false;

  TtsController get tts =>
      widget.overlayController.widget.chatController.choreographer.tts;

  bool get isSelected =>
      widget.overlayController.selectedChoice == widget.constructForm;

  Future<void> play() async {
    if (widget.audioContent == null) {
      return;
    }

    if (_isPlaying) {
      await tts.stop();
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    } else {
      if (mounted) {
        setState(() => _isPlaying = true);
      }
      try {
        await tts.tryToSpeak(
          widget.audioContent!,
          context,
          targetID: 'word-audio-button',
        );
      } catch (e, s) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {"text": widget.audioContent},
        );
      } finally {
        if (mounted) {
          setState(() => _isPlaying = false);
        }
      }
    }
  }

  MatchFeedback? get choiceFeedback => widget.overlayController.feedbackStates
      .firstWhereOrNull((e) => e.form == widget.constructForm);

  Color color(BuildContext context) {
    final feedback = choiceFeedback;
    if (feedback != null) {
      return feedback.isCorrect ? AppConfig.success : AppConfig.warning;
    }

    if (isSelected) {
      return Theme.of(context).colorScheme.primaryContainer;
    }

    if (_isHovered) {
      return Theme.of(context).colorScheme.primaryContainer;
    }

    return Theme.of(context).colorScheme.surface;
  }

  @override
  didUpdateWidget(MessageMatchActivityItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.overlayController.selectedChoice !=
            widget.overlayController.selectedChoice ||
        oldWidget.overlayController.selectedToken !=
            widget.overlayController.selectedToken ||
        widget.overlayController.feedbackStates
                .any((e) => e.form == widget.constructForm) !=
            oldWidget.overlayController.feedbackStates
                .any((e) => e.form == widget.constructForm)) {
      setState(() {});
    }
  }

  IntrinsicWidth content(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: widget.fixedSize,
        width: widget.fixedSize,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color(context).withAlpha((0.4 * 255).toInt()),
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
          border: isSelected
              ? Border.all(
                  color: color(context),
                  width: 2,
                )
              : Border.all(
                  color: Colors.transparent,
                  width: 2,
                ),
        ),
        child: widget.content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<ConstructForm>(
      data: widget.constructForm,
      feedback: Material(
        type: MaterialType.transparency,
        child: content(context),
      ),
      delay: const Duration(milliseconds: 100),
      onDragStarted: () {
        widget.overlayController.onChoiceSelect(widget.constructForm, true);
      },
      child: InkWell(
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        onTap: () {
          play();
          widget.overlayController.onChoiceSelect(widget.constructForm);
        },
        child: content(context),
      ),
    );
  }
}
