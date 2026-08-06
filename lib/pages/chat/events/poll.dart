// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/robust_poll_parser.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matrix/matrix.dart' hide Result;

class PollWidget extends StatelessWidget {
  final Event event;
  final Timeline timeline;
  final Color textColor;
  final Color linkColor;
  const PollWidget({
    required this.event,
    required this.timeline,
    required this.textColor,
    required this.linkColor,
    super.key,
  });

  Map<String, Set<String>> _getPollResponses(Timeline timeline) {
    final aggregatedEvents = timeline
        .aggregatedEvents[event.eventId]?[RelationshipTypes.reference]
        ?.toList();
    if (aggregatedEvents == null || aggregatedEvents.isEmpty) return {};

    aggregatedEvents.removeWhere(
      (e) =>
          e.type != 'm.poll.response' &&
          e.type != 'org.matrix.msc3381.poll.response',
    );

    final responses = <String, Event>{};
    final endPollEvent = _getEndPollEvent(timeline);

    for (final e in aggregatedEvents) {
      final existingEvent = responses[e.senderId];
      if (existingEvent != null &&
          existingEvent.originServerTs.isAfter(e.originServerTs)) {
        continue;
      }
      if (endPollEvent != null &&
          e.originServerTs.isAfter(endPollEvent.originServerTs)) {
        continue;
      }
      responses[e.senderId] = e;
    }

    return responses.map((userId, e) {
      final responseMap =
          e.content['m.poll.response'] ??
          e.content['org.matrix.msc3381.poll.response'];
      final answers = <String>[];
      if (responseMap is Map) {
        final answersList = responseMap['answers'];
        if (answersList is List) {
          answers.addAll(answersList.cast<String>());
        }
      }
      return MapEntry(userId, answers.toSet());
    });
  }

  Event? _getEndPollEvent(Timeline timeline) {
    final aggregatedEvents =
        timeline.aggregatedEvents[event.eventId]?[RelationshipTypes.reference];
    if (aggregatedEvents == null || aggregatedEvents.isEmpty) return null;

    final redactPowerLevel =
        event.room
            .getState(EventTypes.RoomPowerLevels)
            ?.content
            .tryGet<int>('redact') ??
        50;

    return aggregatedEvents.firstWhereOrNull((e) {
      final hasEndKey =
          e.content.containsKey('m.poll.end') ||
          e.content.containsKey('org.matrix.msc3381.poll.end');
      if (!hasEndKey) {
        return false;
      }

      if (e.senderId == event.senderId ||
          e.senderFromMemoryOrFallback.powerLevel.level >= redactPowerLevel) {
        return true;
      }
      return false;
    });
  }

  bool _getPollHasBeenEnded(Timeline timeline) =>
      _getEndPollEvent(timeline) != null;

  void _endPoll(BuildContext context) {
    final isStable = event.type == 'm.poll.start';
    final endType = isStable ? 'm.poll.end' : 'org.matrix.msc3381.poll.end';

    showFutureLoadingDialog(
      context: context,
      future: () => event.room.sendEvent({
        'm.relates_to': {
          'rel_type': RelationshipTypes.reference,
          'event_id': event.eventId,
        },
        endType: {},
      }, type: endType),
    );
  }

  void _toggleVote(BuildContext context, String answerId, int maxSelection) {
    final userId = event.room.client.userID!;
    final answerIds = _getPollResponses(timeline)[userId] ?? {};
    if (!answerIds.remove(answerId)) {
      answerIds.add(answerId);
      if (answerIds.length > maxSelection) {
        answerIds.clear();
        answerIds.add(answerId);
      }
    }

    final isStable = event.type == 'm.poll.start';
    final responseType = isStable
        ? 'm.poll.response'
        : 'org.matrix.msc3381.poll.response';

    showFutureLoadingDialog(
      context: context,
      future: () => event.room.sendEvent({
        'm.relates_to': {
          'rel_type': RelationshipTypes.reference,
          'event_id': event.eventId,
        },
        responseType: {'answers': answerIds.toList()},
      }, type: responseType),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventContent = RobustPollParser.parseRobustPollContent(event.content);
    if (eventContent == null) {
      return const Text('Unable to parse poll event...');
    }
    final responses = _getPollResponses(timeline);
    final pollHasBeenEnded = _getPollHasBeenEnded(timeline);

    final isStable = event.type == 'm.poll.start';
    final responseType = isStable
        ? 'm.poll.response'
        : 'org.matrix.msc3381.poll.response';

    final canVote = event.room.canSendEvent(responseType) && !pollHasBeenEnded;
    final maxPolls = responses.length;
    final answersVisible = eventContent.disclosed || pollHasBeenEnded;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Linkify(
              text: eventContent.question,
              textScaleFactor: MediaQuery.textScalerOf(context).scale(1),
              style: TextStyle(
                color: textColor,
                fontSize: AppConfig.messageFontSize,
              ),
              options: const LinkifyOptions(humanize: false),
              linkStyle: TextStyle(
                color: linkColor,
                fontSize: AppConfig.messageFontSize,
                decoration: TextDecoration.underline,
                decorationColor: linkColor,
              ),
              onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
            ),
          ),
          Divider(color: linkColor.withAlpha(64)),
          ...eventContent.answers.map((answer) {
            final votedUserIds = responses.entries
                .where((entry) => entry.value.contains(answer.id))
                .map((entry) => entry.key)
                .toSet();
            return Material(
              color: Colors.transparent,
              clipBehavior: Clip.hardEdge,
              child: CheckboxListTile.adaptive(
                value:
                    responses[event.room.client.userID!]?.contains(answer.id) ??
                    false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                checkboxScaleFactor: 1.5,
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                onChanged: !canVote
                    ? null
                    : (_) => _toggleVote(
                        context,
                        answer.id,
                        eventContent.maxSelections,
                      ),
                title: Text(
                  answer.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: AppConfig.messageFontSize,
                  ),
                ),
                subtitle: answersVisible
                    ? Column(
                        crossAxisAlignment: .start,
                        mainAxisSize: .min,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  L10n.of(
                                    context,
                                  ).countVotes(votedUserIds.length),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: linkColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                ...votedUserIds.map((userId) {
                                  final user = event.room
                                      .getState(EventTypes.RoomMember, userId)
                                      ?.asUser(event.room);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0,
                                    ),
                                    child: Avatar(
                                      mxContent: user?.avatarUrl,
                                      name:
                                          user?.calcDisplayname() ??
                                          userId.localpart,
                                      size: 12,
                                    ),
                                  );
                                }),
                                const SizedBox(width: 2),
                              ],
                            ),
                          ),
                          LinearProgressIndicator(
                            color: linkColor,
                            backgroundColor: linkColor.withAlpha(128),
                            borderRadius: BorderRadius.circular(
                              AppConfig.borderRadius,
                            ),
                            value: maxPolls == 0
                                ? 0
                                : votedUserIds.length / maxPolls,
                          ),
                        ],
                      )
                    : null,
              ),
            );
          }),
          if (!pollHasBeenEnded && event.senderId == event.room.client.userID)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: () => _endPoll(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: linkColor,
                  side: BorderSide(color: linkColor.withAlpha(64)),
                ),
                child: Text(L10n.of(context).endPoll),
              ),
            )
          else if (!answersVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                L10n.of(context).answersWillBeVisibleWhenPollHasEnded,
                style: TextStyle(
                  color: linkColor,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else if (pollHasBeenEnded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                L10n.of(context).pollHasBeenEnded,
                style: TextStyle(
                  color: linkColor,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
