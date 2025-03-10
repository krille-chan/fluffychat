import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordTextWithAudioButton extends StatefulWidget {
  final String text;
  final TtsController ttsController;
  final double? textSize;

  const WordTextWithAudioButton({
    super.key,
    required this.text,
    required this.ttsController,
    this.textSize,
  });

  @override
  WordAudioButtonState createState() => WordAudioButtonState();
}

class WordAudioButtonState extends State<WordTextWithAudioButton> {
  bool _isPlaying = false;
  // initialize as null because we don't know if we need to load
  // audio from choreo yet. This shall remain null if user device support
  // text to speech
  final bool? _isLoadingAudio = null;

  @override
  void initState() {
    super.initState();
    widget.ttsController.addListener(_onTtsControllerChange);
  }

  @override
  void dispose() {
    widget.ttsController.removeListener(_onTtsControllerChange);
    super.dispose();
  }

  void _onTtsControllerChange() {
    setState(() {});
  }

  double get textSize =>
      widget.textSize ?? Theme.of(context).textTheme.titleLarge?.fontSize ?? 16;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: MatrixState.pAnyState
          .layerLinkAndKey('text-audio-button ${widget.text}')
          .link,
      child: MouseRegion(
        key: MatrixState.pAnyState
            .layerLinkAndKey('text-audio-button ${widget.text}')
            .key,
        cursor: SystemMouseCursors.click,
        onEnter: (event) => setState(() {}),
        onExit: (event) => setState(() {}),
        child: GestureDetector(
          onTap: () async {
            if (_isLoadingAudio == true) {
              return;
            }
            if (_isPlaying) {
              await widget.ttsController.stop();
              if (mounted) {
                setState(() => _isPlaying = false);
              }
            } else {
              if (mounted) {
                setState(() => _isPlaying = true);
              }
              try {
                await widget.ttsController.tryToSpeak(
                  widget.text,
                  context,
                  targetID: 'text-audio-button',
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
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Text(
                    widget.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _isPlaying
                              ? Theme.of(context).colorScheme.secondary
                              : null,
                          fontSize: textSize,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                if (widget.ttsController.hasLoadedTextToSpeech == false)
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 4,
                    ), // Adds 20 pixels of left padding
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                  )
                else
                  Icon(
                    _isPlaying ? Icons.play_arrow : Icons.play_arrow_outlined,
                    size: textSize,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
