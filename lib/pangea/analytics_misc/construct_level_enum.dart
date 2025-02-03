import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';

enum ConstructLevelEnum {
  flowers,
  greens,
  seeds,
}

extension ConstructLevelEnumExt on ConstructLevelEnum {
  Color get color {
    switch (this) {
      case ConstructLevelEnum.flowers:
        return Color.lerp(AppConfig.primaryColor, Colors.white, 0.6) ??
            AppConfig.primaryColor;
      case ConstructLevelEnum.greens:
        return Color.lerp(AppConfig.success, Colors.white, 0.6) ??
            AppConfig.success;
      case ConstructLevelEnum.seeds:
        return Color.lerp(AppConfig.gold, Colors.white, 0.6) ?? AppConfig.gold;
    }
  }

  Color get darkColor {
    switch (this) {
      case ConstructLevelEnum.flowers:
        return Color.lerp(AppConfig.primaryColor, Colors.white, 0.3) ??
            AppConfig.primaryColor;
      case ConstructLevelEnum.greens:
        return Color.lerp(AppConfig.success, Colors.black, 0.3) ??
            AppConfig.success;
      case ConstructLevelEnum.seeds:
        return Color.lerp(AppConfig.gold, Colors.black, 0.3) ?? AppConfig.gold;
    }
  }

  String get svgURL {
    switch (this) {
      case ConstructLevelEnum.seeds:
        return "${AppConfig.assetsBaseURL}/${AnalyticsConstants.seedSvgFileName}";
      case ConstructLevelEnum.greens:
        return "${AppConfig.assetsBaseURL}/${AnalyticsConstants.leafSvgFileName}";
      case ConstructLevelEnum.flowers:
        return "${AppConfig.assetsBaseURL}/${AnalyticsConstants.flowerSvgFileName}";
    }
  }

  String get emoji {
    switch (this) {
      case ConstructLevelEnum.flowers:
        return AnalyticsConstants.emojiForFlower;
      case ConstructLevelEnum.greens:
        return AnalyticsConstants.emojiForGreen;
      case ConstructLevelEnum.seeds:
        return AnalyticsConstants.emojiForSeed;
    }
  }

  String get xpString {
    switch (this) {
      case ConstructLevelEnum.flowers:
        return ">${AnalyticsConstants.xpForFlower}";
      case ConstructLevelEnum.greens:
        return ">${AnalyticsConstants.xpForGreens}";
      case ConstructLevelEnum.seeds:
        return "<${AnalyticsConstants.xpForGreens}";
    }
  }

  int get xpNeeded {
    switch (this) {
      case ConstructLevelEnum.flowers:
        return AnalyticsConstants.xpForFlower;
      case ConstructLevelEnum.greens:
        return AnalyticsConstants.xpForGreens;
      case ConstructLevelEnum.seeds:
        return 0;
    }
  }
}
