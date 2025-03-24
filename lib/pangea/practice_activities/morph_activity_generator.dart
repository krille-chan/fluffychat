import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
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
      "X": [],
    },
  };

  /// Get the sequence of activities for a given part of speech
  /// The sequence is a list of morphological features that should be practiced
  /// in order for the given part of speech
  POSActivitySequence getSequence(String? langCode, String pos) {
    if (langCode == null || !sequence.containsKey(langCode)) {
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

    final List<String> distractors =
        token.morphActivityDistractors(morphFeature, morphTag);

    debugger(when: kDebugMode && distractors.length < 3);

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
          question: MatrixState.pangeaController.matrixState.context.mounted
              ? L10n.of(MatrixState.pangeaController.matrixState.context)
                  .whatIsTheMorphTag(
                  getMorphologicalCategoryCopy(
                        morphFeature,
                        MatrixState.pangeaController.matrixState.context,
                      ) ??
                      morphFeature,
                  token.text.content,
                )
              : morphFeature,
          choices: distractors + [morphTag],
          answers: [morphTag],
          spanDisplayDetails: null,
        ),
      ),
    );
  }
}
