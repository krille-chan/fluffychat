import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_content.dart';
import 'package:fluffychat/pages/chat/events/reply_content.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/toolbar/enums/reading_assistance_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_speech_to_text_card.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/file_description.dart';
import 'package:fluffychat/widgets/matrix.dart';

// @ggurdin be great to explain the need/function of a widget like this
class OverlayMessage extends StatelessWidget {
  final Event event;
  final PangeaMessageEvent? pangeaMessageEvent;
  final MessageOverlayController overlayController;
  final ChatController controller;
  final Event? nextEvent;
  final Event? previousEvent;
  final Timeline timeline;
  final bool immersionMode;

  final Animation<Size>? sizeAnimation;
  final double? messageWidth;
  final double? messageHeight;
  final double maxHeight;

  final bool isTransitionAnimation;
  final ReadingAssistanceMode? readingAssistanceMode;

  const OverlayMessage(
    this.event, {
    this.immersionMode = false,
    required this.overlayController,
    required this.controller,
    required this.timeline,
    required this.messageWidth,
    required this.messageHeight,
    required this.maxHeight,
    this.pangeaMessageEvent,
    this.nextEvent,
    this.previousEvent,
    this.sizeAnimation,
    this.isTransitionAnimation = false,
    this.readingAssistanceMode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool ownMessage = event.senderId == Matrix.of(context).client.userID;

    final displayTime = event.type == EventTypes.RoomCreate ||
        nextEvent == null ||
        !event.originServerTs.sameEnvironment(nextEvent!.originServerTs);

    final nextEventSameSender = nextEvent != null &&
        {
          EventTypes.Message,
          EventTypes.Sticker,
          EventTypes.Encrypted,
        }.contains(nextEvent!.type) &&
        nextEvent!.senderId == event.senderId &&
        !displayTime;

    final previousEventSameSender = previousEvent != null &&
        {
          EventTypes.Message,
          EventTypes.Sticker,
          EventTypes.Encrypted,
        }.contains(previousEvent!.type) &&
        previousEvent!.senderId == event.senderId &&
        previousEvent!.originServerTs.sameEnvironment(event.originServerTs);

    final textColor = event.isActivityMessage
        ? ThemeData.light().colorScheme.onPrimary
        : ownMessage
            ? ThemeData.dark().colorScheme.onPrimary
            : theme.colorScheme.onSurface;

    final linkColor = theme.brightness == Brightness.light
        ? theme.colorScheme.primary
        : ownMessage
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface;

    final displayEvent = event.getDisplayEvent(timeline);
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

    final noBubble = ({
              MessageTypes.Video,
              MessageTypes.Image,
              MessageTypes.Sticker,
            }.contains(event.messageType) &&
            event.fileDescription == null &&
            !event.redacted) ||
        (event.messageType == MessageTypes.Text &&
            event.relationshipType == null &&
            event.onlyEmotes &&
            event.numberEmotes > 0 &&
            event.numberEmotes <= 3);

    final showTranslation = overlayController.showTranslation &&
        overlayController.translationText != null;

    final showTranscription = pangeaMessageEvent?.isAudioMessage == true;

    final content = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppConfig.borderRadius,
        ),
      ),
      width: messageWidth,
      height: messageHeight,
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
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
                      left: 16,
                      right: 16,
                      top: 8,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: ReplyContent.borderRadius,
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
                    ),
                  );
                },
              ),
            MessageContent(
              displayEvent,
              textColor: textColor,
              linkColor: linkColor,
              borderRadius: borderRadius,
              timeline: timeline,
              pangeaMessageEvent: pangeaMessageEvent,
              immersionMode: immersionMode,
              overlayController: overlayController,
              controller: controller,
              nextEvent: nextEvent,
              prevEvent: previousEvent,
              isTransitionAnimation: isTransitionAnimation,
              readingAssistanceMode: readingAssistanceMode,
            ),
            if (event.hasAggregatedEvents(
              timeline,
              RelationshipTypes.edit,
            ))
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.0,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: textColor.withAlpha(164),
                      size: 14,
                    ),
                    Text(
                      displayEvent.originServerTs.localizedTimeShort(
                        context,
                      ),
                      style: TextStyle(
                        color: textColor.withAlpha(
                          164,
                        ),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    return Material(
      type: MaterialType.transparency,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: noBubble ? Colors.transparent : color,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizeAnimation != null
                ? AnimatedBuilder(
                    animation: sizeAnimation!,
                    builder: (context, child) {
                      return SizedBox(
                        height: sizeAnimation!.value.height,
                        width: sizeAnimation!.value.width,
                        child: content,
                      );
                    },
                  )
                : content,
            if (showTranscription || showTranslation)
              Container(
                width: messageWidth,
                constraints: const BoxConstraints(
                  maxHeight: AppConfig.audioTranscriptionMaxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    12.0,
                    20.0,
                    12.0,
                    12.0,
                  ),
                  child: SingleChildScrollView(
                    child: showTranscription
                        ? MessageSpeechToTextCard(
                            messageEvent: pangeaMessageEvent!,
                            textColor: textColor,
                          )
                        : Text(
                            overlayController.translationText!,
                            style: AppConfig.messageTextStyle(
                              event,
                              textColor,
                            ).copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
