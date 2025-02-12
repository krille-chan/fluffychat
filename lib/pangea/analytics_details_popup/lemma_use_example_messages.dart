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
import 'package:fluffychat/widgets/matrix.dart';

class LemmaUseExampleMessages extends StatelessWidget {
  final ConstructUses construct;

  const LemmaUseExampleMessages({
    super.key,
    required this.construct,
  });

  Future<List<ExampleMessage>> _getExampleMessages() async {
    final Set<ExampleMessage> examples = {};
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

      final Event? event = await room.getEventById(use.metadata.eventId!);
      if (event == null) continue;
      final PangeaMessageEvent pangeaMessageEvent = PangeaMessageEvent(
        event: event,
        timeline: timeline!,
        ownMessage: event.senderId ==
            MatrixState.pangeaController.matrixState.client.userID,
      );
      final tokens = pangeaMessageEvent.messageDisplayRepresentation?.tokens;
      if (tokens == null || tokens.isEmpty) continue;
      final token =
          tokens.firstWhereOrNull((token) => token.text.content == use.form);
      if (token == null) continue;

      final int offset = token.text.offset;
      examples.add(
        ExampleMessage(
          message: pangeaMessageEvent.messageDisplayText,
          offset: offset,
          length: use.form!.length,
        ),
      );
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
              children: snapshot.data!.map((e) {
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
                      children: [
                        TextSpan(text: e.message.substring(0, e.offset)),
                        TextSpan(
                          text: e.message
                              .substring(e.offset, e.offset + e.length),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: e.message.substring(e.offset + e.length),
                        ),
                      ],
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
  final String message;
  final int offset;
  final int length;

  ExampleMessage({
    required this.message,
    required this.offset,
    required this.length,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExampleMessage &&
        other.message == message &&
        other.offset == offset &&
        other.length == length;
  }

  @override
  int get hashCode => message.hashCode ^ offset.hashCode ^ length.hashCode;
}
