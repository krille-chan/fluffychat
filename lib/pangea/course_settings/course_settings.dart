// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/common/widgets/url_image_widget.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_plans/course_activities/activity_summaries_provider.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/course_settings/pin_clipper.dart';
import 'package:fluffychat/pangea/course_settings/topic_participant_list.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';

class CourseSettings extends StatefulWidget {
  final Room room;
  const CourseSettings({
    super.key,
    required this.room,
  });

  @override
  State<CourseSettings> createState() => CourseSettingsState();
}

class CourseSettingsState extends State<CourseSettings>
    with ActivitySummariesProvider, CoursePlanProvider {
  Room get room => widget.room;
  bool _loadingActivities = true;

  @override
  void initState() {
    super.initState();
    _loadSummaries();
    _loadCourseInfo();
  }

  @override
  void didUpdateWidget(covariant CourseSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.room.id != widget.room.id) {
      _loadCourseInfo();
    }
  }

  Future<void> _loadCourseInfo() async {
    if (widget.room.coursePlan == null) {
      setState(() {
        course = null;
        loadingCourse = false;
        loadingTopics = false;
        _loadingActivities = false;
      });
      return;
    }

    setState(() => _loadingActivities = true);
    await loadCourse(widget.room.coursePlan!.uuid);
    if (course != null) {
      await loadTopics();
      await loadAllActivities();
    }
    if (mounted) setState(() => _loadingActivities = false);
  }

  Future<void> _loadSummaries() async {
    try {
      await loadRoomSummaries(
        room.spaceChildren.map((c) => c.roomId).whereType<String>().toList(),
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "message": "Failed to load activity summaries",
          "roomId": room.id,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loadingCourse) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (course == null || courseError != null) {
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
                  onPressed: () =>
                      context.go("/rooms/spaces/${room.id}/addcourse"),
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

    if (loadingTopics) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final activeTopicId = currentTopicId(
      room.client.userID!,
      course!,
    );

    final int? topicIndex =
        activeTopicId == null ? null : course!.topicIds.indexOf(activeTopicId);

    final Map<String, List<User>> userTopics = _loadingActivities
        ? {}
        : topicsToUsers(
            room,
            course!,
          );

    return Column(
      spacing: isColumnMode ? 40.0 : 36.0,
      mainAxisSize: MainAxisSize.min,
      children: course!.topicIds.mapIndexed((index, topicId) {
        final topic = course!.loadedTopics[topicId];
        if (topic == null) {
          return const SizedBox();
        }

        final usersInTopic = userTopics[topicId] ?? [];
        final activityError = activityErrors[topicId];

        final bool locked = topicIndex == null ? false : index > topicIndex;
        final disabled = locked || _loadingActivities || activityError != null;
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
                                  else if (_loadingActivities)
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
                  _loadingActivities
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(),
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
                                    controller: this,
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

class TopicActivitiesList extends StatefulWidget {
  final Room room;
  final Map<String, ActivityPlanModel> activities;
  final CourseSettingsState controller;

  const TopicActivitiesList({
    super.key,
    required this.room,
    required this.activities,
    required this.controller,
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
          final complete = widget.controller.hasCompletedActivity(
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
                    if (complete)
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
