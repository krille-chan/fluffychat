enum ActivityTypeEnum { multipleChoice, freeResponse, listening, speaking }

extension ActivityTypeExtension on ActivityTypeEnum {
  String get string {
    switch (this) {
      case ActivityTypeEnum.multipleChoice:
        return 'multiple_choice';
      case ActivityTypeEnum.freeResponse:
        return 'free_response';
      case ActivityTypeEnum.listening:
        return 'listening';
      case ActivityTypeEnum.speaking:
        return 'speaking';
    }
  }
}
