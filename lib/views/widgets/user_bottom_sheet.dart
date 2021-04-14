import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/dialogs/permission_slider_dialog.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:flutter/material.dart';
import 'content_banner.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../../utils/presence_extension.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

class UserBottomSheet extends StatelessWidget {
  final User user;
  final Function onMention;

  const UserBottomSheet({
    Key key,
    @required this.user,
    this.onMention,
  }) : super(key: key);

  void participantAction(BuildContext context, String action) async {
    final Function _askConfirmation =
        () async => (await showOkCancelAlertDialog(
              context: context,
              useRootNavigator: false,
              title: L10n.of(context).areYouSure,
              okLabel: L10n.of(context).yes,
              cancelLabel: L10n.of(context).no,
            ) ==
            OkCancelResult.ok);
    switch (action) {
      case 'mention':
        Navigator.of(context, rootNavigator: false).pop();
        onMention();
        break;
      case 'ban':
        if (await _askConfirmation()) {
          await showFutureLoadingDialog(
            context: context,
            future: () => user.ban(),
          );
          Navigator.of(context, rootNavigator: false).pop();
        }
        break;
      case 'unban':
        if (await _askConfirmation()) {
          await showFutureLoadingDialog(
            context: context,
            future: () => user.unban(),
          );
          Navigator.of(context, rootNavigator: false).pop();
        }
        break;
      case 'kick':
        if (await _askConfirmation()) {
          await showFutureLoadingDialog(
            context: context,
            future: () => user.kick(),
          );
          Navigator.of(context, rootNavigator: false).pop();
        }
        break;
      case 'permission':
        final newPermission =
            await PermissionSliderDialog(initialPermission: user.powerLevel)
                .show(context);
        if (newPermission != null) {
          if (newPermission == 100 && await _askConfirmation() == false) break;
          await showFutureLoadingDialog(
            context: context,
            future: () => user.setPower(newPermission),
          );
          Navigator.of(context, rootNavigator: false).pop();
        }
        break;
      case 'message':
        final roomId = await user.startDirectChat();
        await AdaptivePageLayout.of(context)
            .pushNamedAndRemoveUntilIsFirst('/rooms/$roomId');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = user.room.client;
    final presence = client.presences[user.id];
    final items = <PopupMenuEntry<String>>[];

    if (onMention != null) {
      items.add(
        PopupMenuItem(
          value: 'mention',
          child: _TextWithIcon(
            L10n.of(context).mention,
            Icons.alternate_email_outlined,
          ),
        ),
      );
    }
    if (user.id != user.room.client.userID && !user.room.isDirectChat) {
      items.add(
        PopupMenuItem(
          value: 'message',
          child: _TextWithIcon(
            L10n.of(context).sendAMessage,
            Icons.send_outlined,
          ),
        ),
      );
    }
    if (user.canChangePowerLevel) {
      items.add(
        PopupMenuItem(
          value: 'permission',
          child: _TextWithIcon(
            L10n.of(context).setPermissionsLevel,
            Icons.edit_attributes_outlined,
          ),
        ),
      );
    }
    if (user.canKick) {
      items.add(
        PopupMenuItem(
          value: 'kick',
          child: _TextWithIcon(
            L10n.of(context).kickFromChat,
            Icons.exit_to_app_outlined,
          ),
        ),
      );
    }
    if (user.canBan && user.membership != Membership.ban) {
      items.add(
        PopupMenuItem(
          value: 'ban',
          child: _TextWithIcon(
            L10n.of(context).banFromChat,
            Icons.warning_sharp,
          ),
        ),
      );
    } else if (user.canBan && user.membership == Membership.ban) {
      items.add(
        PopupMenuItem(
          value: 'unban',
          child: _TextWithIcon(
            L10n.of(context).removeExile,
            Icons.warning_outlined,
          ),
        ),
      );
    }
    return Center(
      child: Container(
        width: min(
            MediaQuery.of(context).size.width, FluffyThemes.columnWidth * 1.5),
        child: Material(
          elevation: 4,
          child: SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                leading: IconButton(
                  icon: Icon(Icons.arrow_downward_outlined),
                  onPressed: Navigator.of(context, rootNavigator: false).pop,
                  tooltip: L10n.of(context).close,
                ),
                title: Text(user.calcDisplayname()),
                actions: [
                  if (user.id != user.room.client.userID)
                    PopupMenuButton(
                      itemBuilder: (_) => items,
                      onSelected: (action) =>
                          participantAction(context, action),
                    ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ContentBanner(
                      user.avatarUrl,
                      defaultIcon: Icons.person_outline,
                      client: user.room.client,
                    ),
                  ),
                  ListTile(
                    title: Text(L10n.of(context).username),
                    subtitle: Text(user.id),
                    trailing: Icon(Icons.share_outlined),
                    onTap: () => FluffyShare.share(user.id, context),
                  ),
                  if (presence != null)
                    ListTile(
                      title: Text(presence.getLocalizedStatusMessage(context)),
                      subtitle:
                          Text(presence.getLocalizedLastActiveAgo(context)),
                      trailing: Icon(Icons.circle,
                          color: presence.presence.currentlyActive ?? false
                              ? Colors.green
                              : Colors.grey),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextWithIcon extends StatelessWidget {
  final String text;
  final IconData iconData;

  const _TextWithIcon(
    this.text,
    this.iconData, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData),
        SizedBox(width: 16),
        Text(text),
      ],
    );
  }
}
