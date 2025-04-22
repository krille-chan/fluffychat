import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/toolbar/controllers/tts_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

class WordTextWithAudioButton extends StatefulWidget {
  final String text;
  final String uniqueID;
  final TextStyle? style;
  final double? iconSize;

  const WordTextWithAudioButton({
    super.key,
    required this.text,
    required this.uniqueID,
    this.style,
    this.iconSize,
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

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: MatrixState.pAnyState
          .layerLinkAndKey('text-audio-button-${widget.uniqueID}')
          .link,
      child: MouseRegion(
        key: MatrixState.pAnyState
            .layerLinkAndKey('text-audio-button-${widget.uniqueID}')
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
                final l2 = MatrixState.pangeaController.languageController
                    .activeL2Code();
                if (l2 != null) {
                  await tts.tryToSpeak(
                    widget.text,
                    context,
                    targetID: 'text-audio-button-${widget.uniqueID}',
                    langCode: l2,
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.0,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: Text(
                  widget.text,
                  style: widget.style ?? Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              else
                Icon(
                  _isPlaying ? Icons.pause_outlined : Icons.volume_up,
                  color:
                      _isPlaying ? Theme.of(context).colorScheme.primary : null,
                  size: widget.iconSize,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
