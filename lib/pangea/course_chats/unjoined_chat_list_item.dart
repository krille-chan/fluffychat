import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

class UnjoinedChatListItem extends StatelessWidget {
  final SpaceRoomsChunk chunk;
  final VoidCallback onTap;
  const UnjoinedChatListItem({
    super.key,
    required this.chunk,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayname =
        chunk.name ?? chunk.canonicalAlias ?? L10n.of(context).emptyChat;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 1,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -0.5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          onTap: onTap,
          leading: Avatar(
            mxContent: chunk.avatarUrl,
            name: displayname,
            userId: Matrix.of(context)
                .client
                .getRoomById(chunk.roomId)
                ?.directChatMatrixID,
            borderRadius: chunk.roomType == 'm.space'
                ? BorderRadius.circular(
                    AppConfig.borderRadius / 2,
                  )
                : null,
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  displayname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                chunk.numJoinedMembers.toString(),
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.people_outlined,
                size: 14,
              ),
            ],
          ),
          subtitle: Text(
            chunk.topic ??
                L10n.of(context).countParticipants(
                  chunk.numJoinedMembers,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
