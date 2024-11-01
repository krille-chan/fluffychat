// import 'dart:convert';
// import 'dart:developer';

// import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
// import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';

// import '../enum/vocab_proficiency_enum.dart';

// class VocabHeadwords {
//   List<VocabList> lists;

//   VocabHeadwords({
//     required this.lists,
//   });

//   /// in json parameter, keys are the names of the VocabList
//   /// values are the words in the VocabList
//   factory VocabHeadwords.fromJson(Map<String, dynamic> json) {
//     final List<VocabList> lists = [];
//     for (final entry in json.entries) {
//       lists.add(
//         VocabList(
//           name: entry.key,
//           lemmas: (entry.value as Iterable).cast<String>().toList(),
//         ),
//       );
//     }
//     return VocabHeadwords(lists: lists);
//   }

//   static Future<VocabHeadwords> getHeadwords(String langCode) async {
//     final String data =
//         await rootBundle.loadString('${langCode}_headwords.json');
//     final decoded = jsonDecode(data);
//     final VocabHeadwords headwords = VocabHeadwords.fromJson(decoded);
//     return headwords;
//   }
// }

// class VocabList {
//   String name;

//   /// key is lemma
//   Map<String, VocabTotals> words = {};

//   VocabList({
//     required this.name,
//     required List<String> lemmas,
//   }) {
//     for (final lemma in lemmas) {
//       words[lemma] = VocabTotals.newTotals;
//     }
//   }

//   void addVocabUse(String lemma, List<OneConstructUse> use) {
//     words[lemma.toUpperCase()]?.addVocabUseBasedOnUseType(use);
//   }

//   ListTotals calculuateTotals() {
//     final ListTotals listTotals = ListTotals.empty;
//     for (final word in words.entries) {
//       debugger(when: kDebugMode && word.key == "baloncesto".toLowerCase());
//       listTotals.addByType(word.value.proficiencyLevel);
//     }
//     return listTotals;
//   }
// }

// class ListTotals {
//   int low;
//   int medium;
//   int high;
//   int unknown;

//   ListTotals({
//     required this.low,
//     required this.medium,
//     required this.high,
//     required this.unknown,
//   });

//   static get empty => ListTotals(low: 0, medium: 0, high: 0, unknown: 0);

//   void addByType(VocabProficiencyEnum prof) {
//     switch (prof) {
//       case VocabProficiencyEnum.low:
//         low++;
//         break;
//       case VocabProficiencyEnum.medium:
//         medium++;
//         break;
//       case VocabProficiencyEnum.high:
//         high++;
//         break;
//       case VocabProficiencyEnum.unk:
//         unknown++;
//         break;
//     }
//   }
// }

// class VocabTotals {
//   num ga;

//   num wa;

//   num corIt;

//   num incIt;

//   num ignIt;

//   VocabTotals({
//     required this.ga,
//     required this.wa,
//     required this.corIt,
//     required this.incIt,
//     required this.ignIt,
//   });

//   num get calculateEstimatedVocabProficiency {
//     const num gaWeight = -1;
//     const num waWeight = 1;
//     const num corItWeight = 0.5;
//     const num incItWeight = -0.5;
//     const num ignItWeight = 0.1;

//     final num gaScore = ga * gaWeight;
//     final num waScore = wa * waWeight;
//     final num corItScore = corIt * corItWeight;
//     final num incItScore = incIt * incItWeight;
//     final num ignItScore = ignIt * ignItWeight;

//     final num totalScore =
//         gaScore + waScore + corItScore + incItScore + ignItScore;

//     return totalScore;
//   }

//   VocabProficiencyEnum get proficiencyLevel =>
//       VocabProficiencyUtil.proficiency(calculateEstimatedVocabProficiency);

//   static VocabTotals get newTotals {
//     return VocabTotals(
//       ga: 0,
//       wa: 0,
//       corIt: 0,
//       incIt: 0,
//       ignIt: 0,
//     );
//   }

//   void addVocabUseBasedOnUseType(List<OneConstructUse> uses) {
//     for (final use in uses) {
//       switch (use.useType) {
//         case ConstructUseTypeEnum.ga:
//           ga++;
//           break;
//         case ConstructUseTypeEnum.wa:
//           wa++;
//           break;
//         case ConstructUseTypeEnum.corIt:
//           corIt++;
//           break;
//         case ConstructUseTypeEnum.incIt:
//           incIt++;
//           break;
//         case ConstructUseTypeEnum.ignIt:
//           ignIt++;
//           break;
//         //TODO - these shouldn't be counted as such
//         case ConstructUseTypeEnum.ignIGC:
//           ignIt++;
//           break;
//         case ConstructUseTypeEnum.corIGC:
//           corIt++;
//           break;
//         case ConstructUseTypeEnum.incIGC:
//           incIt++;
//           break;
//         //TODO if we bring back Headwords then we need to add these
//         case ConstructUseTypeEnum.corPA:
//           break;
//         case ConstructUseTypeEnum.incPA:
//           break;
//         case ConstructUseTypeEnum.unk:
//           break;
//         case ConstructUseTypeEnum.ignPA:
//           break;
//       }
//     }
//   }
// }
