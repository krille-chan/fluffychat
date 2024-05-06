import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/speech_to_text_score.dart';
import 'package:fluffychat/pangea/widgets/chat/speech_to_text_text.dart';
import 'package:fluffychat/pangea/widgets/chat/toolbar_content_loading_indicator.dart';
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
  SpeechToTextModel? speechToTextResponse;
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

  // look for transcription in message event
  // if not found, call API to transcribe audio
  Future<void> getSpeechToText() async {
    try {
      if (l1Code == null || l2Code == null) {
        throw Exception('Language selection not found');
      }
      speechToTextResponse ??=
          await widget.messageEvent.getSpeechToText(l1Code!, l2Code!);

      debugPrint(
        'Speech to text transcript: ${speechToTextResponse?.transcript.text}',
      );
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
    if (_fetchingTranscription) {
      return const ToolbarContentLoadingIndicator();
    }

    //done fetchig but not results means some kind of error
    if (speechToTextResponse == null) {
      return CardErrorWidget(error: error);
    }

    return Column(
      children: [
        SpeechToTextText(transcript: speechToTextResponse!.transcript),
        const Divider(),
        SpeechToTextScoreWidget(
          score: speechToTextResponse!.transcript.confidence,
        ),
      ],
    );
  }
}
