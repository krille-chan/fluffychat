import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
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
    if (json[_langCodeKey] == LanguageKeys.unknownLanguage) {
      ErrorHandler.logError(
        e: Exception("Language code cannot be 'unk'"),
        s: StackTrace.current,
        data: {"rep_content": json},
      );
    }
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
}
