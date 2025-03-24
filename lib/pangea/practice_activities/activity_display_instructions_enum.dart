enum ActivityDisplayInstructionsEnum { highlight, hide, nothing }

extension ActivityDisplayInstructionsEnumExt
    on ActivityDisplayInstructionsEnum {
  String get string => toString().split('.').last;
}
