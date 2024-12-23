import 'package:collection/collection.dart';
import 'package:fluffychat/pangea/constants/language_constants.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/space_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../utils/matrix_sdk_extensions/matrix_locals.dart';

class GetChatListItemSubtitle {
  final List<String> hideContentKeys = [
    ModelKey.transcription,
  ];

  bool moveBackInTimeline(Event event) =>
      hideContentKeys.any(
        (key) => event.content.tryGet(key) != null,
      ) ||
      event.type.startsWith("p.") ||
      event.type.startsWith("pangea.") ||
      event.type == EventTypes.SpaceChild ||
      event.type == EventTypes.SpaceParent;

  Future<String> getSubtitle(
    L10n l10n,
    Event? event,
    PangeaController pangeaController,
  ) async {
    if (event == null) return l10n.emptyChat;
    try {
      String? eventContextId = event.eventId;
      if (!event.eventId.isValidMatrixId || event.eventId.sigil != '\$') {
        eventContextId = null;
      }

      final Timeline timeline = event.room.timeline != null &&
              event.room.timeline!.chunk.eventsMap.containsKey(eventContextId)
          ? event.room.timeline!
          : await event.room.getTimeline(eventContextId: eventContextId);

      if (moveBackInTimeline(event)) {
        event = timeline.events.firstWhereOrNull((e) => !moveBackInTimeline(e));
        if (event == null) {
          return l10n.emptyChat;
        }
      }

      if (!pangeaController.languageController.languagesSet ||
          event.redacted ||
          event.type != EventTypes.Message ||
          event.messageType != MessageTypes.Text ||
          !pangeaController.permissionsController
              .isToolEnabled(ToolSetting.immersionMode, event.room)) {
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

      final PangeaMessageEvent pangeaMessageEvent = PangeaMessageEvent(
        event: event,
        timeline: timeline,
        ownMessage: false,
      );
      final l2Code = pangeaController.languageController.activeL2Code();
      if (l2Code == null || l2Code == LanguageKeys.unknownLanguage) {
        return event.body;
      }

      final String? text =
          (await pangeaMessageEvent.representationByLanguageGlobal(
        langCode: l2Code,
      ))
              ?.text;

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
                    .firstWhereOrNull((u) => u.id != event!.room.client.userID)
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
          "event": event?.toJson(),
        },
      );
      return event?.body ?? l10n.emptyChat;
    }
  }
}
