import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';

class LemmaUseExampleMessages extends StatelessWidget {
  final ConstructUses construct;
  final Client client;

  const LemmaUseExampleMessages({
    super.key,
    required this.construct,
    required this.client,
  });

  Future<List<List<InlineSpan>>> _getExampleMessages() async {
    final Map<String, _ExampleMessage> examples = {};
    for (final OneConstructUse use in construct.cappedUses) {
      final eventId = use.metadata.eventId;
      final form = use.form;
      if (eventId == null || form == null) continue;

      if (examples[eventId]?.addToken(form) == true) {
        continue;
      }

      final messageEvent = await client.getEventByConstructUse(use);
      if (messageEvent == null) continue;

      final tokens = messageEvent.messageDisplayRepresentation?.tokens;
      if (tokens == null || tokens.isEmpty) continue;
      final example = _ExampleMessage(
        eventId: eventId,
        message: messageEvent.messageDisplayText,
        tokens: tokens,
      );

      if (example.addToken(form)) examples[eventId] = example;
      if (examples.length > 4) break;
    }

    final List<List<InlineSpan>> exampleSpans = [];
    for (final example in examples.values) {
      try {
        exampleSpans.add(example.getTextSpans());
      } catch (e, s) {
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {
            "message": example.message,
            "tokens": example.tokens.map((t) => t.toJson()).toList(),
          },
        );
      }
    }

    return exampleSpans;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getExampleMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: snapshot.data!.map((example) {
                return Container(
                  decoration: BoxDecoration(
                    color: construct.lemmaCategory.color(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                        fontSize:
                            AppSettings.fontSizeFactor.value *
                            AppConfig.messageFontSize,
                      ),
                      children: example,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return const Column(
            children: [
              SizedBox(height: 10),
              CircularProgressIndicator.adaptive(strokeWidth: 2),
            ],
          );
        }
      },
    );
  }
}

class _ExampleMessage {
  final String eventId;
  final String message;
  final List<PangeaToken> tokens;

  _ExampleMessage({
    required this.eventId,
    required this.message,
    required this.tokens,
  });

  final List<PangeaToken> _boldedTokens = [];

  bool addToken(String form) {
    final token = tokens.firstWhereOrNull(
      (token) => token.text.content == form,
    );

    if (token == null || _boldedTokens.contains(token)) {
      return false;
    }

    _boldedTokens.add(token);
    return true;
  }

  /// Get a list of text spans with styling to indicate the matching tokens.
  List<TextSpan> getTextSpans() {
    int characterPointer = 0;
    final List<TextSpan> spans = [];

    final sortedTokens = [..._boldedTokens]
      ..sort((a, b) => a.text.offset.compareTo(b.text.offset));

    for (final token in sortedTokens) {
      if (token.text.offset > characterPointer) {
        final beforeText = message.characters
            .skip(characterPointer)
            .take(token.text.offset - characterPointer)
            .toString();
        spans.add(TextSpan(text: beforeText));
      }

      characterPointer = token.text.offset;
      final tokenText = message.characters
          .skip(characterPointer)
          .take(token.text.length)
          .toString();

      if (tokenText != token.text.content) {
        throw StateError(
          "Token text mismatch: expected '${token.text.content}', got '$tokenText'",
        );
      }

      spans.add(
        TextSpan(
          text: tokenText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      characterPointer = token.text.offset + token.text.length;
    }

    if (characterPointer < message.length) {
      final afterText = message.characters
          .skip(characterPointer)
          .take(message.length - characterPointer)
          .toString();
      spans.add(TextSpan(text: afterText));
    }

    return spans;
  }
}
