import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/utils/download_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:matrix/matrix.dart';

import 'matrix.dart';

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
    // #Pangea
    final PangeaController pangeaController = MatrixState.pangeaController;
    final ClassSettingsModel? classSettings = pangeaController
        .matrixState.client
        .getRoomById(widget.room.id)
        ?.firstLanguageSettings;
    // Pangea#
    notificationChangeSub ??= Matrix.of(context)
        .client
        .onAccountData
        .stream
        .where((u) => u.type == 'm.push_rules')
        .listen(
          (u) => setState(() {}),
        );
    final items = <PopupMenuEntry<String>>[
      // #Pangea
      // PopupMenuItem<String>(
      //   value: 'widgets',
      //   child: Row(
      //     children: [
      //       const Icon(Icons.widgets_outlined),
      //       const SizedBox(width: 12),
      //       Text(L10n.of(context)!.matrixWidgets),
      //     ],
      //   ),
      // ),
      PopupMenuItem<String>(
        value: 'learning_settings',
        child: Row(
          children: [
            const Icon(Icons.settings),
            const SizedBox(width: 12),
            Text(L10n.of(context)!.learningSettings),
          ],
        ),
      ),
      // Pangea#
      widget.room.pushRuleState == PushRuleState.notify
          ? PopupMenuItem<String>(
              value: 'mute',
              child: Row(
                children: [
                  const Icon(Icons.notifications_off_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.muteChat),
                ],
              ),
            )
          : PopupMenuItem<String>(
              value: 'unmute',
              child: Row(
                children: [
                  const Icon(Icons.notifications_on_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context)!.unmuteChat),
                ],
              ),
            ),
      // #Pangea
      // PopupMenuItem<String>(
      //   value: 'todos',
      //   child: Row(
      //     children: [
      //       const Icon(Icons.task_alt_outlined),
      //       const SizedBox(width: 12),
      //       Text(L10n.of(context)!.todoLists),
      //     ],
      //   ),
      // ),
      // Pangea#
      PopupMenuItem<String>(
        value: 'todos',
        child: Row(
          children: [
            const Icon(Icons.task_alt_outlined),
            const SizedBox(width: 12),
            Text(L10n.of(context)!.todoLists),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'leave',
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
      if (classSettings != null)
        PopupMenuItem<String>(
          value: 'download txt',
          child: Row(
            children: [
              const Icon(Icons.download_outlined),
              const SizedBox(width: 12),
              Text(L10n.of(context)!.downloadTxtFile),
            ],
          ),
        ),
      if (classSettings != null)
        PopupMenuItem<String>(
          value: 'download csv',
          child: Row(
            children: [
              const Icon(Icons.download_outlined),
              const SizedBox(width: 12),
              Text(L10n.of(context)!.downloadCSVFile),
            ],
          ),
        ),
      if (classSettings != null)
        PopupMenuItem<String>(
          value: 'download xlsx',
          child: Row(
            children: [
              const Icon(Icons.download_outlined),
              const SizedBox(width: 12),
              Text(L10n.of(context)!.downloadXLSXFile),
            ],
          ),
        ),
      // Pangea#
    ];
    if (widget.displayChatDetails) {
      items.insert(
        0,
        PopupMenuItem<String>(
          value: 'details',
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded),
              const SizedBox(width: 12),
              Text(L10n.of(context)!.chatDetails),
            ],
          ),
        ),
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        KeyBoardShortcuts(
          keysToPress: {
            LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.keyI,
          },
          helpLabel: L10n.of(context)!.chatDetails,
          onKeysPressed: _showChatDetails,
          child: const SizedBox.shrink(),
        ),
        PopupMenuButton(
          onSelected: (String choice) async {
            switch (choice) {
              case 'leave':
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
              case 'mute':
                await showFutureLoadingDialog(
                  context: context,
                  future: () =>
                      widget.room.setPushRuleState(PushRuleState.mentionsOnly),
                );
                break;
              case 'unmute':
                await showFutureLoadingDialog(
                  context: context,
                  future: () =>
                      widget.room.setPushRuleState(PushRuleState.notify),
                );
                break;
              // #Pangea
              // case 'todos':
              //   context.go('/rooms/${widget.room.id}/tasks');
              //   break;
              // Pangea#
              case 'details':
                _showChatDetails();
                break;
              // #Pangea
              case 'download txt':
                showFutureLoadingDialog(
                  context: context,
                  future: () => downloadChat(
                    widget.room,
                    classSettings!,
                    DownloadType.txt,
                    Matrix.of(context).client,
                    context,
                  ),
                );
                break;
              case 'download csv':
                showFutureLoadingDialog(
                  context: context,
                  future: () => downloadChat(
                    widget.room,
                    classSettings!,
                    DownloadType.csv,
                    Matrix.of(context).client,
                    context,
                  ),
                );
                break;
              case 'download xlsx':
                showFutureLoadingDialog(
                  context: context,
                  future: () => downloadChat(
                    widget.room,
                    classSettings!,
                    DownloadType.xlsx,
                    Matrix.of(context).client,
                    context,
                  ),
                );
                break;
              case 'learning_settings':
                context.go('/rooms/settings/learning');
                break;
              // #Pangea
            }
          },
          itemBuilder: (BuildContext context) => items,
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
