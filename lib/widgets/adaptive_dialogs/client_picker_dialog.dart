// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/show_scaffold_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';

/// A reusable dialog which lets the user pick one of the logged in
/// accounts (clients). Returns the selected [Client] or `null` if the
/// dialog was dismissed.
///
/// Shows nothing and returns the current client directly if there is
/// only a single account.
Future<Client?> showClientPickerDialog(
  BuildContext context, {
  String? title,
}) async {
  final matrix = Matrix.of(context);
  final clients = matrix.widget.clients.where((client) => client.isLogged());
  if (clients.length < 2) {
    return clients.isEmpty ? null : matrix.client;
  }
  return showScaffoldDialog<Client>(
    context: context,
    containerColor: Colors.transparent,
    builder: (context) => ClientPickerDialog(
      clients: clients.toList(),
      title: title ?? L10n.of(context).chooseAccount,
    ),
  );
}

class ClientPickerDialog extends StatelessWidget {
  final List<Client> clients;
  final String title;

  const ClientPickerDialog({
    required this.clients,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final client in clients)
            ListTile(
              leading: FutureBuilder<Profile?>(
                future: client.fetchOwnProfile(),
                builder: (context, snapshot) {
                  final displayname =
                      snapshot.data?.displayName ??
                      client.userID?.localpart ??
                      client.userID ??
                      '';
                  return Avatar(
                    mxContent: snapshot.data?.avatarUrl,
                    name: displayname,
                    size: 40,
                  );
                },
              ),
              title: Text(
                client.userID?.localpart ?? client.userID ?? '',
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: client.homeserver != null
                  ? Text(
                      client.homeserver.toString(),
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              onTap: () => Navigator.of(context).pop(client),
            ),
        ],
      ),
      actions: [
        AdaptiveDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(L10n.of(context).cancel),
        ),
      ],
    );
  }
}
