import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/navi_rail_item.dart';
import 'package:fluffychat/pangea/chat_list/utils/chat_list_handle_space_tap.dart';
import 'package:fluffychat/pangea/course_plans/map_clipper.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SpacesNavigationRail extends StatelessWidget {
  final String? activeSpaceId;
  // #Pangea
  // final void Function() onGoToChats;
  // final void Function(String) onGoToSpaceId;
  final String? path;
  // Pangea#

  const SpacesNavigationRail({
    required this.activeSpaceId,
    // #Pangea
    // required this.onGoToChats,
    // required this.onGoToSpaceId,
    required this.path,
    // Pangea#
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
    // #Pangea
    final isAnalytics = path?.contains('analytics') ?? false;
    final isCommunities = path?.contains('communities') ?? false;
    final isColumnMode = FluffyThemes.isColumnMode(context);

    final width = isColumnMode
        ? FluffyThemes.navRailWidth
        : FluffyThemes.navRailWidth - 8.0;
    // return StreamBuilder(
    return Material(
      child: SafeArea(
        child: StreamBuilder(
          // Pangea#
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
              // #Pangea
              // width: FluffyThemes.navRailWidth,
              width: width,
              // Pangea#
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      // #Pangea
                      // itemCount: rootSpaces.length + 2,
                      itemCount: rootSpaces.length + 3,
                      // Pangea#
                      itemBuilder: (context, i) {
                        // #Pangea
                        if (i == 0) {
                          return NaviRailItem(
                            isSelected: isAnalytics,
                            onTap: () {
                              context.go("/rooms/analytics");
                            },
                            backgroundColor: Colors.transparent,
                            icon: FutureBuilder<Profile>(
                              future: client.fetchOwnProfile(),
                              builder: (context, snapshot) => Stack(
                                alignment: Alignment.center,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(99),
                                    child: Avatar(
                                      mxContent: snapshot.data?.avatarUrl,
                                      name: snapshot.data?.displayName ??
                                          client.userID!.localpart,
                                      size:
                                          width - (isColumnMode ? 32.0 : 24.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            toolTip: L10n.of(context).home,
                          );
                        }
                        i--;
                        // Pangea#
                        if (i == 0) {
                          return NaviRailItem(
                            // #Pangea
                            // isSelected: activeSpaceId == null && !isSettings,
                            isSelected: activeSpaceId == null &&
                                !isSettings &&
                                !isAnalytics &&
                                !isCommunities,
                            // onTap: onGoToChats,
                            // icon: const Padding(
                            //   padding: EdgeInsets.all(10.0),
                            //   child: Icon(Icons.forum_outlined),
                            // ),
                            // selectedIcon: const Padding(
                            //   padding: EdgeInsets.all(10.0),
                            //   child: Icon(Icons.forum),
                            // ),
                            // toolTip: L10n.of(context).chats,
                            // unreadBadgeFilter: (room) => true,
                            icon: const Icon(Icons.forum_outlined),
                            selectedIcon: const Icon(Icons.forum),
                            onTap: () => context.go("/rooms"),
                            toolTip: L10n.of(context).directMessages,
                            unreadBadgeFilter: (room) =>
                                room.firstSpaceParent == null,
                            // Pangea#
                          );
                        }
                        i--;
                        if (i == rootSpaces.length) {
                          return NaviRailItem(
                            // #Pangea
                            // isSelected: false,
                            // onTap: () => context.go('/rooms/newspace'),
                            // icon: const Padding(
                            //   padding: EdgeInsets.all(8.0),
                            //   child: Icon(Icons.add),
                            // ),
                            // toolTip: L10n.of(context).createNewSpace,
                            backgroundColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(0),
                            isSelected: isCommunities,
                            onTap: () {
                              context.go('/rooms/communities');
                            },
                            icon: ClipPath(
                              clipper: MapClipper(),
                              child: Container(
                                width: width - (isColumnMode ? 32.0 : 24.0),
                                height: width - (isColumnMode ? 32.0 : 24.0),
                                color: isCommunities
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHigh,
                                child: const Icon(Icons.add),
                              ),
                            ),
                            toolTip: L10n.of(context).findCourse,
                            // Pangea#
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
                          // #Pangea
                          backgroundColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(0),
                          // onTap: () => onGoToSpaceId(rootSpaces[i].id),
                          onTap: () {
                            final room = client.getRoomById(rootSpaces[i].id);
                            if (room != null) {
                              chatListHandleSpaceTap(
                                context,
                                room,
                              );
                            } else {
                              context.go(
                                "/rooms/spaces/${rootSpaces[i].id}/details",
                              );
                            }
                          },
                          // Pangea#
                          unreadBadgeFilter: (room) =>
                              spaceChildrenIds.contains(room.id),
                          // #Pangea
                          // icon: Avatar(
                          //   mxContent: rootSpaces[i].avatar,
                          //   name: displayname,
                          //   border: BorderSide(
                          //     width: 1,
                          //     color: Theme.of(context).dividerColor,
                          //   ),
                          //   borderRadius: BorderRadius.circular(
                          //     AppConfig.borderRadius / 2,
                          //   ),
                          // ),
                          icon: ClipPath(
                            clipper: MapClipper(),
                            child: Avatar(
                              mxContent: rootSpaces[i].avatar,
                              name: displayname,
                              border: BorderSide(
                                width: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(0),
                              size: width - (isColumnMode ? 32.0 : 24.0),
                            ),
                          ),
                          // Pangea#
                        );
                      },
                    ),
                  ),
                  NaviRailItem(
                    isSelected: isSettings,
                    onTap: () => context.go('/rooms/settings'),
                    // #Pangea
                    // icon: const Padding(
                    //   padding: EdgeInsets.all(10.0),
                    //   child: Icon(Icons.settings_outlined),
                    // ),
                    // selectedIcon: const Padding(
                    //   padding: EdgeInsets.all(10.0),
                    //   child: Icon(Icons.settings),
                    // ),
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    // Pangea#
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
