import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_list_tile.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

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
        : await showModalActionPopup<String>(
            context: context,
            title: L10n.of(context).pin,
            cancelLabel: L10n.of(context).cancel,
            actions: events
                .map(
                  (event) => AdaptiveModalAction(
                    value: event?.eventId ?? '',
                    icon: const Icon(Icons.push_pin_outlined),
                    label: event?.calcLocalizedBodyFallback(
                          MatrixLocals(L10n.of(context)),
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
    final theme = Theme.of(context);

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
