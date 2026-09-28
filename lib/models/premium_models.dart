// SPDX-FileCopyrightText: 2024-Present Aerogram Contributors
// SPDX-License-Identifier: AGPL-3.0-or-later

enum PremiumTier {
  none,
  premium,
}

class PremiumFeatures {
  final bool premiumIcon;
  final bool premiumEmoji;
  final bool animatedAvatar;
  final bool animatedProfile;
  final bool premiumStickers;
  final bool premiumReactions;
  final bool expandedReactions;
  final bool exclusiveEffects;
  final bool additionalAnimations;
  final bool additionalThemes;
  final bool customProfileColor;
  final bool customChatColor;
  final bool customWallpaper;
  final bool premiumAppIcons;
  final bool increasedLimits;
  final bool largerFiles;
  final bool messageTranslation;
  final bool voiceTranscription;
  final bool advancedPrivacy;
  final bool profileBanner;

  const PremiumFeatures({
    this.premiumIcon = false,
    this.premiumEmoji = false,
    this.animatedAvatar = false,
    this.animatedProfile = false,
    this.premiumStickers = false,
    this.premiumReactions = false,
    this.expandedReactions = false,
    this.exclusiveEffects = false,
    this.additionalAnimations = false,
    this.additionalThemes = false,
    this.customProfileColor = false,
    this.customChatColor = false,
    this.customWallpaper = false,
    this.premiumAppIcons = false,
    this.increasedLimits = false,
    this.largerFiles = false,
    this.messageTranslation = false,
    this.voiceTranscription = false,
    this.advancedPrivacy = false,
    this.profileBanner = false,
  });

  factory PremiumFeatures.none() => const PremiumFeatures();

  factory PremiumFeatures.premium() => const PremiumFeatures(
        premiumIcon: true,
        premiumEmoji: true,
        animatedAvatar: true,
        animatedProfile: true,
        premiumStickers: true,
        premiumReactions: true,
        expandedReactions: true,
        exclusiveEffects: true,
        additionalAnimations: true,
        additionalThemes: true,
        customProfileColor: true,
        customChatColor: true,
        customWallpaper: true,
        premiumAppIcons: true,
        increasedLimits: true,
        largerFiles: true,
        messageTranslation: true,
        voiceTranscription: true,
        advancedPrivacy: true,
        profileBanner: true,
      );

  Map<String, dynamic> toJson() => {
        'premiumIcon': premiumIcon,
        'premiumEmoji': premiumEmoji,
        'animatedAvatar': animatedAvatar,
        'animatedProfile': animatedProfile,
        'premiumStickers': premiumStickers,
        'premiumReactions': premiumReactions,
        'expandedReactions': expandedReactions,
        'exclusiveEffects': exclusiveEffects,
        'additionalAnimations': additionalAnimations,
        'additionalThemes': additionalThemes,
        'customProfileColor': customProfileColor,
        'customChatColor': customChatColor,
        'customWallpaper': customWallpaper,
        'premiumAppIcons': premiumAppIcons,
        'increasedLimits': increasedLimits,
        'largerFiles': largerFiles,
        'messageTranslation': messageTranslation,
        'voiceTranscription': voiceTranscription,
        'advancedPrivacy': advancedPrivacy,
        'profileBanner': profileBanner,
      };

  factory PremiumFeatures.fromJson(Map<String, dynamic> json) =>
      PremiumFeatures(
        premiumIcon: json['premiumIcon'] ?? false,
        premiumEmoji: json['premiumEmoji'] ?? false,
        animatedAvatar: json['animatedAvatar'] ?? false,
        animatedProfile: json['animatedProfile'] ?? false,
        premiumStickers: json['premiumStickers'] ?? false,
        premiumReactions: json['premiumReactions'] ?? false,
        expandedReactions: json['expandedReactions'] ?? false,
        exclusiveEffects: json['exclusiveEffects'] ?? false,
        additionalAnimations: json['additionalAnimations'] ?? false,
        additionalThemes: json['additionalThemes'] ?? false,
        customProfileColor: json['customProfileColor'] ?? false,
        customChatColor: json['customChatColor'] ?? false,
        customWallpaper: json['customWallpaper'] ?? false,
        premiumAppIcons: json['premiumAppIcons'] ?? false,
        increasedLimits: json['increasedLimits'] ?? false,
        largerFiles: json['largerFiles'] ?? false,
        messageTranslation: json['messageTranslation'] ?? false,
        voiceTranscription: json['voiceTranscription'] ?? false,
        advancedPrivacy: json['advancedPrivacy'] ?? false,
        profileBanner: json['profileBanner'] ?? false,
      );
}
