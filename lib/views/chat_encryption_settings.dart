import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/avatar.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:fluffychat/views/widgets/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../views/widgets/dialogs/key_verification_dialog.dart';
import '../utils/device_extension.dart';

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
        await KeyVerificationDialog(request: req).show(context);
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
        await KeyVerificationDialog(request: req).show(context);
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
        leading: BackButton(),
        title: Text(L10n.of(context).tapOnDeviceToVerify),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: ListTile(
            title: Text(L10n.of(context).deviceVerifyDescription),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              foregroundColor: Theme.of(context).accentColor,
              child: Icon(Icons.lock),
            ),
          ),
        ),
      ),
      body: MaxWidthBody(
        withScrolling: true,
        child: StreamBuilder(
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: deviceKeys.length,
                    itemBuilder: (BuildContext context, int i) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (i == 0 ||
                            deviceKeys[i].userId !=
                                deviceKeys[i - 1].userId) ...{
                          Divider(height: 1, thickness: 1),
                          PopupMenuButton(
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
                                  value: 'verify_user',
                                  child: Text(L10n.of(context).verifyUser),
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
                              title: Row(
                                children: [
                                  Text(
                                    room
                                        .getUserByMXIDSync(deviceKeys[i].userId)
                                        .calcDisplayname(),
                                  ),
                                  Spacer(),
                                  Text(
                                    deviceKeys[i].userId,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color
                                          .withAlpha(150),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        },
                        PopupMenuButton(
                          onSelected: (action) =>
                              onSelected(context, action, deviceKeys[i]),
                          itemBuilder: (c) {
                            var items = <PopupMenuEntry<String>>[];
                            if (deviceKeys[i].blocked ||
                                !deviceKeys[i].verified) {
                              items.add(PopupMenuItem(
                                value:
                                    deviceKeys[i].userId == room.client.userID
                                        ? 'verify'
                                        : 'verify_user',
                                child: Text(L10n.of(context).verifyStart),
                              ));
                            }
                            if (deviceKeys[i].blocked) {
                              items.add(PopupMenuItem(
                                value: 'unblock',
                                child: Text(L10n.of(context).unblockDevice),
                              ));
                            }
                            if (!deviceKeys[i].blocked) {
                              items.add(PopupMenuItem(
                                value: 'block',
                                child: Text(L10n.of(context).blockDevice),
                              ));
                            }
                            return items;
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              foregroundColor:
                                  Theme.of(context).textTheme.bodyText1.color,
                              backgroundColor:
                                  Theme.of(context).secondaryHeaderColor,
                              child: Icon(deviceKeys[i].icon),
                            ),
                            title: Text(
                              deviceKeys[i].displayname,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  deviceKeys[i].deviceId,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color
                                        .withAlpha(150),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  deviceKeys[i].blocked
                                      ? L10n.of(context).blocked
                                      : deviceKeys[i].verified
                                          ? L10n.of(context).verified
                                          : L10n.of(context).unknownDevice,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: deviceKeys[i].blocked
                                        ? Colors.red
                                        : deviceKeys[i].verified
                                            ? Colors.green
                                            : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
