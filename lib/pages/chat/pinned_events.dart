import 'dart:async';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_link_text/link_text.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/utils/url_launcher.dart';

class PinnedEvents extends StatelessWidget {
  final ChatController controller;

  const PinnedEvents(this.controller, {Key? key}) : super(key: key);

  Future<void> _displayPinnedEventsDialog(
      BuildContext context, List<Event?> events) async {
    final eventId = events.length == 1
        ? events.single?.eventId
        : await showModalActionSheet<String>(
            context: context,
            actions: events
                .map((event) => SheetAction(
                      key: event?.eventId ?? '',
                      label: event?.getLocalizedBody(
                            MatrixLocals(L10n.of(context)!),
                            withSenderNamePrefix: true,
                            hideReply: true,
                          ) ??
                          'UNKNOWN',
                    ))
                .toList());

    if (eventId != null) controller.scrollToEventId(eventId);
  }

  @override
  Widget build(BuildContext context) {
    final pinnedEventIds = controller.room!.pinnedEventIds;

    if (pinnedEventIds.isEmpty) {
      return Container();
    }
    final completers = pinnedEventIds.map<Completer<Event?>>((e) {
      final completer = Completer<Event?>();
      controller.room!
          .getEventById(e)
          .then((value) => completer.complete(value));
      return completer;
    });
    return FutureBuilder<List<Event?>>(
        future: Future.wait(completers.map((e) => e.future).toList()),
        builder: (context, snapshot) {
          final pinnedEvents = snapshot.data;
          final event = (pinnedEvents != null && pinnedEvents.isNotEmpty)
              ? snapshot.data?.last
              : null;

          if (event != null && pinnedEvents != null) {
            final fontSize =
                AppConfig.messageFontSize * AppConfig.fontSizeFactor;
            return Material(
              color: Theme.of(context).appBarTheme.backgroundColor,
              elevation: Theme.of(context).appBarTheme.elevation ?? 10,
              shadowColor: Theme.of(context).appBarTheme.shadowColor,
              child: ListTile(
                tileColor: Colors.transparent,
                onTap: () => _displayPinnedEventsDialog(
                  context,
                  pinnedEvents,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: L10n.of(context)!.unpin,
                  onPressed: () => controller.unpinEvent(event.eventId),
                ),
                title: LinkText(
                  text: event.getLocalizedBody(
                    MatrixLocals(L10n.of(context)!),
                    withSenderNamePrefix: true,
                    hideReply: true,
                  ),
                  maxLines: 3,
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    decoration:
                        event.redacted ? TextDecoration.lineThrough : null,
                  ),
                  linkStyle: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.color
                        ?.withAlpha(150),
                    fontSize: fontSize,
                    decoration: TextDecoration.underline,
                  ),
                  onLinkTap: (url) => UrlLauncher(context, url).launchUrl(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            Logs().e('Error loading pinned events.', snapshot.error);
            return ListTile(
                tileColor: Theme.of(context).secondaryHeaderColor,
                title: Text(L10n.of(context)!.pinnedEventsError));
          } else {
            return ListTile(
              tileColor: Theme.of(context).secondaryHeaderColor,
              title: const Center(
                child: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        });
  }
}
