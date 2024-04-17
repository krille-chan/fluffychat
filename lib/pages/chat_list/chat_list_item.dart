import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/room_status_extension.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import '../../config/themes.dart';
import '../../utils/date_time_extension.dart';
import '../../widgets/avatar.dart';
import '../../widgets/matrix.dart';

enum ArchivedRoomAction { delete, rejoin }

class ChatListItem extends StatelessWidget {
  final Room room;
  final bool activeChat;
  final bool selected;
  final void Function()? onLongPress;
  final void Function()? onForget;
  final void Function() onTap;

  const ChatListItem(
    this.room, {
    this.activeChat = false,
    this.selected = false,
    required this.onTap,
    this.onLongPress,
    this.onForget,
    super.key,
  });

  Future<void> archiveAction(BuildContext context) async {
    {
      if ([Membership.leave, Membership.ban].contains(room.membership)) {
        await showFutureLoadingDialog(
          context: context,
          future: () => room.forget(),
        );
        return;
      }
      final confirmed = await showOkCancelAlertDialog(
        useRootNavigator: false,
        context: context,
        title: L10n.of(context)!.areYouSure,
        okLabel: L10n.of(context)!.yes,
        cancelLabel: L10n.of(context)!.no,
        message: L10n.of(context)!.archiveRoomDescription,
      );
      if (confirmed == OkCancelResult.cancel) return;
      await showFutureLoadingDialog(
        context: context,
        future: () => room.leave(),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = room.pushRuleState != PushRuleState.notify;
    final typingText = room.getLocalizedTypingText(context);
    final lastEvent = room.lastEvent;
    final ownMessage = lastEvent?.senderId == Matrix.of(context).client.userID;
    final unread = room.isUnread || room.membership == Membership.invite;
    final unreadBubbleSize = unread || room.hasNewMessages
        ? room.notificationCount > 0
            ? 20.0
            : 14.0
        : 0.0;
    final hasNotifications = room.notificationCount > 0;
    final backgroundColor = selected
        ? Theme.of(context).colorScheme.primaryContainer
        : activeChat
            ? Theme.of(context).colorScheme.secondaryContainer
            : null;
    final displayname = room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(context)!),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 1,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        clipBehavior: Clip.hardEdge,
        color: backgroundColor,
        child: FutureBuilder(
          future: room.loadHeroUsers(),
          builder: (context, snapshot) => HoverBuilder(
            builder: (context, hovered) => ListTile(
              visualDensity: const VisualDensity(vertical: -0.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              onLongPress: onLongPress,
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  HoverBuilder(
                    builder: (context, hovered) => AnimatedScale(
                      duration: FluffyThemes.animationDuration,
                      curve: FluffyThemes.animationCurve,
                      scale: hovered ? 1.1 : 1.0,
                      child: Avatar(
                        mxContent: room.avatar,
                        name: displayname,
                        presenceUserId: room.directChatMatrixID,
                        presenceBackgroundColor: backgroundColor,
                        onTap: onLongPress,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: AnimatedScale(
                      duration: FluffyThemes.animationDuration,
                      curve: FluffyThemes.animationCurve,
                      scale: (hovered || selected) ? 1.0 : 0.0,
                      child: Material(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        child: Icon(
                          selected
                              ? Icons.check_circle
                              : Icons.check_circle_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      displayname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: unread || room.hasNewMessages
                          ? const TextStyle(fontWeight: FontWeight.bold)
                          : null,
                    ),
                  ),
                  if (isMuted)
                    const Padding(
                      padding: EdgeInsets.only(left: 4.0),
                      child: Icon(
                        Icons.notifications_off_outlined,
                        size: 16,
                      ),
                    ),
                  if (room.isFavourite || room.membership == Membership.invite)
                    Padding(
                      padding: EdgeInsets.only(
                        right: hasNotifications ? 4.0 : 0.0,
                      ),
                      child: Icon(
                        Icons.push_pin,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  if (lastEvent != null && room.membership != Membership.invite)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        lastEvent.originServerTs.localizedTimeShort(context),
                        style: TextStyle(
                          fontSize: 13,
                          color: unread
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (typingText.isEmpty &&
                      ownMessage &&
                      room.lastEvent!.status.isSending) ...[
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                    ),
                    const SizedBox(width: 4),
                  ],
                  AnimatedContainer(
                    width: typingText.isEmpty ? 0 : 18,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(),
                    duration: FluffyThemes.animationDuration,
                    curve: FluffyThemes.animationCurve,
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.edit_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 14,
                    ),
                  ),
                  Expanded(
                    child: typingText.isNotEmpty
                        ? Text(
                            typingText,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            maxLines: 1,
                            softWrap: false,
                          )
                        : FutureBuilder<String>(
                            future: room.lastEvent?.calcLocalizedBody(
                                  MatrixLocals(L10n.of(context)!),
                                  hideReply: true,
                                  hideEdit: true,
                                  plaintextBody: true,
                                  removeMarkdown: true,
                                  withSenderNamePrefix: !room.isDirectChat ||
                                      room.directChatMatrixID !=
                                          room.lastEvent?.senderId,
                                ) ??
                                Future.value(L10n.of(context)!.emptyChat),
                            builder: (context, snapshot) {
                              return Text(
                                room.membership == Membership.invite
                                    ? room.isDirectChat
                                        ? L10n.of(context)!.invitePrivateChat
                                        : L10n.of(context)!.inviteGroupChat
                                    : snapshot.data ??
                                        room.lastEvent
                                            ?.calcLocalizedBodyFallback(
                                          MatrixLocals(L10n.of(context)!),
                                          hideReply: true,
                                          hideEdit: true,
                                          plaintextBody: true,
                                          removeMarkdown: true,
                                          withSenderNamePrefix:
                                              !room.isDirectChat ||
                                                  room.directChatMatrixID !=
                                                      room.lastEvent?.senderId,
                                        ) ??
                                        L10n.of(context)!.emptyChat,
                                softWrap: false,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: unread || room.hasNewMessages
                                      ? FontWeight.bold
                                      : null,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                  decoration: room.lastEvent?.redacted == true
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: FluffyThemes.animationDuration,
                    curve: FluffyThemes.animationCurve,
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    height: unreadBubbleSize,
                    width: !hasNotifications && !unread && !room.hasNewMessages
                        ? 0
                        : (unreadBubbleSize - 9) *
                                room.notificationCount.toString().length +
                            9,
                    decoration: BoxDecoration(
                      color: room.highlightCount > 0 ||
                              room.membership == Membership.invite
                          ? Colors.red
                          : hasNotifications || room.markedUnread
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                    ),
                    child: Center(
                      child: hasNotifications
                          ? Text(
                              room.notificationCount.toString(),
                              style: TextStyle(
                                color: room.highlightCount > 0
                                    ? Colors.white
                                    : hasNotifications
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                fontSize: 13,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
              onTap: onTap,
              trailing: onForget == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.delete_outlined),
                      onPressed: onForget,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
