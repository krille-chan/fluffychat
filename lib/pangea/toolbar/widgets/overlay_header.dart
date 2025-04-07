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
    final l10n = L10n.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppConfig.borderRadius),
          bottomRight: Radius.circular(AppConfig.borderRadius),
        ),
        color: theme.appBarTheme.backgroundColor ??
            theme.colorScheme.surfaceContainerHighest,
      ),
      height: theme.appBarTheme.toolbarHeight ?? AppConfig.defaultHeaderHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (controller.selectedEvents.length == 1)
            IconButton(
              icon: const Icon(Symbols.reply_all),
              tooltip: l10n.reply,
              onPressed: controller.replyAction,
              color: theme.colorScheme.primary,
            ),
          IconButton(
            icon: const Icon(Symbols.forward),
            tooltip: l10n.forward,
            onPressed: controller.forwardEventsAction,
            color: theme.colorScheme.primary,
          ),
          if (controller.selectedEvents.length == 1 &&
              controller.selectedEvents.single.messageType == MessageTypes.Text)
            IconButton(
              icon: const Icon(Icons.copy_outlined),
              tooltip: l10n.copy,
              onPressed: controller.copyEventsAction,
              color: theme.colorScheme.primary,
            ),
          if (controller.canPinSelectedEvents)
            IconButton(
              icon: const Icon(Icons.push_pin_outlined),
              onPressed: controller.pinEvent,
              tooltip: l10n.pinMessage,
              color: theme.colorScheme.primary,
            ),
          if (controller.canEditSelectedEvents &&
              !controller.selectedEvents.first.isActivityMessage)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: l10n.edit,
              onPressed: controller.editSelectedEventAction,
              color: theme.colorScheme.primary,
            ),
          if (controller.canRedactSelectedEvents)
            IconButton(
              icon: const Icon(Icons.delete_outlined),
              tooltip: l10n.redactMessage,
              onPressed: controller.redactEventsAction,
              color: theme.colorScheme.primary,
            ),
          if (controller.selectedEvents.length == 1)
            IconButton(
              icon: const Icon(Icons.shield_outlined),
              tooltip: l10n.reportMessage,
              onPressed: () {
                final event = controller.selectedEvents.first;
                controller.clearSelectedEvents();
                reportEvent(
                  event,
                  controller,
                  controller.context,
                );
              },
              color: theme.colorScheme.primary,
            ),
          if (controller.selectedEvents.length == 1)
            IconButton(
              icon: const Icon(Icons.info_outlined),
              tooltip: l10n.messageInfo,
              color: theme.colorScheme.primary,
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
