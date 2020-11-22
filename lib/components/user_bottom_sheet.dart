import 'dart:math';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/adaptive_page_layout.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/material.dart';
import 'content_banner.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../utils/presence_extension.dart';
import 'dialogs/simple_dialogs.dart';
import 'matrix.dart';
import '../views/key_verification.dart';
import '../utils/app_route.dart';

class UserBottomSheet extends StatelessWidget {
  final User user;
  final Function onMention;

  const UserBottomSheet({Key key, @required this.user, this.onMention})
      : super(key: key);

  void participantAction(BuildContext context, String action) async {
    final Function _askConfirmation = () async =>
        (await showOkCancelAlertDialog(
                context: context, title: L10n.of(context).areYouSure) ==
            OkCancelResult.ok);
    switch (action) {
      case 'mention':
        Navigator.of(context).pop();
        onMention();
        break;
      case 'ban':
        if (await _askConfirmation()) {
          await SimpleDialogs(context).tryRequestWithLoadingDialog(user.ban());
          Navigator.of(context).pop();
        }
        break;
      case 'unban':
        if (await _askConfirmation()) {
          await SimpleDialogs(context)
              .tryRequestWithLoadingDialog(user.unban());
          Navigator.of(context).pop();
        }
        break;
      case 'kick':
        if (await _askConfirmation()) {
          await SimpleDialogs(context).tryRequestWithLoadingDialog(user.kick());
          Navigator.of(context).pop();
        }
        break;
      case 'admin':
        if (await _askConfirmation()) {
          await SimpleDialogs(context)
              .tryRequestWithLoadingDialog(user.setPower(100));
          Navigator.of(context).pop();
        }
        break;
      case 'moderator':
        if (await _askConfirmation()) {
          await SimpleDialogs(context)
              .tryRequestWithLoadingDialog(user.setPower(50));
          Navigator.of(context).pop();
        }
        break;
      case 'user':
        if (await _askConfirmation()) {
          await SimpleDialogs(context)
              .tryRequestWithLoadingDialog(user.setPower(0));
          Navigator.of(context).pop();
        }
        break;
      case 'message':
        final roomId = await user.startDirectChat();
        await Navigator.of(context).pushAndRemoveUntil(
            AppRoute.defaultRoute(
              context,
              ChatView(roomId),
            ),
            (Route r) => r.isFirst);
        break;
    }
  }

  void _verifyAction(BuildContext context) async {
    final client = Matrix.of(context).client;
    final req = await client.userDeviceKeys[user.id].startVerification();
    await Navigator.of(context).push(
      AppRoute.defaultRoute(
        context,
        KeyVerificationView(request: req),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
    final presence = client.presences[user.id];
    final verificationStatus = client.userDeviceKeys[user.id]?.verified;
    var items = <PopupMenuEntry<String>>[];

    if (onMention != null) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              L10n.of(context).mention,
              Icons.alternate_email_outlined,
            ),
            value: 'mention'),
      );
    }
    if (user.id != Matrix.of(context).client.userID &&
        !user.room.isDirectChat) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              L10n.of(context).sendAMessage,
              Icons.send,
            ),
            value: 'message'),
      );
    }
    if (user.canChangePowerLevel &&
        user.room.ownPowerLevel == 100 &&
        user.powerLevel != 100) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              L10n.of(context).makeAnAdmin,
              Icons.arrow_upward,
            ),
            value: 'admin'),
      );
    }
    if (user.canChangePowerLevel &&
        user.room.ownPowerLevel >= 50 &&
        user.powerLevel != 50) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              L10n.of(context).makeAModerator,
              Icons.arrow_upward_outlined,
            ),
            value: 'moderator'),
      );
    }
    if (user.canChangePowerLevel && user.powerLevel != 0) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              L10n.of(context).revokeAllPermissions,
              Icons.arrow_downward_outlined,
            ),
            value: 'user'),
      );
    }
    if (user.canKick) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              L10n.of(context).kickFromChat,
              Icons.exit_to_app_outlined,
            ),
            value: 'kick'),
      );
    }
    if (user.canBan && user.membership != Membership.ban) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              L10n.of(context).banFromChat,
              Icons.warning_sharp,
            ),
            value: 'ban'),
      );
    } else if (user.canBan && user.membership == Membership.ban) {
      items.add(
        PopupMenuItem(
            child: _TextWithIcon(
              L10n.of(context).removeExile,
              Icons.warning_outlined,
            ),
            value: 'unban'),
      );
    }
    return Center(
      child: Container(
        width: min(MediaQuery.of(context).size.width,
            AdaptivePageLayout.defaultMinWidth * 1.5),
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
                        Icons.lock,
                        color: {
                              UserVerifiedStatus.unknownDevice: Colors.red,
                              UserVerifiedStatus.verified: Colors.green,
                            }[verificationStatus] ??
                            Colors.orange,
                      ),
                      onPressed: () =>
                          verificationStatus == UserVerifiedStatus.unknown
                              ? _verifyAction(context)
                              : null,
                    ),
                  if (user.id != Matrix.of(context).client.userID)
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
                    ),
                  ),
                  ListTile(
                    title: Text(L10n.of(context).username),
                    subtitle: Text(user.id),
                    trailing: Icon(Icons.share),
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
