import 'package:flutter/material.dart';

import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/space_view.dart';

class SpaceViewAppbar extends StatelessWidget {
  final Function(SpaceActions) onSpaceAction;
  final VoidCallback onBack;
  final List<Room>? joinedParents;
  final Function(String) toParentSpace;
  final Room? room;

  const SpaceViewAppbar({
    super.key,
    required this.onSpaceAction,
    required this.onBack,
    required this.toParentSpace,
    this.joinedParents,
    this.room,
  });

  @override
  Widget build(BuildContext context) {
    final displayname =
        room?.getLocalizedDisplayname() ?? L10n.of(context).nothingFound;

    return GestureDetector(
      onTap: () => onSpaceAction(SpaceActions.settings),
      child: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: joinedParents?.isNotEmpty ?? false ? 0.0 : null,
        title: Row(
          children: [
            if (joinedParents?.isNotEmpty ?? false)
              IconButton(
                icon: const Icon(Icons.arrow_back_outlined),
                onPressed: () => toParentSpace(joinedParents!.first.id),
              ),
            Flexible(
              child: Column(
                spacing: 4.0,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (room != null)
                    Text(
                      L10n.of(context).countChatsAndCountParticipants(
                        room!.spaceChildren.length,
                        room!.summary.mJoinedMemberCount ?? 1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<SpaceActions>(
            useRootNavigator: true,
            onSelected: onSpaceAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SpaceActions.settings,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.settings_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).settings),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SpaceActions.invite,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_add_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).invite),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SpaceActions.groupChat,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Symbols.chat_add_on),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).groupChat),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SpaceActions.subspace,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).subspace),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SpaceActions.leave,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.logout_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).leave),
                  ],
                ),
              ),
              PopupMenuItem(
                value: SpaceActions.delete,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delete_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).delete),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
