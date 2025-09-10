import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/chat_list/utils/get_chat_list_item_subtitle.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/room_status_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import '../../config/themes.dart';
import '../../utils/date_time_extension.dart';
import '../../widgets/avatar.dart';

enum ArchivedRoomAction { delete, rejoin }

class ChatListItem extends StatelessWidget {
  final Room room;
  final Room? space;
  final bool activeChat;
  final void Function(BuildContext context)? onLongPress;
  final void Function()? onForget;
  final void Function() onTap;
  final String? filter;
  // #Pangea
  final BorderRadius? borderRadius;
  final Widget? trailing;
  // Pangea#

  const ChatListItem(
    this.room, {
    this.activeChat = false,
    required this.onTap,
    this.onLongPress,
    this.onForget,
    this.filter,
    this.space,
    super.key,
    // #Pangea
    this.borderRadius,
    this.trailing,
    // Pangea#
  });

  Future<bool> archiveAction(BuildContext context) async {
    {
      if ([Membership.leave, Membership.ban].contains(room.membership)) {
        final forgetResult = await showFutureLoadingDialog(
          context: context,
          future: () => room.forget(),
        );
        return forgetResult.isValue;
      }
      final confirmed = await showOkCancelAlertDialog(
        context: context,
        title: L10n.of(context).areYouSure,
        okLabel: L10n.of(context).leave,
        cancelLabel: L10n.of(context).cancel,
        // #Pangea
        // message: L10n.of(context).archiveRoomDescription,
        message: room.isSpace
            ? L10n.of(context).leaveSpaceDescription
            : L10n.of(context).leaveRoomDescription,
        // Pangea#
        isDestructive: true,
      );
      if (confirmed != OkCancelResult.ok) return false;
      final leaveResult = await showFutureLoadingDialog(
        context: context,
        // #Pangea
        // future: () => room.leave(),
        future: () => room.isSpace ? room.leaveSpace() : room.leave(),
        // Pangea#
      );
      return leaveResult.isValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isMuted = room.pushRuleState != PushRuleState.notify;
    final typingText = room.getLocalizedTypingText(context);
    final lastEvent = room.lastEvent;
    final ownMessage = lastEvent?.senderId == room.client.userID;
    final unread = room.isUnread || room.membership == Membership.invite;
    final directChatMatrixId = room.directChatMatrixID;
    final isDirectChat = directChatMatrixId != null;
    final unreadBubbleSize = unread || room.hasNewMessages
        ? room.notificationCount > 0
            ? 20.0
            : 14.0
        : 0.0;
    final hasNotifications = room.notificationCount > 0;
    final backgroundColor =
        activeChat ? theme.colorScheme.secondaryContainer : null;
    final displayname = room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(context)),
    );
    final filter = this.filter;
    if (filter != null && !displayname.toLowerCase().contains(filter)) {
      return const SizedBox.shrink();
    }

    // #Pangea
    if (filter != null && filter.isNotEmpty && room.isSpace) {
      return const SizedBox.shrink();
    }
    // Pangea#

    final needLastEventSender = lastEvent == null
        ? false
        : room.getState(EventTypes.RoomMember, lastEvent.senderId) == null;
    final space = this.space;

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
            builder: (context, listTileHovered) => ListTile(
              visualDensity: const VisualDensity(vertical: -0.5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              onLongPress: () => onLongPress?.call(context),
              leading: HoverBuilder(
                builder: (context, hovered) => AnimatedScale(
                  duration: FluffyThemes.animationDuration,
                  curve: FluffyThemes.animationCurve,
                  scale: hovered ? 1.1 : 1.0,
                  child: SizedBox(
                    width: Avatar.defaultSize,
                    height: Avatar.defaultSize,
                    child: Stack(
                      children: [
                        if (space != null)
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Avatar(
                              border: BorderSide(
                                width: 2,
                                color: backgroundColor ??
                                    theme.colorScheme.surface,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppConfig.borderRadius / 4,
                              ),
                              mxContent: space.avatar,
                              size: Avatar.defaultSize * 0.75,
                              name: space.getLocalizedDisplayname(),
                              // #Pangea
                              userId: space.directChatMatrixID,
                              useRive: true,
                              // Pangea#
                              onTap: () => onLongPress?.call(context),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Avatar(
                            border: space == null
                                ? room.isSpace
                                    ? BorderSide(
                                        width: 1,
                                        color: theme.dividerColor,
                                      )
                                    : null
                                : BorderSide(
                                    width: 2,
                                    color: backgroundColor ??
                                        theme.colorScheme.surface,
                                  ),
                            // #Pangea
                            // borderRadius: room.isSpace
                            //     ? BorderRadius.circular(
                            //         AppConfig.borderRadius / 4,
                            //       )
                            //     : null,
                            borderRadius: borderRadius ??
                                (room.isSpace
                                    ? BorderRadius.circular(
                                        AppConfig.borderRadius / 4,
                                      )
                                    : null),
                            // Pangea#
                            mxContent: room.avatar,
                            size: space != null
                                ? Avatar.defaultSize * 0.75
                                : Avatar.defaultSize,
                            name: displayname,
                            presenceUserId: directChatMatrixId,
                            presenceBackgroundColor: backgroundColor,
                            onTap: () => onLongPress?.call(context),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => onLongPress?.call(context),
                            child: AnimatedScale(
                              duration: FluffyThemes.animationDuration,
                              curve: FluffyThemes.animationCurve,
                              scale: listTileHovered ? 1.0 : 0.0,
                              child: Material(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(16),
                                child: const Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      displayname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontWeight: unread || room.hasNewMessages
                            ? FontWeight.w500
                            : null,
                      ),
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
                  if (room.isFavourite)
                    Padding(
                      padding: EdgeInsets.only(
                        right: hasNotifications ? 4.0 : 0.0,
                      ),
                      child: Icon(
                        Icons.push_pin,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  if (!room.isSpace &&
                      lastEvent != null &&
                      room.membership != Membership.invite)
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        lastEvent.originServerTs.localizedTimeShort(context),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: theme.colorScheme.secondary,
                      size: 14,
                    ),
                  ),
                  Expanded(
                    child: room.isSpace && room.membership == Membership.join
                        ? Text(
                            L10n.of(context).countChatsAndCountParticipants(
                              // #Pangea
                              // room.spaceChildren.length,
                              room.spaceChildCount,
                              // Pangea#
                              (room.summary.mJoinedMemberCount ?? 1),
                            ),
                            style: TextStyle(color: theme.colorScheme.outline),
                          )
                        : typingText.isNotEmpty
                            ? Text(
                                typingText,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                ),
                                maxLines: 1,
                                softWrap: false,
                              )
                            // #Pangea
                            : room.lastEvent != null
                                ? ChatListItemSubtitle(
                                    room: room,
                                    style: TextStyle(
                                      fontWeight: unread || room.hasNewMessages
                                          ? FontWeight.bold
                                          : null,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  )
                                // Pangea#
                                : FutureBuilder(
                                    key: ValueKey(
                                      '${lastEvent?.eventId}_${lastEvent?.type}_${lastEvent?.redacted}',
                                    ),
                                    future: needLastEventSender
                                        ? lastEvent.calcLocalizedBody(
                                            MatrixLocals(L10n.of(context)),
                                            hideReply: true,
                                            hideEdit: true,
                                            plaintextBody: true,
                                            removeMarkdown: true,
                                            withSenderNamePrefix:
                                                (!isDirectChat ||
                                                    directChatMatrixId !=
                                                        room.lastEvent
                                                            ?.senderId),
                                          )
                                        : null,
                                    initialData:
                                        lastEvent?.calcLocalizedBodyFallback(
                                      MatrixLocals(L10n.of(context)),
                                      hideReply: true,
                                      hideEdit: true,
                                      plaintextBody: true,
                                      removeMarkdown: true,
                                      withSenderNamePrefix: (!isDirectChat ||
                                          directChatMatrixId !=
                                              room.lastEvent?.senderId),
                                    ),
                                    builder: (context, snapshot) => Text(
                                      room.membership == Membership.invite
                                          ? room
                                                  .getState(
                                                    EventTypes.RoomMember,
                                                    room.client.userID!,
                                                  )
                                                  ?.content
                                                  .tryGet<String>('reason') ??
                                              (isDirectChat
                                                  ? L10n.of(context)
                                                      .newChatRequest
                                                  // #Pangea
                                                  // : L10n.of(context)
                                                  //     .inviteGroupChat)
                                                  : L10n.of(context).inviteChat)
                                          // Pangea#
                                          : snapshot.data ??
                                              L10n.of(context).emptyChat,
                                      softWrap: false,
                                      maxLines:
                                          room.notificationCount >= 1 ? 2 : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: unread || room.hasNewMessages
                                            ? theme.colorScheme.onSurface
                                            : theme.colorScheme.outline,
                                        decoration:
                                            room.lastEvent?.redacted == true
                                                ? TextDecoration.lineThrough
                                                : null,
                                      ),
                                    ),
                                  ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: FluffyThemes.animationDuration,
                    curve: FluffyThemes.animationCurve,
                    alignment: Alignment.center,
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
                          ? theme.colorScheme.error
                          : hasNotifications || room.markedUnread
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: hasNotifications
                        ? Text(
                            room.notificationCount.toString(),
                            style: TextStyle(
                              color: room.highlightCount > 0 ||
                                      room.membership == Membership.invite
                                  ? theme.colorScheme.onError
                                  : hasNotifications
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onPrimaryContainer,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
              onTap: onTap,
              // #Pangea
              // trailing: onForget == null
              //     ? null
              //     : IconButton(
              //         icon: const Icon(Icons.delete_outlined),
              //         onPressed: onForget,
              //       ),
              trailing: trailing ??
                  (onForget == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.delete_outlined),
                          onPressed: onForget,
                        )),
              // Pangea#
            ),
          ),
        ),
      ),
    );
  }
}
