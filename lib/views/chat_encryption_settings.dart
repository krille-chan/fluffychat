import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/avatar.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../components/dialogs/key_verification_dialog.dart';

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
        await KeyVerificationDialog(
          request: req,
          l10n: L10n.of(context),
        ).show(context);
        break;
      case 'verify_manual':
        if (await showOkCancelAlertDialog(
              context: context,
              title: L10n.of(context).isDeviceKeyCorrect,
              message: key.ed25519Key.beautified,
              okLabel: L10n.of(context).ok,
              cancelLabel: L10n.of(context).cancel,
            ) ==
            OkCancelResult.ok) {
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
        await KeyVerificationDialog(
          request: req,
          l10n: L10n.of(context),
        ).show(context);
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => FlushbarHelper.createInformation(
              message: L10n.of(context).warningEncryptionInBeta)
          .show(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(widget.id);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
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
                            } else {
                              items.add(PopupMenuItem(
                                child: Text(L10n.of(context).verifyUser),
                                value: 'verify_user',
                              ));
                            }
                            items.add(PopupMenuItem(
                              child: Text(L10n.of(context).verifyManual),
                              value: 'verify_manual',
                            ));
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
                            '${deviceKeys[i].deviceDisplayName ?? L10n.of(context).unknownDevice}',
                            style: TextStyle(
                                color: deviceKeys[i].blocked
                                    ? Colors.red
                                    : deviceKeys[i].verified
                                        ? Colors.green
                                        : Colors.orange),
                          ),
                          subtitle: Text(
                            '${L10n.of(context).deviceId}: ${deviceKeys[i].deviceId}',
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
