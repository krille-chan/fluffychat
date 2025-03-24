import 'package:fluffychat/pangea/constructs/construct_form.dart';

class MatchFeedback {
  ConstructForm form;
  bool isCorrect;

  MatchFeedback({required this.form, required this.isCorrect});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MatchFeedback &&
        other.form == form &&
        other.isCorrect == isCorrect;
  }

  @override
  int get hashCode => form.hashCode ^ isCorrect.hashCode;
}
