import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import '../constants/pangea_event_types.dart';
import 'message_data_models.dart';

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
      ErrorHandler.logError(e: err, s: s);
      return null;
    }
  }

  PangeaMessageTokens? get tokens => _pangeaMessageTokens;
}
