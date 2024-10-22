enum ActivityTypeEnum { multipleChoice, wordFocusListening }

extension ActivityTypeExtension on ActivityTypeEnum {
  String get string {
    switch (this) {
      case ActivityTypeEnum.multipleChoice:
        return 'multiple_choice';
      case ActivityTypeEnum.wordFocusListening:
        return 'word_focus_listening';
    }
  }
}
