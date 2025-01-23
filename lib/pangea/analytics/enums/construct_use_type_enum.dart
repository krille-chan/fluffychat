import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/analytics/enums/analytics_summary_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';

enum ConstructUseTypeEnum {
  /// produced in chat by user, igc was run, and we've judged it to be a correct use
  wa,

  /// produced in chat by user, igc was run, and we've judged it to be a incorrect use
  /// Note: if the IGC match is ignored, this is not counted as an incorrect use
  ga,

  /// produced in chat by user and igc was not run
  unk,

  /// interactive translation activity
  corIt,
  ignIt,
  incIt,

  /// interactive grammar checking activity
  corIGC,
  incIGC,
  ignIGC,

  /// word meaning in context practice activity
  corPA,
  ignPA,
  incPA,

  /// applies to target lemma in word-focus listening activity
  corWL,
  incWL,
  ignWL,

  /// applies to the form of the lemma in a hidden word listening activity
  corHWL,
  incHWL,
  ignHWL,

  /// lemma id activity
  corL,
  incL,
  ignL,

  /// morph id activity
  corM,
  incM,
  ignM,

  /// emoji activity
  /// No correct/incorrect/ignored distinction is made
  /// User can select any emoji
  em,

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
      case ConstructUseTypeEnum.corL:
        return L10n.of(context).constructUseCorLDesc;
      case ConstructUseTypeEnum.incL:
        return L10n.of(context).constructUseIncLDesc;
      case ConstructUseTypeEnum.ignL:
        return L10n.of(context).constructUseIgnLDesc;
      case ConstructUseTypeEnum.corM:
        return L10n.of(context).constructUseCorMDesc;
      case ConstructUseTypeEnum.incM:
        return L10n.of(context).constructUseIncMDesc;
      case ConstructUseTypeEnum.ignM:
        return L10n.of(context).constructUseIgnMDesc;
      case ConstructUseTypeEnum.em:
        return L10n.of(context).constructUseEmojiDesc;
      case ConstructUseTypeEnum.nan:
        return L10n.of(context).constructUseNanDesc;
    }
  }

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
      case ConstructUseTypeEnum.corIGC:
      case ConstructUseTypeEnum.ga:
        return Icons.spellcheck;
      case ConstructUseTypeEnum.corPA:
      case ConstructUseTypeEnum.incPA:
      case ConstructUseTypeEnum.ignPA:
        return ActivityTypeEnum.wordMeaning.icon;
      case ConstructUseTypeEnum.ignWL:
      case ConstructUseTypeEnum.incWL:
      case ConstructUseTypeEnum.corWL:
        return ActivityTypeEnum.wordFocusListening.icon;
      case ConstructUseTypeEnum.incHWL:
      case ConstructUseTypeEnum.ignHWL:
      case ConstructUseTypeEnum.corHWL:
        return ActivityTypeEnum.hiddenWordListening.icon;
      case ConstructUseTypeEnum.corL:
      case ConstructUseTypeEnum.incL:
      case ConstructUseTypeEnum.ignL:
        return ActivityTypeEnum.lemmaId.icon;
      case ConstructUseTypeEnum.corM:
      case ConstructUseTypeEnum.incM:
      case ConstructUseTypeEnum.ignM:
        return ActivityTypeEnum.morphId.icon;
      case ConstructUseTypeEnum.em:
        return ActivityTypeEnum.emoji.icon;
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
      case ConstructUseTypeEnum.corL:
      case ConstructUseTypeEnum.corM:
        return 2;

      case ConstructUseTypeEnum.corIt:
      case ConstructUseTypeEnum.em:
        return 1;

      case ConstructUseTypeEnum.ignIt:
      case ConstructUseTypeEnum.ignIGC:
      case ConstructUseTypeEnum.ignPA:
      case ConstructUseTypeEnum.ignWL:
      case ConstructUseTypeEnum.ignHWL:
      case ConstructUseTypeEnum.ignL:
      case ConstructUseTypeEnum.ignM:
      case ConstructUseTypeEnum.unk:
      case ConstructUseTypeEnum.nan:
        return 0;

      case ConstructUseTypeEnum.ga:
        return -1;

      case ConstructUseTypeEnum.incIt:
      case ConstructUseTypeEnum.incIGC:
      case ConstructUseTypeEnum.incL:
      case ConstructUseTypeEnum.incM:
        return -2;

      case ConstructUseTypeEnum.incPA:
      case ConstructUseTypeEnum.incWL:
      case ConstructUseTypeEnum.incHWL:
        return -3;
    }
  }

  bool get sentByUser {
    switch (this) {
      case ConstructUseTypeEnum.wa:
      case ConstructUseTypeEnum.ga:
      case ConstructUseTypeEnum.unk:
      case ConstructUseTypeEnum.corIt:
      case ConstructUseTypeEnum.ignIt:
      case ConstructUseTypeEnum.incIt:
      case ConstructUseTypeEnum.corIGC:
      case ConstructUseTypeEnum.incIGC:
      case ConstructUseTypeEnum.ignIGC:
        return true;

      case ConstructUseTypeEnum.corPA:
      case ConstructUseTypeEnum.ignPA:
      case ConstructUseTypeEnum.incPA:
      case ConstructUseTypeEnum.corWL:
      case ConstructUseTypeEnum.incWL:
      case ConstructUseTypeEnum.ignWL:
      case ConstructUseTypeEnum.corHWL:
      case ConstructUseTypeEnum.incHWL:
      case ConstructUseTypeEnum.ignHWL:
      case ConstructUseTypeEnum.corL:
      case ConstructUseTypeEnum.incL:
      case ConstructUseTypeEnum.ignL:
      case ConstructUseTypeEnum.corM:
      case ConstructUseTypeEnum.incM:
      case ConstructUseTypeEnum.ignM:
      case ConstructUseTypeEnum.em:
      case ConstructUseTypeEnum.nan:
        return false;
    }
  }

  AnalyticsSummaryEnum? get summaryEnumType {
    switch (this) {
      case ConstructUseTypeEnum.wa:
      case ConstructUseTypeEnum.ga:
      case ConstructUseTypeEnum.unk:
        return AnalyticsSummaryEnum.numWordsTyped;

      case ConstructUseTypeEnum.corIt:
      case ConstructUseTypeEnum.corPA:
      case ConstructUseTypeEnum.corIGC:
      case ConstructUseTypeEnum.corWL:
      case ConstructUseTypeEnum.corHWL:
      case ConstructUseTypeEnum.corL:
      case ConstructUseTypeEnum.corM:
      case ConstructUseTypeEnum.em:
        return AnalyticsSummaryEnum.numChoicesCorrect;

      case ConstructUseTypeEnum.incIt:
      case ConstructUseTypeEnum.incIGC:
      case ConstructUseTypeEnum.incPA:
      case ConstructUseTypeEnum.incWL:
      case ConstructUseTypeEnum.incHWL:
      case ConstructUseTypeEnum.incL:
      case ConstructUseTypeEnum.incM:
        return AnalyticsSummaryEnum.numChoicesIncorrect;

      case ConstructUseTypeEnum.ignIt:
      case ConstructUseTypeEnum.ignPA:
      case ConstructUseTypeEnum.ignIGC:
      case ConstructUseTypeEnum.ignWL:
      case ConstructUseTypeEnum.ignHWL:
      case ConstructUseTypeEnum.ignL:
      case ConstructUseTypeEnum.ignM:
      case ConstructUseTypeEnum.nan:
        return null;
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
