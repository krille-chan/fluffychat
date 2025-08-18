import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityPlanRepo {
  static final GetStorage _activityPlanStorage =
      GetStorage('activity_plan_by_id_storage');

  static ActivityPlanModel? getCached(String id) {
    final cachedJson = _activityPlanStorage.read(id);
    if (cachedJson == null) return null;

    try {
      return ActivityPlanModel.fromJson(cachedJson);
    } catch (e) {
      _removeCached(id);
      return null;
    }
  }

  static Future<void> _setCached(ActivityPlanModel response) =>
      _activityPlanStorage.write(response.bookmarkId, response.toJson());

  static Future<void> _removeCached(String id) =>
      _activityPlanStorage.remove(id);

  static Future<void> set(ActivityPlanModel activity) => _setCached(activity);

  static Future<ActivityPlanModel> get(String id) async {
    final cached = getCached(id);
    if (cached != null) return cached;

    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.get(
      url: "${PApiUrls.activityPlan}/$id",
    );

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    final response = ActivityPlanModel.fromJson(decodedBody["plan"]);

    _setCached(response);
    return response;
  }

  static Future<ActivityPlanModel> update(
    ActivityPlanModel update,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.patch(
      url: "${PApiUrls.activityPlan}/${update.bookmarkId}",
      body: update.toJson(),
    );

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    final response = ActivityPlanModel.fromJson(decodedBody["plan"]);

    _removeCached(update.bookmarkId);
    _setCached(response);

    return response;
  }

  static Future<void> remove(String id) => _removeCached(id);
}
