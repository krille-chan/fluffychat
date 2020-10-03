import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:flutter/material.dart';
import 'package:fluffychat/utils/presence_extension.dart';

import 'chat.dart';

class PresenceView extends StatelessWidget {
  final Uri avatarUrl;
  final String displayname;
  final Presence presence;
  final bool composeMode;
  final TextEditingController _composeController = TextEditingController();

  PresenceView({
    this.composeMode = false,
    this.presence,
    this.avatarUrl,
    this.displayname,
    Key key,
  }) : super(key: key);

  void _sendMessageAction(BuildContext context) async {
    final roomId = await User(
      presence.senderId,
      room: Room(id: '', client: Matrix.of(context).client),
    ).startDirectChat();
    await Navigator.of(context).pushAndRemoveUntil(
        AppRoute.defaultRoute(
          context,
          ChatView(roomId),
        ),
        (Route r) => r.isFirst);
  }

  void _setStatusAction(BuildContext context) async {
    if (_composeController.text.isEmpty) return;
    await SimpleDialogs(context).tryRequestWithLoadingDialog(
      Matrix.of(context).client.sendPresence(
          Matrix.of(context).client.userID, PresenceType.online,
          statusMsg: _composeController.text),
    );
    await Navigator.of(context).popUntil((Route r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    if (composeMode == false && presence == null) {
      throw ('If composeMode is null then the presence must be not null!');
    }
    final padding = const EdgeInsets.only(
      top: 16.0,
      right: 16.0,
      left: 16.0,
      bottom: 64.0,
    );
    return Scaffold(
      backgroundColor: displayname.color,
      extendBody: true,
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: Navigator.of(context).pop,
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Avatar(avatarUrl, displayname),
          title: Text(
            displayname,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            presence?.senderId ?? Matrix.of(context).client.userID,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              displayname.color,
              Theme.of(context).primaryColor,
              displayname.color,
            ],
          ),
        ),
        child: composeMode
            ? Padding(
                padding: padding,
                child: TextField(
                  controller: _composeController,
                  autofocus: true,
                  minLines: 1,
                  maxLines: 20,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              )
            : ListView(
                shrinkWrap: true,
                padding: padding,
                children: [
                  Text(
                    presence.getLocalizedStatusMessage(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        icon: Icon(composeMode ? Icons.edit : Icons.message_outlined),
        label: Text(composeMode
            ? L10n.of(context).setStatus
            : L10n.of(context).sendAMessage),
        onPressed: () => composeMode
            ? _setStatusAction(context)
            : _sendMessageAction(context),
      ),
    );
  }
}
