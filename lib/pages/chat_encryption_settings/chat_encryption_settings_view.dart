import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat_encryption_settings/chat_encryption_settings.dart';

class ChatEncryptionSettingsView extends StatelessWidget {
  final ChatEncryptionSettingsController controller;

  const ChatEncryptionSettingsView(this.controller, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = controller.room;
    return StreamBuilder<Object>(
        stream: room.client.onSync.stream.where(
            (s) => s.rooms?.join?[room.id] != null || s.deviceLists != null),
        builder: (context, _) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.close_outlined),
                  onPressed: () => VRouter.of(context)
                      .toSegments(['rooms', controller.roomId!]),
                ),
                title: Text(L10n.of(context)!.endToEndEncryption),
                actions: [
                  TextButton(
                    onPressed: () =>
                        launchUrlString(AppConfig.encryptionTutorial),
                    child: Text(L10n.of(context)!.help),
                  ),
                ],
              ),
              body: ListView(
                children: [
                  SwitchListTile(
                    secondary: CircleAvatar(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        child: const Icon(Icons.lock_outlined)),
                    title: Text(L10n.of(context)!.encryptThisChat),
                    value: room.encrypted,
                    onChanged: controller.enableEncryption,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/encryption.png',
                      width: 212,
                    ),
                  ),
                  const Divider(height: 1),
                  if (room.isDirectChat)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: controller.startVerification,
                          icon: const Icon(Icons.verified_outlined),
                          label: Text(L10n.of(context)!.verifyStart),
                        ),
                      ),
                    ),
                  if (room.encrypted) ...[
                    const Divider(height: 1),
                    ListTile(
                      title: Text(
                        L10n.of(context)!.deviceKeys,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: room.onUpdate.stream,
                      builder: (context, snapshot) =>
                          FutureBuilder<List<DeviceKeys>>(
                              future: room.getUserDeviceKeys(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                        '${L10n.of(context)!.oopsSomethingWentWrong}: ${snapshot.error}'),
                                  );
                                }
                                if (!snapshot.hasData) {
                                  return const Center(
                                      child: CircularProgressIndicator.adaptive(
                                          strokeWidth: 2));
                                }
                                final deviceKeys = snapshot.data!;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: deviceKeys.length,
                                  itemBuilder: (BuildContext context, int i) =>
                                      SwitchListTile(
                                    value: !deviceKeys[i].blocked,
                                    activeColor: deviceKeys[i].verified
                                        ? Colors.green
                                        : Colors.orange,
                                    onChanged: (_) => controller
                                        .toggleDeviceKey(deviceKeys[i]),
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            deviceKeys[i].deviceId ??
                                                L10n.of(context)!.unknownDevice,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Chip(
                                            label: Text(
                                              deviceKeys[i].userId,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      deviceKeys[i]
                                              .ed25519Key
                                              ?.replaceAllMapped(
                                                  RegExp(r'.{4}'),
                                                  (s) => '${s.group(0)} ') ??
                                          L10n.of(context)!
                                              .unknownEncryptionAlgorithm,
                                      style: const TextStyle(
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                );
                              }),
                    ),
                  ] else
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          L10n.of(context)!.encryptionNotEnabled,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ));
  }
}
