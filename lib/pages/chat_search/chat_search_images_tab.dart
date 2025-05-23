import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/events/video_player.dart';
import 'package:fluffychat/pages/image_viewer/image_viewer.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/mxc_image.dart';

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
    final borderRadius = BorderRadius.circular(AppConfig.borderRadius / 2);
    return StreamBuilder(
      stream: searchStream,
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        final events = snapshot.data?.$1;
        if (searchStream == null || events == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator.adaptive(strokeWidth: 2),
              const SizedBox(height: 8),
              Text(
                L10n.of(context).searchIn(
                  room.getLocalizedDisplayname(
                    MatrixLocals(L10n.of(context)),
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
              Text(L10n.of(context).nothingFound),
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
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      foregroundColor: theme.colorScheme.onSecondaryContainer,
                    ),
                    onPressed: () => startSearch(
                      prevBatch: nextBatch,
                      previousSearchResult: events,
                    ),
                    icon: const Icon(
                      Icons.arrow_downward_outlined,
                    ),
                    label: Text(L10n.of(context).searchMore),
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
                        color: theme.dividerColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat.yMMMM(
                          Localizations.localeOf(context).languageCode,
                        ).format(eventsByMonthList[i].key),
                        style: theme.textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: theme.dividerColor,
                      ),
                    ),
                  ],
                ),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  mainAxisSpacing: padding,
                  crossAxisSpacing: padding,
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.all(padding),
                  crossAxisCount: 3,
                  children: monthEvents.map(
                    (event) {
                      if (event.messageType == MessageTypes.Video) {
                        return Material(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: borderRadius,
                          child: EventVideoPlayer(event),
                        );
                      }
                      return InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => ImageViewer(
                            event,
                            outerContext: context,
                          ),
                        ),
                        borderRadius: borderRadius,
                        child: Material(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: borderRadius,
                          child: MxcImage(
                            event: event,
                            width: 128,
                            height: 128,
                            fit: BoxFit.cover,
                            animated: true,
                            isThumbnail: true,
                          ),
                        ),
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
