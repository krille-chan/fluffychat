import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart' hide Result;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/user_lemma_info_extension.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/languages/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/lemma.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_repo.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/lemmas/user_set_lemma_info.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/parts_of_speech_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ConstructIdentifier {
  final String lemma;
  final ConstructTypeEnum type;
  final String _category;

  ConstructIdentifier({
    required this.lemma,
    required this.type,
    required String category,
  }) : _category = category {
    if (type == ConstructTypeEnum.morph &&
        MorphFeaturesEnumExtension.fromString(category) ==
            MorphFeaturesEnum.Unknown) {
      ErrorHandler.logError(
        e: Exception("Morph feature not found"),
        data: {"category": category, "lemma": lemma, "type": type},
      );
    }
  }

  factory ConstructIdentifier.fromJson(Map<String, dynamic> json) {
    final categoryEntry = json['cat'] ?? json['categories'];
    String? category;
    if (categoryEntry != null) {
      if (categoryEntry is String) {
        category = categoryEntry;
      } else if (categoryEntry is List) {
        category = categoryEntry.first;
      }
    }

    final type = ConstructTypeEnum.values.firstWhereOrNull(
      (e) => e.string == json['type'],
    );

    if (type == null) {
      Sentry.addBreadcrumb(Breadcrumb(message: "type is: ${json['type']}"));
      Sentry.addBreadcrumb(Breadcrumb(data: json));
      throw Exception("Matching construct type not found");
    }

    try {
      return ConstructIdentifier(
        lemma: json['lemma'] as String,
        type: type,
        category: category ?? "",
      );
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s, data: json);
      rethrow;
    }
  }

  String get category {
    if (_category.isEmpty) return "other";
    return _category.toLowerCase();
  }

  Map<String, dynamic> toJson() {
    return {'lemma': lemma, 'type': type.string, 'cat': category};
  }

  // override operator == and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConstructIdentifier &&
        other.lemma == lemma &&
        other.type == type &&
        (category == other.category ||
            category.toLowerCase() == 'other' ||
            other.category.toLowerCase() == 'other');
  }

  @override
  int get hashCode {
    return lemma.hashCode ^ type.hashCode ^ category.hashCode;
  }

  String get string {
    return "$lemma:${type.string}-$category".toLowerCase();
  }

  static ConstructIdentifier? fromString(String s) {
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final lemma = parts[0];
    final typeAndCategory = parts[1].split('-');
    if (typeAndCategory.length != 2) return null;
    final typeString = typeAndCategory[0];
    final category = typeAndCategory[1];

    final type = ConstructTypeEnum.values.firstWhereOrNull(
      (e) => e.string == typeString,
    );

    if (type == null) return null;

    return ConstructIdentifier(lemma: lemma, type: type, category: category);
  }

  bool get isContentWord =>
      PartOfSpeechEnum.fromString(category)?.isContentWord ?? false;

  LemmaInfoRequest lemmaInfoRequest(Map<String, dynamic> messageInfo) =>
      LemmaInfoRequest(
        partOfSpeech: category,
        lemmaLang:
            MatrixState.pangeaController.userController.userL2?.langCodeShort ??
            LanguageKeys.defaultLanguage,
        userL1:
            MatrixState.pangeaController.userController.userL1?.langCodeShort ??
            LanguageKeys.defaultLanguage,
        lemma: lemma,
        messageInfo: messageInfo,
      );

  /// [lemmmaLang] if not set, assumed to be userL2
  Future<Result<LemmaInfoResponse>> getLemmaInfo(
    Map<String, dynamic> messageInfo,
  ) => LemmaInfoRepo.get(
    MatrixState.pangeaController.userController.accessToken,
    lemmaInfoRequest(messageInfo),
  );

  String? get userSetEmoji => _userLemmaInfo.emojis?.firstOrNull;

  UserSetLemmaInfo get _userLemmaInfo =>
      MatrixState.pangeaController.matrixState.client
          .analyticsRoomLocal()
          ?.getUserSetLemmaInfo(this) ??
      UserSetLemmaInfo();

  String get storageKey => TupleKey(lemma, type.name, category).toString();

  String get compositeKey => '$lemma|${type.name}'.toLowerCase();

  static ConstructIdentifier fromStorageKey(String key) {
    final parts = key.split('|');
    final lemma = parts[0];
    final typeName = parts[1];
    final category = parts[2];

    final type =
        ConstructTypeEnum.values.firstWhereOrNull((e) => e.name == typeName) ??
        ConstructTypeEnum.vocab;

    return ConstructIdentifier(lemma: lemma, type: type, category: category);
  }

  PangeaToken get asToken => PangeaToken(
    lemma: Lemma(text: lemma, saveVocab: true, form: lemma),
    pos: category,
    text: PangeaTokenText.fromString(lemma),
    morph: {},
  );

  /// Score for a construct that has never been seen (no use history).
  int get unseenPracticeScore =>
      AnalyticsConstants.defaultDaysSinceLastUsed *
      (isContentWord
          ? AnalyticsConstants.contentWordMultiplier
          : AnalyticsConstants.functionWordMultiplier);

  bool get isInvalid =>
      (type == ConstructTypeEnum.morph &&
          MorphFeaturesEnumExtension.fromString(category) ==
              MorphFeaturesEnum.Unknown) ||
      category == 'other' ||
      lemma.isEmpty;
}
