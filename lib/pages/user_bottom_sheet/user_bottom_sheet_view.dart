import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/presence_builder.dart';
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
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayname),
              PresenceBuilder(
                userId: userId,
                client: client,
                builder: (context, presence) {
                  if (presence == null ||
                      (presence.presence == PresenceType.offline &&
                          presence.lastActiveTimestamp == null)) {
                    return const SizedBox.shrink();
                  }

                  final dotColor = presence.presence.isOnline
                      ? Colors.green
                      : presence.presence.isUnavailable
                          ? Colors.orange
                          : Colors.grey;

                  final lastActiveTimestamp = presence.lastActiveTimestamp;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: dotColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      if (presence.currentlyActive == true)
                        Text(
                          L10n.of(context)!.currentlyActive,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      else if (lastActiveTimestamp != null)
                        Text(
                          L10n.of(context)!.lastActiveAgo(
                            lastActiveTimestamp.localizedTimeShort(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            if (userId != client.userID &&
                !client.ignoredUsers.contains(userId))
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.block_outlined),
                  tooltip: L10n.of(context)!.block,
                  onPressed: () => controller
                      .participantAction(UserBottomSheetAction.ignore),
                ),
              ),
          ],
        ),
        body: StreamBuilder<Object>(
          stream: user?.room.client.onSync.stream.where(
            (syncUpdate) =>
                syncUpdate.rooms?.join?[user.room.id]?.timeline?.events?.any(
                  (state) => state.type == EventTypes.RoomPowerLevels,
                ) ??
                false,
          ),
          builder: (context, snapshot) {
            return ListView(
              children: [
                if (user?.membership == Membership.knock)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Material(
                      color:
                          // ignore: deprecated_member_use
                          Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                      child: ListTile(
                        minVerticalPadding: 16,
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            L10n.of(context)!
                                .userWouldLikeToChangeTheChat(displayname),
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                foregroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: controller.knockAccept,
                              icon: const Icon(Icons.check_outlined),
                              label: Text(L10n.of(context)!.accept),
                            ),
                            const SizedBox(width: 12),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .errorContainer,
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                              onPressed: controller.knockDecline,
                              icon: const Icon(Icons.cancel_outlined),
                              label: Text(L10n.of(context)!.decline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Material(
                        elevation: Theme.of(context)
                                .appBarTheme
                                .scrolledUnderElevation ??
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
                                  Theme.of(context).colorScheme.onSurface,
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
                      label: Text(
                        controller.widget.user == null
                            ? L10n.of(context)!.startConversation
                            : L10n.of(context)!.sendAMessage,
                      ),
                    ),
                  ),
                PresenceBuilder(
                  userId: userId,
                  client: client,
                  builder: (context, presence) {
                    final status = presence?.statusMsg;
                    if (status == null || status.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ListTile(
                      title: SelectableLinkify(
                        text: status,
                        style: const TextStyle(fontSize: 16),
                        options: const LinkifyOptions(humanize: false),
                        linkStyle: const TextStyle(
                          color: Colors.blueAccent,
                          decorationColor: Colors.blueAccent,
                        ),
                        onOpen: (url) =>
                            UrlLauncher(context, url.url).launchUrl(),
                      ),
                    );
                  },
                ),
                if (controller.widget.onMention != null)
                  ListTile(
                    leading: const Icon(Icons.alternate_email_outlined),
                    title: Text(L10n.of(context)!.mention),
                    onTap: () => controller
                        .participantAction(UserBottomSheetAction.mention),
                  ),
                if (user != null) ...[
                  Divider(color: Theme.of(context).dividerColor),
                  ListTile(
                    title: Text(
                      '${L10n.of(context)!.userRole} (${user.powerLevel})',
                    ),
                    leading: const Icon(Icons.person_outlined),
                    trailing: Material(
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius / 2),
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      child: DropdownButton<int>(
                        onChanged: user.canChangeUserPowerLevel ||
                                // Workaround until https://github.com/famedly/matrix-dart-sdk/pull/1765
                                (user.room.canChangePowerLevel &&
                                    user.id == user.room.client.userID)
                            ? controller.setPowerLevel
                            : null,
                        value: {0, 50, 100}.contains(user.powerLevel)
                            ? user.powerLevel
                            : null,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        borderRadius:
                            BorderRadius.circular(AppConfig.borderRadius / 2),
                        underline: const SizedBox.shrink(),
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(L10n.of(context)!.user),
                          ),
                          DropdownMenuItem(
                            value: 50,
                            child: Text(L10n.of(context)!.moderator),
                          ),
                          DropdownMenuItem(
                            value: 100,
                            child: Text(L10n.of(context)!.admin),
                          ),
                          DropdownMenuItem(
                            value: null,
                            child: Text(L10n.of(context)!.custom),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Theme.of(context).dividerColor),
                ],
                if (user != null && user.canKick)
                  ListTile(
                    textColor: Theme.of(context).colorScheme.error,
                    iconColor: Theme.of(context).colorScheme.error,
                    title: Text(L10n.of(context)!.kickFromChat),
                    leading: const Icon(Icons.exit_to_app_outlined),
                    onTap: () => controller
                        .participantAction(UserBottomSheetAction.kick),
                  ),
                if (user != null &&
                    user.canBan &&
                    user.membership != Membership.ban)
                  ListTile(
                    textColor: Theme.of(context).colorScheme.onErrorContainer,
                    iconColor: Theme.of(context).colorScheme.onErrorContainer,
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
                    onTap: () => controller
                        .participantAction(UserBottomSheetAction.unban),
                  ),
                if (user != null && user.id != client.userID)
                  ListTile(
                    textColor: Theme.of(context).colorScheme.onErrorContainer,
                    iconColor: Theme.of(context).colorScheme.onErrorContainer,
                    title: Text(L10n.of(context)!.reportUser),
                    leading: const Icon(Icons.report_outlined),
                    onTap: () => controller
                        .participantAction(UserBottomSheetAction.report),
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
            );
          },
        ),
      ),
    );
  }
}
