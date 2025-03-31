import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

typedef MorphActivitySequence = Map<String, POSActivitySequence>;

typedef POSActivitySequence = List<String>;

class MorphActivityGenerator {
  /// Generate a morphological activity for a given token and morphological feature
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
  ) async {
    debugger(when: kDebugMode && req.targetTokens.length != 1);

    debugger(when: kDebugMode && req.targetMorphFeature == null);

    final PangeaToken token = req.targetTokens.first;

    final MorphFeaturesEnum morphFeature = req.targetMorphFeature!;
    final String? morphTag = token.getMorphTag(morphFeature);

    if (morphTag == null) {
      debugger(when: kDebugMode);
      throw "No morph tag found for morph feature";
    }

    final List<String> distractors =
        token.morphActivityDistractors(morphFeature, morphTag);

    debugger(when: kDebugMode && distractors.length < 3);

    return MessageActivityResponse(
      activity: PracticeActivityModel(
        targetTokens: req.targetTokens,
        langCode: req.userL2,
        activityType: ActivityTypeEnum.morphId,
        morphFeature: req.targetMorphFeature,
        multipleChoiceContent: MultipleChoiceActivity(
          question: MatrixState.pangeaController.matrixState.context.mounted
              ? L10n.of(MatrixState.pangeaController.matrixState.context)
                  .whatIsTheMorphTag(
                  morphFeature.getDisplayCopy(
                    MatrixState.pangeaController.matrixState.context,
                  ),
                  token.text.content,
                )
              : morphFeature.name,
          choices: distractors + [morphTag],
          answers: [morphTag],
          spanDisplayDetails: null,
        ),
      ),
    );
  }
}
