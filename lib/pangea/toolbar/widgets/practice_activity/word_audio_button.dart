import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordAudioButton extends StatefulWidget {
  final String text;
  final double size;
  final bool isSelected;
  final double baseOpacity;

  /// If defined, this callback will be called instead of the default one
  final void Function()? callbackOverride;

  const WordAudioButton({
    super.key,
    required this.text,
    this.size = 24,
    this.isSelected = false,
    this.baseOpacity = 1,
    this.callbackOverride,
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
          .layerLinkAndKey('word-audio-butto${widget.text}')
          .link,
      child: Opacity(
        opacity: !widget.isSelected ? widget.baseOpacity : 1,
        child: IconButton(
          key: MatrixState.pAnyState
              .layerLinkAndKey('word-audio-butto${widget.text}')
              .key,
          icon: const Icon(Icons.volume_up),
          isSelected: _isPlaying,
          selectedIcon: const Icon(Icons.pause_outlined),
          color:
              widget.isSelected ? Theme.of(context).colorScheme.primary : null,
          tooltip:
              _isPlaying ? L10n.of(context).stop : L10n.of(context).playAudio,
          iconSize: widget.size,
          onPressed: widget.callbackOverride ??
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
                    await tts.tryToSpeak(
                      widget.text,
                      context,
                      targetID: 'word-audio-button',
                    );
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
              }, // Disable button if language isn't supported
        ),
      ),
    );
  }
}
