import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_title.dart';
import 'package:fluffychat/pangea/utils/overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

class OverlayHeader extends StatelessWidget {
  ChatController controller;
  Function closeToolbar;

  OverlayHeader({
    required this.controller,
    required this.closeToolbar,
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
        onPressed: () => closeToolbar(),
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
        IconButton(
          padding: const EdgeInsets.only(bottom: 6),
          icon: Icon(
            Icons.more_horiz,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => showPopup(context),
        ),
      ],
    );
  }

  void showPopup(BuildContext context) {
    OverlayUtil.showOverlay(
      context: context,
      child: SelectionPopup(controller: controller),
      transformTargetId: "",
      targetAnchor: Alignment.center,
      followerAnchor: Alignment.center,
      closePrevOverlay: false,
      position: OverlayEnum.topRight,
    );
  }
}

class SelectionPopup extends StatelessWidget {
  ChatController controller;

  SelectionPopup({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: controller.showEventInfo,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.messageInfo),
                ],
              ),
            ),
            TextButton(
              onPressed: controller.reportEventAction,
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
      ),
    );
  }
}
