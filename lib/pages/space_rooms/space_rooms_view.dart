// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/unread_bubble.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';
import 'space_rooms.dart';

class SpaceRoomsView extends StatelessWidget {
  final SpaceRoomsController controller;

  const SpaceRoomsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final spaceId = controller.spaceId;
    final visibleChildren = controller.visibleChildren;
    final filterController = controller.filterController;
    final noMoreRooms = controller.noMoreRooms;
    final isLoading = controller.isLoading;

    final room = spaceId != null
        ? Matrix.of(context).client.getRoomById(spaceId)
        : null;
    const avatarSize = Avatar.defaultSize / 1.5;
    final isAdmin = room?.canChangeStateEvent(EventTypes.SpaceChild) == true;
    final displayname =
        room?.getLocalizedDisplayname() ?? L10n.of(context).nothingFound;
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(displayname),
      ),
      body: MaxWidthBody(
        withScrolling: false,
        innerPadding: const EdgeInsets.symmetric(vertical: 8),
        child: room == null
            ? const Center(child: Icon(Icons.search_outlined, size: 80))
            : StreamBuilder(
                stream: room.client.onSync.stream
                    .where((s) => s.hasRoomUpdate)
                    .rateLimit(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        scrolledUnderElevation: 0,
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        title: TextField(
                          controller: filterController,
                          onChanged: (_) => controller.setFilter(),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: theme.colorScheme.secondaryContainer,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            contentPadding: EdgeInsets.zero,
                            hintText: L10n.of(context).search,
                            hintStyle: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.normal,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.search_outlined,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverList.builder(
                        itemCount: visibleChildren.length + 1,
                        itemBuilder: (context, i) {
                          if (i == visibleChildren.length) {
                            if (noMoreRooms) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 2.0,
                              ),
                              child: TextButton(
                                onPressed: isLoading
                                    ? null
                                    : controller.loadHierarchy,
                                child: isLoading
                                    ? const CircularProgressIndicator.adaptive()
                                    : Text(L10n.of(context).loadMore),
                              ),
                            );
                          }
                          final item = visibleChildren[i];
                          var joinedRoom = room.client.getRoomById(item.roomId);
                          final displayname =
                              item.name ??
                              item.canonicalAlias ??
                              joinedRoom?.getLocalizedDisplayname() ??
                              L10n.of(context).emptyChat;
                          final avatarUrl =
                              item.avatarUrl ?? joinedRoom?.avatar;
                          if (joinedRoom?.membership == Membership.leave) {
                            joinedRoom = null;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 1,
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(
                                AppConfig.borderRadius,
                              ),
                              clipBehavior: Clip.hardEdge,
                              color: Colors.transparent,
                              child: HoverBuilder(
                                builder: (context, hovered) => ListTile(
                                  visualDensity: const VisualDensity(
                                    vertical: -0.5,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                    left: 8,
                                    right: joinedRoom == null ? 0 : 8,
                                  ),
                                  onTap: joinedRoom != null
                                      ? () => controller.onChatTap(joinedRoom!)
                                      : null,
                                  onLongPress: joinedRoom != null
                                      ? () => controller.showSpaceChildEditMenu(
                                          context,
                                          item.roomId,
                                        )
                                      : null,
                                  leading: hovered
                                      ? SizedBox.square(
                                          dimension: avatarSize,
                                          child: IconButton(
                                            splashRadius: avatarSize,
                                            iconSize: 14,
                                            style: IconButton.styleFrom(
                                              foregroundColor: theme
                                                  .colorScheme
                                                  .onTertiaryContainer,
                                              backgroundColor: theme
                                                  .colorScheme
                                                  .tertiaryContainer,
                                            ),
                                            onPressed:
                                                isAdmin || joinedRoom != null
                                                ? () => controller
                                                      .showSpaceChildEditMenu(
                                                        context,
                                                        item.roomId,
                                                      )
                                                : null,
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                            ),
                                          ),
                                        )
                                      : Avatar(
                                          size: avatarSize,
                                          mxContent: avatarUrl,
                                          name: '#',
                                          backgroundColor: theme
                                              .colorScheme
                                              .surfaceContainer,
                                          textColor:
                                              item.name?.darkColor ??
                                              theme.colorScheme.onSurface,
                                          shapeBorder:
                                              item.roomType == 'm.space'
                                              ? RoundedSuperellipseBorder(
                                                  side: BorderSide(
                                                    color: theme
                                                        .colorScheme
                                                        .surfaceContainerHighest,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        AppConfig.borderRadius /
                                                            4,
                                                      ),
                                                )
                                              : null,
                                          borderRadius:
                                              item.roomType == 'm.space'
                                              ? BorderRadius.circular(
                                                  AppConfig.borderRadius / 4,
                                                )
                                              : null,
                                        ),
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Opacity(
                                          opacity: joinedRoom == null ? 0.5 : 1,
                                          child: Text(
                                            displayname,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      if (joinedRoom != null &&
                                          joinedRoom.pushRuleState !=
                                              PushRuleState.notify)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                          child: Icon(
                                            Icons.notifications_off_outlined,
                                            size: 16,
                                          ),
                                        ),
                                      if (joinedRoom != null)
                                        UnreadBubble(room: joinedRoom)
                                      else
                                        TextButton(
                                          onPressed: () =>
                                              controller.joinChildRoom(item),
                                          child: Text(L10n.of(context).join),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SliverPadding(padding: EdgeInsets.only(top: 32)),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
