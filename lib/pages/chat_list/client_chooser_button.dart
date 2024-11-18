import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/fluffy_share.dart';
import 'chat_list.dart';

class ClientChooserButton extends StatelessWidget {
  final ChatListController controller;

  const ClientChooserButton(this.controller, {super.key});

  List<PopupMenuEntry<Object>> _bundleMenuItems(BuildContext context) {
    final matrix = Matrix.of(context);
    final bundles = matrix.accountBundles.keys.toList()
      ..sort(
        (a, b) => a!.isValidMatrixId == b!.isValidMatrixId
            ? 0
            : a.isValidMatrixId && !b.isValidMatrixId
                ? -1
                : 1,
      );
    return <PopupMenuEntry<Object>>[
      PopupMenuItem(
        value: SettingsAction.newGroup,
        child: Row(
          children: [
            const Icon(Icons.group_add_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context).createGroup),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.setStatus,
        child: Row(
          children: [
            const Icon(Icons.edit_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context).setStatus),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.invite,
        child: Row(
          children: [
            Icon(Icons.adaptive.share_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context).inviteContact),
          ],
        ),
      ),
      // Currently disabled because of:
      // https://github.com/matrix-org/matrix-react-sdk/pull/12286
      /*PopupMenuItem(
        value: SettingsAction.archive,
        child: Row(
          children: [
            const Icon(Icons.archive_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context)!.archive),
          ],
        ),
      ),*/
      PopupMenuItem(
        value: SettingsAction.settings,
        child: Row(
          children: [
            const Icon(Icons.settings_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context).settings),
          ],
        ),
      ),
      const PopupMenuDivider(),
      for (final bundle in bundles) ...[
        if (matrix.accountBundles[bundle]!.length != 1 ||
            matrix.accountBundles[bundle]!.single!.userID != bundle)
          PopupMenuItem(
            value: null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bundle!,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleMedium!.color,
                    fontSize: 14,
                  ),
                ),
                const Divider(height: 1),
              ],
            ),
          ),
        ...matrix.accountBundles[bundle]!.map(
          (client) => PopupMenuItem(
            value: client,
            child: FutureBuilder<Profile?>(
              // analyzer does not understand this type cast for error
              // handling
              //
              // ignore: unnecessary_cast
              future: (client!.fetchOwnProfile() as Future<Profile?>)
                  .onError((e, s) => null),
              builder: (context, snapshot) => Row(
                children: [
                  Avatar(
                    mxContent: snapshot.data?.avatarUrl,
                    name:
                        snapshot.data?.displayName ?? client.userID!.localpart,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      snapshot.data?.displayName ?? client.userID!.localpart!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => controller.editBundlesForAccount(
                      client.userID,
                      bundle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      PopupMenuItem(
        value: SettingsAction.addAccount,
        child: Row(
          children: [
            const Icon(Icons.person_add_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context).addAccount),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);

    var clientCount = 0;
    matrix.accountBundles.forEach((key, value) => clientCount += value.length);
    return FutureBuilder<Profile>(
      future: matrix.client.fetchOwnProfile(),
      builder: (context, snapshot) => Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(
            clientCount,
            (index) => const SizedBox.shrink(),
          ),
          const SizedBox.shrink(),
          const SizedBox.shrink(),
          PopupMenuButton<Object>(
            onSelected: (o) => _clientSelected(o, context),
            itemBuilder: _bundleMenuItems,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(99),
              child: Avatar(
                mxContent: snapshot.data?.avatarUrl,
                name: snapshot.data?.displayName ??
                    matrix.client.userID!.localpart,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clientSelected(
    Object object,
    BuildContext context,
  ) async {
    if (object is Client) {
      controller.setActiveClient(object);
    } else if (object is String) {
      controller.setActiveBundle(object);
    } else if (object is SettingsAction) {
      switch (object) {
        case SettingsAction.addAccount:
          final consent = await showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).addAccount,
            message: L10n.of(context).enableMultiAccounts,
            okLabel: L10n.of(context).next,
            cancelLabel: L10n.of(context).cancel,
          );
          if (consent != OkCancelResult.ok) return;
          context.go('/rooms/settings/addaccount');
          break;
        case SettingsAction.newGroup:
          context.go('/rooms/newgroup');
          break;
        case SettingsAction.invite:
          FluffyShare.shareInviteLink(context);
          break;
        case SettingsAction.settings:
          context.go('/rooms/settings');
          break;
        case SettingsAction.archive:
          context.go('/rooms/archive');
          break;
        case SettingsAction.setStatus:
          controller.setStatus();
          break;
      }
    }
  }
}

enum SettingsAction {
  addAccount,
  newGroup,
  setStatus,
  invite,
  settings,
  archive,
}
