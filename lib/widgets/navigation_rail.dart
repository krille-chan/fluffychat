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
import 'package:url_launcher/url_launcher.dart';

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

            return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: SizedBox(
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
                                isSelected:
                                    activeSpaceId == null && !isSettings,
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
                            // if (i == rootSpaces.length) {
                            //   return NaviRailItem(
                            //     isSelected: false,
                            //     onTap: () => context.go('/rooms/newspace'),
                            //     icon: const Padding(
                            //       padding: EdgeInsets.all(8.0),
                            //       child: Icon(Icons.add),
                            //     ),
                            //     toolTip: L10n.of(context).createNewSpace,
                            //   );
                            // }
                            // final space = rootSpaces[i];
                            // final displayname =
                            //     rootSpaces[i].getLocalizedDisplayname(
                            //   MatrixLocals(L10n.of(context)),
                            // );
                            // final spaceChildrenIds = space.spaceChildren
                            //     .map((c) => c.roomId)
                            //     .toSet();
                            // return NaviRailItem(
                            //   toolTip: displayname,
                            //   isSelected: activeSpaceId == space.id,
                            //   onTap: () => onGoToSpaceId(rootSpaces[i].id),
                            //   unreadBadgeFilter: (room) =>
                            //       spaceChildrenIds.contains(room.id),
                            //   icon: Avatar(
                            //     mxContent: rootSpaces[i].avatar,
                            //     name: displayname,
                            //     border: BorderSide(
                            //       width: 1,
                            //       color: Theme.of(context).dividerColor,
                            //     ),
                            //     borderRadius: BorderRadius.circular(
                            //       AppConfig.borderRadius / 2,
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                      ),
                      NaviRailItem(
                        toolTip: 'Links',
                        isSelected: false,
                        onTap: () {},
                        icon: PopupMenuButton<_LinksMenuAction>(
                          useRootNavigator: true,
                          icon: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.link_outlined,
                              color: Theme.of(context).colorScheme.onTertiary,
                            ),
                          ),
                          onSelected: (action) async {
                            switch (action) {
                              case _LinksMenuAction.store:
                                final uri = Uri.parse(
                                  'https://www.radiohemp.com/loja/',
                                );
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                                break;
                              case _LinksMenuAction.course:
                                final uri = Uri.parse(
                                  'https://www.radiohemp.com/produto/como-plantar-maconha-medicinal/',
                                );
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              case _LinksMenuAction.news:
                                final uri = Uri.parse(
                                  'https://www.radiohemp.com/blog/',
                                );
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              case _LinksMenuAction.podcasts:
                                final uri = Uri.parse(
                                  'https://www.radiohemp.com/podcast/',
                                );
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: _LinksMenuAction.store,
                              child: Text(L10n.of(context).menuStore),
                            ),
                            PopupMenuItem(
                              value: _LinksMenuAction.course,
                              child: Text(L10n.of(context).menuCourse),
                            ),
                            PopupMenuItem(
                              value: _LinksMenuAction.news,
                              child: Text(L10n.of(context).menuNews),
                            ),
                            PopupMenuItem(
                              value: _LinksMenuAction.podcasts,
                              child: Text(L10n.of(context).menuPodcasts),
                            ),
                          ],
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
                ));
          },
        ),
      ),
    );
  }
}

enum _LinksMenuAction { store, course, news, podcasts }
