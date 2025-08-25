import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/chat_settings/pages/room_details_buttons.dart';
import 'package:fluffychat/pangea/chat_settings/utils/delete_room.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/conversation_bot/conversation_bot_settings.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ChatDetailsButtonRow extends StatefulWidget {
  final ChatDetailsController controller;
  final Room room;

  const ChatDetailsButtonRow({
    super.key,
    required this.controller,
    required this.room,
  });

  @override
  State<ChatDetailsButtonRow> createState() => ChatDetailsButtonRowState();
}

class ChatDetailsButtonRowState extends State<ChatDetailsButtonRow> {
  StreamSubscription? notificationChangeSub;

  @override
  void initState() {
    super.initState();
    notificationChangeSub ??= Matrix.of(context)
        .client
        .onSync
        .stream
        .where(
          (syncUpdate) =>
              syncUpdate.accountData?.any(
                (accountData) => accountData.type == 'm.push_rules',
              ) ??
              false,
        )
        .listen(
          (u) => setState(() {}),
        );
  }

  @override
  void dispose() {
    notificationChangeSub?.cancel();
    super.dispose();
  }

  final double _buttonHeight = 84.0;
  final double _miniButtonWidth = 50.0;

  Room get room => widget.room;

  List<ButtonDetails> _buttons(BuildContext context) {
    final L10n l10n = L10n.of(context);
    return [
      ButtonDetails(
        title: l10n.permissions,
        icon: const Icon(Icons.edit_attributes_outlined, size: 30.0),
        onPressed: () => context.go('/rooms/${room.id}/details/permissions'),
        enabled: room.isRoomAdmin && !room.isDirectChat,
        showInMainView: false,
      ),
      ButtonDetails(
        title: room.pushRuleState == PushRuleState.notify
            ? l10n.notificationsOn
            : l10n.notificationsOff,
        icon: Icon(
          room.pushRuleState == PushRuleState.notify
              ? Icons.notifications_on_outlined
              : Icons.notifications_off_outlined,
          size: 30.0,
        ),
        onPressed: () => showFutureLoadingDialog(
          context: context,
          future: () => room.setPushRuleState(
            room.pushRuleState == PushRuleState.notify
                ? PushRuleState.mentionsOnly
                : PushRuleState.notify,
          ),
        ),
      ),
      ButtonDetails(
        title: l10n.invite,
        icon: const Icon(Icons.person_add_outlined, size: 30.0),
        onPressed: () {
          String filter = 'knocking';
          if (room.getParticipants([Membership.knock]).isEmpty) {
            filter = room.pangeaSpaceParents.isNotEmpty ? 'space' : 'contacts';
          }
          context.go('/rooms/${room.id}/details/invite?filter=$filter');
        },
        enabled: room.canInvite && !room.isDirectChat,
      ),
      ButtonDetails(
        title: l10n.download,
        icon: const Icon(Icons.download_outlined, size: 30.0),
        onPressed: widget.controller.downloadChatAction,
        visible: kIsWeb,
        enabled: room.ownPowerLevel >= 50,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.botSettings,
        icon: const BotFace(
          width: 30.0,
          expression: BotExpression.idle,
        ),
        onPressed: () => showDialog<BotOptionsModel?>(
          context: context,
          builder: (BuildContext context) => ConversationBotSettingsDialog(
            room: room,
            onSubmit: widget.controller.setBotOptions,
          ),
        ),
        visible: !room.isDirectChat || room.botOptions != null,
        enabled: room.canInvite,
      ),
      ButtonDetails(
        title: l10n.chatCapacity,
        icon: const Icon(Icons.reduce_capacity, size: 30.0),
        onPressed: widget.controller.setRoomCapacity,
        enabled: !room.isDirectChat && room.canSendDefaultStates,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.leave,
        icon: const Icon(Icons.logout_outlined, size: 30.0),
        onPressed: () async {
          final confirmed = await showOkCancelAlertDialog(
            useRootNavigator: false,
            context: context,
            title: L10n.of(context).areYouSure,
            okLabel: L10n.of(context).leave,
            cancelLabel: L10n.of(context).no,
            message: L10n.of(context).leaveRoomDescription,
            isDestructive: true,
          );
          if (confirmed != OkCancelResult.ok) return;
          final resp = await showFutureLoadingDialog(
            context: context,
            future: room.leave,
          );
          if (!resp.isError) {
            context.go("/rooms");
          }
        },
        enabled: room.membership == Membership.join,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.delete,
        icon: const Icon(Icons.delete_outline, size: 30.0),
        onPressed: () async {
          final confirmed = await showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).areYouSure,
            okLabel: L10n.of(context).delete,
            cancelLabel: L10n.of(context).cancel,
            isDestructive: true,
            message: L10n.of(context).deleteChatDesc,
          );
          if (confirmed != OkCancelResult.ok) return;

          final resp = await showFutureLoadingDialog(
            context: context,
            future: room.delete,
          );
          if (resp.isError) return;
          context.go("/rooms");
        },
        enabled: room.isRoomAdmin && !room.isDirectChat,
        showInMainView: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final buttons = _buttons(context)
        .where(
          (button) => button.visible,
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final fullButtonCapacity = (availableWidth / 120.0).floor() - 1;

          final mini = fullButtonCapacity < 4;

          final List<ButtonDetails> mainViewButtons =
              buttons.where((button) => button.showInMainView).toList();
          final List<ButtonDetails> otherButtons =
              buttons.where((button) => !button.showInMainView).toList();

          return Row(
            spacing: FluffyThemes.isColumnMode(context) ? 12.0 : 0.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(mainViewButtons.length + 1, (index) {
              if (index == mainViewButtons.length) {
                if (otherButtons.isEmpty) {
                  return const SizedBox();
                }

                return Expanded(
                  child: PopupMenuButton(
                    useRootNavigator: true,
                    itemBuilder: (context) {
                      return otherButtons
                          .map(
                            (button) => PopupMenuItem(
                              value: button,
                              onTap: button.enabled ? button.onPressed : null,
                              enabled: button.enabled,
                              child: Row(
                                children: [
                                  button.icon,
                                  const SizedBox(width: 8),
                                  Text(button.title),
                                ],
                              ),
                            ),
                          )
                          .toList();
                    },
                    child: RoomDetailsButton(
                      mini: mini,
                      buttonDetails: ButtonDetails(
                        title: L10n.of(context).more,
                        icon: const Icon(Icons.more_horiz_outlined),
                      ),
                      height: mini ? _miniButtonWidth : _buttonHeight,
                    ),
                  ),
                );
              }

              final button = mainViewButtons[index];
              return Expanded(
                child: RoomDetailsButton(
                  mini: mini,
                  buttonDetails: button,
                  height: mini ? _miniButtonWidth : _buttonHeight,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
