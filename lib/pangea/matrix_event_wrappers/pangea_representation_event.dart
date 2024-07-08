import 'dart:developer';

import 'package:fluffychat/pangea/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_choreo_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/tokens_event_content_model.dart';
import 'package:fluffychat/pangea/repo/tokens_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/src/utils/markdown.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../widgets/matrix.dart';
import '../constants/language_constants.dart';
import '../constants/pangea_event_types.dart';
import '../models/choreo_record.dart';
import '../models/representation_content_model.dart';
import '../utils/error_handler.dart';
import 'pangea_tokens_event.dart';

class RepresentationEvent {
  Event? _event;
  PangeaRepresentation? _content;
  PangeaMessageTokens? _tokens;
  ChoreoRecord? _choreo;
  Timeline timeline;

  RepresentationEvent({
    required this.timeline,
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
          message: "Token events for representation ${_event?.eventId}: "
              "Content: ${tokenEvents.map((e) => e.content).toString()}"
              "Type: ${tokenEvents.map((e) => e.type).toString()}",
        ),
      );
      ErrorHandler.logError(
        m: 'should not have more than one tokenEvent per representation ${_event?.eventId}',
        s: StackTrace.current,
      );
    }

    _tokens = tokenEvents.first.getPangeaContent<PangeaMessageTokens>();

    return _tokens?.tokens;
  }

  Future<List<PangeaToken>?> tokensGlobal(BuildContext context) async {
    if (tokens != null) return tokens!;

    if (_event == null) {
      // debugger(when: kDebugMode);
      // ErrorHandler.logError(
      //   m: '_event and _tokens both null',
      //   s: StackTrace.current,
      // );
      return null;
    }

    final Event? tokensEvent =
        await MatrixState.pangeaController.messageData.getTokenEvent(
      context: context,
      repEventId: _event!.eventId,
      room: _event!.room,
      // Jordan - for just tokens, it's not clear which languages to pass
      req: TokensRequestModel(
        fullText: text,
        userL1:
            MatrixState.pangeaController.languageController.userL1?.langCode ??
                LanguageKeys.unknownLanguage,
        userL2: langCode,
      ),
    );

    if (tokensEvent == null) return null;

    _tokens = TokensEvent(event: tokensEvent).tokens;

    return _tokens?.tokens;
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
        data: _event?.toJson(),
      );
    }

    _choreo = ChoreoEvent(event: choreoMatrixEvents.first).content;

    return _choreo;
  }

  String? formatBody() {
    return markdown(content.text);
  }
}
