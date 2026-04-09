import 'dart:async';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_list_tile.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class PinnedEvents extends StatelessWidget {
  final ChatController controller;

  const PinnedEvents(this.controller, {super.key});

  Future<void> _displayPinnedEventsDialog(BuildContext context) async {
    final l10n = L10n.of(context);
    final eventsResult = await showFutureLoadingDialog(
      context: context,
      future: () => Future.wait(
        controller.room.pinnedEventIds.map(
          (eventId) => controller.room.getEventById(eventId),
        ),
      ),
    );
    final events = eventsResult.result;
    if (events == null) return;
    if (!context.mounted) return;

    if (events.length == 1) {
      final event = events.single;
      if (event != null) controller.scrollToEventId(event.eventId);
      return;
    }

    final canUnpin =
        controller.room.canSendEvent(EventTypes.RoomPinnedEvents);

    final eventId = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      constraints: BoxConstraints(
        maxWidth: 512,
        maxHeight: MediaQuery.sizeOf(context).height - 32,
      ),
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text(
              l10n.pin,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const Divider(height: 1),
          ...events.map(
            (event) => ListTile(
              leading: canUnpin
                  ? IconButton(
                      icon: const Icon(Icons.push_pin),
                      tooltip: l10n.unpin,
                      onPressed: () {
                        Navigator.of(context).pop<String>();
                        if (event != null) {
                          controller.unpinEvent(event.eventId);
                        }
                      },
                    )
                  : const Icon(Icons.push_pin_outlined),
              title: Text(
                event?.calcLocalizedBodyFallback(
                      MatrixLocals(l10n),
                      withSenderNamePrefix: true,
                      hideReply: true,
                    ) ??
                    'UNKNOWN',
                maxLines: 1,
              ),
              onTap: () =>
                  Navigator.of(context).pop<String>(event?.eventId ?? ''),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            title: Text(l10n.cancel),
            onTap: () => Navigator.of(context).pop<String>(),
          ),
        ],
      ),
    );

    if (eventId != null && eventId.isNotEmpty) {
      controller.scrollToEventId(eventId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final pinnedEventIds = controller.room.pinnedEventIds;

    if (pinnedEventIds.isEmpty || controller.activeThreadId != null) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<Event?>(
      future: controller.room.getEventById(pinnedEventIds.last),
      builder: (context, snapshot) {
        final event = snapshot.data;
        return ChatAppBarListTile(
          title:
              event?.calcLocalizedBodyFallback(
                MatrixLocals(L10n.of(context)),
                withSenderNamePrefix: true,
                hideReply: true,
              ) ??
              L10n.of(context).loadingPleaseWait,
          leading: IconButton(
            splashRadius: 18,
            iconSize: 18,
            color: theme.colorScheme.onSurfaceVariant,
            icon: const Icon(Icons.push_pin),
            tooltip: L10n.of(context).unpin,
            onPressed: controller.room.canSendEvent(EventTypes.RoomPinnedEvents)
                ? () => controller.unpinEvent(event!.eventId)
                : null,
          ),
          onTap: () => _displayPinnedEventsDialog(context),
        );
      },
    );
  }
}
