import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_identifier.dart';
import 'package:fluffychat/pangea/constructs/construct_level_enum.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_repo.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/lemmas/user_set_lemma_info.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/morph_repo.dart';
import 'package:fluffychat/pangea/morphs/parts_of_speech_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';

import '../../common/constants/model_keys.dart';
import '../../lemmas/lemma.dart';

class PangeaToken {
  PangeaTokenText text;

  //TODO - make this a string and move save_vocab to this class
  // clients have been able to handle null lemmas for 12 months so this is safe
  Lemma lemma;

  /// [pos] ex "VERB" - part of speech of the token
  /// https://universaldependencies.org/u/pos/
  String pos;

  /// [_morph] ex {} - morphological features of the token
  /// https://universaldependencies.org/u/feat/
  final Map<String, dynamic> _morph;

  PangeaToken({
    required this.text,
    required this.lemma,
    required this.pos,
    required Map<String, dynamic> morph,
  }) : _morph = morph;

  @override
  bool operator ==(Object other) {
    if (other is PangeaToken) {
      return other.text.content == text.content &&
          other.text.offset == text.offset;
    }
    return false;
  }

  @override
  int get hashCode => text.content.hashCode ^ text.offset.hashCode;

  Map<String, dynamic> get morph {
    if (_morph.keys.map((key) => key.toLowerCase()).contains("pos")) {
      return _morph;
    }
    final morphWithPos = Map<String, dynamic>.from(_morph);
    morphWithPos["pos"] = pos;
    return morphWithPos;
  }

  /// reconstructs the text from the tokens
  /// [tokens] - the tokens to reconstruct
  /// [debugWalkThrough] - if true, will start the debugger
  static String reconstructText(
    List<PangeaToken> tokens, {
    bool debugWalkThrough = false,
    int startTokenIndex = 0,
    int endTokenIndex = -1,
  }) {
    debugger(when: kDebugMode && debugWalkThrough);

    if (endTokenIndex == -1) {
      endTokenIndex = tokens.length;
    }

    final List<PangeaToken> subset =
        tokens.sublist(startTokenIndex, endTokenIndex);

    if (subset.isEmpty) {
      debugger(when: kDebugMode);
      return '';
    }

    if (subset.length == 1) {
      return subset.first.text.content;
    }

    String reconstruction = "";
    for (int i = 0; i < subset.length; i++) {
      int whitespace = subset[i].text.offset -
          (i > 0 ? (subset[i - 1].text.offset + subset[i - 1].text.length) : 0);

      if (whitespace < 0) {
        whitespace = 0;
      }
      reconstruction += ' ' * whitespace + subset[i].text.content;
    }

    return reconstruction;
  }

  static Lemma _getLemmas(String text, dynamic json) {
    if (json != null) {
      // July 24, 2024 - we're changing from a list to a single lemma and this is for backwards compatibility
      // previously sent tokens have lists of lemmas
      if (json is Iterable) {
        return json
                .map<Lemma>(
                  (e) => Lemma.fromJson(e as Map<String, dynamic>),
                )
                .toList()
                .cast<Lemma>()
                .firstOrNull ??
            Lemma(text: text, saveVocab: false, form: text);
      } else {
        return Lemma.fromJson(json);
      }
    } else {
      // earlier still, we didn't have lemmas so this is for really old tokens
      return Lemma(text: text, saveVocab: false, form: text);
    }
  }

  factory PangeaToken.fromJson(Map<String, dynamic> json) {
    final PangeaTokenText text =
        PangeaTokenText.fromJson(json[_textKey] as Map<String, dynamic>);
    return PangeaToken(
      text: text,
      lemma: _getLemmas(text.content, json[_lemmaKey]),
      pos: json['pos'] ?? '',
      morph: json['morph'] ?? {},
    );
  }

  static const String _textKey = "text";
  static const String _lemmaKey = ModelKey.lemma;

  Map<String, dynamic> toJson() => {
        _textKey: text.toJson(),
        _lemmaKey: [lemma.toJson()],
        'pos': pos,
        'morph': morph,
      };

  /// alias for the offset
  int get start => text.offset;

  /// alias for the end of the token ie offset + length
  int get end => text.offset + text.length;

  bool get isContentWord => vocabConstructID.isContentWord;

  String get analyticsDebugPrint =>
      "content: ${text.content} isContentWord: $isContentWord vocab_construct_xp: ${vocabConstruct.points} daysSincelastUseInWordMeaning ${daysSinceLastUseByType(ActivityTypeEnum.wordMeaning, null)}";

  bool get canBeDefined =>
      PartOfSpeechEnumExtensions.fromString(pos)?.canBeDefined ?? false;

  bool get canBeHeard =>
      PartOfSpeechEnumExtensions.fromString(pos)?.canBeHeard ?? false;

  /// Given a [type] and [metadata], returns a [OneConstructUse] for this lemma
  OneConstructUse toVocabUse(
    ConstructUseTypeEnum type,
    ConstructUseMetaData metadata,
  ) {
    return OneConstructUse(
      useType: type,
      lemma: lemma.text,
      form: text.content,
      constructType: ConstructTypeEnum.vocab,
      metadata: metadata,
      category: pos,
    );
  }

  List<OneConstructUse> allUses(
    ConstructUseTypeEnum type,
    ConstructUseMetaData metadata,
  ) {
    final List<OneConstructUse> uses = [];
    if (!lemma.saveVocab) return uses;

    uses.add(toVocabUse(type, metadata));
    for (final morphFeature in morph.keys) {
      uses.add(
        OneConstructUse(
          useType: type,
          lemma: morph[morphFeature],
          form: text.content,
          constructType: ConstructTypeEnum.morph,
          metadata: metadata,
          category: morphFeature,
        ),
      );
    }

    return uses;
  }

  bool isActivityBasicallyEligible(
    ActivityTypeEnum a, [
    String? morphFeature,
    String? morphTag,
  ]) {
    if (!lemma.saveVocab) {
      return false;
    }

    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        return canBeDefined;
      case ActivityTypeEnum.lemmaId:
        return lemma.saveVocab &&
            text.content.toLowerCase() != lemma.text.toLowerCase();
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.messageMeaning:
        return true;
      case ActivityTypeEnum.morphId:
        return morph.isNotEmpty;
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
        return canBeHeard;
    }
  }

  // bool _didActivity(
  //   ActivityTypeEnum a, [
  //   String? morphFeature,
  //   String? morphTag,
  // ]) {
  //   if ((morphFeature == null || morphTag == null) &&
  //       a == ActivityTypeEnum.morphId) {
  //     debugger(when: kDebugMode);
  //     return true;
  //   }

  //   switch (a) {
  //     case ActivityTypeEnum.wordMeaning:
  //     case ActivityTypeEnum.wordFocusListening:
  //     case ActivityTypeEnum.hiddenWordListening:
  //     case ActivityTypeEnum.lemmaId:
  //     case ActivityTypeEnum.emoji:
  //     case ActivityTypeEnum.messageMeaning:
  //       return vocabConstruct.uses
  //           .map((u) => u.useType)
  //           .any((u) => a.associatedUseTypes.contains(u));
  //     case ActivityTypeEnum.morphId:
  //       return morph.entries
  //           .map((e) => morphConstruct(morphFeature!, morphTag!).uses)
  //           .expand((e) => e)
  //           .any(
  //             (u) =>
  //                 a.associatedUseTypes.contains(u.useType) &&
  //                 u.form == text.content,
  //           );
  //   }
  // }

  bool didActivitySuccessfully(
    ActivityTypeEnum a, [
    String? morphFeature,
    String? morphTag,
  ]) {
    if ((morphFeature == null || morphTag == null) &&
        a == ActivityTypeEnum.morphId) {
      debugger(when: kDebugMode);
      return true;
    }
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
      case ActivityTypeEnum.lemmaId:
      case ActivityTypeEnum.emoji:
        return vocabConstruct.uses
            .map((u) => u.useType)
            .any((u) => u == a.correctUse);
      // Note that it matters less if they did morphId in general, than if they did it with the particular feature
      case ActivityTypeEnum.morphId:
        // TODO: investigate if we take out condition "|| morphTag == null", will we get the expected number of morph activities?
        if (morphFeature == null || morphTag == null) {
          debugger(when: kDebugMode);
          return false;
        }
        return morphConstruct(morphFeature)?.uses.any(
                  (u) => u.useType == a.correctUse && u.form == text.content,
                ) ??
            false;
      case ActivityTypeEnum.messageMeaning:
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          m: "should not call didActivitySuccessfully for ActivityTypeEnum.messageMeaning",
          data: toJson(),
        );
        return true;
    }
  }

  bool _isActivityProbablyLevelAppropriate(
    ActivityTypeEnum a, [
    String? morphFeature,
  ]) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        return vocabConstructID.isActivityProbablyLevelAppropriate(
          a,
          text.content,
        );

      case ActivityTypeEnum.wordFocusListening:
        return !didActivitySuccessfully(a) ||
            daysSinceLastUseByType(a, null) > 30;
      case ActivityTypeEnum.hiddenWordListening:
        return daysSinceLastUseByType(a, null) > 7;
      case ActivityTypeEnum.lemmaId:
        return false;
      // disabling lemma activities for now
      // It has 2 purposes:
      // • learning value
      // • triangulating our determination of the lemma with AI plus user verification.
      // However, displaying the lemma during the meaning activity helps
      // disambiguate what the meaning activity is about. This is probably more valuable than the
      // lemma activity itself. The piping for the lemma activity will stay there if we want to turn
      // it back on, maybe in select instances.
      // return _didActivitySuccessfully(ActivityTypeEnum.wordMeaning) &&
      //     daysSinceLastUseByType(a) > 7;
      case ActivityTypeEnum.emoji:
        return vocabConstructID.isActivityProbablyLevelAppropriate(
          a,
          text.content,
        );

      case ActivityTypeEnum.messageMeaning:
        return true;
      case ActivityTypeEnum.morphId:
        return morphFeature != null
            ? morphIdByFeature(morphFeature)
                    ?.isActivityProbablyLevelAppropriate(a, text.content) ??
                false
            : false;
    }
  }

  /// Safely get morph tag for a given feature without regard for case
  String? getMorphTag(String feature) {
    if (morph.containsKey(feature)) return morph[feature];
    if (morph.containsKey(feature.toLowerCase())) {
      return morph[feature.toLowerCase()];
    }
    final lowerCaseEntries = morph.entries.map(
      (e) => MapEntry(e.key.toLowerCase(), e.value),
    );
    return lowerCaseEntries
        .firstWhereOrNull(
          (e) => e.key == feature.toLowerCase(),
        )
        ?.value;
  }

  // maybe for every 5 points of xp for a particular activity, increment the days between uses by 2
  bool shouldDoActivity({
    required ActivityTypeEnum a,
    required String? feature,
    required String? tag,
  }) {
    return isActivityBasicallyEligible(a, feature, tag) &&
        _isActivityProbablyLevelAppropriate(a, feature);
  }

  ConstructUses get vocabConstruct =>
      MatrixState.pangeaController.getAnalytics.constructListModel
          .getConstructUses(
        vocabConstructID,
      ) ??
      ConstructUses(
        lemma: lemma.text,
        constructType: ConstructTypeEnum.vocab,
        category: pos,
        uses: [],
      );

  ConstructUses? morphConstruct(String morphFeature) =>
      morphIdByFeature(morphFeature)?.constructUses;

  ConstructIdentifier? morphIdByFeature(String feature) {
    final tag = getMorphTag(feature);
    if (tag == null) return null;
    return ConstructIdentifier(
      lemma: tag,
      type: ConstructTypeEnum.morph,
      category: feature,
    );
  }

  /// lastUsed by activity type, construct and form
  DateTime? _lastUsedByActivityType(ActivityTypeEnum a, String? feature) {
    if (a == ActivityTypeEnum.morphId && feature == null) {
      debugger(when: kDebugMode);
      return null;
    }
    final ConstructIdentifier? cId = a == ActivityTypeEnum.morphId
        ? morphIdByFeature(feature!)
        : vocabConstructID;

    if (cId == null) return null;

    final correctUseTimestamps = cId.constructUses.uses
        .where((u) => u.form == text.content)
        .map((u) => u.timeStamp)
        .toList();

    if (correctUseTimestamps.isEmpty) return null;

    // return the most recent timestamp
    return correctUseTimestamps.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// daysSinceLastUse by activity type
  /// returns 1000 if there is no last use
  int daysSinceLastUseByType(ActivityTypeEnum a, String? feature) {
    final lastUsed = _lastUsedByActivityType(a, feature);
    if (lastUsed == null) return 1000;
    return DateTime.now().difference(lastUsed).inDays;
  }

  List<ConstructIdentifier> get _constructIDs {
    final List<ConstructIdentifier> ids = [];
    ids.add(
      ConstructIdentifier(
        lemma: lemma.text,
        type: ConstructTypeEnum.vocab,
        category: pos,
      ),
    );
    for (final morph in morph.entries) {
      ids.add(
        ConstructIdentifier(
          lemma: morph.value,
          type: ConstructTypeEnum.morph,
          category: morph.key,
        ),
      );
    }
    return ids;
  }

  List<ConstructUses> get constructs => _constructIDs
      .map(
        (id) => MatrixState.pangeaController.getAnalytics.constructListModel
            .getConstructUses(id),
      )
      .where((construct) => construct != null)
      .cast<ConstructUses>()
      .toList();

  Future<List<String>> getEmojiChoices() => LemmaInfoRepo.get(
        LemmaInfoRequest(
          lemma: lemma.text,
          partOfSpeech: pos,
          lemmaLang: MatrixState
                  .pangeaController.languageController.userL2?.langCode ??
              LanguageKeys.unknownLanguage,
          userL1: MatrixState
                  .pangeaController.languageController.userL1?.langCode ??
              LanguageKeys.defaultLanguage,
        ),
      ).then((onValue) => onValue.emoji);

  ConstructIdentifier get vocabConstructID => ConstructIdentifier(
        lemma: lemma.text,
        type: ConstructTypeEnum.vocab,
        category: pos,
      );

  /// [setEmoji] sets the emoji for the lemma
  /// NOTE: assumes that the language of the lemma is the same as the user's current l2
  Future<void> setEmoji(List<String> emojis) =>
      vocabConstructID.setUserLemmaInfo(UserSetLemmaInfo(emojis: emojis));

  /// [getEmoji] gets the emoji for the lemma
  /// NOTE: assumes that the language of the lemma is the same as the user's current l2
  List<String> getEmoji() => vocabConstructID.userSetEmoji;

  String get xpEmoji => vocabConstruct.xpEmoji;

  ConstructLevelEnum get lemmaXPCategory {
    if (vocabConstruct.points >= AnalyticsConstants.xpForFlower) {
      return ConstructLevelEnum.flowers;
    } else if (vocabConstruct.points >= AnalyticsConstants.xpForGreens) {
      return ConstructLevelEnum.greens;
    } else {
      return ConstructLevelEnum.seeds;
    }
  }

  List<String> morphActivityDistractors(
    String morphFeature,
    String morphTag,
  ) {
    final List<String> allTags = MorphsRepo.cached.getAllTags(morphFeature);

    final List<String> possibleDistractors = allTags
        .where(
          (tag) => tag.toLowerCase() != morphTag.toLowerCase() && tag != "X",
        )
        .toList();

    possibleDistractors.shuffle();
    return possibleDistractors.take(3).toList();
  }

  /// initial default input mode for a token
  MessageMode get modeForToken {
    // if (getEmoji() == null) {
    //   return MessageMode.wordEmoji;
    // }

    if (shouldDoActivity(
      a: ActivityTypeEnum.wordMeaning,
      feature: null,
      tag: null,
    )) {
      return MessageMode.wordMeaning;
    }

    // final String? morph = nextMorphFeatureEligibleForActivity;
    // if (morph != null) {
    //   debugPrint("should do morph activity for ${text.content}");
    //   return MessageMode.wordMorph;
    // }

    return MessageMode.wordZoom;
  }

  /// cycle through morphs to get the next one where should do morph activity is true
  /// if none are found, return null
  String? get nextMorphFeatureEligibleForActivity {
    final morphFeatures = morph.keys.toList();

    if (shouldDoActivity(
      a: ActivityTypeEnum.morphId,
      feature: "pos",
      tag: morph["pos"],
    )) {
      return "pos";
    }

    for (final feature in morphFeatures.where((f) => f != "pos").toList()) {
      if (shouldDoActivity(
        a: ActivityTypeEnum.morphId,
        feature: feature,
        tag: morph[feature],
      )) {
        return feature;
      }
    }

    return null;
  }

  bool get doesLemmaTextMatchTokenText {
    return lemma.text.toLowerCase() == text.content.toLowerCase();
  }

  // put "pos" first in the list
  List<MapEntry<String, dynamic>> get sortedMorphs {
    final List<MapEntry<String, dynamic>> morphEntries = morph.entries.toList();
    morphEntries.sort((a, b) {
      if (a.key.toLowerCase() == "pos") return -1;
      if (b.key.toLowerCase() == "pos") return 1;
      return a.key.toLowerCase().compareTo(b.key.toLowerCase());
    });
    return morphEntries;
  }

  bool shouldDoActivityByMessageMode(MessageMode mode) {
    // debugPrint("should do activity for ${text.content} in $mode");
    return mode.associatedActivityType != null
        ? shouldDoActivity(
            a: mode.associatedActivityType!,
            feature: null,
            tag: null,
          )
        : false;
  }

  List<ConstructIdentifier> get allConstructIds => _constructIDs;

  List<ConstructIdentifier> get morphConstructIds => morph.entries
      .map(
        (e) => ConstructIdentifier(
          lemma: e.key,
          type: ConstructTypeEnum.morph,
          category: e.value,
        ),
      )
      .toList();

  List<ConstructIdentifier> get morphsBasicallyEligibleForPracticeByPriority =>
      MorphFeaturesEnumExtension.eligibleForPractice.where((f) {
        return f == MorphFeaturesEnum.Pos || getMorphTag(f.name) != null;
      }).map((f) {
        if (f == MorphFeaturesEnum.Pos) {
          return ConstructIdentifier(
            lemma: pos,
            type: ConstructTypeEnum.morph,
            category: f.name,
          );
        }
        return ConstructIdentifier(
          lemma: getMorphTag(f.name)!,
          type: ConstructTypeEnum.morph,
          category: f.name,
        );
      }).toList();

  bool hasMorph(ConstructIdentifier cId) {
    if (cId.category == "pos") {
      return morph["pos"].toString().toLowerCase() == cId.lemma.toLowerCase();
    }
    return morph.entries.any(
      (e) =>
          e.key.toLowerCase() == cId.lemma.toLowerCase() &&
          e.value.toString().toLowerCase() == cId.category.toLowerCase(),
    );
  }

  /// [0,infinity) - a lower number means higher priority
  int activityPriorityScore(ActivityTypeEnum a, String? morphFeature) {
    return daysSinceLastUseByType(a, morphFeature) *
        (vocabConstructID.isContentWord ? 1 : 2);
  }
}
