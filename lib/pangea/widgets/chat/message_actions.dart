import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/choreographer/widgets/language_display_toggle.dart';
import 'package:fluffychat/pangea/widgets/chat/text_to_speech_button.dart';
import 'package:flutter/material.dart';

class PangeaMessageActions extends StatelessWidget {
  final ChatController chatController;

  const PangeaMessageActions({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        LanguageToggleSwitch(controller: chatController),
        TextToSpeechButton(
          controller: chatController,
        ),
        // IconButton(
        //   icon: Icon(Icons.mic),
        //   onPressed: chatController.onMicTap,
        // ),
        // Add more IconButton widgets here
      ],
    );
  }
}
