import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/invitation_selection/invitation_selection.dart';
import 'package:fluffychat/pages/user_bottom_sheet/user_bottom_sheet.dart';
import 'package:fluffychat/pangea/analytics_misc/level_display_name.dart';
import 'package:fluffychat/pangea/chat_settings/constants/room_settings_constants.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/refer_friends_dialog.dart';
import 'package:fluffychat/pangea/common/widgets/full_width_dialog.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class InvitationSelectionView extends StatelessWidget {
  final InvitationSelectionController controller;

  const InvitationSelectionView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final room =
        Matrix.of(context).client.getRoomById(controller.widget.roomId);
    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }

    // #Pangea
    // final groupName = room.name.isEmpty ? L10n.of(context).group : room.name;
    // Pangea#
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        titleSpacing: 0,
        title: Text(L10n.of(context).inviteContact),
      ),
      body: MaxWidthBody(
        innerPadding: const EdgeInsets.symmetric(vertical: 8),
        // #Pangea
        withScrolling: false,
        // Pangea#
        child: Column(
          children: [
            Padding(
              // #Pangea
              // padding: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.only(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              // Pangea#
              child: TextField(
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.secondaryContainer,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.normal,
                  ),
                  // #Pangea
                  hintText: L10n.of(context).inviteStudentByUserName,
                  // hintText: L10n.of(context).inviteContactToGroup(groupName),
                  // Pangea#
                  prefixIcon: controller.loading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 12,
                          ),
                          child: SizedBox.square(
                            dimension: 24,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : const Icon(Icons.search_outlined),
                ),
                onChanged: controller.searchUserWithCoolDown,
              ),
            ),
            // #Pangea
            // StreamBuilder<Object>(
            Expanded(
              child: StreamBuilder<Object>(
                // Pangea#
                stream: room.client.onRoomState.stream
                    .where((update) => update.roomId == room.id),
                builder: (context, snapshot) {
                  final participants =
                      room.getParticipants().map((user) => user.id).toSet();
                  return controller.foundProfiles.isNotEmpty
                      ? ListView.builder(
                          // #Pangea
                          // physics: const NeverScrollableScrollPhysics(),
                          // shrinkWrap: true,
                          // Pangea#
                          itemCount: controller.foundProfiles.length,
                          itemBuilder: (BuildContext context, int i) =>
                              _InviteContactListTile(
                            profile: controller.foundProfiles[i],
                            isMember: participants
                                .contains(controller.foundProfiles[i].userId),
                            onTap: () => controller.inviteAction(
                              context,
                              controller.foundProfiles[i].userId,
                              controller.foundProfiles[i].displayName ??
                                  controller
                                      .foundProfiles[i].userId.localpart ??
                                  L10n.of(context).user,
                            ),
                          ),
                        )
                      : FutureBuilder<List<User>>(
                          future: controller.getContacts(context),
                          builder: (BuildContext context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                ),
                              );
                            }
                            final contacts = snapshot.data!;
                            return ListView.builder(
                              // #Pangea
                              // physics: const NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              // itemCount: contacts.length,
                              // itemBuilder: (BuildContext context, int i) =>
                              //    _InviteContactListTile(
                              itemCount: contacts.length + 1,
                              itemBuilder: (BuildContext context, int i) {
                                if (i == contacts.length) {
                                  return room.isSpace
                                      ? const SizedBox()
                                      : Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: SizedBox(
                                              width: 450,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${AppConfig.assetsBaseURL}/${RoomSettingsConstants.referFriendAsset}",
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const SizedBox(),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator
                                                          .adaptive(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                }
                                return _InviteContactListTile(
                                  // Pangea#
                                  user: contacts[i],
                                  profile: Profile(
                                    avatarUrl: contacts[i].avatarUrl,
                                    displayName: contacts[i].displayName ??
                                        contacts[i].id.localpart ??
                                        L10n.of(context).user,
                                    userId: contacts[i].id,
                                  ),
                                  isMember:
                                      participants.contains(contacts[i].id),
                                  onTap: () => controller.inviteAction(
                                    context,
                                    contacts[i].id,
                                    contacts[i].displayName ??
                                        contacts[i].id.localpart ??
                                        L10n.of(context).user,
                                  ),
                                  // #Pangea
                                  roomPowerLevel: controller.participants
                                      ?.firstWhereOrNull(
                                        (element) =>
                                            element.id == contacts[i].id,
                                      )
                                      ?.powerLevel,
                                  membership: controller.participants
                                      ?.firstWhereOrNull(
                                        (element) =>
                                            element.id == contacts[i].id,
                                      )
                                      ?.membership,
                                  // Pangea#
                                );
                              },
                            );
                          },
                        );
                },
              ),
            ),
            // #Pangea
            if (!room.isSpace)
              Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 16.0,
                  bottom: FluffyThemes.isColumnMode(context) ? 0 : 16.0,
                ),
                child: Row(
                  spacing: 8.0,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) => FullWidthDialog(
                            dialogContent: ReferFriendsDialog(room: room),
                            maxWidth: 600.0,
                            maxHeight: 800.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.gold,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 12.0,
                          children: [
                            Icon(
                              Icons.redeem_outlined,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? DefaultTextStyle.of(context).style.color
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            Text(
                              L10n.of(context).referFriends,
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? null
                                    : Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => context.go("/rooms/${room.id}"),
                        style: ElevatedButton.styleFrom(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 12.0,
                          children: [
                            Icon(
                              Icons.chat_outlined,
                              color: DefaultTextStyle.of(context).style.color,
                            ),
                            Text(
                              L10n.of(context).startChatting,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Pangea#
          ],
        ),
      ),
    );
  }
}

class _InviteContactListTile extends StatelessWidget {
  final Profile profile;
  final User? user;
  final bool isMember;
  final void Function() onTap;
  // #Pangea
  final int? roomPowerLevel;
  final Membership? membership;
  // Pangea#

  const _InviteContactListTile({
    required this.profile,
    this.user,
    required this.isMember,
    required this.onTap,
    // #Pangea
    this.roomPowerLevel,
    this.membership,
    // Pangea#
  });

  @override
  Widget build(BuildContext context) {
    // #Pangea
    String? permissionCopy() {
      if (roomPowerLevel == null) {
        return null;
      }

      return roomPowerLevel! >= 100
          ? L10n.of(context).admin
          : roomPowerLevel! >= 50
              ? L10n.of(context).moderator
              : null;
    }

    String? membershipCopy() => switch (membership) {
          Membership.ban => L10n.of(context).banned,
          Membership.invite => L10n.of(context).invited,
          Membership.join => null,
          Membership.knock => L10n.of(context).knocking,
          Membership.leave => L10n.of(context).leftTheChat,
          null => null,
        };
    // Pangea#

    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return ListTile(
      leading: Avatar(
        mxContent: profile.avatarUrl,
        name: profile.displayName,
        presenceUserId: profile.userId,
        onTap: () => showAdaptiveBottomSheet(
          context: context,
          builder: (c) => UserBottomSheet(
            user: user,
            profile: profile,
            outerContext: context,
          ),
        ),
      ),
      title: Text(
        profile.displayName ?? profile.userId.localpart ?? l10n.user,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        profile.userId,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: theme.colorScheme.secondary,
        ),
      ),
      // #Pangea
      // trailing: TextButton.icon(
      //   onPressed: isMember ? null : onTap,
      //   label: Text(isMember ? l10n.participant : l10n.invite),
      //   icon: Icon(isMember ? Icons.check : Icons.add),
      // ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LevelDisplayName(userId: profile.userId),
          if (membershipCopy() != null)
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: theme.secondaryHeaderColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                membershipCopy()!,
                style: theme.textTheme.labelSmall,
              ),
            )
          else if (permissionCopy() != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: roomPowerLevel! >= 100
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(
                  AppConfig.borderRadius,
                ),
              ),
              child: Text(
                permissionCopy()!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: roomPowerLevel! >= 100
                      ? theme.colorScheme.onTertiary
                      : theme.colorScheme.onTertiaryContainer,
                ),
              ),
            )
          else if (!isMember || roomPowerLevel == null || roomPowerLevel! < 50)
            TextButton.icon(
              onPressed: isMember ? null : onTap,
              label: Text(isMember ? l10n.participant : l10n.invite),
              icon: Icon(isMember ? Icons.check : Icons.add),
            ),
        ],
      ),
      // Pangea#
    );
  }
}
