import 'dart:convert';

import 'package:http/http.dart' hide Client;
import 'package:matrix/matrix.dart';
import 'package:matrix/matrix_api_lite/generated/api.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_roles_model.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';

extension RoomSummaryExtension on Api {
  Future<RoomSummariesResponse> getRoomSummaries(List<String> roomIds) async {
    final requestUri = Uri(
      path: '/_synapse/client/unstable/org.pangea/room_preview',
      queryParameters: {
        'rooms': roomIds.join(","),
      },
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

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    summaries.forEach((key, value) {
      json[key] = value.toJson();
    });
    return json;
  }
}

class RoomSummaryResponse {
  final ActivityPlanModel activityPlan;
  final ActivityRolesModel activityRoles;

  RoomSummaryResponse({
    required this.activityPlan,
    required this.activityRoles,
  });

  factory RoomSummaryResponse.fromJson(Map<String, dynamic> json) {
    return RoomSummaryResponse(
      activityPlan: ActivityPlanModel.fromJson(
        json[PangeaEventTypes.activityPlan]?["default"]?["content"] ?? {},
      ),
      activityRoles: ActivityRolesModel.fromJson(
        json[PangeaEventTypes.activityRole]?["default"]?["content"] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PangeaEventTypes.activityPlan: activityPlan.toJson(),
      PangeaEventTypes.activityRole: activityRoles.toJson(),
    };
  }
}
