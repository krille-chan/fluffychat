import 'package:fluffychat/pangea/constructs/construct_form.dart';

class PracticeChoice {
  /// choiceContent
  final String choiceContent;

  /// Form of the associated token
  final ConstructForm form;

  PracticeChoice({
    required this.choiceContent,
    required this.form,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PracticeChoice &&
        other.form == form &&
        other.choiceContent == choiceContent;
  }

  @override
  int get hashCode => form.hashCode ^ choiceContent.hashCode;
}
