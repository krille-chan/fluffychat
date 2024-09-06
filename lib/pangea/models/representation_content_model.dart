import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/choreo_record.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/speech_to_text_models.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:matrix/matrix.dart';

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

  /// Get construct uses of type vocab for the message.
  /// Takes a list of tokens and a choreo record, which is searched
  /// through for each token for its construct use type.
  /// Also takes either an event (typically when the Representation itself is
  /// available) or construct use metadata (when the event is not available,
  /// i.e. immediately after message send) to create the construct use.
  List<OneConstructUse> vocabUses({
    required List<PangeaToken> tokens,
    Event? event,
    ConstructUseMetaData? metadata,
    ChoreoRecord? choreo,
  }) {
    final List<OneConstructUse> uses = [];

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
    final tokensToSave =
        tokens.where((token) => token.lemma.saveVocab).toList();
    for (final token in tokensToSave) {
      uses.addAll(
        getUsesForToken(
          token,
          metadata,
          choreo: choreo,
        ),
      );
    }

    return uses;
  }

  /// Returns a [OneConstructUse] for the given [token]
  /// If there is no [choreo], the [token] is
  /// considered to be a [ConstructUseTypeEnum.wa] as long as it matches the target language.
  /// Later on, we may want to consider putting it in some category of like 'pending'
  /// If the [token] is in the [choreo.acceptedOrIgnoredMatch], it is considered to be a [ConstructUseTypeEnum.ga].
  /// If the [token] is in the [choreo.acceptedOrIgnoredMatch.choices], it is considered to be a [ConstructUseTypeEnum.corIt].
  /// If the [token] is not included in any choreoStep, it is considered to be a [ConstructUseTypeEnum.wa].
  List<OneConstructUse> getUsesForToken(
    PangeaToken token,
    ConstructUseMetaData metadata, {
    ChoreoRecord? choreo,
  }) {
    final List<OneConstructUse> uses = [];
    final lemma = token.lemma;
    final content = token.text.content;

    if (choreo == null) {
      final bool inUserL2 = langCode ==
          MatrixState.pangeaController.languageController.activeL2Code();
      final useType =
          inUserL2 ? ConstructUseTypeEnum.wa : ConstructUseTypeEnum.unk;
      for (final entry in token.morph.entries) {
        uses.add(
          OneConstructUse(
            useType: useType,
            lemma: entry.value,
            categories: [entry.key],
            constructType: ConstructTypeEnum.morph,
            metadata: metadata,
          ),
        );
      }

      if (lemma.saveVocab) {
        uses.add(
          lemma.toVocabUse(
            inUserL2 ? ConstructUseTypeEnum.wa : ConstructUseTypeEnum.unk,
            metadata,
          ),
        );
      }
      return uses;
    }

    for (final step in choreo.choreoSteps) {
      /// if 1) accepted match 2) token is in the replacement and 3) replacement
      /// is in the overall step text, then token was a ga
      final bool isAcceptedMatch =
          step.acceptedOrIgnoredMatch?.status == PangeaMatchStatus.accepted;
      final bool isITStep = step.itStep != null;
      if (!isAcceptedMatch && !isITStep) continue;

      if (isAcceptedMatch &&
          step.acceptedOrIgnoredMatch?.match.choices != null) {
        final choices = step.acceptedOrIgnoredMatch!.match.choices!;
        final bool stepContainedToken = choices.any(
          (choice) =>
              // if this choice contains the token's content
              choice.value.contains(content) &&
              // if the complete input text after this step
              // contains the choice (why is this here?)
              step.text.contains(choice.value),
        );
        if (stepContainedToken) {
          return [];
        }
      }

      if (isITStep && step.itStep?.chosenContinuance != null) {
        final bool pickedThroughIT =
            step.itStep!.chosenContinuance!.text.contains(content);
        if (pickedThroughIT) {
          return [];
        }
      }
    }

    for (final entry in token.morph.entries) {
      uses.add(
        OneConstructUse(
          useType: ConstructUseTypeEnum.wa,
          lemma: entry.value,
          categories: [entry.key],
          constructType: ConstructTypeEnum.morph,
          metadata: metadata,
        ),
      );
    }
    if (lemma.saveVocab) {
      uses.add(
        lemma.toVocabUse(
          ConstructUseTypeEnum.wa,
          metadata,
        ),
      );
    }
    return uses;
  }
}
