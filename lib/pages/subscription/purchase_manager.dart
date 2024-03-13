import 'dart:async';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseManager {
  static Future<Map<String, IntroEligibility>> checkTrialOrIntroductoryPriceEligibility(List<String> productIdentifiers) async {
    try {
      final Map<String, dynamic> eligibilityMap = await Purchases.checkTrialOrIntroductoryPriceEligibility(productIdentifiers);
      return Map<String, IntroEligibility>.from(
        eligibilityMap.map(
              (key, value) => MapEntry(
            key,
            IntroEligibility.fromJson(Map<String, dynamic>.from(value)),
          ),
        ),
      );
    } catch (e) {
      print('Error checking eligibility: $e');
      return {};
    }
  }
}
