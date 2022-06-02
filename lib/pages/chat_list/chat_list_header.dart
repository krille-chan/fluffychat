import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/client_chooser_button.dart';
import '../../widgets/matrix.dart';

class ChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatListController controller;

  const ChatListHeader({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectMode = controller.selectMode;

    return AppBar(
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
                    onKeysPressed: () => VRouter.of(context).to('/search'),
                    helpLabel: L10n.of(context)!.search,
                    child: IconButton(
                      icon: const Icon(Icons.search_outlined),
                      tooltip: L10n.of(context)!.search,
                      onPressed: () => VRouter.of(context).to('/search'),
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
      title: PageTransitionSwitcher(
        reverse: false,
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            fillColor: Colors.transparent,
            child: child,
          );
        },
        layoutBuilder: (children) => Stack(
          alignment: AlignmentDirectional.centerStart,
          children: children,
        ),
        child: selectMode == SelectMode.share
            ? Text(
                L10n.of(context)!.share,
                key: const ValueKey(SelectMode.share),
              )
            : selectMode == SelectMode.select
                ? Text(
                    controller.selectedRoomIds.length.toString(),
                    key: const ValueKey(SelectMode.select),
                  )
                : (() {
                    final name = controller.activeSpaceId == null
                        ? AppConfig.applicationName
                        : Matrix.of(context)
                            .client
                            .getRoomById(controller.activeSpaceId!)!
                            .displayname;
                    return Text(name, key: ValueKey(name));
                  })(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
