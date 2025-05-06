import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordAudioButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final double baseOpacity;
  final String uniqueID;
  final String? langCode;
  final EdgeInsets? padding;

  /// If defined, this callback will be called instead of the default one
  final void Function()? callbackOverride;

  const WordAudioButton({
    super.key,
    required this.text,
    required this.uniqueID,
    this.isSelected = false,
    this.baseOpacity = 1,
    this.callbackOverride,
    this.langCode,
    this.padding,
  });

  @override
  WordAudioButtonState createState() => WordAudioButtonState();
}

class WordAudioButtonState extends State<WordAudioButton> {
  final TtsController tts = TtsController();
  bool _isPlaying = false;

  @override
  void didUpdateWidget(covariant WordAudioButton oldWidget) {
    if (oldWidget.isSelected != widget.isSelected ||
        oldWidget.callbackOverride != widget.callbackOverride) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: MatrixState.pAnyState
          .layerLinkAndKey('word-audio-button-${widget.uniqueID}')
          .link,
      child: Opacity(
        key: MatrixState.pAnyState
            .layerLinkAndKey('word-audio-button-${widget.uniqueID}')
            .key,
        opacity: widget.isSelected || _isPlaying ? 1 : widget.baseOpacity,
        child: Tooltip(
          message:
              _isPlaying ? L10n.of(context).stop : L10n.of(context).playAudio,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: widget.callbackOverride ??
                  () async {
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
                        if (widget.langCode != null) {
                          await tts.tryToSpeak(
                            widget.text,
                            context: context,
                            targetID: 'word-audio-button-${widget.uniqueID}',
                            langCode: widget.langCode!,
                          );
                        }
                      } catch (e, s) {
                        ErrorHandler.logError(
                          e: e,
                          s: s,
                          data: {
                            "text": widget.text,
                          },
                        );
                      } finally {
                        if (mounted) {
                          setState(() => _isPlaying = false);
                        }
                      }
                    }
                  },
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(0.0),
                child: Icon(
                  _isPlaying ? Icons.pause_outlined : Icons.volume_up,
                  color:
                      _isPlaying ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
