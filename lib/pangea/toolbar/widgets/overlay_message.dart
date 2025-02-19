import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_content.dart';
import 'package:fluffychat/pages/chat/events/reply_content.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/widgets/matrix.dart';

// @ggurdin be great to explain the need/function of a widget like this
class OverlayMessage extends StatelessWidget {
  final Event event;
  final PangeaMessageEvent? pangeaMessageEvent;
  final MessageOverlayController overlayController;
  final ChatController controller;
  final Event? nextEvent;
  final Event? prevEvent;
  final Timeline timeline;
  final bool immersionMode;
  final double messageWidth;
  final double messageHeight;

  const OverlayMessage(
    this.event, {
    this.immersionMode = false,
    required this.overlayController,
    required this.controller,
    required this.timeline,
    required this.messageWidth,
    required this.messageHeight,
    this.pangeaMessageEvent,
    this.nextEvent,
    this.prevEvent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool ownMessage = event.senderId == Matrix.of(context).client.userID;

    final displayTime = event.type == EventTypes.RoomCreate ||
        nextEvent == null ||
        event.originServerTs.sameEnvironment(nextEvent!.originServerTs);

    final nextEventSameSender = nextEvent != null &&
        {
          EventTypes.Message,
          EventTypes.Sticker,
          EventTypes.Encrypted,
        }.contains(nextEvent!.type) &&
        nextEvent!.senderId == event.senderId &&
        !displayTime;

    final previousEventSameSender = prevEvent != null &&
        {
          EventTypes.Message,
          EventTypes.Sticker,
          EventTypes.Encrypted,
        }.contains(prevEvent!.type) &&
        prevEvent!.senderId == event.senderId &&
        prevEvent!.originServerTs.sameEnvironment(event.originServerTs);

    const hardCorner = Radius.circular(4);
    const roundedCorner = Radius.circular(AppConfig.borderRadius);
    final borderRadius = BorderRadius.only(
      topLeft: !ownMessage && nextEventSameSender ? hardCorner : roundedCorner,
      topRight: ownMessage && nextEventSameSender ? hardCorner : roundedCorner,
      bottomLeft:
          !ownMessage && previousEventSameSender ? hardCorner : roundedCorner,
      bottomRight:
          ownMessage && previousEventSameSender ? hardCorner : roundedCorner,
    );

    final displayEvent = event.getDisplayEvent(timeline);
    // ignore: deprecated_member_use
    var color = theme.colorScheme.surfaceContainerHigh;
    if (ownMessage) {
      color = displayEvent.status.isError
          ? Colors.redAccent
          : Color.alphaBlend(
              Colors.white.withAlpha(180),
              ThemeData.dark().colorScheme.primary,
            );
    }

    if (event.isActivityMessage) {
      color = theme.brightness == Brightness.dark
          ? theme.colorScheme.onSecondary
          : theme.colorScheme.primary;
    }

    final noBubble = {
          MessageTypes.Video,
          MessageTypes.Image,
          MessageTypes.Sticker,
        }.contains(event.messageType) &&
        !event.redacted;
    final noPadding = {
      MessageTypes.File,
      MessageTypes.Audio,
    }.contains(event.messageType);

    final textColor = event.isActivityMessage
        ? ThemeData.light().colorScheme.onPrimary
        : ownMessage
            ? ThemeData.dark().colorScheme.onPrimary
            : theme.colorScheme.onSurface;

    return Material(
      color: color,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppConfig.borderRadius,
            ),
          ),
          padding: noBubble || noPadding
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
          width: messageWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (event.relationshipType == RelationshipTypes.reply)
                FutureBuilder<Event?>(
                  future: event.getReplyEvent(
                    timeline,
                  ),
                  builder: (
                    BuildContext context,
                    snapshot,
                  ) {
                    final replyEvent = snapshot.hasData
                        ? snapshot.data!
                        : Event(
                            eventId: event.relationshipEventId!,
                            content: {
                              'msgtype': 'm.text',
                              'body': '...',
                            },
                            senderId: event.senderId,
                            type: 'm.room.message',
                            room: event.room,
                            status: EventStatus.sent,
                            originServerTs: DateTime.now(),
                          );
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 4.0,
                      ),
                      child: InkWell(
                        borderRadius: ReplyContent.borderRadius,
                        onTap: () => controller.scrollToEventId(
                          replyEvent.eventId,
                        ),
                        child: AbsorbPointer(
                          child: ReplyContent(
                            replyEvent,
                            ownMessage: ownMessage,
                            timeline: timeline,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              MessageContent(
                event.getDisplayEvent(timeline),
                textColor: textColor,
                pangeaMessageEvent: pangeaMessageEvent,
                immersionMode: immersionMode,
                overlayController: overlayController,
                controller: controller,
                nextEvent: nextEvent,
                prevEvent: prevEvent,
                borderRadius: borderRadius,
                timeline: timeline,
                linkColor: theme.brightness == Brightness.light
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onPrimary,
              ),
              if (event.hasAggregatedEvents(
                timeline,
                RelationshipTypes.edit,
              ))
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (event.hasAggregatedEvents(
                        timeline,
                        RelationshipTypes.edit,
                      )) ...[
                        Icon(
                          Icons.edit_outlined,
                          color: textColor.withAlpha(164),
                          size: 14,
                        ),
                        Text(
                          ' - ${displayEvent.originServerTs.localizedTimeShort(context)}',
                          style: TextStyle(
                            color: textColor.withAlpha(
                              164,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
