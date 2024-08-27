import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_title.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

class OverlayHeader extends StatelessWidget {
  final ChatController controller;

  const OverlayHeader({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          actionsIconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              controller.clearSelectedEvents();
              MatrixState.pAnyState.closeAllOverlays();
            },
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
            if (controller.selectedEvents.length == 1 &&
                controller.selectedEvents.single.messageType ==
                    MessageTypes.Text)
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
            if (controller.selectedEvents.length == 1)
              IconButton(
                icon: const Icon(Icons.info_outlined),
                tooltip: L10n.of(context)!.messageInfo,
                onPressed: () {
                  controller.showEventInfo();
                  controller.clearSelectedEvents();
                },
              ),
            if (controller.selectedEvents.length == 1)
              IconButton(
                icon: const Icon(Icons.shield_outlined),
                tooltip: L10n.of(context)!.reportMessage,
                onPressed: controller.reportEventAction,
              ),
          ],
        ),
      ],
    );
  }
}
