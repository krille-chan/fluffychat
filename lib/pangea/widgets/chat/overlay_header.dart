import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_title.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

enum _EventContextAction { info, report }

class OverlayHeader extends StatelessWidget {
  ChatController controller;

  OverlayHeader({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Event selectedEvent = controller.selectedEvents.single;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      actionsIconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.primary,
      ),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: MatrixState.pAnyState.closeOverlay,
        tooltip: L10n.of(context)!.close,
        color: Theme.of(context).colorScheme.primary,
      ),
      titleSpacing: 0,
      title: ChatAppBarTitle(controller),
      actions: [
        if (controller.canEditSelectedEvents)
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: L10n.of(context)!.edit,
            onPressed: controller.editSelectedEventAction,
          ),
        if (selectedEvent.messageType == MessageTypes.Text)
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            tooltip: L10n.of(context)!.copy,
            onPressed: controller.copyEventsAction,
          ),
        if (controller.canSaveSelectedEvent)
          // Use builder context to correctly position the share dialog on iPad
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.adaptive.share),
              tooltip: L10n.of(context)!.share,
              onPressed: () => controller.saveSelectedEvent(context),
            ),
          ),
        if (controller.canPinSelectedEvents)
          IconButton(
            icon: const Icon(Icons.push_pin_outlined),
            onPressed: controller.pinEvent,
            tooltip: L10n.of(context)!.pinMessage,
          ),
        if (controller.canRedactSelectedEvents)
          IconButton(
            icon: const Icon(Icons.delete_outlined),
            tooltip: L10n.of(context)!.redactMessage,
            onPressed: controller.redactEventsAction,
          ),
        PopupMenuButton<_EventContextAction>(
          onSelected: (action) {
            switch (action) {
              case _EventContextAction.info:
                controller.showEventInfo();
                controller.clearSelectedEvents();
                break;
              case _EventContextAction.report:
                controller.reportEventAction();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _EventContextAction.info,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.messageInfo),
                ],
              ),
            ),
            if (selectedEvent.status.isSent)
              PopupMenuItem(
                value: _EventContextAction.report,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.reportMessage),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
