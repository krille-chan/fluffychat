import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_encryption_settings/chat_encryption_settings.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class ChatEncryptionSettingsView extends StatelessWidget {
  final ChatEncryptionSettingsController controller;

  const ChatEncryptionSettingsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final room = controller.room;
    return StreamBuilder<Object>(
      stream: room.client.onSync.stream.where(
        (s) => s.rooms?.join?[room.id] != null || s.deviceLists != null,
      ),
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_outlined),
            onPressed: () => context.go('/rooms/${controller.roomId!}'),
          ),
          title: Text(L10n.of(context).encryption),
          actions: [
            TextButton(
              onPressed: () => launchUrlString(AppConfig.encryptionTutorial),
              child: Text(L10n.of(context).help),
            ),
          ],
        ),
        body: MaxWidthBody(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                secondary: CircleAvatar(
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: const Icon(Icons.lock_outlined),
                ),
                title: Text(L10n.of(context).encryptThisChat),
                value: room.encrypted,
                onChanged: controller.enableEncryption,
              ),
              Icon(
                CupertinoIcons.lock_shield,
                size: 128,
                color: theme.colorScheme.onInverseSurface,
              ),
              if (room.isDirectChat)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.startVerification,
                      icon: const Icon(Icons.verified_outlined),
                      label: Text(L10n.of(context).verifyStart),
                    ),
                  ),
                ),
              if (room.encrypted) ...[
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    L10n.of(context).deviceKeys,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: room.client.onRoomState.stream
                      .where((update) => update.roomId == controller.room.id),
                  builder: (context, snapshot) =>
                      FutureBuilder<List<DeviceKeys>>(
                    future: room.getUserDeviceKeys(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${L10n.of(context).oopsSomethingWentWrong}: ${snapshot.error}',
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          ),
                        );
                      }
                      final deviceKeys = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: deviceKeys.length,
                        itemBuilder: (BuildContext context, int i) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (i == 0 ||
                                deviceKeys[i].userId !=
                                    deviceKeys[i - 1].userId) ...[
                              const Divider(),
                              FutureBuilder(
                                future: room.client
                                    .getUserProfile(deviceKeys[i].userId),
                                builder: (context, snapshot) {
                                  final displayname =
                                      snapshot.data?.displayname ??
                                          deviceKeys[i].userId.localpart ??
                                          deviceKeys[i].userId;
                                  return ListTile(
                                    leading: Avatar(
                                      name: displayname,
                                      mxContent: snapshot.data?.avatarUrl,
                                    ),
                                    title: Text(displayname),
                                    subtitle: Text(deviceKeys[i].userId),
                                  );
                                },
                              ),
                            ],
                            SwitchListTile(
                              value: !deviceKeys[i].blocked,
                              activeThumbColor: deviceKeys[i].verified
                                  ? Colors.green
                                  : Colors.orange,
                              onChanged: (_) =>
                                  controller.toggleDeviceKey(deviceKeys[i]),
                              title: Row(
                                children: [
                                  Text(
                                    deviceKeys[i].verified
                                        ? L10n.of(context).verified
                                        : deviceKeys[i].blocked
                                            ? L10n.of(context).blocked
                                            : L10n.of(context).unverified,
                                    style: TextStyle(
                                      color: deviceKeys[i].verified
                                          ? Colors.green
                                          : deviceKeys[i].blocked
                                              ? Colors.red
                                              : Colors.orange,
                                    ),
                                  ),
                                  const Text(' | ID: '),
                                  Text(
                                    deviceKeys[i].deviceId ??
                                        L10n.of(context).unknownDevice,
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                deviceKeys[i].ed25519Key?.beautified ??
                                    L10n.of(context).unknownEncryptionAlgorithm,
                                style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  color: theme.colorScheme.secondary,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      L10n.of(context).encryptionNotEnabled,
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
