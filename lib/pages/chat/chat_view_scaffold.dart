import 'package:flutter/material.dart';

import 'package:badges/badges.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_title.dart';
import 'package:fluffychat/pages/chat/encryption_button.dart';
import 'package:fluffychat/widgets/chat_settings_popup_menu.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/unread_rooms_badge.dart';
import '../../utils/stream_extension.dart';

enum _EventContextAction { info, report }

class ChatViewScaffold extends StatelessWidget {
  final ChatController controller;
  final Widget body;

  const ChatViewScaffold(this.controller, {super.key, required this.body});

  List<Widget> _appBarActions(BuildContext context) {
    if (controller.selectMode) {
      return [
        if (controller.canEditSelectedEvents)
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: L10n.of(context)!.edit,
            onPressed: controller.editSelectedEventAction,
          ),
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
              if (controller.selectedEvents.single.status.isSent)
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
      ];
    } else if (!controller.room.isArchived) {
      return [
        if (Matrix.of(context).voipPlugin != null &&
            controller.room.isDirectChat)
          IconButton(
            onPressed: controller.onPhoneButtonTap,
            icon: const Icon(Icons.call_outlined),
            tooltip: L10n.of(context)!.placeCall,
          ),
        EncryptionButton(controller.room),
        ChatSettingsPopupMenu(controller.room, true),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: controller.selectedEvents.isEmpty && !controller.showEmojiPicker,
      onPopInvoked: (pop) async {
        if (pop) return;
        if (controller.selectedEvents.isNotEmpty) {
          controller.clearSelectedEvents();
        } else if (controller.showEmojiPicker) {
          controller.emojiPickerAction();
        }
      },
      child: GestureDetector(
        onTapDown: (_) => controller.setReadMarker(),
        behavior: HitTestBehavior.opaque,
        child: StreamBuilder(
          stream: controller.room.onUpdate.stream
              .rateLimit(const Duration(seconds: 1)),
          builder: (context, snapshot) => FutureBuilder(
            future: controller.loadTimelineFuture,
            builder: (BuildContext context, snapshot) {
              return Scaffold(
                appBar: AppBar(
                  actionsIconTheme: IconThemeData(
                    color: controller.selectedEvents.isEmpty
                        ? null
                        : Theme.of(context).colorScheme.primary,
                  ),
                  leading: controller.selectMode
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: controller.clearSelectedEvents,
                          tooltip: L10n.of(context)!.close,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : UnreadRoomsBadge(
                          filter: (r) => r.id != controller.roomId,
                          badgePosition: BadgePosition.topEnd(end: 8, top: 4),
                          child: const Center(child: BackButton()),
                        ),
                  titleSpacing: 0,
                  title: ChatAppBarTitle(controller),
                  actions: _appBarActions(context),
                ),
                floatingActionButton: controller.showScrollDownButton &&
                        controller.selectedEvents.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 56.0),
                        child: FloatingActionButton(
                          onPressed: controller.scrollDown,
                          heroTag: null,
                          mini: true,
                          child: const Icon(Icons.arrow_downward_outlined),
                        ),
                      )
                    : null,
                body: body,
              );
            },
          ),
        ),
      ),
    );
  }
}
