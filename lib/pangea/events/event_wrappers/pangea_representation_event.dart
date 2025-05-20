// ignore_for_file: implementation_imports

import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/src/utils/markdown.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/choreographer/event_wrappers/pangea_choreo_event.dart';
import 'package:fluffychat/pangea/choreographer/models/choreo_record.dart';
import 'package:fluffychat/pangea/choreographer/models/language_detection_model.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/events/models/representation_content_model.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/events/repo/token_api_models.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
import 'package:fluffychat/pangea/morphs/morph_features_enum.dart';
import 'package:fluffychat/pangea/morphs/parts_of_speech_enum.dart';
import 'package:fluffychat/pangea/practice_activities/activity_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class RepresentationEvent {
  Event? _event;
  PangeaRepresentation? _content;
  PangeaMessageTokens? _tokens;
  ChoreoRecord? _choreo;
  Timeline timeline;
  Event parentMessageEvent;

  RepresentationEvent({
    required this.timeline,
    required this.parentMessageEvent,
    Event? event,
    PangeaRepresentation? content,
    PangeaMessageTokens? tokens,
    ChoreoRecord? choreo,
  }) {
    if (event != null && event.type != PangeaEventTypes.representation) {
      throw Exception(
        "${event.type} should not be used to make a RepresentationEvent",
      );
    }
    _event = event;
    _content = content;
    _tokens = tokens;
    _choreo = choreo;
  }

  Event? get event => _event;

  // Note: in the case where the event is the originalSent or originalWritten event,
  // the content will be set on initialization by the PangeaMessageEvent
  // Otherwise, the content will be fetched from the event where it is stored in content[type]
  PangeaRepresentation get content {
    if (_content != null) return _content!;
    _content = _event?.getPangeaContent<PangeaRepresentation>();
    return _content!;
  }

  String get text => content.text;

  String get langCode => content.langCode;

  bool get botAuthored =>
      content.originalSent == false && content.originalWritten == false;

  List<LanguageDetection>? get detections => _tokens?.detections;

  List<PangeaToken>? get tokens {
    if (_tokens != null) return _tokens!.tokens;

    if (_event == null) {
      // debugger(when: kDebugMode);
      // ErrorHandler.logError(
      //   m: '_event and _tokens both null',
      //   s: StackTrace.current,
      // );
      return null;
    }

    final Set<Event> tokenEvents = _event?.aggregatedEvents(
          timeline,
          PangeaEventTypes.tokens,
        ) ??
        {};

    if (tokenEvents.isEmpty) return null;

    if (tokenEvents.length > 1) {
      debugger(when: kDebugMode);
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              'should not have more than one tokenEvent per representation ${_event?.eventId}',
          data: {
            "eventID": _event?.eventId,
            "content": tokenEvents.map((e) => e.content).toString(),
            "type": tokenEvents.map((e) => e.type).toString(),
          },
        ),
      );
    }

    PangeaMessageTokens? storedTokens;
    for (final tokenEvent in tokenEvents) {
      final tokenPangeaEvent =
          tokenEvent.getPangeaContent<PangeaMessageTokens>();
      if (PangeaToken.reconstructText(tokenPangeaEvent.tokens) != text) {
        Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'Stored tokens do not match text for representation',
            data: {
              'text': text,
              'tokens': tokenPangeaEvent.tokens,
            },
          ),
        );
        continue;
      }
      storedTokens = tokenPangeaEvent;
      break;
    }

    if (storedTokens == null) {
      ErrorHandler.logError(
        e: "No tokens found for representation",
        data: {
          "event": _event?.toJson(),
        },
      );
      return null;
    }

    _tokens = storedTokens;

    return _tokens?.tokens;
  }

  Future<List<PangeaToken>> tokensGlobal(
    String senderID,
    DateTime timestamp,
  ) async {
    if (tokens != null) return tokens!;

    if (_event == null && timestamp.isAfter(DateTime(2024, 9, 25))) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message:
              'representation with no _event and no tokens got tokens directly. This means an original_sent with no tokens. This should not happen in messages sent after September 25',
          data: {
            'content': content.toJson(),
            'event': _event?.toJson(),
            'timestamp': timestamp.toIso8601String(),
            'senderID': senderID,
          },
        ),
      );
    }
    final TokensResponseModel res =
        await MatrixState.pangeaController.messageData.getTokens(
      repEventId: _event?.eventId,
      room: _event?.room ?? parentMessageEvent.room,
      req: TokensRequestModel(
        fullText: text,
        langCode: langCode,
        senderL1:
            MatrixState.pangeaController.languageController.userL1?.langCode ??
                LanguageKeys.unknownLanguage,
        // since langCode is known, senderL2 will be used to determine whether these tokens
        // need pos/mporph tags whether lemmas are eligible to marked as "save_vocab=true"
        senderL2:
            MatrixState.pangeaController.languageController.userL2?.langCode ??
                LanguageKeys.unknownLanguage,
      ),
    );

    return res.tokens;
  }

  Future<void> sendTokensEvent(
    String repEventID,
    Room room,
    String userl1,
    String userl2,
  ) async {
    if (tokens != null) return;
    if (_event == null) {
      ErrorHandler.logError(
        e: "Called getTokensEvent with no _event",
        data: {},
      );
      return;
    }

    await MatrixState.pangeaController.messageData.sendTokensEvent(
      repEventId: repEventID,
      room: room,
      req: TokensRequestModel(
        fullText: text,
        langCode: langCode,
        senderL1: userl1,
        senderL2: userl2,
      ),
    );
  }

  ChoreoRecord? get choreo {
    if (_choreo != null) return _choreo;

    if (_event == null) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "_event and _choreo both null",
        ),
      );
      return null;
    }

    final Set<Event> choreoMatrixEvents =
        _event?.aggregatedEvents(timeline, PangeaEventTypes.choreoRecord) ?? {};

    if (choreoMatrixEvents.isEmpty) return null;

    if (choreoMatrixEvents.length > 1) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        m: 'should not have more than one choreoEvent per representation ${_event?.eventId}',
        s: StackTrace.current,
        data: {"event": _event?.toJson()},
      );
    }

    _choreo = ChoreoEvent(event: choreoMatrixEvents.first).content;

    return _choreo;
  }

  String? formatBody() {
    return markdown(content.text);
  }

  /// Finds the closest non-punctuation token to the given token.
  ///
  /// This method checks if the provided token is a punctuation token. If it is not,
  /// it returns the token itself. If the token is a punctuation token, it searches
  /// through the list of tokens to find the closest non-punctuation token either to
  /// the left or right of the given token.
  ///
  /// If both left and right non-punctuation tokens are found, it returns the one
  /// that is closest to the given token. If only one of them is found, it returns
  /// that token. If no non-punctuation tokens are found, it returns null.
  ///
  /// - Parameters:
  ///   - token: The token for which to find the closest non-punctuation token.
  ///
  /// - Returns: The closest non-punctuation token, or null if no such token exists.
  PangeaToken? getClosestNonPunctToken(PangeaToken token) {
    if (token.pos != "PUNCT") return token;
    if (tokens == null) return null;
    final index = tokens!.indexOf(token);
    if (index > -1) {
      final leftTokens = tokens!.sublist(0, index);
      final rightTokens = tokens!.sublist(index + 1);
      final leftMostToken = leftTokens.lastWhereOrNull(
        (element) => element.pos != "PUNCT",
      );
      final rightMostToken = rightTokens.firstWhereOrNull(
        (element) => element.pos != "PUNCT",
      );

      if (leftMostToken != null && rightMostToken != null) {
        final leftDistance = token.start - leftMostToken.end;
        final rightDistance = rightMostToken.start - token.end;
        return leftDistance < rightDistance ? leftMostToken : rightMostToken;
      } else if (leftMostToken != null) {
        return leftMostToken;
      } else if (rightMostToken != null) {
        return rightMostToken;
      }
    }
    return null;
  }

  List<PangeaToken> get tokensToSave =>
      tokens?.where((token) => token.lemma.saveVocab).toList() ?? [];

  // List<ConstructIdentifier> get allTokenMorphsToConstructIdentifiers => tokens?.map((t) => t.morphConstructIds).toList() ??
  //     [];

  /// get allTokenMorphsToConstructIdentifiers
  Set<MorphFeaturesEnum> get morphFeatureSetToPractice =>
      MorphFeaturesEnum.values.where((feature) {
        // pos is always included
        if (feature == MorphFeaturesEnum.Pos) {
          return true;
        }
        return tokens?.any((token) => token.morph.containsKey(feature)) ??
            false;
      }).toSet();

  Set<PartOfSpeechEnum> posSetToPractice(ActivityTypeEnum a) =>
      PartOfSpeechEnum.values.where((pos) {
        // some pos are not eligible for practice at all
        if (!pos.eligibleForPractice(a)) {
          return false;
        }
        return tokens?.any(
              (token) => token.pos.toLowerCase() == pos.name.toLowerCase(),
            ) ??
            false;
      }).toSet();

  List<String> tagsByFeature(MorphFeaturesEnum feature) {
    return tokens
            ?.where((t) => t.morph.containsKey(feature))
            .map((t) => t.morph[feature])
            .cast<String>()
            .toList() ??
        [];
  }
}
