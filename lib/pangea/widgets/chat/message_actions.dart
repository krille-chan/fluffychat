import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/choreographer/widgets/language_display_toggle.dart';
import 'package:fluffychat/pangea/widgets/chat/text_to_speech_button.dart';
import 'package:flutter/material.dart';

class PangeaMessageActions extends StatelessWidget {
  final ChatController chatController;

  const PangeaMessageActions({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    return chatController.selectedEvents.length == 1
        ? Row(
            children: <Widget>[
              LanguageToggleSwitch(controller: chatController),
              TextToSpeechButton(
                controller: chatController,
                selectedEvent: chatController.selectedEvents.first,
              ),
              // IconButton(
              //   icon: Icon(Icons.mic),
              //   onPressed: chatController.onMicTap,
              // ),
              // Add more IconButton widgets here
            ],
          )
        : const SizedBox();
  }
}
