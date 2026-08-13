// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/stt/stt_model_picker.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'matrix.dart';

enum ChatPopupMenuActions { details, encryption, leave, search, sttModel }

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
    notificationChangeSub ??= Matrix.of(context).client.onSync.stream
        .where(
          (syncUpdate) =>
              syncUpdate.accountData?.any(
                (accountData) => accountData.type == 'm.push_rules',
              ) ??
              false,
        )
        .listen((u) => setState(() {}));
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox.shrink(),
        PopupMenuButton<ChatPopupMenuActions>(
          useRootNavigator: true,
          onSelected: (choice) async {
            switch (choice) {
              case ChatPopupMenuActions.leave:
                final l10n = L10n.of(context);
                final router = GoRouter.of(context);
                final confirmed = await showOkCancelAlertDialog(
                  context: context,
                  title: l10n.areYouSure,
                  message: l10n.archiveRoomDescription,
                  okLabel: l10n.leave,
                  cancelLabel: l10n.cancel,
                  isDestructive: true,
                );
                if (confirmed != OkCancelResult.ok) return;
                if (!context.mounted) return;
                final result = await showFutureLoadingDialog(
                  context: context,
                  future: () => widget.room.leave(),
                );
                if (result.error == null) {
                  router.go('/rooms');
                }

                break;
              case ChatPopupMenuActions.details:
                _showChatDetails();
                break;
              case ChatPopupMenuActions.search:
                context.go('/rooms/${widget.room.id}/search');
                break;
              case ChatPopupMenuActions.encryption:
                context.go('/rooms/${widget.room.id}/encryption');
                break;
              case ChatPopupMenuActions.sttModel:
                await showSttModelPicker(context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            if (widget.displayChatDetails)
              PopupMenuItem<ChatPopupMenuActions>(
                value: ChatPopupMenuActions.details,
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).chatDetails),
                  ],
                ),
              ),
            PopupMenuItem<ChatPopupMenuActions>(
              value: ChatPopupMenuActions.search,
              child: Row(
                children: [
                  const Icon(Icons.search_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).search),
                ],
              ),
            ),
            PopupMenuItem<ChatPopupMenuActions>(
              value: ChatPopupMenuActions.encryption,
              child: Row(
                children: [
                  const Icon(Icons.lock_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).encryption),
                ],
              ),
            ),
            if (Matrix.of(context).stt.isFeatureAvailable &&
                Matrix.of(context).stt.onDeviceAvailable)
              PopupMenuItem<ChatPopupMenuActions>(
                value: ChatPopupMenuActions.sttModel,
                child: Row(
                  children: [
                    const Icon(Icons.subtitles_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).speechToTextModel),
                    const Spacer(),
                    Text(
                      AppSettings.sttModel.value,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            PopupMenuItem<ChatPopupMenuActions>(
              value: ChatPopupMenuActions.leave,
              child: Row(
                children: [
                  const Icon(Icons.delete_outlined),
                  const SizedBox(width: 12),
                  Text(L10n.of(context).leave),
                ],
              ),
            ),
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
