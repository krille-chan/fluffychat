import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';

class MultipleChoice {
  final String question;
  final List<String> choices;
  final String correctAnswer;

  MultipleChoice({
    required this.question,
    required this.choices,
    required this.correctAnswer,
  });

  bool isCorrect(int index) => index == correctAnswerIndex;

  bool get isValidQuestion => choices.contains(correctAnswer);

  int get correctAnswerIndex => choices.indexOf(correctAnswer);

  Color choiceColor(int index) =>
      index == correctAnswerIndex ? AppConfig.success : AppConfig.warning;

  factory MultipleChoice.fromJson(Map<String, dynamic> json) {
    return MultipleChoice(
      question: json['question'] as String,
      choices: (json['choices'] as List).map((e) => e as String).toList(),
      correctAnswer: json['correct_answer'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'choices': choices,
      'correct_answer': correctAnswer,
    };
  }
}
