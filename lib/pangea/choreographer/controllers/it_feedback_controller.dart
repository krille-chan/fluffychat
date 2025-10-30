import 'package:fluffychat/pangea/common/constants/model_keys.dart';

class ITFeedbackRequestModel {
  final String sourceText;
  final String currentText;
  final String bestContinuance;
  final String chosenContinuance;
  final String feedbackLang;
  final String sourceTextLang;
  final String targetLang;

  ITFeedbackRequestModel({
    required this.sourceText,
    required this.currentText,
    required this.bestContinuance,
    required this.chosenContinuance,
    required this.feedbackLang,
    required this.sourceTextLang,
    required this.targetLang,
  });

  Map<String, dynamic> toJson() => {
        ModelKey.sourceText: sourceText,
        ModelKey.currentText: currentText,
        ModelKey.bestContinuance: bestContinuance,
        ModelKey.chosenContinuance: chosenContinuance,
        ModelKey.feedbackLang: feedbackLang,
        ModelKey.srcLang: sourceTextLang,
        ModelKey.tgtLang: targetLang,
      };
}

class ITFeedbackResponseModel {
  String text;

  ITFeedbackResponseModel({required this.text});

  factory ITFeedbackResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      ITFeedbackResponseModel(text: json[ModelKey.text]);
}
