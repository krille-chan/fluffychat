import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/construct_use_model.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';

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

  /// [morph] ex {} - morphological features of the token
  /// https://universaldependencies.org/u/feat/
  final Map<String, dynamic> morph;

  PangeaToken({
    required this.text,
    required this.lemma,
    required this.pos,
    required this.morph,
  });

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
      case ActivityTypeEnum.wordFocusListening:
        return false;
      case ActivityTypeEnum.hiddenWordListening:
        return canBeHeard;
    }
  }

  bool _didActivity(ActivityTypeEnum a) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        return vocabConstruct.uses
            .map((u) => u.useType)
            .any((u) => a.associatedUseTypes.contains(u));
      case ActivityTypeEnum.wordFocusListening:
        return vocabConstruct.uses
            // TODO - double-check that form is going to be available here
            // .where((u) =>
            //     u.form?.toLowerCase() == text.content.toLowerCase(),)
            .map((u) => u.useType)
            .any((u) => a.associatedUseTypes.contains(u));
      case ActivityTypeEnum.hiddenWordListening:
        return vocabConstruct.uses
            // TODO - double-check that form is going to be available here
            // .where((u) =>
            //     u.form?.toLowerCase() == text.content.toLowerCase(),)
            .map((u) => u.useType)
            .any((u) => a.associatedUseTypes.contains(u));
    }
  }

  bool _didActivitySuccessfully(ActivityTypeEnum a) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
        return vocabConstruct.uses
            .map((u) => u.useType)
            .any((u) => u == ConstructUseTypeEnum.corPA);
      case ActivityTypeEnum.wordFocusListening:
        return vocabConstruct.uses
            // TODO - double-check that form is going to be available here
            // .where((u) =>
            //     u.form?.toLowerCase() == text.content.toLowerCase(),)
            .map((u) => u.useType)
            .any((u) => u == ConstructUseTypeEnum.corWL);
      case ActivityTypeEnum.hiddenWordListening:
        return vocabConstruct.uses
            // TODO - double-check that form is going to be available here
            // .where((u) =>
            //     u.form?.toLowerCase() == text.content.toLowerCase(),)
            .map((u) => u.useType)
            .any((u) => u == ConstructUseTypeEnum.corHWL);
    }
  }

  bool _isActivityProbablyLevelAppropriate(ActivityTypeEnum a) {
    switch (a) {
      case ActivityTypeEnum.wordMeaning:
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
        return daysSinceLastUseByType(a) > 2;
    }
  }

  // maybe for every 5 points of xp for a particular activity, increment the days between uses by 2
  bool shouldDoActivity(ActivityTypeEnum a) =>
      lemma.saveVocab &&
      _isActivityBasicallyEligible(a) &&
      _isActivityProbablyLevelAppropriate(a);

  /// we try to guess if the user is click on a token specifically or clicking on a message in general
  /// if we think the word might be new for the learner, then we'll assume they're clicking on the word
  bool get shouldDoWordMeaningOnClick =>
      lemma.saveVocab &&
      canBeDefined &&
      daysSinceLastUseByType(ActivityTypeEnum.wordMeaning) > 1;

  List<ActivityTypeEnum> get eligibleActivityTypes {
    final List<ActivityTypeEnum> eligibleActivityTypes = [];

    if (!lemma.saveVocab) {
      return eligibleActivityTypes;
    }

    for (final type in ActivityTypeEnum.values) {
      if (shouldDoActivity(type)) {
        eligibleActivityTypes.add(type);
      }
    }

    return eligibleActivityTypes;
  }

  ConstructUses get vocabConstruct {
    final vocab = constructs.firstWhereOrNull(
      (element) => element.id.type == ConstructTypeEnum.vocab,
    );
    if (vocab == null) {
      return ConstructUses(
        lemma: lemma.text,
        constructType: ConstructTypeEnum.vocab,
        category: pos,
        uses: [],
      );
    }
    return vocab;
  }

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
}

class PangeaTokenText {
  int offset;
  String content;
  int length;

  PangeaTokenText({
    required this.offset,
    required this.content,
    required this.length,
  });

  factory PangeaTokenText.fromJson(Map<String, dynamic> json) {
    debugger(when: kDebugMode && json[_offsetKey] == null);
    return PangeaTokenText(
      offset: json[_offsetKey],
      content: json[_contentKey],
      length: json[_lengthKey] ?? (json[_contentKey] as String).length,
    );
  }

  static const String _offsetKey = "offset";
  static const String _contentKey = "content";
  static const String _lengthKey = "length";

  Map<String, dynamic> toJson() =>
      {_offsetKey: offset, _contentKey: content, _lengthKey: length};

  //override equals and hashcode
  @override
  bool operator ==(Object other) {
    if (other is PangeaTokenText) {
      return other.offset == offset &&
          other.content == content &&
          other.length == length;
    }
    return false;
  }

  @override
  int get hashCode => offset.hashCode ^ content.hashCode ^ length.hashCode;
}
