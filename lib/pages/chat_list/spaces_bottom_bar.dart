import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SpacesBottomBar extends StatelessWidget {
  final ChatListController controller;
  const SpacesBottomBar(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex = controller.activeSpaceId == null
        ? 0
        : controller.spaces
                .indexWhere((space) => controller.activeSpaceId == space.id) +
            1;
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 6,
      child: StreamBuilder<Object>(
          stream: Matrix.of(context).client.onSync.stream.where((sync) =>
              (sync.rooms?.join?.values?.any((r) =>
                      r.state?.any((s) => s.type.startsWith('m.space'))) ??
                  false) ||
              (sync.rooms?.leave?.isNotEmpty ?? false)),
          builder: (context, snapshot) {
            return SalomonBottomBar(
              itemPadding: const EdgeInsets.all(8),
              currentIndex: currentIndex,
              onTap: (i) => controller.setActiveSpaceId(
                context,
                i == 0 ? null : controller.spaces[i - 1].id,
              ),
              selectedItemColor: Theme.of(context).colorScheme.primary,
              items: [
                SalomonBottomBarItem(
                  icon: const Icon(CupertinoIcons.chat_bubble_2),
                  activeIcon: const Icon(CupertinoIcons.chat_bubble_2_fill),
                  title: Text(L10n.of(context).allChats),
                ),
                ...controller.spaces
                    .map((space) => SalomonBottomBarItem(
                          icon: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: () => controller.setActiveSpaceId(
                              context,
                              space.id,
                            ),
                            onLongPress: () =>
                                controller.editSpace(context, space.id),
                            child: Avatar(
                              space.avatar,
                              space.displayname,
                              size: 24,
                              fontSize: 12,
                            ),
                          ),
                          title: Text(space.displayname),
                        ))
                    .toList(),
              ],
            );
          }),
    );
  }
}
