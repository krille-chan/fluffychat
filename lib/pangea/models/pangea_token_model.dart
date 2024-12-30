import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/extensions/client_extension/client_extension.dart';
import 'package:fluffychat/pangea/models/analytics/construct_use_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/repo/lemma_definition_repo.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

import '../constants/model_keys.dart';
import 'lemma.dart';

class PangeaToken {
  PangeaTokenText text;

  //TODO - make this a string and move save_vocab to this class
  // clients have been able to handle null lemmas for 12 months so this is safe
  Lemma lemma;

  /// [pos] ex "VERB" - part of speech of the token
  /// https://universaldependencies.org/u/pos/
  final String pos;

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
        "PROPN",
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

  bool _isActivityBasicallyEligible(ActivityTypeEnum a) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        return canBeDefined;
      case ActivityTypeEnum.lemmaId:
        return lemma.saveVocab;
      case ActivityTypeEnum.emoji:
        return true;
      case ActivityTypeEnum.morphId:
        return morph.isNotEmpty;
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.hiddenWordListening:
        return canBeHeard;
    }
  }

  bool _didActivity(
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
            .any((u) => a.associatedUseTypes.contains(u));
      case ActivityTypeEnum.morphId:
        return morph.entries
            .map((e) => morphConstruct(morphFeature!, morphTag!).uses)
            .expand((e) => e)
            .any(
              (u) =>
                  a.associatedUseTypes.contains(u.useType) &&
                  u.form == text.content,
            );
    }
  }

  bool _didActivitySuccessfully(
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
        if (morphFeature == null || morphTag == null) {
          debugger(when: kDebugMode);
          return false;
        }
        return morphConstruct(morphFeature, morphTag)
            .uses
            .any((u) => u.useType == a.correctUse && u.form == text.content);
    }
  }

  bool _isActivityProbablyLevelAppropriate(
    ActivityTypeEnum a, [
    String? morphFeature,
    String? morphTag,
  ]) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        if (daysSinceLastUseByType(ActivityTypeEnum.wordMeaning) < 1) {
          return false;
        }

        if (isContentWord) {
          return vocabConstruct.points < 30;
        } else if (canBeDefined) {
          return vocabConstruct.points < 5;
        } else {
          return false;
        }
      case ActivityTypeEnum.wordFocusListening:
        return !_didActivitySuccessfully(a) || daysSinceLastUseByType(a) > 30;
      case ActivityTypeEnum.hiddenWordListening:
        return daysSinceLastUseByType(a) > 7;
      case ActivityTypeEnum.lemmaId:
        return daysSinceLastUseByType(a) > 7;
      case ActivityTypeEnum.emoji:
        return getEmoji() == null;
      case ActivityTypeEnum.morphId:
        if (morphFeature == null || morphTag == null) {
          debugger(when: kDebugMode);
          return false;
        }
        return daysSinceLastUseMorph(morphFeature, morphTag) > 1 &&
            morphConstruct(morphFeature, morphTag).points < 5;
    }
  }

  bool get shouldDoPosActivity => shouldDoMorphActivity("pos");

  bool shouldDoMorphActivity(String feature) {
    return shouldDoActivity(
      a: ActivityTypeEnum.morphId,
      feature: feature,
      tag: getMorphTag(feature),
    );
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

  Future<bool> canGenerateDistractors(
    ActivityTypeEnum type, {
    String? morphFeature,
    String? morphTag,
  }) async {
    final constructListModel =
        MatrixState.pangeaController.getAnalytics.constructListModel;
    switch (type) {
      case ActivityTypeEnum.lemmaId:
        final distractors =
            await constructListModel.lemmaActivityDistractors(this);
        return distractors.isNotEmpty;
      case ActivityTypeEnum.morphId:
        final distractors = constructListModel.morphActivityDistractors(
          morphFeature!,
          morphTag!,
        );
        return distractors.isNotEmpty;
      case ActivityTypeEnum.emoji:
      case ActivityTypeEnum.wordFocusListening:
      case ActivityTypeEnum.wordMeaning:
      case ActivityTypeEnum.hiddenWordListening:
        return true;
    }
  }

  // maybe for every 5 points of xp for a particular activity, increment the days between uses by 2
  bool shouldDoActivity({
    required ActivityTypeEnum a,
    required String? feature,
    required String? tag,
  }) {
    return lemma.saveVocab &&
        _isActivityBasicallyEligible(a) &&
        _isActivityProbablyLevelAppropriate(a, feature, tag);
  }

  List<ActivityTypeEnum> get eligibleActivityTypes {
    final List<ActivityTypeEnum> eligibleActivityTypes = [];

    if (!lemma.saveVocab) {
      return eligibleActivityTypes;
    }

    for (final type in ActivityTypeEnum.values) {
      if (shouldDoActivity(a: type, feature: null, tag: null)) {
        eligibleActivityTypes.add(type);
      }
    }

    return eligibleActivityTypes;
  }

  ConstructUses get vocabConstruct =>
      MatrixState.pangeaController.getAnalytics.constructListModel
          .getConstructUses(
        ConstructIdentifier(
          lemma: lemma.text,
          type: ConstructTypeEnum.morph,
          category: pos,
        ),
      ) ??
      ConstructUses(
        lemma: lemma.text,
        constructType: ConstructTypeEnum.morph,
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
  DateTime? _lastUsedByActivityType(ActivityTypeEnum a) =>
      constructs.where((c) => a.constructFilter(c.id)).fold<DateTime?>(
        null,
        (previousValue, element) {
          if (previousValue == null) return element.lastUsed;
          if (element.lastUsed == null) return previousValue;
          return element.lastUsed!.isAfter(previousValue)
              ? element.lastUsed
              : previousValue;
        },
      );

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

  Map<String, dynamic> toServerChoiceTokenWithXP() {
    return {
      'token': toJson(),
      'constructs_with_xp': constructs.map((e) => e.toJson()).toList(),
      'target_types': eligibleActivityTypes.map((e) => e.string).toList(),
    };
  }

  Future<List<String>> getEmojiChoices() => LemmaDictionaryRepo.get(
        LemmaDefinitionRequest(
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

  Room? get analyticsRoom {
    final String? l2 =
        MatrixState.pangeaController.languageController.userL2?.langCode;

    if (l2 == null) {
      debugger(when: kDebugMode);
      return null;
    }

    final Room? analyticsRoom =
        MatrixState.pangeaController.matrixState.client.analyticsRoomLocal(l2);

    if (analyticsRoom == null) {
      debugger(when: kDebugMode);
    }

    return analyticsRoom;
  }

  /// [setEmoji] sets the emoji for the lemma
  /// NOTE: assumes that the language of the lemma is the same as the user's current l2
  Future<void> setEmoji(String emoji) async {
    if (analyticsRoom == null) return;
    try {
      final client = MatrixState.pangeaController.matrixState.client;
      final syncFuture = client.onRoomState.stream.firstWhere((event) {
        return event.roomId == analyticsRoom!.id &&
            event.state.type == PangeaEventTypes.userChosenEmoji;
      });
      client.setRoomStateWithKey(
        analyticsRoom!.id,
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
    return analyticsRoom
        ?.getState(PangeaEventTypes.userChosenEmoji, vocabConstructID.string)
        ?.content
        .tryGet<String>(ModelKey.emoji);
  }

  String get xpEmoji {
    if (xp < 30) {
      // bean emoji
      return "🫛";
    } else if (xp < 100) {
      // sprout emoji
      return "🌱";
    } else {
      // flower emoji
      return "🌺";
    }
  }
}
