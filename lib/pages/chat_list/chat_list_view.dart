import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/navi_rail_item.dart';
import 'package:fluffychat/pangea/chat_list/widgets/chat_list_view_body_wrapper.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import '../../widgets/matrix.dart';

class ChatListView extends StatelessWidget {
  final ChatListController controller;

  const ChatListView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    return PopScope(
      canPop: !controller.isSearchMode && controller.activeSpaceId == null,
      onPopInvokedWithResult: (pop, _) {
        if (pop) return;
        if (controller.activeSpaceId != null) {
          controller.clearActiveSpace();
          return;
        }
        if (controller.isSearchMode) {
          controller.cancelSearch();
          return;
        }
      },
      child: Row(
        children: [
          if (FluffyThemes.isColumnMode(context) &&
              controller.widget.displayNavigationRail) ...[
            StreamBuilder(
              key: ValueKey(
                client.userID.toString(),
              ),
              stream: client.onSync.stream
                  .where((s) => s.hasRoomUpdate)
                  .rateLimit(const Duration(seconds: 1)),
              builder: (context, _) {
                final allSpaces = Matrix.of(context)
                    .client
                    .rooms
                    .where((room) => room.isSpace);
                final rootSpaces = allSpaces
                    .where(
                      (space) => !allSpaces.any(
                        (parentSpace) => parentSpace.spaceChildren
                            .any((child) => child.roomId == space.id),
                      ),
                    )
                    .toList();

                return SizedBox(
                  width: FluffyThemes.navRailWidth,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: rootSpaces.length + 2,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return NaviRailItem(
                          isSelected: controller.activeSpaceId == null,
                          onTap: controller.clearActiveSpace,
                          icon: const Icon(Icons.forum_outlined),
                          selectedIcon: const Icon(Icons.forum),
                          toolTip: L10n.of(context).chats,
                          unreadBadgeFilter: (room) => true,
                        );
                      }
                      i--;
                      if (i == rootSpaces.length) {
                        return NaviRailItem(
                          isSelected: false,
                          onTap: () => context.go('/rooms/newspace'),
                          icon: const Icon(Icons.add),
                          toolTip: L10n.of(context).createNewSpace,
                        );
                      }
                      final space = rootSpaces[i];
                      final displayname = rootSpaces[i].getLocalizedDisplayname(
                        MatrixLocals(L10n.of(context)),
                      );
                      final spaceChildrenIds =
                          space.spaceChildren.map((c) => c.roomId).toSet();
                      return NaviRailItem(
                        toolTip: displayname,
                        isSelected: controller.activeSpaceId == space.id,
                        onTap: () =>
                            controller.setActiveSpace(rootSpaces[i].id),
                        unreadBadgeFilter: (room) =>
                            spaceChildrenIds.contains(room.id),
                        icon: Avatar(
                          mxContent: rootSpaces[i].avatar,
                          name: displayname,
                          // #Pangea
                          presenceUserId: space.directChatMatrixID,
                          // Pangea#
                          size: 32,
                          borderRadius: BorderRadius.circular(
                            AppConfig.borderRadius / 4,
                          ),
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
                // #Pangea
                // body: ChatListViewBody(controller),
                body: ChatListViewBodyWrapper(controller: controller),
                // Pangea#
                floatingActionButton:
                    !controller.isSearchMode && controller.activeSpaceId == null
                        ? FloatingActionButton.extended(
                            // #Pangea
                            // onPressed: () => context.go('/rooms/newprivatechat'),
                            onPressed: () => context.go('/rooms/newgroup'),
                            // Pangea#
                            icon: const Icon(Icons.add_outlined),
                            label: Text(
                              L10n.of(context).chat,
                              overflow: TextOverflow.fade,
                            ),
                          )
                        : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
