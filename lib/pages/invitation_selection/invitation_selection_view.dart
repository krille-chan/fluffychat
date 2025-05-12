import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/invitation_selection/invitation_selection.dart';
import 'package:fluffychat/pangea/analytics_misc/level_display_name.dart';
import 'package:fluffychat/pangea/chat_settings/constants/room_settings_constants.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/space_invite_buttons.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/utils/stream_extension.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../widgets/adaptive_dialogs/user_dialog.dart';

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
        // #Pangea
        actions: [
          if (room.classCode(context) != null)
            PopupMenuButton<int>(
              icon: const Icon(Icons.share_outlined),
              onSelected: (value) async {
                final spaceCode = room.classCode(context)!;
                String toCopy = spaceCode;
                if (value == 0) {
                  final String initialUrl =
                      kIsWeb ? html.window.origin! : Environment.frontendURL;
                  toCopy =
                      "$initialUrl/#/join_with_link?${SpaceConstants.classCode}=${room.classCode(context)}";
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
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
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
                          .shareInviteCode(room.classCode(context)!),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
        ],
        // Pangea#
      ),
      body: MaxWidthBody(
        innerPadding: const EdgeInsets.symmetric(vertical: 8),
        // #Pangea
        withScrolling: false,
        // Pangea#
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: 450,
                child: CachedNetworkImage(
                  imageUrl:
                      "${AppConfig.assetsBaseURL}/${RoomSettingsConstants.referFriendAsset}",
                  errorWidget: (context, url, error) => const SizedBox(),
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
              ),
            ),
            Column(
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
                  key: controller.viewportKey,
                  child: StreamBuilder<Object>(
                    // stream: room.client.onRoomState.stream
                    //     .where((update) => update.roomId == room.id),
                    stream: room.client.onRoomState.stream
                        .where((update) => update.roomId == room.id)
                        .rateLimit(const Duration(seconds: 1)),
                    // Pangea#
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
                                isMember: participants.contains(
                                  controller.foundProfiles[i].userId,
                                ),
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
                                      final showButtons = controller
                                          .showShareButtons(contacts.length);
                                      return AnimatedOpacity(
                                        duration:
                                            FluffyThemes.animationDuration,
                                        opacity: showButtons ? 1.0 : 0.0,
                                        child: SpaceInviteButtons(room: room),
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
                                    );
                                  },
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  elevation: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      room.isSpace
                          ? L10n.of(context).goToSpaceButton
                          : L10n.of(context).goToChat,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
                onPressed: () => room.isSpace
                    ? context.push("/rooms/${room.id}/details")
                    : context.go("/rooms/${room.id}"),
              ),
            ),
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

  const _InviteContactListTile({
    required this.profile,
    this.user,
    required this.isMember,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // #Pangea
    // final theme = Theme.of(context);
    // Pangea#
    final l10n = L10n.of(context);

    return ListTile(
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
      // #Pangea
      // subtitle: Text(
      //   profile.userId,
      //   maxLines: 1,
      //   overflow: TextOverflow.ellipsis,
      //   style: TextStyle(
      //     color: theme.colorScheme.secondary,
      //   ),
      // ),
      subtitle: LevelDisplayName(userId: profile.userId),
      // Pangea#
      trailing: TextButton.icon(
        onPressed: isMember ? null : onTap,
        label: Text(isMember ? l10n.participant : l10n.invite),
        icon: Icon(isMember ? Icons.check : Icons.add),
      ),
    );
  }
}
