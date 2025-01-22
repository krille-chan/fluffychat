import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import 'package:fluffychat/pangea/activity_planner/media_enum.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../common/network/requests.dart';

class ActivityPlanRequest {
  final String topic;
  final String mode;
  final String objective;
  final MediaEnum media;
  final int cefrLevel;
  final String languageOfInstructions;
  final String targetLanguage;
  final int count;

  ActivityPlanRequest({
    required this.topic,
    required this.mode,
    required this.objective,
    required this.media,
    required this.cefrLevel,
    required this.languageOfInstructions,
    required this.targetLanguage,
    this.count = 3,
  });

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'mode': mode,
      'objective': objective,
      'media': media.string,
      'cefr_level': cefrLanguageLevel,
      'language_of_instructions': languageOfInstructions,
      'target_language': targetLanguage,
      'count': count,
    };
  }

  String get storageKey =>
      '$topic-$mode-$objective-${media.string}-$cefrLevel-$languageOfInstructions-$targetLanguage';

  String get cefrLanguageLevel {
    switch (cefrLevel) {
      case 0:
        return 'Pre-A1';
      case 1:
        return 'A1';
      case 2:
        return 'A2';
      case 3:
        return 'B1';
      case 4:
        return 'B2';
      case 5:
        return 'C1';
      case 6:
        return 'C2';
      default:
        return 'Pre-A1';
    }
  }
}

class ActivityPlanResponse {
  final List<String> activityPlans;

  ActivityPlanResponse({required this.activityPlans});

  factory ActivityPlanResponse.fromJson(Map<String, dynamic> json) {
    return ActivityPlanResponse(
      activityPlans: List<String>.from(json['activity_plans']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_plans': activityPlans,
    };
  }
}

class ActivityPlanGenerationRepo {
  static final GetStorage _activityPlanStorage =
      GetStorage('activity_plan_storage');

  static void set(ActivityPlanRequest request, ActivityPlanResponse response) {
    _activityPlanStorage.write(request.storageKey, response.toJson());
  }

  static Future<ActivityPlanResponse> get(ActivityPlanRequest request) async {
    final cachedJson = _activityPlanStorage.read(request.storageKey);
    if (cachedJson != null) {
      final cached = ActivityPlanResponse.fromJson(cachedJson);

      return cached;
    }

    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.activityPlanGeneration,
      body: request.toJson(),
    );

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    final response = ActivityPlanResponse.fromJson(decodedBody);

    set(request, response);

    return response;
  }
}
