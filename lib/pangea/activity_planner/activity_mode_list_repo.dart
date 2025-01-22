import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/activity_planner/list_request_schema.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../common/network/requests.dart';

class ActivityModeListRepo {
  static final GetStorage _modeListStorage = GetStorage('mode_list_storage');

  static void set(
    ActivitySettingRequestSchema request,
    List<ActivitySettingResponseSchema> response,
  ) {
    _modeListStorage.write(
      request.storageKey,
      response.map((e) => e.toJson()).toList(),
    );
  }

  static List<ActivitySettingResponseSchema> fromJson(Iterable json) {
    return List<ActivitySettingResponseSchema>.from(
      json.map((x) => ActivitySettingResponseSchema.fromJson(x)),
    );
  }

  static Future<List<ActivitySettingResponseSchema>> get(
    ActivitySettingRequestSchema request,
  ) async {
    final cachedJson = _modeListStorage.read(request.storageKey);
    if (cachedJson != null) {
      return ActivityModeListRepo.fromJson(cachedJson);
    }

    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.activityModeList,
      body: request.toJson(),
    );

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    final response = ActivityModeListRepo.fromJson(decodedBody);

    set(request, response);

    return response;
  }
}
