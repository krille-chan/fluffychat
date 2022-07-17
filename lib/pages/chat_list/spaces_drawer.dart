import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/pages/chat_list/spaces_entry.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'chat_list.dart';
import 'spaces_drawer_entry.dart';

class SpacesDrawer extends StatelessWidget {
  final ChatListController controller;

  const SpacesDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spaceEntries = controller.spacesEntries
        .map((e) => SpacesEntryMaybeChildren.buildIfTopLevel(
            e, controller.spacesEntries))
        .whereNotNull()
        .toList();

    final childSpaceIds = <String>{};

    final spacesHierarchy = <SpacesEntryMaybeChildren>[];

    final matrix = Matrix.of(context);
    for (final entry in spaceEntries) {
      if (entry.spacesEntry is SpaceSpacesEntry) {
        final space = entry.spacesEntry.getSpace(context);
        if (space != null && space.spaceChildren.isNotEmpty) {
          final children = space.spaceChildren;
          // computing the children space entries
          final childrenSpaceEntries = spaceEntries.where((element) {
            // current ID
            final id = element.spacesEntry.getSpace(context)?.id;

            // comparing against the supposed IDs of the children and checking
            // whether the room is already joined
            return children.any(
              (child) =>
                  child.roomId == id &&
                  matrix.client.rooms
                      .any((joinedRoom) => child.roomId == joinedRoom.id),
            );
          });
          childSpaceIds.addAll(childrenSpaceEntries
              .map((e) => e.spacesEntry.getSpace(context)?.id)
              .whereNotNull());
          entry.children.addAll(childrenSpaceEntries);
          spacesHierarchy.add(entry);
        } else {
          if (space?.spaceParents.isEmpty ?? false) {
            spacesHierarchy.add(entry);
          }
        }
      } else {
        spacesHierarchy.add(entry);
      }
    }

    spacesHierarchy.removeWhere((element) =>
        childSpaceIds.contains(element.spacesEntry.getSpace(context)?.id));

    // final spacesHierarchy = spaceEntries;

    // TODO(TheOeWithTheBraid): wait for space hierarchy https://gitlab.com/famedly/company/frontend/libraries/matrix_api_lite/-/merge_requests/58

    return ListView.builder(
      itemCount: spacesHierarchy.length + 1,
      itemBuilder: (context, i) {
        if (i == spacesHierarchy.length) {
          return ListTile(
            leading: CircleAvatar(
              radius: Avatar.defaultSize / 2,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              child: const Icon(
                Icons.archive_outlined,
              ),
            ),
            title: Text(L10n.of(context)!.archive),
            onTap: () {
              Scaffold.of(context).closeDrawer();
              VRouter.of(context).to('/archive');
            },
          );
        }
        final space = spacesHierarchy[i];
        return SpacesDrawerEntry(
          entry: space,
          controller: controller,
        );
      },
    );
  }
}

class SpacesEntryMaybeChildren {
  final SpacesEntry spacesEntry;

  final Set<SpacesEntryMaybeChildren> children;

  const SpacesEntryMaybeChildren(this.spacesEntry, [this.children = const {}]);

  static SpacesEntryMaybeChildren? buildIfTopLevel(
      SpacesEntry entry, List<SpacesEntry> allEntries,
      [String? parent]) {
    if (entry is SpaceSpacesEntry) {
      final room = entry.space;
      if ((parent == null && room.spaceParents.isNotEmpty) ||
          (parent != null &&
              !room.spaceParents.any((element) => element.roomId == parent))) {
        return null;
      } else {
        final children = allEntries
            .where((element) =>
                element is SpaceSpacesEntry &&
                element.space.spaceParents.any((parent) =>
                    parent.roomId == room.id /*&& (parent.canonical ?? true)*/))
            .toList();
        return SpacesEntryMaybeChildren(
            entry,
            children
                .map((e) => buildIfTopLevel(e, allEntries, room.id))
                .whereNotNull()
                .toSet());
      }
    } else {
      return SpacesEntryMaybeChildren(entry);
    }
  }

  bool isActiveOfChild(ChatListController controller) =>
      spacesEntry == controller.activeSpacesEntry ||
      children.any(
        (element) => element.isActiveOfChild(controller),
      );

  Map<String, dynamic> toJson() => {
        'entry': spacesEntry is SpaceSpacesEntry
            ? (spacesEntry as SpaceSpacesEntry).space.id
            : spacesEntry.runtimeType.toString(),
        if (spacesEntry is SpaceSpacesEntry)
          'rawSpaceParents': (spacesEntry as SpaceSpacesEntry)
              .space
              .spaceParents
              .map((e) =>
                  {'roomId': e.roomId, 'canonical': e.canonical, 'via': e.via})
              .toList(),
        if (spacesEntry is SpaceSpacesEntry)
          'rawSpaceChildren': (spacesEntry as SpaceSpacesEntry)
              .space
              .spaceChildren
              .map(
                (e) => {
                  'roomId': e.roomId,
                  'suggested': e.suggested,
                  'via': e.via,
                  'order': e.order
                },
              )
              .toList(),
        'children': children.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
