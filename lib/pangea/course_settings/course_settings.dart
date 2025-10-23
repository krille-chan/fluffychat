// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat_details/chat_details.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/course_settings/pin_clipper.dart';
import 'package:fluffychat/pangea/course_settings/topic_participant_list.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:shimmer/shimmer.dart';

class CourseSettings extends StatelessWidget {
  // final Room room;

  // /// The course ID to load, from the course plan event in the room.
  // /// Separate from the room to trigger didUpdateWidget on change
  // final String? courseId;
  final ChatDetailsController controller;

  const CourseSettings({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.loadingCourse) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final room =
        Matrix.of(context).client.getRoomById(controller.widget.roomId);
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
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  onPressed: () => context
                      .go("/rooms/spaces/${controller.roomId}/addcourse"),
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
    );

    final int? topicIndex = activeTopicId == null
        ? null
        : controller.course!.topicIds.indexOf(activeTopicId);

    final Map<String, List<User>> userTopics = controller.loadingActivities
        ? {}
        : controller.topicsToUsers(
            room,
            controller.course!,
          );

    return Column(
      spacing: isColumnMode ? 40.0 : 36.0,
      mainAxisSize: MainAxisSize.min,
      children: controller.course!.topicIds.mapIndexed((index, topicId) {
        final topic = controller.course!.loadedTopics[topicId];
        if (topic == null) {
          return const SizedBox();
        }

        final usersInTopic = userTopics[topicId] ?? [];
        final activityError = controller.activityErrors[topicId];

        final bool locked = topicIndex == null ? false : index > topicIndex;
        final disabled =
            locked || controller.loadingActivities || activityError != null;
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
                                    )
                                  else if (controller.loadingActivities)
                                    const SizedBox(
                                      width: 54.0,
                                      height: 54.0,
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                                ],
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          avatarSize:
                                              isColumnMode ? 50.0 : 25.0,
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
                  controller.loadingActivities
                      ? ActivityCardPlaceholder(
                          activityCount: topic.activityIds.length,
                        )
                      : activityError != null
                          ? ErrorIndicator(
                              message: L10n.of(context).oopsSomethingWentWrong,
                            )
                          : topic.loadedActivities.isNotEmpty
                              ? SizedBox(
                                  height: isColumnMode ? 290.0 : 210.0,
                                  child: TopicActivitiesList(
                                    room: room,
                                    activities: topic.loadedActivities,
                                    loading: controller.loadingCourseSummary,
                                    hasCompletedActivity:
                                        controller.hasCompletedActivity,
                                  ),
                                )
                              : const SizedBox(),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class ActivityCardPlaceholder extends StatelessWidget {
  final int activityCount;

  const ActivityCardPlaceholder({
    super.key,
    required this.activityCount,
  });

  @override
  Widget build(BuildContext context) {
    final int shimmerCount = activityCount;
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    return SizedBox(
      height: isColumnMode ? 290.0 : 210.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shimmerCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Shimmer.fromColors(
              baseColor: theme.colorScheme.primary.withAlpha(20),
              highlightColor: theme.colorScheme.primary.withAlpha(50),
              child: Container(
                width: isColumnMode ? 160.0 : 120.0,
                height: isColumnMode ? 280.0 : 200.0,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TopicActivitiesList extends StatefulWidget {
  final Room room;
  final Map<String, ActivityPlanModel> activities;
  final bool loading;
  final bool Function(String userId, String activityId) hasCompletedActivity;

  const TopicActivitiesList({
    super.key,
    required this.room,
    required this.activities,
    required this.loading,
    required this.hasCompletedActivity,
  });
  @override
  State<TopicActivitiesList> createState() => TopicActivitiesListState();
}

class TopicActivitiesListState extends State<TopicActivitiesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    final activityEntries = widget.activities.entries.toList();
    activityEntries.sort(
      (a, b) => a.value.req.numberOfParticipants.compareTo(
        b.value.req.numberOfParticipants,
      ),
    );

    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: activityEntries.length,
        itemBuilder: (context, index) {
          final activityEntry = activityEntries[index];
          final complete = widget.hasCompletedActivity(
            widget.room.client.userID!,
            activityEntry.key,
          );

          final activityRoomId = widget.room.activeActivityRoomId(
            activityEntry.key,
          );

          final activity = activityEntry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => context.go(
                  activityRoomId != null
                      ? "/rooms/spaces/${widget.room.id}/$activityRoomId"
                      : "/rooms/spaces/${widget.room.id}/activity/${activityEntry.key}",
                ),
                child: Stack(
                  children: [
                    ActivitySuggestionCard(
                      activity: activity,
                      width: isColumnMode ? 160.0 : 120.0,
                      height: isColumnMode ? 280.0 : 200.0,
                      fontSize: isColumnMode ? 20.0 : 12.0,
                      fontSizeSmall: isColumnMode ? 12.0 : 8.0,
                      iconSize: isColumnMode ? 12.0 : 8.0,
                    ),
                    if (widget.loading)
                      Container(
                        width: isColumnMode ? 160.0 : 120.0,
                        height: isColumnMode ? 280.0 : 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: theme.colorScheme.surface.withAlpha(180),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      )
                    else if (complete)
                      Container(
                        width: isColumnMode ? 160.0 : 120.0,
                        height: isColumnMode ? 280.0 : 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: theme.colorScheme.surface.withAlpha(180),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/pangea/check.svg",
                            width: 48.0,
                            height: 48.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
