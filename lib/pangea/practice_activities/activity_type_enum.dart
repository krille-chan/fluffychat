import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';

enum ActivityTypeEnum {
  wordMeaning,
  wordFocusListening,
  hiddenWordListening,
  lemmaId,
  emoji,
  morphId,
  messageMeaning,
  lemmaMeaning,
  lemmaAudio,
  grammarCategory,
  grammarError;

  bool get includeTTSOnClick {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.lemmaId:
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.morphId:
      case ActivityTypeEnum.messageMeaning:
        return false;
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
      case ActivityTypeEnum.lemmaAudio:
      case ActivityTypeEnum.lemmaMeaning:
      case ActivityTypeEnum.grammarCategory:
      case ActivityTypeEnum.grammarError:
        return true;
    }
  }

  static ActivityTypeEnum fromString(String value) {
    final split = value.split('.').last;
    switch (split) {
      // used to be called multiple_choice, but we changed it to word_meaning
      // as we now have multiple types of multiple choice activities
      // old data will still have multiple_choice so we need to handle that
      case 'multiple_choice':
      case 'multipleChoice':
      case 'word_meaning':
      case 'wordMeaning':
        return ActivityTypeEnum.wordMeaning;
      case 'word_focus_listening':
      case 'wordFocusListening':
        return ActivityTypeEnum.wordFocusListening;
      case 'hidden_word_listening':
      case 'hiddenWordListening':
        return ActivityTypeEnum.hiddenWordListening;
      case 'lemma_id':
        return ActivityTypeEnum.lemmaId;
      case 'emoji':
        return ActivityTypeEnum.emoji;
      case 'morph_id':
        return ActivityTypeEnum.morphId;
      case 'message_meaning':
        return ActivityTypeEnum.messageMeaning; // TODO: Add to L10n
      case 'lemma_meaning':
      case 'lemmaMeaning':
        return ActivityTypeEnum.lemmaMeaning;
      case 'lemma_audio':
      case 'lemmaAudio':
        return ActivityTypeEnum.lemmaAudio;
      case 'grammar_category':
      case 'grammarCategory':
        return ActivityTypeEnum.grammarCategory;
      case 'grammar_error':
      case 'grammarError':
        return ActivityTypeEnum.grammarError;
      default:
        throw Exception('Unknown activity type: $split');
    }
  }

  List<ConstructUseTypeEnum> get associatedUseTypes {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
        return [
          ConstructUseTypeEnum.corPA,
          ConstructUseTypeEnum.incPA,
          ConstructUseTypeEnum.ignPA,
        ];
      case ActivityTypeEnum.wordFocusListening:
        return [
          ConstructUseTypeEnum.corWL,
          ConstructUseTypeEnum.incWL,
          ConstructUseTypeEnum.ignWL,
        ];
      case ActivityTypeEnum.hiddenWordListening:
        return [
          ConstructUseTypeEnum.corHWL,
          ConstructUseTypeEnum.incHWL,
          ConstructUseTypeEnum.ignHWL,
        ];
      case ActivityTypeEnum.lemmaId:
        return [
          ConstructUseTypeEnum.corL,
          ConstructUseTypeEnum.incL,
          ConstructUseTypeEnum.ignL,
        ];
      case ActivityTypeEnum.emoji:
        return [ConstructUseTypeEnum.em];
      case ActivityTypeEnum.morphId:
        return [
          ConstructUseTypeEnum.corM,
          ConstructUseTypeEnum.incM,
          ConstructUseTypeEnum.ignM,
        ];
      case ActivityTypeEnum.messageMeaning:
        return [
          ConstructUseTypeEnum.corMM,
          ConstructUseTypeEnum.incMM,
          ConstructUseTypeEnum.ignMM,
        ];
      case ActivityTypeEnum.lemmaAudio:
        return [ConstructUseTypeEnum.corLA, ConstructUseTypeEnum.incLA];
      case ActivityTypeEnum.lemmaMeaning:
        return [ConstructUseTypeEnum.corLM, ConstructUseTypeEnum.incLM];
      case ActivityTypeEnum.grammarCategory:
        return [ConstructUseTypeEnum.corGC, ConstructUseTypeEnum.incGC];
      case ActivityTypeEnum.grammarError:
        return [ConstructUseTypeEnum.corGE, ConstructUseTypeEnum.incGE];
    }
  }

  ConstructUseTypeEnum get correctUse {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
        return ConstructUseTypeEnum.corPA;
      case ActivityTypeEnum.wordFocusListening:
        return ConstructUseTypeEnum.corWL;
      case ActivityTypeEnum.hiddenWordListening:
        return ConstructUseTypeEnum.corHWL;
      case ActivityTypeEnum.lemmaId:
        return ConstructUseTypeEnum.corL;
      case ActivityTypeEnum.emoji:
        return ConstructUseTypeEnum.em;
      case ActivityTypeEnum.morphId:
        return ConstructUseTypeEnum.corM;
      case ActivityTypeEnum.messageMeaning:
        return ConstructUseTypeEnum.corMM;
      case ActivityTypeEnum.lemmaAudio:
        return ConstructUseTypeEnum.corLA;
      case ActivityTypeEnum.lemmaMeaning:
        return ConstructUseTypeEnum.corLM;
      case ActivityTypeEnum.grammarCategory:
        return ConstructUseTypeEnum.corGC;
      case ActivityTypeEnum.grammarError:
        return ConstructUseTypeEnum.corGE;
    }
  }

  ConstructUseTypeEnum get incorrectUse {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
        return ConstructUseTypeEnum.incPA;
      case ActivityTypeEnum.wordFocusListening:
        return ConstructUseTypeEnum.incWL;
      case ActivityTypeEnum.hiddenWordListening:
        return ConstructUseTypeEnum.incHWL;
      case ActivityTypeEnum.lemmaId:
        return ConstructUseTypeEnum.incL;
      case ActivityTypeEnum.emoji:
        return ConstructUseTypeEnum.em;
      case ActivityTypeEnum.morphId:
        return ConstructUseTypeEnum.incM;
      case ActivityTypeEnum.messageMeaning:
        return ConstructUseTypeEnum.incMM;
      case ActivityTypeEnum.lemmaAudio:
        return ConstructUseTypeEnum.incLA;
      case ActivityTypeEnum.lemmaMeaning:
        return ConstructUseTypeEnum.incLM;
      case ActivityTypeEnum.grammarCategory:
        return ConstructUseTypeEnum.incGC;
      case ActivityTypeEnum.grammarError:
        return ConstructUseTypeEnum.incGE;
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.lemmaMeaning:
        return Icons.translate;
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
      case ActivityTypeEnum.lemmaAudio:
        return Icons.volume_up;
      case ActivityTypeEnum.lemmaId:
        return Symbols.dictionary;
      case ActivityTypeEnum.emoji:
        return Icons.emoji_emotions;
      case ActivityTypeEnum.morphId:
        return Icons.format_shapes;
      case ActivityTypeEnum.messageMeaning:
      case ActivityTypeEnum.grammarCategory:
      case ActivityTypeEnum.grammarError:
        return Icons.star; // TODO: Add to L10n
    }
  }

  /// The minimum number of tokens in a message for this activity type to be available.
  /// Matching activities don't make sense for a single-word message.
  int get minTokensForMatchActivity {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.lemmaId:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.emoji:
        return 2;
      case ActivityTypeEnum.hiddenWordListening:
      case ActivityTypeEnum.morphId:
      case ActivityTypeEnum.messageMeaning:
      case ActivityTypeEnum.lemmaMeaning:
      case ActivityTypeEnum.lemmaAudio:
      case ActivityTypeEnum.grammarCategory:
      case ActivityTypeEnum.grammarError:
        return 1;
    }
  }

  static List<ActivityTypeEnum> get practiceTypes => [
    ActivityTypeEnum.emoji,
    ActivityTypeEnum.wordMeaning,
    ActivityTypeEnum.wordFocusListening,
    ActivityTypeEnum.morphId,
  ];

  static List<ActivityTypeEnum> get _vocabPracticeTypes => [
    ActivityTypeEnum.lemmaMeaning,
    ActivityTypeEnum.lemmaAudio,
  ];

  static List<ActivityTypeEnum> get _grammarPracticeTypes => [
    ActivityTypeEnum.grammarCategory,
    ActivityTypeEnum.grammarError,
  ];

  static List<ActivityTypeEnum> analyticsPracticeTypes(
    ConstructTypeEnum constructType,
  ) {
    switch (constructType) {
      case ConstructTypeEnum.vocab:
        return _vocabPracticeTypes;
      case ConstructTypeEnum.morph:
        return _grammarPracticeTypes;
    }
  }

  /// The type of construct uses that these activities produce.
  /// NOTE: Grammar error activities create vocab uses, assosiated with the tokens in the
  /// targeted error span – NOT morph uses.
  ConstructTypeEnum get constructUsesType {
    switch (this) {
      case ActivityTypeEnum.grammarCategory:
      case ActivityTypeEnum.morphId:
        return ConstructTypeEnum.morph;
      default:
        return ConstructTypeEnum.vocab;
    }
  }
}
