import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:hermes/l10n/l10n.dart';
import 'package:hermes/config/themes.dart';
import 'package:hermes/pages/chat/chat.dart';
import 'package:hermes/utils/date_time_extension.dart';
import 'package:hermes/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:hermes/utils/sync_status_localization.dart';
import 'package:hermes/widgets/avatar.dart';
import 'package:hermes/widgets/presence_builder.dart';

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
          : () => PantheonThemes.isThreeColumnMode(context)
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                StreamBuilder(
                  stream: room.client.onSyncStatus.stream,
                  builder: (context, snapshot) {
                    final status = room.client.onSyncStatus.value ??
                        const SyncStatusUpdate(SyncStatus.waitingForResponse);
                    final hide = PantheonThemes.isColumnMode(context) ||
                        (room.client.onSync.value != null &&
                            status.status != SyncStatus.error &&
                            room.client.prevBatch != null);
                    return AnimatedSize(
                      duration: PantheonThemes.animationDuration,
                      child: hide
                          ? PresenceBuilder(
                              userId: room.directChatMatrixID,
                              builder: (context, presence) {
                                final lastActiveTimestamp =
                                    presence?.lastActiveTimestamp;
                                final style = TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.outline,
                                );
                                if (presence?.currentlyActive == true) {
                                  return Text(
                                    L10n.of(context).currentlyActive,
                                    style: style,
                                  );
                                }
                                if (lastActiveTimestamp != null) {
                                  return Text(
                                    L10n.of(context).lastActiveAgo(
                                      lastActiveTimestamp
                                          .localizedTimeShort(context),
                                    ),
                                    style: style,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            )
                          : Row(
                              children: [
                                SizedBox.square(
                                  dimension: 10,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 1,
                                    value: status.progress,
                                    valueColor: status.error != null
                                        ? AlwaysStoppedAnimation<Color>(
                                            Theme.of(context).colorScheme.error,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    status.calcLocalizedString(context),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: status.error != null
                                          ? Theme.of(context).colorScheme.error
                                          : null,
                                    ),
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
