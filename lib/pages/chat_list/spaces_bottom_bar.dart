import 'package:flutter/material.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/spaces_entry.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SpacesBottomBar extends StatelessWidget {
  final ChatListController controller;
  const SpacesBottomBar(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foundIndex = controller.spacesEntries.indexWhere(
        (se) => spacesEntryRoughEquivalence(se, controller.activeSpacesEntry));
    final currentIndex = foundIndex == -1 ? 0 : foundIndex;
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 6,
      child: SafeArea(
        child: StreamBuilder<Object>(
            stream: Matrix.of(context).client.onSync.stream.where((sync) =>
                (sync.rooms?.join?.values.any((r) =>
                        r.state?.any((s) => s.type.startsWith('m.space')) ??
                        false) ??
                    false) ||
                (sync.rooms?.leave?.isNotEmpty ?? false)),
            builder: (context, snapshot) {
              return Container(
                height: 56,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SalomonBottomBar(
                    itemPadding: const EdgeInsets.all(8),
                    currentIndex: currentIndex,
                    onTap: (i) => controller.setActiveSpacesEntry(
                      context,
                      controller.spacesEntries[i],
                    ),
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    items: controller.spacesEntries
                        .map((entry) => _buildSpacesEntryUI(context, entry))
                        .toList(),
                  ),
                ),
              );
            }),
      ),
    );
  }

  SalomonBottomBarItem _buildSpacesEntryUI(
      BuildContext context, SpacesEntry entry) {
    final space = entry.getSpace(context);
    if (space != null) {
      return SalomonBottomBarItem(
        icon: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => controller.setActiveSpacesEntry(
            context,
            entry,
          ),
          onLongPress: () => controller.editSpace(context, space.id),
          child: Avatar(
            mxContent: space.avatar,
            name: space.displayname,
            size: 24,
            fontSize: 12,
          ),
        ),
        title: Text(entry.getName(context)),
      );
    }
    return SalomonBottomBarItem(
      icon: entry.getIcon(false),
      activeIcon: entry.getIcon(true),
      title: Text(entry.getName(context)),
    );
  }
}
