import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart' hide Result;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/choreographer/choreo_record_model.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/models/llm_feedback_model.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/models/stt_translation_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/events/repo/language_detection_repo.dart';
import 'package:fluffychat/pangea/events/repo/language_detection_request.dart';
import 'package:fluffychat/pangea/events/repo/language_detection_response.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/learning_settings/tool_settings_enum.dart';
import 'package:fluffychat/pangea/speech_to_text/audio_encoding_enum.dart';
import 'package:fluffychat/pangea/speech_to_text/speech_to_text_repo.dart';
import 'package:fluffychat/pangea/speech_to_text/speech_to_text_request_model.dart';
import 'package:fluffychat/pangea/speech_to_text/speech_to_text_response_model.dart';
import 'package:fluffychat/pangea/text_to_speech/text_to_speech_repo.dart';
import 'package:fluffychat/pangea/text_to_speech/text_to_speech_request_model.dart';
import 'package:fluffychat/pangea/text_to_speech/text_to_speech_response_model.dart';
import 'package:fluffychat/pangea/toolbar/message_practice/message_audio_card.dart';
import 'package:fluffychat/pangea/translation/full_text_translation_repo.dart';
import 'package:fluffychat/pangea/translation/full_text_translation_request_model.dart';
import 'package:fluffychat/pangea/translation/full_text_translation_response_model.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import '../../../widgets/matrix.dart';
import '../../common/utils/error_handler.dart';
import '../../languages/language_constants.dart';
import '../constants/pangea_event_types.dart';

class PangeaMessageEvent {
  late Event _event;
  final Timeline timeline;
  final bool ownMessage;

  PangeaMessageEvent({
    required Event event,
    required this.timeline,
    required this.ownMessage,
  }) {
    if (event.type != EventTypes.Message) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: "${event.type} should not be used to make a PangeaMessageEvent",
        data: {"event": event.toJson()},
      );
    }
    _event = event;
  }

  //the timeline filters the edits and uses the original events
  //so this event will always be the original and the sdk getter body
  //handles getting the latest text from the aggregated events
  Event get event => _event;

  String get body => _event.body;

  String get senderId => _event.senderId;

  DateTime get originServerTs => _event.originServerTs;

  String get eventId => _event.eventId;

  Room get room => _event.room;

  bool get isAudioMessage => _event.messageType == MessageTypes.Audio;

  String? get _l2Code => MatrixState.pangeaController.userController.userL2Code;

  String? get _l1Code =>
      MatrixState.pangeaController.userController.userL1?.langCode;

  Event? _latestEditCache;
  Event get _latestEdit => _latestEditCache ??=
      _event
          .aggregatedEvents(timeline, RelationshipTypes.edit)
          //sort by event.originServerTs to get the most recent first
          .sorted((a, b) => b.originServerTs.compareTo(a.originServerTs))
          .firstOrNull ??
      _event;

  // get audio events that are related to this event
  Set<Event> get ttsEvents => _latestEdit
      .aggregatedEvents(timeline, PangeaEventTypes.textToSpeech)
      .where((element) {
        return element.content.tryGet<Map<String, dynamic>>(
              ModelKey.transcription,
            ) !=
            null;
      })
      .toSet();

  Set<Event> get _sttTranslationEvents =>
      _latestEdit.aggregatedEvents(timeline, PangeaEventTypes.sttTranslation);

  List<RepresentationEvent> get _repEvents => _latestEdit
      .aggregatedEvents(timeline, PangeaEventTypes.representation)
      .map(
        (e) => RepresentationEvent(
          event: e,
          parentMessageEvent: _latestEdit,
          timeline: timeline,
        ),
      )
      .sorted((a, b) {
        if (a.event == null) return -1;
        if (b.event == null) return 1;
        return b.event!.originServerTs.compareTo(a.event!.originServerTs);
      })
      .toList();

  ChoreoRecordModel? get _embeddedChoreo {
    try {
      if (_latestEdit.content[ModelKey.choreoRecord] == null) return null;
      return ChoreoRecordModel.fromJson(
        _latestEdit.content[ModelKey.choreoRecord] as Map<String, dynamic>,
        originalWrittenContent,
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: _latestEdit.content,
        m: "error parsing choreoRecord",
      );
      return null;
    }
  }

  PangeaMessageTokens? _tokensSafe(Map<String, dynamic>? content) {
    try {
      if (content == null) return null;
      return PangeaMessageTokens.fromJson(content);
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: content ?? {},
        m: "error parsing tokensSent",
      );
      return null;
    }
  }

  List<RepresentationEvent>? _representations;
  List<RepresentationEvent> get representations {
    if (_representations != null) return _representations!;
    _representations = [];
    try {
      final tokens = _tokensSafe(
        _latestEdit.content[ModelKey.tokensSent] as Map<String, dynamic>?,
      );

      // If originalSent has no tokens, there is not way to generate a tokens event
      // and send it as a related event, since original sent has not eventID to set
      // as parentEventId. In this case, it's better to generate a new representation
      // with an eventID and send the related tokens event to that representation.
      // This is a rare situation, and has only been seen with some bot messages.
      if (tokens != null) {
        final lang = tokens.detections?.isNotEmpty == true
            ? tokens.detections!.first.langCode
            : null;

        final original = PangeaRepresentation(
          langCode: lang ?? LanguageKeys.unknownLanguage,
          text: _latestEdit.body,
          originalSent: true,
          originalWritten: false,
        );

        _representations!.add(
          RepresentationEvent(
            parentMessageEvent: _latestEdit,
            content: original,
            tokens: tokens,
            choreo: _embeddedChoreo,
            timeline: timeline,
          ),
        );
      }
    } catch (err, s) {
      ErrorHandler.logError(
        m: "error parsing originalSent",
        e: err,
        s: s,
        data: {"event": _latestEdit.toJson()},
      );
    }

    if (_latestEdit.content[ModelKey.originalWritten] != null) {
      try {
        _representations!.add(
          RepresentationEvent(
            parentMessageEvent: _latestEdit,
            content: PangeaRepresentation.fromJson(
              _latestEdit.content[ModelKey.originalWritten]
                  as Map<String, dynamic>,
            ),
            tokens: _tokensSafe(
              _latestEdit.content[ModelKey.tokensWritten]
                  as Map<String, dynamic>?,
            ),
            timeline: timeline,
          ),
        );
      } catch (err, s) {
        ErrorHandler.logError(
          m: "error parsing originalWritten",
          e: err,
          s: s,
          data: {"event": _latestEdit.toJson()},
        );
      }
    }

    _representations!.addAll(_repEvents);
    return _representations!;
  }

  RepresentationEvent? get originalSent => representations.firstWhereOrNull(
    (element) => element.content.originalSent,
  );

  RepresentationEvent? get originalWritten => representations.firstWhereOrNull(
    (element) => element.content.originalWritten,
  );

  String get originalWrittenContent {
    String? written = originalSent?.content.text;
    if (originalWritten != null && !originalWritten!.content.originalSent) {
      written = originalWritten!.text;
    } else if (originalSent?.choreo != null) {
      written = originalSent!.choreo!.originalText;
    }

    return written ?? body;
  }

  String get messageDisplayLangCode {
    if (isAudioMessage) {
      final stt = getSpeechToTextLocal();
      if (stt == null) return LanguageKeys.unknownLanguage;
      return stt.langCode;
    }

    final bool immersionMode = MatrixState.pangeaController.userController
        .isToolEnabled(ToolSetting.immersionMode);

    final String? originalLangCode = originalSent?.langCode;

    final String? langCode = immersionMode ? _l2Code : originalLangCode;
    return langCode ?? LanguageKeys.unknownLanguage;
  }

  RepresentationEvent? get messageDisplayRepresentation =>
      _representationByLanguage(messageDisplayLangCode);

  /// Gets the message display text for the current language code.
  /// If the message display text is not available for the current language code,
  /// it returns the message body.
  String get messageDisplayText =>
      messageDisplayRepresentation?.text ?? _latestEdit.body;

  TextDirection get textDirection =>
      LanguageConstants.rtlLanguageCodes.contains(messageDisplayLangCode)
      ? TextDirection.rtl
      : TextDirection.ltr;

  void updateLatestEdit() {
    _latestEditCache = null;
    _representations = null;
  }

  RepresentationEvent? _representationByLanguage(
    String langCode, {
    bool Function(RepresentationEvent)? filter,
  }) => representations.firstWhereOrNull(
    (element) =>
        element.langCode.split("-")[0] == langCode.split("-")[0] &&
        (filter?.call(element) ?? true),
  );

  RepresentationEvent? get _speechToTextRepresentation => representations
      .firstWhereOrNull((element) => element.content.speechToText != null);

  Event? _getTextToSpeechLocal(String langCode, String text, String? voice) {
    for (final audio in ttsEvents) {
      final dataMap = audio.content.tryGetMap(ModelKey.transcription);
      if (dataMap == null || !dataMap.containsKey(ModelKey.tokens)) continue;

      try {
        final PangeaAudioEventData audioData = PangeaAudioEventData.fromJson(
          dataMap as dynamic,
        );

        if (audioData.langCode == langCode &&
            audioData.text == text &&
            audioData.voice == voice) {
          return audio;
        }
      } catch (e, s) {
        debugger(when: kDebugMode);
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {"event": audio.toJson()},
          m: "error parsing data in getTextToSpeechLocal",
        );
      }
    }
    return null;
  }

  SpeechToTextResponseModel? getSpeechToTextLocal() {
    final rep = _speechToTextRepresentation?.content.speechToText;
    if (rep != null) return rep;

    // Check for STT embedded directly in the audio event content
    // (user-sent audio embeds under userStt, bot-sent audio under botTranscription)
    final rawEmbeddedStt =
        event.content.tryGetMap(ModelKey.userStt) ??
        event.content.tryGetMap(ModelKey.botTranscription);

    if (rawEmbeddedStt != null) {
      try {
        return SpeechToTextResponseModel.fromJson(
          Map<String, dynamic>.from(rawEmbeddedStt),
        );
      } catch (err, s) {
        ErrorHandler.logError(
          e: err,
          s: s,
          data: {"event": _event.toJson()},
          m: "error parsing embedded stt",
        );
        return null;
      }
    }

    return null;
  }

  SttTranslationModel? _getSttTranslationLocal(String langCode) {
    final events = _sttTranslationEvents;
    final List<SttTranslationModel> translations = [];
    for (final event in events) {
      try {
        final translation = SttTranslationModel.fromJson(event.content);
        translations.add(translation);
      } catch (e) {
        Sentry.addBreadcrumb(
          Breadcrumb(
            message: "Failed to parse STT translation",
            data: {
              "eventID": event.eventId,
              "content": event.content,
              "error": e.toString(),
            },
          ),
        );
      }
    }

    return translations.firstWhereOrNull((t) => t.langCode == langCode);
  }

  Future<PangeaAudioFile> requestTextToSpeech(
    String langCode,
    String? voice,
  ) async {
    final local = _getTextToSpeechLocal(langCode, messageDisplayText, voice);
    if (local != null) {
      final file = await local.getPangeaAudioFile();
      if (file != null) return file;
    }

    final rep = _representationByLanguage(langCode);
    final tokensResp = await rep?.requestTokens();
    final request = TextToSpeechRequestModel(
      text: rep?.content.text ?? body,
      tokens: tokensResp?.result?.map((t) => t.text).toList() ?? [],
      langCode: langCode,
      userL1: _l1Code ?? LanguageKeys.unknownLanguage,
      userL2: _l2Code ?? LanguageKeys.unknownLanguage,
      voice: voice,
    );

    final result = await TextToSpeechRepo.get(
      MatrixState.pangeaController.userController.accessToken,
      request,
    );

    if (result.error != null) {
      throw Exception("Error getting text to speech: ${result.error}");
    }

    final response = result.result!;
    final audioBytes = base64.decode(response.audioContent);
    final fileName =
        "audio_for_${_event.eventId}_$langCode.${response.fileExtension}";

    final file = PangeaAudioFile(
      bytes: audioBytes,
      name: fileName,
      mimeType: response.mimeType,
      duration: response.durationMillis,
      waveform: response.waveform,
      tokens: response.ttsTokens,
    );

    room.sendFileEvent(
      file,
      extraContent: {
        'info': {...file.info, ModelKey.duration: response.durationMillis},
        'org.matrix.msc3245.voice': {},
        'org.matrix.msc1767.audio': {
          ModelKey.duration: response.durationMillis,
          'waveform': response.waveform,
        },
        ModelKey.transcription: response
            .toPangeaAudioEventData(rep?.text ?? body, langCode, voice)
            .toJson(),
        "m.relates_to": {
          "rel_type": PangeaEventTypes.textToSpeech,
          "event_id": _event.eventId,
        },
      },
    );

    return file;
  }

  Future<SpeechToTextResponseModel> requestSpeechToText(
    String l1Code,
    String l2Code, {
    bool sendEvent = true,
  }) async {
    if (!isAudioMessage) {
      throw 'Calling getSpeechToText on non-audio message';
    }

    final speechToTextLocal = getSpeechToTextLocal();
    if (speechToTextLocal != null) {
      return speechToTextLocal;
    }

    final matrixFile = await _event.downloadAndDecryptAttachment();
    final result = await SpeechToTextRepo.get(
      MatrixState.pangeaController.userController.accessToken,
      SpeechToTextRequestModel(
        audioContent: matrixFile.bytes,
        audioEvent: _event,
        config: SpeechToTextAudioConfigModel(
          encoding: mimeTypeToAudioEncoding(matrixFile.mimeType),
          sampleRateHertz: 22050,
          userL1: l1Code,
          userL2: l2Code,
        ),
      ),
    );

    if (result.error != null) {
      throw Exception("Error getting speech to text: ${result.error}");
    }

    if (sendEvent) {
      sendSttRepresentationEvent(result.result!);
    }

    return result.result!;
  }

  Future<String> requestSttTranslation({
    required String langCode,
    required String l1Code,
    required String l2Code,
  }) async {
    // First try to access the local translation event via a representation event
    final local = _getSttTranslationLocal(langCode);
    if (local != null) return local.translation;

    final stt = await requestSpeechToText(l1Code, l2Code);
    final res = await FullTextTranslationRepo.get(
      MatrixState.pangeaController.userController.accessToken,
      FullTextTranslationRequestModel(
        text: stt.transcript.text,
        tgtLang: l1Code,
        userL2: l2Code,
        userL1: l1Code,
      ),
    );

    if (res.isError) {
      throw res.error!;
    }

    final translation = SttTranslationModel(
      translation: res.result!.bestTranslation,
      langCode: l1Code,
    );

    _sendSttTranslationEvent(sttTranslation: translation);
    return translation.translation;
  }

  Future<String?> requestRepresentationByDetectedLanguage() async {
    LanguageDetectionResponse? resp;
    final result = await LanguageDetectionRepo.get(
      MatrixState.pangeaController.userController.accessToken,
      LanguageDetectionRequest(
        text: _latestEdit.body,
        senderl1: _l1Code,
        senderl2: _l2Code,
      ),
    );

    if (result.isError) return null;
    resp = result.result!;

    final langCode = resp.detections.firstOrNull?.langCode;
    if (langCode == null) return null;
    if (langCode == originalSent?.langCode) {
      return originalSent?.event?.eventId;
    }

    final res = await _requestRepresentation(
      originalSent?.content.text ?? _latestEdit.body,
      langCode,
      originalSent?.langCode ?? LanguageKeys.unknownLanguage,
      originalSent: originalSent == null,
    );

    if (res.isError) return null;
    return _sendRepresentationEvent(res.result!);
  }

  Future<FullTextTranslationResponseModel> requestTranslationByL1({
    List<LLMFeedbackModel<FullTextTranslationResponseModel>>? feedback,
  }) async {
    if (_l1Code == null || _l2Code == null) {
      throw Exception("Missing language codes");
    }

    if (feedback == null) {
      final includedIT =
          originalSent?.choreo?.endedWithIT(originalSent!.text) == true;
      RepresentationEvent? rep;
      if (!includedIT) {
        // if the message didn't go through translation, get any l1 rep
        rep = _representationByLanguage(_l1Code!);
      } else {
        // if the message went through translation, get the non-original
        // l1 rep since originalWritten could contain some l2 words
        // (https://github.com/pangeachat/client/issues/3591)
        rep = _representationByLanguage(
          _l1Code!,
          filter: (rep) => !rep.content.originalWritten,
        );
      }
      if (rep != null) {
        return FullTextTranslationResponseModel(
          translation: rep.text,
          translations: [rep.text],
          source: messageDisplayLangCode,
        );
      }
    }

    final includedIT =
        originalSent?.choreo?.endedWithIT(originalSent!.text) == true;

    final String srcLang = includedIT
        ? (originalWritten?.langCode ?? _l1Code!)
        : (originalSent?.langCode ?? _l2Code!);

    final text = includedIT ? originalWrittenContent : messageDisplayText;
    final resp = await FullTextTranslationRepo.get(
      MatrixState.pangeaController.userController.accessToken,
      FullTextTranslationRequestModel(
        text: text,
        srcLang: srcLang,
        tgtLang: _l1Code!,
        userL2:
            MatrixState.pangeaController.userController.userL2Code ??
            LanguageKeys.unknownLanguage,
        userL1: _l1Code!,
        feedback: feedback,
      ),
    );

    if (resp.isError) throw resp.error!;
    _sendRepresentationEvent(
      PangeaRepresentation(
        langCode: _l1Code!,
        text: resp.result!.bestTranslation,
        originalSent: false,
        originalWritten: false,
      ),
    );
    return resp.result!;
  }

  Future<Result<PangeaRepresentation>> _requestRepresentation(
    String text,
    String targetLang,
    String sourceLang, {
    bool originalSent = false,
    List<LLMFeedbackModel<FullTextTranslationResponseModel>>? feedback,
  }) async {
    _representations = null;

    final res = await FullTextTranslationRepo.get(
      MatrixState.pangeaController.userController.accessToken,
      FullTextTranslationRequestModel(
        text: text,
        srcLang: sourceLang,
        tgtLang: targetLang,
        userL2: _l2Code ?? LanguageKeys.unknownLanguage,
        userL1: _l1Code ?? LanguageKeys.unknownLanguage,
        feedback: feedback,
      ),
    );

    return res.isError
        ? Result.error(res.error!)
        : Result.value(
            PangeaRepresentation(
              langCode: targetLang,
              text: res.result!.bestTranslation,
              originalSent: originalSent,
              originalWritten: false,
            ),
          );
  }

  Future<String?> _sendRepresentationEvent(
    PangeaRepresentation representation,
  ) async {
    final repEvent = await room.sendPangeaEvent(
      content: representation.toJson(),
      parentEventId: _latestEdit.eventId,
      type: PangeaEventTypes.representation,
    );
    return repEvent?.eventId;
  }

  Future<Event?> sendSttRepresentationEvent(
    SpeechToTextResponseModel stt,
  ) async {
    final representation = PangeaRepresentation(
      langCode: stt.langCode,
      text: stt.transcript.text,
      originalSent: false,
      originalWritten: false,
      speechToText: stt,
    );

    _representations = null;
    return room.sendPangeaEvent(
      content: representation.toJson(),
      parentEventId: _latestEdit.eventId,
      type: PangeaEventTypes.representation,
    );
  }

  Future<Event?> _sendSttTranslationEvent({
    required SttTranslationModel sttTranslation,
  }) => room.sendPangeaEvent(
    content: sttTranslation.toJson(),
    parentEventId: _latestEdit.eventId,
    type: PangeaEventTypes.sttTranslation,
  );
}
