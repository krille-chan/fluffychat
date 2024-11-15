import 'dart:developer';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ActivityContent {
  final String question;
  final List<String> choices;
  final String answer;
  final RelevantSpanDisplayDetails? spanDisplayDetails;

  ActivityContent({
    required this.question,
    required this.choices,
    required this.answer,
    required this.spanDisplayDetails,
  });

  /// we've had some bugs where the index is not expected
  /// so we're going to check if the index or the value is correct
  /// and if not, we'll investigate
  bool isCorrect(String value, int index) {
    if (value != choices[index]) {
      debugger(when: kDebugMode);
    }
    return value == answer || index == correctAnswerIndex;
  }

  bool get isValidQuestion => choices.contains(answer);

  int get correctAnswerIndex => choices.indexOf(answer);

  int choiceIndex(String choice) => choices.indexOf(choice);

  Color choiceColor(int index) =>
      index == correctAnswerIndex ? AppConfig.success : AppConfig.warning;

  factory ActivityContent.fromJson(Map<String, dynamic> json) {
    final spanDisplay = json['span_display_details'] != null &&
            json['span_display_details'] is Map
        ? RelevantSpanDisplayDetails.fromJson(json['span_display_details'])
        : null;
    return ActivityContent(
      question: json['question'] as String,
      choices: (json['choices'] as List).map((e) => e as String).toList(),
      answer: json['answer'] ?? json['correct_answer'] as String,
      spanDisplayDetails: spanDisplay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'choices': choices,
      'answer': answer,
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
        other.answer == answer;
  }

  @override
  int get hashCode {
    return question.hashCode ^ choices.hashCode ^ answer.hashCode;
  }
}
