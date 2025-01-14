import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/tokens_event_content_model.dart';
import '../constants/pangea_event_types.dart';

class TokensEvent {
  Event event;
  PangeaMessageTokens? _content;

  TokensEvent({required this.event}) {
    if (event.type != PangeaEventTypes.tokens) {
      throw Exception(
        "${event.type} should not be used to make a TokensEvent",
      );
    }
  }

  PangeaMessageTokens? get _pangeaMessageTokens {
    try {
      _content ??= event.getPangeaContent<PangeaMessageTokens>();
      return _content!;
    } catch (err, s) {
      debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          "event": event.toJson(),
        },
      );
      return null;
    }
  }

  PangeaMessageTokens? get tokens => _pangeaMessageTokens;
}
