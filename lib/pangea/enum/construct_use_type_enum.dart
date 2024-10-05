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

  /// selected correctly in word meaning in context practice activity
  corPA,

  /// encountered as distractor in word meaning in context practice activity and correctly ignored it
  /// Currently not used
  ignPA,

  /// was target construct in word meaning in context practice activity and incorrectly selected
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
      case ConstructUseTypeEnum.ignPA:
        return 'ignPA';
    }
  }

  IconData get icon {
    switch (this) {
      case ConstructUseTypeEnum.ga:
        return Icons.check;
      case ConstructUseTypeEnum.wa:
        return Icons.thumb_up_sharp;
      case ConstructUseTypeEnum.corIt:
        return Icons.translate;
      case ConstructUseTypeEnum.incIt:
        return Icons.translate;
      case ConstructUseTypeEnum.ignIt:
        return Icons.translate;
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
      case ConstructUseTypeEnum.ignPA:
        return Icons.close;
      case ConstructUseTypeEnum.unk:
        return Icons.help;
    }
  }

  /// Returns the point value for the construct use type
  /// This is used to calculate the both the total points for a user and per construct
  /// Users get slightly negative points for incorrect uses to encourage them to be more careful
  /// They get the most points for direct uses without help.
  /// They get a small amount of points for correct uses in interactions.
  /// Practice activities get a moderate amount of points.
  int get pointValue {
    switch (this) {
      case ConstructUseTypeEnum.ga:
        return 2;
      case ConstructUseTypeEnum.wa:
        return 3;
      case ConstructUseTypeEnum.corIt:
        return 1;
      case ConstructUseTypeEnum.incIt:
        return -1;
      case ConstructUseTypeEnum.ignIt:
        return 1;
      case ConstructUseTypeEnum.ignIGC:
        return 1;
      case ConstructUseTypeEnum.corIGC:
        return 2;
      case ConstructUseTypeEnum.incIGC:
        return -1;
      case ConstructUseTypeEnum.unk:
        return 0;
      case ConstructUseTypeEnum.corPA:
        return 5;
      case ConstructUseTypeEnum.incPA:
        return -2;
      case ConstructUseTypeEnum.ignPA:
        return 1;
    }
  }
}
