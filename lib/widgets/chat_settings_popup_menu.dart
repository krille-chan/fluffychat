import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:vrouter/vrouter.dart';
import 'matrix.dart';

class ChatSettingsPopupMenu extends StatefulWidget {
  final Room room;
  final bool displayChatDetails;
  const ChatSettingsPopupMenu(this.room, this.displayChatDetails, {Key key})
      : super(key: key);

  @override
  _ChatSettingsPopupMenuState createState() => _ChatSettingsPopupMenuState();
}

class _ChatSettingsPopupMenuState extends State<ChatSettingsPopupMenu> {
  StreamSubscription notificationChangeSub;

  @override
  void dispose() {
    notificationChangeSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notificationChangeSub ??= Matrix.of(context)
        .client
        .onAccountData
        .stream
        .where((u) => u.type == 'm.push_rules')
        .listen(
          (u) => setState(() => null),
        );
    final items = <PopupMenuEntry<String>>[
      widget.room.pushRuleState == PushRuleState.notify
          ? PopupMenuItem<String>(
              value: 'mute',
              child: Text(L10n.of(context).muteChat),
            )
          : PopupMenuItem<String>(
              value: 'unmute',
              child: Text(L10n.of(context).unmuteChat),
            ),
      PopupMenuItem<String>(
        value: 'leave',
        child: Text(L10n.of(context).leave),
      ),
    ];
    if (widget.displayChatDetails) {
      items.insert(
        0,
        PopupMenuItem<String>(
          value: 'details',
          child: Text(L10n.of(context).chatDetails),
        ),
      );
    }
    return PopupMenuButton(
      onSelected: (String choice) async {
        switch (choice) {
          case 'leave':
            final confirmed = await showOkCancelAlertDialog(
              context: context,
              title: L10n.of(context).areYouSure,
              okLabel: L10n.of(context).ok,
              cancelLabel: L10n.of(context).cancel,
            );
            if (confirmed == OkCancelResult.ok) {
              final success = await showFutureLoadingDialog(
                  context: context, future: () => widget.room.leave());
              if (success.error == null) {
                VRouter.of(context).push('/rooms');
              }
            }
            break;
          case 'mute':
            await showFutureLoadingDialog(
                context: context,
                future: () =>
                    widget.room.setPushRuleState(PushRuleState.mentionsOnly));
            break;
          case 'unmute':
            await showFutureLoadingDialog(
                context: context,
                future: () =>
                    widget.room.setPushRuleState(PushRuleState.notify));
            break;
          case 'details':
            VRouter.of(context).push('/rooms/${widget.room.id}/details');
            break;
        }
      },
      itemBuilder: (BuildContext context) => items,
    );
  }
}
