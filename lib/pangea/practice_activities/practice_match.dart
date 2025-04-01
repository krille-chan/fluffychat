import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

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
    // if there are multiple forms for a construct, pick one to display
    // each cosntruct will have ~3 forms
    // sometimes a form could be in multiple constructs
    // so we need to make sure we don't display the same form twice
    // if we get to one that is already displayed, we can pick a different form
    // either from that construct's options, or returning to the previous construct
    // and picking a different form from there
    for (final ith in matchInfo.entries) {
      for (int i = 0; i < ith.value.length; i++) {
        final String acceptableAnswer = ith.value[i];
        if (!choices
            .any((element) => element.choiceContent == acceptableAnswer)) {
          choices.add(
            PracticeChoice(choiceContent: acceptableAnswer, form: ith.key),
          );
          debugPrint(
            'Added choice: ${choices.last.choiceContent} for form: ${choices.last.form.form}',
          );
          i = ith.value.length; // break out of the loop
        }
        // TODO: if none found, we can probably pick a different form for the other one
      }
    }

    // remove any items from matchInfo that don't have an item in choices
    for (final ith in matchInfo.keys) {
      if (!choices.any((choice) => choice.form == ith)) {
        matchInfo.remove(ith);
      }
    }
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
