import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/tts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class WordAudioButton extends StatefulWidget {
  final String text;
  final TtsController ttsController;
  final String eventID;

  const WordAudioButton({
    super.key,
    required this.text,
    required this.ttsController,
    required this.eventID,
  });

  @override
  WordAudioButtonState createState() => WordAudioButtonState();
}

class WordAudioButtonState extends State<WordAudioButton> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.play_arrow_outlined),
      isSelected: _isPlaying,
      selectedIcon: const Icon(Icons.pause_outlined),
      color: _isPlaying ? Colors.white : null,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          _isPlaying
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      tooltip: _isPlaying ? L10n.of(context).stop : L10n.of(context).playAudio,
      onPressed: () async {
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
              widget.eventID,
            );
          } catch (e, s) {
            ErrorHandler.logError(
              e: e,
              s: s,
              data: {
                "text": widget.text,
                "eventID": widget.eventID,
              },
            );
          } finally {
            if (mounted) {
              setState(() => _isPlaying = false);
            }
          }
        }
      }, // Disable button if language isn't supported
    );
  }
}
