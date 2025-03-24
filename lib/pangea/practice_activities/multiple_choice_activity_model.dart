import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/practice_activities/practice_activity_model.dart';

class ActivityContent {
  final String question;

  /// choices, including the correct answer
  final List<String> choices;
  final List<String> answers;
  final RelevantSpanDisplayDetails? spanDisplayDetails;

  ActivityContent({
    required this.question,
    required this.choices,
    required this.answers,
    required this.spanDisplayDetails,
  });

  /// we've had some bugs where the index is not expected
  /// so we're going to check if the index or the value is correct
  /// and if not, we'll investigate
  bool isCorrect(String value, int index) {
    if (value != choices[index]) {
      debugger(when: kDebugMode);
    }
    return answers.contains(value) || correctAnswerIndices.contains(index);
  }

  bool get isValidQuestion => choices.toSet().containsAll(answers);

  List<int> get correctAnswerIndices {
    final List<int> indices = [];
    for (var i = 0; i < choices.length; i++) {
      if (answers.contains(choices[i])) {
        indices.add(i);
      }
    }
    return indices;
  }

  int choiceIndex(String choice) => choices.indexOf(choice);

  Color choiceColor(int index) => correctAnswerIndices.contains(index)
      ? AppConfig.success
      : AppConfig.warning;

  factory ActivityContent.fromJson(Map<String, dynamic> json) {
    final spanDisplay = json['span_display_details'] != null &&
            json['span_display_details'] is Map
        ? RelevantSpanDisplayDetails.fromJson(json['span_display_details'])
        : null;

    final answerEntry = json['answer'] ?? json['correct_answer'] ?? "";
    List<String> answers = [];
    if (answerEntry is String) {
      answers = [answerEntry];
    } else if (answerEntry is List) {
      answers = answerEntry.map((e) => e as String).toList();
    }

    return ActivityContent(
      question: json['question'] as String,
      choices: (json['choices'] as List).map((e) => e as String).toList(),
      answers: answers,
      spanDisplayDetails: spanDisplay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'choices': choices,
      'answer': answers,
      'span_display_details': spanDisplayDetails?.toJson(),
    };
  }

  // ovveride operator == and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ActivityContent &&
        other.question == question &&
        other.choices == choices &&
        const ListEquality().equals(other.answers.sorted(), answers.sorted());
  }

  @override
  int get hashCode {
    return question.hashCode ^ choices.hashCode ^ Object.hashAll(answers);
  }
}
