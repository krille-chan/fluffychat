import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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

  /// a form of lemma was read-aloud in word-focus listening activity and incorrectly selected
  incWL,

  /// a form of the lemma was read-aloud in word-focus listening activity and correctly ignored
  ignWL,

  /// correctly chose a form of the lemma in a hidden word listening activity
  corHWL,

  /// incorrectly chose a form of the lemma in a hidden word listening activity
  incHWL,

  /// ignored a form of the lemma in a hidden word listening activity
  ignHWL,

  /// not defined, likely a new construct introduced by choreo and not yet classified by an old version of the client
  nan
}

extension ConstructUseTypeExtension on ConstructUseTypeEnum {
  String get string => toString().split('.').last;

  String description(BuildContext context) {
    switch (this) {
      case ConstructUseTypeEnum.wa:
        return L10n.of(context).constructUseWaDesc;
      case ConstructUseTypeEnum.ga:
        return L10n.of(context).constructUseGaDesc;
      case ConstructUseTypeEnum.unk:
        return L10n.of(context).constructUseUnkDesc;
      case ConstructUseTypeEnum.corIt:
        return L10n.of(context).constructUseCorITDesc;
      case ConstructUseTypeEnum.ignIt:
        return L10n.of(context).constructUseIgnITDesc;
      case ConstructUseTypeEnum.incIt:
        return L10n.of(context).constructUseIncITDesc;
      case ConstructUseTypeEnum.ignIGC:
        return L10n.of(context).constructUseIgnIGCDesc;
      case ConstructUseTypeEnum.corIGC:
        return L10n.of(context).constructUseCorIGCDesc;
      case ConstructUseTypeEnum.incIGC:
        return L10n.of(context).constructUseIncIGCDesc;
      case ConstructUseTypeEnum.corPA:
        return L10n.of(context).constructUseCorPADesc;
      case ConstructUseTypeEnum.ignPA:
        return L10n.of(context).constructUseIgnPADesc;
      case ConstructUseTypeEnum.incPA:
        return L10n.of(context).constructUseIncPADesc;
      case ConstructUseTypeEnum.corWL:
        return L10n.of(context).constructUseCorWLDesc;
      case ConstructUseTypeEnum.incWL:
        return L10n.of(context).constructUseIncWLDesc;
      case ConstructUseTypeEnum.ignWL:
        return L10n.of(context).constructUseIngWLDesc;
      case ConstructUseTypeEnum.corHWL:
        return L10n.of(context).constructUseCorHWLDesc;
      case ConstructUseTypeEnum.incHWL:
        return L10n.of(context).constructUseIncHWLDesc;
      case ConstructUseTypeEnum.ignHWL:
        return L10n.of(context).constructUseIgnHWLDesc;
      case ConstructUseTypeEnum.nan:
        return L10n.of(context).constructUseNanDesc;
    }
  }

  IconData get icon {
    switch (this) {
      // all minus for wrong answer
      case ConstructUseTypeEnum.incIt:
      case ConstructUseTypeEnum.incIGC:
      case ConstructUseTypeEnum.incPA:
      case ConstructUseTypeEnum.incWL:
      case ConstructUseTypeEnum.incHWL:
        return Icons.dangerous_outlined;

      // correct in word meaning
      case ConstructUseTypeEnum.corPA:
        return Icons.add_task_outlined;

      // correct in audio practice
      case ConstructUseTypeEnum.corWL:
      case ConstructUseTypeEnum.corHWL:
        return Icons.volume_up_outlined;

      // correct in translation
      case ConstructUseTypeEnum.corIt:
        return Icons.translate_outlined;

      // written correctly without help
      case ConstructUseTypeEnum.wa:
        return Icons.thumb_up_outlined;

      // correct in grammar correction
      case ConstructUseTypeEnum.corIGC:
        return Icons.spellcheck_outlined;

      // ignored
      case ConstructUseTypeEnum.ignIt:
      case ConstructUseTypeEnum.ignIGC:
      case ConstructUseTypeEnum.ignPA:
      case ConstructUseTypeEnum.ignWL:
      case ConstructUseTypeEnum.ignHWL:
        return Icons.block_outlined;

      case ConstructUseTypeEnum.ga:
        return Icons.edit_outlined;

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
      case ConstructUseTypeEnum.corHWL:
        return 3;

      case ConstructUseTypeEnum.corIGC:
        return 2;

      case ConstructUseTypeEnum.corIt:
        return 1;

      case ConstructUseTypeEnum.ignIt:
      case ConstructUseTypeEnum.ignIGC:
      case ConstructUseTypeEnum.ignPA:
      case ConstructUseTypeEnum.ignWL:
      case ConstructUseTypeEnum.ignHWL:
      case ConstructUseTypeEnum.unk:
      case ConstructUseTypeEnum.nan:
        return 0;

      case ConstructUseTypeEnum.ga:
        return -1;

      case ConstructUseTypeEnum.incIt:
      case ConstructUseTypeEnum.incIGC:
        return -2;

      case ConstructUseTypeEnum.incPA:
      case ConstructUseTypeEnum.incWL:
      case ConstructUseTypeEnum.incHWL:
        return -3;
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
