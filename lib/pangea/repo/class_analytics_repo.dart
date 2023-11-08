// import 'dart:convert';
// import 'dart:developer';

// import 'package:fluffychat/pangea/network/requests.dart';
// import 'package:fluffychat/pangea/utils/analytics_util.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart';

// import '../../config/environment.dart';
// import '../models/analytics_model_oldest.dart';
// import '../network/urls.dart';

class PClassAnalyticsRepo {
  /// deprecated in favor of new analytics
  static Future<dynamic> repoGetAnalyticsByIds(
      String accessToken, String timeSpan,
      {List<String>? classIds,
      List<String>? userIds,
      List<String>? chatIds}) async {
    // if (!AnalyticsUtil.isValidSpan(timeSpan)) throw "Invalid span";

    // final Requests req = Requests(
    //     accessToken: accessToken, choreoApiKey: Environment.choreoApiKey);

    // final body = {};
    // body["timespan"] = timeSpan;
    // if (classIds != null) body["class_ids"] = classIds;
    // if (chatIds != null) body["chat_ids"] = chatIds;
    // if (userIds != null) body["user_ids"] = userIds;

    // final Response res =
    //     await req.post(url: PApiUrls.classAnalytics, body: body);
    // final json = jsonDecode(res.body);

    // final Iterable<dynamic>? classJson = json["class_analytics"];
    // final Iterable<dynamic>? chatJson = json["chat_analytics"];
    // final Iterable<dynamic>? userJson = json["user_analytics"];

    // final classInfo = classJson != null
    //     ? (classJson)
    //         .map((e) {
    //           e["timespan"] = timeSpan;
    //           return chartAnalytics(e);
    //         })
    //         .toList()
    //         .cast<chartAnalytics>()
    //     : [];
    // final chatInfo = chatJson != null
    //     ? (chatJson)
    //         .map((e) {
    //           e["timespan"] = timeSpan;
    //           return chartAnalytics(e);
    //         })
    //         .toList()
    //         .cast<chartAnalytics>()
    //     : [];
    // final userInfo = userJson != null
    //     ? (userJson)
    //         .map((e) {
    //           e["timespan"] = timeSpan;
    //           return chartAnalytics(e);
    //         })
    //         .toList()
    //         .cast<chartAnalytics>()
    //     : [];

    // final List<chartAnalytics> allAnalytics = [
    //   ...classInfo,
    //   ...chatInfo,
    //   ...userInfo
    // ];
    // return allAnalytics;
  }
}
