import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/utils/room_summary_extension.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_model.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

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

  Set<String> openSessions(String activityId) {
    if (roomSummaries == null || roomSummaries!.isEmpty) return {};
    final Set<String> sessions = {};

    for (final entry in roomSummaries!.entries) {
      final summary = entry.value;
      final roomId = entry.key;

      if (summary.activityPlan.activityId != activityId) {
        continue;
      }

      final isOpen = summary.activityRoles.roles.length <
          summary.activityPlan.req.numberOfParticipants;

      if (isOpen) {
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
          (entry) => entry.activityRoles.roles.values.any(
            (v) => v.userId == userID && v.isArchived,
          ),
        )
        .map((e) => e.activityPlan.activityId)
        .whereType<String>()
        .toSet();
  }

  bool hasCompletedActivity(
    String userID,
    String activityID,
  ) {
    final completed = _completedActivities(userID);
    return completed.contains(activityID);
  }

  bool _hasCompletedTopic(
    String userID,
    CourseTopicModel topic,
  ) {
    final topicActivityIds = topic.activityIds.toSet();
    final numTwoPersonActivities = topic.loadedActivities.values
        .where((a) => a.req.numberOfParticipants <= 2)
        .length;

    final completedTopicActivities =
        _completedActivities(userID).intersection(topicActivityIds);

    return completedTopicActivities.length >= numTwoPersonActivities;
  }

  String? currentTopicId(
    String userID,
    CoursePlanModel course,
  ) {
    if (course.loadedTopics.isEmpty) {
      return null;
    }

    for (int i = 0; i < course.topicIds.length; i++) {
      final topicId = course.topicIds[i];
      final topic = course.loadedTopics[topicId];
      if (topic == null) continue;
      if (!topic.activityListComplete) {
        return null;
      }

      if (!_hasCompletedTopic(userID, topic) && topic.activityIds.isNotEmpty) {
        return topicId;
      }
    }
    return course.topicIds.last;
  }

  Map<String, List<User>> topicsToUsers(
    Room room,
    CoursePlanModel course,
  ) {
    final Map<String, List<User>> topicUserMap = {};
    final users = room.getParticipants();
    for (final user in users) {
      if (user.id == BotName.byEnvironment) continue;
      final topicId = currentTopicId(user.id, course);
      if (topicId != null) {
        topicUserMap.putIfAbsent(topicId, () => []).add(user);
      }
    }
    return topicUserMap;
  }
}
