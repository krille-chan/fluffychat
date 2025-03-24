import 'dart:async';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_repo.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';
import 'package:fluffychat/pangea/word_bank/vocab_bank_repo.dart';
import 'package:fluffychat/pangea/word_bank/vocab_request.dart';
import 'package:fluffychat/widgets/matrix.dart';

class LemmaMeaningActivityGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
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
          question: L10n.of(MatrixState.pangeaController.matrixState.context)
              .whatIsMeaning(lemmaId.lemma, lemmaId.category),
          choices: choices,
          answers: [res.meaning],
          spanDisplayDetails: null,
        ),
      ),
    );
  }

  /// From the cache, get a random set of cached definitions that are not for a specific lemma
  static Future<List<String>> getDistractorMeanings(
    LemmaInfoRequest req,
    int count,
  ) async {
    final eligible = await VocabRepo.getSemanticallySimilarWords(
      VocabRequest(
        langCode: req.lemmaLang,
        level: MatrixState
            .pangeaController.userController.profile.userSettings.cefrLevel,
        lemma: req.lemma,
        pos: req.partOfSpeech,
        count: count,
      ),
    );
    eligible.vocab.shuffle();

    final List<ConstructIdentifier> distractorConstructUses =
        eligible.vocab.take(count).toList();

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
}
