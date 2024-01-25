import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../constants/model_keys.dart';
import '../utils/error_handler.dart';
import 'lemma.dart';

class PangeaToken {
  PangeaTokenText text;
  bool hasInfo;
  List<Lemma> lemmas;

  PangeaToken({
    required this.text,
    required this.hasInfo,
    required this.lemmas,
  });

  static getLemmas(String text, Iterable? json) {
    if (json != null) {
      return json
          .map<Lemma>(
            (e) => Lemma.fromJson(e as Map<String, dynamic>),
          )
          .toList()
          .cast<Lemma>();
    } else {
      return [Lemma(text: text, saveVocab: false, form: text)];
    }
  }

  factory PangeaToken.fromJson(Map<String, dynamic> json) {
    try {
      final PangeaTokenText text =
          PangeaTokenText.fromJson(json[_textKey] as Map<String, dynamic>);
      return PangeaToken(
        text: text,
        hasInfo: json[_hasInfoKey] ?? text.length > 2,
        lemmas: getLemmas(text.content, json[_lemmaKey]),
      );
    } catch (err, s) {
      debugger(when: kDebugMode);
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "PangeaToken.fromJson error",
          data: {
            "json": json,
          },
        ),
      );
      ErrorHandler.logError(e: err, s: s);
      rethrow;
    }
  }

  static const String _textKey = "text";
  static const String _hasInfoKey = "has_info";
  static const String _lemmaKey = ModelKey.lemma;

  Map<String, dynamic> toJson() => {
        _textKey: text,
        _hasInfoKey: hasInfo,
        _lemmaKey: lemmas.map((e) => e.toJson()).toList(),
      };

  int get end => text.offset + text.length;
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
}
