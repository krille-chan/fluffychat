import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordTextWithAudioButton extends StatefulWidget {
  final String text;
  final double? textSize;

  const WordTextWithAudioButton({
    super.key,
    required this.text,
    this.textSize,
  });

  @override
  WordAudioButtonState createState() => WordAudioButtonState();
}

class WordAudioButtonState extends State<WordTextWithAudioButton> {
  // initialize as null because we don't know if we need to load
  // audio from choreo yet. This shall remain null if user device support
  // text to speech
  final bool? _isLoadingAudio = null;
  final TtsController tts = TtsController();

  bool _isPlaying = false;
  bool _isLoading = false;
  StreamSubscription? _loadingChoreoSubscription;

  @override
  void initState() {
    super.initState();
    _loadingChoreoSubscription = tts.loadingChoreoStream.stream.listen((val) {
      if (mounted) setState(() => _isLoading = val);
    });
  }

  @override
  void dispose() {
    _loadingChoreoSubscription?.cancel();
    tts.dispose();
    super.dispose();
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
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          fontSize: textSize,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                if (_isLoading)
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
                    _isPlaying ? Icons.volume_up : Icons.pause_outlined,
                    size: textSize,
                    color: _isPlaying
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
