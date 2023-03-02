import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:badges/badges.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/navi_rail_item.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/unread_rooms_badge.dart';
import '../../widgets/matrix.dart';
import 'chat_list_body.dart';
import 'chat_list_header.dart';
import 'start_chat_fab.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {Key? key}) : super(key: key);

  List<NavigationDestination> getNavigationDestinations(BuildContext context) {
    final badgePosition = BadgePosition.topEnd(top: -12, end: -8);
    return [
      if (AppConfig.separateChatTypes) ...[
        NavigationDestination(
          icon: UnreadRoomsBadge(
            badgePosition: badgePosition,
            filter: controller.getRoomFilterByActiveFilter(ActiveFilter.groups),
            child: const Icon(Icons.groups_outlined),
          ),
          selectedIcon: UnreadRoomsBadge(
            badgePosition: badgePosition,
            filter: controller.getRoomFilterByActiveFilter(ActiveFilter.groups),
            child: const Icon(Icons.groups),
          ),
          label: L10n.of(context)!.groups,
        ),
        NavigationDestination(
          icon: UnreadRoomsBadge(
            badgePosition: badgePosition,
            filter:
                controller.getRoomFilterByActiveFilter(ActiveFilter.messages),
            child: const Icon(Icons.chat_outlined),
          ),
          selectedIcon: UnreadRoomsBadge(
            badgePosition: badgePosition,
            filter:
                controller.getRoomFilterByActiveFilter(ActiveFilter.messages),
            child: const Icon(Icons.chat),
          ),
          label: L10n.of(context)!.messages,
        ),
      ] else
        NavigationDestination(
          icon: UnreadRoomsBadge(
            badgePosition: badgePosition,
            filter:
                controller.getRoomFilterByActiveFilter(ActiveFilter.allChats),
            child: const Icon(Icons.chat_outlined),
          ),
          selectedIcon: UnreadRoomsBadge(
            badgePosition: badgePosition,
            filter:
                controller.getRoomFilterByActiveFilter(ActiveFilter.allChats),
            child: const Icon(Icons.chat),
          ),
          label: L10n.of(context)!.chats,
        ),
      if (controller.spaces.isNotEmpty)
        const NavigationDestination(
          icon: Icon(Icons.workspaces_outlined),
          selectedIcon: Icon(Icons.workspaces),
          label: 'Spaces',
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    return StreamBuilder<Object?>(
      stream: Matrix.of(context).onShareContentChanged.stream,
      builder: (_, __) {
        final selectMode = controller.selectMode;
        return VWidgetGuard(
          onSystemPop: (redirector) async {
            final selMode = controller.selectMode;
            if (selMode != SelectMode.normal) {
              controller.cancelAction();
              redirector.stopRedirection();
              return;
            }
            if (controller.activeFilter !=
                (AppConfig.separateChatTypes
                    ? ActiveFilter.messages
                    : ActiveFilter.allChats)) {
              controller
                  .onDestinationSelected(AppConfig.separateChatTypes ? 1 : 0);
              redirector.stopRedirection();
              return;
            }
          },
          child: Row(
            children: [
              if (FluffyThemes.isColumnMode(context) &&
                  FluffyThemes.getDisplayNavigationRail(context)) ...[
                Builder(
                  builder: (context) {
                    final allSpaces =
                        client.rooms.where((room) => room.isSpace);
                    final rootSpaces = allSpaces
                        .where(
                          (space) => !allSpaces.any(
                            (parentSpace) => parentSpace.spaceChildren
                                .any((child) => child.roomId == space.id),
                          ),
                        )
                        .toList();
                    final destinations = getNavigationDestinations(context);

                    return SizedBox(
                      width: 64,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: rootSpaces.length + destinations.length,
                        itemBuilder: (context, i) {
                          if (i < destinations.length) {
                            return NaviRailItem(
                              isSelected: i == controller.selectedIndex,
                              onTap: () => controller.onDestinationSelected(i),
                              icon: destinations[i].icon,
                              selectedIcon: destinations[i].selectedIcon,
                              toolTip: destinations[i].label,
                            );
                          }
                          i -= destinations.length;
                          final isSelected =
                              controller.activeFilter == ActiveFilter.spaces &&
                                  rootSpaces[i].id == controller.activeSpaceId;
                          return NaviRailItem(
                            toolTip: rootSpaces[i].getLocalizedDisplayname(
                              MatrixLocals(L10n.of(context)!),
                            ),
                            isSelected: isSelected,
                            onTap: () =>
                                controller.setActiveSpace(rootSpaces[i].id),
                            icon: Avatar(
                              mxContent: rootSpaces[i].avatar,
                              name: rootSpaces[i].getLocalizedDisplayname(
                                MatrixLocals(L10n.of(context)!),
                              ),
                              size: 32,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                Container(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ],
              Expanded(
                child: GestureDetector(
                  onTap: FocusManager.instance.primaryFocus?.unfocus,
                  excludeFromSemantics: true,
                  behavior: HitTestBehavior.translucent,
                  child: Scaffold(
                    appBar: ChatListHeader(controller: controller),
                    body: ChatListViewBody(controller),
                    bottomNavigationBar: controller.displayNavigationBar
                        ? NavigationBar(
                            height: 64,
                            selectedIndex: controller.selectedIndex,
                            onDestinationSelected:
                                controller.onDestinationSelected,
                            destinations: getNavigationDestinations(context),
                          )
                        : null,
                    floatingActionButtonLocation:
                        controller.filteredRooms.isEmpty
                            ? FloatingActionButtonLocation.centerFloat
                            : null,
                    floatingActionButton: selectMode == SelectMode.normal
                        ? KeyBoardShortcuts(
                            keysToPress: {
                              LogicalKeyboardKey.controlLeft,
                              LogicalKeyboardKey.keyN
                            },
                            onKeysPressed: () =>
                                VRouter.of(context).to('/newprivatechat'),
                            helpLabel: L10n.of(context)!.newChat,
                            child: StartChatFloatingActionButton(
                              controller: controller,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
