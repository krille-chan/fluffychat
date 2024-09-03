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
}

enum RCPlatform {
  stripe,
  android,
  apple,
}

class SubscriptionPlatform {
  RCPlatform currentPlatform = kIsWeb
      ? RCPlatform.stripe
      : Platform.isAndroid
          ? RCPlatform.android
          : RCPlatform.apple;

  @override
  String toString() {
    return currentPlatform == RCPlatform.stripe
        ? 'stripe'
        : currentPlatform == RCPlatform.android
            ? 'play_store'
            : 'app_store';
  }
}
