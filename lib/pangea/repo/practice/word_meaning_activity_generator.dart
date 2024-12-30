import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/repo/lemma_definition_repo.dart';

class WordMeaningActivityGenerator {
  Future<MessageActivityResponse> get(
    MessageActivityRequest req,
  ) async {
    final ConstructIdentifier lemmaId = ConstructIdentifier(
      lemma: req.targetTokens[0].lemma.text,
      type: ConstructTypeEnum.vocab,
      category: req.targetTokens[0].pos,
    );

    final LemmaDefinitionRequest lemmaDefReq = LemmaDefinitionRequest(
      lemma: lemmaId.lemma,
      partOfSpeech: lemmaId.category,

      /// This assumes that the user's L2 is the language of the lemma
      lemmaLang: req.userL2,
      userL1: req.userL1,
    );

    final res = await LemmaDictionaryRepo.get(lemmaDefReq);

    final choices =
        LemmaDictionaryRepo.getDistractorDefinitions(lemmaDefReq, 3);

    return MessageActivityResponse(
      activity: PracticeActivityModel(
        tgtConstructs: [lemmaId],
        targetTokens: req.targetTokens,
        langCode: req.userL2,
        activityType: ActivityTypeEnum.wordMeaning,
        content: ActivityContent(
          question: "?",
          choices: choices,
          answers: [res.definition],
          spanDisplayDetails: null,
        ),
      ),
    );
  }
}
