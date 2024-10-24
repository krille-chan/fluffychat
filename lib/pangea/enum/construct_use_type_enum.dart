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

  /// was target lemma in word-focus listening activity and correctly selected
  corWL,

  /// form of lemma was read-aloud in word-focus listening activity and incorrectly selected
  incWL,

  /// form of lemma was read-aloud in word-focus listening activity and correctly ignored
  ignWL,

  /// not defined, likely a new construct introduced by choreo and not yet classified by an old version of the client
  nan
}

extension ConstructUseTypeExtension on ConstructUseTypeEnum {
  String get string => toString().split('.').last;

  IconData get icon {
    switch (this) {
      case ConstructUseTypeEnum.wa:
        return Icons.thumb_up_sharp;

      case ConstructUseTypeEnum.corIt:
      case ConstructUseTypeEnum.incIt:
      case ConstructUseTypeEnum.ignIt:
        return Icons.translate;

      case ConstructUseTypeEnum.ignIGC:
      case ConstructUseTypeEnum.incIGC:
      case ConstructUseTypeEnum.incPA:
      case ConstructUseTypeEnum.ignPA:
      case ConstructUseTypeEnum.ignWL:
      case ConstructUseTypeEnum.incWL:
        return Icons.close;

      case ConstructUseTypeEnum.ga:
      case ConstructUseTypeEnum.corIGC:
      case ConstructUseTypeEnum.corPA:
      case ConstructUseTypeEnum.corWL:
        return Icons.check;

      case ConstructUseTypeEnum.unk:
      case ConstructUseTypeEnum.nan:
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
      case ConstructUseTypeEnum.corPA:
        return 5;

      case ConstructUseTypeEnum.wa:
      case ConstructUseTypeEnum.corWL:
        return 3;

      case ConstructUseTypeEnum.ga:
      case ConstructUseTypeEnum.corIGC:
        return 2;

      case ConstructUseTypeEnum.corIt:
      case ConstructUseTypeEnum.ignIt:
      case ConstructUseTypeEnum.ignIGC:
      case ConstructUseTypeEnum.ignPA:
      case ConstructUseTypeEnum.ignWL:
        return 1;

      case ConstructUseTypeEnum.unk:
      case ConstructUseTypeEnum.nan:
        return 0;

      case ConstructUseTypeEnum.incIt:
      case ConstructUseTypeEnum.incIGC:
        return -1;

      case ConstructUseTypeEnum.incPA:
      case ConstructUseTypeEnum.incWL:
        return -2;
    }
  }
}

class ConstructUseTypeUtil {
  static ConstructUseTypeEnum fromString(String value) {
    return ConstructUseTypeEnum.values.firstWhere(
      (e) => e.string == value,
      orElse: () => ConstructUseTypeEnum.nan,
    );
  }
}
