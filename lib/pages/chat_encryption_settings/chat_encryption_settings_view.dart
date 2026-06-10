// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_encryption_settings/chat_encryption_settings.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
            mainAxisSize: .min,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                title: Text(L10n.of(context).encryptThisChat),
                value: room.encrypted,
                onChanged: controller.enableEncryption,
              ),
              Divider(color: theme.dividerColor, height: 1),
              if (room.isDirectChat) ...[
                const SizedBox(height: 16),
                ListTile(
                  title: Text(L10n.of(context).interactiveVerification),
                  subtitle: Text(
                    L10n.of(context).interactiveVerificationDescription,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                    left: 16,
                    right: 16,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                        side: BorderSide(
                          color: theme.colorScheme.onPrimaryContainer,
                          width: 1,
                        ),
                      ),
                      onPressed: controller.startVerification,
                      icon: const Icon(Icons.verified_outlined),
                      label: Text(L10n.of(context).verifyStart),
                    ),
                  ),
                ),
                Divider(color: theme.dividerColor, height: 1),
              ],
              if (room.encrypted) ...[
                // TODO: Display device keys
                SelectionArea(
                  child: FutureBuilder(
                    future: room.requestParticipants(),
                    builder: (context, snapshot) {
                      final users = snapshot.data;
                      if (users == null) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return Column(
                        children: users.map((user) {
                          final userDeviceKeys =
                              room.client.userDeviceKeys[user.id];
                          final masterKey = userDeviceKeys?.masterKey;
                          final tofuSince = masterKey?.trustOnFirstUseSince;
                          return Column(
                            mainAxisSize: .min,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    (userDeviceKeys?.deviceKeys.length ?? 0)
                                        .toString(),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        user.calcDisplayname(),
                                        maxLines: 1,
                                        overflow: .ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: .start,
                                  mainAxisSize: .min,
                                  children: [
                                    Text(
                                      user.id,
                                      maxLines: 1,
                                      overflow: .ellipsis,
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      masterKey == null
                                          ? L10n.of(context).noUserKeyFound
                                          : masterKey.verified == true
                                          ? L10n.of(context).verified
                                          : tofuSince != null
                                          ? L10n.of(context).knownSince(
                                              tofuSince.localizedTime(context),
                                            )
                                          : L10n.of(context).unverified,
                                      style: TextStyle(
                                        color: masterKey == null
                                            ? theme.colorScheme.onErrorContainer
                                            : masterKey.verified
                                            ? Colors.green
                                            : tofuSince != null
                                            ? theme.colorScheme.primary
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () =>
                                      controller.uncollapse(user.id),
                                  icon: Icon(
                                    controller.uncollapsedUserId == user.id
                                        ? Icons.keyboard_arrow_up_outlined
                                        : Icons.keyboard_arrow_down_outlined,
                                  ),
                                ),
                              ),
                              if (controller.uncollapsedUserId == user.id &&
                                  userDeviceKeys != null) ...[
                                ...userDeviceKeys.deviceKeys.values.map((
                                  device,
                                ) {
                                  final signedDevice = device
                                      .hasValidSignatureChain(
                                        verifiedOnly: false,
                                        verifiedByTheirMasterKey: true,
                                      );
                                  return ListTile(
                                    title: Text(
                                      device.verified
                                          ? L10n.of(context).verified
                                          : device.blocked
                                          ? L10n.of(context).blocked
                                          : !signedDevice
                                          ? L10n.of(context).unsignedDevice
                                          : L10n.of(context).signedDevice,
                                      style: TextStyle(
                                        color: device.verified
                                            ? Colors.green
                                            : device.blocked
                                            ? theme.colorScheme.error
                                            : !signedDevice
                                            ? theme.colorScheme.onErrorContainer
                                            : theme.colorScheme.primary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      device.curve25519Key?.beautified ??
                                          L10n.of(context).noCurve25519KeyFound,
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.block_outlined),
                                      style: IconButton.styleFrom(
                                        foregroundColor: device.blocked
                                            ? theme.colorScheme.error
                                            : null,
                                      ),
                                      tooltip: device.blocked
                                          ? L10n.of(context).unblockDevice
                                          : L10n.of(context).blockDevice,

                                      onPressed: () =>
                                          controller.toggleBlocked(device),
                                    ),
                                  );
                                }),
                                Divider(color: theme.dividerColor),
                              ],
                            ],
                          );
                        }).toList(),
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
                      style: const TextStyle(fontStyle: FontStyle.italic),
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
