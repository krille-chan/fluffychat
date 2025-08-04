import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/activity_summary/activity_summary_request_model.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_response_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivitySummaryRepo {
  static final GetStorage _activitySummaryStorage =
      GetStorage('activity_summary_storage');

  static void set(
    ActivitySummaryRequestModel request,
    ActivitySummaryResponseModel response,
  ) {
    _activitySummaryStorage.write(_storageKey(request), response.toJson());
  }

  static String _storageKey(ActivitySummaryRequestModel request) {
    // You may want to customize this key based on request fields
    return request.activity.hashCode.toString();
  }

  static Future<ActivitySummaryResponseModel> get(
    ActivitySummaryRequestModel request,
  ) async {
    final cachedJson = _activitySummaryStorage.read(_storageKey(request));
    if (cachedJson != null) {
      final cached = ActivitySummaryResponseModel.fromJson(cachedJson);
      return cached;
    }

    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.activitySummary,
      body: request.toJson(),
    );

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    final response = ActivitySummaryResponseModel.fromJson(decodedBody);

    set(request, response);

    return response;
  }
}
