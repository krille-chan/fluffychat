import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'chat_list.dart';

class ClientChooserButton extends StatelessWidget {
  final ChatListController controller;

  const ClientChooserButton(this.controller, {Key? key}) : super(key: key);

  List<PopupMenuEntry<Object>> _bundleMenuItems(BuildContext context) {
    final matrix = Matrix.of(context);
    final bundles = matrix.accountBundles.keys.toList()
      ..sort((a, b) => a!.isValidMatrixId == b!.isValidMatrixId
          ? 0
          : a.isValidMatrixId && !b.isValidMatrixId
              ? -1
              : 1);
    return <PopupMenuEntry<Object>>[
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
                    color: Theme.of(context).textTheme.subtitle1!.color,
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
                child: FutureBuilder<Profile>(
                  future: client!.fetchOwnProfile(),
                  builder: (context, snapshot) => Row(
                    children: [
                      Avatar(
                        mxContent: snapshot.data?.avatarUrl,
                        name: snapshot.data?.displayName ??
                            client.userID!.localpart,
                        size: 28,
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
                            client.userID, bundle),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);

    int clientCount = 0;
    matrix.accountBundles.forEach((key, value) => clientCount += value.length);
    return Center(
      child: FutureBuilder<Profile>(
        future: matrix.client.fetchOwnProfile(),
        builder: (context, snapshot) => Stack(
          alignment: Alignment.center,
          children: [
            ...List.generate(
              clientCount,
              (index) => KeyBoardShortcuts(
                child: Container(),
                keysToPress: _buildKeyboardShortcut(index + 1),
                helpLabel: L10n.of(context)!.switchToAccount(index + 1),
                onKeysPressed: () => _handleKeyboardShortcut(matrix, index),
              ),
            ),
            KeyBoardShortcuts(
              child: Container(),
              keysToPress: {
                LogicalKeyboardKey.controlLeft,
                LogicalKeyboardKey.tab
              },
              helpLabel: L10n.of(context)!.nextAccount,
              onKeysPressed: () => _nextAccount(matrix),
            ),
            KeyBoardShortcuts(
              child: Container(),
              keysToPress: {
                LogicalKeyboardKey.controlLeft,
                LogicalKeyboardKey.shiftLeft,
                LogicalKeyboardKey.tab
              },
              helpLabel: L10n.of(context)!.previousAccount,
              onKeysPressed: () => _previousAccount(matrix),
            ),
            PopupMenuButton<Object>(
              child: Material(
                borderRadius: BorderRadius.zero,
                child: Avatar(
                  mxContent: snapshot.data?.avatarUrl,
                  name: snapshot.data?.displayName ??
                      matrix.client.userID!.localpart,
                  size: 28,
                  fontSize: 12,
                ),
              ),
              onSelected: _clientSelected,
              itemBuilder: _bundleMenuItems,
            ),
          ],
        ),
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

  void _clientSelected(Object object) {
    if (object is Client) {
      controller.setActiveClient(object);
    } else if (object is String) {
      controller.setActiveBundle(object);
    }
  }

  void _handleKeyboardShortcut(MatrixState matrix, int index) {
    final bundles = matrix.accountBundles.keys.toList()
      ..sort((a, b) => a!.isValidMatrixId == b!.isValidMatrixId
          ? 0
          : a.isValidMatrixId && !b.isValidMatrixId
              ? -1
              : 1);
    // beginning from end if negative
    if (index < 0) {
      int clientCount = 0;
      matrix.accountBundles
          .forEach((key, value) => clientCount += value.length);
      _handleKeyboardShortcut(matrix, clientCount);
    }
    for (final bundleName in bundles) {
      final bundle = matrix.accountBundles[bundleName];
      if (bundle != null) {
        if (index < bundle.length) {
          return _clientSelected(bundle[index]!);
        } else {
          index -= bundle.length;
        }
      }
    }
    // if index too high, restarting from 0
    _handleKeyboardShortcut(matrix, 0);
  }

  int? _shortcutIndexOfClient(MatrixState matrix, Client client) {
    int index = 0;

    final bundles = matrix.accountBundles.keys.toList()
      ..sort((a, b) => a!.isValidMatrixId == b!.isValidMatrixId
          ? 0
          : a.isValidMatrixId && !b.isValidMatrixId
              ? -1
              : 1);
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

  void _nextAccount(MatrixState matrix) {
    final client = matrix.client;
    final lastIndex = _shortcutIndexOfClient(matrix, client);
    _handleKeyboardShortcut(matrix, lastIndex! + 1);
  }

  void _previousAccount(MatrixState matrix) {
    final client = matrix.client;
    final lastIndex = _shortcutIndexOfClient(matrix, client);
    _handleKeyboardShortcut(matrix, lastIndex! - 1);
  }
}
