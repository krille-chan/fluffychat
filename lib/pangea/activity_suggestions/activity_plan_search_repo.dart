// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart';

// import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
// import 'package:fluffychat/pangea/activity_planner/activity_plan_response.dart';
// import 'package:fluffychat/pangea/common/config/environment.dart';
// import 'package:fluffychat/pangea/common/network/requests.dart';
// import 'package:fluffychat/pangea/common/network/urls.dart';
// import 'package:fluffychat/widgets/matrix.dart';

// class ActivitySearchRepo {
//   static final GetStorage _activityPlanStorage =
//       GetStorage('activity_plan_search_storage');

//   static void set(
//     String storageKey,
//     ActivityPlanResponseWrapper wrappedResponse,
//   ) {
//     _activityPlanStorage.write(storageKey, wrappedResponse.toJson());
//   }

//   static Future<ActivityPlanResponseWrapper> get(
//     ActivityPlanRequest request,
//   ) async {
//     final storageKey = "${request.storageKey}_wrapper";
//     final cachedJson = _activityPlanStorage.read(storageKey);
//     if (cachedJson != null) {
//       ActivityPlanResponseWrapper? cached;
//       try {
//         cached = ActivityPlanResponseWrapper.fromJson(cachedJson);
//       } catch (e) {
//         _activityPlanStorage.remove(storageKey);
//       }

//       if (cached is ActivityPlanResponseWrapper) {
//         return cached;
//       }
//     }

//     final Requests req = Requests(
//       choreoApiKey: Environment.choreoApiKey,
//       accessToken: MatrixState.pangeaController.userController.accessToken,
//     );

//     Response? res;
//     try {
//       res = await req.post(
//         url: PApiUrls.activityPlanSearch,
//         body: request.toJson(),
//       );
//     } catch (err) {
//       debugPrint("err: $err, err is http response: ${err is Response}");
//       if (err is Response) {
//         return ActivityPlanResponseWrapper(
//           response: ActivityPlanResponse(activityPlans: []),
//           statusCode: err.statusCode,
//         );
//       }
//     }

//     final decodedBody = jsonDecode(utf8.decode(res!.bodyBytes));
//     final response = ActivityPlanResponse.fromJson(decodedBody);
//     final wrappedResponse = ActivityPlanResponseWrapper(
//       response: response,
//       statusCode: res.statusCode,
//     );

//     if (res.statusCode == 200) {
//       set(storageKey, wrappedResponse);
//     }

//     return wrappedResponse;
//   }
// }

// class ActivityPlanResponseWrapper {
//   final ActivityPlanResponse response;
//   final int statusCode;

//   ActivityPlanResponseWrapper({
//     required this.response,
//     required this.statusCode,
//   });

//   factory ActivityPlanResponseWrapper.fromJson(Map<String, dynamic> json) {
//     return ActivityPlanResponseWrapper(
//       response: json['activity_plan_response'].fromJson,
//       statusCode: json['activity_response_status'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'activity_plan_response': response.toJson(),
//       'activity_response_status': statusCode,
//     };
//   }
// }
