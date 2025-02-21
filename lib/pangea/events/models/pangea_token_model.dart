import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_misc/analytics_constants.dart';
import 'package:fluffychat/pangea/analytics_misc/client_analytics_extension.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_identifier.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_level_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_repo.dart';
import 'package:fluffychat/pangea/lemmas/lemma_info_request.dart';
import 'package:fluffychat/pangea/toolbar/enums/activity_type_enum.dart';
import 'package:fluffychat/pangea/toolbar/repo/lemma_activity_generator.dart';
import 'package:fluffychat/pangea/toolbar/repo/lemma_meaning_activity_generator.dart';
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

  bool get isContentWord =>
      ["NOUN", "VERB", "ADJ", "ADV"].contains(pos) && lemma.saveVocab;

  String get analyticsDebugPrint =>
      "content: ${text.content} isContentWord: $isContentWord total_xp:$xp vocab_construct_xp: ${vocabConstruct.points} daysSincelastUseInWordMeaning ${daysSinceLastUseByType(ActivityTypeEnum.wordMeaning)}";

  bool get canBeDefined =>
      [
        "ADJ",
        "ADP",
        "ADV",
        "AUX",
        "CCONJ",
        "DET",
        "INTJ",
        "NOUN",
        "NUM",
        "PRON",
        "SCONJ",
        "VERB",
      ].contains(pos) &&
      lemma.saveVocab;

  bool get canBeHeard =>
      [
        "ADJ",
        "ADV",
        "AUX",
        "DET",
        "INTJ",
        "NOUN",
        "NUM",
        "PRON",
        "PROPN",
        "SCONJ",
        "VERB",
      ].contains(pos) &&
      lemma.saveVocab;

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

    bool canGenerate = false;
    if (a != ActivityTypeEnum.lemmaId) {
      canGenerate = _canGenerateDistractors(
        a,
        morphFeature: morphFeature,
        morphTag: morphTag,
      );
    }

    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        return canBeDefined && canGenerate;
      case ActivityTypeEnum.lemmaId:
        return lemma.saveVocab &&
            text.content.toLowerCase() != lemma.text.toLowerCase();
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.messageMeaning:
        return true;
      case ActivityTypeEnum.morphId:
        return morph.isNotEmpty && canGenerate;
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
        return morphConstruct(morphFeature, morphTag)
            .uses
            .any((u) => u.useType == a.correctUse && u.form == text.content);
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
    String? morphTag,
  ]) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        if (daysSinceLastUseByType(ActivityTypeEnum.wordMeaning) < 7 ||
            daysSinceLastUseByType(ActivityTypeEnum.messageMeaning) < 7) {
          return false;
        }

        // if last used less than 1 day ago, return false
        // this is largely to account for cases of sending a message with some
        // error that gets you negative points for it
        if (vocabConstruct.lastUsed != null &&
            DateTime.now().difference(vocabConstruct.lastUsed!).inDays < 1) {
          return false;
        }

        if (isContentWord) {
          return vocabConstruct.points < 1;
        } else if (canBeDefined) {
          return vocabConstruct.points < 1;
        } else {
          return false;
        }
      case ActivityTypeEnum.wordFocusListening:
        return !didActivitySuccessfully(a) || daysSinceLastUseByType(a) > 30;
      case ActivityTypeEnum.hiddenWordListening:
        return daysSinceLastUseByType(a) > 7;
      case ActivityTypeEnum.lemmaId:
        return false;
      // disabling lemma activities for now
      // It has 2 purposes:• learning value• triangulating our determination of the lemma with
      // AI plus user verification.However, displaying the lemma during the meaning activity helps
      // disambiguate what the meaning activity is about. This is probably more valuable than the
      // lemma activity itself. The piping for the lemma activity will stay there if we want to turn
      //it back on, maybe in select instances.
      // return _didActivitySuccessfully(ActivityTypeEnum.wordMeaning) &&
      //     daysSinceLastUseByType(a) > 7;
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.messageMeaning:
        return true;
      case ActivityTypeEnum.morphId:
        if (morphFeature == null || morphTag == null) {
          debugger(when: kDebugMode);
          return false;
        }
        return daysSinceLastUseMorph(morphFeature, morphTag) > 1 &&
            morphConstruct(morphFeature, morphTag).points < 5;
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

  /// Syncronously determine if a distractor can be generated for a given activity type.
  /// WARNING - do not use this function to determine if lemma activities can be generated.
  /// Use [canGenerateLemmaDistractors] instead.
  bool _canGenerateDistractors(
    ActivityTypeEnum type, {
    String? morphFeature,
    String? morphTag,
  }) {
    switch (type) {
      case ActivityTypeEnum.lemmaId:
        // the function to determine this for lemmas is async
        // do not use this function for lemma activities
        debugger(when: kDebugMode);
        return false;
      case ActivityTypeEnum.morphId:
        final distractors = morphActivityDistractors(
          morphFeature!,
          morphTag!,
        );
        return distractors.isNotEmpty;
      case ActivityTypeEnum.wordMeaning:
        return LemmaMeaningActivityGenerator.canGenerateDistractors(
          lemma.text,
          pos,
        );
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
      case ActivityTypeEnum.messageMeaning:
        return true;
    }
  }

  Future<bool> canGenerateLemmaDistractors() async {
    final distractors =
        await LemmaActivityGenerator().lemmaActivityDistractors(this);
    return distractors.isNotEmpty;
  }

  // maybe for every 5 points of xp for a particular activity, increment the days between uses by 2
  bool shouldDoActivity({
    required ActivityTypeEnum a,
    required String? feature,
    required String? tag,
  }) {
    return isActivityBasicallyEligible(a, feature, tag) &&
        _isActivityProbablyLevelAppropriate(a, feature, tag);
  }

  ConstructUses get vocabConstruct =>
      MatrixState.pangeaController.getAnalytics.constructListModel
          .getConstructUses(
        ConstructIdentifier(
          lemma: lemma.text,
          type: ConstructTypeEnum.vocab,
          category: pos,
        ),
      ) ??
      ConstructUses(
        lemma: lemma.text,
        constructType: ConstructTypeEnum.vocab,
        category: pos,
        uses: [],
      );

  ConstructUses morphConstruct(String morphFeature, String morphTag) =>
      MatrixState.pangeaController.getAnalytics.constructListModel
          .getConstructUses(
        ConstructIdentifier(
          lemma: morphTag,
          type: ConstructTypeEnum.morph,
          category: morphFeature,
        ),
      ) ??
      ConstructUses(
        lemma: morphTag,
        constructType: ConstructTypeEnum.morph,
        category: morphFeature,
        uses: [],
      );

  int get xp {
    return constructs.fold<int>(
      0,
      (previousValue, element) => previousValue + element.points,
    );
  }

  /// lastUsed by activity type
  DateTime? _lastUsedByActivityType(ActivityTypeEnum a) {
    final List<ConstructUses> filteredConstructs =
        constructs.where((c) => a.constructFilter(c.id)).toList();
    final correctUseTimestamps = filteredConstructs
        .expand((c) => c.uses)
        .where((u) => u.useType == a.correctUse)
        .map((u) => u.timeStamp)
        .toList();

    if (correctUseTimestamps.isEmpty) return null;

    // return the most recent timestamp
    return correctUseTimestamps.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// daysSinceLastUse by activity type
  int daysSinceLastUseByType(ActivityTypeEnum a) {
    final lastUsed = _lastUsedByActivityType(a);
    if (lastUsed == null) return 1000;
    return DateTime.now().difference(lastUsed).inDays;
  }

  int daysSinceLastUseMorph(String morphFeature, String morphTag) {
    final lastUsed = morphConstruct(morphFeature, morphTag).lastUsed;
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
  Future<void> setEmoji(String emoji) async {
    final analyticsRoom =
        MatrixState.pangeaController.matrixState.client.analyticsRoomLocal();
    if (analyticsRoom == null) return;
    try {
      final client = MatrixState.pangeaController.matrixState.client;
      final syncFuture = client.onRoomState.stream.firstWhere((event) {
        return event.roomId == analyticsRoom.id &&
            event.state.type == PangeaEventTypes.userChosenEmoji;
      });
      client.setRoomStateWithKey(
        analyticsRoom.id,
        PangeaEventTypes.userChosenEmoji,
        vocabConstructID.string,
        {ModelKey.emoji: emoji},
      );
      await syncFuture;
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        data: {
          "construct": vocabConstructID.string,
          "emoji": emoji,
        },
        s: s,
      );
    }
  }

  /// [getEmoji] gets the emoji for the lemma
  /// NOTE: assumes that the language of the lemma is the same as the user's current l2
  String? getEmoji() {
    final analyticsRoom =
        MatrixState.pangeaController.matrixState.client.analyticsRoomLocal();
    return analyticsRoom
        ?.getState(PangeaEventTypes.userChosenEmoji, vocabConstructID.string)
        ?.content
        .tryGet<String>(ModelKey.emoji);
  }

  String get xpEmoji {
    if (vocabConstruct.points < 30) {
      // bean emoji
      return "🫛";
    } else if (vocabConstruct.points < 100) {
      // sprout emoji
      return "🌱";
    } else {
      // flower emoji
      return "🌺";
    }
  }

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
    final List<ConstructUses> morphConstructs = MatrixState
        .pangeaController.getAnalytics.constructListModel
        .constructList(type: ConstructTypeEnum.morph);
    final List<String> possibleDistractors = morphConstructs
        .where(
          (c) =>
              c.category == morphFeature.toLowerCase() &&
              c.lemma.toLowerCase() != morphTag.toLowerCase() &&
              c.lemma.isNotEmpty &&
              c.lemma != "X",
        )
        .map((c) => c.lemma)
        .toList();

    possibleDistractors.shuffle();
    return possibleDistractors.take(3).toList();
  }
}
