import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/navi_rail_item.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SpacesNavigationRail extends StatelessWidget {
  final String? activeSpaceId;
  final void Function() onGoToChats;
  final void Function(String) onGoToSpaceId;

  const SpacesNavigationRail({
    required this.activeSpaceId,
    required this.onGoToChats,
    required this.onGoToSpaceId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final isSettings = GoRouter.of(context)
        .routeInformationProvider
        .value
        .uri
        .path
        .startsWith('/rooms/settings');
    return Material(
      child: SafeArea(
        child: StreamBuilder(
          key: ValueKey(
            client.userID.toString(),
          ),
          stream: client.onSync.stream
              .where((s) => s.hasRoomUpdate)
              .rateLimit(const Duration(seconds: 1)),
          builder: (context, _) {
            final allSpaces = client.rooms.where((room) => room.isSpace);
            final rootSpaces = allSpaces
                .where(
                  (space) => !allSpaces.any(
                    (parentSpace) => parentSpace.spaceChildren
                        .any((child) => child.roomId == space.id),
                  ),
                )
                .toList();

            return SizedBox(
              width: FluffyThemes.isColumnMode(context)
                  ? FluffyThemes.navRailWidth
                  : FluffyThemes.navRailWidth * 0.75,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: rootSpaces.length + 2,
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return NaviRailItem(
                            isSelected: activeSpaceId == null && !isSettings,
                            onTap: onGoToChats,
                            icon: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.forum_outlined),
                            ),
                            selectedIcon: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(Icons.forum),
                            ),
                            toolTip: L10n.of(context).chats,
                            unreadBadgeFilter: (room) => true,
                          );
                        }
                        i--;
                        if (i == rootSpaces.length) {
                          return NaviRailItem(
                            isSelected: false,
                            onTap: () => context.go('/rooms/newspace'),
                            icon: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.add),
                            ),
                            toolTip: L10n.of(context).createNewSpace,
                          );
                        }
                        final space = rootSpaces[i];
                        final displayname =
                            rootSpaces[i].getLocalizedDisplayname(
                          MatrixLocals(L10n.of(context)),
                        );
                        final spaceChildrenIds =
                            space.spaceChildren.map((c) => c.roomId).toSet();
                        return NaviRailItem(
                          toolTip: displayname,
                          isSelected: activeSpaceId == space.id,
                          onTap: () => onGoToSpaceId(rootSpaces[i].id),
                          unreadBadgeFilter: (room) =>
                              spaceChildrenIds.contains(room.id),
                          icon: Avatar(
                            mxContent: rootSpaces[i].avatar,
                            name: displayname,
                            border: BorderSide(
                              width: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConfig.borderRadius / 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  NaviRailItem(
                    isSelected: isSettings,
                    onTap: () => context.go('/rooms/settings'),
                    icon: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.settings_outlined),
                    ),
                    selectedIcon: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.settings),
                    ),
                    toolTip: L10n.of(context).settings,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
