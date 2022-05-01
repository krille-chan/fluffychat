import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pages/chat_list/spaces_entry.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'chat_list.dart';

class SpacesDrawer extends StatelessWidget {
  final ChatListController controller;

  const SpacesDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex = controller.activeSpaceId == null
        ? 0
        : controller.spaces
                .indexWhere((space) => controller.activeSpaceId == space.id) +
            1;

    final Map<SpacesEntry, dynamic> spaceHierarchy =
        Map.fromEntries(controller.spacesEntries.map((e) => MapEntry(e, null)));

    // TODO(TheOeWithTheBraid): wait for space hierarchy https://gitlab.com/famedly/company/frontend/libraries/matrix_api_lite/-/merge_requests/58

    return WillPopScope(
      onWillPop: () async {
        controller.snapBackSpacesSheet();
        return false;
      },
      child: Column(
        children: List.generate(
          spaceHierarchy.length,
          (index) {
            if (index == 0) {
              return ListTile(
                selected: currentIndex == index,
                leading: const Icon(Icons.keyboard_arrow_down),
                title: Text(L10n.of(context)!.allChats),
                onTap: () => controller.setActiveSpacesEntry(
                  context,
                  null,
                ),
              );
            } else {
              final space = spaceHierarchy.keys.toList()[index];
              final room = space.getSpace(context)!;
              return ListTile(
                selected: currentIndex == index,
                leading: Avatar(
                  mxContent: room.avatar,
                  name: space.getName(context),
                  size: 24,
                  fontSize: 12,
                ),
                title: Text(space.getName(context)),
                subtitle: room.topic.isEmpty
                    ? null
                    : Tooltip(
                        message: room.topic,
                        child: Text(
                          room.topic.replaceAll('\n', ' '),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                onTap: () => controller.setActiveSpacesEntry(
                  context,
                  space,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: L10n.of(context)!.edit,
                  onPressed: () => controller.editSpace(context, room.id),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
