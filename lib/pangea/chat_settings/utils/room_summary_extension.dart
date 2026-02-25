import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:http/http.dart' hide Client;
import 'package:matrix/matrix.dart';
import 'package:matrix/matrix_api_lite/generated/api.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_role_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_roles_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_model.dart';
import 'package:fluffychat/pangea/course_plans/courses/course_plan_event.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';

extension RoomSummaryExtension on Api {
  Future<RoomSummariesResponse> getRoomSummaries(List<String> roomIds) async {
    final requestUri = Uri(
      path: '/_synapse/client/unstable/org.pangea/room_preview',
      queryParameters: {'rooms': roomIds.join(",")},
    );
    final request = Request('GET', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['authorization'] = 'Bearer ${bearerToken!}';
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    final responseString = utf8.decode(responseBody);
    if (response.statusCode != 200) {
      throw Exception(
        'HTTP error response: statusCode=${response.statusCode}, body=$responseString',
      );
    }
    final json = jsonDecode(responseString);
    return RoomSummariesResponse.fromJson(json);
  }
}

extension RoomSummaryRequest on Client {
  Future<RoomSummariesResponse> requestRoomSummaries(List<String> roomIds) =>
      getRoomSummaries(roomIds);
}

class RoomSummariesResponse {
  Map<String, RoomSummaryResponse> summaries;

  RoomSummariesResponse({required this.summaries});

  factory RoomSummariesResponse.fromJson(Map<String, dynamic> json) {
    final summaries = <String, RoomSummaryResponse>{};
    json["rooms"].forEach((key, value) {
      if (value.isNotEmpty) {
        summaries[key] = RoomSummaryResponse.fromJson(value);
      }
    });
    return RoomSummariesResponse(summaries: summaries);
  }
}

class RoomSummaryResponse {
  final ActivityPlanModel? activityPlan;
  final ActivityRolesModel? activityRoles;
  final ActivitySummaryModel? activitySummary;
  final CoursePlanEvent? coursePlan;

  final JoinRules? joinRule;
  final Map<String, int>? powerLevels;
  final Map<String, String> membershipSummary;
  final String? displayName;
  final String? avatarUrl;

  RoomSummaryResponse({
    required this.membershipSummary,
    this.activityPlan,
    this.activityRoles,
    this.activitySummary,
    this.coursePlan,
    this.joinRule,
    this.powerLevels,
    this.displayName,
    this.avatarUrl,
  });

  List<String> get adminUserIDs {
    if (powerLevels == null) return [];
    return powerLevels!.entries
        .where((entry) => entry.value >= 100)
        .map((entry) => entry.key)
        .toList();
  }

  Membership? getMembershipForUserId(String userId) {
    final membershipString = membershipSummary[userId];
    if (membershipString == null) return null;
    return Membership.values.firstWhere(
      (m) => m.name == membershipString,
      orElse: () => Membership.join,
    );
  }

  Map<String, ActivityRoleModel> get joinedUsersWithRoles {
    if (activityRoles == null) return {};
    return Map.fromEntries(
      activityRoles!.roles.entries.where(
        (role) => getMembershipForUserId(role.value.userId) == Membership.join,
      ),
    );
  }

  int get joinedMemberCount => membershipSummary.values
      .where((membership) => membership == Membership.join.name)
      .length;

  factory RoomSummaryResponse.fromJson(Map<String, dynamic> json) {
    final planEntry =
        json[PangeaEventTypes.activityPlan]?["default"]?["content"];
    ActivityPlanModel? plan;
    if (planEntry != null && planEntry is Map<String, dynamic>) {
      plan = ActivityPlanModel.fromJson(planEntry);
    }

    final rolesEntry =
        json[PangeaEventTypes.activityRole]?["default"]?["content"];
    ActivityRolesModel? roles;
    if (rolesEntry != null && rolesEntry is Map<String, dynamic>) {
      roles = ActivityRolesModel.fromJson(rolesEntry);
    }

    final summaryEntry =
        json[PangeaEventTypes.activitySummary]?["default"]?["content"];
    ActivitySummaryModel? summary;
    if (summaryEntry != null && summaryEntry is Map<String, dynamic>) {
      summary = ActivitySummaryModel.fromJson(summaryEntry);
    }

    final coursePlanEntry =
        json[PangeaEventTypes.coursePlan]?["default"]?["content"];
    CoursePlanEvent? coursePlan;
    if (coursePlanEntry != null && coursePlanEntry is Map<String, dynamic>) {
      coursePlan = CoursePlanEvent.fromJson(coursePlanEntry);
    }

    final powerLevelsEntry =
        json[EventTypes.RoomPowerLevels]?['default']?['content']?['users'];
    Map<String, int>? powerLevels;
    if (powerLevelsEntry != null) {
      powerLevels = Map<String, int>.from(powerLevelsEntry);
    }

    final joinRulesString =
        json[EventTypes.RoomJoinRules]?['default']?['content']?['join_rule'];
    JoinRules? joinRule;
    if (joinRulesString != null && joinRulesString is String) {
      joinRule = JoinRules.values.singleWhereOrNull(
        (element) => element.text == joinRulesString,
      );
    }

    final displayName =
        json[EventTypes.RoomName]?['default']?['content']?['name'] as String?;

    String? avatarUrl =
        json[EventTypes.RoomAvatar]?['default']?['content']?['url'] as String?;
    if (avatarUrl != null && Uri.tryParse(avatarUrl) == null) {
      avatarUrl = null;
    }

    return RoomSummaryResponse(
      activityPlan: plan,
      activityRoles: roles,
      activitySummary: summary,
      coursePlan: coursePlan,
      powerLevels: powerLevels,
      joinRule: joinRule,
      membershipSummary: Map<String, String>.from(
        json['membership_summary'] ?? {},
      ),
      displayName: displayName,
      avatarUrl: avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityPlan': activityPlan?.toJson(),
      'activityRoles': activityRoles?.toJson(),
      'activitySummary': activitySummary?.toJson(),
      'coursePlan': coursePlan?.toJson(),
      'joinRule': joinRule?.text,
      'powerLevels': powerLevels,
      'membershipSummary': membershipSummary,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };
  }
}
