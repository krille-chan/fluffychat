// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/dialog_text_field.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

Future<bool> showTrustUserInRoomDialog(BuildContext context, Room room) async {
  if (!room.encrypted) return true;

  final users = await room.requestParticipants();
  if (!context.mounted) return false;

  users.removeWhere((user) {
    if (user.id == room.client.userID) return true;
    final keys = room.client.userDeviceKeys[user.id];
    final masterKey = keys?.masterKey;

    if (keys == null || masterKey == null || masterKey.verified) return true;
    return false;
  });

  if (users.isEmpty) return true;

  final l10n = L10n.of(context);
  final theme = Theme.of(context);

  final allow = await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Center(
        child: Icon(
          Icons.lock_outlined,
          size: 32,
          color: theme.colorScheme.primary,
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 128),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: .stretch,
            mainAxisSize: .min,
            children: [
              Center(
                child: Text(
                  users.length == 1
                      ? l10n.allowEncryptedCommunicationWith(
                          users.single.calcDisplayname(),
                        )
                      : 'Allow encrypted communication with ${users.length} users?',
                  style: TextStyle(fontSize: 16),
                  textAlign: .center,
                ),
              ),
              const SizedBox(height: 16),
              for (final user in users) ...[
                Row(
                  children: [
                    Avatar(
                      name: user.calcDisplayname(),
                      mxContent: user.avatarUrl,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user.calcDisplayname(),
                        style: theme.textTheme.labelSmall,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                DialogTextField(
                  controller: TextEditingController(
                    text: l10n.publicKey(
                      room
                              .client
                              .userDeviceKeys[user.id]
                              ?.masterKey
                              ?.publicKey
                              ?.beautifiedOneLine ??
                          '???',
                    ),
                  ),
                  textStyle: theme.textTheme.labelSmall,
                  readOnly: true,
                  maxLines: 2,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        AdaptiveDialogAction(
          bigButtons: true,
          onPressed: () {
            for (final user in users) {
              room.client.userDeviceKeys[user.id]?.masterKey?.setVerified(true);
            }
            Navigator.of(context).pop(true);
          },
          child: Text(L10n.of(context).allow),
        ),
        AdaptiveDialogAction(
          bigButtons: true,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(L10n.of(context).onlyThisTime),
        ),
        AdaptiveDialogAction(
          bigButtons: true,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
      ],
    ),
  );

  if (allow != true) return false;

  return true;
}
