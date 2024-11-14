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

  factory SubscriptionAppIds.fromJson(Map<String, dynamic> json) {
    return SubscriptionAppIds()
      ..stripeId = json['stripe_id']
      ..androidId = json['android_id']
      ..appleId = json['apple_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['stripe_id'] = stripeId;
    data['android_id'] = androidId;
    data['apple_id'] = appleId;
    return data;
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
