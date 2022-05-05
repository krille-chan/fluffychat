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
    final currentIndex = controller.spacesEntries.indexWhere((space) =>
        controller.activeSpacesEntry.runtimeType == space.runtimeType &&
        (controller.activeSpaceId == space.getSpace(context)?.id));

    final Map<SpacesEntry, dynamic> spaceHierarchy =
        Map.fromEntries(controller.spacesEntries.map((e) => MapEntry(e, null)));

    // TODO(TheOeWithTheBraid): wait for space hierarchy https://gitlab.com/famedly/company/frontend/libraries/matrix_api_lite/-/merge_requests/58

    return WillPopScope(
      onWillPop: () async {
        controller.snapBackSpacesSheet();
        return false;
      },
      child: Column(
        children: List.generate(spaceHierarchy.length, (index) {
          final space = spaceHierarchy.keys.toList()[index];
          final room = space.getSpace(context);
          final active = currentIndex == index;
          return ListTile(
            selected: active,
            leading: index == 0
                ? const Icon(Icons.keyboard_arrow_down)
                : room == null
                    ? space.getIcon(active)
                    : Avatar(
                        mxContent: room.avatar,
                        name: space.getName(context),
                        size: 24,
                        fontSize: 12,
                      ),
            title: Text(space.getName(context)),
            subtitle: room?.topic.isEmpty ?? true
                ? null
                : Tooltip(
                    message: room!.topic,
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
            trailing: room != null
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: L10n.of(context)!.edit,
                    onPressed: () => controller.editSpace(context, room.id),
                  )
                : null,
          );
        }),
      ),
    );
  }
}
