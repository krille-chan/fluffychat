import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/avatar.dart';

class ChatSearchMessageTab extends StatelessWidget {
  final String searchQuery;
  final Room room;
  final Stream<(List<Event>, String?)>? searchStream;
  final void Function({
    String? prevBatch,
    List<Event>? previousSearchResult,
  }) startSearch;

  const ChatSearchMessageTab({
    required this.searchQuery,
    required this.room,
    required this.searchStream,
    required this.startSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      key: ValueKey(searchQuery),
      stream: searchStream,
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        if (searchStream == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_outlined, size: 64),
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
        final events = snapshot.data?.$1 ?? [];

        return SelectionArea(
          child: ListView.separated(
            itemCount: events.length + 1,
            separatorBuilder: (context, _) => Divider(
              color: theme.dividerColor,
              height: 1,
            ),
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
              final sender = event.senderFromMemoryOrFallback;
              final displayname = sender.calcDisplayname(
                i18n: MatrixLocals(L10n.of(context)),
              );
              return _MessageSearchResultListTile(
                sender: sender,
                displayname: displayname,
                event: event,
                room: room,
              );
            },
          ),
        );
      },
    );
  }
}

class _MessageSearchResultListTile extends StatelessWidget {
  const _MessageSearchResultListTile({
    required this.sender,
    required this.displayname,
    required this.event,
    required this.room,
  });

  final User sender;
  final String displayname;
  final Event event;
  final Room room;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Row(
        children: [
          Avatar(
            mxContent: sender.avatarUrl,
            name: displayname,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            displayname,
          ),
          Expanded(
            child: Text(
              ' | ${event.originServerTs.localizedTimeShort(context)}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
      subtitle: Linkify(
        textScaleFactor: MediaQuery.textScalerOf(context).scale(1),
        options: const LinkifyOptions(humanize: false),
        linkStyle: TextStyle(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
          decorationColor: theme.colorScheme.primary,
        ),
        onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
        text: event
            .calcLocalizedBodyFallback(
              plaintextBody: true,
              removeMarkdown: true,
              MatrixLocals(
                L10n.of(context),
              ),
            )
            .trim(),
        maxLines: 7,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.chevron_right_outlined,
        ),
        onPressed: () => context.go(
          '/${Uri(
            pathSegments: ['rooms', room.id],
            queryParameters: {'event': event.eventId},
          )}',
        ),
      ),
    );
  }
}
