import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/learning_settings/pages/settings_learning.dart';
import 'package:fluffychat/pangea/user/utils/p_logout.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

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
    // #Pangea
    // final matrix = Matrix.of(context);
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
      // PopupMenuItem(
      //   value: SettingsAction.newGroup,
      //   child: Row(
      //     children: [
      //       const Icon(Icons.group_add_outlined),
      //       const SizedBox(width: 18),
      //       Text(L10n.of(context).createGroup),
      //     ],
      //   ),
      // ),
      // PopupMenuItem(
      //   value: SettingsAction.setStatus,
      //   child: Row(
      //     children: [
      //       const Icon(Icons.edit_outlined),
      //       const SizedBox(width: 18),
      //       Text(L10n.of(context).setStatus),
      //     ],
      //   ),
      // ),
      PopupMenuItem(
        value: SettingsAction.learning,
        child: Row(
          children: [
            const Icon(Icons.psychology_outlined),
            const SizedBox(width: 18),
            Expanded(child: Text(L10n.of(context).learningSettings)),
          ],
        ),
      ),
      // PopupMenuItem(
      //   value: SettingsAction.invite,
      //   child: Row(
      //     children: [
      //       Icon(Icons.adaptive.share_outlined),
      //       const SizedBox(width: 18),
      //       Text(L10n.of(context).inviteContact),
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
      // #Pangea
      PopupMenuItem(
        value: SettingsAction.logout,
        child: Row(
          children: [
            const Icon(Icons.logout_outlined),
            const SizedBox(width: 18),
            Expanded(child: Text(L10n.of(context).logout)),
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
      //       Text(L10n.of(context).addAccount),
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
                      // #Pangea
                      presenceUserId: matrix.client.userID!,
                      // size: 32,
                      size: 60,
                      // Pangea#
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
    // #Pangea
    // if (object is Client) {
    //   controller.setActiveClient(object);
    // } else if (object is String) {
    //   controller.setActiveBundle(object);
    // } else
    if (object is SettingsAction) {
      // Pangea#
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
        // #Pangea
        // case SettingsAction.newGroup:
        //   context.go('/rooms/newgroup');
        //   break;
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
            barrierDismissible: false,
          );
          break;
        case SettingsAction.logout:
          pLogoutAction(context);
          break;
        // Pangea#
      }
    }
  }
}

enum SettingsAction {
  addAccount,
  // #Pangea
  // newGroup,
  // setStatus,
  // invite,
  // Pangea#
  settings,
  // #Pangea
  // archive,
  learning,
  logout,
  // Pangea#
}
