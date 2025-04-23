import 'dart:math';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/choreographer/models/choreo_record.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/models/speech_to_text_models.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// this class is contained within a [RepresentationEvent]
/// this event is the child of a [EventTypes.Message]
/// the event has two potential children events -
/// [PangeaTokensEvent] and [PangeaIGCEvent]
/// these events contain [PangeaMessageTokens] and [ChoreoRecord], respectively.
class PangeaRepresentation {
  /// system-detected language, possibly condensed from a list,
  /// but only with high certainty
  /// cannot be "unk"
  String langCode;

  /// final sent text
  /// if this was a process, a [PangeaIGCEvent] will contain changes
  String text;

  bool originalSent;
  bool originalWritten;

  // a representation can be create via speech to text on the original message
  SpeechToTextModel? speechToText;

  // how do we know which representation was sent by author?
  // RepresentationEvent.text == PangeaMessageEvent.event.body
  // use: to know whether directUse

  // how do we know which representation was original L1 message that was translated (if it exists)?
  // (of l2 rep) RepresentationEvent.igc.steps.first.text = RepresentationEvent.text (of L1 rep)
  // use: for base text for future translations

  // os = true and ow = false
  // rep that went through IGC/IT

  // os = false and ow = false
  // rep added by other user

  // os = true and ow = true
  // potentially L1 language use, maybe with limited IGC, and ignored out of target cries
  // potentially perfect L2 use

  // os = false and ow = true
  // L1 message that then went through significant IGC and/or IT
  // L2 message with errors that went through IGC

  PangeaRepresentation({
    required this.langCode,
    required this.text,
    required this.originalSent,
    required this.originalWritten,
    this.speechToText,
  });

  factory PangeaRepresentation.fromJson(Map<String, dynamic> json) {
    return PangeaRepresentation(
      langCode: json[_langCodeKey],
      text: json[_textKey],
      originalSent: json[_originalSentKey] ?? false,
      originalWritten: json[_originalWrittenKey] ?? false,
      speechToText: json[_speechToTextKey] == null
          ? null
          : SpeechToTextModel.fromJson(json[_speechToTextKey]),
    );
  }

  static const _textKey = "txt";
  static const _langCodeKey = "lang";
  static const _originalSentKey = "snt";
  static const _originalWrittenKey = "wrttn";
  static const _speechToTextKey = "stt";

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[_textKey] = text;
    data[_langCodeKey] = langCode;
    if (originalSent) data[_originalSentKey] = originalSent;
    if (originalWritten) data[_originalWrittenKey] = originalWritten;
    if (speechToText != null) {
      data[_speechToTextKey] = speechToText!.toJson();
    }
    return data;
  }

  /// Get construct uses for the message that weren't captured during language assistance.
  /// Takes a list of tokens and a choreo record, which is searched
  /// through for each token for its construct use type.
  /// Also takes either an event (typically when the Representation itself is
  /// available) or construct use metadata (when the event is not available,
  /// i.e. immediately after message send) to create the construct use.
  List<OneConstructUse> vocabAndMorphUses({
    required List<PangeaToken> tokens,
    Event? event,
    ConstructUseMetaData? metadata,
    ChoreoRecord? choreo,
  }) {
    final List<OneConstructUse> uses = [];
    final l2 = MatrixState.pangeaController.languageController.userL2;
    if (langCode.split("-")[0] != l2?.langCodeShort) return uses;

    // missing vital info so return
    if (event?.roomId == null && metadata?.roomId == null) {
      // debugger(when: kDebugMode);
      return uses;
    }

    metadata ??= ConstructUseMetaData(
      roomId: event!.roomId!,
      eventId: event.eventId,
      timeStamp: event.originServerTs,
    );

    // for each token, record whether selected in ga, ta, or wa
    List<PangeaToken> tokensToSave =
        tokens.where((token) => token.lemma.saveVocab).toList();
    if (choreo != null && choreo.pastedStrings.isNotEmpty) {
      tokensToSave = tokensToSave
          .where(
            (token) => !choreo.pastedStrings.any(
              (pasted) => pasted
                  .toLowerCase()
                  .contains(token.text.content.toLowerCase()),
            ),
          )
          .toList();
    }

    if (choreo == null ||
        (choreo.choreoSteps.isEmpty && choreo.itSteps.isEmpty)) {
      for (final token in tokensToSave) {
        uses.addAll(
          token.allUses(
            ConstructUseTypeEnum.wa,
            metadata,
            ConstructUseTypeEnum.wa.pointValue,
          ),
        );
      }

      return uses;
    }

    for (final token in tokensToSave) {
      ChoreoRecordStep? tokenStep;
      for (final step in choreo.choreoSteps) {
        final igcMatch = step.acceptedOrIgnoredMatch;
        final itStep = step.itStep;
        if (itStep == null && igcMatch == null) {
          continue;
        }

        final choices = step.choices;
        if (choices == null || choices.isEmpty) {
          continue;
        }

        final stepContainsToken = choices.any(
          (choice) => choice.contains(token.text.content),
        );

        // if the step contains the token, and the token hasn't been assigned a step
        // (or the assigned step is an IGC step, but an IT step contains the token)
        // then assign the token to the step
        if (stepContainsToken &&
            (tokenStep == null ||
                (tokenStep.itStep == null && step.itStep != null))) {
          tokenStep = step;
        }
      }

      if (tokenStep == null ||
          tokenStep.acceptedOrIgnoredMatch?.status ==
              PangeaMatchStatus.automatic) {
        // if the token wasn't found in any IT or IGC step, so it was wa
        uses.addAll(
          token.allUses(
            ConstructUseTypeEnum.wa,
            metadata,
            ConstructUseTypeEnum.wa.pointValue,
          ),
        );
        continue;
      }

      if (tokenStep.acceptedOrIgnoredMatch != null &&
          tokenStep.acceptedOrIgnoredMatch?.status !=
              PangeaMatchStatus.accepted) {
        uses.addAll(
          token.allUses(
            ConstructUseTypeEnum.ga,
            metadata,
            0,
          ),
        );
        continue;
      }

      if (tokenStep.itStep != null) {
        final selectedChoices = tokenStep.itStep!.continuances
            .where((choice) => choice.wasClicked)
            .length;
        if (selectedChoices == 0) {
          ErrorHandler.logError(
            e: "No selected choices for IT step",
            data: {
              "token": token.text.content,
              "step": tokenStep.toJson(),
            },
          );
          continue;
        }

        final corITPoints = ConstructUseTypeEnum.corIt.pointValue;
        final incITPoints = ConstructUseTypeEnum.incIt.pointValue;
        final xp = max(
          0,
          corITPoints + (incITPoints * (selectedChoices - 1)),
        );

        uses.addAll(
          token.allUses(
            ConstructUseTypeEnum.ta,
            metadata,
            xp,
          ),
        );
      } else if (tokenStep.acceptedOrIgnoredMatch!.match.choices != null) {
        final selectedChoices = tokenStep.acceptedOrIgnoredMatch!.match.choices!
            .where((choice) => choice.selected)
            .length;
        if (selectedChoices == 0) {
          ErrorHandler.logError(
            e: "No selected choices for IGC step",
            data: {
              "token": token.text.content,
              "step": tokenStep.toJson(),
            },
          );
          continue;
        }

        final corIGCPoints = ConstructUseTypeEnum.corIGC.pointValue;
        final incIGCPoints = ConstructUseTypeEnum.incIGC.pointValue;
        final xp = max(
          0,
          corIGCPoints + (incIGCPoints * (selectedChoices - 1)),
        );

        uses.addAll(
          token.allUses(
            ConstructUseTypeEnum.ga,
            metadata,
            xp,
          ),
        );
      }
    }

    return uses;
  }
}
