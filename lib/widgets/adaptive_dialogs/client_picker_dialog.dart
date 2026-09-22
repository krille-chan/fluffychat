// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

/// A reusable dialog which lets the user pick one of the logged in
/// accounts (clients). Returns the selected [Client] or `null` if the
/// dialog was dismissed.
///
/// Shows nothing and returns the current client directly if there is
/// only a single account.
Future<Client?> showClientPickerDialog(BuildContext context) async {
  final clients = Matrix.of(context).widget.clients;

  if (clients.length < 2) {
    return clients.isEmpty ? null : clients.first;
  }

  final profiles = (await showFutureLoadingDialog(
    context: context,
    future: () => Future.wait(
      clients.map((client) async {
        try {
          return await client.fetchOwnProfile();
        } catch (_) {
          return Profile(
            userId: client.userID ?? '',
            displayName:
                client.userID?.localpart ??
                client.userID ??
                L10n.of(context).user,
            avatarUrl: null,
          );
        }
      }),
    ),
  )).result;

  if (profiles == null || !context.mounted) return null;

  return showModalActionPopup<Client>(
    context: context,
    title: L10n.of(context).chooseAccount,
    cancelLabel: L10n.of(context).cancel,
    actions: [
      for (final (i, client) in clients.indexed)
        () {
          final name =
              profiles[i].displayName ??
              client.userID?.localpart ??
              client.userID ??
              L10n.of(context).user;
          return AdaptiveModalAction(
            label: name,
            value: client,
            isDefaultAction: i == 0,
            icon: Avatar(
              mxContent: profiles[i].avatarUrl,
              name: name,
              size: 40,
            ),
          );
        }(),
    ],
  );
}
