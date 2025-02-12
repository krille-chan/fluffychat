import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/card_error_widget.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/toolbar/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/toolbar/widgets/icon_number_widget.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_content_loading_indicator.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../bot/utils/bot_style.dart';

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
  TextSpan? transcriptText;

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
      if (mounted) {
        setState(() => _fetchingTranscription = false);
      }
    }
  }

  TextSpan _buildTranscriptText(BuildContext context) {
    try {
      final Transcript transcript = speechToTextResponse!.transcript;
      final List<InlineSpan> spans = [];
      String remainingFullText = transcript.text;

      if (transcript.sttTokens.isEmpty) {
        return TextSpan(
          text: remainingFullText,
          style: BotStyle.text(context),
        );
      }

      for (final token in transcript.sttTokens) {
        final offset = remainingFullText.indexOf(token.token.text.content);
        if (offset == -1) continue;
        final length = token.length;

        if (remainingFullText.substring(0, offset).trim().isNotEmpty) {
          remainingFullText = remainingFullText.substring(offset);
          continue;
        }

        if (offset > 0) {
          // Add any plain text before the token
          spans.add(
            TextSpan(text: remainingFullText.substring(0, offset)),
          );
        }

        spans.add(
          TextSpan(
            text: remainingFullText.substring(
              offset,
              offset + token.length,
            ),
            style: BotStyle.text(
              context,
              existingStyle: TextStyle(color: token.color(context)),
              setColor: false,
            ),
            // gesturRecognizer that sets selectedToken on click
            // recognizer: TapGestureRecognizer()
            //   ..onTap = () {
            //     debugPrint('Token tapped');
            //     debugPrint(token.toJson().toString());
            //     if (mounted) {
            //       setState(() {
            //         if (selectedToken == token) {
            //           selectedToken = null;
            //         } else {
            //           selectedToken = token;
            //         }
            //       });
            //     }
            //   },
          ),
        );

        remainingFullText = remainingFullText.substring(offset + length);
      }

      if (remainingFullText.isNotEmpty) {
        // Add any remaining text after the last token
        spans.add(TextSpan(text: remainingFullText));
      }

      return TextSpan(children: spans);
    } catch (err, s) {
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
      setState(() => error = err);
      return const TextSpan(text: '');
    }
  }

  @override
  void initState() {
    super.initState();
    getSpeechToText().then((_) {
      if (mounted) {
        setState(() => transcriptText = _buildTranscriptText(context));
      }
    });
  }

  String? get wordsPerMinuteString =>
      speechToTextResponse?.transcript.wordsPerMinute?.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    if (_fetchingTranscription) {
      return const ToolbarContentLoadingIndicator();
    }

    // done fetchig but not results means some kind of error
    if (speechToTextResponse == null || error != null) {
      return CardErrorWidget(
        error: error ?? "Failed to fetch speech to text",
        maxWidth: AppConfig.toolbarMinWidth,
      );
    }

    //TODO: find better icons
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          RichText(
            text: transcriptText!,
          ),
          if (widget.messageEvent.senderId == Matrix.of(context).client.userID)
            Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IconNumberWidget(
                    //   icon: Symbols.target,
                    //   number:
                    //       "${selectedToken?.confidence ?? speechToTextResponse!.transcript.confidence}%",
                    //   toolTip: L10n.of(context).accuracy,
                    // ),
                    // const SizedBox(width: 16),
                    IconNumberWidget(
                      icon: Icons.speed,
                      number: wordsPerMinuteString != null
                          ? "$wordsPerMinuteString"
                          : "??",
                      toolTip: L10n.of(context).wordsPerMinute,
                    ),
                  ],
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: InstructionsInlineTooltip(
                        instructionsEnum: InstructionsEnum.speechToText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
