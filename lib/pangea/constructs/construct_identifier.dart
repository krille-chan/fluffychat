import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/emojis/emoji_stack.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_repo.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_response.dart';
import 'package:fluffychat/pangea/lemmas/user_set_lemma_info.dart';
import 'package:fluffychat/pangea/message_token_text/message_token_button.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_icon.dart';
import 'package:fluffychat/pangea/morphs/parts_of_speech_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ConstructIdentifier {
  final String lemma;
  final ConstructTypeEnum type;
  final String _category;

  ConstructIdentifier({
    required this.lemma,
    required this.type,
    required category,
  }) : _category = category;

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
    return {
      'lemma': lemma,
      'type': type.string,
      'cat': category,
    };
  }

  // override operator == and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConstructIdentifier &&
        other.lemma == lemma &&
        other.type == type &&
        (category == other.category ||
            category.toLowerCase() == "other" ||
            other.category.toLowerCase() == "other");
  }

  @override
  int get hashCode {
    return lemma.hashCode ^ type.hashCode;
  }

  String get string {
    return "$lemma:${type.string}-$category".toLowerCase();
  }

  String get partialKey => "$lemma-${type.string}";

  ConstructUses get constructUses =>
      MatrixState.pangeaController.getAnalytics.constructListModel
          .getConstructUses(
        this,
      ) ??
      ConstructUses(
        lemma: lemma,
        constructType: ConstructTypeEnum.morph,
        category: category,
        uses: [],
      );

  List<String> get userSetEmoji => userLemmaInfo?.emojis ?? [];

  String? get userSetMeaning => userLemmaInfo?.meaning;

  UserSetLemmaInfo? get userLemmaInfo {
    switch (type) {
      case ConstructTypeEnum.vocab:
        final dynamic lemmaInfoContent = MatrixState
            .pangeaController.matrixState.client
            .analyticsRoomLocal()
            ?.getState(PangeaEventTypes.userSetLemmaInfo, string)
            ?.content;
        if (lemmaInfoContent != null && lemmaInfoContent is Map) {
          try {
            return UserSetLemmaInfo.fromJson(
              lemmaInfoContent as Map<String, dynamic>,
            );
          } catch (e, s) {
            debugger(when: kDebugMode);
            ErrorHandler.logError(
              e: e,
              data: {
                "construct": string,
                "content": lemmaInfoContent,
              },
              s: s,
            );
            return null;
          }
        } else {
          return null;
        }
      case ConstructTypeEnum.morph:
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          e: Exception("Morphs should not have userSetEmoji"),
          data: toJson(),
        );
        return null;
    }
  }

  Future<void> setUserLemmaInfo(UserSetLemmaInfo newLemmaInfo) async {
    final analyticsRoom =
        MatrixState.pangeaController.matrixState.client.analyticsRoomLocal();
    if (analyticsRoom == null) return;
    try {
      final client = MatrixState.pangeaController.matrixState.client;
      final syncFuture = client.onRoomState.stream.firstWhere((event) {
        return event.roomId == analyticsRoom.id &&
            event.state.type == PangeaEventTypes.userSetLemmaInfo;
      });

      client.setRoomStateWithKey(
        analyticsRoom.id,
        PangeaEventTypes.userSetLemmaInfo,
        string,
        UserSetLemmaInfo(
          emojis: newLemmaInfo.emojis ?? userLemmaInfo?.emojis,
          meaning: newLemmaInfo.meaning ?? userLemmaInfo?.meaning,
        ).toJson(),
      );
      await syncFuture;
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        data: newLemmaInfo.toJson(),
        s: s,
      );
    }
  }

  /// [lemmmaLang] if not set, assumed to be userL2
  Future<LemmaInfoResponse> getLemmaInfo([
    String? lemmaLang,
    String? userl1,
  ]) =>
      LemmaInfoRepo.get(
        LemmaInfoRequest(
          partOfSpeech: category,
          lemmaLang: lemmaLang ??
              MatrixState
                  .pangeaController.languageController.userL2?.langCodeShort ??
              LanguageKeys.defaultLanguage,
          userL1: userl1 ??
              MatrixState
                  .pangeaController.languageController.userL1?.langCodeShort ??
              LanguageKeys.defaultLanguage,
          lemma: lemma,
        ),
      );

  bool get isContentWord =>
      PartOfSpeechEnumExtensions.fromString(category)?.isContentWord ?? false;

  /// [form] should be passed if available and is required for morphId
  bool isActivityProbablyLevelAppropriate(ActivityTypeEnum a, String? form) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        final double contentModifier = isContentWord ? 0.5 : 1;
        if (daysSinceLastEligibleUseForMeaning <
            3 * constructUses.points * contentModifier) {
          return false;
        }

        return true;
      case ActivityTypeEnum.emoji:
        return userSetEmoji.length < maxEmojisPerLemma;
      case ActivityTypeEnum.morphId:
        if (form == null) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(
            e: Exception(
              "form is null in isActivityProbablyLevelAppropriate for morphId",
            ),
            data: {
              "activity": a,
              "construct": toJson(),
            },
          );
          return false;
        }
        final uses = constructUses.uses
            .where((u) => u.form == form)
            .map((u) => u.timeStamp)
            .toList();

        if (uses.isEmpty) return true;

        final lastUsed = uses.reduce((a, b) => a.isAfter(b) ? a : b);

        return DateTime.now().difference(lastUsed).inDays >
            1 * constructUses.points;
      case ActivityTypeEnum.wordFocusListening:
        final pos = PartOfSpeechEnumExtensions.fromString(lemma) ??
            PartOfSpeechEnumExtensions.fromString(category);

        if (pos == null) {
          debugger(when: kDebugMode);
          return false;
        }

        return pos.canBeHeard;
      default:
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          e: Exception(
            "Activity type $a not handled in ConstructIdentifier.isActivityProbablyLevelAppropriate",
          ),
          data: {
            "activity": a,
            "construct": toJson(),
          },
        );
        return false;
    }
  }

  /// days since last eligible use for meaning
  /// this is the number of days since the last time the user used this word
  /// in a way that would engage with the meaning of the word
  /// importantly, this excludes emoji activities
  /// we want users to be able to do an emoji activity as a ramp up to
  /// a word meaning activity
  int get daysSinceLastEligibleUseForMeaning {
    final times = constructUses.uses
        .where(
          (u) =>
              u.useType.sentByUser ||
              ActivityTypeEnum.wordMeaning.associatedUseTypes
                  .contains(u.useType) ||
              ActivityTypeEnum.messageMeaning.associatedUseTypes
                  .contains(u.useType),
        )
        .map((u) => u.timeStamp)
        .toList();

    if (times.isEmpty) return 1000;

    // return the most recent timestamp
    final last = times.reduce((a, b) => a.isAfter(b) ? a : b);

    return DateTime.now().difference(last).inDays;
  }

  Widget get visual {
    switch (type) {
      case ConstructTypeEnum.vocab:
        return EmojiStack(emoji: userSetEmoji);
      case ConstructTypeEnum.morph:
        return MorphIcon(
          morphFeature: MorphFeaturesEnumExtension.fromString(category),
          morphTag: lemma,
        );
    }
  }
}
