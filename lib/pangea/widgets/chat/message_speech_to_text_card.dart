import 'dart:developer';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/enum/instructions_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/utils/inline_tooltip.dart';
import 'package:fluffychat/pangea/widgets/chat/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/pangea/widgets/common/icon_number_widget.dart';
import 'package:fluffychat/pangea/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../utils/bot_style.dart';

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
  STTToken? selectedToken;

  String? get l1Code =>
      MatrixState.pangeaController.languageController.activeL1Code();
  String? get l2Code =>
      MatrixState.pangeaController.languageController.activeL2Code();

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
      debugger(when: kDebugMode);
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

  void closeHint() {
    setState(() {});
  }

  TextSpan _buildTranscriptText(BuildContext context) {
    final Transcript transcript = speechToTextResponse!.transcript;
    final List<InlineSpan> spans = [];
    final String fullText = transcript.text;
    int lastEnd = 0;

    for (final token in transcript.sttTokens) {
      // debugPrint('Token confidence: ${token.confidence}');
      // debugPrint('color: ${token.color(context)}');
      if (token.offset > lastEnd) {
        // Add any plain text before the token
        spans.add(
          TextSpan(
            text: fullText.substring(lastEnd, token.offset),
          ),
        );
        // debugPrint('Pre: ${fullText.substring(lastEnd, token.offset)}');
      }

      spans.add(
        TextSpan(
          text: fullText.substring(token.offset, token.offset + token.length),
          style: BotStyle.text(
            context,
            existingStyle: TextStyle(color: token.color(context)),
            setColor: false,
          ),
          // gesturRecognizer that sets selectedToken on click
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              debugPrint('Token tapped');
              debugPrint(token.toJson().toString());
              setState(() {
                if (selectedToken == token) {
                  selectedToken = null;
                } else {
                  selectedToken = token;
                }
              });
            },
        ),
      );

      // debugPrint(
      //   'Main: ${fullText.substring(token.offset, token.offset + token.length)}',
      // );

      lastEnd = token.offset + token.length;
    }

    if (lastEnd < fullText.length) {
      // Add any remaining text after the last token
      spans.add(
        TextSpan(
          text: fullText.substring(lastEnd),
        ),
      );
      // debugPrint('Post: ${fullText.substring(lastEnd)}');
    }

    return TextSpan(children: spans);
  }

  @override
  void initState() {
    super.initState();
    getSpeechToText();
  }

  String? get wordsPerMinuteString =>
      speechToTextResponse?.transcript.wordsPerMinute?.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    if (_fetchingTranscription) {
      return const ToolbarContentLoadingIndicator();
    }

    // done fetchig but not results means some kind of error
    if (speechToTextResponse == null) {
      return CardErrorWidget(
        error: error ?? "Failed to fetch speech to text",
        maxWidth: AppConfig.toolbarMinWidth,
      );
    }

    //TODO: find better icons
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          RichText(
            text: _buildTranscriptText(context),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconNumberWidget(
                icon: Symbols.target,
                number:
                    "${selectedToken?.confidence ?? speechToTextResponse!.transcript.confidence}%",
                toolTip: L10n.of(context)!.accuracy,
              ),
              const SizedBox(width: 16),
              IconNumberWidget(
                icon: Icons.speed,
                number: wordsPerMinuteString != null
                    ? "$wordsPerMinuteString"
                    : "??",
                toolTip: L10n.of(context)!.wordsPerMinute,
              ),
            ],
          ),
          const InlineTooltip(
            instructionsEnum: InstructionsEnum.speechToText,
          ),
        ],
      ),
    );
  }
}
