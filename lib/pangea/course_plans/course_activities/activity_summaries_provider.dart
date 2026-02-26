import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/utils/room_summary_extension.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_model.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

enum ActivitySummaryStatus {
  notStarted,
  inProgress,
  completed;

  String label(L10n l10n, int count) {
    switch (this) {
      case ActivitySummaryStatus.notStarted:
        return l10n.notStartedActivitiesTitle(count);
      case ActivitySummaryStatus.inProgress:
        return l10n.inProgressActivitiesTitle(count);
      case ActivitySummaryStatus.completed:
        return l10n.completedActivitiesTitle(count);
    }
  }
}

mixin ActivitySummariesProvider<T extends StatefulWidget> on State<T> {
  Map<String, RoomSummaryResponse>? roomSummaries;

  Future<void> loadRoomSummaries(List<String> roomIds) async {
    if (roomIds.isEmpty) {
      roomSummaries = {};
      return;
    }

    final resp = await Matrix.of(context).client.requestRoomSummaries(roomIds);
    if (mounted) {
      setState(() => roomSummaries = resp.summaries);
    }
  }

  bool isActivityStarted(String roomId) {
    if (isActivityFinished(roomId)) return true;
    final roomSummary = roomSummaries?[roomId];
    if (roomSummary == null) return false;

    final activityPlan = roomSummary.activityPlan;
    final assignedRoles = roomSummary.joinedUsersWithRoles;
    if (activityPlan == null) return false;
    return activityPlan.roles.length - assignedRoles.length <= 0;
  }

  bool isActivityFinished(String roomId) {
    final roomSummary = roomSummaries?[roomId];
    if (roomSummary == null) return false;

    final activityRoles = roomSummary.activityRoles;
    if (activityRoles == null) return false;
    final roles = activityRoles.roles.values.where(
      (r) => r.userId != BotName.byEnvironment,
    );

    if (roles.isEmpty) return false;
    if (!roles.any((r) => r.isFinished)) return false;

    return roles.every((r) {
      if (r.isFinished) return true;

      // if the user is in the chat (not null && membership is join),
      // then the activity is not finished for them
      final membership = roomSummary.getMembershipForUserId(r.userId);
      return membership == null || membership != Membership.join;
    });
  }

  Map<String, RoomSummaryResponse> activitySessions(String activityId) =>
      Map.fromEntries(
        roomSummaries?.entries.where(
              (v) => v.value.activityPlan?.activityId == activityId,
            ) ??
            [],
      );

  Map<ActivitySummaryStatus, Map<String, RoomSummaryResponse>>
  activitySessionStatuses(String activityId) {
    final statuses = <ActivitySummaryStatus, Map<String, RoomSummaryResponse>>{
      ActivitySummaryStatus.notStarted: {},
      ActivitySummaryStatus.inProgress: {},
      ActivitySummaryStatus.completed: {},
    };

    final sessions = activitySessions(activityId);
    for (final entry in sessions.entries) {
      final session = entry.value;
      final roomId = entry.key;

      if (isActivityFinished(roomId)) {
        statuses[ActivitySummaryStatus.completed]![roomId] = session;
      } else if (isActivityStarted(roomId)) {
        statuses[ActivitySummaryStatus.inProgress]![roomId] = session;
      } else {
        statuses[ActivitySummaryStatus.notStarted]![roomId] = session;
      }
    }

    return statuses;
  }

  Set<String> openSessions(String activityId) {
    if (roomSummaries == null || roomSummaries!.isEmpty) return {};
    final Set<String> sessions = {};

    for (final entry in roomSummaries!.entries) {
      final summary = entry.value;
      final roomId = entry.key;

      if (summary.activityPlan?.activityId != activityId) {
        continue;
      }

      if (!isActivityStarted(roomId)) {
        sessions.add(roomId);
      }
    }
    return sessions;
  }

  int numOpenSessions(String activityId) => openSessions(activityId).length;

  Set<String> _completedActivities(String userID) {
    if (roomSummaries == null || roomSummaries!.isEmpty) return {};
    return roomSummaries!.values
        .where(
          (entry) =>
              entry.activityRoles != null &&
              entry.activityRoles!.roles.values.any(
                (v) => v.userId == userID && v.isArchived,
              ),
        )
        .map((e) => e.activityPlan?.activityId)
        .whereType<String>()
        .toSet();
  }

  bool hasCompletedActivity(String userID, String activityID) {
    final completed = _completedActivities(userID);
    return completed.contains(activityID);
  }

  bool _hasCompletedTopic(
    String userID,
    CourseTopicModel topic,
    int? activitiesToCompleteOverride,
  ) {
    final topicActivityIds = topic.activityIds.toSet();
    final completedTopicActivities = _completedActivities(
      userID,
    ).intersection(topicActivityIds);

    if (completedTopicActivities.length >= topicActivityIds.length) {
      return true;
    }

    if (activitiesToCompleteOverride != null) {
      return completedTopicActivities.length >= activitiesToCompleteOverride;
    }

    final numTwoPersonActivities = topic.activityRoleCounts.entries
        .where((e) => e.value <= 2)
        .length;

    return completedTopicActivities.length >= numTwoPersonActivities;
  }

  String? currentTopicId(
    String userID,
    CoursePlanModel course,
    int? activitiesToCompleteOverride,
  ) {
    if (course.loadedTopics.isEmpty) {
      return null;
    }

    for (int i = 0; i < course.topicIds.length; i++) {
      final topicId = course.topicIds[i];
      final topic = course.loadedTopics[topicId];
      if (topic == null) continue;
      if (!_hasCompletedTopic(userID, topic, activitiesToCompleteOverride) &&
          topic.activityIds.isNotEmpty) {
        return topicId;
      }
    }
    return course.topicIds.last;
  }

  Map<String, List<User>> topicsToUsers(
    Room room,
    CoursePlanModel course,
    int? activitiesToCompleteOverride,
  ) {
    final Map<String, List<User>> topicUserMap = {};
    final users = room.getParticipants();
    for (final user in users) {
      if (user.id == BotName.byEnvironment) continue;
      final topicId = currentTopicId(
        user.id,
        course,
        activitiesToCompleteOverride,
      );
      if (topicId != null) {
        topicUserMap.putIfAbsent(topicId, () => []).add(user);
      }
    }
    return topicUserMap;
  }
}
