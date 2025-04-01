import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/utils/report_message.dart';

class OverlayHeader extends StatelessWidget {
  final ChatController controller;

  const OverlayHeader({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConfig.borderRadius),
          bottomRight: Radius.circular(AppConfig.borderRadius),
        ),
        color: Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      height: Theme.of(context).appBarTheme.toolbarHeight ??
          AppConfig.defaultHeaderHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (controller.selectedEvents.length == 1)
            IconButton(
              icon: const Icon(Symbols.reply_all),
              tooltip: L10n.of(context).reply,
              onPressed: controller.replyAction,
              color: Theme.of(context).colorScheme.primary,
            ),
          IconButton(
            icon: const Icon(Symbols.forward),
            tooltip: L10n.of(context).forward,
            onPressed: controller.forwardEventsAction,
            color: Theme.of(context).colorScheme.primary,
          ),
          if (controller.selectedEvents.length == 1 &&
              controller.selectedEvents.single.messageType == MessageTypes.Text)
            IconButton(
              icon: const Icon(Icons.copy_outlined),
              tooltip: L10n.of(context).copy,
              onPressed: controller.copyEventsAction,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (controller.canPinSelectedEvents)
            IconButton(
              icon: const Icon(Icons.push_pin_outlined),
              onPressed: controller.pinEvent,
              tooltip: L10n.of(context).pinMessage,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (controller.canEditSelectedEvents &&
              !controller.selectedEvents.first.isActivityMessage)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: L10n.of(context).edit,
              onPressed: controller.editSelectedEventAction,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (controller.canRedactSelectedEvents)
            IconButton(
              icon: const Icon(Icons.delete_outlined),
              tooltip: L10n.of(context).redactMessage,
              onPressed: controller.redactEventsAction,
              color: Theme.of(context).colorScheme.primary,
            ),
          if (controller.selectedEvents.length == 1)
            IconButton(
              icon: const Icon(Icons.shield_outlined),
              tooltip: L10n.of(context).reportMessage,
              onPressed: () => reportEvent(
                controller.selectedEvents.first,
                controller,
                context,
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
          if (controller.selectedEvents.length == 1)
            IconButton(
              icon: const Icon(Icons.info_outlined),
              tooltip: L10n.of(context).messageInfo,
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                controller.showEventInfo();
                controller.clearSelectedEvents();
              },
            ),
        ],
      ),
    );
  }
}
