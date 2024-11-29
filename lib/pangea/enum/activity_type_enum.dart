import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';

enum ActivityTypeEnum { wordMeaning, wordFocusListening, hiddenWordListening }

extension ActivityTypeExtension on ActivityTypeEnum {
  String get string {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
        return 'word_meaning';
      case ActivityTypeEnum.wordFocusListening:
        return 'word_focus_listening';
      case ActivityTypeEnum.hiddenWordListening:
        return 'hidden_word_listening';
    }
  }

  bool get hiddenType {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.wordFocusListening:
        return false;
      case ActivityTypeEnum.hiddenWordListening:
        return true;
    }
  }

  bool get includeTTSOnClick {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
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
    }
  }

  /// Filters out constructs that are not relevant to the activity type
  bool Function(ConstructIdentifier) get constructFilter {
    switch (this) {
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
        return (id) => id.type == ConstructTypeEnum.vocab;
    }
  }
}
