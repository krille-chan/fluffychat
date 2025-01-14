import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/pangea/analytics/enums/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics/enums/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/models/practice_activity_model.dart';

enum ActivityTypeEnum {
  wordMeaning,
  wordFocusListening,
  hiddenWordListening,
  lemmaId,
  emoji,
  morphId
}

extension ActivityTypeExtension on ActivityTypeEnum {
  String get string {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
        return 'word_meaning';
      case ActivityTypeEnum.wordFocusListening:
        return 'word_focus_listening';
      case ActivityTypeEnum.hiddenWordListening:
        return 'hidden_word_listening';
      case ActivityTypeEnum.lemmaId:
        return 'lemma_id';
      case ActivityTypeEnum.emoji:
        return 'emoji';
      case ActivityTypeEnum.morphId:
        return 'morph_id';
    }
  }

  bool get hiddenType {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.lemmaId:
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.morphId:
        return false;
      case ActivityTypeEnum.hiddenWordListening:
        return true;
    }
  }

  bool get includeTTSOnClick {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.lemmaId:
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.morphId:
        return false;
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
        return true;
    }
  }

  ActivityTypeEnum fromString(String value) {
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
    }
  }

  /// Filters out constructs that are not relevant to the activity type
  bool Function(ConstructIdentifier) get constructFilter {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
      case ActivityTypeEnum.lemmaId:
      case ActivityTypeEnum.emoji:
        return (id) => id.type == ConstructTypeEnum.vocab;
      case ActivityTypeEnum.morphId:
        return (id) => id.type == ConstructTypeEnum.morph;
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
        return Icons.translate;
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
        return Icons.hearing;
      case ActivityTypeEnum.lemmaId:
        return Symbols.dictionary;
      case ActivityTypeEnum.emoji:
        return Icons.emoji_emotions;
      case ActivityTypeEnum.morphId:
        return Icons.format_shapes;
    }
  }
}
