import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/themes.dart';
import 'package:tawkie/pages/chat/chat.dart';
import 'package:tawkie/utils/date_time_extension.dart';
import 'package:tawkie/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:tawkie/utils/social_media_utils.dart';
import 'package:tawkie/widgets/avatar.dart';
import 'package:tawkie/widgets/presence_builder.dart';

class ChatAppBarTitle extends StatelessWidget {
  final ChatController controller;

  const ChatAppBarTitle(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final room = controller.room;

    if (controller.selectedEvents.isNotEmpty) {
      return Text(controller.selectedEvents.length.toString());
    }

    final localizedDisplayName =
        room.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));

    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: controller.isArchived
          ? null
          : () => FluffyThemes.isThreeColumnMode(context)
              ? controller.toggleDisplayChatDetailsColumn()
              : context.go('/rooms/${room.id}/details'),
      child: FutureBuilder<RoomDisplayInfo>(
        future: loadRoomInfo(context, room),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildRoomInfoPlaceholder(context, localizedDisplayName);
          }

          final roomInfo = snapshot.data!;
          return _buildRoomInfo(context, roomInfo, room);
        },
      ),
    );
  }

  Widget _buildRoomInfoPlaceholder(BuildContext context, String displayName) {
    return Row(
      children: [
        Hero(
          tag: 'content_banner',
          child: Avatar(
            mxContent: controller.room.avatar,
            name: displayName,
            size: 32,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomInfo(
      BuildContext context, RoomDisplayInfo roomInfo, Room room) {
    final theme = Theme.of(context);
    final networkColor = roomInfo.networkColor;
    final networkImage = roomInfo.networkImage;
    final displayName = roomInfo.displayname;
    final directChatMatrixId = room.directChatMatrixID;

    return Row(
      children: [
        Hero(
          tag: 'content_banner',
          child: Avatar(
            mxContent: room.avatar,
            name: displayName,
            size: 32,
          ),
        ),
        const SizedBox(width: 12),
        if (networkImage != null)
          SizedBox(
            height: 16.0, // to adjust height
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: networkImage,
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.brightness == Brightness.light
                      ? null
                      : networkColor,
                ),
              ),
              AnimatedSize(
                duration: FluffyThemes.animationDuration,
                child: PresenceBuilder(
                  userId: directChatMatrixId,
                  builder: (context, presence) {
                    final style = theme.textTheme.bodySmall;
                    if (presence?.currentlyActive == true) {
                      return Text(
                        L10n.of(context)!.currentlyActive,
                        style: style,
                      );
                    }
                    final lastActiveTimestamp = presence?.lastActiveTimestamp;
                    if (lastActiveTimestamp != null) {
                      return Text(
                        L10n.of(context)!.lastActiveAgo(
                          lastActiveTimestamp.localizedTimeShort(context),
                        ),
                        style: style,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
