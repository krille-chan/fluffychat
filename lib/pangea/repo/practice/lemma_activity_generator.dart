import 'dart:developer';

import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';

class LemmaActivityGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
  ) async {
    debugger(when: kDebugMode && req.targetTokens.length != 1);

    final token = req.targetTokens.first;
    final List<String> choices = await MatrixState
        .pangeaController.getAnalytics.constructListModel
        .lemmaActivityDistractors(token);

    // TODO - modify MultipleChoiceActivity flow to allow no correct answer
    return MessageActivityResponse(
      activity: PracticeActivityModel(
        activityType: ActivityTypeEnum.lemmaId,
        targetTokens: [token],
        tgtConstructs: [token.vocabConstructID],
        langCode: req.userL2,
        content: ActivityContent(
          question: "",
          choices: choices,
          answers: [token.lemma.text],
          spanDisplayDetails: null,
        ),
      ),
    );
  }
}
