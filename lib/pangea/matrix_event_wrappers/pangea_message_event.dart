import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/controllers/text_to_speech_controller.dart';
import 'package:fluffychat/pangea/enum/audio_encoding_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_representation_event.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/practice_activity_event.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';
import 'package:fluffychat/pangea/models/choreo_record.dart';
import 'package:fluffychat/pangea/models/pangea_match_model.dart';
import 'package:fluffychat/pangea/models/representation_content_model.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/models/speech_to_text_models.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/repo/full_text_translation_repo.dart';
import 'package:fluffychat/pangea/widgets/chat/message_audio_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../widgets/matrix.dart';
import '../constants/language_constants.dart';
import '../constants/pangea_event_types.dart';
import '../enum/use_type.dart';
import '../utils/error_handler.dart';

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

  Future<PangeaAudioFile> getMatrixAudioFile(
    String langCode,
    BuildContext context,
  ) async {
    final String text = (await representationByLanguageGlobal(
          langCode: langCode,
        ))
            ?.text ??
        body;
    final TextToSpeechRequest params = TextToSpeechRequest(
      text: text,
      langCode: langCode,
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
    );

    sendAudioEvent(file, response, text, langCode);

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
        ModelKey.transcription: {
          ModelKey.text: text,
          ModelKey.langCode: langCode,
        },
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

  //get audio for text and language
  //if no audio exists, create it
  //if audio exists, return it
  Future<Event?> getTextToSpeechGlobal(String langCode) async {
    final String text = representationByLanguage(langCode)?.text ?? body;

    final local = getTextToSpeechLocal(langCode, text);

    if (local != null) return Future.value(local);

    final TextToSpeechRequest params = TextToSpeechRequest(
      text: text,
      langCode: langCode,
    );

    final TextToSpeechResponse response =
        await MatrixState.pangeaController.textToSpeech.get(
      params,
    );

    final audioBytes = base64.decode(response.audioContent);

    // if (!TextToSpeechController.isOggFile(audioBytes)) {
    //   throw Exception("File is not a valid OGG format");
    // } else {
    //   debugPrint("File is a valid OGG format");
    // }

    // from text, trim whitespace, remove special characters, and limit to 20 characters
    // final fileName =
    //     text.trim().replaceAll(RegExp('[^A-Za-z0-9]'), '').substring(0, 20);
    final eventIdParam = _event.eventId;
    final fileName =
        "audio_for_${eventIdParam}_$langCode.${response.fileExtension}";

    final file = MatrixAudioFile(
      bytes: audioBytes,
      name: fileName,
      mimeType: response.mimeType,
    );

    // try {
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
        ModelKey.transcription: {
          ModelKey.text: text,
          ModelKey.langCode: langCode,
        },
      },
    );
    // .timeout(
    //   Durations.long4,
    //   onTimeout: () {
    //     debugPrint("timeout in getTextToSpeechGlobal");
    //     return null;
    //   },
    // );

    debugPrint("eventId in getTextToSpeechGlobal $eventId");
    return eventId != null ? room.getEventById(eventId) : null;
  }

  Event? getTextToSpeechLocal(String langCode, String text) {
    return allAudio.firstWhereOrNull(
      (element) {
        // Safely access the transcription map
        final transcription = element.content.tryGetMap(ModelKey.transcription);

        // return transcription != null;
        if (transcription == null) {
          // If transcription is null, this element does not match.
          return false;
        }

        // Safely get language code and text from the transcription
        final elementLangCode = transcription[ModelKey.langCode];
        final elementText = transcription[ModelKey.text];

        // Check if both language code and text matsch
        return elementLangCode == langCode && elementText == text;
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

  SpeechToTextModel? getSpeechToTextLocal(
    String? l1Code,
    String? l2Code,
  ) {
    if (l1Code == null || l2Code == null) {
      return null;
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

    final SpeechToTextModel? speechToTextLocal = representations
        .firstWhereOrNull(
          (element) => element.content.speechToText != null,
        )
        ?.content
        .speechToText;

    if (speechToTextLocal != null) return speechToTextLocal;

    final matrixFile = await _event.downloadAndDecryptAttachment();
    // Pangea#
    // File? file;

    // TODO: Test on mobile and see if we need this case, doeesn't seem so
    // if (!kIsWeb) {
    //   final tempDir = await getTemporaryDirectory();
    //   final fileName = Uri.encodeComponent(
    //     // #Pangea
    //     // widget.event.attachmentOrThumbnailMxcUrl()!.pathSegments.last,
    //     widget.messageEvent.event
    //         .attachmentOrThumbnailMxcUrl()!
    //         .pathSegments
    //         .last,
    //     // Pangea#
    //   );
    //   file = File('${tempDir.path}/${fileName}_${matrixFile.name}');
    //   await file.writeAsBytes(matrixFile.bytes);
    // }

    // audioFile = file;

    debugPrint("mimeType ${matrixFile.mimeType}");
    debugPrint("encoding ${mimeTypeToAudioEncoding(matrixFile.mimeType)}");

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

  PangeaMessageTokens? _tokensSafe(Map<String, dynamic>? content) {
    try {
      if (content == null) return null;
      return PangeaMessageTokens.fromJson(content);
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: content,
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
        _representations!.add(sent);
      } catch (err, s) {
        ErrorHandler.logError(
          m: "error parsing originalSent",
          e: err,
          s: s,
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

  RepresentationEvent? representationByLanguage(String langCode) =>
      representations.firstWhereOrNull(
        (element) => element.langCode == langCode,
      );

  int translationIndex(String langCode) => representations.indexWhere(
        (element) => element.langCode == langCode,
      );

  String translationTextSafe(String langCode) {
    return representationByLanguage(langCode)?.text ?? body;
  }

  Future<PangeaRepresentation?> representationByLanguageGlobal({
    required String langCode,
  }) async {
    final RepresentationEvent? repLocal = representationByLanguage(langCode);

    if (repLocal != null ||
        langCode == LanguageKeys.unknownLanguage ||
        langCode == LanguageKeys.mixedLanguage ||
        langCode == LanguageKeys.multiLanguage) return repLocal?.content;

    if (eventId.contains("web")) return null;

    // should this just be the original event body?
    // worth a conversation with the team
    final PangeaRepresentation? basis =
        (originalWritten ?? originalSent)?.content;

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

  RepresentationEvent? get originalSent => representations
      .firstWhereOrNull((element) => element.content.originalSent);

  RepresentationEvent? get originalWritten => representations
      .firstWhereOrNull((element) => element.content.originalWritten);

  PangeaRepresentation get defaultRepresentation => PangeaRepresentation(
        langCode: LanguageKeys.unknownLanguage,
        text: body,
        originalSent: false,
        originalWritten: false,
      );

  UseType get msgUseType {
    final ChoreoRecord? choreoRecord = originalSent?.choreo;
    if (choreoRecord == null) {
      return UseType.un;
    } else if (choreoRecord.includedIT) {
      return UseType.ta;
    } else if (choreoRecord.hasAcceptedMatches) {
      return UseType.ga;
    } else {
      return UseType.wa;
    }
  }

  bool get showUseType => false;
  // *note* turning this feature off but leave code here to bring back (if need)
  // !ownMessage &&
  // _event.room.isSpaceAdmin &&
  // _event.senderId != BotName.byEnvironment &&
  // !room.isUserSpaceAdmin(_event.senderId) &&
  // _event.messageType != PangeaEventTypes.report &&
  // _event.messageType == MessageTypes.Text;

  // this is just showActivityIcon now but will include
  // logic for showing
  // NOTE: turning this off for now
  bool get showMessageButtons => false;
  // bool get showMessageButtons => hasUncompletedActivity;

  /// Returns a boolean value indicating whether to show an activity icon for this message event.
  ///
  /// The [hasUncompletedActivity] getter checks if the [l2Code] is null, and if so, returns false.
  /// Otherwise, it retrieves a list of [PracticeActivityEvent] objects using the [practiceActivities] function
  /// with the [l2Code] as an argument.
  /// If the list is empty, it returns false.
  /// Otherwise, it checks if every activity in the list is complete using the [isComplete] property.
  /// If any activity is not complete, it returns true, indicating that the activity icon should be shown.
  /// Otherwise, it returns false.
  bool get hasUncompletedActivity {
    if (practiceActivities.isEmpty) return false;
    return practiceActivities.any((activity) => !(activity.isComplete));
  }

  int get numberOfActivitiesCompleted {
    return practiceActivities.where((activity) => activity.isComplete).length;
  }

  String? get l2Code =>
      MatrixState.pangeaController.languageController.activeL2Code();

  String? get l1Code =>
      MatrixState.pangeaController.languageController.userL1?.langCode;

  String get messageDisplayLangCode {
    final bool immersionMode = MatrixState
        .pangeaController.permissionsController
        .isToolEnabled(ToolSetting.immersionMode, room);

    final String? originalLangCode =
        (originalWritten ?? originalSent)?.langCode;

    final String? langCode = immersionMode ? l2Code : originalLangCode;
    return langCode ?? LanguageKeys.unknownLanguage;
  }

  /// Gets the message display text for the current language code.
  /// If the message display text is not available for the current language code,
  /// it returns the message body.
  String get messageDisplayText {
    final String? text = representationByLanguage(messageDisplayLangCode)?.text;
    return text ?? body;
  }

  List<PangeaMatch>? errorSteps(String lemma) {
    final RepresentationEvent? repEvent = originalSent ?? originalWritten;
    if (repEvent?.choreo == null) return null;

    final List<PangeaMatch> steps = repEvent!.choreo!.choreoSteps
        .where(
          (choreoStep) =>
              choreoStep.acceptedOrIgnoredMatch != null &&
              choreoStep.acceptedOrIgnoredMatch?.match.shortMessage == lemma,
        )
        .map((element) => element.acceptedOrIgnoredMatch)
        .cast<PangeaMatch>()
        .toList();
    return steps;
  }

  /// Returns a list of all [PracticeActivityEvent] objects
  /// associated with this message event.
  List<PracticeActivityEvent> get _practiceActivityEvents {
    return _latestEdit
        .aggregatedEvents(
          timeline,
          PangeaEventTypes.pangeaActivity,
        )
        .map(
          (e) => PracticeActivityEvent(
            timeline: timeline,
            event: e,
          ),
        )
        .toList();
  }

  /// Returns a boolean value indicating whether there are any
  /// activities associated with this message event for the user's active l2
  bool get hasActivities {
    try {
      return practiceActivities.isNotEmpty;
    } catch (e, s) {
      ErrorHandler.logError(e: e, s: s);
      return false;
    }
  }

  /// Returns a list of [PracticeActivityEvent] objects for the given [langCode].
  List<PracticeActivityEvent> practiceActivitiesByLangCode(
    String langCode, {
    bool debug = false,
  }) {
    // @wcjord - disabled try catch for testing
    try {
      debugger(when: debug);
      final List<PracticeActivityEvent> activities = [];
      for (final event in _practiceActivityEvents) {
        if (event.practiceActivity.langCode == langCode) {
          activities.add(event);
        }
      }
      return activities;
    } catch (e, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s, data: event.toJson());
      return [];
    }
  }

  /// Returns a list of [PracticeActivityEvent] for the user's active l2.
  List<PracticeActivityEvent> get practiceActivities =>
      l2Code == null ? [] : practiceActivitiesByLangCode(l2Code!);

  /// all construct uses for the message, including vocab and grammar
  List<OneConstructUse> get allConstructUses => [
        ..._grammarConstructUses,
        ..._vocabUses,
      ];

  /// get construct uses of type vocab for the message
  List<OneConstructUse> get _vocabUses {
    if (originalSent?.tokens != null) {
      return originalSent!.content.vocabUses(
        event: event,
        choreo: originalSent!.choreo,
        tokens: originalSent!.tokens!,
      );
    }
    return [];
  }

  /// get construct uses of type grammar for the message
  List<OneConstructUse> get _grammarConstructUses =>
      originalSent?.choreo?.grammarConstructUses(event: event) ?? [];
}

class URLFinder {
  static Iterable<Match> getMatches(String text) {
    final RegExp exp =
        RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    return exp.allMatches(text);
  }
}
