import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_encryption_settings/chat_encryption_settings.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
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
              const Divider(),
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
                        itemBuilder: (BuildContext context, int i) =>
                            SwitchListTile(
                          value: !deviceKeys[i].blocked,
                          activeColor: deviceKeys[i].verified
                              ? Colors.green
                              : Colors.orange,
                          onChanged: (_) =>
                              controller.toggleDeviceKey(deviceKeys[i]),
                          title: Row(
                            children: [
                              Icon(
                                deviceKeys[i].verified
                                    ? Icons.verified_outlined
                                    : deviceKeys[i].blocked
                                        ? Icons.block_outlined
                                        : Icons.info_outlined,
                                color: deviceKeys[i].verified
                                    ? Colors.green
                                    : deviceKeys[i].blocked
                                        ? Colors.red
                                        : Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                deviceKeys[i].deviceId ??
                                    L10n.of(context).unknownDevice,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                fit: FlexFit.loose,
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius,
                                    ),
                                    side: BorderSide(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  color: theme.colorScheme.primaryContainer,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      deviceKeys[i].userId,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            deviceKeys[i].ed25519Key?.beautified ??
                                L10n.of(context).unknownEncryptionAlgorithm,
                            style: TextStyle(
                              fontFamily: 'RobotoMono',
                              color: theme.colorScheme.secondary,
                            ),
                          ),
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
