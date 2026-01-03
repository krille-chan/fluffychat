import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_search/search_footer.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/event_extension.dart';

class ChatSearchFilesTab extends StatelessWidget {
  final Room room;
  final List<Event> events;
  final void Function() onStartSearch;
  final bool endReached, isLoading;
  final DateTime? searchedUntil;

  const ChatSearchFilesTab({
    required this.room,
    required this.events,
    required this.onStartSearch,
    required this.endReached,
    required this.isLoading,
    super.key,
    required this.searchedUntil,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SelectionArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: events.length + 1,
        itemBuilder: (context, i) {
          if (i == events.length) {
            return SearchFooter(
              searchedUntil: searchedUntil,
              endReached: endReached,
              isLoading: isLoading,
              onStartSearch: onStartSearch,
            );
          }
          final event = events[i];
          final filename =
              event.content.tryGet<String>('filename') ??
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
              : prevEvent.originServerTs.sameEnvironment(event.originServerTs);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!sameEnvironment) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: theme.dividerColor),
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
                        child: Container(height: 1, color: theme.dividerColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Material(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
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
  }
}
