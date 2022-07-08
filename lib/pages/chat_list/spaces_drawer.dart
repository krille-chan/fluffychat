import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';

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

    return ListView.builder(
      itemCount: spaceHierarchy.length + 1,
      itemBuilder: (context, i) {
        if (i == spaceHierarchy.length) {
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
        final space = spaceHierarchy.keys.toList()[i];
        final room = space.getSpace(context);
        final active = currentIndex == i;
        return ListTile(
          selected: active,
          leading: room == null
              ? CircleAvatar(
                  child: space.getIcon(active),
                  radius: Avatar.defaultSize / 2,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                )
              : Avatar(
                  mxContent: room.avatar,
                  name: space.getName(context),
                ),
          title: Text(
            space.getName(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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
              ? SizedBox(
                  width: 32,
                  child: IconButton(
                    splashRadius: 24,
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: L10n.of(context)!.edit,
                    onPressed: () => controller.editSpace(context, room.id),
                  ),
                )
              : const Icon(Icons.arrow_forward_ios_outlined),
        );
      },
    );
  }
}
