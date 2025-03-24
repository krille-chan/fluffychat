import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/lemmas/lemma.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/practice_activities/message_activity_request.dart';
import 'package:fluffychat/pangea/practice_activities/multiple_choice_activity_model.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';

final wordMeaningStaticPracticeActivityModel = MessageActivityResponse(
  activity: PracticeActivityModel(
    tgtConstructs: [
      ConstructIdentifier(
        type: ConstructTypeEnum.vocab,
        lemma: 'example',
        category: 'noun',
      ),
    ],
    targetTokens: [
      PangeaToken(
        text: PangeaTokenText(content: 'Cómo', offset: 0, length: 4),
        lemma: Lemma(text: 'cómo', saveVocab: true, form: 'cómo'),
        pos: 'ADV',
        morph: {
          'PronType': 'Int',
        },
      ),
      PangeaToken(
        text: PangeaTokenText(content: 'estás', offset: 5, length: 5),
        lemma: Lemma(text: 'estar', saveVocab: true, form: 'estás'),
        pos: 'VERB',
        morph: {
          'Mood': 'Ind',
          'Tense': 'Pres',
          'VerbForm': 'Fin',
          'Number': 'Sing',
          'Person': '2',
        },
      ),
      PangeaToken(
        text: PangeaTokenText(content: '?', offset: 10, length: 1),
        lemma: Lemma(text: '?', saveVocab: false, form: '?'),
        pos: 'PUNCT',
        morph: {
          'PunctType': 'Peri',
        },
      ),
    ],
    langCode: 'en',
    activityType: ActivityTypeEnum.messageMeaning,
    content: ActivityContent(
      question: 'What is the meaning of the message?',
      choices: ['How are you?', 'What is your name?'],
      answers: ['How are you?'],
      spanDisplayDetails: null,
    ),
  ),
);
