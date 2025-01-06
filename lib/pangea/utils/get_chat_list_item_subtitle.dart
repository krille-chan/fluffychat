import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/widgets/chat/message_token_text.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../../utils/matrix_sdk_extensions/matrix_locals.dart';

class ChatListItemSubtitle extends StatelessWidget {
  final Event? event;
  final TextStyle style;

  const ChatListItemSubtitle({
    super.key,
    required this.event,
    required this.style,
  });

  bool _showPangeaContent(Event event) {
    return MatrixState.pangeaController.languageController.languagesSet &&
        !event.redacted &&
        event.type == EventTypes.Message &&
        event.messageType == MessageTypes.Text;
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
    if (event == null) return Text(L10n.of(context).emptyChat, style: style);
    if (!_showPangeaContent(event!)) {
      return FutureBuilder(
        future: event!.calcLocalizedBody(
          MatrixLocals(L10n.of(context)),
          hideReply: true,
          hideEdit: true,
          plaintextBody: true,
          removeMarkdown: true,
          withSenderNamePrefix: !event!.room.isDirectChat ||
              event!.room.directChatMatrixID != event!.room.lastEvent?.senderId,
        ),
        builder: (context, snapshot) {
          return Text(
            snapshot.hasData && snapshot.data != null
                ? snapshot.data!
                : L10n.of(context).emptyChat,
            style: style,
          );
        },
      );
    }

    return FutureBuilder(
      future: _getPangeaMessageEvent(event!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messageEventAndTokens = snapshot.data as MessageEventAndTokens;
          final pangeaMessageEvent = messageEventAndTokens.event;
          final tokens = messageEventAndTokens.tokens;

          final analyticsEntry = tokens != null
              ? MatrixState.pangeaController.getAnalytics.perMessage.get(
                  tokens,
                  pangeaMessageEvent,
                )
              : null;

          return MessageTextWidget(
            pangeaMessageEvent: pangeaMessageEvent,
            style: style,
            messageAnalyticsEntry: analyticsEntry,
            isSelected: null,
            onClick: null,
          );
        }

        return Text(
          L10n.of(context).emptyChat,
          style: style,
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
