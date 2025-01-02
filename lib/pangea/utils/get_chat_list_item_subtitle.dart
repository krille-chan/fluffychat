import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../utils/matrix_sdk_extensions/matrix_locals.dart';

class GetChatListItemSubtitle {
  final List<String> hideContentKeys = [
    ModelKey.transcription,
  ];

  String _constructTokens(
    List<PangeaToken> tokens,
    List<PangeaToken> hiddenTokens,
  ) {
    String result = "";
    int currentPosition = 0;
    for (final token in tokens) {
      if (token.text.offset > currentPosition) {
        result += " " * (token.text.offset - currentPosition);
        currentPosition = token.text.offset;
      }

      if (hiddenTokens.contains(token)) {
        result += "_" * token.text.length;
      } else {
        result += token.text.content;
      }
      currentPosition += token.text.length;
    }
    return result;
  }

  Future<String> getSubtitle(
    L10n l10n,
    Event? event,
    PangeaController pangeaController,
  ) async {
    if (event == null) return l10n.emptyChat;
    try {
      if (!pangeaController.languageController.languagesSet ||
          event.redacted ||
          event.type != EventTypes.Message ||
          event.messageType != MessageTypes.Text) {
        return event.calcLocalizedBody(
          MatrixLocals(l10n),
          hideReply: true,
          hideEdit: true,
          plaintextBody: true,
          removeMarkdown: true,
          withSenderNamePrefix: !event.room.isDirectChat ||
              event.room.directChatMatrixID != event.room.lastEvent?.senderId,
        );
      }

      String? eventContextId = event.eventId;
      if (!event.eventId.isValidMatrixId || event.eventId.sigil != '\$') {
        eventContextId = null;
      }

      final Timeline timeline = event.room.timeline != null &&
              event.room.timeline!.chunk.eventsMap.containsKey(eventContextId)
          ? event.room.timeline!
          : await event.room.getTimeline(eventContextId: eventContextId);

      final PangeaMessageEvent pangeaMessageEvent = PangeaMessageEvent(
        event: event,
        timeline: timeline,
        ownMessage: event.senderId == event.room.client.userID,
      );

      final l2Code = pangeaController.languageController.activeL2Code();
      if (l2Code == null || l2Code == LanguageKeys.unknownLanguage) {
        return event.body;
      }

      final String? text =
          pangeaMessageEvent.messageDisplayRepresentation?.text;

      final tokens =
          await pangeaMessageEvent.messageDisplayRepresentation?.tokensGlobal(
        event.senderId,
        event.originServerTs,
      );

      if (tokens != null) {
        final analyticsEntry = pangeaController.getAnalytics.perMessage.get(
          tokens,
          pangeaMessageEvent,
        );

        if (analyticsEntry?.nextActivity?.activityType ==
            ActivityTypeEnum.hiddenWordListening) {
          try {
            return _constructTokens(
              tokens,
              analyticsEntry!.nextActivity!.tokens,
            );
          } catch (err, s) {
            ErrorHandler.logError(
              e: err,
              s: s,
              data: {
                "tokens": tokens,
                "analyticsEntry": analyticsEntry,
              },
            );
          }
        }
      }

      final i18n = MatrixLocals(l10n);

      if (text == null || event.room.lastEvent == null) {
        return l10n.emptyChat;
      }

      if (!event.room.isDirectChat ||
          event.room.directChatMatrixID != event.room.lastEvent!.senderId) {
        final senderNameOrYou = event.senderId == event.room.client.userID
            ? i18n.you
            : event.room
                    .getParticipants()
                    .firstWhereOrNull((u) => u.id != event.room.client.userID)
                    ?.calcDisplayname(i18n: i18n) ??
                event.room.lastEvent!.senderId;

        return "$senderNameOrYou: $text";
      }

      return text;
    } catch (e, s) {
      // debugger(when: kDebugMode);
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "event": event.toJson(),
        },
      );
      return event.body;
    }
  }
}
