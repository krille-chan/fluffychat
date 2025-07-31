import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/fluffy_share.dart';
import 'chat_list.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/platform_infos.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

    final theme = Theme.of(context);

    return <PopupMenuEntry<Object>>[
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
      //   value: SettingsAction.archive,
      //   child: Row(
      //     children: [
      //       const Icon(Icons.archive_outlined),
      //       const SizedBox(width: 18),
      //       Text(L10n.of(context).archive),
      //     ],
      //   ),
      // ),
      PopupMenuItem(
        value: SettingsAction.setStatus,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.edit_outlined,
                color: theme.colorScheme.primaryFixed,
                size: 20,
              ),
            ),
            const SizedBox(width: 18),
            Text(L10n.of(context).setStatus),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.store,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/store.svg',
                width: 30,
              ),
            ),
            const SizedBox(width: 18),
            Text(L10n.of(context).menuStore),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.course,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SvgPicture.asset(
                'assets/icons/course.svg',
                width: 30,
              ),
            ),
            const SizedBox(width: 18),
            Text(L10n.of(context).menuCourse),
          ],
        ),
      ),

      PopupMenuItem(
        value: SettingsAction.podcasts,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SvgPicture.asset(
                'assets/icons/podcast.svg',
                width: 30,
              ),
            ),
            const SizedBox(width: 18),
            Text(L10n.of(context).menuPodcasts),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.settings,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 3, top: 8, bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/configs.svg',
                width: 27,
              ),
            ),
            const SizedBox(width: 18),
            Text(L10n.of(context).settings),
          ],
        ),
      ),
      PopupMenuItem(
        value: SettingsAction.about,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Icon(
                Icons.info_outlined,
                color: theme.colorScheme.primaryFixed,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(L10n.of(context).about),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: SettingsAction.invite,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.adaptive.share_outlined,
                color: theme.colorScheme.primaryFixed,
                size: 20,
              ),
            ),
            const SizedBox(width: 18),
            Text('${L10n.of(context).inviteContact} 🔥'),
          ],
        ),
      ),
      //   for (final bundle in bundles) ...[
      //     if (matrix.accountBundles[bundle]!.length != 1 ||
      //         matrix.accountBundles[bundle]!.single!.userID != bundle)
      //       PopupMenuItem(
      //         value: null,
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Text(
      //               bundle!,
      //               style: TextStyle(
      //                 color: Theme.of(context).textTheme.titleMedium!.color,
      //                 fontSize: 14,
      //               ),
      //             ),
      //             const Divider(height: 1),
      //           ],
      //         ),
      //       ),
      //     ...matrix.accountBundles[bundle]!
      //         .whereType<Client>()
      //         .where((client) => client.isLogged())
      //         .map(
      //           (client) => PopupMenuItem(
      //             value: client,
      //             child: FutureBuilder<Profile?>(
      //               future: client.fetchOwnProfile(),
      //               builder: (context, snapshot) => Row(
      //                 children: [
      //                   Avatar(
      //                     mxContent: snapshot.data?.avatarUrl,
      //                     name: snapshot.data?.displayName ??
      //                         client.userID!.localpart,
      //                     size: 32,
      //                   ),
      //                   const SizedBox(width: 12),
      //                   Expanded(
      //                     child: Text(
      //                       snapshot.data?.displayName ??
      //                           client.userID!.localpart!,
      //                       overflow: TextOverflow.ellipsis,
      //                     ),
      //                   ),
      //                   const SizedBox(width: 12),
      //                   IconButton(
      //                     icon: const Icon(Icons.edit_outlined),
      //                     onPressed: () => controller.editBundlesForAccount(
      //                       client.userID,
      //                       bundle,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //   ],
      //   // PopupMenuItem(
      //   //   value: SettingsAction.addAccount,
      //   //   child: Row(
      //   //     children: [
      //   //       const Icon(Icons.person_add_outlined),
      //   //       const SizedBox(width: 18),
      //   //       Text(L10n.of(context).addAccount),
      //   //     ],
      //   //   ),
      //   // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final matrix = Matrix.of(context);

    var clientCount = 0;
    matrix.accountBundles.forEach((key, value) => clientCount += value.length);
    return FutureBuilder<Profile>(
      future: matrix.client.isLogged() ? matrix.client.fetchOwnProfile() : null,
      builder: (context, snapshot) => Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(99),
        color: Colors.transparent,
        child: PopupMenuButton<Object>(
          popUpAnimationStyle: FluffyThemes.isColumnMode(context)
              ? AnimationStyle.noAnimation
              : null, // https://github.com/flutter/flutter/issues/167180
          onSelected: (o) => _clientSelected(o, context),
          itemBuilder: _bundleMenuItems,
          child: Center(
            child: Avatar(
              mxContent: snapshot.data?.avatarUrl,
              name:
                  snapshot.data?.displayName ?? matrix.client.userID?.localpart,
              size: 32,
            ),
          ),
        ),
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
        // case SettingsAction.addAccount:
        //   final consent = await showOkCancelAlertDialog(
        //     context: context,
        //     title: L10n.of(context).addAccount,
        //     message: L10n.of(context).enableMultiAccounts,
        //     okLabel: L10n.of(context).next,
        //     cancelLabel: L10n.of(context).cancel,
        //   );
        //   if (consent != OkCancelResult.ok) return;
        //   context.go('/rooms/settings/addaccount');
        //   break;
        // case SettingsAction.newGroup:
        //   context.go('/rooms/newgroup');
        //   break;

        case SettingsAction.invite:
          FluffyShare.shareInviteLink(context);
          break;

        case SettingsAction.settings:
          context.go('/rooms/settings');
          break;

        case SettingsAction.setStatus:
          controller.setStatus();
          break;

        case SettingsAction.store:
          await launchUrl(
            Uri.parse('https://www.radiohemp.com/store/'),
            mode: LaunchMode.externalApplication,
          );
          break;

        case SettingsAction.course:
          await launchUrl(
            Uri.parse(
              'https://www.radiohemp.com/produto/como-plantar-maconha-medicinal/',
            ),
            mode: LaunchMode.externalApplication,
          );
          break;

        case SettingsAction.podcasts:
          await launchUrl(
            Uri.parse('https://www.radiohemp.com/podcast/'),
            mode: LaunchMode.externalApplication,
          );
          break;

        case SettingsAction.about:
          PlatformInfos.showAboutInfo(context);
          break;
      }
    }
  }
}

enum SettingsAction {
  // addAccount,
  // newGroup,
  setStatus,
  invite,
  settings,
  about,
  store,
  course,
  podcasts
  // archive,
}
