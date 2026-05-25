// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_encryption_settings/chat_encryption_settings.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  clipBehavior: Clip.hardEdge,
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    title: Text(L10n.of(context).encryptThisChat),
                    value: room.encrypted,
                    onChanged: controller.enableEncryption,
                  ),
                ),
              ),
              if (room.isDirectChat) ...[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Material(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .stretch,
                      children: [
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
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              foregroundColor:
                                  theme.colorScheme.onPrimaryContainer,
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
                      ],
                    ),
                  ),
                ),
              ],
              if (room.encrypted) ...[
                ListTile(
                  title: Text(
                    L10n.of(context).deviceKeys,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                StreamBuilder(
                  stream: room.client.onRoomState.stream.where(
                    (update) => update.roomId == controller.room.id,
                  ),
                  builder: (context, snapshot) => FutureBuilder<List<DeviceKeys>>(
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
                      return SelectionArea(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: deviceKeys.length,
                          itemBuilder: (BuildContext context, int i) => Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Material(
                              color: deviceKeys[i].verified
                                  ? theme.brightness == Brightness.light
                                        ? Colors.green.shade50
                                        : Colors.green.shade900
                                  : deviceKeys[i].blocked
                                  ? theme.colorScheme.errorContainer
                                  : theme.colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(
                                AppConfig.borderRadius,
                              ),
                              child: ListTile(
                                title: Row(
                                  spacing: 8,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        deviceKeys[i].verified
                                            ? L10n.of(context).verified
                                            : deviceKeys[i].blocked
                                            ? L10n.of(context).blocked
                                            : L10n.of(context).unverified,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: deviceKeys[i].verified
                                              ? Colors.green
                                              : theme.colorScheme.error,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        deviceKeys[i].verified
                                            ? Icons.verified
                                            : Icons.verified_outlined,
                                        color: deviceKeys[i].verified
                                            ? Colors.green
                                            : null,
                                      ),
                                      tooltip: L10n.of(context).verify,
                                      onPressed: () => controller
                                          .toggleVerified(deviceKeys[i]),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        deviceKeys[i].blocked
                                            ? Icons.block
                                            : Icons.block_outlined,

                                        color: deviceKeys[i].blocked
                                            ? theme.colorScheme.error
                                            : null,
                                      ),
                                      tooltip: L10n.of(context).block,
                                      onPressed: () => controller.toggleBlocked(
                                        deviceKeys[i],
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: .start,
                                  mainAxisSize: .min,
                                  spacing: 2,
                                  children: [
                                    GestureDetector(
                                      onTap: () => UrlLauncher(
                                        context,
                                        'https://matrix.to/#/${deviceKeys[i].userId}',
                                      ).openMatrixToUrl(),
                                      child: Text(
                                        deviceKeys[i].userId,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: theme.colorScheme.primary,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'ID: ${deviceKeys[i].deviceId}',
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Text(
                                      '${deviceKeys[i].ed25519Key?.beautified}',
                                      style: TextStyle(
                                        fontFamily: 'RobotoMono',
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
