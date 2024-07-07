enum ActivityDisplayInstructionsEnum { highlight, hide }

extension ActivityDisplayInstructionsEnumExt
    on ActivityDisplayInstructionsEnum {
  String get string {
    switch (this) {
      case ActivityDisplayInstructionsEnum.highlight:
        return 'highlight';
      case ActivityDisplayInstructionsEnum.hide:
        return 'hide';
    }
  }
}
