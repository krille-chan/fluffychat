import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pangea/analytics_summary/learning_progress_indicators.dart';
import 'package:fluffychat/pangea/course_chats/activity_template_chat_list_item.dart';
import 'package:fluffychat/pangea/course_chats/course_chats_page.dart';
import 'package:fluffychat/pangea/course_chats/unjoined_chat_list_item.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/space_analytics/analytics_request_indicator.dart';
import 'package:fluffychat/pangea/spaces/widgets/knocking_users_indicator.dart';
import 'package:fluffychat/utils/stream_extension.dart';

class CourseChatsView extends StatelessWidget {
  final CourseChatsController controller;
  const CourseChatsView(
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final room = controller.room;
    if (room == null) {
      return const Center(
        child: Icon(
          Icons.search_outlined,
          size: 80,
        ),
      );
    }

    return CoursePlanBuilder(
      courseId: room.coursePlan?.uuid,
      onLoaded: controller.setCourse,
      builder: (context, courseController) {
        return StreamBuilder(
          stream: room.client.onSync.stream
              .where((s) => s.hasRoomUpdate)
              .rateLimit(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            final joinedChats = controller.joinedChats;
            final joinedSessions = controller.joinedActivities();

            final discoveredGroupChats = controller.discoveredGroupChats;
            final discoveredSessions =
                controller.discoveredActivities().entries.toList();

            final isColumnMode = FluffyThemes.isColumnMode(context);
            return Padding(
              padding: isColumnMode
                  ? const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 8.0,
                    )
                  : const EdgeInsets.all(0.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: joinedChats.length +
                    joinedSessions.length +
                    discoveredGroupChats.length +
                    discoveredSessions.length +
                    7,
                itemBuilder: (context, i) {
                  // courses chats title
                  if (i == 0) {
                    if (isColumnMode) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        child: Column(
                          spacing: 12.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LearningProgressIndicators(),
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 30.0,
                            ),
                            SizedBox(height: 12.0),
                          ],
                        ),
                      );
                    }

                    return const SizedBox();
                  }
                  i--;

                  if (i == 0) {
                    return KnockingUsersIndicator(room: room);
                  }
                  i--;

                  if (i == 0) {
                    return AnalyticsRequestIndicator(room: room);
                  }
                  i--;

                  // joined group chats
                  if (i < joinedChats.length) {
                    final joinedRoom = joinedChats[i];
                    return ChatListItem(
                      joinedRoom,
                      onTap: () => controller.onChatTap(joinedRoom),
                      onLongPress: (context) => controller.chatContextAction(
                        joinedRoom,
                        context,
                      ),
                      activeChat: controller.widget.activeChat == joinedRoom.id,
                    );
                  }
                  i -= joinedChats.length;

                  // unjoined group chats
                  if (i < discoveredGroupChats.length) {
                    return UnjoinedChatListItem(
                      chunk: discoveredGroupChats[i],
                      onTap: () =>
                          controller.joinChildRoom(discoveredGroupChats[i]),
                    );
                  }
                  i -= discoveredGroupChats.length;

                  if (i == 0) {
                    return joinedSessions.isEmpty && discoveredSessions.isEmpty
                        ? ListTile(
                            leading: const Icon(Icons.map_outlined),
                            title: Text(L10n.of(context).whatNow),
                            subtitle: Text(L10n.of(context).chooseNextActivity),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () => context.go(
                              "/rooms/spaces/${room.id}/details?tab=course",
                            ),
                          )
                        : const SizedBox();
                  }
                  i--;

                  if (i == 0) {
                    return joinedSessions.isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 20.0,
                              bottom: 4.0,
                            ),
                            child: Text(
                              L10n.of(context).myActivities,
                              style: const TextStyle(fontSize: 12.0),
                              textAlign: TextAlign.center,
                            ),
                          );
                  }
                  i--;

                  // joined activity sessions
                  if (i < joinedSessions.length) {
                    final joinedRoom = joinedSessions[i];
                    return ChatListItem(
                      joinedRoom,
                      onTap: () => controller.onChatTap(joinedRoom),
                      onLongPress: (context) => controller.chatContextAction(
                        joinedRoom,
                        context,
                      ),
                      activeChat: controller.widget.activeChat == joinedRoom.id,
                      borderRadius: BorderRadius.circular(
                        AppConfig.borderRadius / 2,
                      ),
                    );
                  }
                  i -= joinedSessions.length;

                  if (i == 0) {
                    return discoveredSessions.isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 20.0,
                              bottom: 4.0,
                            ),
                            child: Text(
                              L10n.of(context).openToJoin,
                              style: const TextStyle(fontSize: 12.0),
                              textAlign: TextAlign.center,
                            ),
                          );
                  }
                  i--;

                  // unjoined activity sessions
                  if (i < discoveredSessions.length) {
                    final activity = discoveredSessions[i].key;
                    final sessions = discoveredSessions[i].value;
                    return ActivityTemplateChatListItem(
                      space: room,
                      activity: activity,
                      sessions: sessions,
                      joinActivity: (e) =>
                          controller.joinActivity(activity.activityId, e),
                    );
                  }
                  i -= discoveredSessions.length;

                  if (controller.noMoreRooms) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 2.0,
                    ),
                    child: TextButton(
                      onPressed: controller.isLoading
                          ? null
                          : controller.loadHierarchy,
                      child: controller.isLoading
                          ? LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(
                                AppConfig.borderRadius,
                              ),
                            )
                          : Text(L10n.of(context).loadMore),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
