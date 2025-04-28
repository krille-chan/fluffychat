import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/toolbar/models/speech_to_text_models.dart';
import 'package:fluffychat/widgets/matrix.dart';

class MessageSpeechToTextCard extends StatefulWidget {
  final PangeaMessageEvent messageEvent;
  final Color textColor;

  const MessageSpeechToTextCard({
    super.key,
    required this.messageEvent,
    required this.textColor,
  });

  @override
  MessageSpeechToTextCardState createState() => MessageSpeechToTextCardState();
}

class MessageSpeechToTextCardState extends State<MessageSpeechToTextCard> {
  SpeechToTextModel? _speechToTextResponse;

  bool _fetchingTranscription = true;
  Object? error;

  String? get l1Code =>
      MatrixState.pangeaController.languageController.activeL1Code();
  String? get l2Code =>
      MatrixState.pangeaController.languageController.activeL2Code();

  @override
  void initState() {
    super.initState();
    _fetchTranscription();
  }

  // look for transcription in message event
  // if not found, call API to transcribe audio
  Future<void> _fetchTranscription() async {
    try {
      if (l1Code == null || l2Code == null) {
        throw Exception('Language selection not found');
      }

      _speechToTextResponse ??= await widget.messageEvent.getSpeechToText(
        l1Code!,
        l2Code!,
      );
    } catch (e, s) {
      debugger(when: kDebugMode);
      error = e;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: widget.messageEvent.event.content,
      );
    } finally {
      if (mounted) {
        setState(() => _fetchingTranscription = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fetchingTranscription) {
      return const LinearProgressIndicator();
    }

    // // done fetching but not results means some kind of error
    if (_speechToTextResponse == null || error != null) {
      return Row(
        spacing: 8.0,
        children: [
          Flexible(
            child: RichText(
              text: TextSpan(
                style: AppConfig.messageTextStyle(
                  widget.messageEvent.event,
                  widget.textColor,
                ),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.error,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: L10n.of(context).oopsSomethingWentWrong,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Text(
      "${_speechToTextResponse?.transcript.text}",
      style: AppConfig.messageTextStyle(
        widget.messageEvent.event,
        widget.textColor,
      ).copyWith(
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
