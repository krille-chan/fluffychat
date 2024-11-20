import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/utils/download_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'matrix.dart';

enum ChatPopupMenuActions {
  details,
  mute,
  unmute,
  leave,
  search,
  // #Pangea
  downloadTxt,
  downloadCsv,
  downloadXlsx,
  learningSettings,
  // Pangea#
}

class ChatSettingsPopupMenu extends StatefulWidget {
  final Room room;
  final bool displayChatDetails;

  const ChatSettingsPopupMenu(this.room, this.displayChatDetails, {super.key});

  @override
  ChatSettingsPopupMenuState createState() => ChatSettingsPopupMenuState();
}

class ChatSettingsPopupMenuState extends State<ChatSettingsPopupMenu> {
  StreamSubscription? notificationChangeSub;

  @override
  void dispose() {
    notificationChangeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
    return Stack(
      alignment: Alignment.center,
      children: [
        // #Pangea
        // KeyBoardShortcuts(
        //   keysToPress: {
        //     LogicalKeyboardKey.controlLeft,
        //     LogicalKeyboardKey.keyI,
        //   },
        //   helpLabel: L10n.of(context)!.chatDetails,
        //   onKeysPressed: _showChatDetails,
        //   child: const SizedBox.shrink(),
        // ),
        // Pangea#
        PopupMenuButton<ChatPopupMenuActions>(
          onSelected: (choice) async {
            switch (choice) {
              case ChatPopupMenuActions.leave:
                final confirmed = await showOkCancelAlertDialog(
                  useRootNavigator: false,
                  context: context,
                  title: L10n.of(context)!.areYouSure,
                  okLabel: L10n.of(context)!.ok,
                  cancelLabel: L10n.of(context)!.cancel,
                  message: L10n.of(context)!.archiveRoomDescription,
                );
                if (confirmed == OkCancelResult.ok) {
                  final success = await showFutureLoadingDialog(
                    context: context,
                    future: () => widget.room.leave(),
                  );
                  if (success.error == null) {
                    context.go('/rooms');
                  }
                }
                break;
              case ChatPopupMenuActions.mute:
                await showFutureLoadingDialog(
                  context: context,
                  future: () =>
                      widget.room.setPushRuleState(PushRuleState.mentionsOnly),
                );
                break;
              case ChatPopupMenuActions.unmute:
                await showFutureLoadingDialog(
                  context: context,
                  future: () =>
                      widget.room.setPushRuleState(PushRuleState.notify),
                );
                break;
              case ChatPopupMenuActions.details:
                _showChatDetails();
                break;
              case ChatPopupMenuActions.search:
                context.go('/rooms/${widget.room.id}/search');
                break;
              // #Pangea
              case ChatPopupMenuActions.downloadTxt:
                showFutureLoadingDialog(
                  context: context,
                  future: () => downloadChat(
                    widget.room,
                    DownloadType.txt,
                    context,
                  ),
                );
                break;
              case ChatPopupMenuActions.downloadCsv:
                showFutureLoadingDialog(
                  context: context,
                  future: () => downloadChat(
                    widget.room,
                    DownloadType.csv,
                    context,
                  ),
                );
                break;
              case ChatPopupMenuActions.downloadXlsx:
                showFutureLoadingDialog(
                  context: context,
                  future: () => downloadChat(
                    widget.room,
                    DownloadType.xlsx,
                    context,
                  ),
                );
                break;
              case ChatPopupMenuActions.learningSettings:
                showDialog(
                  context: context,
                  builder: (c) => const SettingsLearning(),
                );
                break;
              // Pangea#
            }
          },
          itemBuilder: (BuildContext context) => [
            if (widget.displayChatDetails)
              PopupMenuItem<ChatPopupMenuActions>(
                value: ChatPopupMenuActions.details,
                child: Row(
                  children: [
                    const Icon(Icons.settings_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.chatDetails),
                  ],
                ),
              ),
            // #Pangea
            PopupMenuItem<ChatPopupMenuActions>(
              value: ChatPopupMenuActions.learningSettings,
              child: Row(
                children: [
                  const Icon(Icons.psychology_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.learningSettings),
                ],
              ),
            ),
            // Pangea#
            if (widget.room.pushRuleState == PushRuleState.notify)
              PopupMenuItem<ChatPopupMenuActions>(
                value: ChatPopupMenuActions.mute,
                child: Row(
                  children: [
                    const Icon(Icons.notifications_off_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.muteChat),
                  ],
                ),
              )
            else
              PopupMenuItem<ChatPopupMenuActions>(
                value: ChatPopupMenuActions.unmute,
                child: Row(
                  children: [
                    const Icon(Icons.notifications_on_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context)!.unmuteChat),
                  ],
                ),
              ),
            PopupMenuItem<ChatPopupMenuActions>(
              value: ChatPopupMenuActions.search,
              child: Row(
                children: [
                  const Icon(Icons.search_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.search),
                ],
              ),
            ),
            PopupMenuItem<ChatPopupMenuActions>(
              value: ChatPopupMenuActions.leave,
              child: Row(
                children: [
                  // #Pangea
                  // const Icon(Icons.delete_outlined),
                  const Icon(Icons.arrow_forward),
                  // Pangea#
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.leave),
                ],
              ),
            ),
            // #Pangea
            PopupMenuItem<ChatPopupMenuActions>(
              value: ChatPopupMenuActions.downloadTxt,
              child: Row(
                children: [
                  const Icon(Icons.download_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.downloadTxtFile),
                ],
              ),
            ),
            PopupMenuItem<ChatPopupMenuActions>(
              value: ChatPopupMenuActions.downloadCsv,
              child: Row(
                children: [
                  const Icon(Icons.download_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.downloadCSVFile),
                ],
              ),
            ),
            PopupMenuItem<ChatPopupMenuActions>(
              value: ChatPopupMenuActions.downloadXlsx,
              child: Row(
                children: [
                  const Icon(Icons.download_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.downloadXLSXFile),
                ],
              ),
            ),
            // Pangea#
          ],
        ),
      ],
    );
  }

  void _showChatDetails() {
    if (GoRouterState.of(context).uri.path.endsWith('/details')) {
      context.go('/rooms/${widget.room.id}');
    } else {
      context.go('/rooms/${widget.room.id}/details');
    }
  }
}
