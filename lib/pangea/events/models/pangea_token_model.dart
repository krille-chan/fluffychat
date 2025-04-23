import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_form.dart';
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
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/message_morph_choice.dart';
import 'package:fluffychat/widgets/matrix.dart';
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
  final Map<MorphFeaturesEnum, String> _morph;

  PangeaToken({
    required this.text,
    required this.lemma,
    required this.pos,
    required Map<MorphFeaturesEnum, String> morph,
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

  /// [morph] - morphological features of the token
  /// includes the part of speech if it is not already included
  /// https://universaldependencies.org/u/feat/
  Map<MorphFeaturesEnum, String> get morph {
    if (_morph.keys.contains(MorphFeaturesEnum.Pos)) {
      return _morph;
    }
    final morphWithPos = Map<MorphFeaturesEnum, String>.from(_morph);
    morphWithPos[MorphFeaturesEnum.Pos] = pos;
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
      morph: json['morph'] != null
          ? (json['morph'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                MorphFeaturesEnumExtension.fromString(key),
                value as String,
              ),
            )
          : {},
    );
  }

  static const String _textKey = "text";
  static const String _lemmaKey = ModelKey.lemma;

  Map<String, dynamic> toJson() => {
        _textKey: text.toJson(),
        _lemmaKey: [lemma.toJson()],
        'pos': pos,
        // store morph as a map of strings ie Map<feature.name,tag>
        'morph': morph.map(
          (key, value) => MapEntry(key.name, value),
        ),
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
    int xp,
  ) {
    return OneConstructUse(
      useType: type,
      lemma: lemma.text,
      form: text.content,
      constructType: ConstructTypeEnum.vocab,
      metadata: metadata,
      category: pos,
      xp: xp,
    );
  }

  List<OneConstructUse> allUses(
    ConstructUseTypeEnum type,
    ConstructUseMetaData metadata,
    int xp,
  ) {
    final List<OneConstructUse> uses = [];
    if (!lemma.saveVocab) return uses;

    uses.add(toVocabUse(type, metadata, xp));
    for (final morphFeature in morph.keys) {
      uses.add(
        OneConstructUse(
          useType: type,
          lemma: morph[morphFeature]!,
          form: text.content,
          constructType: ConstructTypeEnum.morph,
          metadata: metadata,
          category: morphFeature,
          xp: xp,
        ),
      );
    }

    return uses;
  }

  bool isActivityBasicallyEligible(
    ActivityTypeEnum a, [
    MorphFeaturesEnum? morphFeature,
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
    MorphFeaturesEnum? morphFeature,
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
    MorphFeaturesEnum? morphFeature,
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
  String? getMorphTag(MorphFeaturesEnum feature) {
    // if the morph contains the feature, return it
    if (morph.containsKey(feature)) return morph[feature];

    return null;
  }

  // maybe for every 5 points of xp for a particular activity, increment the days between uses by 2
  bool shouldDoActivity({
    required ActivityTypeEnum a,
    required MorphFeaturesEnum? feature,
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

  ConstructUses? morphConstruct(MorphFeaturesEnum morphFeature) =>
      morphIdByFeature(morphFeature)?.constructUses;

  ConstructIdentifier? morphIdByFeature(MorphFeaturesEnum feature) {
    final tag = getMorphTag(feature);
    if (tag == null) return null;
    return ConstructIdentifier(
      lemma: tag,
      type: ConstructTypeEnum.morph,
      category: feature.name,
    );
  }

  /// lastUsed by activity type, construct and form
  DateTime? _lastUsedByActivityType(
    ActivityTypeEnum a,
    MorphFeaturesEnum? feature,
  ) {
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
  int daysSinceLastUseByType(ActivityTypeEnum a, MorphFeaturesEnum? feature) {
    final lastUsed = _lastUsedByActivityType(a, feature);
    if (lastUsed == null) return 20;
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
          category: morph.key.name,
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

  ConstructForm get vocabForm =>
      ConstructForm(form: text.content, cId: vocabConstructID);

  /// [setEmoji] sets the emoji for the lemma
  /// NOTE: assumes that the language of the lemma is the same as the user's current l2
  Future<void> setEmoji(List<String> emojis) =>
      vocabConstructID.setUserLemmaInfo(UserSetLemmaInfo(emojis: emojis));

  Future<void> setMeaning(String meaning) =>
      vocabConstructID.setUserLemmaInfo(UserSetLemmaInfo(meaning: meaning));

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
    MorphFeaturesEnum morphFeature,
    String morphTag,
  ) {
    final List<String> allTags =
        MorphsRepo.cached.getDisplayTags(morphFeature.name);

    final List<String> possibleDistractors = allTags
        .where(
          (tag) => tag.toLowerCase() != morphTag.toLowerCase() && tag != "X",
        )
        .toList();

    possibleDistractors.shuffle();
    return possibleDistractors.take(numberOfMorphDistractors).toList();
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

  List<MorphFeaturesEnum> get allMorphFeatures => morph.keys.toList();

  /// cycle through morphs to get the next one where should do morph activity is true
  /// if none are found, return null
  MorphFeaturesEnum? get nextMorphFeatureEligibleForActivity {
    for (final m in morph.entries) {
      if (shouldDoActivity(
        a: ActivityTypeEnum.morphId,
        feature: m.key,
        tag: m.value,
      )) {
        return m.key;
      }
    }

    return null;
  }

  bool get doesLemmaTextMatchTokenText {
    return lemma.text.toLowerCase() == text.content.toLowerCase();
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

  List<ConstructIdentifier> get morphsBasicallyEligibleForPracticeByPriority =>
      MorphFeaturesEnumExtension.eligibleForPractice.where((f) {
        return morph.containsKey(f);
      }).map((f) {
        return ConstructIdentifier(
          lemma: getMorphTag(f)!,
          type: ConstructTypeEnum.morph,
          category: f.name,
        );
      }).toList();

  bool hasMorph(ConstructIdentifier cId) {
    return morph.entries.any(
      (e) =>
          e.key.name == cId.lemma.toLowerCase() &&
          e.value.toString().toLowerCase() == cId.category.toLowerCase(),
    );
  }

  /// [0,infinity) - a higher number means higher priority
  int activityPriorityScore(
    ActivityTypeEnum a,
    MorphFeaturesEnum? morphFeature,
  ) {
    return daysSinceLastUseByType(a, morphFeature) *
        (vocabConstructID.isContentWord ? 10 : 9);
  }
}
