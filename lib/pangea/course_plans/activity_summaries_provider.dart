import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/bot/utils/bot_name.dart';
import 'package:fluffychat/pangea/chat_settings/utils/room_summary_extension.dart';
import 'package:fluffychat/pangea/course_plans/course_plan_model.dart';
import 'package:fluffychat/pangea/course_plans/course_topic_model.dart';
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
    CoursePlanModel course,
  ) {
    final topicIndex = course.loadedTopics.indexWhere(
      (t) => t.uuid == topic.uuid,
    );

    if (topicIndex == -1) {
      throw Exception('Topic not found');
    }

    final topicActivities = course.loadedTopics[topicIndex].loadedActivities;
    final topicActivityIds = topicActivities.map((a) => a.activityId).toSet();
    final numTwoPersonActivities =
        topicActivities.where((a) => a.req.numberOfParticipants <= 2).length;

    final completedTopicActivities =
        _completedActivities(userID).intersection(topicActivityIds);

    return completedTopicActivities.length >= numTwoPersonActivities;
  }

  int currentTopicIndex(
    String userID,
    CoursePlanModel course,
  ) {
    if (course.loadedTopics.isEmpty) return -1;
    for (int i = 0; i < course.loadedTopics.length; i++) {
      if (!_hasCompletedTopic(userID, course.loadedTopics[i], course)) {
        return i;
      }
    }
    return 0;
  }

  Future<Map<String, List<User>>> topicsToUsers(
    Room room,
    CoursePlanModel course,
  ) async {
    final Map<String, List<User>> topicUserMap = {};
    final users = await room.requestParticipants(
      [Membership.join, Membership.invite, Membership.knock],
      false,
      true,
    );

    for (final user in users) {
      if (user.id == BotName.byEnvironment) continue;
      final topicIndex = currentTopicIndex(user.id, course);
      if (topicIndex != -1) {
        final topicID = course.loadedTopics[topicIndex].uuid;
        topicUserMap.putIfAbsent(topicID, () => []).add(user);
      }
    }
    return topicUserMap;
  }
}
