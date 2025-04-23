import 'dart:math';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaUseExampleMessages extends StatelessWidget {
  final ConstructUses construct;

  const LemmaUseExampleMessages({
    super.key,
    required this.construct,
  });

  Future<List<ExampleMessage>> _getExampleMessages() async {
    final List<ExampleMessage> examples = [];
    for (final OneConstructUse use in construct.uses) {
      if (use.useType.skillsEnumType != LearningSkillsEnum.writing ||
          use.metadata.eventId == null ||
          use.form == null ||
          use.xp <= 0) {
        continue;
      }

      final exampleIndex = examples.indexWhere(
        (example) => example.event.eventId == use.metadata.eventId!,
      );

      if (exampleIndex != -1) {
        final example = examples[exampleIndex];
        final token = example.tokens.firstWhereOrNull(
          (token) => token.text.content == use.form,
        );
        if (token == null) continue;
        if (example.isTokenAdded(token)) continue;
        example.addToken(token);
        examples[exampleIndex] = example;
        continue;
      }

      if (use.metadata.roomId == null) continue;
      final Room? room = MatrixState.pangeaController.matrixState.client
          .getRoomById(use.metadata.roomId!);
      if (room == null) continue;

      Timeline? timeline = room.timeline;
      if (room.timeline == null) {
        timeline = await room.getTimeline();
      }

      final Event? event = exampleIndex != -1
          ? examples[exampleIndex].event
          : await room.getEventById(use.metadata.eventId!);

      if (event == null) continue;
      final PangeaMessageEvent pangeaMessageEvent = PangeaMessageEvent(
        event: event,
        timeline: timeline!,
        ownMessage: event.senderId ==
            MatrixState.pangeaController.matrixState.client.userID,
      );
      final tokens = pangeaMessageEvent.messageDisplayRepresentation?.tokens;
      if (tokens == null || tokens.isEmpty) continue;
      final token = tokens.firstWhereOrNull(
        (token) => token.text.content == use.form,
      );
      if (token == null) continue;

      final example = ExampleMessage(
        event: event,
        message: pangeaMessageEvent.messageDisplayText,
        tokens: tokens,
      );

      if (example.isTokenAdded(token)) continue;
      example.addToken(token);
      examples.add(example);
      if (examples.length > 4) break;
    }

    return examples.toList();
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
                        fontSize: AppConfig.fontSizeFactor *
                            AppConfig.messageFontSize,
                      ),
                      children: example.textSpans,
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
              CircularProgressIndicator.adaptive(
                strokeWidth: 2,
              ),
            ],
          );
        }
      },
    );
  }
}

class ExampleMessage {
  final Event event;
  final String message;
  final List<PangeaToken> tokens;
  final List<PangeaToken> _boldedTokens;

  ExampleMessage({
    required this.event,
    required this.message,
    required this.tokens,
  }) : _boldedTokens = [];

  final int tokenWindowSize = 10;

  void addToken(PangeaToken token) {
    _boldedTokens.add(token);
  }

  bool isTokenAdded(PangeaToken token) => _boldedTokens.contains(token);

  /// Get a list of text spans with styling to indicate the matching tokens.
  /// Leaves a window of tokens around the highlighted tokens.
  List<TextSpan> get textSpans {
    // define the token windows
    final List<TokenWindow> tokenWindows = [];
    tokens.sort((a, b) => a.text.offset.compareTo(b.text.offset));
    _boldedTokens.sort((a, b) => a.text.offset.compareTo(b.text.offset));

    int globalTokenIndex = 0;
    for (int i = 0; i < _boldedTokens.length; i++) {
      // go through each of the bolded tokens and add the surrounding token windows
      final boldedToken = _boldedTokens[i];
      final tokenIndex = tokens.indexOf(boldedToken);

      // globalTokenIndex is the index of the last token added to this list + 1.
      if (globalTokenIndex < tokenIndex) {
        final gapSize = tokenIndex - globalTokenIndex;
        if (gapSize <= tokenWindowSize) {
          // if the gap is less than the window size, add all the gap tokens
          tokenWindows.add(
            TokenWindow(
              globalTokenIndex,
              tokenIndex,
              false,
            ),
          );
        } else {
          // otherwise, add the window size tokens preceding the bolded token
          tokenWindows.add(
            TokenWindow(
              tokenIndex - tokenWindowSize,
              tokenIndex,
              false,
            ),
          );
        }
      }

      globalTokenIndex = tokenIndex;

      tokenWindows.add(
        TokenWindow(
          tokenIndex,
          tokenIndex + 1,
          true,
        ),
      );

      globalTokenIndex = tokenIndex + 1;

      if (i >= _boldedTokens.length - 1) {
        // if this is the last bolded token, then add the
        // remaining tokens (up to the max window size)
        if (globalTokenIndex >= tokens.length) break;
        final endIndex = min(tokens.length, globalTokenIndex + tokenWindowSize);
        tokenWindows.add(
          TokenWindow(
            globalTokenIndex,
            endIndex,
            false,
          ),
        );
        break;
      }

      // add the window tokens after the bolded token
      final nextToken = _boldedTokens[i + 1];
      final nextTokenIndex = tokens.indexOf(nextToken);
      final endIndex = min(nextTokenIndex, globalTokenIndex + tokenWindowSize);
      tokenWindows.add(
        TokenWindow(
          globalTokenIndex,
          endIndex,
          false,
        ),
      );

      globalTokenIndex = endIndex;
    }

    final List<TextSpan> spans = [];
    // use separate pointers to handle white space around bolded tokens
    int characterPointer = 0;
    int tokenPointer = 0;

    for (final window in tokenWindows) {
      if (tokenPointer < window.startTokenIndex) {
        spans.add(const TextSpan(text: " ... "));
        characterPointer = tokens[window.startTokenIndex].text.offset;
      }

      spans.add(
        TextSpan(
          text: message.substring(
            characterPointer,
            tokens[window.endTokenIndex - 1].text.offset +
                tokens[window.endTokenIndex - 1].text.length,
          ),
          style: window.isBold
              ? const TextStyle(fontWeight: FontWeight.bold)
              : null,
        ),
      );

      tokenPointer = window.endTokenIndex;
      characterPointer = tokens[window.endTokenIndex - 1].text.offset +
          tokens[window.endTokenIndex - 1].text.length;
    }

    if (tokenPointer < tokens.length) {
      spans.add(const TextSpan(text: " ... "));
    }
    return spans;
  }
}

class TokenWindow {
  int startTokenIndex;
  int endTokenIndex;
  bool isBold;

  TokenWindow(this.startTokenIndex, this.endTokenIndex, this.isBold);
}
