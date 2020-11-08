import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../components/dialogs/simple_dialogs.dart';
import '../utils/app_route.dart';
import 'key_verification.dart';

class ChatEncryptionSettingsView extends StatelessWidget {
  final String id;

  const ChatEncryptionSettingsView(this.id, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AdaptivePageLayout(
      firstScaffold: ChatList(
        activeChat: id,
      ),
      secondScaffold: ChatEncryptionSettings(id),
      primaryPage: FocusPage.SECOND,
    );
  }
}

class ChatEncryptionSettings extends StatefulWidget {
  final String id;

  const ChatEncryptionSettings(this.id, {Key key}) : super(key: key);

  @override
  _ChatEncryptionSettingsState createState() => _ChatEncryptionSettingsState();
}

class _ChatEncryptionSettingsState extends State<ChatEncryptionSettings> {
  Future<void> onSelected(
      BuildContext context, String action, DeviceKeys key) async {
    final room = Matrix.of(context).client.getRoomById(widget.id);
    final unblock = () async {
      if (key.blocked) {
        await key.setBlocked(false);
      }
    };
    switch (action) {
      case 'verify':
        await unblock();
        final req = key.startVerification();
        req.onUpdate = () {
          if (req.state == KeyVerificationState.done) {
            setState(() => null);
          }
        };
        await Navigator.of(context).push(
          AppRoute.defaultRoute(
            context,
            KeyVerificationView(request: req),
          ),
        );
        break;
      case 'verify_manual':
        if (await SimpleDialogs(context).askConfirmation(
          titleText: L10n.of(context).isDeviceKeyCorrect,
          contentText: key.ed25519Key.beautified,
        )) {
          await unblock();
          await key.setVerified(true);
          setState(() => null);
        }
        break;
      case 'verify_user':
        await unblock();
        final req =
            await room.client.userDeviceKeys[key.userId].startVerification();
        req.onUpdate = () {
          if (req.state == KeyVerificationState.done) {
            setState(() => null);
          }
        };
        await Navigator.of(context).push(
          AppRoute.defaultRoute(
            context,
            KeyVerificationView(request: req),
          ),
        );
        break;
      case 'block':
        if (key.directVerified) {
          await key.setVerified(false);
        }
        await key.setBlocked(true);
        setState(() => null);
        break;
      case 'unblock':
        await unblock();
        setState(() => null);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(widget.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).participatingUserDevices),
      ),
      body: StreamBuilder(
          stream: room.onUpdate.stream,
          builder: (context, snapshot) {
            return FutureBuilder<List<DeviceKeys>>(
              future: room.getUserDeviceKeys(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(L10n.of(context).oopsSomethingWentWrong +
                        ': ' +
                        snapshot.error.toString()),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final deviceKeys = snapshot.data;
                return ListView.separated(
                  separatorBuilder: (BuildContext context, int i) =>
                      Divider(height: 1),
                  itemCount: deviceKeys.length,
                  itemBuilder: (BuildContext context, int i) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (i == 0 ||
                          deviceKeys[i].userId != deviceKeys[i - 1].userId)
                        Material(
                          child: PopupMenuButton(
                            onSelected: (action) =>
                                onSelected(context, action, deviceKeys[i]),
                            itemBuilder: (c) {
                              var items = <PopupMenuEntry<String>>[];
                              if (room
                                      .client
                                      .userDeviceKeys[deviceKeys[i].userId]
                                      .verified ==
                                  UserVerifiedStatus.unknown) {
                                items.add(PopupMenuItem(
                                  child: Text(L10n.of(context).verifyUser),
                                  value: 'verify_user',
                                ));
                              }
                              return items;
                            },
                            child: ListTile(
                              leading: Avatar(
                                room
                                    .getUserByMXIDSync(deviceKeys[i].userId)
                                    .avatarUrl,
                                room
                                    .getUserByMXIDSync(deviceKeys[i].userId)
                                    .calcDisplayname(),
                              ),
                              title: Text(room
                                  .getUserByMXIDSync(deviceKeys[i].userId)
                                  .calcDisplayname()),
                              subtitle: Text(deviceKeys[i].userId),
                            ),
                          ),
                          elevation: 2,
                        ),
                      PopupMenuButton(
                        onSelected: (action) =>
                            onSelected(context, action, deviceKeys[i]),
                        itemBuilder: (c) {
                          var items = <PopupMenuEntry<String>>[];
                          if (deviceKeys[i].blocked ||
                              !deviceKeys[i].verified) {
                            if (deviceKeys[i].userId == room.client.userID) {
                              items.add(PopupMenuItem(
                                child: Text(L10n.of(context).verifyStart),
                                value: 'verify',
                              ));
                              items.add(PopupMenuItem(
                                child: Text(L10n.of(context).verifyManual),
                                value: 'verify_manual',
                              ));
                            } else {
                              items.add(PopupMenuItem(
                                child: Text(L10n.of(context).verifyUser),
                                value: 'verify_user',
                              ));
                            }
                          }
                          if (deviceKeys[i].blocked) {
                            items.add(PopupMenuItem(
                              child: Text(L10n.of(context).unblockDevice),
                              value: 'unblock',
                            ));
                          }
                          if (!deviceKeys[i].blocked) {
                            items.add(PopupMenuItem(
                              child: Text(L10n.of(context).blockDevice),
                              value: 'block',
                            ));
                          }
                          return items;
                        },
                        child: ListTile(
                          title: Text(
                            '${deviceKeys[i].deviceDisplayName ?? L10n.of(context).unknownDevice} - ${deviceKeys[i].deviceId}',
                            style: TextStyle(
                                color: deviceKeys[i].blocked
                                    ? Colors.red
                                    : deviceKeys[i].verified
                                        ? Colors.green
                                        : Colors.orange),
                          ),
                          subtitle: Text(
                            deviceKeys[i].ed25519Key.beautified,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}
