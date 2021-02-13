import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/permission_slider_dialog.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:flutter/material.dart';
import 'content_banner.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../utils/presence_extension.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'dialogs/key_verification_dialog.dart';

class UserBottomSheet extends StatelessWidget {
  final User user;
  final Function onMention;
  final L10n l10n;

  const UserBottomSheet({
    Key key,
    @required this.user,
    @required this.l10n,
    this.onMention,
  }) : super(key: key);

  void participantAction(BuildContext context, String action) async {
    final Function _askConfirmation = () async =>
        (await showOkCancelAlertDialog(
                context: context, title: l10n.areYouSure) ==
            OkCancelResult.ok);
    switch (action) {
      case 'mention':
        Navigator.of(context).pop();
        onMention();
        break;
      case 'ban':
        if (await _askConfirmation()) {
          await showFutureLoadingDialog(
            context: context,
            future: () => user.ban(),
          );
          Navigator.of(context).pop();
        }
        break;
      case 'unban':
        if (await _askConfirmation()) {
          await showFutureLoadingDialog(
            context: context,
            future: () => user.unban(),
          );
          Navigator.of(context).pop();
        }
        break;
      case 'kick':
        if (await _askConfirmation()) {
          await showFutureLoadingDialog(
            context: context,
            future: () => user.kick(),
          );
          Navigator.of(context).pop();
        }
        break;
      case 'permission':
        final newPermission = await PermissionSliderDialog(
          initialPermission: user.powerLevel,
          l10n: L10n.of(context),
        ).show(context);
        if (newPermission != null) {
          if (newPermission == 100 && await _askConfirmation() == false) break;
          await showFutureLoadingDialog(
            context: context,
            future: () => user.setPower(newPermission),
          );
          Navigator.of(context).pop();
        }
        break;
      case 'message':
        final roomId = await user.startDirectChat();
        await AdaptivePageLayout.of(context)
            .pushNamedAndRemoveUntilIsFirst('/rooms/${roomId}');
        break;
    }
  }

  void _verifyAction(BuildContext context) async {
    final client = user.room.client;
    final req = await client.userDeviceKeys[user.id].startVerification();
    await KeyVerificationDialog(
      request: req,
      l10n: L10n.of(context),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final client = user.room.client;
    final presence = client.presences[user.id];
    final verificationStatus = client.userDeviceKeys[user.id]?.verified;
    var items = <PopupMenuEntry<String>>[];

    if (onMention != null) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              l10n.mention,
              Icons.alternate_email_outlined,
            ),
            value: 'mention'),
      );
    }
    if (user.id != user.room.client.userID && !user.room.isDirectChat) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              l10n.sendAMessage,
              Icons.send_outlined,
            ),
            value: 'message'),
      );
    }
    if (user.canChangePowerLevel) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              l10n.setPermissionsLevel,
              Icons.edit_attributes_outlined,
            ),
            value: 'permission'),
      );
    }
    if (user.canKick) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              l10n.kickFromChat,
              Icons.exit_to_app_outlined,
            ),
            value: 'kick'),
      );
    }
    if (user.canBan && user.membership != Membership.ban) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              l10n.banFromChat,
              Icons.warning_sharp,
            ),
            value: 'ban'),
      );
    } else if (user.canBan && user.membership == Membership.ban) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              l10n.removeExile,
              Icons.warning_outlined,
            ),
            value: 'unban'),
      );
    }
    return Center(
      child: Container(
        width: min(
            MediaQuery.of(context).size.width, FluffyThemes.columnWidth * 1.5),
        child: SafeArea(
          child: Material(
            elevation: 4,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                leading: IconButton(
                  icon: Icon(Icons.arrow_downward_outlined),
                  onPressed: Navigator.of(context).pop,
                ),
                title: Text(user.calcDisplayname()),
                actions: [
                  if (verificationStatus != null)
                    IconButton(
                      icon: Icon(
                        Icons.lock_outlined,
                        color: {
                              UserVerifiedStatus.unknownDevice: Colors.red,
                              UserVerifiedStatus.verified: Colors.green,
                            }[verificationStatus] ??
                            Colors.orange,
                      ),
                      tooltip: {
                            UserVerifiedStatus.unknownDevice:
                                L10n.of(context).userNotVerified,
                            UserVerifiedStatus.verified:
                                L10n.of(context).userVerified,
                          }[verificationStatus] ??
                          L10n.of(context).userUnknownVerification,
                      onPressed: () =>
                          verificationStatus == UserVerifiedStatus.unknown
                              ? _verifyAction(context)
                              : null,
                    ),
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
                    title: Text(l10n.username),
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
