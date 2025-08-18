import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';

class AnalyticsProfileModel {
  LanguageModel? baseLanguage;
  LanguageModel? targetLanguage;
  Map<LanguageModel, LanguageAnalyticsProfileEntry>? languageAnalytics;

  AnalyticsProfileModel({
    this.baseLanguage,
    this.targetLanguage,
    this.languageAnalytics,
  });

  factory AnalyticsProfileModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey(PangeaEventTypes.profileAnalytics)) {
      return AnalyticsProfileModel();
    }

    final profileJson = json[PangeaEventTypes.profileAnalytics];

    final baseLanguage = profileJson[ModelKey.userSourceLanguage] != null
        ? PLanguageStore.byLangCode(profileJson[ModelKey.userSourceLanguage])
        : null;

    final targetLanguage = profileJson[ModelKey.userTargetLanguage] != null
        ? PLanguageStore.byLangCode(profileJson[ModelKey.userTargetLanguage])
        : null;

    final languageAnalytics = <LanguageModel, LanguageAnalyticsProfileEntry>{};
    if (profileJson[ModelKey.analytics] != null &&
        profileJson[ModelKey.analytics]!.isNotEmpty) {
      for (final entry in profileJson[ModelKey.analytics].entries) {
        final lang = PLanguageStore.byLangCode(entry.key);
        if (lang == null) continue;
        final level = entry.value[ModelKey.level];
        final xpOffset = entry.value[ModelKey.xpOffset] ?? 0;
        final analyticsRoomId =
            entry.value[ModelKey.analyticsRoomId] as String?;
        languageAnalytics[lang] = LanguageAnalyticsProfileEntry(
          level,
          xpOffset,
          analyticsRoomId: analyticsRoomId,
        );
      }
    }

    final profile = AnalyticsProfileModel(
      baseLanguage: baseLanguage,
      targetLanguage: targetLanguage,
      languageAnalytics: languageAnalytics,
    );
    return profile;
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (targetLanguage != null) {
      json[ModelKey.userTargetLanguage] = targetLanguage!.langCodeShort;
    }

    if (baseLanguage != null) {
      json[ModelKey.userSourceLanguage] = baseLanguage!.langCodeShort;
    }

    final analytics = {};
    if (languageAnalytics != null && languageAnalytics!.isNotEmpty) {
      for (final entry in languageAnalytics!.entries) {
        analytics[entry.key.langCode] = {
          ModelKey.level: entry.value.level,
          ModelKey.xpOffset: entry.value.xpOffset,
          if (entry.value.analyticsRoomId != null)
            ModelKey.analyticsRoomId: entry.value.analyticsRoomId,
        };
      }
    }

    json[ModelKey.analytics] = analytics;
    return json;
  }

  bool get isEmpty =>
      baseLanguage == null ||
      targetLanguage == null ||
      (languageAnalytics == null || languageAnalytics!.isEmpty);

  String? analyticsRoomIdByLanguage(LanguageModel language) =>
      languageAnalytics![language]?.analyticsRoomId;

  /// Set the level and analytics room ID for the a given language.
  void setLanguageInfo(
    LanguageModel language,
    int level,
    String? analyticsRoomId,
  ) {
    languageAnalytics ??= {};
    languageAnalytics![language] ??= LanguageAnalyticsProfileEntry(
      0,
      0,
      analyticsRoomId: analyticsRoomId,
    );

    if (languageAnalytics![language]!.level < level) {
      languageAnalytics![language]!.level = level;
    }

    final currentRoomId = analyticsRoomIdByLanguage(language);
    if (currentRoomId == null) {
      languageAnalytics![language]!.analyticsRoomId = analyticsRoomId;
    }
    languageAnalytics![language]!.level = level;
  }

  void addXPOffset(
    LanguageModel language,
    int xpOffset,
    String? analyticsRoomId,
  ) {
    languageAnalytics ??= {};
    languageAnalytics![language] ??= LanguageAnalyticsProfileEntry(
      0,
      0,
      analyticsRoomId: analyticsRoomId,
    );

    final currentRoomId = analyticsRoomIdByLanguage(language);
    if (currentRoomId == null) {
      languageAnalytics![language]!.analyticsRoomId = analyticsRoomId;
    }
    languageAnalytics![language]!.xpOffset += xpOffset;
  }

  int? get level => languageAnalytics?[targetLanguage]?.level;

  int? get xpOffset => languageAnalytics?[targetLanguage]?.xpOffset;
}

class LanguageAnalyticsProfileEntry {
  int level;
  int xpOffset = 0;
  String? analyticsRoomId;

  LanguageAnalyticsProfileEntry(
    this.level,
    this.xpOffset, {
    this.analyticsRoomId,
  });
}
