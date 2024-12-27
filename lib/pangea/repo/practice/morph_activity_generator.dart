import 'dart:developer';

import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';

typedef MorphActivitySequence = Map<String, POSActivitySequence>;

typedef POSActivitySequence = List<String>;

class MorphActivityGenerator {
  // TODO we want to define this on the server and have the client pull it down
  final Map<String, MorphActivitySequence> sequence = {
    "en": {
      "ADJ": ["AdvType", "Aspect"],
      "ADP": [],
      "ADV": [],
      "AUX": ["Tense", "Number"],
      "CCONJ": [],
      "DET": [],
      "NOUN": ["Number"],
      "NUM": [],
      "PRON": ["Number", "Person"],
      "SCONJ": [],
      "PUNCT": [],
      "VERB": ["Tense", "Aspect"],
    },
  };

  /// Get the sequence of activities for a given part of speech
  /// The sequence is a list of morphological features that should be practiced
  /// in order for the given part of speech
  Future<POSActivitySequence> getSequence(String langCode, String pos) async {
    if (!sequence.containsKey(langCode)) {
      langCode = "en";
    }
    final MorphActivitySequence morphActivitySequence = sequence[langCode]!;

    if (!morphActivitySequence.containsKey(pos)) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "No sequence defined",
        data: {"langCode": langCode, "pos": pos},
      );
      return [];
    }

    return morphActivitySequence[pos]!;
  }

  /// Generate a morphological activity for a given token and morphological feature
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
  ) async {
    debugger(when: kDebugMode && req.targetTokens.length != 1);

    debugger(when: kDebugMode && req.targetMorphFeature == null);

    final PangeaToken token = req.targetTokens.first;

    final String morphFeature = req.targetMorphFeature!;
    final String? morphTag = token.getMorphTag(morphFeature);

    if (morphTag == null) {
      debugger(when: kDebugMode);
      throw "No morph tag found for morph feature";
    }

    final List<String> distractors = MatrixState
        .pangeaController.getAnalytics.constructListModel
        .morphActivityDistractors(morphFeature, morphTag);

    return MessageActivityResponse(
      activity: PracticeActivityModel(
        tgtConstructs: [
          ConstructIdentifier(
            lemma: morphTag,
            type: ConstructTypeEnum.morph,
            category: morphFeature,
          ),
        ],
        targetTokens: req.targetTokens,
        langCode: req.userL2,
        activityType: ActivityTypeEnum.morphId,
        content: ActivityContent(
          question: "",
          choices: distractors + [morphTag],
          answers: [morphTag],
          spanDisplayDetails: null,
        ),
      ),
    );
  }
}
