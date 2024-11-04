import 'package:fluffychat/pangea/constants/analytics_constants.dart';
import 'package:fluffychat/pangea/enum/analytics/morph_categories_enum.dart';
import 'package:fluffychat/pangea/enum/analytics/parts_of_speech_enum.dart';
import 'package:flutter/material.dart';

enum ConstructTypeEnum {
  grammar,
  vocab,
  morph,
}

extension ConstructExtension on ConstructTypeEnum {
  String get string {
    switch (this) {
      case ConstructTypeEnum.grammar:
        return 'grammar';
      case ConstructTypeEnum.vocab:
        return 'vocab';
      case ConstructTypeEnum.morph:
        return 'morph';
    }
  }

  int get maxXPPerLemma {
    switch (this) {
      case ConstructTypeEnum.grammar:
        return 0;
      case ConstructTypeEnum.vocab:
        return AnalyticsConstants.vocabUseMaxXP;
      case ConstructTypeEnum.morph:
        return AnalyticsConstants.morphUseMaxXP;
    }
  }

  String? getDisplayCopy(String category, BuildContext context) {
    switch (this) {
      case ConstructTypeEnum.morph:
        return getMorphologicalCategoryCopy(category, context);
      case ConstructTypeEnum.vocab:
        return getVocabCategoryName(category, context);
      default:
        return null;
    }
  }
}

class ConstructTypeUtil {
  static ConstructTypeEnum fromString(String? string) {
    switch (string) {
      case 'g':
      case 'grammar':
        return ConstructTypeEnum.grammar;
      case 'v':
      case 'vocab':
        return ConstructTypeEnum.vocab;
      case 'm':
      case 'morph':
        return ConstructTypeEnum.morph;
      default:
        return ConstructTypeEnum.vocab;
    }
  }
}
