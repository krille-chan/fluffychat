import 'package:matrix/matrix.dart';
import 'package:fluffychat/pages/chat_encryption_settings.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:vrouter/vrouter.dart';
import '../../utils/matrix_sdk_extensions.dart/device_extension.dart';

class ChatEncryptionSettingsView extends StatelessWidget {
  final ChatEncryptionSettingsController controller;

  const ChatEncryptionSettingsView(this.controller, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(controller.roomId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () =>
              VRouter.of(context).toSegments(['rooms', controller.roomId]),
        ),
        title: Text(L10n.of(context).tapOnDeviceToVerify),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: ListTile(
            title: Text(L10n.of(context).deviceVerifyDescription),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              foregroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.lock),
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
                    return const Center(
                        child:
                            CircularProgressIndicator.adaptive(strokeWidth: 2));
                  }
                  final deviceKeys = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: deviceKeys.length,
                    itemBuilder: (BuildContext context, int i) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (i == 0 ||
                            deviceKeys[i].userId !=
                                deviceKeys[i - 1].userId) ...{
                          const Divider(height: 1, thickness: 1),
                          PopupMenuButton(
                            onSelected: (action) => controller.onSelected(
                                context, action, deviceKeys[i]),
                            itemBuilder: (c) {
                              final items = <PopupMenuEntry<String>>[];
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
                              title: Text(
                                room
                                    .getUserByMXIDSync(deviceKeys[i].userId)
                                    .calcDisplayname(),
                              ),
                              subtitle: Text(
                                deviceKeys[i].userId,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        },
                        PopupMenuButton(
                          onSelected: (action) => controller.onSelected(
                              context, action, deviceKeys[i]),
                          itemBuilder: (c) {
                            final items = <PopupMenuEntry<String>>[];
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
                              foregroundColor: Colors.white,
                              backgroundColor: deviceKeys[i].color,
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                ),
                                const Spacer(),
                                Text(
                                  deviceKeys[i].blocked
                                      ? L10n.of(context).blocked
                                      : deviceKeys[i].verified
                                          ? L10n.of(context).verified
                                          : L10n.of(context).unverified,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: deviceKeys[i].color,
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

extension on DeviceKeys {
  Color get color => blocked
      ? Colors.red
      : verified
          ? Colors.green
          : Colors.orange;
}
