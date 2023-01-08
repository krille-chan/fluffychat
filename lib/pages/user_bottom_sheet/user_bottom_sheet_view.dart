import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/widgets/avatar.dart';
import '../../utils/matrix_sdk_extensions/presence_extension.dart';
import '../../widgets/matrix.dart';
import 'user_bottom_sheet.dart';

class UserBottomSheetView extends StatelessWidget {
  final UserBottomSheetController controller;

  const UserBottomSheetView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = controller.widget.user;
    final client = Matrix.of(context).client;
    final presence = client.presences[user.id];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: CloseButton(
            onPressed: Navigator.of(context, rootNavigator: false).pop,
          ),
          title: Text(user.calcDisplayname()),
          actions: [
            if (user.id != client.userID)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton.icon(
                  onPressed: () => controller
                      .participantAction(UserBottomSheetAction.message),
                  icon: const Icon(Icons.chat_outlined),
                  label: Text(L10n.of(context)!.newChat),
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
                  child: Avatar(
                    mxContent: user.avatarUrl,
                    name: user.calcDisplayname(),
                    size: Avatar.defaultSize * 2,
                    fontSize: 24,
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(right: 16.0),
                    title: Text(user.id),
                    subtitle: presence == null
                        ? null
                        : Text(presence.getLocalizedLastActiveAgo(context)),
                    trailing: IconButton(
                      icon: Icon(Icons.adaptive.share),
                      onPressed: () => FluffyShare.share(
                        user.id,
                        context,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (controller.widget.onMention != null)
              ListTile(
                trailing: const Icon(Icons.alternate_email_outlined),
                title: Text(L10n.of(context)!.mention),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.mention),
              ),
            if (user.canChangePowerLevel)
              ListTile(
                title: Text(L10n.of(context)!.setPermissionsLevel),
                trailing: const Icon(Icons.edit_attributes_outlined),
                onTap: () => controller
                    .participantAction(UserBottomSheetAction.permission),
              ),
            if (user.canKick)
              ListTile(
                title: Text(L10n.of(context)!.kickFromChat),
                trailing: const Icon(Icons.exit_to_app_outlined),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.kick),
              ),
            if (user.canBan && user.membership != Membership.ban)
              ListTile(
                title: Text(L10n.of(context)!.banFromChat),
                trailing: const Icon(Icons.warning_sharp),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.ban),
              )
            else if (user.canBan && user.membership == Membership.ban)
              ListTile(
                title: Text(L10n.of(context)!.unbanFromChat),
                trailing: const Icon(Icons.warning_outlined),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.unban),
              ),
            if (user.id != client.userID &&
                !client.ignoredUsers.contains(user.id))
              ListTile(
                textColor: Theme.of(context).colorScheme.onErrorContainer,
                iconColor: Theme.of(context).colorScheme.onErrorContainer,
                title: Text(L10n.of(context)!.ignore),
                trailing: const Icon(Icons.block),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.ignore),
              ),
            if (user.id != client.userID)
              ListTile(
                textColor: Theme.of(context).colorScheme.error,
                iconColor: Theme.of(context).colorScheme.error,
                title: Text(L10n.of(context)!.reportUser),
                trailing: const Icon(Icons.shield_outlined),
                onTap: () =>
                    controller.participantAction(UserBottomSheetAction.report),
              ),
          ],
        ),
      ),
    );
  }
}
