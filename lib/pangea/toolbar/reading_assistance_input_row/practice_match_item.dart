import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/practice_activities/practice_choice.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class PracticeMatchItem extends StatefulWidget {
  const PracticeMatchItem({
    super.key,
    required this.content,
    required this.constructForm,
    required this.isCorrect,
    required this.isSelected,
    this.audioContent,
    required this.overlayController,
    required this.fixedSize,
  });

  final Widget content;
  final PracticeChoice constructForm;
  final String? audioContent;
  final MessageOverlayController overlayController;
  final double? fixedSize;
  final bool? isCorrect;
  final bool isSelected;

  @override
  PracticeMatchItemState createState() => PracticeMatchItemState();
}

class PracticeMatchItemState extends State<PracticeMatchItem> {
  bool _isHovered = false;
  bool _isPlaying = false;

  TtsController get tts =>
      widget.overlayController.widget.chatController.choreographer.tts;

  bool get isSelected => widget.isSelected;

  bool? get isCorrect => widget.isCorrect;

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

  Color color(BuildContext context) {
    if (isCorrect != null) {
      return isCorrect! ? AppConfig.success : AppConfig.warning;
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
  didUpdateWidget(PracticeMatchItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected ||
        oldWidget.isCorrect != widget.isCorrect) {
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

  void onTap() {
    play();
    widget.overlayController.onChoiceSelect(widget.constructForm);
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<PracticeChoice>(
      data: widget.constructForm,
      feedback: Material(
        type: MaterialType.transparency,
        child: content(context),
      ),
      delay: const Duration(milliseconds: 50),
      onDragStarted: () {
        widget.overlayController.onChoiceSelect(widget.constructForm, true);
      },
      child: InkWell(
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        onTap: onTap,
        child: content(context),
      ),
    );
  }
}
