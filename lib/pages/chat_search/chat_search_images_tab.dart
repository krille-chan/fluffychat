import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/events/image_bubble.dart';
import 'package:fluffychat/pages/chat/events/video_player.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';

class ChatSearchImagesTab extends StatelessWidget {
  final Room room;
  final Stream<(List<Event>, String?)>? searchStream;
  final void Function({
    String? prevBatch,
    List<Event>? previousSearchResult,
  }) startSearch;

  const ChatSearchImagesTab({
    required this.room,
    required this.startSearch,
    required this.searchStream,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: searchStream,
      builder: (context, snapshot) {
        final events = snapshot.data?.$1;
        if (searchStream == null || events == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator.adaptive(strokeWidth: 2),
              const SizedBox(height: 8),
              Text(
                L10n.of(context)!.searchIn(
                  room.getLocalizedDisplayname(
                    MatrixLocals(L10n.of(context)!),
                  ),
                ),
              ),
            ],
          );
        }
        if (events.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.photo_outlined, size: 64),
              const SizedBox(height: 8),
              Text(L10n.of(context)!.nothingFound),
            ],
          );
        }
        final eventsByMonth = <DateTime, List<Event>>{};
        for (final event in events) {
          final month = DateTime(
            event.originServerTs.year,
            event.originServerTs.month,
          );
          eventsByMonth[month] ??= [];
          eventsByMonth[month]!.add(event);
        }
        final eventsByMonthList = eventsByMonth.entries.toList();

        const padding = 8.0;

        return ListView.builder(
          itemCount: eventsByMonth.length + 1,
          itemBuilder: (context, i) {
            if (i == eventsByMonth.length) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              final nextBatch = snapshot.data?.$2;
              if (nextBatch == null) {
                return const SizedBox.shrink();
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                    onPressed: () => startSearch(
                      prevBatch: nextBatch,
                      previousSearchResult: events,
                    ),
                    icon: const Icon(
                      Icons.arrow_downward_outlined,
                    ),
                    label: Text(L10n.of(context)!.searchMore),
                  ),
                ),
              );
            }

            final monthEvents = eventsByMonthList[i].value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat.yMMMM(
                          Localizations.localeOf(context).languageCode,
                        ).format(eventsByMonthList[i].key),
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ],
                ),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  mainAxisSpacing: padding,
                  crossAxisSpacing: padding,
                  padding: const EdgeInsets.all(padding),
                  crossAxisCount: 3,
                  children: monthEvents.map(
                    (event) {
                      if (event.messageType == MessageTypes.Video) {
                        return EventVideoPlayer(event);
                      }
                      return ImageBubble(
                        event,
                        fit: BoxFit.cover,
                      );
                    },
                  ).toList(),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
