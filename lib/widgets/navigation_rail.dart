import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/navi_rail_item.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SpacesNavigationRail extends StatelessWidget {
  final String? activeSpaceId;
  final void Function() onGoToChats;
  final void Function(String) onGoToSpaceId;
  // #Pangea
  final void Function()? clearActiveSpace;
  // Pangea#

  const SpacesNavigationRail({
    required this.activeSpaceId,
    required this.onGoToChats,
    required this.onGoToSpaceId,
    // #Pangea
    this.clearActiveSpace,
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
    final path = GoRouter.of(context).routeInformationProvider.value.uri.path;
    final isHomepage = path.contains('homepage');
    final isCommunities = path.contains('communities');
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
                            isSelected: isColumnMode
                                ? activeSpaceId == null &&
                                    !isSettings &&
                                    !isCommunities
                                : isHomepage,
                            onTap: () {
                              if (isColumnMode) {
                                onGoToChats();
                              } else {
                                clearActiveSpace?.call();
                                context.go("/rooms/homepage");
                              }
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
                          return isColumnMode
                              ? const SizedBox()
                              : NaviRailItem(
                                  // #Pangea
                                  // isSelected: activeSpaceId == null && !isSettings,
                                  isSelected: activeSpaceId == null &&
                                      !isSettings &&
                                      !isHomepage &&
                                      !isCommunities,
                                  // Pangea#
                                  onTap: onGoToChats,
                                  // #Pangea
                                  // icon: const Padding(
                                  //   padding: EdgeInsets.all(10.0),
                                  //   child: Icon(Icons.forum_outlined),
                                  // ),
                                  // selectedIcon: const Padding(
                                  //   padding: EdgeInsets.all(10.0),
                                  //   child: Icon(Icons.forum),
                                  // ),
                                  icon: const Icon(Icons.forum_outlined),
                                  selectedIcon: const Icon(Icons.forum),
                                  // Pangea#
                                  toolTip: L10n.of(context).chats,
                                  unreadBadgeFilter: (room) => true,
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
                            isSelected: isCommunities,
                            onTap: () {
                              clearActiveSpace?.call();
                              context.go('/rooms/communities');
                            },
                            icon: const Icon(Icons.groups),
                            toolTip: L10n.of(context).findYourPeople,
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
                            // #Pangea
                            size: width - (isColumnMode ? 32.0 : 24.0),
                            // Pangea#
                          ),
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
