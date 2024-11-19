import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/pangea/pages/settings_learning/settings_learning.dart';
import 'package:fluffychat/pangea/utils/logout.dart';
import 'package:fluffychat/pangea/utils/space_code.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
// import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:matrix/matrix.dart';

class ClientChooserButton extends StatelessWidget {
  // #Pangea
  // final ChatListController controller;
  // Pangea#

  const ClientChooserButton(
      // #Pangea
      // this.controller,
      // Pangea#
      {
    super.key,
  });

  List<PopupMenuEntry<Object>> _bundleMenuItems(BuildContext context) {
    final matrix = Matrix.of(context);
    // #Pangea
    // final bundles = matrix.accountBundles.keys.toList()
    //   ..sort(
    //     (a, b) => a!.isValidMatrixId == b!.isValidMatrixId
    //         ? 0
    //         : a.isValidMatrixId && !b.isValidMatrixId
    //             ? -1
    //             : 1,
    //   );
    // Pangea#
    return <PopupMenuEntry<Object>>[
      // #Pangea
      PopupMenuItem(
        value: SettingsAction.joinWithClassCode,
        child: Row(
          children: [
            const Icon(Icons.join_full_outlined),
            const SizedBox(width: 18),
            Expanded(child: Text(L10n.of(context)!.joinWithClassCode)),
          ],
        ),
      ),
      // PopupMenuItem(
      //   value: SettingsAction.newGroup,
      //   child: Row(
      //     children: [
      //       const Icon(Icons.group_add_outlined),
      //       const SizedBox(width: 18),
      //       Text(L10n.of(context)!.createGroup),
      //     ],
      //   ),
      // ),
      // Pangea#
      PopupMenuItem(
        value: SettingsAction.newSpace,
        child: Row(
          children: [
            const Icon(Icons.workspaces_outlined),
            const SizedBox(width: 18),
            // #Pangea
            Text(L10n.of(context)!.createNewSpace),
            // Text(L10n.of(context)!.createNewSpace),
            // Pangea#
          ],
        ),
      ),
      // #Pangea
      PopupMenuItem(
        value: SettingsAction.learning,
        child: Row(
          children: [
            const Icon(Icons.psychology_outlined),
            const SizedBox(width: 18),
            Expanded(child: Text(L10n.of(context)!.learningSettings)),
          ],
        ),
      ),
      // PopupMenuItem(
      //   value: SettingsAction.setStatus,
      //   child: Row(
      //     children: [
      //       const Icon(Icons.edit_outlined),
      //       const SizedBox(width: 18),
      //       Text(L10n.of(context)!.setStatus),
      //     ],
      //   ),
      // ),
      // PopupMenuItem(
      //   value: SettingsAction.invite,
      //   child: Row(
      //     children: [
      //       Icon(Icons.adaptive.share_outlined),
      //       const SizedBox(width: 18),
      //       Text(L10n.of(context)!.inviteContact),
      //     ],
      //   ),
      // ),
      // Pangea#
      // Currently disabled because of:
      // https://github.com/matrix-org/matrix-react-sdk/pull/12286
      /*PopupMenuItem(
        value: SettingsAction.archive,
        child: Row(
          children: [
            const Icon(Icons.archive_outlined),
            const SizedBox(width: 18),
            Text(L10n.of(context)!!.archive),
          ],
        ),
      ),*/
      PopupMenuItem(
        value: SettingsAction.settings,
        child: Row(
          children: [
            const Icon(Icons.settings_outlined),
            const SizedBox(width: 18),
            // #Pangea
            Text(L10n.of(context)!.settings),
            // Text(L10n.of(context)!.settings),
            // Pangea#
          ],
        ),
      ),
      // #Pangea
      PopupMenuItem(
        value: SettingsAction.logout,
        child: Row(
          children: [
            const Icon(Icons.logout_outlined),
            const SizedBox(width: 18),
            Expanded(child: Text(L10n.of(context)!.logout)),
          ],
        ),
      ),
      // const PopupMenuDivider(),
      // for (final bundle in bundles) ...[
      //   if (matrix.accountBundles[bundle]!.length != 1 ||
      //       matrix.accountBundles[bundle]!.single!.userID != bundle)
      //     PopupMenuItem(
      //       value: null,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           Text(
      //             bundle!,
      //             style: TextStyle(
      //               color: Theme.of(context).textTheme.titleMedium!.color,
      //               fontSize: 14,
      //             ),
      //           ),
      //           const Divider(height: 1),
      //         ],
      //       ),
      //     ),
      //   ...matrix.accountBundles[bundle]!.map(
      //     (client) => PopupMenuItem(
      //       value: client,
      //       child: FutureBuilder<Profile?>(
      //         // analyzer does not understand this type cast for error
      //         // handling
      //         //
      //         // ignore: unnecessary_cast
      //         future: (client!.fetchOwnProfile() as Future<Profile?>)
      //             .onError((e, s) => null),
      //         builder: (context, snapshot) => Row(
      //           children: [
      //             Avatar(
      //               mxContent: snapshot.data?.avatarUrl,
      //               name:
      //                   snapshot.data?.displayName ?? client.userID!.localpart,
      //               size: 32,
      //             ),
      //             const SizedBox(width: 12),
      //             Expanded(
      //               child: Text(
      //                 snapshot.data?.displayName ?? client.userID!.localpart!,
      //                 overflow: TextOverflow.ellipsis,
      //               ),
      //             ),
      //             const SizedBox(width: 12),
      //             IconButton(
      //               icon: const Icon(Icons.edit_outlined),
      //               onPressed: () => controller.editBundlesForAccount(
      //                 client.userID,
      //                 bundle,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ],
      // PopupMenuItem(
      //   value: SettingsAction.addAccount,
      //   child: Row(
      //     children: [
      //       const Icon(Icons.person_add_outlined),
      //       const SizedBox(width: 18),
      //       Text(L10n.of(context)!.addAccount),
      //     ],
      //   ),
      // ),
      // Pangea#
    ];
  }

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);

    var clientCount = 0;
    matrix.accountBundles.forEach((key, value) => clientCount += value.length);
    // #Pangea
    return matrix.client.userID == null
        ? const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator.adaptive(),
          )
        :
        // Pangea#
        FutureBuilder<Profile>(
            future: matrix.client.fetchOwnProfile(),
            builder: (context, snapshot) => Stack(
              alignment: Alignment.center,
              children: [
                // #Pangea
                // ...List.generate(
                //   clientCount,
                //   (index) => KeyBoardShortcuts(
                //     keysToPress: _buildKeyboardShortcut(index + 1),
                //     helpLabel: L10n.of(context)!.switchToAccount(index + 1),
                //     onKeysPressed: () => _handleKeyboardShortcut(
                //       matrix,
                //       index,
                //       context,
                //     ),
                //     child: const SizedBox.shrink(),
                //   ),
                // ),
                // KeyBoardShortcuts(
                //   keysToPress: {
                //     LogicalKeyboardKey.controlLeft,
                //     LogicalKeyboardKey.tab,
                //   },
                //   helpLabel: L10n.of(context)!.nextAccount,
                //   onKeysPressed: () => _nextAccount(matrix, context),
                //   child: const SizedBox.shrink(),
                // ),
                // KeyBoardShortcuts(
                //   keysToPress: {
                //     LogicalKeyboardKey.controlLeft,
                //     LogicalKeyboardKey.shiftLeft,
                //     LogicalKeyboardKey.tab,
                //   },
                //   helpLabel: L10n.of(context)!.previousAccount,
                //   onKeysPressed: () => _previousAccount(matrix, context),
                //   child: const SizedBox.shrink(),
                // ),
                // Pangea#
                PopupMenuButton<Object>(
                  onSelected: (o) => _clientSelected(o, context),
                  itemBuilder: _bundleMenuItems,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                    child:
                        //   // #Pangea
                        //   Stack(
                        // alignment: Alignment.bottomRight,
                        // children: [
                        //   Padding(
                        //     padding: const EdgeInsets.all(4),
                        //     child:
                        //         // Pangea#
                        Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(15),
                        // color: Theme.of(context).colorScheme.surfaceBright,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(
                              0,
                              1,
                            ), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Avatar(
                        mxContent: snapshot.data?.avatarUrl,
                        name: snapshot.data?.displayName ??
                            matrix.client.userID!.localpart,
                        size: 60,
                      ),
                    ),
                    //       // #Pangea
                    //     ),
                    //     const Icon(Icons.settings_outlined, size: 20),
                    //   ],
                    // ),
                    // // Pangea#
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
        LogicalKeyboardKey(0x00000000030 + index),
      };
    } else {
      return null;
    }
  }

  void _clientSelected(
    Object object,
    BuildContext context,
  ) async {
    // #Pangea
    // if (object is Client) {
    //   controller.setActiveClient(object);
    // } else if (object is String) {
    //   controller.setActiveBundle(object);
    // } else
    // Pangea#
    if (object is SettingsAction) {
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
          context.go('/rooms/settings/addaccount');
          break;
        // #Pangea
        // case SettingsAction.newGroup:
        //   context.go('/rooms/newgroup');
        //   break;
        // Pangea#
        case SettingsAction.newSpace:
          // #Pangea
          // controller.createNewSpace();
          context.push<String?>('/rooms/newspace');
          // Pangea#
          break;
        // #Pangea
        // case SettingsAction.invite:
        //   FluffyShare.shareInviteLink(context);
        //   break;
        // Pangea#
        case SettingsAction.settings:
          context.go('/rooms/settings');
          break;
        // #Pangea
        // case SettingsAction.archive:
        //   context.go('/rooms/archive');
        //   break;
        // case SettingsAction.setStatus:
        //   controller.setStatus();
        //   break;
        case SettingsAction.learning:
          showDialog(
            context: context,
            builder: (c) => const SettingsLearning(),
          );
          break;
        case SettingsAction.joinWithClassCode:
          SpaceCodeUtil.joinWithSpaceCodeDialog(
            context,
            MatrixState.pangeaController,
          );
          break;
        case SettingsAction.logout:
          pLogoutAction(context);
          break;
        // Pangea#
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
      var clientCount = 0;
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
    var index = 0;

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
  // #Pangea
  // newGroup,
  // Pangea#
  newSpace,
  // #Pangea
  // setStatus,
  // invite,
  // Pangea#
  settings,
  // #Pangea
  // archive,
  joinWithClassCode,
  learning,
  logout,
  // Pangea#
}
