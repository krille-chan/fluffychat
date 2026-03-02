import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/choreographer/choreo_record_model.dart';
import 'package:fluffychat/pangea/choreographer/completed_it_step_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_model.dart';
import 'package:fluffychat/pangea/choreographer/igc/pangea_match_status_enum.dart';
import 'package:fluffychat/pangea/choreographer/igc/span_choice_type_enum.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/speech_to_text/speech_to_text_response_model.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// this class is contained within a [RepresentationEvent]
/// this event is the child of a [EventTypes.Message]
/// the event has two potential children events -
/// [PangeaTokensEvent] and [PangeaIGCEvent]
/// these events contain [PangeaMessageTokens] and [ChoreoRecordModel], respectively.
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
  SpeechToTextResponseModel? speechToText;

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
          : SpeechToTextResponseModel.fromJson(json[_speechToTextKey]),
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

  bool get langCodeMatchesL2 =>
      langCode.split("-").first ==
      MatrixState.pangeaController.userController.userL2?.langCodeShort;

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
    ChoreoRecordModel? choreo,
  }) {
    // missing vital info so return
    if (event?.roomId == null && metadata?.roomId == null) {
      // debugger(when: kDebugMode);
      return [];
    }

    metadata ??= ConstructUseMetaData(
      roomId: event!.roomId!,
      eventId: event.eventId,
      timeStamp: event.originServerTs,
    );

    final tokensToSave = _filterTokensToSave(tokens, choreo);

    final List<OneConstructUse> uses = [];
    if (choreo == null || choreo.choreoSteps.isEmpty) {
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
      final step = _getStepForToken(token, choreo);
      uses.addAll(_getUsesForToken(token, metadata, step));
    }

    return uses;
  }

  List<PangeaToken> _filterTokensToSave(
    List<PangeaToken> tokens,
    ChoreoRecordModel? choreo,
  ) {
    final List<PangeaToken> tokensToSave = tokens
        .where((token) => token.lemma.saveVocab)
        .toList();

    final pastedStrings = choreo?.pastedStrings ?? <String>{};

    return tokensToSave
        .where(
          (token) => !pastedStrings.any(
            (pasted) =>
                pasted.toLowerCase().contains(token.text.content.toLowerCase()),
          ),
        )
        .toList();
  }

  ChoreoRecordStepModel? _getStepForToken(
    PangeaToken token,
    ChoreoRecordModel choreo,
  ) {
    ChoreoRecordStepModel? tokenStep;
    for (final step in choreo.choreoSteps) {
      final igcMatch = step.acceptedOrIgnoredMatch;
      final itStep = step.itStep;
      if (itStep == null &&
          (igcMatch == null ||
              igcMatch.status == PangeaMatchStatusEnum.viewed)) {
        continue;
      }

      final choices = step.choices;
      if (choices == null || choices.isEmpty) {
        continue;
      }

      final stepContainsToken =
          step.selectedChoice?.contains(token.text.content) == true;

      // if the step contains the token, and the token hasn't been assigned a step
      // (or the assigned step is an IGC step, but an IT step contains the token)
      // then assign the token to the step
      if (stepContainsToken &&
          (tokenStep == null ||
              (tokenStep.itStep == null && step.itStep != null))) {
        tokenStep = step;
      }
    }
    return tokenStep;
  }

  List<OneConstructUse> _getUsesForToken(
    PangeaToken token,
    ConstructUseMetaData metadata,
    ChoreoRecordStepModel? tokenStep,
  ) {
    if (tokenStep == null ||
        tokenStep.acceptedOrIgnoredMatch?.status ==
            PangeaMatchStatusEnum.automatic) {
      // if the token wasn't found in any IT or IGC step, so it was wa
      return token.allUses(
        ConstructUseTypeEnum.wa,
        metadata,
        ConstructUseTypeEnum.wa.pointValue,
      );
    }

    if (tokenStep.acceptedOrIgnoredMatch != null &&
        tokenStep.acceptedOrIgnoredMatch?.status !=
            PangeaMatchStatusEnum.accepted) {
      return token.allUses(ConstructUseTypeEnum.ignIGC, metadata, 0);
    }

    if (tokenStep.itStep != null) {
      return _getUsesForITToken(token, tokenStep.itStep!, metadata);
    } else if (tokenStep.acceptedOrIgnoredMatch!.match.choices != null) {
      return _getUsesForIGCToken(
        token,
        tokenStep.acceptedOrIgnoredMatch!,
        metadata,
      );
    }

    return [];
  }

  List<OneConstructUse> _getUsesForITToken(
    PangeaToken token,
    CompletedITStepModel itStep,
    ConstructUseMetaData metadata,
  ) {
    final selectedChoices = itStep.continuances.where(
      (choice) => choice.wasClicked,
    );

    if (selectedChoices.isEmpty) {
      return token.allUses(ConstructUseTypeEnum.ignIt, metadata, 0);
    }

    final numCorrectChoices = selectedChoices
        .where((choice) => choice.gold)
        .length;

    final numIncorrectChoices = selectedChoices.length - numCorrectChoices;
    return [
      if (numCorrectChoices > 0)
        ...token.allUses(
          ConstructUseTypeEnum.corIt,
          metadata,
          ConstructUseTypeEnum.corIt.pointValue * numCorrectChoices,
        ),
      if (numIncorrectChoices > 0)
        ...token.allUses(
          ConstructUseTypeEnum.incIt,
          metadata,
          ConstructUseTypeEnum.incIt.pointValue * numIncorrectChoices,
        ),
    ];
  }

  List<OneConstructUse> _getUsesForIGCToken(
    PangeaToken token,
    PangeaMatch match,
    ConstructUseMetaData metadata,
  ) {
    final selectedChoices = match.match.choices!.where(
      (choice) => choice.selected,
    );

    if (selectedChoices.isEmpty) {
      return token.allUses(ConstructUseTypeEnum.ignIGC, metadata, 0);
    }

    final numCorrectChoices = selectedChoices
        .where((choice) => choice.type.isSuggestion)
        .length;

    final numIncorrectChoices = selectedChoices.length - numCorrectChoices;

    return [
      if (numCorrectChoices > 0)
        ...token.allUses(
          ConstructUseTypeEnum.corIGC,
          metadata,
          ConstructUseTypeEnum.corIGC.pointValue * numCorrectChoices,
        ),
      if (numIncorrectChoices > 0)
        ...token.allUses(
          ConstructUseTypeEnum.incIGC,
          metadata,
          ConstructUseTypeEnum.incIGC.pointValue * numIncorrectChoices,
        ),
    ];
  }
}
