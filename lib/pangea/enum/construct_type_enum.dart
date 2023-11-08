enum ConstructType {
  grammar,
  vocab,
}

extension ConstructExtension on ConstructType {
  String get string {
    switch (this) {
      case ConstructType.grammar:
        return 'grammar';
      case ConstructType.vocab:
        return 'vocab';
    }
  }
}

class ConstructTypeUtil {
  static ConstructType fromString(String? string) {
    switch (string) {
      case 'g':
      case 'grammar':
        return ConstructType.grammar;
      case 'v':
      case 'vocab':
        return ConstructType.vocab;
      default:
        return ConstructType.vocab;
    }
  }
}
