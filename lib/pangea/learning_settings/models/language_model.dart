import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/learning_settings/enums/l2_support_enum.dart';

class LanguageModel {
  final String langCode;
  final String displayName;
  final L2SupportEnum l2Support;

  LanguageModel({
    required this.langCode,
    required this.displayName,
    this.l2Support = L2SupportEnum.na,
  });

  factory LanguageModel.fromJson(json) {
    final String code = json['language_code'] ??
        codeFromNameOrCode(
          json['language_name'],
          json['language_flag'],
        );

    return LanguageModel(
      langCode: code,
      displayName: json['language_name'],
      l2Support: json['l2_support'] != null
          ? L2SupportEnum.na.fromStorageString(json['l2_support'])
          : L2SupportEnum.na,
    );
  }

  toJson() => {
        'language_code': langCode,
        'language_name': displayName,
        'l2_support': l2Support.storageString,
      };

  bool get l2 => l2Support != L2SupportEnum.na;

  // Discuss with Jordan - adding langCode field to language objects as separate from displayName
  static String codeFromNameOrCode(String codeOrName, [String? url]) {
    if (codeOrName.isEmpty) return LanguageKeys.unknownLanguage;
    if (codeOrName == LanguageKeys.unknownLanguage) return codeOrName;

    if (url == null) return LanguageKeys.unknownLanguage;

    final List<String> split = url.split('/');
    return split.last.split('.').first;
  }

  //PTODO - add flag for unknown
  static LanguageModel get unknown => LanguageModel(
        langCode: LanguageKeys.unknownLanguage,
        displayName: "Unknown",
      );

  static LanguageModel multiLingual([BuildContext? context]) => LanguageModel(
        displayName: context != null
            ? L10n.of(context).multiLingualSpace
            : "Multilingual Space",
        langCode: LanguageKeys.multiLanguage,
      );

  String? getDisplayName(BuildContext context) {
    return displayName;
  }

  String get langCodeShort => langCode.split('-').first;

  @override
  bool operator ==(Object other) {
    if (other is LanguageModel) {
      return langCode == other.langCode;
    }
    return false;
  }

  @override
  int get hashCode => langCode.hashCode;
}
