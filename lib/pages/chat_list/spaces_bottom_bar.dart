import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/widgets/avatar.dart';

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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
      onTap: (i) => controller.setActiveSpaceId(
        context,
        i == 0 ? null : controller.spaces[i - 1].id,
      ),
      items: [
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          icon: const Icon(CupertinoIcons.chat_bubble_2),
          label: L10n.of(context).allChats,
        ),
        ...controller.spaces
            .map((space) => BottomNavigationBarItem(
                  icon: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: () => controller.setActiveSpaceId(
                      context,
                      space.id,
                    ),
                    onLongPress: () => controller.editSpace(context, space.id),
                    child: Avatar(
                      space.avatar,
                      space.displayname,
                      size: 24,
                      fontSize: 12,
                    ),
                  ),
                  label: space.displayname,
                ))
            .toList(),
      ],
    );
  }
}
