import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_builder.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_dialog.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/course_creation/course_info_chip_widget.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_builder.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_room_extension.dart';
import 'package:fluffychat/pangea/course_settings/pin_clipper.dart';
import 'package:fluffychat/pangea/course_settings/topic_participant_list.dart';

class CourseSettings extends StatelessWidget {
  final Room room;
  final CoursePlanController controller;
  const CourseSettings(
    this.controller, {
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.error != null) {
      return Center(
        child: ErrorIndicator(message: L10n.of(context).failedToLoadCourseInfo),
      );
    }

    if (controller.course == null) {
      return Center(child: Text(L10n.of(context).noCourseFound));
    }

    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);
    final double titleFontSize = isColumnMode ? 24.0 : 12.0;
    final double descFontSize = isColumnMode ? 12.0 : 8.0;
    final double iconSize = isColumnMode ? 16.0 : 12.0;

    final course = controller.course!;
    final currentTopicIndex = room.currentTopicIndex(
      room.client.userID!,
      course,
    );

    return FutureBuilder(
      future: room.topicsToUsers(course),
      builder: (context, snapshot) {
        final topicsToUsers = snapshot.data ?? {};
        return Column(
          spacing: isColumnMode ? 40.0 : 36.0,
          mainAxisSize: MainAxisSize.min,
          children: course.topics.mapIndexed((index, topic) {
            final unlocked = index <= currentTopicIndex;
            final usersInTopic = topicsToUsers[topic.uuid] ?? [];
            return AbsorbPointer(
              absorbing: !unlocked,
              child: Opacity(
                opacity: unlocked ? 1.0 : 0.5,
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
                                        child: topic.imageUrl != null
                                            ? CachedNetworkImage(
                                                width: 54.0,
                                                height: 54.0,
                                                fit: BoxFit.cover,
                                                imageUrl: topic.imageUrl!,
                                                placeholder: (context, url) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Container(
                                                    width: 54.0,
                                                    height: 54.0,
                                                    decoration: BoxDecoration(
                                                      color: theme.colorScheme
                                                          .secondary,
                                                    ),
                                                  );
                                                },
                                              )
                                            : Container(
                                                width: 54.0,
                                                height: 54.0,
                                                decoration: BoxDecoration(
                                                  color: theme
                                                      .colorScheme.secondary,
                                                ),
                                              ),
                                      ),
                                      if (!unlocked)
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
                                        CourseInfoChip(
                                          icon: Icons.location_on,
                                          text: topic.location,
                                          fontSize: descFontSize,
                                          iconSize: iconSize,
                                        ),
                                        if (constraints.maxWidth < 700.0)
                                          Padding(
                                            padding: const EdgeInsetsGeometry
                                                .symmetric(
                                              vertical: 4.0,
                                            ),
                                            child: TopicParticipantList(
                                              room: room,
                                              users: usersInTopic,
                                              avatarSize:
                                                  isColumnMode ? 50.0 : 25.0,
                                              overlap:
                                                  isColumnMode ? 20.0 : 8.0,
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
                    if (unlocked)
                      SizedBox(
                        height: 210.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topic.activities.length,
                          itemBuilder: (context, index) {
                            final activity = topic.activities[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: ActivityPlannerBuilder(
                                initialActivity: activity,
                                room: room,
                                builder: (activityController) {
                                  return ActivitySuggestionCard(
                                    controller: activityController,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ActivitySuggestionDialog(
                                            controller: activityController,
                                            buttonText:
                                                L10n.of(context).launchToSpace,
                                          );
                                        },
                                      );
                                    },
                                    width: 120.0,
                                    height: 200.0,
                                    fontSize: 12.0,
                                    fontSizeSmall: 8.0,
                                    iconSize: 8.0,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
