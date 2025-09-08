import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart' as sdk;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_list/chat_list_item.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';
import 'package:fluffychat/pangea/course_chats/course_chats_page.dart';
import 'package:fluffychat/pangea/course_chats/unjoined_chat_list_item.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/course_plans/course_topic_model.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
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
      onLoaded: (course) {
        controller.setCourse(course);
        final topic = room.ownCurrentTopic(course);
        if (topic != null) controller.setSelectedTopicId(topic.uuid);
      },
      builder: (context, courseController) {
        final CourseTopicModel? topic = controller.selectedTopic;
        final List<String> activityIds = topic?.activityIds ?? [];

        return StreamBuilder(
          stream: room.client.onSync.stream
              .where((s) => s.hasRoomUpdate)
              .rateLimit(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            final childrenIds = room.spaceChildren
                .map((c) => c.roomId)
                .whereType<String>()
                .toSet();

            final joinedChats = [];
            final joinedSessions = [];
            final joinedRooms = room.client.rooms
                .where((room) => childrenIds.remove(room.id))
                .where((room) => !room.isHiddenRoom)
                .toList();

            for (final joinedRoom in joinedRooms) {
              if (joinedRoom.isActivitySession) {
                String? activityId = joinedRoom.activityPlan?.activityId;
                if (activityId == null && joinedRoom.isActivityRoomType) {
                  activityId = joinedRoom.roomType!.split(":").last;
                }

                if (topic == null || activityIds.contains(activityId)) {
                  joinedSessions.add(joinedRoom);
                }
              } else {
                joinedChats.add(joinedRoom);
              }
            }

            final discoveredGroupChats = [];
            final discoveredSessions = [];
            final discoveredChildren =
                controller.discoveredChildren ?? <SpaceRoomsChunk>[];

            for (final child in discoveredChildren) {
              final roomType = child.roomType;
              if (roomType?.startsWith(PangeaRoomTypes.activitySession) ==
                  true) {
                if (activityIds.contains(roomType!.split(":").last)) {
                  discoveredSessions.add(child);
                }
              } else {
                discoveredGroupChats.add(child);
              }
            }

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
                    6,
                itemBuilder: (context, i) {
                  // courses chats title
                  if (i == 0) {
                    if (isColumnMode) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          spacing: 12.0,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 24.0),
                            const Icon(
                              Icons.chat_bubble_outline,
                              size: 30.0,
                            ),
                            Text(
                              L10n.of(context).courseChats,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            const SizedBox(height: 14.0),
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
                    if (room.coursePlan == null ||
                        (courseController.course == null &&
                            !courseController.loading)) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 12.0,
                      ),
                      child: courseController.loading
                          ? LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(
                                AppConfig.borderRadius,
                              ),
                            )
                          : topic != null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MouseRegion(
                                      cursor: controller.canMoveLeft
                                          ? SystemMouseCursors.click
                                          : SystemMouseCursors.basic,
                                      child: GestureDetector(
                                        onTap: controller.canMoveLeft
                                            ? controller.moveLeft
                                            : null,
                                        child: Opacity(
                                          opacity: controller.canMoveLeft
                                              ? 1.0
                                              : 0.3,
                                          child: const Icon(
                                            Icons.arrow_left,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (topic.location != null)
                                      Row(
                                        spacing: 6.0,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 24.0,
                                          ),
                                          Text(
                                            topic.location!,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    MouseRegion(
                                      cursor: controller.canMoveRight
                                          ? SystemMouseCursors.click
                                          : SystemMouseCursors.basic,
                                      child: GestureDetector(
                                        onTap: controller.canMoveRight
                                            ? controller.moveRight
                                            : null,
                                        child: Opacity(
                                          opacity: controller.canMoveRight
                                              ? 1.0
                                              : 0.3,
                                          child: const Icon(
                                            Icons.arrow_right,
                                            size: 24.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                    );
                  }
                  i--;

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
                    );
                  }
                  i -= joinedSessions.length;

                  // unjoined activity sessions
                  if (i < discoveredSessions.length) {
                    return UnjoinedChatListItem(
                      chunk: discoveredSessions[i],
                      onTap: () => controller.joinChildRoom(
                        discoveredSessions[i],
                      ),
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
