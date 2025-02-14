import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_level_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/analytics_misc/learning_skills_enum.dart';
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
          use.pointValue <= 0) {
        continue;
      }

      final Room? room = MatrixState.pangeaController.matrixState.client
          .getRoomById(use.metadata.roomId);
      if (room == null) continue;

      Timeline? timeline = room.timeline;
      if (room.timeline == null) {
        timeline = await room.getTimeline();
      }

      final exampleIndex = examples.indexWhere(
        (example) => example.event.eventId == use.metadata.eventId!,
      );

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

      final example = exampleIndex == -1
          ? ExampleMessage(
              event: event,
              message: pangeaMessageEvent.messageDisplayText,
            )
          : examples[exampleIndex];

      if (example.isTokenAdded(token)) continue;
      example.addTokenPosition(token.text.offset, token.text.length);

      exampleIndex == -1
          ? examples.add(example)
          : examples[exampleIndex] = example;
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
                    color: construct.lemmaCategory.color,
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
  final Map<int, int> _tokenPositions;

  ExampleMessage({
    required this.event,
    required this.message,
  }) : _tokenPositions = {};

  void addTokenPosition(int offset, int length) {
    _tokenPositions[offset] = length;
  }

  bool isTokenAdded(PangeaToken token) {
    return _tokenPositions.keys.any(
      (offset) => offset == token.text.offset,
    );
  }

  List<List<int>> get _sortedTokenPositions {
    return _tokenPositions.entries
        .sorted((a, b) => a.key.compareTo(b.key))
        .map((entry) => [entry.key, entry.value])
        .toList();
  }

  List<TextSpan> get textSpans {
    final spans = <TextSpan>[];
    int lastOffset = 0;
    for (final token in _sortedTokenPositions) {
      spans.add(
        TextSpan(
          text: message.substring(lastOffset, token[0]),
        ),
      );
      spans.add(
        TextSpan(
          text: message.substring(token[0], token[0] + token[1]),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      lastOffset = token[0] + token[1];
    }
    spans.add(
      TextSpan(
        text: message.substring(lastOffset),
      ),
    );
    return spans;
  }
}
