import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';

class ChatSearchFilesTab extends StatelessWidget {
  final Room room;
  final Stream<(List<Event>, String?)>? searchStream;
  final void Function({
    String? prevBatch,
    List<Event>? previousSearchResult,
  }) startSearch;

  const ChatSearchFilesTab({
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
              const Icon(Icons.file_present_outlined, size: 64),
              const SizedBox(height: 8),
              Text(L10n.of(context).nothingFound),
            ],
          );
        }

        return SelectionArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: events.length + 1,
            itemBuilder: (context, i) {
              if (i == events.length) {
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
              final event = events[i];
              final filename = event.content.tryGet<String>('filename') ??
                  event.content.tryGet<String>('body') ??
                  L10n.of(context).unknownEvent('File');
              final filetype = (filename.contains('.')
                  ? filename.split('.').last.toUpperCase()
                  : event.content
                          .tryGetMap<String, dynamic>('info')
                          ?.tryGet<String>('mimetype')
                          ?.toUpperCase() ??
                      'UNKNOWN');
              final sizeString = event.sizeString;
              final prevEvent = i > 0 ? events[i - 1] : null;
              final sameEnvironment = prevEvent == null
                  ? false
                  : prevEvent.originServerTs
                      .sameEnvironment(event.originServerTs);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!sameEnvironment) ...[
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
                              event.originServerTs.localizedTime(context),
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
                      const SizedBox(height: 4),
                    ],
                    Material(
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                      color: theme.colorScheme.onInverseSurface,
                      clipBehavior: Clip.hardEdge,
                      child: ListTile(
                        leading: const Icon(Icons.file_present_outlined),
                        title: Text(
                          filename,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('$sizeString | $filetype'),
                        onTap: () => event.saveFile(context),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
