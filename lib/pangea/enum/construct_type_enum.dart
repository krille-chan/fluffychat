enum ConstructTypeEnum {
  grammar,
  vocab,
}

extension ConstructExtension on ConstructTypeEnum {
  String get string {
    switch (this) {
      case ConstructTypeEnum.grammar:
        return 'grammar';
      case ConstructTypeEnum.vocab:
        return 'vocab';
    }
  }
}

class ConstructTypeUtil {
  static ConstructTypeEnum fromString(String? string) {
    switch (string) {
      case 'g':
      case 'grammar':
        return ConstructTypeEnum.grammar;
      case 'v':
      case 'vocab':
        return ConstructTypeEnum.vocab;
      default:
        return ConstructTypeEnum.vocab;
    }
  }
}
