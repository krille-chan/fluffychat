import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/constants/model_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../utils/matrix_sdk_extensions/matrix_locals.dart';

class GetChatListItemSubtitle {
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

      final Timeline timeline =
          await event.room.getTimeline(eventContextId: eventContextId);

      if (event.content.tryGet(ModelKey.transcription) != null) {
        int index = timeline.events.indexWhere(
          (e) => e.eventId == event!.eventId,
        );

        while (index < timeline.events.length &&
            (timeline.events[index].content.tryGet(ModelKey.transcription) !=
                    null ||
                timeline.events[index].type != EventTypes.Message)) {
          index++;
        }

        if (timeline.events.length > index + 1) {
          event = timeline.events[index];
        }
      }

      if (event.type != EventTypes.Message ||
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
      final l2Code = pangeaController.languageController
          .activeL2Code(roomID: event.roomId);

      if (l2Code == null || l2Code == LanguageKeys.unknownLanguage) {
        return event.body;
      }

      final String? text =
          (await pangeaMessageEvent.representationByLanguageGlobal(
        langCode: l2Code,
      ))
              ?.text;

      final i18n = MatrixLocals(l10n);

      if (text == null) return l10n.emptyChat;

      if (!event.room.isDirectChat ||
          event.room.directChatMatrixID != event.room.lastEvent?.senderId) {
        final senderNameOrYou = event.senderId == event.room.client.userID
            ? i18n.you
            : event.room
                .unsafeGetUserFromMemoryOrFallback(event.senderId)
                .calcDisplayname(i18n: i18n);

        return "$senderNameOrYou: $text";
      }

      return text;
    } catch (e, s) {
      // debugger(when: kDebugMode);
      ErrorHandler.logError(e: e, s: s);
      return event?.body ?? l10n.emptyChat;
    }
  }
}
