import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/config/themes.dart';
import 'package:tawkie/utils/date_time_extension.dart';
import 'package:tawkie/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:tawkie/utils/room_status_extension.dart';
import 'package:tawkie/widgets/avatar.dart';
import 'package:tawkie/widgets/hover_builder.dart';
import 'package:tawkie/widgets/matrix.dart';

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
    var displayname = room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(context)!),
    );

    bool containsFacebook(List<String> participantsIds) {
      return participantsIds.any((id) => id.contains('@messenger2'));
    }

    bool containsInstagram(List<String> participantsIds) {
      return participantsIds.any((id) => id.contains('@instagram2_'));
    }

    bool containsWhatsApp(List<String> participantsIds) {
      return participantsIds.any((id) => id.contains('@whatsapp'));
    }

    void removeFacebookTag() {
      if (displayname.contains('(FB)')) {
        displayname = displayname.replaceAll('(FB)', ''); // Delete (FB)
      }
    }

    void removeInstagramTag() {
      if (displayname.contains('(IG)')) {
        displayname = displayname.replaceAll('(IG)', ''); // Delete (Instagram)
      }
    }

    void removeWhatsAppTag() {
      if (displayname.contains('(WA)')) {
        displayname = displayname.replaceAll('(WA)', ''); // Delete (WA)
      }
    }

    // Condition for verifying the presence of social networks in participants ID
    Future<List<dynamic>> loadRoomInfo() async {
      List<User> participants = room.getParticipants();
      Color? networkColor;
      Image? networkImage;
      final participantsIds = participants.map((member) => member.id).toList();

      if (containsFacebook(participantsIds)) {
        networkColor = FluffyThemes.facebookColor;
        networkImage = Image.asset(
          'assets/facebook-messenger.png',
          color: networkColor,
          filterQuality: FilterQuality.high,
        );
        removeFacebookTag();
      } else if (containsInstagram(participantsIds)) {
        networkColor = FluffyThemes.instagramColor;
        networkImage = Image.asset(
          'assets/instagram.png',
          color: networkColor,
          filterQuality: FilterQuality.high,
        );
        removeInstagramTag();
      } else if (containsWhatsApp(participantsIds)) {
        networkColor = FluffyThemes.whatsAppColor;
        networkImage = Image.asset(
          'assets/whatsapp.png',
          color: networkColor,
          filterQuality: FilterQuality.high,
        );
        removeWhatsAppTag();
      }

      return [networkColor, networkImage];
    }

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
              leading: Avatar(
                mxContent: room.avatar,
                name: displayname,
                presenceUserId: room.directChatMatrixID,
                presenceBackgroundColor: backgroundColor,
              ),
              title: FutureBuilder<List<dynamic>>(
                future: loadRoomInfo(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    final networkColor = snapshot.data![0];
                    final networkImage = snapshot.data![1];
                    return Row(
                      children: <Widget>[
                        if (networkImage != null)
                          SizedBox(
                            height: 16.0, // to adjust height
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: networkImage,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            displayname,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: unread
                                ? TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? null
                                        : networkColor, // Color for the dark theme
                                  )
                                : TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? null
                                        : networkColor, // Color for the dark theme
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
                        if (room.isFavourite ||
                            room.membership == Membership.invite)
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
                        if (lastEvent != null &&
                            room.membership != Membership.invite)
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              lastEvent.originServerTs
                                  .localizedTimeShort(context),
                              style: TextStyle(
                                fontSize: 13,
                                color: unread
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                },
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
                  ? hovered || selected
                      ? IconButton(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          icon: Icon(
                            selected
                                ? Icons.check_circle
                                : Icons.check_circle_outlined,
                          ),
                          onPressed: onLongPress,
                        )
                      : null
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
