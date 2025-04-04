import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/analytics_misc/constructs_model.dart';
import 'package:fluffychat/pangea/choreographer/models/choreo_record.dart';
import 'package:fluffychat/pangea/choreographer/models/pangea_match_model.dart';
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
    for (final token in tokensToSave) {
      uses.addAll(
        _getUsesForToken(
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
  ///
  /// For both vocab and morph constructs, we should
  /// 1) give wa if no assistance was used
  /// 2) give ga if IGC was used and
  /// 3) make no use if IT was used
  List<OneConstructUse> _getUsesForToken(
    PangeaToken token,
    ConstructUseMetaData metadata, {
    ChoreoRecord? choreo,
  }) {
    final List<OneConstructUse> uses = [];
    final lemma = token.lemma;
    final content = token.text.content;

    if (choreo == null) {
      uses.add(
        OneConstructUse(
          useType: ConstructUseTypeEnum.wa,
          lemma: token.pos,
          form: token.text.content,
          category: "POS",
          constructType: ConstructTypeEnum.morph,
          metadata: metadata,
        ),
      );

      for (final entry in token.morph.entries) {
        uses.add(
          OneConstructUse(
            useType: ConstructUseTypeEnum.wa,
            lemma: entry.value,
            form: token.text.content,
            category: entry.key,
            constructType: ConstructTypeEnum.morph,
            metadata: metadata,
          ),
        );
      }

      if (lemma.saveVocab) {
        uses.add(
          token.toVocabUse(
            ConstructUseTypeEnum.wa,
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

      // if the token was in an IT match, return no uses
      if (step.itStep != null) return [];

      // if this step was not accepted, continue
      if (!isAcceptedMatch) continue;

      if (isAcceptedMatch &&
          step.acceptedOrIgnoredMatch?.match.choices != null) {
        final choices = step.acceptedOrIgnoredMatch!.match.choices!;
        final bool stepContainedToken = choices.any(
          (choice) =>
              // if this choice contains the token's content
              choice.value.contains(content),
        );
        if (stepContainedToken) {
          // give ga if IGC was used
          uses.add(
            token.toVocabUse(
              ConstructUseTypeEnum.ga,
              metadata,
            ),
          );

          uses.add(
            OneConstructUse(
              useType: ConstructUseTypeEnum.ga,
              lemma: token.pos,
              form: token.text.content,
              category: "POS",
              constructType: ConstructTypeEnum.morph,
              metadata: metadata,
            ),
          );

          for (final entry in token.morph.entries) {
            uses.add(
              OneConstructUse(
                useType: ConstructUseTypeEnum.ga,
                lemma: entry.value,
                form: token.text.content,
                category: entry.key,
                constructType: ConstructTypeEnum.morph,
                metadata: metadata,
              ),
            );
          }
          return uses;
        }
      }
    }

    uses.add(
      OneConstructUse(
        useType: ConstructUseTypeEnum.wa,
        lemma: token.pos,
        form: token.text.content,
        category: "POS",
        constructType: ConstructTypeEnum.morph,
        metadata: metadata,
      ),
    );

    // the token wasn't found in any IT or IGC step, so it was wa
    for (final entry in token.morph.entries) {
      uses.add(
        OneConstructUse(
          useType: ConstructUseTypeEnum.wa,
          lemma: entry.value,
          form: token.text.content,
          category: entry.key,
          constructType: ConstructTypeEnum.morph,
          metadata: metadata,
        ),
      );
    }
    if (lemma.saveVocab) {
      uses.add(
        token.toVocabUse(
          ConstructUseTypeEnum.wa,
          metadata,
        ),
      );
    }
    return uses;
  }
}
