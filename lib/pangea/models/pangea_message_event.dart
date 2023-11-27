// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

// Project imports:
import 'package:fluffychat/pangea/constants/pangea_message_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/models/choreo_record.dart';
import 'package:fluffychat/pangea/models/message_data_models.dart';
import 'package:fluffychat/pangea/models/pangea_representation_event.dart';
import 'package:fluffychat/pangea/utils/bot_name.dart';
import '../../widgets/matrix.dart';
import '../constants/language_keys.dart';
import '../constants/model_keys.dart';
import '../constants/pangea_event_types.dart';
import '../enum/use_type.dart';
import '../utils/error_handler.dart';

class PangeaMessageEvent {
  late Event _event;
  final Timeline timeline;
  final bool ownMessage;
  final bool selected;
  bool _isValidPangeaMessageEvent = true;

  PangeaMessageEvent({
    required Event event,
    required this.timeline,
    required this.ownMessage,
    required this.selected,
  }) {
    if (event.type != EventTypes.Message) {
      _isValidPangeaMessageEvent = false;
      ErrorHandler.logError(
        m: "${event.type} should not be used to make a PangeaMessageEvent",
      );
    }
    _event = event;
  }

  //the timeline filters the edits and uses the original events
  //so this event will always be the original and the sdk getter body
  //handles getting the latest text from the aggregated events
  String get body => _event.body;

  String get senderId => _event.senderId;

  DateTime get originServerTs => _event.originServerTs;

  String get eventId => _event.eventId;

  Room get room => _event.room;

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

  bool get showRichText {
    if (!_isValidPangeaMessageEvent) {
      return false;
    }
    // if (URLFinder.getMatches(event.body).isNotEmpty) {
    //   return false;
    // }
    if ([EventStatus.error, EventStatus.sending].contains(_event.status)) {
      return false;
    }
    if (ownMessage && !selected) return false;

    return true;
  }

  List<RepresentationEvent>? _representations;
  List<RepresentationEvent> get representations {
    if (_representations != null) return _representations!;

    _representations = [];

    if (_latestEdit.content[ModelKey.originalSent] != null) {
      try {
        _representations!.add(
          RepresentationEvent(
            content: PangeaRepresentation.fromJson(
              _latestEdit.content[ModelKey.originalSent]
                  as Map<String, dynamic>,
            ),
            tokens: _latestEdit.content[ModelKey.tokensSent] != null
                ? PangeaMessageTokens.fromJson(
                    _latestEdit.content[ModelKey.tokensSent]
                        as Map<String, dynamic>,
                  )
                : null,
            choreo: _latestEdit.content[ModelKey.choreoRecord] != null
                ? ChoreoRecord.fromJson(
                    _latestEdit.content[ModelKey.choreoRecord]
                        as Map<String, dynamic>,
                  )
                : null,
            timeline: timeline,
          ),
        );
      } catch (err, s) {
        ErrorHandler.logError(
          e: err,
          s: s,
        );
      }
    }

    if (_latestEdit.content[ModelKey.originalWritten] != null) {
      _representations!.add(
        RepresentationEvent(
          content: PangeaRepresentation.fromJson(
            _latestEdit.content[ModelKey.originalWritten]
                as Map<String, dynamic>,
          ),
          tokens: _latestEdit.content[ModelKey.tokensWritten] != null
              ? PangeaMessageTokens.fromJson(
                  _latestEdit.content[ModelKey.tokensWritten]
                      as Map<String, dynamic>,
                )
              : null,
          timeline: timeline,
        ),
      );
    }

    _representations!.addAll(
      _latestEdit
          .aggregatedEvents(
            timeline,
            PangeaEventTypes.representation,
          )
          .map(
            (e) => RepresentationEvent(event: e, timeline: timeline),
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

  bool get isNew =>
      DateTime.now().difference(originServerTs.toLocal()).inSeconds < 8;

  Future<RepresentationEvent?> _repLocal(String langCode) async {
    int tries = 0;

    RepresentationEvent? rep = representationByLanguage(langCode);

    while ((isNew || eventId.contains("web")) && tries < 20) {
      if (rep != null) return rep;
      await Future.delayed(const Duration(milliseconds: 500));
      rep = representationByLanguage(langCode);
      tries += 1;
    }
    return rep;
  }

  Future<RepresentationEvent?> representationByLanguageGlobal({
    required BuildContext context,
    required String langCode,
  }) async {
    // try {
    final RepresentationEvent? repLocal = await _repLocal(langCode);

    if (repLocal != null ||
        langCode == LanguageKeys.unknownLanguage ||
        langCode == LanguageKeys.mixedLanguage ||
        langCode == LanguageKeys.multiLanguage) return repLocal;

    if (eventId.contains("web")) return null;

    // should this just be the original event body?
    // worth a conversation with the team
    final PangeaRepresentation? basis =
        (originalWritten ?? originalSent)?.content;

    final Event? repEvent = await MatrixState.pangeaController.messageData
        .getRepresentationMatrixEvent(
      context: context,
      messageEventId: _latestEdit.eventId,
      text: basis?.text ?? _latestEdit.body,
      target: langCode,
      source: basis?.langCode,
      room: _latestEdit.room,
    );

    // PTODO - if res.source different from langCode, save rep for source

    return repEvent != null
        ? RepresentationEvent(
            event: repEvent,
            timeline: timeline,
          )
        : null;
    // } catch (err, s) {
    //   debugger(when: kDebugMode);
    //   ErrorHandler.logError(
    //     e: err,
    //     s: s,
    //   );
    //   return null;
    // }
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

  UseType get useType => useTypeCalculator(originalSent?.choreo);

  bool get showUseType =>
      !ownMessage &&
      _event.room.isSpaceAdmin &&
      _event.senderId != BotName.byEnvironment &&
      !room.isUserSpaceAdmin(_event.senderId) &&
      _event.messageType != PangeaMessageTypes.report;

  // List<SpanData> get activities =>
  //each match is turned into an activity that other students can access
  //they're not told the answer but have to find it themselves
  //the message has a blank piece which they fill in themselves
}

class URLFinder {
  static Iterable<Match> getMatches(String text) {
    final RegExp exp =
        RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    return exp.allMatches(text);
  }
}
