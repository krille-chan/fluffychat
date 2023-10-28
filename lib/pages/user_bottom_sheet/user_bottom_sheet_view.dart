import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/widgets/avatar.dart';
import '../../widgets/matrix.dart';
import 'user_bottom_sheet.dart';

class UserBottomSheetView extends StatelessWidget {
  final UserBottomSheetController controller;

  const UserBottomSheetView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final user = controller.widget.user;
    final userId = (user?.id ?? controller.widget.profile?.userId)!;
    final displayname = (user?.calcDisplayname() ??
        controller.widget.profile?.displayName ??
        controller.widget.profile?.userId.localpart)!;
    final avatarUrl = user?.avatarUrl ?? controller.widget.profile?.avatarUrl;

    final client = Matrix.of(controller.widget.outerContext).client;
    final profileSearchError = controller.widget.profileSearchError;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: CloseButton(
            onPressed: Navigator.of(context, rootNavigator: false).pop,
          ),
          title: Text(displayname.trim().split(' ').first),
          actions: [
            if (userId != client.userID &&
                !client.ignoredUsers.contains(userId))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton.icon(
                  label: Text(
                    L10n.of(context)!.ignore,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  icon: Icon(
                    Icons.shield_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => controller
                      .participantAction(UserBottomSheetAction.ignore),
                ),
              ),
          ],
        ),
        body: ListView(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    elevation:
                        Theme.of(context).appBarTheme.scrolledUnderElevation ??
                            4,
                    shadowColor: Theme.of(context).appBarTheme.shadowColor,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                      borderRadius: BorderRadius.circular(
                        Avatar.defaultSize * 2.5,
                      ),
                    ),
                    child: Avatar(
                      mxContent: avatarUrl,
                      name: displayname,
                      size: Avatar.defaultSize * 2.5,
                      fontSize: 18 * 2.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () => FluffyShare.share(
                          'https://matrix.to/#/$userId',
                          context,
                        ),
                        icon: Icon(
                          Icons.adaptive.share_outlined,
                          size: 16,
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onBackground,
                        ),
                        label: Text(
                          displayname,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          //  style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => FluffyShare.share(
                          userId,
                          context,
                          copyOnly: true,
                        ),
                        icon: const Icon(
                          Icons.copy_outlined,
                          size: 14,
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                        ),
                        label: Text(
                          userId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          //    style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (userId != client.userID)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: ElevatedButton.icon(
                  onPressed: () => controller
                      .participantAction(UserBottomSheetAction.message),
                  icon: const Icon(Icons.forum_outlined),
                  label: Text(L10n.of(context)!.sendAMessage),
                ),
              ),
            if (controller.widget.onMention != null)
              ListTile(
                leading: const Icon(Icons.alternate_email_outlined),
                title: Text(L10n.of(context)!.mention),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.mention),
              ),
            if (user != null && user.canChangePowerLevel)
              ListTile(
                title: Text(L10n.of(context)!.setPermissionsLevel),
                leading: const Icon(Icons.edit_attributes_outlined),
                onTap: () => controller
                    .participantAction(UserBottomSheetAction.permission),
              ),
            if (user != null && user.canKick)
              ListTile(
                title: Text(L10n.of(context)!.kickFromChat),
                leading: const Icon(Icons.exit_to_app_outlined),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.kick),
              ),
            if (user != null &&
                user.canBan &&
                user.membership != Membership.ban)
              ListTile(
                title: Text(L10n.of(context)!.banFromChat),
                leading: const Icon(Icons.warning_sharp),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.ban),
              )
            else if (user != null &&
                user.canBan &&
                user.membership == Membership.ban)
              ListTile(
                title: Text(L10n.of(context)!.unbanFromChat),
                leading: const Icon(Icons.warning_outlined),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.unban),
              ),
            if (user != null && user.id != client.userID)
              ListTile(
                textColor: Theme.of(context).colorScheme.onErrorContainer,
                iconColor: Theme.of(context).colorScheme.onErrorContainer,
                title: Text(L10n.of(context)!.reportUser),
                leading: const Icon(Icons.report_outlined),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.report),
              ),
            if (profileSearchError != null)
              ListTile(
                leading: const Icon(
                  Icons.warning_outlined,
                  color: Colors.orange,
                ),
                subtitle: Text(
                  L10n.of(context)!.profileNotFound,
                  style: const TextStyle(color: Colors.orange),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
