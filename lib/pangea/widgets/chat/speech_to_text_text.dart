import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/utils/bot_style.dart';

class SpeechToTextText extends StatelessWidget {
  final Transcript transcript;

  const SpeechToTextText({super.key, required this.transcript});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildTranscriptText(context, transcript),
    );
  }

  TextSpan _buildTranscriptText(BuildContext context, Transcript transcript) {
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
}
