import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import 'package:fluffychat/pages/chat_list/spaces_bottom_bar.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import '../../widgets/matrix.dart';
import 'chat_list_body.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object?>(
      stream: Matrix.of(context).onShareContentChanged.stream,
      builder: (_, __) {
        final selectMode = controller.selectMode;
        final showSpaces =
            controller.spaces.isNotEmpty && controller.selectedRoomIds.isEmpty;
        return VWidgetGuard(
          onSystemPop: (redirector) async {
            final selMode = controller.selectMode;
            if (selMode != SelectMode.normal) controller.cancelAction();
            if (selMode == SelectMode.select) redirector.stopRedirection();
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: controller.scrolledToTop ? 0 : null,
              actionsIconTheme: IconThemeData(
                color: controller.selectedRoomIds.isEmpty
                    ? null
                    : Theme.of(context).colorScheme.primary,
              ),
              leading: Matrix.of(context).isMultiAccount
                  ? ClientChooserButton(controller)
                  : selectMode == SelectMode.normal
                      ? null
                      : IconButton(
                          tooltip: L10n.of(context)!.cancel,
                          icon: const Icon(Icons.close_outlined),
                          onPressed: controller.cancelAction,
                          color: Theme.of(context).colorScheme.primary,
                        ),
              centerTitle: false,
              actions: selectMode == SelectMode.share
                  ? null
                  : selectMode == SelectMode.select
                      ? [
                          if (controller.spaces.isNotEmpty)
                            IconButton(
                              tooltip: L10n.of(context)!.addToSpace,
                              icon: const Icon(Icons.group_work_outlined),
                              onPressed: controller.addOrRemoveToSpace,
                            ),
                          IconButton(
                            tooltip: L10n.of(context)!.toggleUnread,
                            icon: Icon(controller.anySelectedRoomNotMarkedUnread
                                ? Icons.mark_chat_read_outlined
                                : Icons.mark_chat_unread_outlined),
                            onPressed: controller.toggleUnread,
                          ),
                          IconButton(
                            tooltip: L10n.of(context)!.toggleFavorite,
                            icon: Icon(controller.anySelectedRoomNotFavorite
                                ? Icons.push_pin_outlined
                                : Icons.push_pin),
                            onPressed: controller.toggleFavouriteRoom,
                          ),
                          IconButton(
                            icon: Icon(controller.anySelectedRoomNotMuted
                                ? Icons.notifications_off_outlined
                                : Icons.notifications_outlined),
                            tooltip: L10n.of(context)!.toggleMuted,
                            onPressed: controller.toggleMuted,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outlined),
                            tooltip: L10n.of(context)!.archive,
                            onPressed: controller.archiveAction,
                          ),
                        ]
                      : [
                          KeyBoardShortcuts(
                            keysToPress: {
                              LogicalKeyboardKey.controlLeft,
                              LogicalKeyboardKey.keyF
                            },
                            onKeysPressed: () =>
                                VRouter.of(context).to('/search'),
                            helpLabel: L10n.of(context)!.search,
                            child: IconButton(
                              icon: const Icon(Icons.search_outlined),
                              tooltip: L10n.of(context)!.search,
                              onPressed: () =>
                                  VRouter.of(context).to('/search'),
                            ),
                          ),
                          if (selectMode == SelectMode.normal)
                            IconButton(
                              icon: const Icon(Icons.camera_alt_outlined),
                              tooltip: L10n.of(context)!.addToStory,
                              onPressed: () =>
                                  VRouter.of(context).to('/stories/create'),
                            ),
                          PopupMenuButton<PopupMenuAction>(
                            onSelected: controller.onPopupMenuSelect,
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: PopupMenuAction.setStatus,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.edit_outlined),
                                    const SizedBox(width: 12),
                                    Text(L10n.of(context)!.setStatus),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: PopupMenuAction.newGroup,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.group_add_outlined),
                                    const SizedBox(width: 12),
                                    Text(L10n.of(context)!.createNewGroup),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: PopupMenuAction.newSpace,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.group_work_outlined),
                                    const SizedBox(width: 12),
                                    Text(L10n.of(context)!.createNewSpace),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: PopupMenuAction.invite,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.share_outlined),
                                    const SizedBox(width: 12),
                                    Text(L10n.of(context)!.inviteContact),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: PopupMenuAction.archive,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.archive_outlined),
                                    const SizedBox(width: 12),
                                    Text(L10n.of(context)!.archive),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: PopupMenuAction.settings,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.settings_outlined),
                                    const SizedBox(width: 12),
                                    Text(L10n.of(context)!.settings),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
              title: Text(selectMode == SelectMode.share
                  ? L10n.of(context)!.share
                  : selectMode == SelectMode.select
                      ? controller.selectedRoomIds.length.toString()
                      : controller.activeSpaceId == null
                          ? AppConfig.applicationName
                          : Matrix.of(context)
                              .client
                              .getRoomById(controller.activeSpaceId!)!
                              .displayname),
            ),
            body: LayoutBuilder(
              builder: (context, size) {
                controller.snappingSheetContainerSize = size;
                return SnappingSheet(
                  key: ValueKey(Matrix.of(context).client.userID.toString() +
                      showSpaces.toString()),
                  controller: controller.snappingSheetController,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        height: controller.showChatBackupBanner ? 54 : 0,
                        duration: const Duration(milliseconds: 300),
                        clipBehavior: Clip.hardEdge,
                        curve: Curves.bounceInOut,
                        decoration: const BoxDecoration(),
                        child: Material(
                          color: Theme.of(context).colorScheme.surface,
                          child: ListTile(
                            leading: Image.asset(
                              'assets/backup.png',
                              fit: BoxFit.contain,
                              width: 44,
                            ),
                            title: Text(L10n.of(context)!.setupChatBackupNow),
                            trailing: const Icon(Icons.chevron_right_outlined),
                            onTap: controller.firstRunBootstrapAction,
                          ),
                        ),
                      ),
                      Expanded(child: ChatListViewBody(controller)),
                    ],
                  ),
                  initialSnappingPosition: showSpaces
                      ? const SnappingPosition.pixels(
                          positionPixels: kSpacesBottomBarHeight)
                      : const SnappingPosition.factor(positionFactor: 0.0),
                  snappingPositions: showSpaces
                      ? const [
                          SnappingPosition.pixels(
                              positionPixels: kSpacesBottomBarHeight),
                          SnappingPosition.factor(positionFactor: 0.5),
                          SnappingPosition.factor(positionFactor: 0.9),
                        ]
                      : [const SnappingPosition.factor(positionFactor: 0.0)],
                  sheetBelow: showSpaces
                      ? SnappingSheetContent(
                          childScrollController:
                              controller.snappingSheetScrollContentController,
                          draggable: true,
                          child: SpacesBottomBar(controller),
                        )
                      : null,
                );
              },
            ),
            floatingActionButton: selectMode == SelectMode.normal
                ? Padding(
                    padding: showSpaces
                        ? const EdgeInsets.only(bottom: 64.0)
                        : const EdgeInsets.all(0),
                    child: KeyBoardShortcuts(
                      child: FloatingActionButton.extended(
                        isExtended: controller.scrolledToTop,
                        onPressed: () =>
                            VRouter.of(context).to('/newprivatechat'),
                        icon: const Icon(CupertinoIcons.chat_bubble),
                        label: Text(L10n.of(context)!.newChat),
                      ),
                      keysToPress: {
                        LogicalKeyboardKey.controlLeft,
                        LogicalKeyboardKey.keyN
                      },
                      onKeysPressed: () =>
                          VRouter.of(context).to('/newprivatechat'),
                      helpLabel: L10n.of(context)!.newChat,
                    ),
                  )
                : null,
            bottomNavigationBar: const ConnectionStatusHeader(),
          ),
        );
      },
    );
  }
}

enum ChatListPopupMenuItemActions {
  createGroup,
  createSpace,
  discover,
  setStatus,
  inviteContact,
  settings,
}
