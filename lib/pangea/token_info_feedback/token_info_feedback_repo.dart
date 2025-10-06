import 'dart:convert';

import 'package:http/http.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';
import 'package:fluffychat/pangea/common/network/requests.dart';
import 'package:fluffychat/pangea/common/network/urls.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_request.dart';
import 'package:fluffychat/pangea/token_info_feedback/token_info_feedback_response.dart';
import 'package:fluffychat/widgets/matrix.dart';

class TokenInfoFeedbackRepo {
  /// Submit token info feedback for processing
  ///
  /// This method sends user feedback about token information to the server
  /// for evaluation and potential updates. The feedback is processed
  /// and may result in updated token data, lemma information, or phonetics.
  static Future<TokenInfoFeedbackResponse> submitFeedback(
    TokenInfoFeedbackRequest request,
  ) async {
    final Requests req = Requests(
      choreoApiKey: Environment.choreoApiKey,
      accessToken: MatrixState.pangeaController.userController.accessToken,
    );

    final Response res = await req.post(
      url: PApiUrls.tokenFeedback,
      body: request.toJson(),
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Failed to submit token info feedback: ${res.statusCode} ${res.body}',
      );
    }

    final decodedBody = jsonDecode(utf8.decode(res.bodyBytes));
    return TokenInfoFeedbackResponse.fromJson(decodedBody);
  }
}
