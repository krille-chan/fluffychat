import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

enum SpanChoiceType {
  bestCorrection,
  distractor,
  bestAnswer,
}

extension SpanChoiceExt on SpanChoiceType {
  String get name {
    switch (this) {
      case SpanChoiceType.bestCorrection:
        return "bestCorrection";
      case SpanChoiceType.distractor:
        return "distractor";
      case SpanChoiceType.bestAnswer:
        return "bestAnswer";
    }
  }

  String defaultFeedback(BuildContext context) {
    switch (this) {
      case SpanChoiceType.bestCorrection:
        return L10n.of(context).bestCorrectionFeedback;
      case SpanChoiceType.distractor:
        return L10n.of(context).distractorFeedback;
      case SpanChoiceType.bestAnswer:
        return L10n.of(context).bestAnswerFeedback;
    }
  }

  IconData get icon {
    switch (this) {
      case SpanChoiceType.bestCorrection:
        return Icons.check_circle;
      case SpanChoiceType.distractor:
        return Icons.cancel;
      case SpanChoiceType.bestAnswer:
        return Icons.check_circle;
    }
  }

  Color get color {
    switch (this) {
      case SpanChoiceType.bestCorrection:
        return Colors.green;
      case SpanChoiceType.distractor:
        return Colors.red;
      case SpanChoiceType.bestAnswer:
        return Colors.green;
    }
  }
}
