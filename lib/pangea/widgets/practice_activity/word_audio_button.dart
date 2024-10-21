import 'package:fluffychat/pangea/widgets/chat/tts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class WordAudioButton extends StatefulWidget {
  final String text;

  const WordAudioButton({
    super.key,
    required this.text,
  });

  @override
  WordAudioButtonState createState() => WordAudioButtonState();
}

class WordAudioButtonState extends State<WordAudioButton> {
  bool _isPlaying = false;

  TtsController ttsController = TtsController();

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ttsController.setupTTS().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
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
          tooltip:
              _isPlaying ? L10n.of(context)!.stop : L10n.of(context)!.playAudio,
          onPressed: () async {
            if (_isPlaying) {
              await ttsController.tts.stop();
              setState(() {
                _isPlaying = false;
              });
            } else {
              setState(() {
                _isPlaying = true;
              });
              await ttsController.speak(widget.text);
              setState(() {
                _isPlaying = false;
              });
            }
          }, // Disable button if language isn't supported
        ),
        ttsController.missingVoiceButton,
      ],
    );
  }
}
