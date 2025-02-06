enum LanguageLevelTypeEnum { preA1, a1, a2, b1, b2, c1, c2 }

extension LanguageLevelTypeEnumExtension on LanguageLevelTypeEnum {
  // Makes enum a string
  String get string {
    switch (this) {
      case LanguageLevelTypeEnum.preA1:
        return 'PREA1';
      case LanguageLevelTypeEnum.a1:
        return 'A1';
      case LanguageLevelTypeEnum.a2:
        return 'A2';
      case LanguageLevelTypeEnum.b1:
        return 'B1';
      case LanguageLevelTypeEnum.b2:
        return 'B2';
      case LanguageLevelTypeEnum.c1:
        return 'C1';
      case LanguageLevelTypeEnum.c2:
        return 'C2';
    }
  }

  // Makes enum an int
  int get storageInt {
    switch (this) {
      case LanguageLevelTypeEnum.preA1:
        return 0;
      case LanguageLevelTypeEnum.a1:
        return 1;
      case LanguageLevelTypeEnum.a2:
        return 2;
      case LanguageLevelTypeEnum.b1:
        return 3;
      case LanguageLevelTypeEnum.b2:
        return 4;
      case LanguageLevelTypeEnum.c1:
        return 5;
      case LanguageLevelTypeEnum.c2:
        return 6;
    }
  }

  static LanguageLevelTypeEnum fromInt(int? value) {
    switch (value) {
      case 0:
        return LanguageLevelTypeEnum.preA1;
      case 1:
        return LanguageLevelTypeEnum.a1;
      case 2:
        return LanguageLevelTypeEnum.a2;
      case 3:
        return LanguageLevelTypeEnum.b1;
      case 4:
        return LanguageLevelTypeEnum.b2;
      case 5:
        return LanguageLevelTypeEnum.c1;
      case 6:
        return LanguageLevelTypeEnum.c2;
      default:
        return LanguageLevelTypeEnum.a1;
    }
  }

  static LanguageLevelTypeEnum fromString(String? value) {
    switch (value) {
      case 'PREA1':
      case 'PRE-A1':
      case 'Pre-A1':
        return LanguageLevelTypeEnum.preA1;
      case 'A1':
        return LanguageLevelTypeEnum.a1;
      case 'A2':
        return LanguageLevelTypeEnum.a2;
      case 'B1':
        return LanguageLevelTypeEnum.b1;
      case 'B2':
        return LanguageLevelTypeEnum.b2;
      case 'C1':
        return LanguageLevelTypeEnum.c1;
      case 'C2':
        return LanguageLevelTypeEnum.c2;
      default:
        return LanguageLevelTypeEnum.a1;
    }
  }
}
