import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/message_activity_request.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:flutter/foundation.dart';

import '../constants/model_keys.dart';
import 'lemma.dart';

class PangeaToken {
  PangeaTokenText text;
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

  static String reconstructText(
    List<PangeaToken> tokens, [
    int startTokenIndex = 0,
    int endTokenIndex = -1,
  ]) {
    if (endTokenIndex == -1) {
      endTokenIndex = tokens.length - 1;
    }

    final List<PangeaToken> subset =
        tokens.whereIndexed((int index, PangeaToken token) {
      return index >= startTokenIndex && index <= endTokenIndex;
    }).toList();

    if (subset.isEmpty) {
      debugger(when: kDebugMode);
      return '';
    }

    if (subset.length == 1) {
      return subset.first.text.content;
    }

    String reconstruction = subset.first.text.content;
    for (int i = 1; i < subset.length - 1; i++) {
      int whitespace = subset[i].text.offset -
          (subset[i - 1].text.offset + subset[i - 1].text.length);
      if (whitespace < 0) {
        debugger(when: kDebugMode);
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

  /// create an empty tokenWithXP object
  TokenWithXP get emptyTokenWithXP {
    final List<ConstructWithXP> constructs = [];

    constructs.add(
      ConstructWithXP(
        id: ConstructIdentifier(
          lemma: lemma.text,
          type: ConstructTypeEnum.vocab,
        ),
        xp: 0,
        lastUsed: null,
      ),
    );

    for (final morph in morph.entries) {
      constructs.add(
        ConstructWithXP(
          id: ConstructIdentifier(
            lemma: morph.key,
            type: ConstructTypeEnum.morph,
          ),
          xp: 0,
          lastUsed: null,
        ),
      );
    }

    return TokenWithXP(
      token: this,
      constructs: constructs,
    );
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
