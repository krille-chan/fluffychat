import 'dart:developer';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:just_audio/just_audio.dart';
import 'package:matrix/matrix.dart';

class TextToSpeechButton extends StatefulWidget {
  final ChatController controller;

  const TextToSpeechButton({
    super.key,
    required this.controller,
  });

  @override
  _TextToSpeechButtonState createState() => _TextToSpeechButtonState();
}

class _TextToSpeechButtonState extends State<TextToSpeechButton> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSpeech() {
    try {
      final String langCode = widget.controller.choreographer.messageOptions
              .selectedDisplayLang?.langCode ??
          widget.controller.choreographer.l2LangCode ??
          'en';
      final Event event = widget.controller.selectedEvents.first;

      PangeaMessageEvent(
        event: event,
        timeline: widget.controller.timeline!,
        ownMessage: event.senderId == Matrix.of(context).client.userID,
        selected: true,
      ).getAudioGlobal(langCode);

      // final String? text = PangeaMessageEvent(
      //   event: event,
      //   timeline: widget.controller.timeline!,
      //   ownMessage: event.senderId == Matrix.of(context).client.userID,
      //   selected: true,
      // ).representationByLanguage(langCode)?.text;

      // if (text == null || text.isEmpty) {
      //   throw Exception("text is null or empty in text_to_speech_button.dart");
      // }

      // final TextToSpeechRequest params = TextToSpeechRequest(
      //   text: text,
      //   langCode: widget.controller.choreographer.messageOptions
      //           .selectedDisplayLang?.langCode ??
      //       widget.controller.choreographer.l2LangCode ??
      //       LanguageKeys.unknownLanguage,
      // );

      // final TextToSpeechResponse response = await TextToSpeechService.get(
      //   accessToken:
      //       await MatrixState.pangeaController.userController.accessToken,
      //   params: params,
      // );

      // if (response.mediaType != 'audio/ogg') {
      //   throw Exception('Unexpected media type: ${response.mediaType}');
      // }

      // // Decode the base64 audio content to bytes
      // final audioBytes = base64.decode(response.audioContent);

      // final encoding = Uri.dataFromBytes(audioBytes);
      // final uri = AudioSource.uri(encoding);
      // // gets here without problems

      // await _audioPlayer.setAudioSource(uri);
      // await _audioPlayer.play();

      // final audioBytes = base64.decode(response.audioContent);
      // final tempDir = await getTemporaryDirectory();
      // final file = File('${tempDir.path}/speech.ogg');
      // await file.writeAsBytes(audioBytes);

      // await _audioPlayer.setFilePath(file.path);

      // await _audioPlayer.play();
    } catch (e) {
      debugger(when: kDebugMode);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            L10n.of(context)!.errorGettingAudio,
          ),
        ),
      );
      ErrorHandler.logError(
        e: Exception(),
        s: StackTrace.current,
        m: 'text is null or empty in text_to_speech_button.dart',
        data: {
          'event': widget.controller.selectedEvents.first,
          'langCode': widget.controller.choreographer.messageOptions
                  .selectedDisplayLang?.langCode ??
              widget.controller.choreographer.l2LangCode ??
              LanguageKeys.unknownLanguage,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _playSpeech,
      child: const Text('Convert to Speech'),
    );
  }
}
