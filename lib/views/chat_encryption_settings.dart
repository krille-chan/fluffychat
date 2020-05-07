import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:flutter/material.dart';

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
  Room room;

  StreamSubscription roomUpdate;

  @override
  void dispose() {
    roomUpdate?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    room ??= Matrix.of(context).client.getRoomById(widget.id);
    roomUpdate ??= room.onUpdate.stream.listen((s) => setState(() => null));

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).participatingUserDevices),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder<List<DeviceKeys>>(
            future: room.getUserDeviceKeys(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(L10n.of(context).oopsSomethingWentWrong +
                      ": " +
                      snapshot.error.toString()),
                );
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final List<DeviceKeys> deviceKeys = snapshot.data;
              return Expanded(
                child: ListView.separated(
                  separatorBuilder: (BuildContext context, int i) =>
                      Divider(height: 1),
                  itemCount: deviceKeys.length,
                  itemBuilder: (BuildContext context, int i) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (i == 0 ||
                          deviceKeys[i].userId != deviceKeys[i - 1].userId)
                        Material(
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
                          elevation: 2,
                        ),
                      CheckboxListTile(
                        title: Text(
                          "${deviceKeys[i].unsigned["device_display_name"] ?? L10n.of(context).unknownDevice} - ${deviceKeys[i].deviceId}",
                          style: TextStyle(
                              color: deviceKeys[i].blocked
                                  ? Colors.red
                                  : deviceKeys[i].verified
                                      ? Colors.green
                                      : Colors.orange),
                        ),
                        subtitle: Text(
                          deviceKeys[i]
                              .keys["ed25519:${deviceKeys[i].deviceId}"]
                              .beautified,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color),
                        ),
                        value: deviceKeys[i].verified,
                        onChanged: (bool newVal) {
                          if (newVal == true) {
                            if (deviceKeys[i].blocked) {
                              deviceKeys[i]
                                  .setBlocked(false, Matrix.of(context).client);
                            }
                            deviceKeys[i]
                                .setVerified(true, Matrix.of(context).client);
                          } else {
                            if (deviceKeys[i].verified) {
                              deviceKeys[i].setVerified(
                                  false, Matrix.of(context).client);
                            }
                            deviceKeys[i]
                                .setBlocked(true, Matrix.of(context).client);
                          }
                          setState(() => null);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Divider(thickness: 1, height: 1),
          ListTile(
            title: Text("Outbound MegOlm session ID:"),
            subtitle: Text(
                room.outboundGroupSession?.session_id()?.beautified ?? "None"),
          ),
        ],
      ),
    );
  }
}
