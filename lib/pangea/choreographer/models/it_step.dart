import 'package:flutter/material.dart';

import '../constants/choreo_constants.dart';
import 'it_response_model.dart';

class ITStep {
  List<Continuance> continuances;
  int? chosen;
  String? customInput;
  bool showAlternativeTranslationOption = false;

  ITStep(
    this.continuances, {
    this.chosen,
    this.customInput,
  }) {
    if (chosen == null && customInput == null) {
      throw Exception("ITStep must have either chosen or customInput");
    }
    if (chosen != null && customInput != null) {
      throw Exception("ITStep must have only chosen or customInput");
    }
  }

  Continuance? get chosenContinuance {
    if (chosen == null) return null;
    return continuances[chosen!];
  }

  String choiceFeedback(BuildContext context) {
    if (continuances.length == 1) return '';
    return chosenContinuance?.feedbackText(context) ?? "";
  }

  bool get isCorrect =>
      chosenContinuance != null &&
      (chosenContinuance!.level == ChoreoConstants.levelThresholdForGreen ||
          chosenContinuance!.gold);

  bool get isYellow =>
      chosenContinuance != null &&
      chosenContinuance!.level == ChoreoConstants.levelThresholdForYellow;

  bool get isWrong {
    return chosenContinuance != null &&
        chosenContinuance!.level == ChoreoConstants.levelThresholdForRed;
  }

  bool get isCustom => chosenContinuance == null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['continuances'] = continuances.map((e) => e.toJson(true)).toList();
    data['chosen'] = chosen;
    data['custom_input'] = customInput;
    return data;
  }

  factory ITStep.fromJson(Map<String, dynamic> json) {
    final List<Continuance> continuances = <Continuance>[];
    for (final Map<String, dynamic> continuance in json['continuances']) {
      continuances.add(Continuance.fromJson(continuance));
    }
    return ITStep(
      continuances,
      chosen: json['chosen'],
      customInput: json['custom_input'],
    );
  }
}
