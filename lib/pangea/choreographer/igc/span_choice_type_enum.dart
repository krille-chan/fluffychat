import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';

enum SpanChoiceTypeEnum {
  suggestion,
  alt,
  distractor,
  @Deprecated('Use suggestion instead')
  bestCorrection,
  @Deprecated('Use suggestion instead')
  bestAnswer,
}

extension SpanChoiceExt on SpanChoiceTypeEnum {
  bool get isSuggestion =>
      this == SpanChoiceTypeEnum.suggestion ||
      // ignore: deprecated_member_use_from_same_package
      this == SpanChoiceTypeEnum.bestCorrection ||
      // ignore: deprecated_member_use_from_same_package
      this == SpanChoiceTypeEnum.bestAnswer ||
      this == SpanChoiceTypeEnum.alt;

  String defaultFeedback(BuildContext context) {
    switch (this) {
      case SpanChoiceTypeEnum.suggestion:
      // ignore: deprecated_member_use_from_same_package
      case SpanChoiceTypeEnum.bestCorrection:
        return L10n.of(context).bestCorrectionFeedback;
      case SpanChoiceTypeEnum.alt:
      // ignore: deprecated_member_use_from_same_package
      case SpanChoiceTypeEnum.bestAnswer:
        return L10n.of(context).bestAnswerFeedback;
      case SpanChoiceTypeEnum.distractor:
        return L10n.of(context).distractorFeedback;
    }
  }

  IconData get icon {
    switch (this) {
      case SpanChoiceTypeEnum.suggestion:
      // ignore: deprecated_member_use_from_same_package
      case SpanChoiceTypeEnum.bestCorrection:
      case SpanChoiceTypeEnum.alt:
      // ignore: deprecated_member_use_from_same_package
      case SpanChoiceTypeEnum.bestAnswer:
        return Icons.check_circle;
      case SpanChoiceTypeEnum.distractor:
        return Icons.cancel;
    }
  }

  Color get color {
    switch (this) {
      case SpanChoiceTypeEnum.suggestion:
      // ignore: deprecated_member_use_from_same_package
      case SpanChoiceTypeEnum.bestCorrection:
        return Colors.green;
      case SpanChoiceTypeEnum.alt:
      // ignore: deprecated_member_use_from_same_package
      case SpanChoiceTypeEnum.bestAnswer:
        return Colors.green;
      case SpanChoiceTypeEnum.distractor:
        return Colors.red;
    }
  }
}
