import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:matrix/matrix.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/fluffy_share.dart';
import 'chat_list.dart';

class ClientChooserButton extends StatelessWidget {
  final ChatListController controller;

  const ClientChooserButton(this.controller, {Key? key}) : super(key: key);

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
        value: SettingsAction.newStory,
        child: Row(
          children: [
            const Icon(Icons.camera_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context)!.yourStory),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.newGroup,
        child: Row(
          children: [
            const Icon(Icons.group_add_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context)!.createNewGroup),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.newSpace,
        child: Row(
          children: [
            const Icon(Icons.workspaces_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context)!.createNewSpace),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.invite,
        child: Row(
          children: [
            Icon(Icons.adaptive.share_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context)!.inviteContact),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.archive,
        child: Row(
          children: [
            const Icon(Icons.archive_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context)!.archive),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.settings,
        child: Row(
          children: [
            const Icon(Icons.settings_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context)!.settings),
          ],
        ),
      ),
      const PopupMenuItem(
        value: null,
        child: Divider(height: 1),
      ),
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
        ...matrix.accountBundles[bundle]!
            .map(
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
                        name: snapshot.data?.displayName ??
                            client.userID!.localpart,
                        size: 32,
                        fontSize: 12,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          snapshot.data?.displayName ??
                              client.userID!.localpart!,
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
            )
            .toList(),
      ],
      PopupMenuItem(
        value: SettingsAction.addAccount,
        child: Row(
          children: [
            const Icon(Icons.person_add_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context)!.addAccount),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);

    int clientCount = 0;
    matrix.accountBundles.forEach((key, value) => clientCount += value.length);
    return FutureBuilder<Profile>(
      future: matrix.client.fetchOwnProfile(),
      builder: (context, snapshot) => Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(
            clientCount,
            (index) => KeyBoardShortcuts(
              keysToPress: _buildKeyboardShortcut(index + 1),
              helpLabel: L10n.of(context)!.switchToAccount(index + 1),
              onKeysPressed: () => _handleKeyboardShortcut(
                matrix,
                index,
                context,
              ),
              child: const SizedBox.shrink(),
            ),
          ),
          KeyBoardShortcuts(
            keysToPress: {
              LogicalKeyboardKey.controlLeft,
              LogicalKeyboardKey.tab
            },
            helpLabel: L10n.of(context)!.nextAccount,
            onKeysPressed: () => _nextAccount(matrix, context),
            child: const SizedBox.shrink(),
          ),
          KeyBoardShortcuts(
            keysToPress: {
              LogicalKeyboardKey.controlLeft,
              LogicalKeyboardKey.shiftLeft,
              LogicalKeyboardKey.tab
            },
            helpLabel: L10n.of(context)!.previousAccount,
            onKeysPressed: () => _previousAccount(matrix, context),
            child: const SizedBox.shrink(),
          ),
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
                size: 28,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Set<LogicalKeyboardKey>? _buildKeyboardShortcut(int index) {
    if (index > 0 && index < 10) {
      return {
        LogicalKeyboardKey.altLeft,
        LogicalKeyboardKey(0x00000000030 + index)
      };
    } else {
      return null;
    }
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
            title: L10n.of(context)!.addAccount,
            message: L10n.of(context)!.enableMultiAccounts,
            okLabel: L10n.of(context)!.next,
            cancelLabel: L10n.of(context)!.cancel,
          );
          if (consent != OkCancelResult.ok) return;
          VRouter.of(context).to('/settings/addaccount');
          break;
        case SettingsAction.newStory:
          VRouter.of(context).to('/stories/create');
          break;
        case SettingsAction.newGroup:
          VRouter.of(context).to('/newgroup');
          break;
        case SettingsAction.newSpace:
          VRouter.of(context).to('/newspace');
          break;
        case SettingsAction.invite:
          FluffyShare.share(
            L10n.of(context)!.inviteText(
              Matrix.of(context).client.userID!,
              'https://matrix.to/#/${Matrix.of(context).client.userID}?client=im.fluffychat',
            ),
            context,
          );
          break;
        case SettingsAction.settings:
          VRouter.of(context).to('/settings');
          break;
        case SettingsAction.archive:
          VRouter.of(context).to('/archive');
          break;
      }
    }
  }

  void _handleKeyboardShortcut(
    MatrixState matrix,
    int index,
    BuildContext context,
  ) {
    final bundles = matrix.accountBundles.keys.toList()
      ..sort(
        (a, b) => a!.isValidMatrixId == b!.isValidMatrixId
            ? 0
            : a.isValidMatrixId && !b.isValidMatrixId
                ? -1
                : 1,
      );
    // beginning from end if negative
    if (index < 0) {
      int clientCount = 0;
      matrix.accountBundles
          .forEach((key, value) => clientCount += value.length);
      _handleKeyboardShortcut(matrix, clientCount, context);
    }
    for (final bundleName in bundles) {
      final bundle = matrix.accountBundles[bundleName];
      if (bundle != null) {
        if (index < bundle.length) {
          return _clientSelected(bundle[index]!, context);
        } else {
          index -= bundle.length;
        }
      }
    }
    // if index too high, restarting from 0
    _handleKeyboardShortcut(matrix, 0, context);
  }

  int? _shortcutIndexOfClient(MatrixState matrix, Client client) {
    int index = 0;

    final bundles = matrix.accountBundles.keys.toList()
      ..sort(
        (a, b) => a!.isValidMatrixId == b!.isValidMatrixId
            ? 0
            : a.isValidMatrixId && !b.isValidMatrixId
                ? -1
                : 1,
      );
    for (final bundleName in bundles) {
      final bundle = matrix.accountBundles[bundleName];
      if (bundle == null) return null;
      if (bundle.contains(client)) {
        return index + bundle.indexOf(client);
      } else {
        index += bundle.length;
      }
    }
    return null;
  }

  void _nextAccount(MatrixState matrix, BuildContext context) {
    final client = matrix.client;
    final lastIndex = _shortcutIndexOfClient(matrix, client);
    _handleKeyboardShortcut(matrix, lastIndex! + 1, context);
  }

  void _previousAccount(MatrixState matrix, BuildContext context) {
    final client = matrix.client;
    final lastIndex = _shortcutIndexOfClient(matrix, client);
    _handleKeyboardShortcut(matrix, lastIndex! - 1, context);
  }
}

enum SettingsAction {
  addAccount,
  newStory,
  newGroup,
  newSpace,
  invite,
  settings,
  archive,
}
