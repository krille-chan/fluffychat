import 'dart:convert';

import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import '../constants/choreo_constants.dart';
import '../enum/construct_type_enum.dart';
import 'constructs_analytics_model.dart';
import 'it_step.dart';
import 'lemma.dart';

/// this class lives within a [PangeaIGCEvent]
/// it always has a [RepresentationEvent] parent
/// These live as separate event so that anyone can add and edit grammar checks
/// to a representation
/// It represents the real-time changes to a text
/// TODO - start saving senderL2Code in choreoRecord to be able better decide the useType

class ChoreoRecord {
  /// ordered versions of the representation, with first being original and last
  /// being the final sent text
  /// there is not a 1-to-1 map from steps to matches
  List<ChoreoRecordStep> choreoSteps;

  // String current;

  List<PangeaMatch> openMatches;

  ChoreoRecord({
    required this.choreoSteps,
    required this.openMatches,
    // required this.current,
  });

  factory ChoreoRecord.fromJson(Map<String, dynamic> json) {
    final stepsRaw = json[_stepsKey];
    return ChoreoRecord(
      choreoSteps: (jsonDecode(stepsRaw ?? "[]") as Iterable)
          .map((e) {
            return ChoreoRecordStep.fromJson(e);
          })
          .toList()
          .cast<ChoreoRecordStep>(),
      openMatches: (jsonDecode(json[_openMatchesKey] ?? "[]") as Iterable)
          .map((e) {
            return PangeaMatch.fromJson(e);
          })
          .toList()
          .cast<PangeaMatch>(),
      // current: json[_currentKey],
    );
  }

  static const _stepsKey = "stps";
  static const _openMatchesKey = "mtchs";
  // static const _currentKey = "crnt";

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[_stepsKey] = jsonEncode(choreoSteps.map((e) => e.toJson()).toList());
    data[_openMatchesKey] =
        jsonEncode(openMatches.map((e) => e.toJson()).toList());
    // data[_currentKey] = current;
    return data;
  }

  addRecord(String text, {PangeaMatch? match, ITStep? step}) {
    if (match != null && step != null) {
      throw Exception("match and step should not both be defined");
    }
    choreoSteps.add(
      ChoreoRecordStep(
        text: text,
        acceptedOrIgnoredMatch: match,
        itStep: step,
      ),
    );
  }

  bool get hasAcceptedMatches => choreoSteps.any(
        (element) =>
            element.acceptedOrIgnoredMatch?.status ==
            PangeaMatchStatus.accepted,
      );

  bool get hasIgnoredMatches => choreoSteps.any(
        (element) =>
            element.acceptedOrIgnoredMatch?.status == PangeaMatchStatus.ignored,
      );

  // bool get includedIT => choreoSteps.any((step) {
  //       return step.acceptedOrIgnoredMatch?.status ==
  //               PangeaMatchStatus.accepted &&
  //           (step.acceptedOrIgnoredMatch?.isITStart ?? false);
  //     });

  bool get includedIT => choreoSteps.any((step) {
        return step.acceptedOrIgnoredMatch?.status ==
                PangeaMatchStatus.accepted &&
            (step.acceptedOrIgnoredMatch?.isOutOfTargetMatch ?? false);
      });

  bool get includedIGC => choreoSteps.any((step) {
        return step.acceptedOrIgnoredMatch?.status ==
                PangeaMatchStatus.accepted &&
            (step.acceptedOrIgnoredMatch?.isGrammarMatch ?? false);
      });

  static ChoreoRecord get newRecord => ChoreoRecord(
        choreoSteps: [],
        openMatches: [],
      );

  /// [tokens] is the final list of tokens that were sent
  /// if no ga or ta,
  ///   make wa use for each and return
  /// else
  ///   for each saveable vocab in the final message
  ///     if vocab is contained in an accepted replacement, make ga use
  ///     if vocab is contained in ta choice,
  ///       if selected as choice, corIt
  ///       if written as customInput, corIt? (account for score in this)
  ///   for each it step
  ///     for each continuance
  ///       if not within the final message, save ignIT/incIT
  List<OneConstructUse> toVocabUse(
    List<PangeaToken> tokens,
    String chatId,
    String msgId,
  ) {
    final List<OneConstructUse> uses = [];
    final DateTime now = DateTime.now();
    List<OneConstructUse> lemmasToVocabUses(
      List<Lemma> lemmas,
      ConstructUseType type,
    ) {
      final List<OneConstructUse> uses = [];
      for (final lemma in lemmas) {
        if (lemma.saveVocab) {
          uses.add(
            OneConstructUse(
              useType: type,
              chatId: chatId,
              timeStamp: now,
              lemma: lemma.text,
              form: lemma.form,
              msgId: msgId,
              constructType: ConstructType.vocab,
            ),
          );
        }
      }
      return uses;
    }

    List<OneConstructUse> getVocabUseForToken(PangeaToken token) {
      for (final step in choreoSteps) {
        /// if 1) accepted match 2) token is in the replacement and 3) replacement
        /// is in the overall step text, then token was a ga
        if (step.acceptedOrIgnoredMatch?.status == PangeaMatchStatus.accepted &&
            (step.acceptedOrIgnoredMatch!.match.choices?.any(
                  (r) =>
                      r.value.contains(token.text.content) &&
                      step.text.contains(r.value),
                ) ??
                false)) {
          return lemmasToVocabUses(token.lemmas, ConstructUseType.ga);
        }
        if (step.itStep != null) {
          final bool pickedThroughIT = step.itStep!.chosenContinuance?.text
                  .contains(token.text.content) ??
              false;
          if (pickedThroughIT) {
            return lemmasToVocabUses(token.lemmas, ConstructUseType.corIt);
            //PTODO - check if added via custom input in IT flow
          }
        }
      }
      return lemmasToVocabUses(token.lemmas, ConstructUseType.wa);
    }

    /// for each token, record whether selected in ga, ta, or wa
    for (final token in tokens) {
      uses.addAll(getVocabUseForToken(token));
    }

    for (final itStep in itSteps) {
      for (final continuance in itStep.continuances) {
        // this seems to always be false for continuances right now

        if (finalMessage.contains(continuance.text)) {
          continue;
        }
        if (continuance.wasClicked) {
          //PTODO - account for end of flow score
          if (continuance.level != ChoreoConstants.levelThresholdForGreen) {
            uses.addAll(
              lemmasToVocabUses(continuance.lemmas, ConstructUseType.incIt),
            );
          }
        } else {
          if (continuance.level != ChoreoConstants.levelThresholdForGreen) {
            uses.addAll(
              lemmasToVocabUses(continuance.lemmas, ConstructUseType.ignIt),
            );
          }
        }
      }
    }

    return uses;
  }

  List<OneConstructUse> toGrammarConstructUse(String msgId, String chatId) {
    final List<OneConstructUse> uses = [];
    final DateTime now = DateTime.now();
    for (final step in choreoSteps) {
      if (step.acceptedOrIgnoredMatch?.status == PangeaMatchStatus.accepted) {
        final String name = step.acceptedOrIgnoredMatch!.match.rule?.id ??
            step.acceptedOrIgnoredMatch!.match.shortMessage ??
            step.acceptedOrIgnoredMatch!.match.type.typeName.name;
        uses.add(
          OneConstructUse(
            useType: ConstructUseType.ga,
            chatId: chatId,
            timeStamp: now,
            lemma: name,
            form: name,
            msgId: msgId,
            constructType: ConstructType.grammar,
          ),
        );
      }
    }
    return uses;
  }

  List<ITStep> get itSteps =>
      choreoSteps.where((e) => e.itStep != null).map((e) => e.itStep!).toList();

  String get finalMessage =>
      choreoSteps.isNotEmpty ? choreoSteps.last.text : "";
}

/// new step are saved
/// 1) before every system-provided text is accepted, if final text is different
/// from last step
/// 2) on the acceptance of system-provided text
/// 3) on message send, if final text is different from last step
///
/// user edit
/// "hey ther"
/// user accepts "there" correction
/// "hey there"
/// step made for user edits and step made for system suggestion
/// user goes through IT, chooses "hola"
/// "hola"
/// step saved
/// adds "amigo"
/// step saved
class ChoreoRecordStep {
  /// text after changes have been made
  String text;

  /// all matches throughout edit process,
  /// including those open, accepted and ignored
  /// last step in list may contain open
  PangeaMatch? acceptedOrIgnoredMatch;

  ITStep? itStep;

  ChoreoRecordStep({
    required this.text,
    this.acceptedOrIgnoredMatch,
    this.itStep,
  }) {
    if (itStep != null && acceptedOrIgnoredMatch != null) {
      throw Exception(
        "itStep and acceptedOrIgnoredMatch should not both be defined",
      );
    }
  }

  factory ChoreoRecordStep.fromJson(Map<String, dynamic> json) {
    return ChoreoRecordStep(
      text: json[_textKey],
      acceptedOrIgnoredMatch: json[_acceptedOrIgnoredMatchKey] != null
          ? PangeaMatch.fromJson(json[_acceptedOrIgnoredMatchKey])
          : null,
      itStep: json[_stepKey] != null ? ITStep.fromJson(json[_stepKey]) : null,
    );
  }

  static const _textKey = "txt";
  static const _acceptedOrIgnoredMatchKey = "mtch";
  static const _stepKey = "stp";

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[_textKey] = text;
    data[_acceptedOrIgnoredMatchKey] = acceptedOrIgnoredMatch?.toJson();
    data[_stepKey] = itStep?.toJson();
    return data;
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
