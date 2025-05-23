import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pages/chat_details/participant_list_item.dart';
import 'package:fluffychat/pangea/analytics_misc/level_display_name.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/chat_settings/models/bot_options_model.dart';
import 'package:fluffychat/pangea/chat_settings/utils/delete_room.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/conversation_bot/conversation_bot_settings.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/delete_space_dialog.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/utils/load_participants_util.dart';
import 'package:fluffychat/pangea/spaces/widgets/download_space_analytics_dialog.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/user_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PangeaChatDetailsView extends StatelessWidget {
  final ChatDetailsController controller;

  const PangeaChatDetailsView(this.controller, {super.key});

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

    return StreamBuilder(
      stream: room.client.onRoomState.stream
          .where((update) => update.roomId == room.id),
      builder: (context, snapshot) {
        var members = room.getParticipants().toList()
          ..sort((b, a) => a.powerLevel.compareTo(b.powerLevel));
        members = members.take(10).toList();
        final actualMembersCount = (room.summary.mInvitedMemberCount ?? 0) +
            (room.summary.mJoinedMemberCount ?? 0);
        final displayname = room.getLocalizedDisplayname(
          MatrixLocals(L10n.of(context)),
        );
        return Scaffold(
          appBar: AppBar(
            leading: controller.widget.embeddedCloseButton ??
                (room.isSpace
                    ? FluffyThemes.isColumnMode(context)
                        ? const SizedBox()
                        : BackButton(
                            onPressed: () =>
                                context.go("/rooms?spaceId=${room.id}"),
                          )
                    : const Center(child: BackButton())),
          ),
          body: MaxWidthBody(
            maxWidth: 800,
            showBorder: false,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 2,
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
                                      userId: room.directChatMatrixID,
                                      size: Avatar.defaultSize * 2.5,
                                      borderRadius: room.isSpace
                                          ? BorderRadius.circular(24.0)
                                          : null,
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
                                left: 32.0,
                                right: 32.0,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: RoomDetailsButtonRow(
                            controller: controller,
                            room: room,
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RoomParticipantsSection(room: room),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class RoomDetailsButtonRow extends StatefulWidget {
  final ChatDetailsController controller;
  final Room room;

  const RoomDetailsButtonRow({
    super.key,
    required this.controller,
    required this.room,
  });

  @override
  State<RoomDetailsButtonRow> createState() => RoomDetailsButtonRowState();
}

class RoomDetailsButtonRowState extends State<RoomDetailsButtonRow> {
  StreamSubscription? notificationChangeSub;

  @override
  void initState() {
    super.initState();
    notificationChangeSub ??= Matrix.of(context)
        .client
        .onSync
        .stream
        .where(
          (syncUpdate) =>
              syncUpdate.accountData?.any(
                (accountData) => accountData.type == 'm.push_rules',
              ) ??
              false,
        )
        .listen(
          (u) => setState(() {}),
        );
  }

  @override
  void dispose() {
    notificationChangeSub?.cancel();
    super.dispose();
  }

  final double _buttonWidth = 120.0;
  final double _buttonHeight = 70.0;
  final double _miniButtonWidth = 50.0;

  Room get room => widget.room;

  List<ButtonDetails> _buttons(BuildContext context) {
    final L10n l10n = L10n.of(context);
    return [
      ButtonDetails(
        title: l10n.activities,
        icon: const Icon(Icons.event_note_outlined),
        onPressed: () => context.go("/rooms/${room.id}/details/planner"),
        visible: room.canSendDefaultStates || room.isSpace,
        enabled: room.canSendDefaultStates,
      ),
      ButtonDetails(
        title: l10n.permissions,
        icon: const Icon(Icons.edit_attributes_outlined),
        onPressed: () => context.go('/rooms/${room.id}/details/permissions'),
        visible: (room.isRoomAdmin && !room.isDirectChat) || room.isSpace,
        enabled: room.isRoomAdmin && !room.isDirectChat,
      ),
      ButtonDetails(
        title: l10n.access,
        icon: const Icon(Icons.shield_outlined),
        onPressed: () => context.go('/rooms/${room.id}/details/access'),
        visible: room.isSpace,
        enabled: room.isSpace && room.isRoomAdmin,
      ),
      ButtonDetails(
        title: room.pushRuleState == PushRuleState.notify
            ? l10n.notificationsOn
            : l10n.notificationsOff,
        icon: Icon(
          room.pushRuleState == PushRuleState.notify
              ? Icons.notifications_on_outlined
              : Icons.notifications_off_outlined,
        ),
        onPressed: () => showFutureLoadingDialog(
          context: context,
          future: () => room.setPushRuleState(
            room.pushRuleState == PushRuleState.notify
                ? PushRuleState.mentionsOnly
                : PushRuleState.notify,
          ),
        ),
        visible: !room.isSpace,
      ),
      ButtonDetails(
        title: l10n.invite,
        icon: const Icon(Icons.person_add_outlined),
        onPressed: () => context.go('/rooms/${room.id}/details/invite'),
        visible: (room.canInvite && !room.isDirectChat) || room.isSpace,
        enabled: room.canInvite && !room.isDirectChat,
      ),
      ButtonDetails(
        title: l10n.addSubspace,
        icon: const Icon(Icons.add_outlined),
        onPressed: widget.controller.addSubspace,
        visible: room.isSpace &&
            room.canSendEvent(
              EventTypes.SpaceChild,
            ),
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.downloadSpaceAnalytics,
        icon: const Icon(Icons.download_outlined),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => DownloadAnalyticsDialog(space: room),
          );
        },
        visible: room.isSpace && room.isRoomAdmin,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.download,
        icon: const Icon(Icons.download_outlined),
        onPressed: widget.controller.downloadChatAction,
        visible: room.ownPowerLevel >= 50 && !room.isSpace,
      ),
      ButtonDetails(
        title: l10n.botSettings,
        icon: const BotFace(
          width: 30.0,
          expression: BotExpression.idle,
        ),
        onPressed: () => showDialog<BotOptionsModel?>(
          context: context,
          builder: (BuildContext context) => ConversationBotSettingsDialog(
            room: room,
            onSubmit: widget.controller.setBotOptions,
          ),
        ),
        visible: !room.isSpace && !room.isDirectChat && room.canInvite,
      ),
      ButtonDetails(
        title: l10n.chatCapacity,
        icon: const Icon(Icons.reduce_capacity),
        onPressed: widget.controller.setRoomCapacity,
        visible:
            !room.isSpace && !room.isDirectChat && room.canSendDefaultStates,
      ),
      ButtonDetails(
        title: l10n.leave,
        icon: const Icon(Icons.logout_outlined),
        onPressed: () async {
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
            future: room.isSpace ? room.leaveSpace : room.leave,
          );
          if (!resp.isError) {
            context.go("/rooms?spaceId=clear");
          }
        },
        visible: room.membership == Membership.join,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.delete,
        icon: const Icon(Icons.delete_outline),
        onPressed: () async {
          if (room.isSpace) {
            final resp = await showDialog<bool?>(
              context: context,
              builder: (_) => DeleteSpaceDialog(space: room),
            );

            if (resp == true) {
              context.go("/rooms?spaceId=clear");
            }
          } else {
            final confirmed = await showOkCancelAlertDialog(
              context: context,
              title: L10n.of(context).areYouSure,
              okLabel: L10n.of(context).delete,
              cancelLabel: L10n.of(context).cancel,
              isDestructive: true,
              message: room.isSpace
                  ? L10n.of(context).deleteSpaceDesc
                  : L10n.of(context).deleteChatDesc,
            );
            if (confirmed != OkCancelResult.ok) return;

            final resp = await showFutureLoadingDialog(
              context: context,
              future: room.delete,
            );
            if (resp.isError) return;
            context.go("/rooms?spaceId=clear");
          }
        },
        visible: room.isRoomAdmin,
        showInMainView: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final buttons = _buttons(context)
        .where(
          (button) => button.visible,
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final fullButtonCapacity =
              (availableWidth / _buttonWidth).floor() - 1;
          final miniButtonCapacity =
              (availableWidth / _miniButtonWidth).floor() - 1;

          final mini = fullButtonCapacity < 4;
          final capacity = mini ? miniButtonCapacity : fullButtonCapacity;

          List<ButtonDetails> mainViewButtons =
              buttons.where((button) => button.showInMainView).toList();
          final List<ButtonDetails> otherButtons =
              buttons.where((button) => !button.showInMainView).toList();

          if (capacity < mainViewButtons.length) {
            otherButtons.addAll(mainViewButtons.skip(capacity));
            mainViewButtons = mainViewButtons.take(capacity).toList();
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(mainViewButtons.length + 1, (index) {
              if (index == mainViewButtons.length) {
                if (otherButtons.isEmpty) {
                  return const SizedBox();
                }

                return PopupMenuButton(
                  onSelected: (button) => button.onPressed?.call(),
                  itemBuilder: (context) {
                    return otherButtons
                        .map(
                          (button) => PopupMenuItem(
                            value: button,
                            child: Row(
                              children: [
                                button.icon,
                                const SizedBox(width: 8),
                                Text(button.title),
                              ],
                            ),
                          ),
                        )
                        .toList();
                  },
                  child: RoomDetailsButton(
                    mini: mini,
                    buttonDetails: ButtonDetails(
                      title: L10n.of(context).more,
                      icon: const Icon(Icons.more_horiz_outlined),
                      visible: true,
                    ),
                    width: mini ? _miniButtonWidth : _buttonWidth,
                    height: mini ? _miniButtonWidth : _buttonHeight,
                  ),
                );
              }

              final button = buttons[index];
              return RoomDetailsButton(
                mini: mini,
                buttonDetails: button,
                width: mini ? _miniButtonWidth : _buttonWidth,
                height: mini ? _miniButtonWidth : _buttonHeight,
              );
            }),
          );
        },
      ),
    );
  }
}

class RoomDetailsButton extends StatelessWidget {
  final bool mini;
  // final bool visible;
  // final bool enabled;

  // final String title;
  // final Widget icon;
  // final VoidCallback? onPressed;

  final double width;
  final double height;

  final ButtonDetails buttonDetails;

  const RoomDetailsButton({
    super.key,
    required this.buttonDetails,
    // required this.visible,
    // required this.title,
    // required this.icon,
    required this.mini,
    required this.width,
    required this.height,
    // this.enabled = true,
    // this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!buttonDetails.visible) {
      return const SizedBox();
    }

    return AbsorbPointer(
      absorbing: !buttonDetails.enabled,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: HoverBuilder(
          builder: (context, hovered) {
            return GestureDetector(
              onTap: buttonDetails.onPressed,
              child: Opacity(
                opacity: buttonDetails.enabled ? 1.0 : 0.5,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: hovered
                        ? Theme.of(context).colorScheme.primary.withAlpha(50)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: mini
                      ? buttonDetails.icon
                      : Column(
                          spacing: 8.0,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buttonDetails.icon,
                            Text(
                              buttonDetails.title,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ButtonDetails {
  final String title;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool visible;
  final bool enabled;
  final bool showInMainView;

  const ButtonDetails({
    required this.title,
    required this.icon,
    required this.visible,
    this.onPressed,
    this.enabled = true,
    this.showInMainView = true,
  });
}

class RoomParticipantsSection extends StatelessWidget {
  final Room room;

  const RoomParticipantsSection({
    required this.room,
    super.key,
  });

  final double _width = 80.0;
  final double _padding = 12.0;

  double get _fullWidth => _width + (_padding * 2);

  @override
  Widget build(BuildContext context) {
    final List<User> members = room.getParticipants().toList()
      ..sort((b, a) => a.powerLevel.compareTo(b.powerLevel));

    final actualMembersCount = (room.summary.mInvitedMemberCount ?? 0) +
        (room.summary.mJoinedMemberCount ?? 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final capacity = (availableWidth / _fullWidth).floor();

        if (capacity < 4) {
          return Column(
            children: [
              ...members.map((member) => ParticipantListItem(member)),
              if (actualMembersCount - members.length > 0)
                ListTile(
                  title: Text(
                    L10n.of(context).loadCountMoreParticipants(
                      (actualMembersCount - members.length),
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: const Icon(
                      Icons.group_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () => context.push(
                    '/rooms/${room.id}/details/members',
                  ),
                  trailing: const Icon(Icons.chevron_right_outlined),
                ),
            ],
          );
        }

        return LoadParticipantsUtil(
          space: room,
          builder: (participantsLoader) {
            final filteredParticipants =
                participantsLoader.filteredParticipants("");
            return Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                ...filteredParticipants.mapIndexed((index, user) {
                  Color? color = index == 0
                      ? AppConfig.gold
                      : index == 1
                          ? Colors.grey[400]!
                          : index == 2
                              ? Colors.brown[400]!
                              : null;

                  final publicProfile = participantsLoader.getPublicProfile(
                    user.id,
                  );

                  if (user.id == BotName.byEnvironment ||
                      publicProfile == null ||
                      publicProfile.level == null) {
                    color = null;
                  }

                  return Padding(
                    padding: EdgeInsets.all(_padding),
                    child: SizedBox(
                      width: _width,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              if (color != null)
                                CircleAvatar(
                                  radius: _width / 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: const Alignment(0.5, -0.5),
                                        end: const Alignment(-0.5, 0.5),
                                        colors: <Color>[
                                          color,
                                          Colors.white,
                                          color,
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  height: _width,
                                  width: _width,
                                ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => UserDialog.show(
                                    context: context,
                                    profile: Profile(
                                      userId: user.id,
                                      displayName: user.displayName,
                                      avatarUrl: user.avatarUrl,
                                    ),
                                  ),
                                  child: Center(
                                    child: Avatar(
                                      mxContent: user.avatarUrl,
                                      name: user.calcDisplayname(),
                                      size: _width - 6.0,
                                      presenceUserId: user.id,
                                      showPresence: false,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            user.calcDisplayname(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          LevelDisplayName(
                            userId: user.id,
                            textStyle: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
