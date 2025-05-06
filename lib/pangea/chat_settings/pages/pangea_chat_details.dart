import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pages/chat_details/participant_list_item.dart';
import 'package:fluffychat/pangea/chat_settings/utils/download_chat.dart';
import 'package:fluffychat/pangea/chat_settings/utils/download_file.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/class_details_toggle_add_students_tile.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/class_name_header.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/conversation_bot/conversation_bot_settings.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/download_analytics_button.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/room_capacity_button.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/visibility_toggle.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PangeaChatDetailsView extends StatelessWidget {
  final ChatDetailsController controller;

  const PangeaChatDetailsView(this.controller, {super.key});

  void _downloadChat(BuildContext context) async {
    if (controller.roomId == null) return;
    final Room? room =
        Matrix.of(context).client.getRoomById(controller.roomId!);
    if (room == null) return;

    final type = await showModalActionPopup(
      context: context,
      title: L10n.of(context).downloadGroupText,
      actions: [
        AdaptiveModalAction(
          value: DownloadType.csv,
          label: L10n.of(context).downloadCSVFile,
        ),
        AdaptiveModalAction(
          value: DownloadType.txt,
          label: L10n.of(context).downloadTxtFile,
        ),
        AdaptiveModalAction(
          value: DownloadType.xlsx,
          label: L10n.of(context).downloadXLSXFile,
        ),
      ],
    );
    if (type == null) return;
    downloadChat(room, type, context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final room = Matrix.of(context).client.getRoomById(controller.roomId!);
    if (room == null || room.membership == Membership.leave) {
      return Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).oopsSomethingWentWrong),
        ),
        body: Center(
          child: Text(L10n.of(context).youAreNoLongerParticipatingInThisChat),
        ),
      );
    }

    final bool isGroupChat = !room.isDirectChat && !room.isSpace;

    return StreamBuilder(
      stream: room.client.onRoomState.stream
          .where((update) => update.roomId == room.id),
      builder: (context, snapshot) {
        var members = room.getParticipants().toList()
          ..sort((b, a) => a.powerLevel.compareTo(b.powerLevel));
        members = members.take(10).toList();
        final actualMembersCount = (room.summary.mInvitedMemberCount ?? 0) +
            (room.summary.mJoinedMemberCount ?? 0);
        final canRequestMoreMembers = members.length < actualMembersCount;
        final iconColor = theme.textTheme.bodyLarge!.color;
        final displayname = room.getLocalizedDisplayname(
          MatrixLocals(L10n.of(context)),
        );
        return Scaffold(
          appBar: AppBar(
            leading: controller.widget.embeddedCloseButton ??
                (room.isSpace && FluffyThemes.isColumnMode(context)
                    ? const SizedBox()
                    : const Center(child: BackButton())),
            elevation: theme.appBarTheme.elevation,
            title: ClassNameHeader(
              controller: controller,
              room: room,
            ),
            backgroundColor: theme.appBarTheme.backgroundColor,
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
                                  Hero(
                                    tag:
                                        controller.widget.embeddedCloseButton !=
                                                null
                                            ? 'embedded_content_banner'
                                            : 'content_banner',
                                    child: Avatar(
                                      mxContent: room.avatar,
                                      name: displayname,
                                      // #Pangea
                                      userId: room.directChatMatrixID,
                                      // Pangea#
                                      size: Avatar.defaultSize * 2.5,
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
                                      foregroundColor:
                                          theme.colorScheme.onSurface,
                                    ),
                                    label: Text(
                                      room.isDirectChat
                                          ? L10n.of(context).directChat
                                          : displayname,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 18),
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
                                      foregroundColor:
                                          theme.colorScheme.secondary,
                                    ),
                                    label: Text(
                                      L10n.of(context).countParticipants(
                                        actualMembersCount,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(color: theme.dividerColor, height: 1),
                        Stack(
                          children: [
                            if (room.isRoomAdmin)
                              Positioned(
                                right: 4,
                                top: 4,
                                child: IconButton(
                                  onPressed: controller.setTopicAction,
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 24.0,
                                right: 24.0,
                                top: 16.0,
                                bottom: 16.0,
                              ),
                              child: SelectableLinkify(
                                text: room.topic.isEmpty
                                    ? room.isSpace
                                        ? L10n.of(context).noSpaceDescriptionYet
                                        : L10n.of(context).noChatDescriptionYet
                                    : room.topic,
                                options: const LinkifyOptions(humanize: false),
                                linkStyle: const TextStyle(
                                  color: Colors.blueAccent,
                                  decorationColor: Colors.blueAccent,
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: room.topic.isEmpty
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                  color: theme.textTheme.bodyMedium!.color,
                                  decorationColor:
                                      theme.textTheme.bodyMedium!.color,
                                ),
                                onOpen: (url) =>
                                    UrlLauncher(context, url.url).launchUrl(),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: theme.dividerColor, height: 1),
                        if (isGroupChat && room.canInvite)
                          ConversationBotSettings(
                            key: controller.addConversationBotKey,
                            room: room,
                          ),
                        if (isGroupChat && room.canInvite)
                          Divider(color: theme.dividerColor, height: 1),
                        if (room.canInvite && !room.isDirectChat)
                          ListTile(
                            title: Text(
                              L10n.of(context).inviteStudentByUserName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              child: const Icon(
                                Icons.person_add_outlined,
                              ),
                            ),
                            onTap: () =>
                                context.push('/rooms/${room.id}/invite'),
                          ),
                        if (room.canInvite && !room.isDirectChat)
                          Divider(color: theme.dividerColor, height: 1),
                        if (room.isSpace && room.isRoomAdmin)
                          SpaceDetailsToggleAddStudentsTile(
                            controller: controller,
                          ),
                        if (room.isSpace && room.isRoomAdmin)
                          Divider(color: theme.dividerColor, height: 1),
                        if (isGroupChat && room.isRoomAdmin)
                          ListTile(
                            title: Text(
                              L10n.of(context).editChatPermissions,
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              L10n.of(context).whoCanPerformWhichAction,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: theme.scaffoldBackgroundColor,
                              foregroundColor: iconColor,
                              child: const Icon(
                                Icons.manage_accounts_outlined,
                              ),
                            ),
                            onTap: () => context.push(
                              '/rooms/${room.id}/details/permissions',
                            ),
                          ),
                        if (isGroupChat && room.isRoomAdmin)
                          Divider(color: theme.dividerColor, height: 1),
                        if (room.isRoomAdmin &&
                            room.isSpace &&
                            room.spaceParents.isEmpty)
                          VisibilityToggle(
                            room: room,
                            setVisibility: controller.setVisibility,
                            setJoinRules: controller.setJoinRules,
                            iconColor: iconColor,
                          ),
                        if (room.isRoomAdmin &&
                            room.isSpace &&
                            room.spaceParents.isEmpty)
                          Divider(color: theme.dividerColor, height: 1),
                        if (!room.isSpace && !room.isDirectChat)
                          RoomCapacityButton(
                            room: room,
                            controller: controller,
                          ),
                        if (room.isSpace && room.isRoomAdmin && kIsWeb)
                          DownloadAnalyticsButton(space: room),
                        Divider(color: theme.dividerColor, height: 1),
                        if (room.isRoomAdmin && !room.isSpace)
                          ListTile(
                            title: Text(
                              L10n.of(context).downloadGroupText,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: iconColor,
                              child: const Icon(
                                Icons.download_outlined,
                              ),
                            ),
                            onTap: () => _downloadChat(context),
                          ),
                        if (room.isRoomAdmin && !room.isSpace)
                          Divider(color: theme.dividerColor, height: 1),
                        if (isGroupChat)
                          ListTile(
                            title: Text(
                              room.pushRuleState == PushRuleState.notify
                                  ? L10n.of(context).notificationsOn
                                  : L10n.of(context).notificationsOff,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              foregroundColor: iconColor,
                              child: Icon(
                                room.pushRuleState == PushRuleState.notify
                                    ? Icons.notifications_on_outlined
                                    : Icons.notifications_off_outlined,
                              ),
                            ),
                            onTap: controller.toggleMute,
                          ),
                        if (isGroupChat)
                          Divider(color: theme.dividerColor, height: 1),
                        ListTile(
                          title: Text(
                            L10n.of(context).leave,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            foregroundColor: iconColor,
                            child: const Icon(
                              Icons.logout_outlined,
                            ),
                          ),
                          onTap: () async {
                            final confirmed = await showOkCancelAlertDialog(
                              useRootNavigator: false,
                              context: context,
                              title: L10n.of(context).areYouSure,
                              okLabel: L10n.of(context).leave,
                              cancelLabel: L10n.of(context).no,
                              message: room.isSpace
                                  ? L10n.of(context).leaveSpaceDescription
                                  : L10n.of(context).leaveRoomDescription,
                              isDestructive: true,
                            );
                            if (confirmed != OkCancelResult.ok) return;
                            final resp = await showFutureLoadingDialog(
                              context: context,
                              future:
                                  room.isSpace ? room.leaveSpace : room.leave,
                            );
                            if (!resp.isError) {
                              MatrixState.pangeaController.classController
                                  .setActiveSpaceIdInChatListController(null);
                            }
                          },
                        ),
                        Divider(color: theme.dividerColor, height: 1),
                        ListTile(
                          title: Text(
                            L10n.of(context).countParticipants(
                              actualMembersCount,
                            ),
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  : i < members.length + 1
                      ? ParticipantListItem(members[i - 1])
                      : ListTile(
                          title: Text(
                            L10n.of(context).loadCountMoreParticipants(
                              (actualMembersCount - members.length),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: theme.scaffoldBackgroundColor,
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
