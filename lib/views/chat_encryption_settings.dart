import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/components/dialogs/confirm_dialog.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/views/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

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
        title: Text(I18n.of(context).end2endEncryptionSettings),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(I18n.of(context).encryptionAlgorithm),
            subtitle: Text(room.encryptionAlgorithm ?? I18n.of(context).none),
            trailing: Icon(room.encrypted ? Icons.lock : Icons.lock_open,
                color: room.encrypted ? Colors.green : Colors.red),
            onTap: () {
              if (room.encrypted) return;
              if (!Matrix.of(context).encryptionEnabled) {
                Toast.show(I18n.of(context).needPantalaimonWarning, context,
                    duration: 8);
                return;
              }
              showDialog(
                context: context,
                builder: (BuildContext context) => ConfirmDialog(
                  I18n.of(context).enableEncryptionWarning,
                  I18n.of(context).yes,
                  (context) => Matrix.of(context).tryRequestWithLoadingDialog(
                    room.enableEncryption(),
                  ),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.info),
            subtitle: Text(
              Matrix.of(context).encryptionEnabled
                  ? I18n.of(context).warningEncryptionInBeta
                  : I18n.of(context).needPantalaimonWarning,
            ),
          ),
          Divider(height: 1),
          if (room.encrypted)
            ListTile(
              title: Text(
                "${I18n.of(context).participatingUserDevices}:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (room.encrypted) Divider(height: 1),
          if (room.encrypted)
            FutureBuilder<List<DeviceKeys>>(
              future: room.getUserDeviceKeys(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(I18n.of(context).oopsSomethingWentWrong +
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
                    itemBuilder: (BuildContext context, int i) =>
                        CheckboxListTile(
                      title: Text(
                        "${deviceKeys[i].userId} - ${deviceKeys[i].deviceId}",
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
                        style: TextStyle(color: Colors.black),
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
                            deviceKeys[i]
                                .setVerified(false, Matrix.of(context).client);
                          }
                          deviceKeys[i]
                              .setBlocked(true, Matrix.of(context).client);
                        }
                        setState(() => null);
                      },
                    ),
                  ),
                );
              },
            ),
          if (room.encrypted)
            ListTile(
              title: Text("Outbound MegOlm session ID:"),
              subtitle: Text(
                  room.outboundGroupSession?.session_id()?.beautified ??
                      "None"),
            ),
        ],
      ),
    );
  }
}
