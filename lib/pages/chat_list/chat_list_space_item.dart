import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import '../../config/themes.dart';
import '../../widgets/avatar.dart';

class ChatListSpaceItem extends StatelessWidget {
  final Room room;
  final List<Room> rooms;
  final String? activeChat;

  final void Function(BuildContext context)? onLongPress;
  final void Function(Room room, BuildContext context)? onLongPressDeep;
  final void Function()? onForget;
  final void Function(Room room) onTapDeep;
  final void Function(bool expanded)? onExpansionChanged;
  final String? filter;
  final bool defaultExpanded;

  const ChatListSpaceItem(
    this.room,
    this.rooms, {
    required this.activeChat,
    required this.onTapDeep,
    this.onLongPress,
    this.onLongPressDeep,
    this.onForget,
    this.onExpansionChanged,
    this.filter,
    this.defaultExpanded = true,
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
    final activeChat = this.activeChat == room.id;

    final theme = Theme.of(context);

    final isMuted = room.pushRuleState != PushRuleState.notify;
    final directChatMatrixId = room.directChatMatrixID;
    final hasNotifications = room.notificationCount > 0;
    final backgroundColor =
        activeChat ? theme.colorScheme.secondaryContainer : null;
    final displayname = room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(context)!),
    );
    final filter = this.filter;
    if (filter != null && !displayname.toLowerCase().contains(filter)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 1,
      ),
      child: Material(
        shape: Border(
          top: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        color: backgroundColor,
        child: HoverBuilder(
            builder: (context, listTileHovered) => GestureDetector(
                  onLongPress: () => onLongPress?.call(context),
                  child: ExpansionTile(
                    initiallyExpanded: defaultExpanded,
                    visualDensity: const VisualDensity(vertical: -0.5),
                    leading: HoverBuilder(
                      builder: (context, hovered) => AnimatedScale(
                        duration: FluffyThemes.animationDuration,
                        curve: FluffyThemes.animationCurve,
                        scale: hovered ? 1.1 : 1.0,
                        child: SizedBox(
                          width: Avatar.defaultSize * 0.5,
                          height: Avatar.defaultSize * 0.5,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Avatar(
                                  border: null,
                                  borderRadius: null,
                                  mxContent: room.avatar,
                                  size: Avatar.defaultSize * 0.5,
                                  name: displayname,
                                  presenceUserId: directChatMatrixId,
                                  presenceBackgroundColor: backgroundColor,
                                  onTap: () => onLongPress?.call(context),
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
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
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
                              color: theme.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                    onExpansionChanged: onExpansionChanged,
                    trailing: onForget == null
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.delete_outlined),
                            onPressed: onForget,
                          ),
                    children: [
                      /*CustomScrollView(
                  slivers: [*/
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: rooms.length,
                        itemBuilder: (context, i) {
                          final room = rooms[i];
                          return ChatListItem(
                            room,
                            filter: filter,
                            onTap: () => onTapDeep(room),
                            onLongPress: (context) => onLongPressDeep?.call(
                              room,
                              context,
                            ),
                            activeChat: this.activeChat == room.id,
                          );
                        },
                      ),
                      /*],
                ),*/
                    ],
                  ),
                )),
      ),
    );
  }
}
