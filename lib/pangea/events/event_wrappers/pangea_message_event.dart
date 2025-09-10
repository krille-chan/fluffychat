import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/choreographer/models/choreo_record.dart';
import 'package:fluffychat/pangea/choreographer/repo/full_text_translation_repo.dart';
import 'package:fluffychat/pangea/choreographer/repo/language_detection_repo.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/models/stt_translation_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/learning_settings/utils/p_language_store.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/pangea/spaces/models/space_model.dart';
import 'package:fluffychat/pangea/toolbar/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/toolbar/enums/audio_encoding_enum.dart';
import 'package:fluffychat/pangea/toolbar/event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/toolbar/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_audio_card.dart';
import '../../../widgets/matrix.dart';
import '../../common/utils/error_handler.dart';
import '../../learning_settings/constants/language_constants.dart';
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
        data: {
          "event": event.toJson(),
        },
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

  String? get mimetype {
    if (!isAudioMessage) return null;
    final Map<String, dynamic>? info = _event.content.tryGetMap("info");
    debugPrint("INFO: $info");
    if (info == null) return null;
    return info["mime_type"] ?? info["mimetype"];
  }

  Event? _latestEditCache;
  Event get _latestEdit => _latestEditCache ??= _event
          .aggregatedEvents(
            timeline,
            RelationshipTypes.edit,
          )
          //sort by event.originServerTs to get the most recent first
          .sorted(
            (a, b) => b.originServerTs.compareTo(a.originServerTs),
          )
          .firstOrNull ??
      _event;

  void updateLatestEdit() {
    _latestEditCache = null;
    _representations = null;
  }

  Future<PangeaAudioFile?> getMatrixAudioFile(
    String langCode,
  ) async {
    final RepresentationEvent? rep = representationByLanguage(langCode);

    final TextToSpeechRequest params = TextToSpeechRequest(
      text: rep?.content.text ?? body,
      tokens: (await rep?.tokensGlobal(
            senderId,
            originServerTs,
          ))
              ?.map((t) => t.text)
              .toList() ??
          [],
      langCode: langCode,
      userL1: l1Code ?? LanguageKeys.unknownLanguage,
      userL2: l2Code ?? LanguageKeys.unknownLanguage,
    );

    final TextToSpeechResponse response =
        await MatrixState.pangeaController.textToSpeech.get(
      params,
    );

    final audioBytes = base64.decode(response.audioContent);
    final eventIdParam = _event.eventId;
    final fileName =
        "audio_for_${eventIdParam}_$langCode.${response.fileExtension}";

    final file = PangeaAudioFile(
      bytes: audioBytes,
      name: fileName,
      mimeType: response.mimeType,
      duration: response.durationMillis,
      waveform: response.waveform,
      tokens: response.ttsTokens,
    );

    sendAudioEvent(file, response, rep?.text ?? body, langCode);

    return file;
  }

  Future<Event?> sendAudioEvent(
    PangeaAudioFile file,
    TextToSpeechResponse response,
    String text,
    String langCode,
  ) async {
    final String? eventId = await room.sendFileEvent(
      file,
      inReplyTo: _event,
      extraContent: {
        'info': {
          ...file.info,
          'duration': response.durationMillis,
        },
        'org.matrix.msc3245.voice': {},
        'org.matrix.msc1767.audio': {
          'duration': response.durationMillis,
          'waveform': response.waveform,
        },
        ModelKey.transcription:
            response.toPangeaAudioEventData(text, langCode).toJson(),
      },
    );

    debugPrint("eventId in getTextToSpeechGlobal $eventId");
    final Event? audioEvent =
        eventId != null ? await room.getEventById(eventId) : null;

    if (audioEvent == null) {
      return null;
    }
    allAudio.add(audioEvent);
    return audioEvent;
  }

  Event? getTextToSpeechLocal(String langCode, String text) {
    return allAudio.firstWhereOrNull(
      (event) {
        try {
          // Safely access
          final dataMap = event.content.tryGetMap(ModelKey.transcription);

          if (dataMap == null) {
            return false;
          }

          // old text to speech content will not have TTSToken data
          // we want to disregard them and just generate new ones
          // for that, we'll return false if 'tokens' are null
          // while in-development, we'll pause here to inspect
          // debugger can be removed after we're sure it's working
          if (dataMap['tokens'] == null) {
            // events before today will definitely not have the tokens
            debugger(
              when: kDebugMode &&
                  event.originServerTs.isAfter(DateTime(2024, 10, 16)),
            );
            return false;
          }

          final PangeaAudioEventData audioData =
              PangeaAudioEventData.fromJson(dataMap as dynamic);

          // Check if both language code and text match
          return audioData.langCode == langCode && audioData.text == text;
        } catch (e, s) {
          debugger(when: kDebugMode);
          ErrorHandler.logError(
            e: e,
            s: s,
            data: {},
            m: "error parsing data in getTextToSpeechLocal",
          );
          return false;
        }
      },
    );
  }

  // get audio events that are related to this event
  Set<Event> get allAudio => _latestEdit
          .aggregatedEvents(
        timeline,
        RelationshipTypes.reply,
      )
          .where((element) {
        return element.content.tryGet<Map<String, dynamic>>(
              ModelKey.transcription,
            ) !=
            null;
      }).toSet();

  SpeechToTextModel? getSpeechToTextLocal() {
    final rawBotTranscription =
        event.content.tryGetMap(ModelKey.botTranscription);

    if (rawBotTranscription != null) {
      return SpeechToTextModel.fromJson(
        Map<String, dynamic>.from(rawBotTranscription),
      );
    }

    return representations
        .firstWhereOrNull(
          (element) => element.content.speechToText != null,
        )
        ?.content
        .speechToText;
  }

  Future<SpeechToTextModel?> getSpeechToText(
    String l1Code,
    String l2Code,
  ) async {
    if (!isAudioMessage) {
      ErrorHandler.logError(
        e: 'Calling getSpeechToText on non-audio message',
        s: StackTrace.current,
        data: {
          "content": _event.content,
          "eventId": _event.eventId,
          "roomId": _event.roomId,
          "userId": _event.room.client.userID,
          "account_data": _event.room.client.accountData,
        },
      );
      return null;
    }

    final rawBotTranscription =
        event.content.tryGetMap(ModelKey.botTranscription);
    if (rawBotTranscription != null) {
      final botTranscription = SpeechToTextModel.fromJson(
        Map<String, dynamic>.from(rawBotTranscription),
      );

      _representations ??= [];
      _representations!.add(
        RepresentationEvent(
          timeline: timeline,
          parentMessageEvent: _event,
          content: PangeaRepresentation(
            langCode: botTranscription.langCode,
            text: botTranscription.transcript.text,
            originalSent: false,
            originalWritten: false,
            speechToText: botTranscription,
          ),
        ),
      );

      return botTranscription;
    }

    final SpeechToTextModel? speechToTextLocal = representations
        .firstWhereOrNull(
          (element) => element.content.speechToText != null,
        )
        ?.content
        .speechToText;

    if (speechToTextLocal != null) {
      return speechToTextLocal;
    }

    final matrixFile = await _event.downloadAndDecryptAttachment();

    final SpeechToTextModel response =
        await MatrixState.pangeaController.speechToText.get(
      SpeechToTextRequestModel(
        audioContent: matrixFile.bytes,
        audioEvent: _event,
        config: SpeechToTextAudioConfigModel(
          encoding: mimeTypeToAudioEncoding(matrixFile.mimeType),
          //this is the default in the RecordConfig in record package
          //TODO: check if this is the correct value and make it a constant somewhere
          sampleRateHertz: 22050,
          userL1: l1Code,
          userL2: l2Code,
        ),
      ),
    );

    _representations?.add(
      RepresentationEvent(
        timeline: timeline,
        parentMessageEvent: _event,
        content: PangeaRepresentation(
          langCode: response.langCode,
          text: response.transcript.text,
          originalSent: false,
          originalWritten: false,
          speechToText: response,
        ),
      ),
    );

    return response;
  }

  Future<SttTranslationModel?> sttTranslationByLanguageGlobal({
    required String langCode,
    required String l1Code,
    required String l2Code,
  }) async {
    if (!representations.any(
      (element) => element.content.speechToText != null,
    )) {
      await getSpeechToText(l1Code, l2Code);
    }

    final rep = representations.firstWhereOrNull(
      (element) => element.content.speechToText != null,
    );

    if (rep == null) return null;
    return rep.getSttTranslation(userL1: l1Code, userL2: l2Code);
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

  ChoreoRecord? get _embeddedChoreo {
    try {
      if (_latestEdit.content[ModelKey.choreoRecord] == null) return null;
      return ChoreoRecord.fromJson(
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

  List<RepresentationEvent>? _representations;
  List<RepresentationEvent> get representations {
    if (_representations != null) return _representations!;
    _representations = [];
    if (_latestEdit.content[ModelKey.originalSent] != null) {
      try {
        final RepresentationEvent sent = RepresentationEvent(
          parentMessageEvent: _event,
          content: PangeaRepresentation.fromJson(
            _latestEdit.content[ModelKey.originalSent] as Map<String, dynamic>,
          ),
          tokens: _tokensSafe(
            _latestEdit.content[ModelKey.tokensSent] as Map<String, dynamic>?,
          ),
          choreo: _embeddedChoreo,
          timeline: timeline,
        );
        if (_latestEdit.content[ModelKey.choreoRecord] == null) {
          Sentry.addBreadcrumb(
            Breadcrumb(
              message: "originalSent created without _event or _choreo",
              data: {
                "eventId": _latestEdit.eventId,
                "room": _latestEdit.room.id,
                "sender": _latestEdit.senderId,
              },
            ),
          );
        }

        // If originalSent has no tokens, there is not way to generate a tokens event
        // and send it as a related event, since original sent has not eventID to set
        // as parentEventId. In this case, it's better to generate a new representation
        // with an eventID and send the related tokens event to that representation.
        // This is a rare situation, and has only been seen with some bot messages.
        if (sent.tokens != null) {
          _representations!.add(sent);
        }
      } catch (err, s) {
        ErrorHandler.logError(
          m: "error parsing originalSent",
          e: err,
          s: s,
          data: {
            "event": _event.toJson(),
          },
        );
      }
    }

    if (_latestEdit.content[ModelKey.originalWritten] != null) {
      try {
        _representations!.add(
          RepresentationEvent(
            parentMessageEvent: _event,
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
          data: {
            "event": _event.toJson(),
          },
        );
      }
    }

    _representations!.addAll(
      _latestEdit
          .aggregatedEvents(
            timeline,
            PangeaEventTypes.representation,
          )
          .map(
            (e) => RepresentationEvent(
              event: e,
              parentMessageEvent: _event,
              timeline: timeline,
            ),
          )
          .sorted(
        (a, b) {
          //TODO - test with edited events to make sure this is working
          if (a.event == null) return -1;
          if (b.event == null) return 1;
          return b.event!.originServerTs.compareTo(a.event!.originServerTs);
        },
      ).toList(),
    );

    return _representations!;
  }

  RepresentationEvent? representationByLanguage(
    String langCode, {
    bool Function(RepresentationEvent)? filter,
  }) =>
      representations.firstWhereOrNull(
        (element) =>
            element.langCode.split("-")[0] == langCode.split("-")[0] &&
            (filter?.call(element) ?? true),
      );

  Future<PangeaRepresentation?> representationByLanguageGlobal({
    required String langCode,
  }) async {
    final RepresentationEvent? repLocal = representationByLanguage(langCode);

    if (repLocal != null ||
        langCode == LanguageKeys.unknownLanguage ||
        langCode == LanguageKeys.mixedLanguage ||
        langCode == LanguageKeys.multiLanguage) {
      return repLocal?.content;
    }

    if (eventId.contains("Pangea Chat")) return null;

    // should this just be the original event body?
    // worth a conversation with the team
    final PangeaRepresentation? basis = originalSent?.content;

    // clear representations cache so the new representation event can be added
    // when next requested
    _representations = null;

    return MatrixState.pangeaController.messageData.getPangeaRepresentation(
      req: FullTextTranslationRequestModel(
        text: basis?.text ?? _latestEdit.body,
        srcLang: basis?.langCode,
        tgtLang: langCode,
        userL2: l2Code ?? LanguageKeys.unknownLanguage,
        userL1: l1Code ?? LanguageKeys.unknownLanguage,
      ),
      messageEvent: _event,
    );
  }

  Future<String?> representationByDetectedLanguage() async {
    LanguageDetectionResponse? resp;
    try {
      resp = await LanguageDetectionRepo.get(
        MatrixState.pangeaController.userController.accessToken,
        request: LanguageDetectionRequest(
          text: _latestEdit.body,
          senderl1: l1Code,
          senderl2: l2Code,
        ),
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "event": _event.toJson(),
        },
      );
      return null;
    }

    final langCode = resp.detections.firstOrNull?.langCode;
    if (langCode == null) return null;
    if (langCode == originalSent?.langCode) {
      return originalSent?.event?.eventId;
    }

    // clear representations cache so the new representation event can be added when next requested
    _representations = null;

    return MatrixState.pangeaController.messageData
        .getPangeaRepresentationEvent(
      req: FullTextTranslationRequestModel(
        text: originalSent?.content.text ?? _latestEdit.body,
        srcLang: originalSent?.langCode,
        tgtLang: langCode,
        userL2: l2Code ?? LanguageKeys.unknownLanguage,
        userL1: l1Code ?? LanguageKeys.unknownLanguage,
      ),
      messageEvent: this,
      originalSent: true,
    );
  }

  Future<PangeaRepresentation> l1Respresentation() async {
    if (l1Code == null || l2Code == null) {
      throw Exception("Missing language codes");
    }

    final includedIT =
        (originalSent?.choreo?.endedWithIT(originalSent!.text) ?? false) &&
            !(originalSent?.choreo?.includedIGC ?? true);

    RepresentationEvent? rep;
    if (!includedIT) {
      // if the message didn't go through translation, get any l1 rep
      rep = representationByLanguage(l1Code!);
    } else {
      // if the message went through translation, get the non-original
      // l1 rep since originalWritten could contain some l2 words
      // (https://github.com/pangeachat/client/issues/3591)
      rep = representationByLanguage(
        l1Code!,
        filter: (rep) => !rep.content.originalWritten,
      );
    }

    if (rep != null) return rep.content;

    final String srcLang = includedIT
        ? (originalWritten?.langCode ?? l1Code!)
        : (originalSent?.langCode ?? l2Code!);

    // clear representations cache so the new representation event can be added when next requested
    _representations = null;
    return MatrixState.pangeaController.messageData.getPangeaRepresentation(
      req: FullTextTranslationRequestModel(
        text: includedIT ? originalWrittenContent : messageDisplayText,
        srcLang: srcLang,
        tgtLang: l1Code!,
        userL2: l2Code!,
        userL1: l1Code!,
      ),
      messageEvent: _event,
    );
  }

  RepresentationEvent? get originalSent => representations
      .firstWhereOrNull((element) => element.content.originalSent);

  RepresentationEvent? get originalWritten => representations
      .firstWhereOrNull((element) => element.content.originalWritten);

  String get originalWrittenContent {
    String? written = originalSent?.content.text;
    if (originalWritten != null && !originalWritten!.content.originalSent) {
      written = originalWritten!.text;
    } else if (originalSent?.choreo != null) {
      written = originalSent!.choreo!.originalText;
    }

    return written ?? body;
  }

  String? get l2Code =>
      MatrixState.pangeaController.languageController.activeL2Code();

  String? get l1Code =>
      MatrixState.pangeaController.languageController.userL1?.langCode;

  /// Should almost always be true. Useful in the case that the message
  /// display rep has the langCode "unk"
  bool get messageDisplayLangIsL2 =>
      messageDisplayLangCode.split("-")[0] == l2Code?.split("-")[0];

  String get messageDisplayLangCode {
    if (isAudioMessage) {
      final stt = getSpeechToTextLocal();
      if (stt == null) return LanguageKeys.unknownLanguage;
      return stt.langCode;
    }

    final bool immersionMode = MatrixState
        .pangeaController.permissionsController
        .isToolEnabled(ToolSetting.immersionMode, room);

    final String? originalLangCode = originalSent?.langCode;

    final String? langCode = immersionMode ? l2Code : originalLangCode;
    return langCode ?? LanguageKeys.unknownLanguage;
  }

  RepresentationEvent? get messageDisplayRepresentation =>
      representationByLanguage(messageDisplayLangCode);

  /// Gets the message display text for the current language code.
  /// If the message display text is not available for the current language code,
  /// it returns the message body.
  String get messageDisplayText => messageDisplayRepresentation?.text ?? body;

  /// Returns a list of all [PracticeActivityEvent] objects
  /// associated with this message event.
  List<PracticeActivityEvent> get _practiceActivityEvents {
    final List<Event> events = _latestEdit
        .aggregatedEvents(
          timeline,
          PangeaEventTypes.pangeaActivity,
        )
        .where((event) => !event.redacted)
        .toList();

    final List<PracticeActivityEvent> practiceEvents = [];
    for (final event in events) {
      try {
        practiceEvents.add(
          PracticeActivityEvent(
            timeline: timeline,
            event: event,
          ),
        );
      } catch (e, s) {
        ErrorHandler.logError(e: e, s: s, data: event.toJson());
      }
    }
    return practiceEvents;
  }

  /// Returns a list of [PracticeActivityEvent] objects for the given [langCode].
  List<PracticeActivityEvent> practiceActivitiesByLangCode(
    String langCode, {
    bool debug = false,
  }) =>
      _practiceActivityEvents
          .where(
            (event) =>
                event.practiceActivity.langCode.split("-")[0] ==
                langCode.split("")[0],
          )
          .toList();

  /// Returns a list of [PracticeActivityEvent] for the user's active l2.
  List<PracticeActivityEvent> get practiceActivities =>
      l2Code == null ? [] : practiceActivitiesByLangCode(l2Code!);

  bool shouldDoActivity({
    required PangeaToken? token,
    required ActivityTypeEnum a,
    required MorphFeaturesEnum? feature,
    required String? tag,
  }) {
    if (!messageDisplayLangIsL2 || token == null) {
      return false;
    }

    return token.shouldDoActivity(
      a: a,
      feature: feature,
      tag: tag,
    );
  }

  TextDirection get textDirection =>
      PLanguageStore.rtlLanguageCodes.contains(messageDisplayLangCode)
          ? TextDirection.rtl
          : TextDirection.ltr;
}
