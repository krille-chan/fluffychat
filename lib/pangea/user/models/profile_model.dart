import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/language_list_util.dart';

class PublicProfileModel {
  LanguageModel? targetLanguage;
  Map<LanguageModel, LanguageAnalyticsProfileEntry>? languageAnalytics;

  PublicProfileModel({this.targetLanguage, this.languageAnalytics});

  factory PublicProfileModel.fromJson(Map<String, dynamic> json) {
    if (!json.containsKey(PangeaEventTypes.profileAnalytics)) {
      return PublicProfileModel();
    }

    final profileJson = json[PangeaEventTypes.profileAnalytics];

    final targetLanguage = profileJson[ModelKey.userTargetLanguage] != null
        ? PangeaLanguage.byLangCode(profileJson[ModelKey.userTargetLanguage])
        : null;

    final languageAnalytics = <LanguageModel, LanguageAnalyticsProfileEntry>{};
    if (profileJson[ModelKey.analytics] != null &&
        profileJson[ModelKey.analytics]!.isNotEmpty) {
      for (final entry in profileJson[ModelKey.analytics].entries) {
        final lang = PangeaLanguage.byLangCode(entry.key);
        if (lang == null) continue;
        final level = entry.value[ModelKey.level];
        languageAnalytics[lang] = LanguageAnalyticsProfileEntry(level);
      }
    }

    final profile = PublicProfileModel(
      targetLanguage: targetLanguage,
      languageAnalytics: languageAnalytics,
    );
    return profile;
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (targetLanguage != null) {
      json[ModelKey.userTargetLanguage] = targetLanguage!.langCode;
    }

    final analytics = {};
    if (languageAnalytics != null && languageAnalytics!.isNotEmpty) {
      for (final entry in languageAnalytics!.entries) {
        analytics[entry.key.langCode] = {ModelKey.level: entry.value.level};
      }
    }

    json[ModelKey.analytics] = analytics;
    return json;
  }

  bool get isEmpty =>
      targetLanguage == null &&
      (languageAnalytics == null || languageAnalytics!.isEmpty);

  void setLevel(LanguageModel language, int level) {
    languageAnalytics ??= {};
    languageAnalytics![language] ??= LanguageAnalyticsProfileEntry(0);
    languageAnalytics![language]!.level = level;
  }

  int? get level => languageAnalytics?[targetLanguage]?.level;
}

class LanguageAnalyticsProfileEntry {
  int level;

  LanguageAnalyticsProfileEntry(this.level);
}
