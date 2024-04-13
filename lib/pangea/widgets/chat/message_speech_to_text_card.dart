import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class MessageSpeechToTextCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;

  const MessageSpeechToTextCard({
    super.key,
    required this.messageEvent,
  });

  @override
  MessageSpeechToTextCardState createState() => MessageSpeechToTextCardState();
}

class MessageSpeechToTextCardState extends State<MessageSpeechToTextCard> {
  SpeechToTextResponseModel? speechToTextResponse;
  bool _fetchingTranscription = true;
  Object? error;

  String? get l1Code =>
      MatrixState.pangeaController.languageController.activeL1Code(
        roomID: widget.messageEvent.room.id,
      );
  String? get l2Code =>
      MatrixState.pangeaController.languageController.activeL2Code(
        roomID: widget.messageEvent.room.id,
      );

  String? get transcription => speechToTextResponse
      ?.results.firstOrNull?.transcripts.firstOrNull?.transcript;

  // look for transcription in message event
  // if not found, call API to transcribe audio
  Future<void> getSpeechToText() async {
    try {
      if (l1Code == null || l2Code == null) {
        throw Exception('Language selection not found');
      }
      speechToTextResponse ??=
          await widget.messageEvent.getSpeechToTextGlobal(l1Code!, l2Code!);
    } catch (e, s) {
      error = e;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: widget.messageEvent.event.content,
      );
    } finally {
      setState(() => _fetchingTranscription = false);
    }
  }

  @override
  void initState() {
    super.initState();
    getSpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    if (!_fetchingTranscription && speechToTextResponse == null) {
      return CardErrorWidget(error: error);
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: _fetchingTranscription
          ? SizedBox(
              height: 14,
              width: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : Text(
              transcription!,
              style: BotStyle.text(context),
            ),
    );
  }
}
