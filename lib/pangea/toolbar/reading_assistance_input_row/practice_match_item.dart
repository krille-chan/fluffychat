import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_choice.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PracticeMatchItem extends StatefulWidget {
  const PracticeMatchItem({
    super.key,
    required this.content,
    required this.token,
    required this.constructForm,
    required this.isCorrect,
    required this.isSelected,
    this.audioContent,
    required this.overlayController,
  });

  final Widget content;
  final PangeaToken? token;
  final PracticeChoice constructForm;
  final String? audioContent;
  final MessageOverlayController overlayController;
  final bool? isCorrect;
  final bool isSelected;

  @override
  PracticeMatchItemState createState() => PracticeMatchItemState();
}

class PracticeMatchItemState extends State<PracticeMatchItem> {
  bool _isHovered = false;
  bool _isPlaying = false;

  bool get isSelected => widget.isSelected;

  bool? get isCorrect => widget.isCorrect;

  Future<void> play() async {
    if (widget.audioContent == null) {
      return;
    }

    if (_isPlaying) {
      await TtsController.stop();
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    } else {
      if (mounted) {
        setState(() => _isPlaying = true);
      }
      try {
        final l2 =
            MatrixState.pangeaController.languageController.activeL2Code();
        if (l2 != null) {
          await TtsController.tryToSpeak(
            widget.audioContent!,
            context: context,
            targetID: 'word-audio-button',
            langCode: l2,
          );
        }
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

  void onTap() {
    play();
    isCorrect == null || !isCorrect! || widget.token == null
        ? widget.overlayController.onChoiceSelect(widget.constructForm)
        : widget.overlayController.updateSelectedSpan(widget.token!.text);
  }

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color(context).withAlpha((0.4 * 255).toInt()),
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
              border: isSelected
                  ? Border.all(
                      color: color(context).withAlpha(255),
                      width: 2,
                    )
                  : Border.all(
                      color: Colors.transparent,
                      width: 2,
                    ),
            ),
            child: widget.content,
          ),
        ),
      ],
    );

    return LongPressDraggable<PracticeChoice>(
      data: widget.constructForm,
      feedback: Material(
        type: MaterialType.transparency,
        child: content,
      ),
      delay: const Duration(milliseconds: 50),
      onDragStarted: onTap,
      child: InkWell(
        onHover: (isHovered) => setState(() => _isHovered = isHovered),
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        onTap: onTap,
        child: content,
      ),
    );
  }
}
