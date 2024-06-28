import 'package:flutter/material.dart';

enum ConstructUseTypeEnum {
  /// produced in chat by user, igc was run, and we've judged it to be a correct use
  wa,

  /// produced in chat by user, igc was run, and we've judged it to be a incorrect use
  /// Note: if the IGC match is ignored, this is not counted as an incorrect use
  ga,

  /// produced in chat by user and igc was not run
  unk,

  /// selected correctly in IT flow
  corIt,

  /// encountered as IT distractor and correctly ignored it
  ignIt,

  /// encountered as it distractor and selected it
  incIt,

  /// encountered in igc match and ignored match
  ignIGC,

  /// selected correctly in IGC flow
  corIGC,

  /// encountered as distractor in IGC flow and selected it
  incIGC,

  /// selected correctly in practice activity flow
  corPA,

  /// was target construct in practice activity but user did not select correctly
  incPA,
}

extension ConstructUseTypeExtension on ConstructUseTypeEnum {
  String get string {
    switch (this) {
      case ConstructUseTypeEnum.ga:
        return 'ga';
      case ConstructUseTypeEnum.wa:
        return 'wa';
      case ConstructUseTypeEnum.corIt:
        return 'corIt';
      case ConstructUseTypeEnum.incIt:
        return 'incIt';
      case ConstructUseTypeEnum.ignIt:
        return 'ignIt';
      case ConstructUseTypeEnum.ignIGC:
        return 'ignIGC';
      case ConstructUseTypeEnum.corIGC:
        return 'corIGC';
      case ConstructUseTypeEnum.incIGC:
        return 'incIGC';
      case ConstructUseTypeEnum.unk:
        return 'unk';
      case ConstructUseTypeEnum.corPA:
        return 'corPA';
      case ConstructUseTypeEnum.incPA:
        return 'incPA';
    }
  }

  IconData get icon {
    switch (this) {
      case ConstructUseTypeEnum.ga:
        return Icons.check;
      case ConstructUseTypeEnum.wa:
        return Icons.thumb_up_sharp;
      case ConstructUseTypeEnum.corIt:
        return Icons.check;
      case ConstructUseTypeEnum.incIt:
        return Icons.close;
      case ConstructUseTypeEnum.ignIt:
        return Icons.close;
      case ConstructUseTypeEnum.ignIGC:
        return Icons.close;
      case ConstructUseTypeEnum.corIGC:
        return Icons.check;
      case ConstructUseTypeEnum.incIGC:
        return Icons.close;
      case ConstructUseTypeEnum.corPA:
        return Icons.check;
      case ConstructUseTypeEnum.incPA:
        return Icons.close;
      case ConstructUseTypeEnum.unk:
        return Icons.help;
    }
  }
}
