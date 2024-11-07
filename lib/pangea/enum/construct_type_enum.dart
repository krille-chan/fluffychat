import 'dart:developer';

import 'package:fluffychat/pangea/constants/analytics_constants.dart';
import 'package:flutter/foundation.dart';

enum ConstructTypeEnum {
  /// for vocabulary words
  vocab,

  /// for morphs, actually called "Grammar" in the UI... :P
  morph,
}

extension ConstructExtension on ConstructTypeEnum {
  String get string {
    switch (this) {
      case ConstructTypeEnum.vocab:
        return 'vocab';
      case ConstructTypeEnum.morph:
        return 'morph';
    }
  }

  int get maxXPPerLemma {
    switch (this) {
      case ConstructTypeEnum.vocab:
        return AnalyticsConstants.vocabUseMaxXP;
      case ConstructTypeEnum.morph:
        return AnalyticsConstants.morphUseMaxXP;
    }
  }
}

class ConstructTypeUtil {
  static ConstructTypeEnum fromString(String? string) {
    switch (string) {
      case 'v':
      case 'vocab':
        return ConstructTypeEnum.vocab;
      case 'm':
      case 'morph':
        return ConstructTypeEnum.morph;
      default:
        debugger(when: kDebugMode);
        return ConstructTypeEnum.vocab;
    }
  }
}
