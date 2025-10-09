import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_list/chat_list.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';

class RoomCategoryTile extends StatelessWidget {
  final RoomCategory category;
  final VoidCallback onToggle;
  final Function(Room) onRoomTap;
  final Function(Room, BuildContext) onRoomLongPress;
  final String? activeChat;
  final String filter;

  const RoomCategoryTile({
    super.key,
    required this.category,
    required this.onToggle,
    required this.onRoomTap,
    required this.onRoomLongPress,
    this.activeChat,
    this.filter = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: theme.colorScheme.surface,
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            leading: Icon(
              category.isCollapsed ? Icons.chevron_right : Icons.expand_more,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            title: Text(
              '${category.name} (${category.rooms.length})',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onTap: onToggle,
          ),
        ),
        AnimatedContainer(
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          height: category.isCollapsed ? 0 : null,
          child: ClipRect(
            child: AnimatedOpacity(
              duration: FluffyThemes.animationDuration,
              curve: FluffyThemes.animationCurve,
              opacity: category.isCollapsed ? 0.0 : 1.0,
              child: category.isCollapsed
                  ? const SizedBox.shrink()
                  : Column(
                      children: category.rooms
                          .map(
                            (room) => ChatListItem(
                              room,
                              key: Key('chat_list_item_${room.id}'),
                              filter: filter,
                              onTap: () => onRoomTap(room),
                              onLongPress: (context) =>
                                  onRoomLongPress(room, context),
                              activeChat: activeChat == room.id,
                            ),
                          )
                          .toList(),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
