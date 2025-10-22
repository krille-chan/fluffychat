import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/course_chats/open_roles_indicator.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../utils/matrix_sdk_extensions/matrix_locals.dart';

class ChatListItemSubtitle extends StatelessWidget {
  final Room room;
  final TextStyle style;

  const ChatListItemSubtitle({
    super.key,
    required this.room,
    required this.style,
  });

  bool _showPangeaContent(Event event) {
    return MatrixState.pangeaController.languageController.languagesSet &&
        !event.redacted &&
        event.type == EventTypes.Message &&
        event.messageType == MessageTypes.Text &&
        !(AppConfig.renderHtml && !event.redacted && event.isRichMessage);
  }

  Future<MessageEventAndTokens> _getPangeaMessageEvent(
    final Event event,
  ) async {
    final Timeline timeline = event.room.timeline != null
        ? event.room.timeline!
        : await event.room.getTimeline();

    final pangeaMessageEvent = PangeaMessageEvent(
      event: event,
      timeline: timeline,
      ownMessage: event.senderId == event.room.client.userID,
    );

    final tokens =
        await pangeaMessageEvent.messageDisplayRepresentation?.tokensGlobal(
      event.senderId,
      event.originServerTs,
    );

    return MessageEventAndTokens(
      event: pangeaMessageEvent,
      tokens: tokens,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (room.showActivityChatUI) {
      if (room.hasArchivedActivity) {
        return Text(
          room.activityPlan!.learningObjective,
          style: style,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      } else if (!room.isActivityStarted) {
        return OpenRolesIndicator(
          totalSlots: room.activityPlan!.req.numberOfParticipants,
          userIds:
              room.assignedRoles?.values.map((r) => r.userId).toList() ?? [],
          room: room,
          space: room.courseParent,
        );
      } else if (room.isActivityFinished) {
        return Text(
          L10n.of(context).activityDone,
          style: style,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      }
    }

    final event = room.lastEvent;
    if (event == null) return Text(L10n.of(context).emptyChat, style: style);
    if (!_showPangeaContent(event)) {
      return FutureBuilder(
        future: event.calcLocalizedBody(
          MatrixLocals(L10n.of(context)),
          hideReply: true,
          hideEdit: true,
          plaintextBody: true,
          removeMarkdown: true,
          withSenderNamePrefix: !event.room.isDirectChat ||
              event.room.directChatMatrixID != event.room.lastEvent?.senderId,
        ),
        builder: (context, snapshot) {
          return Text(
            snapshot.hasData && snapshot.data != null
                ? snapshot.data!
                : L10n.of(context).emptyChat,
            style: style,
            softWrap: false,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
        },
      );
    }

    return FutureBuilder(
      future: _getPangeaMessageEvent(event),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messageEventAndTokens = snapshot.data as MessageEventAndTokens;
          final pangeaMessageEvent = messageEventAndTokens.event;
          return Text(
            pangeaMessageEvent.messageDisplayText,
            style: style,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          );
        }

        return Text(
          L10n.of(context).emptyChat,
          style: style,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}

class MessageEventAndTokens {
  final PangeaMessageEvent event;
  final List<PangeaToken>? tokens;

  MessageEventAndTokens({
    required this.event,
    required this.tokens,
  });
}
