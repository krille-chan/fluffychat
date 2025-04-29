import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/constructs/construct_form.dart';
import 'package:fluffychat/pangea/practice_activities/practice_choice.dart';

class PracticeMatchActivity {
  /// The constructIdenfifiers involved in the activity
  /// and the forms that are acceptable answers
  final Map<ConstructForm, List<String>> matchInfo;

  List<PracticeChoice> choices = List.empty(growable: true);

  PracticeMatchActivity({
    required this.matchInfo,
  }) {
    for (final ith in matchInfo.entries) {
      debugPrint(
        'Construct: ${ith.key}, Forms: ${ith.value}',
      );
    }
    // for all the entries in matchInfo, remove an Strings that appear in multiple entries
    final Map<String, int> allForms = {};
    for (final ith in matchInfo.entries) {
      for (final form in ith.value) {
        if (allForms.containsKey(form)) {
          allForms[form] = allForms[form]! + 1;
        } else {
          allForms[form] = 1;
        }
      }
    }

    for (final ith in matchInfo.entries) {
      if (ith.value.isEmpty) {
        matchInfo.remove(ith.key);
        continue;
      }
      choices.add(
        PracticeChoice(
          choiceContent: ith.value.firstWhere(
            (element) => allForms[element] == 1,
            orElse: () {
              ErrorHandler.logError(
                m: "no unique emoji for construct",
                data: {
                  'construct': ith.key,
                  'forms': ith.value,
                  "practice_match": toJson(),
                },
              );
              final String first = ith.value.first;
              // remove the element from the other entry to avoid duplicates
              for (final ith in matchInfo.entries) {
                ith.value.removeWhere((choice) => choice == first);
              }
              return ith.value.first;
            },
          ),
          form: ith.key,
        ),
      );
      debugPrint(
        'Added PracticeChoice Construct: ${ith.key}, Forms: ${ith.value}',
      );
    }

    choices.sort(
      (a, b) => a.choiceContent.length.compareTo(b.choiceContent.length),
    );
  }

  bool isCorrect(ConstructForm form, String value) {
    return matchInfo[form]!.contains(value);
  }

  factory PracticeMatchActivity.fromJson(Map<String, dynamic> json) {
    final Map<ConstructForm, List<String>> matchInfo = {};
    for (final constructJson in json['match_info']) {
      final ConstructForm cId = ConstructForm.fromJson(constructJson['cId']);
      final List<String> surfaceForms =
          List<String>.from(constructJson['forms']);
      matchInfo[cId] = surfaceForms;
    }

    return PracticeMatchActivity(
      matchInfo: matchInfo,
    );
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> matchInfo = [];
    for (final cId in this.matchInfo.keys) {
      matchInfo.add({
        'cId': cId.toJson(),
        'forms': this.matchInfo[cId],
      });
    }

    return {
      'match_info': matchInfo,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PracticeMatchActivity &&
        const MapEquality().equals(other.matchInfo, matchInfo);
  }

  @override
  int get hashCode => const MapEquality().hash(matchInfo);
}
