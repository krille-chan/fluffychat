import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import '../../utils/matrix_sdk_extensions.dart/presence_extension.dart';
import '../../widgets/content_banner.dart';
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
    return Center(
      child: SizedBox(
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
                  icon: const Icon(Icons.arrow_downward_outlined),
                  onPressed: Navigator.of(context, rootNavigator: false).pop,
                  tooltip: L10n.of(context)!.close,
                ),
                title: Text(user.calcDisplayname()),
                actions: [
                  if (user.id != client.userID)
                    PopupMenuButton(
                      itemBuilder: (_) => [
                        if (controller.widget.onMention != null)
                          PopupMenuItem(
                            value: 'mention',
                            child: _TextWithIcon(
                              L10n.of(context)!.mention,
                              Icons.alternate_email_outlined,
                            ),
                          ),
                        if (user.id != client.userID && !user.room.isDirectChat)
                          PopupMenuItem(
                            value: 'message',
                            child: _TextWithIcon(
                              L10n.of(context)!.sendAMessage,
                              Icons.send_outlined,
                            ),
                          ),
                        if (user.canChangePowerLevel)
                          PopupMenuItem(
                            value: 'permission',
                            child: _TextWithIcon(
                              L10n.of(context)!.setPermissionsLevel,
                              Icons.edit_attributes_outlined,
                            ),
                          ),
                        if (user.canKick)
                          PopupMenuItem(
                            value: 'kick',
                            child: _TextWithIcon(
                              L10n.of(context)!.kickFromChat,
                              Icons.exit_to_app_outlined,
                            ),
                          ),
                        if (user.canBan && user.membership != Membership.ban)
                          PopupMenuItem(
                            value: 'ban',
                            child: _TextWithIcon(
                              L10n.of(context)!.banFromChat,
                              Icons.warning_sharp,
                            ),
                          )
                        else if (user.canBan &&
                            user.membership == Membership.ban)
                          PopupMenuItem(
                            value: 'unban',
                            child: _TextWithIcon(
                              L10n.of(context)!.unbanFromChat,
                              Icons.warning_outlined,
                            ),
                          ),
                        if (!client.ignoredUsers.contains(user.id))
                          PopupMenuItem(
                            value: 'ignore',
                            child: _TextWithIcon(
                              L10n.of(context)!.ignore,
                              Icons.block,
                            ),
                          ),
                        PopupMenuItem(
                          value: 'report',
                          child: _TextWithIcon(
                            L10n.of(context)!.reportUser,
                            Icons.shield_outlined,
                          ),
                        ),
                      ],
                      onSelected: controller.participantAction,
                    ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ContentBanner(
                      mxContent: user.avatarUrl,
                      defaultIcon: Icons.account_circle_outlined,
                      client: client,
                    ),
                  ),
                  ListTile(
                    title: Text(L10n.of(context)!.username),
                    subtitle: Text(user.id),
                    trailing: Icon(Icons.adaptive.share_outlined),
                    onTap: () => FluffyShare.share(
                      user.id,
                      context,
                    ),
                  ),
                  if (presence != null)
                    ListTile(
                      title: Text(presence.getLocalizedStatusMessage(context)),
                      subtitle:
                          Text(presence.getLocalizedLastActiveAgo(context)),
                      trailing: Icon(Icons.circle,
                          color: presence.presence == PresenceType.online
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData),
        const SizedBox(width: 16),
        Text(text),
      ],
    );
  }
}
