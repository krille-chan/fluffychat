import 'dart:io';

import 'package:flutter/foundation.dart';

class SubscriptionAppIds {
  String? stripeId;
  String? androidId;
  String? appleId;

  SubscriptionAppIds();

  String? get currentAppId => kIsWeb
      ? stripeId
      : Platform.isAndroid
          ? androidId
          : appleId;

  String? appDisplayName(String appId) {
    if (appId == stripeId) return "web";
    if (appId == androidId) return "Google Play Store";
    if (appId == appleId) return "Apple App Store";
    return null;
  }

  factory SubscriptionAppIds.fromJson(json) {
    final SubscriptionAppIds appIds = SubscriptionAppIds();
    for (final appInfo in (json['items'] as List<dynamic>)) {
      final String platform = appInfo['type'];
      final String appId = appInfo['id'];
      switch (platform) {
        case 'stripe':
          appIds.stripeId = appId;
          continue;
        case 'app_store':
          appIds.appleId = appId;
          continue;
        case 'play_store':
          appIds.androidId = appId;
          continue;
      }
    }
    return appIds;
  }
}

enum RCPlatform {
  stripe,
  android,
  apple,
}

extension RCPlatformExtension on RCPlatform {
  RCPlatform get currentPlatform => kIsWeb
      ? RCPlatform.stripe
      : Platform.isAndroid
          ? RCPlatform.android
          : RCPlatform.apple;

  String get string {
    return currentPlatform == RCPlatform.stripe
        ? 'stripe'
        : currentPlatform == RCPlatform.android
            ? 'play_store'
            : 'app_store';
  }
}
