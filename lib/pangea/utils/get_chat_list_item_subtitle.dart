import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/constants/language_keys.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/models/class_model.dart';
import 'package:fluffychat/pangea/models/pangea_message_event.dart';
import '../../utils/matrix_sdk_extensions/matrix_locals.dart';

class GetChatListItemSubtitle {
  Future<String> getSubtitle(
    BuildContext context,
    Event? event,
    PangeaController pangeaController,
  ) async {
    if (event == null) return L10n.of(context)!.emptyChat;
    // try {
    if (event.type != EventTypes.Message)
    //  ||
    //     !pangeaController.permissionsController
    //         .isToolEnabled(ToolSetting.immersionMode, event.room))
    {
      return event.calcLocalizedBody(
        MatrixLocals(L10n.of(context)!),
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
    final Timeline timeline =
        await event.room.getTimeline(eventContextId: eventContextId);

    final PangeaMessageEvent pangeaMessageEvent = PangeaMessageEvent(
      event: event,
      timeline: timeline,
      ownMessage: false,
    );
    final l2Code =
        pangeaController.languageController.activeL2Code(roomID: event.roomId);

    if (l2Code == null || l2Code == LanguageKeys.unknownLanguage) {
      return event.body;
    }

    final String? text =
        (await pangeaMessageEvent.representationByLanguageGlobal(
      context: context,
      langCode: l2Code,
    ))
            ?.text;

    final i18n = MatrixLocals(L10n.of(context)!);

    if (text == null) return L10n.of(context)!.emptyChat;

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
    // } catch (e, s) {
    //   debugger(when: kDebugMode);
    //   ErrorHandler.logError(e: e, s: s);
    //   return event.body;
    // }
  }
}
