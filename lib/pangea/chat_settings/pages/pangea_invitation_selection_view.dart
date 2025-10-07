import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/analytics_misc/level_display_name.dart';
import 'package:fluffychat/pangea/chat_settings/constants/room_settings_constants.dart';
import 'package:fluffychat/pangea/chat_settings/pages/pangea_invitation_selection.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_plans/map_clipper.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/user_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/member_actions_popup_menu_button.dart';

class PangeaInvitationSelectionView extends StatelessWidget {
  final PangeaInvitationSelectionController controller;

  const PangeaInvitationSelectionView(this.controller, {super.key});

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

    final theme = Theme.of(context);
    final contacts = controller.filteredContacts();

    final doneButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
      child: Row(
        spacing: 34.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          Text(
            L10n.of(context).done,
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onPressed: () => context.go(
        room.isSpace ? "/rooms/spaces/${room.id}/details" : "/rooms/${room.id}",
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        titleSpacing: 0,
        title: Text(L10n.of(context).inviteContact),
      ),
      body: MaxWidthBody(
        maxWidth: 800.0,
        withScrolling: false,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: controller.controller,
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
                  hintText: L10n.of(context).search,
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
              const SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 12.0,
                    children: controller.availableFilters.map((filter) {
                      return FilterChip(
                        label: filter == InvitationFilter.participants
                            ? Row(
                                spacing: 4.0,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.group, size: 16.0),
                                  Text(controller.filterLabel(filter)),
                                ],
                              )
                            : Text(controller.filterLabel(filter)),
                        onSelected: (_) => controller.setFilter(filter),
                        selected: controller.filter == filter,
                      );
                    }).toList(),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: StreamBuilder<Object>(
                    stream: room.client.onRoomState.stream
                        .where((update) => update.roomId == room.id)
                        .rateLimit(const Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      final participants =
                          room.getParticipants().map((user) => user.id).toSet();
                      return controller.filter == InvitationFilter.public
                          ? ListView.builder(
                              itemCount: controller.foundProfiles.length,
                              itemBuilder: (BuildContext context, int i) =>
                                  _InviteContactListTile(
                                profile: controller.foundProfiles[i],
                                isMember: participants.contains(
                                  controller.foundProfiles[i].userId,
                                ),
                                onTap: () => controller.inviteAction(
                                  controller.foundProfiles[i].userId,
                                ),
                                controller: controller,
                              ),
                            )
                          : ListView.builder(
                              itemCount: contacts.length + 2,
                              itemBuilder: (BuildContext context, int i) {
                                if (i == 0) {
                                  return controller.filter ==
                                              InvitationFilter.space &&
                                          controller.spaceParent != null
                                      ? ListTile(
                                          leading: ClipPath(
                                            clipper: MapClipper(),
                                            child: Avatar(
                                              mxContent: controller
                                                  .spaceParent!.avatar,
                                              name: controller.spaceParent!
                                                  .getLocalizedDisplayname(),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                AppConfig.borderRadius / 4,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            controller.spaceParent!
                                                .getLocalizedDisplayname(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            L10n.of(context).countParticipants(
                                              controller.spaceParent!.summary
                                                      .mJoinedMemberCount ??
                                                  1,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: TextButton.icon(
                                            onPressed:
                                                controller.inviteAllInSpace,
                                            label: Text(
                                              L10n.of(context).inviteAllInSpace,
                                            ),
                                            icon: const Icon(Icons.add),
                                          ),
                                        )
                                      : const SizedBox();
                                }

                                i--;

                                if (i == contacts.length) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      width: 450,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${AppConfig.assetsBaseURL}/${RoomSettingsConstants.referFriendAsset}",
                                        errorWidget: (context, url, error) =>
                                            const SizedBox(),
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator
                                              .adaptive(),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return _InviteContactListTile(
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
                                    contacts[i].id,
                                  ),
                                  controller: controller,
                                );
                              },
                            );
                    },
                  ),
                ),
              ),
              Row(
                spacing: 12.0,
                children: [
                  if (room.classCode != null)
                    Expanded(
                      child: PopupMenuButton<int>(
                        borderRadius: BorderRadius.circular(32.0),
                        child: IgnorePointer(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                            child: Row(
                              spacing: 34.0,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.share_outlined,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                                Text(
                                  L10n.of(context).share,
                                  style: TextStyle(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                        onSelected: (value) async {
                          final spaceCode = room.classCode!;
                          String toCopy = spaceCode;
                          if (value == 0) {
                            final String initialUrl = kIsWeb
                                ? html.window.origin!
                                : Environment.frontendURL;
                            toCopy =
                                "$initialUrl/#/join_with_link?${SpaceConstants.classCode}=${room.classCode}";
                          }

                          await Clipboard.setData(ClipboardData(text: toCopy));
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            SnackBar(
                              content: Text(
                                L10n.of(context).copiedToClipboard,
                              ),
                            ),
                          );
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<int>>[
                          PopupMenuItem<int>(
                            value: 0,
                            child: ListTile(
                              leading: const Icon(Icons.share_outlined),
                              title: Text(L10n.of(context).shareSpaceLink),
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 1,
                            child: ListTile(
                              leading: const Icon(Icons.share_outlined),
                              title: Text(
                                L10n.of(context)
                                    .shareInviteCode(room.classCode!),
                              ),
                              contentPadding: const EdgeInsets.all(0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  room.classCode != null
                      ? doneButton
                      : Expanded(child: doneButton),
                ],
              ),
            ],
          ),
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
  final PangeaInvitationSelectionController controller;

  const _InviteContactListTile({
    required this.profile,
    this.user,
    required this.isMember,
    required this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final theme = Theme.of(context);

    final participant = controller.participants?.firstWhereOrNull(
      (p) => p.id == profile.userId,
    );
    final membership = participant?.membership;

    final String? permissionBatch = participant == null
        ? null
        : participant.powerLevel >= 100
            ? L10n.of(context).admin
            : participant.powerLevel >= 50
                ? L10n.of(context).moderator
                : null;

    return ListTile(
      onTap: participant != null
          ? () => showMemberActionsPopupMenu(
                context: context,
                user: participant,
              )
          : null,
      leading: Avatar(
        mxContent: profile.avatarUrl,
        name: profile.displayName,
        presenceUserId: profile.userId,
        onTap: () => UserDialog.show(
          context: context,
          profile: profile,
        ),
      ),
      title: Text(
        profile.displayName ?? profile.userId.localpart ?? l10n.user,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // https://github.com/pangeachat/client/issues/3047
          const SizedBox(height: 2.0),
          Text(
            profile.userId,
            style: const TextStyle(
              fontSize: 12.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          LevelDisplayName(userId: profile.userId),
        ],
      ),
      trailing: [Membership.invite, Membership.knock].contains(membership)
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.membershipCopy(membership)!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            )
          : permissionBatch != null
              ? Container(
                  margin: const EdgeInsets.only(right: 12.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: participant!.powerLevel >= 100
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(
                      AppConfig.borderRadius,
                    ),
                  ),
                  child: Text(
                    permissionBatch,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: participant.powerLevel >= 100
                          ? theme.colorScheme.onTertiary
                          : theme.colorScheme.onTertiaryContainer,
                    ),
                  ),
                )
              : TextButton.icon(
                  onPressed: isMember ? null : onTap,
                  label: Text(isMember ? l10n.participant : l10n.invite),
                  icon: Icon(isMember ? Icons.check : Icons.add),
                ),
    );
  }
}
