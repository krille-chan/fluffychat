import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/default_app_bar_search_field.dart';
import 'package:fluffychat/components/default_bottom_navigation_bar.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../utils/client_presence_extension.dart';
import '../utils/presence_extension.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  StreamSubscription _onSync;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _onSync?.cancel();
    super.dispose();
  }

  DateTime _lastSetState = DateTime.now();
  Timer _coolDown;

  void _updateView() {
    _lastSetState = DateTime.now();
    setState(() => null);
  }

  void _setStatus(BuildContext context) async {
    final input = await showTextInputDialog(
        context: context,
        title: L10n.of(context).setStatus,
        okLabel: L10n.of(context).ok,
        cancelLabel: L10n.of(context).cancel,
        useRootNavigator: false,
        textFields: [
          DialogTextField(
            hintText: L10n.of(context).statusExampleMessage,
          ),
        ]);
    if (input == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.sendPresence(
            Matrix.of(context).client.userID,
            PresenceType.online,
            statusMsg: input.single,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    _onSync ??= client.onSync.stream.listen((_) {
      if (DateTime.now().millisecondsSinceEpoch -
              _lastSetState.millisecondsSinceEpoch <
          1000) {
        _coolDown?.cancel();
        _coolDown = Timer(Duration(seconds: 1), _updateView);
      } else {
        _updateView();
      }
    });
    final contactList = Matrix.of(context)
        .client
        .contactList
        .where((p) =>
            p.senderId.toLowerCase().contains(_controller.text.toLowerCase()))
        .toList();
    if (client.presences[client.userID]?.presence?.statusMsg?.isNotEmpty ??
        false) {
      contactList.insert(0, client.presences[client.userID]);
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Text(L10n.of(context).contacts),
        actions: [
          TextButton.icon(
            label: Text(
              L10n.of(context).status,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            icon:
                Icon(Icons.edit_outlined, color: Theme.of(context).accentColor),
            onPressed: () => _setStatus(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: contactList.length + 1,
        itemBuilder: (_, i) => i == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: DefaultAppBarSearchField(
                      hintText: L10n.of(context).search,
                      prefixIcon: Icon(Icons.search_outlined),
                      searchController: _controller,
                      onChanged: (_) => setState(() => null),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: Avatar.defaultSize / 2,
                      child: Icon(Icons.person_add_outlined),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    title: Text(L10n.of(context).addNewContact),
                    onTap: () => AdaptivePageLayout.of(context)
                        .pushNamed('/newprivatechat'),
                  ),
                  Divider(height: 1),
                  if (contactList.isEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 16),
                        Icon(
                          Icons.share_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        Center(
                          child: OutlinedButton(
                            child: Text(
                              L10n.of(context).inviteContact,
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                            ),
                            onPressed: () => FluffyShare.share(
                                L10n.of(context).inviteText(client.userID,
                                    'https://matrix.to/#/${client.userID}'),
                                context),
                          ),
                        ),
                      ],
                    ),
                ],
              )
            : _ContactListTile(contact: contactList[i - 1]),
      ),
      bottomNavigationBar: DefaultBottomNavigationBar(currentIndex: 0),
    );
  }
}

class _ContactListTile extends StatelessWidget {
  final Presence contact;

  const _ContactListTile({Key key, @required this.contact}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Profile>(
        future:
            Matrix.of(context).client.getProfileFromUserId(contact.senderId),
        builder: (context, snapshot) {
          final displayname =
              snapshot.data?.displayname ?? contact.senderId.localpart;
          final avatarUrl = snapshot.data?.avatarUrl;
          return ListTile(
            leading: Container(
              width: Avatar.defaultSize,
              height: Avatar.defaultSize,
              child: Stack(
                children: [
                  Center(child: Avatar(avatarUrl, displayname)),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.circle,
                      color: contact.color,
                      size: 12,
                    ),
                  ),
                ],
              ),
            ),
            title: Text(displayname),
            subtitle: Text(contact.getLocalizedStatusMessage(context),
                style: contact.presence.statusMsg?.isNotEmpty ?? false
                    ? TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      )
                    : null),
            onTap: () => AdaptivePageLayout.of(context).pushNamed(
                '/rooms/${Matrix.of(context).client.getDirectChatFromUserId(contact.senderId)}'),
          );
        });
  }
}
