import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/chat_settings/pages/room_details_buttons.dart';
import 'package:fluffychat/pangea/chat_settings/pages/room_participants_widget.dart';
import 'package:fluffychat/pangea/chat_settings/pages/space_details_button_row.dart';
import 'package:fluffychat/pangea/chat_settings/widgets/delete_space_dialog.dart';
import 'package:fluffychat/pangea/common/widgets/share_room_button.dart';
import 'package:fluffychat/pangea/course_chats/course_chats_page.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/course_plans/map_clipper.dart';
import 'package:fluffychat/pangea/course_settings/course_settings.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/space_analytics/space_analytics.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

enum SpaceSettingsTabs {
  chat,
  course,
  participants,
  analytics,
  more;

  static SpaceSettingsTabs? fromString(String value) {
    return SpaceSettingsTabs.values.firstWhereOrNull(
      (e) => e.name == value,
    );
  }
}

class SpaceDetailsContent extends StatelessWidget {
  final ChatDetailsController controller;
  final Room room;

  const SpaceDetailsContent(
    this.controller,
    this.room, {
    super.key,
  });

  SpaceSettingsTabs tab(BuildContext context) {
    final defaultTab = FluffyThemes.isColumnMode(context)
        ? SpaceSettingsTabs.course
        : SpaceSettingsTabs.chat;

    final activeTab = controller.widget.activeTab;
    if (activeTab != null) {
      final selectedTab = SpaceSettingsTabs.fromString(activeTab);
      return selectedTab ?? defaultTab;
    }

    return defaultTab;
  }

  void setSelectedTab(SpaceSettingsTabs tab, BuildContext context) {
    context.go('/rooms/spaces/${room.id}/details?tab=${tab.name}');
  }

  List<ButtonDetails> _buttons(BuildContext context) {
    final L10n l10n = L10n.of(context);
    return [
      ButtonDetails(
        title: l10n.chats,
        icon: const Icon(Icons.chat_bubble_outline, size: 30.0),
        onPressed: () => setSelectedTab(SpaceSettingsTabs.chat, context),
        visible: !FluffyThemes.isColumnMode(context),
        tab: SpaceSettingsTabs.chat,
      ),
      ButtonDetails(
        title: l10n.coursePlan,
        icon: const Icon(Icons.map_outlined, size: 30.0),
        onPressed: () => setSelectedTab(SpaceSettingsTabs.course, context),
        tab: SpaceSettingsTabs.course,
      ),
      ButtonDetails(
        title: l10n.participants,
        icon: const Icon(Icons.group_outlined, size: 30.0),
        onPressed: () =>
            setSelectedTab(SpaceSettingsTabs.participants, context),
        tab: SpaceSettingsTabs.participants,
      ),
      ButtonDetails(
        title: l10n.stats,
        icon: const Icon(Symbols.bar_chart_4_bars, size: 30.0),
        onPressed: () => setSelectedTab(SpaceSettingsTabs.analytics, context),
        enabled: room.isRoomAdmin,
        tab: SpaceSettingsTabs.analytics,
      ),
      ButtonDetails(
        title: l10n.invite,
        description: l10n.inviteDesc,
        icon: const Icon(Icons.person_add_outlined, size: 30.0),
        onPressed: () {
          String filter = 'knocking';
          if (room.getParticipants([Membership.knock]).isEmpty) {
            filter = room.pangeaSpaceParents.isNotEmpty ? 'space' : 'contacts';
          }
          context.go(
            '/rooms/spaces/${room.id}/details/invite?filter=$filter',
          );
        },
        enabled: room.canInvite,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.editCourse,
        description: l10n.editCourseDesc,
        icon: const Icon(Icons.edit_outlined, size: 30.0),
        onPressed: () => context.go('/rooms/${room.id}/details/edit'),
        enabled: room.isRoomAdmin,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.permissions,
        description: l10n.permissionsDesc,
        icon: const Icon(Icons.edit_attributes_outlined, size: 30.0),
        onPressed: () => context.go('/rooms/${room.id}/details/permissions'),
        enabled: room.isRoomAdmin,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.access,
        description: l10n.accessDesc,
        icon: const Icon(Icons.shield_outlined, size: 30.0),
        onPressed: () => context.go('/rooms/${room.id}/details/access'),
        enabled: room.isRoomAdmin && room.spaceParents.isEmpty,
        showInMainView: false,
      ),
      ButtonDetails(
        title: l10n.createGroupChat,
        description: l10n.createGroupChatDesc,
        icon: const Icon(Symbols.chat_add_on, size: 30.0),
        onPressed: controller.addGroupChat,
        enabled: room.isRoomAdmin &&
            room.canChangeStateEvent(
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
            future: room.leaveSpace,
          );
          if (!resp.isError) {
            context.go("/rooms");
          }
        },
        enabled: room.membership == Membership.join,
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
            builder: (_) => DeleteSpaceDialog(space: room),
          );

          if (resp == true) {
            context.go("/rooms");
          }
        },
        enabled: room.isRoomAdmin,
        showInMainView: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isColumnMode = FluffyThemes.isColumnMode(context);
    final displayname = room.getLocalizedDisplayname(
      MatrixLocals(L10n.of(context)),
    );
    return CoursePlanBuilder(
      courseId: room.coursePlan?.uuid,
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
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isColumnMode) ...[
                        ClipPath(
                          clipper: MapClipper(),
                          child: Avatar(
                            mxContent: room.avatar,
                            name: displayname,
                            userId: room.directChatMatrixID,
                            size: 80.0,
                            borderRadius: BorderRadius.circular(0.0),
                          ),
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
                                fontSize: isColumnMode ? 32.0 : 16.0,
                                fontWeight: isColumnMode
                                    ? FontWeight.normal
                                    : FontWeight.bold,
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
                    ],
                  ),
                ),
                if (room.classCode != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ShareRoomButton(room: room),
                  ),
              ],
            ),
            SizedBox(height: isColumnMode ? 24.0 : 12.0),
            SpaceDetailsButtonRow(
              controller: controller,
              room: room,
              selectedTab: tab(context),
              onTabSelected: (tab) => setSelectedTab(tab, context),
              buttons: _buttons(context),
            ),
            SizedBox(height: isColumnMode ? 30.0 : 14.0),
            Expanded(
              child: Builder(
                builder: (context) {
                  switch (tab(context)) {
                    case SpaceSettingsTabs.chat:
                      return CourseChats(
                        room.id,
                        activeChat: null,
                        client: room.client,
                      );
                    case SpaceSettingsTabs.course:
                      return SingleChildScrollView(
                        child: CourseSettings(
                          // on redirect back to chat settings after completing activity,
                          // course settings doesn't refresh activity details by default
                          // the key forces a rebuild on this redirect
                          key: ValueKey(controller.widget.activeTab),
                          courseController,
                          room: room,
                        ),
                      );
                    case SpaceSettingsTabs.participants:
                      return SingleChildScrollView(
                        child: RoomParticipantsSection(room: room),
                      );
                    case SpaceSettingsTabs.analytics:
                      return SingleChildScrollView(
                        child: Center(
                          child: SpaceAnalytics(roomId: room.id),
                        ),
                      );
                    case SpaceSettingsTabs.more:
                      final buttons = _buttons(context)
                          .where(
                            (b) => !b.showInMainView && b.visible,
                          )
                          .toList();

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            if (room.topic.isNotEmpty) ...[
                              Text(
                                room.topic,
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
                                    title: Text(b.title),
                                    subtitle: b.description != null
                                        ? Text(b.description!)
                                        : null,
                                    leading: b.icon,
                                    onTap: b.enabled
                                        ? () => b.onPressed?.call()
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
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
