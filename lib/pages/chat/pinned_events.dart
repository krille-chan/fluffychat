import 'dart:async';

import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_list_tile.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';

class PinnedEvents extends StatelessWidget {
  final ChatController controller;

  const PinnedEvents(this.controller, {super.key});

  Future<void> _displayPinnedEventsDialog(BuildContext context) async {
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

    final eventId = events.length == 1
        ? events.single?.eventId
        : await showConfirmationDialog<String>(
            context: context,
            title: L10n.of(context)!.pinMessage,
            actions: events
                .map(
                  (event) => AlertDialogAction(
                    key: event?.eventId ?? '',
                    label: event?.calcLocalizedBodyFallback(
                          MatrixLocals(L10n.of(context)!),
                          withSenderNamePrefix: true,
                          hideReply: true,
                        ) ??
                        'UNKNOWN',
                  ),
                )
                .toList(),
          );

    if (eventId != null) controller.scrollToEventId(eventId);
  }

  @override
  Widget build(BuildContext context) {
    final pinnedEventIds = controller.room.pinnedEventIds;

    if (pinnedEventIds.isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<Event?>(
      future: controller.room.getEventById(pinnedEventIds.last),
      builder: (context, snapshot) {
        final event = snapshot.data;
        return ChatAppBarListTile(
          title: event?.calcLocalizedBodyFallback(
                MatrixLocals(L10n.of(context)!),
                withSenderNamePrefix: true,
                hideReply: true,
              ) ??
              L10n.of(context)!.loadingPleaseWait,
          leading: IconButton(
            splashRadius: 20,
            iconSize: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            icon: const Icon(Icons.push_pin),
            tooltip: L10n.of(context)!.unpin,
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
