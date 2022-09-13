import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/widgets/avatar.dart';

class NavigationRailContent extends StatelessWidget {
  final List<Room> rootSpaces;
  final List<NavigationDestination> destinations;
  final ChatListController controller;
  final bool allowFullSizeDrawer;

  const NavigationRailContent({
    Key? key,
    required this.rootSpaces,
    required this.destinations,
    required this.controller,
    required this.allowFullSizeDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final count = rootSpaces.length + destinations.length;
    final listView = ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: count,
      itemBuilder: (context, i) {
        if (i < destinations.length) {
          final isSelected = i == controller.selectedIndex;
          return Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              border: Border(
                bottom: i == (destinations.length - 1)
                    ? BorderSide(
                        width: 1,
                        color: Theme.of(context).dividerColor,
                      )
                    : BorderSide.none,
                left: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  width: 4,
                ),
                right: const BorderSide(
                  color: Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: IconButton(
              color:
                  isSelected ? Theme.of(context).colorScheme.secondary : null,
              icon: CircleAvatar(
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.background,
                  foregroundColor: isSelected
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onBackground,
                  child: i == controller.selectedIndex
                      ? destinations[i].selectedIcon ?? destinations[i].icon
                      : destinations[i].icon),
              tooltip: destinations[i].label,
              onPressed: () => controller.onDestinationSelected(i),
            ),
          );
        }
        i -= destinations.length;
        final isSelected = controller.activeFilter == ActiveFilter.spaces &&
            rootSpaces[i].id == controller.activeSpaceId;
        return Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
                width: 4,
              ),
              right: const BorderSide(
                color: Colors.transparent,
                width: 4,
              ),
            ),
          ),
          alignment: Alignment.center,
          child: IconButton(
            tooltip: rootSpaces[i].displayname,
            icon: Avatar(
              mxContent: rootSpaces[i].avatar,
              name: rootSpaces[i].displayname,
              size: 32,
              fontSize: 12,
            ),
            onPressed: () => controller.setActiveSpace(rootSpaces[i].id),
          ),
        );
      },
    );
    if (allowFullSizeDrawer) {
      return Column(
        children: [
          Expanded(child: listView),
          Container(
            height: 64,
            width: 64,
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: IconButton(
                color: Theme.of(context).colorScheme.onSecondary,
                tooltip: L10n.of(context)!.allSpaces,
                onPressed: controller.toggleDesktopDrawer,
                icon: const Icon(Icons.arrow_right),
              ),
            ),
          ),
        ],
      );
    } else {
      return listView;
    }
  }
}
