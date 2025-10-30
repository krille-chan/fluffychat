import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/activity_feedback/activity_feedback_request.dart';
import 'package:fluffychat/pangea/activity_feedback/activity_feedback_response.dart';
import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityFeedbackRepo {
  /// Submit activity feedback for processing
  ///
  /// This method sends user feedback about an activity to the server
  /// for evaluation and potential activity edits. The feedback is processed
  /// in the background and the response indicates whether edits will be made.
  static Future<ActivityFeedbackResponse> submitFeedback(
    ActivityFeedbackRequest request,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.activityFeedback,
      body: request.toJson(),
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Failed to submit activity feedback: ${res.statusCode} ${res.body}',
      );
    }

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    return ActivityFeedbackResponse.fromJson(decodedBody);
  }
}
