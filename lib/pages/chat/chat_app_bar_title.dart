// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/sync_status_localization.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/presence_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

class ChatAppBarTitle extends StatelessWidget {
  final ChatController controller;
  const ChatAppBarTitle(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final room = controller.room;
    if (controller.selectedEvents.isNotEmpty) {
      return Text(
        controller.selectedEvents.length.toString(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      );
    }
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: controller.isArchived
          ? null
          : () => FluffyThemes.isThreeColumnMode(context)
                ? controller.toggleDisplayChatDetailsColumn()
                : context.go('/rooms/${room.id}/details'),
      child: Row(
        children: [
          Hero(
            tag: 'content_banner',
            child: Avatar(
              mxContent: room.avatar,
              name: room.getLocalizedDisplayname(
                MatrixLocals(L10n.of(context)),
              ),
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  room.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
                StreamBuilder(
                  stream: room.client.onSyncStatus.stream,
                  builder: (context, snapshot) {
                    final status =
                        room.client.onSyncStatus.value ??
                        const SyncStatusUpdate(SyncStatus.waitingForResponse);
                    final hide =
                        FluffyThemes.isColumnMode(context) ||
                        (room.client.onSync.value != null &&
                            status.status != SyncStatus.error &&
                            room.client.prevBatch != null);
                    final style = TextStyle(fontSize: 11);
                    return AnimatedSize(
                      duration: FluffyThemes.animationDuration,
                      child: hide
                          ? room.isDirectChat
                                ? PresenceBuilder(
                                    userId: room.directChatMatrixID,
                                    builder: (context, presence) {
                                      final statusMessage = presence?.statusMsg;

                                      final lastActiveTimestamp =
                                          presence?.lastActiveTimestamp;

                                      return Row(
                                        children: [
                                          if (presence?.currentlyActive == true)
                                            Text(
                                              L10n.of(context).currentlyActive,
                                              style: style,
                                            )
                                          else if (lastActiveTimestamp != null)
                                            Text(
                                              L10n.of(context).lastActiveAgo(
                                                lastActiveTimestamp
                                                    .localizedTimeShort(
                                                      context,
                                                    ),
                                              ),
                                              style: style,
                                            ),
                                          if (statusMessage != null) ...[
                                            if ((presence?.currentlyActive ==
                                                    true ||
                                                lastActiveTimestamp != null))
                                              Text(' ◦ ', style: style),
                                            Expanded(
                                              child: Text(
                                                statusMessage,
                                                style: style,
                                              ),
                                            ),
                                          ],
                                        ],
                                      );
                                    },
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        L10n.of(context).countParticipants(
                                          (room.summary.mJoinedMemberCount ??
                                                  1) +
                                              (room
                                                      .summary
                                                      .mInvitedMemberCount ??
                                                  0),
                                        ),
                                        style: style,
                                      ),
                                      if (room.topic.isNotEmpty) ...[
                                        Text(' ◦ ', style: style),
                                        Expanded(
                                          child: Text(room.topic, style: style),
                                        ),
                                      ],
                                    ],
                                  )
                          : Row(
                              children: [
                                SizedBox.square(
                                  dimension: 10,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 1,
                                    value: status.progress,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    status.calcLocalizedString(context),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
