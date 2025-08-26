import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/chat_settings/pages/room_details_buttons.dart';
import 'package:fluffychat/pangea/chat_settings/pages/room_participants_widget.dart';
import 'package:fluffychat/pangea/chat_settings/pages/space_details_button_row.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/delete_space_dialog.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/course_chats/course_chats_page.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_settings/course_settings.dart';
import 'package:fluffychat/pangea/courses/course_plan_builder.dart';
import 'package:fluffychat/pangea/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

enum SpaceSettingsTabs {
  chat,
  course,
  participants,
  analytics,
  more,
}

class SpaceDetailsContent extends StatefulWidget {
  final ChatDetailsController controller;
  final Room room;

  const SpaceDetailsContent(this.controller, this.room, {super.key});

  @override
  State<SpaceDetailsContent> createState() => SpaceDetailsContentState();
}

class SpaceDetailsContentState extends State<SpaceDetailsContent> {
  SpaceSettingsTabs? _selectedTab;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(
        () => _selectedTab = FluffyThemes.isColumnMode(context)
            ? SpaceSettingsTabs.course
            : SpaceSettingsTabs.chat,
      );
    });
  }

  @override
  void didUpdateWidget(covariant SpaceDetailsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.room.id != widget.room.id) {
      setState(() {
        _selectedTab = FluffyThemes.isColumnMode(context)
            ? SpaceSettingsTabs.course
            : SpaceSettingsTabs.chat;
      });
    }
  }

  void setSelectedTab(SpaceSettingsTabs tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  List<ButtonDetails> get _buttons {
    final L10n l10n = L10n.of(context);
    return [
      ButtonDetails(
        title: l10n.chats,
        icon: const Icon(Icons.chat_bubble_outline, size: 30.0),
        onPressed: () => setSelectedTab(SpaceSettingsTabs.chat),
        visible: !FluffyThemes.isColumnMode(context),
        tab: SpaceSettingsTabs.chat,
      ),
      ButtonDetails(
        title: l10n.coursePlan,
        icon: const Icon(Icons.map_outlined, size: 30.0),
        onPressed: () => setSelectedTab(SpaceSettingsTabs.course),
        tab: SpaceSettingsTabs.course,
      ),
      ButtonDetails(
        title: l10n.participants,
        icon: const Icon(Icons.group_outlined, size: 30.0),
        onPressed: () => setSelectedTab(SpaceSettingsTabs.participants),
        tab: SpaceSettingsTabs.participants,
      ),
      ButtonDetails(
        title: l10n.stats,
        icon: const Icon(Symbols.bar_chart_4_bars, size: 30.0),
        onPressed: () => setSelectedTab(SpaceSettingsTabs.analytics),
        enabled: widget.room.isRoomAdmin,
        tab: SpaceSettingsTabs.analytics,
      ),
      ButtonDetails(
        title: l10n.invite,
        description: l10n.inviteDesc,
        icon: const Icon(Icons.person_add_outlined, size: 30.0),
        onPressed: () {
          String filter = 'knocking';
          if (widget.room.getParticipants([Membership.knock]).isEmpty) {
            filter = widget.room.pangeaSpaceParents.isNotEmpty
                ? 'space'
                : 'contacts';
          }
          context.go('/rooms/${widget.room.id}/details/invite?filter=$filter');
        },
        enabled: widget.room.canInvite && !widget.room.isDirectChat,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.editCourse,
        description: l10n.editCourseDesc,
        icon: const Icon(Icons.edit_outlined, size: 30.0),
        onPressed: () {},
        visible: false,
        enabled: widget.room.canChangeStateEvent(PangeaEventTypes.coursePlan),
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.permissions,
        description: l10n.permissionsDesc,
        icon: const Icon(Icons.edit_attributes_outlined, size: 30.0),
        onPressed: () =>
            context.go('/rooms/${widget.room.id}/details/permissions'),
        enabled: widget.room.isRoomAdmin && !widget.room.isDirectChat,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.access,
        description: l10n.accessDesc,
        icon: const Icon(Icons.shield_outlined, size: 30.0),
        onPressed: () => context.go('/rooms/${widget.room.id}/details/access'),
        enabled: widget.room.isRoomAdmin && widget.room.spaceParents.isEmpty,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.createGroupChat,
        description: l10n.createGroupChatDesc,
        icon: const Icon(Symbols.chat_add_on, size: 30.0),
        onPressed: widget.controller.addGroupChat,
        enabled: widget.room.isRoomAdmin &&
            widget.room.canChangeStateEvent(
              EventTypes.SpaceChild,
            ),
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.leave,
        icon: const Icon(Icons.logout_outlined, size: 30.0),
        onPressed: () async {
          final confirmed = await showOkCancelAlertDialog(
            useRootNavigator: false,
            context: context,
            title: L10n.of(context).areYouSure,
            okLabel: L10n.of(context).leave,
            cancelLabel: L10n.of(context).no,
            message: L10n.of(context).leaveSpaceDescription,
            isDestructive: true,
          );
          if (confirmed != OkCancelResult.ok) return;
          final resp = await showFutureLoadingDialog(
            context: context,
            future: widget.room.leaveSpace,
          );
          if (!resp.isError) {
            context.go("/rooms");
          }
        },
        enabled: widget.room.membership == Membership.join,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.delete,
        description: l10n.deleteDesc,
        icon: const Icon(
          Icons.delete_outline,
          size: 30.0,
        ),
        onPressed: () async {
          final resp = await showDialog<bool?>(
            context: context,
            builder: (_) => DeleteSpaceDialog(space: widget.room),
          );

          if (resp == true) {
            context.go("/rooms");
          }
        },
        enabled: widget.room.isRoomAdmin && !widget.room.isDirectChat,
        showInMainView: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);
    final displayname = widget.room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(context)),
    );
    return CoursePlanBuilder(
      courseId: widget.room.coursePlan?.uuid,
      builder: (context, courseController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: isColumnMode
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isColumnMode) ...[
                  Avatar(
                    mxContent: widget.room.avatar,
                    name: displayname,
                    userId: widget.room.directChatMatrixID,
                    size: 80.0,
                    borderRadius: widget.room.isSpace
                        ? BorderRadius.circular(24.0)
                        : null,
                  ),
                  const SizedBox(width: 16.0),
                ],
                Flexible(
                  child: Column(
                    spacing: 12.0,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayname,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isColumnMode ? 32.0 : 12.0,
                        ),
                      ),
                      if (isColumnMode && courseController.course != null)
                        CourseInfoChips(
                          courseController.course!,
                          fontSize: 12.0,
                          iconSize: 12.0,
                        ),
                    ],
                  ),
                ),
                if (widget.room.classCode != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: PopupMenuButton(
                      child: const Icon(Symbols.upload),
                      onSelected: (value) async {
                        final spaceCode = widget.room.classCode!;
                        String toCopy = spaceCode;
                        if (value == 0) {
                          final String initialUrl = kIsWeb
                              ? html.window.origin!
                              : Environment.frontendURL;
                          toCopy =
                              "$initialUrl/#/join_with_link?${SpaceConstants.classCode}=${widget.room.classCode}";
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
                            title: Text(L10n.of(context).shareSpaceLink),
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: ListTile(
                            title: Text(
                              L10n.of(context)
                                  .shareInviteCode(widget.room.classCode!),
                            ),
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: isColumnMode ? 24.0 : 12.0),
            SpaceDetailsButtonRow(
              controller: widget.controller,
              room: widget.room,
              selectedTab: _selectedTab,
              onTabSelected: setSelectedTab,
              buttons: _buttons,
            ),
            SizedBox(height: isColumnMode ? 30.0 : 14.0),
            Expanded(
              child: Builder(
                builder: (context) {
                  switch (_selectedTab) {
                    case SpaceSettingsTabs.chat:
                      return CourseChats(
                        widget.room.id,
                        activeChat: null,
                        client: widget.room.client,
                      );
                    case SpaceSettingsTabs.course:
                      return SingleChildScrollView(
                        child: CourseSettings(
                          courseController,
                          room: widget.room,
                        ),
                      );
                    case SpaceSettingsTabs.participants:
                      return SingleChildScrollView(
                        child: RoomParticipantsSection(room: widget.room),
                      );
                    case SpaceSettingsTabs.analytics:
                      return SingleChildScrollView(
                        child: Center(
                          child: SpaceAnalytics(roomId: widget.room.id),
                        ),
                      );
                    case SpaceSettingsTabs.more:
                      final buttons = _buttons
                          .where(
                            (b) => !b.showInMainView && b.visible,
                          )
                          .toList();

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            if (courseController.course != null) ...[
                              Text(
                                courseController.course!.description,
                                style: TextStyle(
                                  fontSize: isColumnMode ? 16.0 : 12.0,
                                ),
                              ),
                              SizedBox(height: isColumnMode ? 30.0 : 14.0),
                            ],
                            Column(
                              spacing: 10.0,
                              mainAxisSize: MainAxisSize.min,
                              children: buttons.map((b) {
                                return Opacity(
                                  opacity: b.enabled ? 1.0 : 0.5,
                                  child: ListTile(
                                    title: Text(
                                      b.title,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    subtitle: b.description != null
                                        ? Text(
                                            b.description!,
                                            style: const TextStyle(
                                              fontSize: 8.0,
                                            ),
                                          )
                                        : null,
                                    leading: b.icon,
                                    onTap: b.enabled
                                        ? () {
                                            b.onPressed?.call();
                                          }
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    case null:
                      return const SizedBox();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
