import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/chat_settings/pages/chat_details_button_row.dart';
import 'package:fluffychat/pangea/chat_settings/pages/room_participants_widget.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/avatar.dart';

class ChatDetailsContent extends StatelessWidget {
  final ChatDetailsController controller;
  final Room room;

  const ChatDetailsContent(this.controller, this.room, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 2,
      itemBuilder: (BuildContext context, int i) {
        if (i == 0) {
          final theme = Theme.of(context);
          final displayname = room.getLocalizedDisplayname(
            MatrixLocals(L10n.of(context)),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Stack(
                      children: [
                        Hero(
                          tag: controller.widget.embeddedCloseButton != null
                              ? 'embedded_content_banner'
                              : 'content_banner',
                          child: Avatar(
                            mxContent: room.avatar,
                            name: displayname,
                            userId: room.directChatMatrixID,
                            size: Avatar.defaultSize * 2.5,
                            borderRadius: room.isSpace
                                ? BorderRadius.circular(24.0)
                                : null,
                          ),
                        ),
                        if (!room.isDirectChat &&
                            room.canChangeStateEvent(
                              EventTypes.RoomAvatar,
                            ))
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: FloatingActionButton.small(
                              onPressed: controller.setAvatarAction,
                              heroTag: null,
                              child: const Icon(
                                Icons.camera_alt_outlined,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: room.isDirectChat
                              ? null
                              : () => room.canChangeStateEvent(
                                    EventTypes.RoomName,
                                  )
                                      ? controller.setDisplaynameAction()
                                      : FluffyShare.share(
                                          displayname,
                                          context,
                                          copyOnly: true,
                                        ),
                          icon: Icon(
                            room.isDirectChat
                                ? Icons.chat_bubble_outline
                                : room.canChangeStateEvent(
                                    EventTypes.RoomName,
                                  )
                                    ? Icons.edit_outlined
                                    : Icons.copy_outlined,
                            size: 16,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.onSurface,
                            disabledForegroundColor:
                                theme.colorScheme.onSurface,
                          ),
                          label: Text(
                            room.isDirectChat
                                ? L10n.of(context).directChat
                                : displayname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: room.isDirectChat
                              ? null
                              : () => context.push(
                                    '/rooms/${controller.roomId}/details/invite?filter=participants',
                                  ),
                          icon: const Icon(
                            Icons.group_outlined,
                            size: 14,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.secondary,
                            disabledForegroundColor:
                                theme.colorScheme.onSurface,
                          ),
                          label: Text(
                            L10n.of(context).countParticipants(
                              room.getParticipants().length,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  if (room.isRoomAdmin)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: IconButton(
                        onPressed: controller.setTopicAction,
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32.0,
                      right: 32.0,
                      top: 16.0,
                      bottom: 16.0,
                    ),
                    child: SelectableLinkify(
                      text: room.topic.isEmpty
                          ? room.isSpace
                              ? L10n.of(context).noSpaceDescriptionYet
                              : L10n.of(context).noChatDescriptionYet
                          : room.topic,
                      options: const LinkifyOptions(humanize: false),
                      linkStyle: const TextStyle(
                        color: Colors.blueAccent,
                        decorationColor: Colors.blueAccent,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: room.topic.isEmpty
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: theme.textTheme.bodyMedium!.color,
                        decorationColor: theme.textTheme.bodyMedium!.color,
                      ),
                      onOpen: (url) =>
                          UrlLauncher(context, url.url).launchUrl(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ChatDetailsButtonRow(
                  controller: controller,
                  room: room,
                ),
              ),
            ],
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: RoomParticipantsSection(room: room),
        );
      },
    );
  }
}
