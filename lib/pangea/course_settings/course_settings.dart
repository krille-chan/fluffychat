// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/course_settings/pin_clipper.dart';
import 'package:fluffychat/pangea/course_settings/topic_activities_list.dart';
import 'package:fluffychat/pangea/course_settings/topic_participant_list.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/widgets/matrix.dart';

class CourseSettings extends StatelessWidget {
  final ChatDetailsController controller;

  const CourseSettings({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.loadingCourse) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final room = Matrix.of(
      context,
    ).client.getRoomById(controller.widget.roomId);
    if (room == null || !room.isSpace) {
      return Center(
        child: Text(
          L10n.of(context).noCourseFound,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    if (controller.course == null || controller.courseError != null) {
      if (controller.courseError != null) {
        return Center(
          child: Text(
            L10n.of(context).courseLoadingError,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      }

      return room.canChangeStateEvent(PangeaEventTypes.coursePlan)
          ? Column(
              spacing: 50.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  L10n.of(context).noCourseFound,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                  ),
                  onPressed: () => context.go(
                    "/rooms/spaces/${controller.roomId}/addcourse",
                  ),
                  child: Row(
                    spacing: 8.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.map_outlined),
                      Text(L10n.of(context).addCoursePlan),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                L10n.of(context).noCourseFound,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
    }

    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);
    final double titleFontSize = isColumnMode ? 24.0 : 12.0;
    final double descFontSize = isColumnMode ? 12.0 : 8.0;
    final double iconSize = isColumnMode ? 16.0 : 12.0;

    if (controller.loadingTopics) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final activeTopicId = controller.currentTopicId(
      Matrix.of(context).client.userID!,
      controller.course!,
      room.teacherMode.activitiesToUnlockTopic,
    );

    final int? topicIndex = activeTopicId == null
        ? null
        : controller.course!.topicIds.indexOf(activeTopicId);

    final Map<String, List<User>> userTopics = controller.loadingCourseInfo
        ? {}
        : controller.topicsToUsers(
            room,
            controller.course!,
            room.teacherMode.activitiesToUnlockTopic,
          );

    final teacherMode = room.isTeacherMode;

    return Column(
      spacing: isColumnMode ? 40.0 : 36.0,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...controller.course!.topicIds.mapIndexed((index, topicId) {
          final topic = controller.course!.loadedTopics[topicId];
          if (topic == null) {
            return const SizedBox();
          }

          final usersInTopic = userTopics[topicId] ?? [];

          final bool locked =
              !teacherMode && (topicIndex == null ? false : index > topicIndex);

          final disabled = locked || controller.loadingCourseInfo;

          return AbsorbPointer(
            absorbing: disabled,
            child: Opacity(
              opacity: disabled ? 0.5 : 1.0,
              child: Column(
                spacing: 12.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        spacing: 8.0,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Row(
                              spacing: 4.0,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  children: [
                                    ClipPath(
                                      clipper: PinClipper(),
                                      child: ImageByUrl(
                                        imageUrl: topic.imageUrl,
                                        width: 54.0,
                                        replacement: Container(
                                          width: 54.0,
                                          height: 54.0,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (locked)
                                      const Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Icon(Icons.lock, size: 24.0),
                                      ),
                                  ],
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        topic.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: titleFontSize,
                                        ),
                                      ),
                                      if (topic.location != null)
                                        CourseInfoChip(
                                          icon: Icons.location_on,
                                          text: topic.location!,
                                          fontSize: descFontSize,
                                          iconSize: iconSize,
                                        ),
                                      if (constraints.maxWidth < 700.0)
                                        Padding(
                                          padding:
                                              const EdgeInsetsGeometry.symmetric(
                                                vertical: 4.0,
                                              ),
                                          child: TopicParticipantList(
                                            room: room,
                                            users: usersInTopic,
                                            avatarSize: isColumnMode
                                                ? 50.0
                                                : 25.0,
                                            overlap: isColumnMode ? 20.0 : 8.0,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (constraints.maxWidth >= 700.0)
                            TopicParticipantList(
                              room: room,
                              users: usersInTopic,
                              avatarSize: isColumnMode ? 50.0 : 25.0,
                              overlap: isColumnMode ? 20.0 : 8.0,
                            ),
                        ],
                      );
                    },
                  ),
                  if (!locked)
                    SizedBox(
                      height: isColumnMode ? 290.0 : 210.0,
                      child: TopicActivitiesList(
                        room: room,
                        topic: topic,
                        hasCompletedActivity: controller.hasCompletedActivity,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
