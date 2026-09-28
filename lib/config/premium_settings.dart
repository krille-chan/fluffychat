// SPDX-FileCopyrightText: 2024-Present Aerogram Contributors
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';
import 'package:fluffychat/models/premium_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PremiumSettings {
  static const String _tierKey = 'aerogram.premium.tier';
  static const String _profileBannerKey = 'aerogram.premium.profile_banner';
  static const String _profileColorKey = 'aerogram.premium.profile_color';
  static const String _chatColorKey = 'aerogram.premium.chat_color';
  static const String _premiumFeaturesKey = 'aerogram.premium.features';

  static Future<SharedPreferences> _getPrefs() =>
      SharedPreferences.getInstance();

  static Future<PremiumTier> getPremiumTier() async {
    final prefs = await _getPrefs();
    final tier = prefs.getString(_tierKey) ?? 'none';
    return PremiumTier.values.firstWhere(
      (e) => e.toString().split('.').last == tier,
      orElse: () => PremiumTier.none,
    );
  }

  static Future<void> setPremiumTier(PremiumTier tier) async {
    final prefs = await _getPrefs();
    await prefs.setString(_tierKey, tier.toString().split('.').last);
  }

  static Future<bool> isPremium() async {
    final tier = await getPremiumTier();
    return tier != PremiumTier.none;
  }

  static Future<PremiumFeatures> getPremiumFeatures() async {
    final tier = await getPremiumTier();
    if (tier == PremiumTier.none) {
      return PremiumFeatures.none();
    }
    return PremiumFeatures.premium();
  }

  static Future<String?> getProfileBannerPath() async {
    final prefs = await _getPrefs();
    return prefs.getString(_profileBannerKey);
  }

  static Future<void> setProfileBannerPath(String path) async {
    final prefs = await _getPrefs();
    await prefs.setString(_profileBannerKey, path);
  }

  static Future<void> removeProfileBanner() async {
    final prefs = await _getPrefs();
    await prefs.remove(_profileBannerKey);
  }

  static Future<int> getProfileColor() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_profileColorKey) ?? 0xFF5625BA;
  }

  static Future<void> setProfileColor(int color) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_profileColorKey, color);
  }

  static Future<int> getChatColor() async {
    final prefs = await _getPrefs();
    return prefs.getInt(_chatColorKey) ?? 0xFF5625BA;
  }

  static Future<void> setChatColor(int color) async {
    final prefs = await _getPrefs();
    await prefs.setInt(_chatColorKey, color);
  }

  static Future<void> resetAllPremiumSettings() async {
    final prefs = await _getPrefs();
    await prefs.remove(_tierKey);
    await prefs.remove(_profileBannerKey);
    await prefs.remove(_profileColorKey);
    await prefs.remove(_chatColorKey);
    await prefs.remove(_premiumFeaturesKey);
  }
}
