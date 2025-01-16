import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics/enums/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics/models/constructs_model.dart';
import 'package:fluffychat/pangea/analytics/repo/lemma_info_repo.dart';
import 'package:fluffychat/pangea/analytics/repo/lemma_info_request.dart';
import 'package:fluffychat/pangea/analytics/repo/lemma_info_response.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/models/message_activity_request.dart';
import 'package:fluffychat/pangea/toolbar/models/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaMeaningActivityGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
    BuildContext context,
  ) async {
    final ConstructIdentifier lemmaId = ConstructIdentifier(
      lemma: req.targetTokens[0].lemma.text.isNotEmpty
          ? req.targetTokens[0].lemma.text
          : req.targetTokens[0].lemma.form,
      type: ConstructTypeEnum.vocab,
      category: req.targetTokens[0].pos,
    );

    final lemmaDefReq = LemmaInfoRequest(
      lemma: lemmaId.lemma,
      partOfSpeech: lemmaId.category,
      // Note that this assumes that the user's L2 is the language of the lemma.
      lemmaLang: req.userL2,
      userL1: req.userL1,
    );

    final res = await LemmaInfoRepo.get(lemmaDefReq);

    final choices = await getDistractorMeanings(lemmaDefReq, 3);

    if (!choices.contains(res.meaning)) {
      choices.add(res.meaning);
      choices.shuffle();
    }

    return MessageActivityResponse(
      activity: PracticeActivityModel(
        tgtConstructs: [lemmaId],
        targetTokens: req.targetTokens,
        langCode: req.userL2,
        activityType: ActivityTypeEnum.wordMeaning,
        content: ActivityContent(
          question:
              L10n.of(context).whatIsMeaning(lemmaId.lemma, lemmaId.category),
          choices: choices,
          answers: [res.meaning],
          spanDisplayDetails: null,
        ),
      ),
    );
  }

  static List<OneConstructUse> eligibleDistractors(String lemma, String pos) {
    return MatrixState.pangeaController.getAnalytics.constructListModel.uses
        .where(
          (c) =>
              c.lemma.toLowerCase() != lemma.toLowerCase() &&
              c.category.toLowerCase() == pos.toLowerCase() &&
              c.constructType == ConstructTypeEnum.vocab,
        )
        .toList();
  }

  /// From the cache, get a random set of cached definitions that are not for a specific lemma
  static Future<List<String>> getDistractorMeanings(
    LemmaInfoRequest req,
    int count,
  ) async {
    final eligible = eligibleDistractors(req.lemma, req.partOfSpeech);
    eligible.shuffle();

    final List<OneConstructUse> distractorConstructUses =
        eligible.take(count).toList();

    final List<Future<LemmaInfoResponse>> futureDefs = [];
    for (final construct in distractorConstructUses) {
      futureDefs.add(
        LemmaInfoRepo.get(
          LemmaInfoRequest(
            lemma: construct.lemma,
            partOfSpeech: construct.category,
            lemmaLang: req.lemmaLang,
            userL1: req.userL1,
          ),
        ),
      );
    }

    final Set<String> distractorDefs = {};
    for (final def in await Future.wait(futureDefs)) {
      distractorDefs.add(def.meaning);
    }

    return distractorDefs.toList();
  }

  static bool canGenerateDistractors(String lemma, String pos) =>
      eligibleDistractors(lemma, pos).isNotEmpty;
}
