import 'dart:convert';

import 'package:fluffychat/pangea/choreographer/choreo_edit_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_status_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/span_data_model.dart';
import 'completed_it_step_model.dart';

/// this class lives within a [PangeaIGCEvent]
/// it always has a [RepresentationEvent] parent
/// These live as separate event so that anyone can add and edit grammar checks
/// to a representation
/// It represents the real-time changes to a text
/// TODO - start saving senderL2Code in choreoRecord to be able better decide the useType

class ChoreoRecordModel {
  /// ordered versions of the representation, with first being original and last
  /// being the final sent text
  /// there is not a 1-to-1 map from steps to matches
  final List<ChoreoRecordStepModel> choreoSteps;
  final List<PangeaMatch> openMatches;
  final String originalText;

  final Set<String> pastedStrings = {};

  ChoreoRecordModel({
    required this.choreoSteps,
    required this.openMatches,
    required this.originalText,
  });

  factory ChoreoRecordModel.fromJson(
    Map<String, dynamic> json, [
    String? defaultOriginalText,
  ]) {
    final stepsRaw = json[_stepsKey];
    String? originalText = json[_originalTextKey];

    List<ChoreoRecordStepModel> steps = [];
    final stepContent = (jsonDecode(stepsRaw ?? "[]") as Iterable);

    if (stepContent.isNotEmpty &&
        originalText == null &&
        stepContent.first["txt"] is String) {
      originalText = stepContent.first["txt"];
    }

    if (stepContent.every((step) => step["txt"] is! String)) {
      steps = stepContent
          .map((e) => ChoreoRecordStepModel.fromJson(e))
          .toList()
          .cast<ChoreoRecordStepModel>();
    } else {
      String? currentEdit = originalText;
      for (final content in stepContent) {
        final String textBefore = content["txt"] ?? "";
        String textAfter = textBefore;

        currentEdit ??= textBefore;

        // typically, taking the original text and applying the edits from the choreo steps
        // will yield a correct result, but it's possible the user manually changed the text
        // between steps, so we need handle that by adding an extra step
        if (textBefore != currentEdit) {
          final edits = ChoreoEditModel.fromText(
            originalText: currentEdit,
            editedText: textBefore,
          );

          steps.add(ChoreoRecordStepModel(edits: edits));
          currentEdit = textBefore;
        }

        int offset = 0;
        int length = 0;
        String insert = "";

        ChoreoRecordStepModel step = ChoreoRecordStepModel.fromJson(content);
        if (step.acceptedOrIgnoredMatch != null) {
          final SpanData? match = step.acceptedOrIgnoredMatch?.match;
          final correction = match?.bestChoice;
          if (correction != null) {
            offset = match!.offset;
            length = match.length;
            insert = correction.value;
          }
        } else if (step.itStep != null) {
          final chosen = step.itStep!.chosenContinuance;
          if (chosen != null) {
            offset = (content["txt"] ?? "").length;
            insert = chosen.text;
          }
        }

        if (textBefore.length - offset - length < 0) {
          length = textBefore.length - offset;
        }

        textAfter = textBefore.replaceRange(offset, offset + length, insert);

        final edits = ChoreoEditModel.fromText(
          originalText: currentEdit,
          editedText: textAfter,
        );

        currentEdit = textAfter;
        step = ChoreoRecordStepModel(
          edits: edits,
          acceptedOrIgnoredMatch: step.acceptedOrIgnoredMatch,
          itStep: step.itStep,
        );
        steps.add(step);
      }
    }

    if (originalText == null &&
        (steps.isNotEmpty || defaultOriginalText == null)) {
      throw Exception(
        "originalText cannot be null, please provide a valid original text",
      );
    }

    return ChoreoRecordModel(
      choreoSteps: steps,
      originalText: originalText ?? defaultOriginalText!,
      openMatches: (jsonDecode(json[_openMatchesKey] ?? "[]") as Iterable)
          .map((e) {
            return PangeaMatch.fromJson(e);
          })
          .toList()
          .cast<PangeaMatch>(),
    );
  }

  static const _stepsKey = "stps";
  static const _openMatchesKey = "mtchs";
  static const _originalTextKey = "ogtxt_v2";

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[_stepsKey] = jsonEncode(choreoSteps.map((e) => e.toJson()).toList());
    data[_openMatchesKey] = jsonEncode(
      openMatches.map((e) => e.toJson()).toList(),
    );
    data[_originalTextKey] = originalText;
    return data;
  }

  bool get includedIT => choreoSteps.any((step) {
    return step.acceptedOrIgnoredMatch?.status ==
            PangeaMatchStatusEnum.accepted &&
        (step.acceptedOrIgnoredMatch?.isOutOfTargetMatch ?? false);
  });

  bool get includedIGC => choreoSteps.any((step) {
    return step.acceptedOrIgnoredMatch?.status ==
            PangeaMatchStatusEnum.accepted &&
        (step.acceptedOrIgnoredMatch?.isGrammarMatch ?? false);
  });

  bool endedWithIT(String sent) {
    return includedIT && stepText() == sent;
  }

  /// Get the text at [stepIndex]
  String stepText({int? stepIndex}) {
    stepIndex ??= choreoSteps.length - 1;
    if (stepIndex >= choreoSteps.length) {
      throw RangeError.index(stepIndex, choreoSteps, "index out of range");
    }

    if (stepIndex < 0) return originalText;

    String text = originalText;
    for (int i = 0; i <= stepIndex; i++) {
      final step = choreoSteps[i];
      if (step.edits == null) continue;
      final edits = step.edits!;

      text = text.replaceRange(
        edits.offset,
        edits.offset + edits.length,
        edits.insert,
      );
    }

    return text;
  }

  void addRecord(
    String text, {
    PangeaMatch? match,
    CompletedITStepModel? step,
  }) {
    if (match != null && step != null) {
      throw Exception("match and step should not both be defined");
    }

    final edit = ChoreoEditModel.fromText(
      originalText: stepText(),
      editedText: text,
    );

    choreoSteps.add(
      ChoreoRecordStepModel(
        edits: edit,
        acceptedOrIgnoredMatch: match,
        itStep: step,
      ),
    );
  }
}

/// A new ChoreoRecordStep is saved in the following cases:
/// 1) before every system-provided text is accepted, if final text is different
/// from last step
/// 2) on the acceptance of system-provided text
/// 3) on message send, if final text is different from last step
/// 4) on the acceptance of an it step
/// 5) on the start of it
///
/// Example 1:
/// the user types "hey ther"
/// IGC suggests "there"
/// user accepts "there" correction
/// text is now "hey there"
/// A step is made for the original input 'hey there' and a step is made for system suggestion
///
/// Example 2:
/// user write "hi friend"
/// a step is made for the original input 'hi friend'
/// the user selects IT and a step is made
/// the user chooses "hola" and a step is saved
/// adds "amigo" and a step saved
class ChoreoRecordStepModel {
  /// Edits that, when applied to the previous step's text,
  /// will provide the current step's text
  /// Should always exist, except when using fromJSON
  /// on old version of ChoreoRecordStep
  final ChoreoEditModel? edits;

  /// all matches throughout edit process,
  /// including those open, accepted and ignored
  /// last step in list may contain open
  final PangeaMatch? acceptedOrIgnoredMatch;

  final CompletedITStepModel? itStep;

  ChoreoRecordStepModel({
    this.edits,
    this.acceptedOrIgnoredMatch,
    this.itStep,
  }) {
    if (itStep != null && acceptedOrIgnoredMatch != null) {
      throw Exception(
        "itStep and acceptedOrIgnoredMatch should not both be defined",
      );
    }
  }

  factory ChoreoRecordStepModel.fromJson(Map<String, dynamic> json) {
    return ChoreoRecordStepModel(
      edits: json[_editKey] != null
          ? ChoreoEditModel.fromJson(json[_editKey])
          : null,
      acceptedOrIgnoredMatch: json[_acceptedOrIgnoredMatchKey] != null
          ? PangeaMatch.fromJson(json[_acceptedOrIgnoredMatchKey])
          : null,
      itStep: json[_stepKey] != null
          ? CompletedITStepModel.fromJson(json[_stepKey])
          : null,
    );
  }

  static const _editKey = "edits_v2";
  static const _acceptedOrIgnoredMatchKey = "mtch";
  static const _stepKey = "stp";

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[_editKey] = edits?.toJson();

    if (acceptedOrIgnoredMatch != null) {
      data[_acceptedOrIgnoredMatchKey] = acceptedOrIgnoredMatch?.toJson();
    }

    if (itStep != null) {
      data[_stepKey] = itStep?.toJson();
    }

    return data;
  }

  List<String>? get choices {
    if (itStep != null) {
      return itStep!.continuances.map((e) => e.text).toList().cast<String>();
    }

    return acceptedOrIgnoredMatch?.match.choices
        ?.map((e) => e.value)
        .toList()
        .cast<String>();
  }

  String? get selectedChoice {
    if (itStep != null) {
      return itStep!.chosenContinuance?.text;
    }

    return acceptedOrIgnoredMatch?.match.selectedChoice?.value;
  }
}

// Example flow
// hello my name is Jordan! Im typing a message

// igc called, step saved with matchIndex = null

// click Im and fixed

// hello my name is Jordan! I'm typing a message

// igc called, step saved with matchIndex equal to i'm index

// hello my name is Jordan! I'm typing a message

// igc called, step saved with matchIndex = null

// class ITStepRecord {
//   List<ContinuanceRecord> allContinuances;

//   /// continuances that were clicked but not selected
//   List<int> clicked;

//   ITStepRecord({required this.continuances});
// }

// class ContinuanceRecord {}
