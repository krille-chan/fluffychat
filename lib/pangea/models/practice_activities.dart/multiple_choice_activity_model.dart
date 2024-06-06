class MultipleChoice {
  final String question;
  final List<String> choices;
  final String correctAnswer;

  MultipleChoice({
    required this.question,
    required this.choices,
    required this.correctAnswer,
  });

  bool get isValidQuestion => choices.contains(correctAnswer);

  int get correctAnswerIndex => choices.indexOf(correctAnswer);

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

// record the options that the user selected
// note that this is not the same as the correct answer
// the user might have selected multiple options before
// finding the answer
class MultipleChoiceActivityCompletionRecord {
  final String question;
  List<String> selectedOptions;

  MultipleChoiceActivityCompletionRecord({
    required this.question,
    this.selectedOptions = const [],
  });

  factory MultipleChoiceActivityCompletionRecord.fromJson(
    Map<String, dynamic> json,
  ) {
    return MultipleChoiceActivityCompletionRecord(
      question: json['question'] as String,
      selectedOptions:
          (json['selected_options'] as List).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'selected_options': selectedOptions,
    };
  }
}
