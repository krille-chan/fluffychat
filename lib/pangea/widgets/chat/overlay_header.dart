import 'package:fluffychat/pages/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';
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
          actions: [
            IconButton(
              icon: const Icon(Symbols.forward),
              tooltip: L10n.of(context)!.forward,
              onPressed: controller.forwardEventsAction,
            ),
            if (controller.selectedEvents.length == 1 &&
                controller.selectedEvents.single.messageType ==
                    MessageTypes.Text)
              IconButton(
                icon: const Icon(Icons.copy_outlined),
                tooltip: L10n.of(context)!.copy,
                onPressed: controller.copyEventsAction,
              ),
            if (controller.canPinSelectedEvents)
              IconButton(
                icon: const Icon(Icons.push_pin_outlined),
                onPressed: controller.pinEvent,
                tooltip: L10n.of(context)!.pinMessage,
              ),
            if (controller.canEditSelectedEvents)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: L10n.of(context)!.edit,
                onPressed: controller.editSelectedEventAction,
              ),
            if (controller.canRedactSelectedEvents)
              IconButton(
                icon: const Icon(Icons.delete_outlined),
                tooltip: L10n.of(context)!.redactMessage,
                onPressed: controller.redactEventsAction,
              ),
            if (controller.selectedEvents.length == 1)
              IconButton(
                icon: const Icon(Icons.shield_outlined),
                tooltip: L10n.of(context)!.reportMessage,
                onPressed: controller.reportEventAction,
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
          ],
        ),
      ],
    );
  }
}
