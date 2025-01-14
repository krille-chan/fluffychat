import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:fluffychat/pangea/choreographer/widgets/igc/word_data_card.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';

class WordData {
  final String word;
  final String fullText;
  final String? userL1;
  final String? userL2;
  // final List<LanguageSense> languageSenses;

  final String targetPartOfSpeech;
  final String basePartOfSpeech;
  final String partOfSpeech;
  final String targetDefinition;
  final String baseDefinition;
  final String targetWord;
  final String baseWord;
  final String baseExampleSentence;
  final String targetExampleSentence;

  WordData({
    // required this.languageSenses,
    required this.fullText,
    required this.word,
    required this.userL1,
    required this.userL2,
    required this.baseDefinition,
    required this.targetDefinition,
    required this.basePartOfSpeech,
    required this.targetPartOfSpeech,
    required this.partOfSpeech,
    required this.baseWord,
    required this.targetWord,
    required this.baseExampleSentence,
    required this.targetExampleSentence,
  });

  // static const String _languageSensesKey = 'sense_responses';
  static const String _dataFullKey = 'data_full';

  Map<String, dynamic> toJson() => {
        // _languageSensesKey: languageSenses.map((e) => e.toJson()).toList(),
        ModelKey.word: word,
        ModelKey.userL1: userL1,
        ModelKey.userL2: userL2,
        ModelKey.baseDefinition: baseDefinition,
        ModelKey.targetDefinition: targetDefinition,
        ModelKey.basePartOfSpeech: basePartOfSpeech,
        ModelKey.targetPartOfSpeech: targetPartOfSpeech,
        ModelKey.partOfSpeech: partOfSpeech,
        ModelKey.baseWord: baseWord,
        ModelKey.targetWord: targetWord,
        ModelKey.baseExampleSentence: baseExampleSentence,
        ModelKey.targetExampleSentence: targetExampleSentence,
      };

  factory WordData.fromJson(
    Map<String, dynamic> json, {
    required String word,
    required String fullText,
    required String userL1,
    required String userL2,
  }) {
    try {
      return WordData(
        // languageSenses: (json[_languageSensesKey] as List<dynamic>)
        //     .map<LanguageSense>(
        //       (e) => LanguageSense.fromJson(e as Map<String, dynamic>),
        //     )
        //     .toList()
        //     .cast<LanguageSense>(),
        baseDefinition: json[_dataFullKey][ModelKey.baseDefinition],
        targetDefinition: json[_dataFullKey][ModelKey.targetDefinition],
        basePartOfSpeech: json[_dataFullKey][ModelKey.basePartOfSpeech],
        targetPartOfSpeech: json[_dataFullKey][ModelKey.targetPartOfSpeech],
        partOfSpeech: json[_dataFullKey][ModelKey.partOfSpeech],
        baseWord: json[_dataFullKey][ModelKey.baseWord],
        targetWord: json[_dataFullKey][ModelKey.targetWord],
        baseExampleSentence: json[_dataFullKey][ModelKey.baseExampleSentence],
        targetExampleSentence: json[_dataFullKey]
            [ModelKey.targetExampleSentence],
        word: word,
        userL1: userL1,
        userL2: userL2,
        fullText: fullText,
      );
    } catch (err) {
      debugger(when: kDebugMode);
      return [] as WordData;
    }
  }

  bool isMatch({
    required String w,
    required String f,
    required String? l1,
    required String? l2,
  }) =>
      word == w && userL1 == l1 && userL2 == l2 && fullText == f;

  String? formattedPartOfSpeech(LanguageType languageType) {
    final String pos = languageType == LanguageType.base
        ? basePartOfSpeech
        : targetPartOfSpeech;
    if (pos.isEmpty) return null;
    return pos[0].toUpperCase() + pos.substring(1);
  }

  // List<LanguageSense> sensesForLanguage(String code) =>
  //     languageSenses.where((langSense) => langSense.langCode == code).toList();
}

// class LanguageSense {
//   List<Sense> senses;
//   String langCode;

//   LanguageSense({
//     required this.senses,
//     required this.langCode,
//   });

//   static const String _sensesKey = "senses";
//   static const String _langCodeKey = "lang_code";

//   Map<String, dynamic> toJson() => {
//         _sensesKey: senses.map((e) => e.toJson()).toList(),
//         _langCodeKey: langCode,
//       };

//   factory LanguageSense.fromJson(Map<String, dynamic> json) => LanguageSense(
//         senses: (json[_sensesKey] as List<dynamic>)
//             .map<Sense>(
//               (e) => Sense.fromJson(e as Map<String, dynamic>),
//             )
//             .toList()
//             .cast<Sense>(),
//         langCode: json[_langCodeKey],
//       );

//   List<String> get partsOfSpeech =>
//       senses.map((sense) => sense.partOfSpeech).toSet().toList();

//   List<String> definitionsForPartOfSpeech(String partOfSpeech) {
//     final List<String> definitions = [];
//     for (final Sense sense in senses) {
//       if (sense.partOfSpeech == partOfSpeech &&
//           sense.definition != null &&
//           sense.definition!.isNotEmpty) {
//         definitions.add(sense.definition!);
//       }
//     }
//     return definitions;
//   }

//   // List<String> partOfSpeechSense(partOfSpeech) {
//   //   return senses
//   //       .where((sense) => sense.partOfSpeech == partOfSpeech)
//   //       .map((sense) => sense.lemmas.join(', '))
//   //       .toSet()
//   //       .toList();
//   // }

//   // Map<String, List<String>> get partOfSpeechSenses {
//   //   final Map<String, List<String>> senses = {};
//   //   for (final partOfSpeech in partsOfSpeech) {
//   //     senses[partOfSpeech] = partOfSpeechSense(partOfSpeech);
//   //   }
//   //   return senses;
//   // }
// }

// class Sense {
//   String partOfSpeech;
//   List<String> lemmas;
//   String? definition;

//   Sense({
//     required this.partOfSpeech,
//     required this.lemmas,
//     required this.definition,
//   });

//   static const String _posKey = "pos";
//   static const String _lemmasKey = "lemmas";
//   static const String _definitionKey = "definition";

//   Map<String, dynamic> toJson() => {
//         _posKey: partOfSpeech,
//         _lemmasKey: lemmas.toString(),
//         _definitionKey: definition
//       };

//   factory Sense.fromJson(Map<String, dynamic> json) => Sense(
//         partOfSpeech: json[_posKey],
//         lemmas: (json[_lemmasKey] as List<dynamic>).cast<String>(),
//         definition: json[_definitionKey],
//       );
// }
