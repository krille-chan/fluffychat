import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/spaces_drawer.dart';
import 'package:fluffychat/utils/space_navigator.dart';
import 'package:fluffychat/widgets/avatar.dart';

class SpacesDrawerEntry extends StatelessWidget {
  final SpacesEntryMaybeChildren entry;
  final ChatListController controller;

  const SpacesDrawerEntry(
      {Key? key, required this.entry, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final space = entry.spacesEntry;
    final room = space.getSpace(context);

    final active = controller.activeSpacesEntry == entry.spacesEntry;
    final leading = room == null
        ? CircleAvatar(
            radius: Avatar.defaultSize / 2,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            child: space.getIcon(active),
          )
        : Avatar(
            mxContent: room.avatar,
            name: space.getName(context),
          );
    final title = Text(
      space.getName(context),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final subtitle = room?.topic.isEmpty ?? true
        ? null
        : Tooltip(
            message: room!.topic,
            child: Text(
              room.topic.replaceAll('\n', ' '),
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          );
    void onTap() {
      SpaceNavigator.navigateToSpace(space.routeHandle);
      Scaffold.of(context).closeDrawer();
    }

    final trailing = room != null
        ? SizedBox(
            width: 32,
            child: IconButton(
              splashRadius: 24,
              icon: const Icon(Icons.edit_outlined),
              tooltip: L10n.of(context)!.edit,
              onPressed: () => controller.editSpace(context, room.id),
            ),
          )
        : const Icon(Icons.arrow_forward_ios_outlined);

    if (entry.children.isEmpty) {
      return ListTile(
        selected: active,
        leading: leading,
        title: title,
        subtitle: subtitle,
        onTap: onTap,
        trailing: trailing,
      );
    } else {
      return ExpansionTile(
        leading: leading,
        initiallyExpanded:
            entry.children.any((element) => entry.isActiveOfChild(controller)),
        title: GestureDetector(
          onTap: onTap,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: title),
                const SizedBox(width: 8),
                trailing
              ]),
        ),
        children: entry.children
            .map((e) => SpacesDrawerEntry(entry: e, controller: controller))
            .toList(),
      );
    }
  }
}
