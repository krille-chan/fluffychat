import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pages/chat_details/participant_list_item.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/chat_settings_popup_menu.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ChatDetailsView extends StatelessWidget {
  final ChatDetailsController controller;

  const ChatDetailsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final room = Matrix.of(context).client.getRoomById(controller.roomId!);
    if (room == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context)!.oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context)!.youAreNoLongerParticipatingInThisChat),
        ),
      );
    }

    final isEmbedded = GoRouterState.of(context).fullPath == '/rooms/:roomid';

    return StreamBuilder(
      stream: room.onUpdate.stream,
      builder: (context, snapshot) {
        var members = room.getParticipants().toList()
          ..sort((b, a) => a.powerLevel.compareTo(b.powerLevel));
        members = members.take(10).toList();
        final actualMembersCount = (room.summary.mInvitedMemberCount ?? 0) +
            (room.summary.mJoinedMemberCount ?? 0);
        final canRequestMoreMembers = members.length < actualMembersCount;
        final iconColor = Theme.of(context).textTheme.bodyLarge!.color;
        final displayname = room.getLocalizedDisplayname(
          MatrixLocals(L10n.of(context)!),
        );
        return Scaffold(
          appBar: isEmbedded
              ? null
              : AppBar(
                  leading: const Center(child: BackButton()),
                  elevation: Theme.of(context).appBarTheme.elevation,
                  actions: <Widget>[
                    if (room.canonicalAlias.isNotEmpty)
                      IconButton(
                        tooltip: L10n.of(context)!.share,
                        icon: Icon(Icons.adaptive.share_outlined),
                        onPressed: () => FluffyShare.share(
                          AppConfig.inviteLinkPrefix + room.canonicalAlias,
                          context,
                        ),
                      ),
                    ChatSettingsPopupMenu(room, false),
                  ],
                  title: Text(L10n.of(context)!.chatDetails),
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                ),
          body: MaxWidthBody(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: members.length + 1 + (canRequestMoreMembers ? 1 : 0),
              itemBuilder: (BuildContext context, int i) => i == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Stack(
                                children: [
                                  Material(
                                    elevation: Theme.of(context)
                                            .appBarTheme
                                            .scrolledUnderElevation ??
                                        4,
                                    shadowColor: Theme.of(context)
                                        .appBarTheme
                                        .shadowColor,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Avatar.defaultSize * 2.5,
                                      ),
                                    ),
                                    child: Hero(
                                      tag: isEmbedded
                                          ? 'embedded_content_banner'
                                          : 'content_banner',
                                      child: Avatar(
                                        mxContent: room.avatar,
                                        name: displayname,
                                        size: Avatar.defaultSize * 2.5,
                                        fontSize: 18 * 2.5,
                                      ),
                                    ),
                                  ),
                                  if (!room.isDirectChat &&
                                      room.canChangeStateEvent(
                                        EventTypes.RoomAvatar,
                                      ))
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: FloatingActionButton.small(
                                        onPressed: controller.setAvatarAction,
                                        heroTag: null,
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => room.isDirectChat
                                        ? null
                                        : room.canChangeStateEvent(
                                            EventTypes.RoomName,
                                          )
                                            ? controller.setDisplaynameAction()
                                            : FluffyShare.share(
                                                displayname,
                                                context,
                                                copyOnly: true,
                                              ),
                                    icon: Icon(
                                      room.isDirectChat
                                          ? Icons.chat_bubble_outline
                                          : room.canChangeStateEvent(
                                              EventTypes.RoomName,
                                            )
                                              ? Icons.edit_outlined
                                              : Icons.copy_outlined,
                                      size: 16,
                                    ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    label: Text(
                                      room.isDirectChat
                                          ? L10n.of(context)!.directChat
                                          : displayname,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      //  style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => room.isDirectChat
                                        ? null
                                        : context.push(
                                            '/rooms/${controller.roomId}/details/members',
                                          ),
                                    icon: const Icon(
                                      Icons.group_outlined,
                                      size: 14,
                                    ),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    label: Text(
                                      L10n.of(context)!.countParticipants(
                                        actualMembersCount,
                                      ),
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
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        if (!room.canChangeStateEvent(EventTypes.RoomTopic))
                          ListTile(
                            title: Text(
                              L10n.of(context)!.chatDescription,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: OutlinedButton.icon(
                              onPressed: controller.setTopicAction,
                              label: Text(L10n.of(context)!.setChatDescription),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: SelectableLinkify(
                            text: room.topic.isEmpty
                                ? L10n.of(context)!.noChatDescriptionYet
                                : room.topic,
                            options: const LinkifyOptions(humanize: false),
                            linkStyle:
                                const TextStyle(color: Colors.blueAccent),
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: room.topic.isEmpty
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                              decorationColor:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            onOpen: (url) =>
                                UrlLauncher(context, url.url).launchUrl(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        if (room.joinRules == JoinRules.public)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: iconColor,
                              child: const Icon(Icons.link_outlined),
                            ),
                            trailing: const Icon(Icons.chevron_right_outlined),
                            onTap: controller.editAliases,
                            title: Text(L10n.of(context)!.editRoomAliases),
                            subtitle: Text(
                              (room.canonicalAlias.isNotEmpty)
                                  ? room.canonicalAlias
                                  : L10n.of(context)!.none,
                            ),
                          ),
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            foregroundColor: iconColor,
                            child: const Icon(
                              Icons.insert_emoticon_outlined,
                            ),
                          ),
                          title: Text(L10n.of(context)!.emoteSettings),
                          subtitle: Text(L10n.of(context)!.setCustomEmotes),
                          onTap: controller.goToEmoteSettings,
                          trailing: const Icon(Icons.chevron_right_outlined),
                        ),
                        if (!room.isDirectChat)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: iconColor,
                              child: const Icon(Icons.shield_outlined),
                            ),
                            title: Text(
                              L10n.of(context)!.whoIsAllowedToJoinThisGroup,
                            ),
                            trailing: room.canChangeJoinRules
                                ? const Icon(Icons.chevron_right_outlined)
                                : null,
                            subtitle: Text(
                              room.joinRules?.getLocalizedString(
                                    MatrixLocals(L10n.of(context)!),
                                  ) ??
                                  L10n.of(context)!.none,
                            ),
                            onTap: room.canChangeJoinRules
                                ? controller.setJoinRules
                                : null,
                          ),
                        if (!room.isDirectChat)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: iconColor,
                              child: const Icon(Icons.visibility_outlined),
                            ),
                            trailing: room.canChangeHistoryVisibility
                                ? const Icon(Icons.chevron_right_outlined)
                                : null,
                            title: Text(
                              L10n.of(context)!.visibilityOfTheChatHistory,
                            ),
                            subtitle: Text(
                              room.historyVisibility?.getLocalizedString(
                                    MatrixLocals(L10n.of(context)!),
                                  ) ??
                                  L10n.of(context)!.none,
                            ),
                            onTap: room.canChangeHistoryVisibility
                                ? controller.setHistoryVisibility
                                : null,
                          ),
                        if (room.joinRules == JoinRules.public)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: iconColor,
                              child: const Icon(
                                Icons.person_add_alt_1_outlined,
                              ),
                            ),
                            trailing: room.canChangeGuestAccess
                                ? const Icon(Icons.chevron_right_outlined)
                                : null,
                            title: Text(
                              L10n.of(context)!.areGuestsAllowedToJoin,
                            ),
                            subtitle: Text(
                              room.guestAccess.getLocalizedString(
                                MatrixLocals(L10n.of(context)!),
                              ),
                            ),
                            onTap: room.canChangeGuestAccess
                                ? controller.setGuestAccess
                                : null,
                          ),
                        if (!room.isDirectChat)
                          ListTile(
                            title: Text(L10n.of(context)!.chatPermissions),
                            subtitle: Text(
                              L10n.of(context)!.whoCanPerformWhichAction,
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: iconColor,
                              child: const Icon(
                                Icons.edit_attributes_outlined,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right_outlined),
                            onTap: () => context
                                .push('/rooms/${room.id}/details/permissions'),
                          ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                        ListTile(
                          title: Text(
                            L10n.of(context)!.countParticipants(
                              actualMembersCount.toString(),
                            ),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!room.isDirectChat && room.canInvite)
                          ListTile(
                            title: Text(L10n.of(context)!.inviteContact),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              radius: Avatar.defaultSize / 2,
                              child: const Icon(Icons.add_outlined),
                            ),
                            trailing: const Icon(Icons.chevron_right_outlined),
                            onTap: () => context.go('/rooms/${room.id}/invite'),
                          ),
                      ],
                    )
                  : i < members.length + 1
                      ? ParticipantListItem(members[i - 1])
                      : ListTile(
                          title: Text(
                            L10n.of(context)!.loadCountMoreParticipants(
                              (actualMembersCount - members.length).toString(),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: const Icon(
                              Icons.group_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          onTap: () => context.push(
                            '/rooms/${controller.roomId!}/details/members',
                          ),
                          trailing: const Icon(Icons.chevron_right_outlined),
                        ),
            ),
          ),
        );
      },
    );
  }
}
