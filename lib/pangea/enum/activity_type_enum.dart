enum ActivityTypeEnum {
  multipleChoice,
  wordFocusListening,
  hiddenWordListening
}

extension ActivityTypeExtension on ActivityTypeEnum {
  String get string {
    switch (this) {
      case ActivityTypeEnum.multipleChoice:
        return 'multiple_choice';
      case ActivityTypeEnum.wordFocusListening:
        return 'word_focus_listening';
      case ActivityTypeEnum.hiddenWordListening:
        return 'hidden_word_listening';
    }
  }

  ActivityTypeEnum fromString(String value) {
    final split = value.split('.').last;
    switch (split) {
      case 'multiple_choice':
      case 'multipleChoice':
        return ActivityTypeEnum.multipleChoice;
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
}
