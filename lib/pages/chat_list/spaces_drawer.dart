import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'chat_list.dart';
import 'spaces_drawer_entry.dart';

class SpacesDrawer extends StatelessWidget {
  final ChatListController controller;
  final List<Room> rootSpaces;
  final List<NavigationDestination> destinations;

  const SpacesDrawer({
    Key? key,
    required this.controller,
    required this.rootSpaces,
    required this.destinations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacesHierarchy = controller.spaces
        .map((e) =>
            SpacesEntryMaybeChildren.buildIfTopLevel(e, controller.spaces))
        .whereNotNull()
        .toList();

    final filteredDestinations = destinations;
    filteredDestinations
        .removeWhere((element) => element.label == L10n.of(context)!.spaces);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: spacesHierarchy.length + filteredDestinations.length,
            itemBuilder: (context, i) {
              if (i < filteredDestinations.length) {
                final isSelected = i == controller.selectedIndex;
                return Container(
                  height: 64,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: i == (filteredDestinations.length - 1)
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
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.background,
                        foregroundColor: isSelected
                            ? Theme.of(context).colorScheme.onSecondary
                            : Theme.of(context).colorScheme.onBackground,
                        child: i == controller.selectedIndex
                            ? filteredDestinations[i].selectedIcon ??
                                filteredDestinations[i].icon
                            : filteredDestinations[i].icon),
                    title: Text(filteredDestinations[i].label),
                    onTap: () => controller.onDestinationSelected(i),
                  ),
                );
              } else {
                i -= filteredDestinations.length;
              }
              final space = spacesHierarchy[i];
              return SpacesDrawerEntry(
                entry: space,
                controller: controller,
              );
            },
          ),
        ),
        Container(
          height: 64,
          width: 64,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              child: IconButton(
                tooltip: L10n.of(context)!.allSpaces,
                color: Theme.of(context).colorScheme.onSecondary,
                onPressed: controller.toggleDesktopDrawer,
                icon: const Icon(Icons.arrow_left),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SpacesEntryMaybeChildren {
  final Room spacesEntry;

  final Set<SpacesEntryMaybeChildren> children;

  const SpacesEntryMaybeChildren(this.spacesEntry, [this.children = const {}]);

  static SpacesEntryMaybeChildren? buildIfTopLevel(
      Room room, List<Room> allEntries,
      [String? parent]) {
    // don't add rooms with parent space apart from those where the
    // parent space is not joined
    if ((parent == null &&
            room.spaceParents.isNotEmpty &&
            !room.hasNotJoinedParentSpace()) ||
        (parent != null &&
            !room.spaceParents.any((element) => element.roomId == parent))) {
      return null;
    } else {
      final children = allEntries
          .where((element) =>
              element.spaceParents.any((parent) => parent.roomId == room.id))
          .toList();
      return SpacesEntryMaybeChildren(
          room,
          children
              .map((e) => buildIfTopLevel(e, allEntries, room.id))
              .whereNotNull()
              .toSet());
    }
  }

  bool isActiveOrChild(ChatListController controller) =>
      spacesEntry.id == controller.activeSpaceId ||
      children.any(
        (element) => element.isActiveOrChild(controller),
      );
}

extension HasNotJoinedParentSpace on Room {
  bool hasNotJoinedParentSpace() {
    return !client.rooms.any(
      (parentSpace) =>
          parentSpace.isSpace &&
          parentSpace.spaceChildren.any((child) => child.roomId == id),
    );
  }
}
