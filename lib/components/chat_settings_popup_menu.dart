import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/views/chat_details.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dialogs/simple_dialogs.dart';
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

  void startCallAction(BuildContext context) async {
    final url =
        '${Matrix.of(context).jitsiInstance}${Uri.encodeComponent(widget.room.id.localpart)}';
    final success = await SimpleDialogs(context)
        .tryRequestWithLoadingDialog(widget.room.sendEvent({
      'msgtype': Matrix.callNamespace,
      'body': url,
    }));
    if (success == false) return;
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    notificationChangeSub ??= Matrix.of(context)
        .client
        .onUserEvent
        .stream
        .where((u) => u.type == 'account_data' && u.eventType == "m.push_rules")
        .listen(
          (u) => setState(() => null),
        );
    List<PopupMenuEntry<String>> items = <PopupMenuEntry<String>>[
      widget.room.pushRuleState == PushRuleState.notify
          ? PopupMenuItem<String>(
              value: "mute",
              child: Text(L10n.of(context).muteChat),
            )
          : PopupMenuItem<String>(
              value: "unmute",
              child: Text(L10n.of(context).unmuteChat),
            ),
      PopupMenuItem<String>(
        value: "call",
        child: Text(L10n.of(context).videoCall),
      ),
      PopupMenuItem<String>(
        value: "leave",
        child: Text(L10n.of(context).leave),
      ),
    ];
    if (widget.displayChatDetails) {
      items.insert(
        0,
        PopupMenuItem<String>(
          value: "details",
          child: Text(L10n.of(context).chatDetails),
        ),
      );
    }
    return PopupMenuButton(
      onSelected: (String choice) async {
        switch (choice) {
          case "leave":
            bool confirmed = await SimpleDialogs(context).askConfirmation();
            if (confirmed) {
              final success = await SimpleDialogs(context)
                  .tryRequestWithLoadingDialog(widget.room.leave());
              if (success != false) {
                await Navigator.of(context).pushAndRemoveUntil(
                    AppRoute.defaultRoute(context, ChatListView()),
                    (Route r) => false);
              }
            }
            break;
          case "mute":
            await SimpleDialogs(context).tryRequestWithLoadingDialog(
                widget.room.setPushRuleState(PushRuleState.mentions_only));
            break;
          case "unmute":
            await SimpleDialogs(context).tryRequestWithLoadingDialog(
                widget.room.setPushRuleState(PushRuleState.notify));
            break;
          case "call":
            startCallAction(context);
            break;
          case "details":
            await Navigator.of(context).push(
              AppRoute.defaultRoute(
                context,
                ChatDetails(widget.room),
              ),
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => items,
    );
  }
}
