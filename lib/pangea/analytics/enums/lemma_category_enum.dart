import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics/constants/analytics_constants.dart';

enum LemmaCategoryEnum {
  flowers,
  greens,
  seeds,
}

extension LemmaCategoryExtension on LemmaCategoryEnum {
  Color get color {
    switch (this) {
      case LemmaCategoryEnum.flowers:
        return Color.lerp(AppConfig.primaryColor, Colors.white, 0.6) ??
            AppConfig.primaryColor;
      case LemmaCategoryEnum.greens:
        return Color.lerp(AppConfig.success, Colors.white, 0.6) ??
            AppConfig.success;
      case LemmaCategoryEnum.seeds:
        return Color.lerp(AppConfig.gold, Colors.white, 0.6) ?? AppConfig.gold;
    }
  }

  Color get darkColor {
    switch (this) {
      case LemmaCategoryEnum.flowers:
        return Color.lerp(AppConfig.primaryColor, Colors.white, 0.3) ??
            AppConfig.primaryColor;
      case LemmaCategoryEnum.greens:
        return Color.lerp(AppConfig.success, Colors.black, 0.3) ??
            AppConfig.success;
      case LemmaCategoryEnum.seeds:
        return Color.lerp(AppConfig.gold, Colors.black, 0.3) ?? AppConfig.gold;
    }
  }

  String get svgURL {
    switch (this) {
      case LemmaCategoryEnum.seeds:
        return "${AppConfig.svgAssetsBaseURL}/${AnalyticsConstants.seedSvgFileName}";
      case LemmaCategoryEnum.greens:
        return "${AppConfig.svgAssetsBaseURL}/${AnalyticsConstants.leafSvgFileName}";
      case LemmaCategoryEnum.flowers:
        return "${AppConfig.svgAssetsBaseURL}/${AnalyticsConstants.flowerSvgFileName}";
    }
  }

  String get emoji {
    switch (this) {
      case LemmaCategoryEnum.flowers:
        return AnalyticsConstants.emojiForFlower;
      case LemmaCategoryEnum.greens:
        return AnalyticsConstants.emojiForGreen;
      case LemmaCategoryEnum.seeds:
        return AnalyticsConstants.emojiForSeed;
    }
  }

  String get xpString {
    switch (this) {
      case LemmaCategoryEnum.flowers:
        return ">${AnalyticsConstants.xpForFlower}";
      case LemmaCategoryEnum.greens:
        return ">${AnalyticsConstants.xpForGreens}";
      case LemmaCategoryEnum.seeds:
        return "<${AnalyticsConstants.xpForGreens}";
    }
  }
}
