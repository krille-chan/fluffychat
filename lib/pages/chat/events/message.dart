import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../config/app_config.dart';
import 'message_content.dart';
import 'message_reactions.dart';
import 'reply_content.dart';
import 'state_message.dart';
import 'verification_request_content.dart';

class Message extends StatelessWidget {
  final Event event;
  final Event nextEvent;
  final void Function(Event) onSelect;
  final void Function(Event) onAvatarTab;
  final void Function(Event) onInfoTab;
  final void Function(String) scrollToEventId;
  final void Function(String) unfold;
  final bool longPressSelect;
  final bool selected;
  final Timeline timeline;

  const Message(this.event,
      {this.nextEvent,
      this.longPressSelect,
      this.onSelect,
      this.onInfoTab,
      this.onAvatarTab,
      this.scrollToEventId,
      @required this.unfold,
      this.selected,
      this.timeline,
      Key key})
      : super(key: key);

  /// Indicates wheither the user may use a mouse instead
  /// of touchscreen.
  static bool useMouse = false;

  @override
  Widget build(BuildContext context) {
    if (![EventTypes.Message, EventTypes.Sticker, EventTypes.Encrypted]
        .contains(event.type)) {
      return StateMessage(event, unfold: unfold);
    }

    if (event.type == EventTypes.Message &&
        event.messageType == EventTypes.KeyVerificationRequest) {
      return VerificationRequestContent(event: event, timeline: timeline);
    }

    final client = Matrix.of(context).client;
    final ownMessage = event.senderId == client.userID;
    final alignment = ownMessage ? Alignment.topRight : Alignment.topLeft;
    var color = Theme.of(context).appBarTheme.backgroundColor;
    final displayTime = event.type == EventTypes.RoomCreate ||
        nextEvent == null ||
        !event.originServerTs.sameEnvironment(nextEvent.originServerTs);
    final sameSender = nextEvent != null &&
            [
              EventTypes.Message,
              EventTypes.Sticker,
              EventTypes.Encrypted,
            ].contains(nextEvent.type)
        ? nextEvent.sender.id == event.sender.id && !displayTime
        : false;
    final textColor = ownMessage
        ? Colors.white
        : Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    final rowMainAxisAlignment =
        ownMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

    final displayEvent = event.getDisplayEvent(timeline);
    final borderRadius = BorderRadius.only(
      topLeft: !ownMessage
          ? const Radius.circular(2)
          : const Radius.circular(AppConfig.borderRadius),
      topRight: ownMessage
          ? const Radius.circular(2)
          : const Radius.circular(AppConfig.borderRadius),
      bottomLeft: const Radius.circular(AppConfig.borderRadius),
      bottomRight: const Radius.circular(AppConfig.borderRadius),
    );
    final noBubble = {
      MessageTypes.Video,
      MessageTypes.Image,
      MessageTypes.Sticker,
    }.contains(event.messageType);

    if (ownMessage) {
      color = displayEvent.status.isError
          ? Colors.redAccent
          : Theme.of(context).primaryColor;
    }

    final rowChildren = <Widget>[
      sameSender || ownMessage
          ? SizedBox(
              width: Avatar.defaultSize,
              height: Avatar.defaultSize,
              child: event.status == EventStatus.sending
                  ? const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child:
                            CircularProgressIndicator.adaptive(strokeWidth: 2),
                      ),
                    )
                  : null,
            )
          : Avatar(
              mxContent: event.sender.avatarUrl,
              name: event.sender.calcDisplayname(),
              onTap: () => onAvatarTab(event),
            ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!ownMessage && !sameSender)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                child: event.room.isDirectChat
                    ? const SizedBox(height: 12)
                    : Text(
                        event.sender.calcDisplayname(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: event.sender.calcDisplayname().color,
                        ),
                      ),
              ),
            Container(
              alignment: alignment,
              padding: const EdgeInsets.only(left: 8),
              child: Material(
                color: noBubble ? Colors.transparent : color,
                elevation: event.type == EventTypes.Sticker ? 0 : 6,
                shadowColor:
                    Theme.of(context).secondaryHeaderColor.withAlpha(100),
                borderRadius: borderRadius,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onHover: (b) => useMouse = true,
                  onTap: !useMouse && longPressSelect
                      ? () => null
                      : () => onSelect(event),
                  onLongPress: !longPressSelect ? null : () => onSelect(event),
                  borderRadius: borderRadius,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                    ),
                    padding:
                        noBubble ? EdgeInsets.zero : const EdgeInsets.all(16),
                    constraints: const BoxConstraints(
                        maxWidth: FluffyThemes.columnWidth * 1.5),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (event.relationshipType ==
                                RelationshipTypes.reply)
                              FutureBuilder<Event>(
                                future: event.getReplyEvent(timeline),
                                builder: (BuildContext context, snapshot) {
                                  final replyEvent = snapshot.hasData
                                      ? snapshot.data
                                      : Event(
                                          eventId: event.relationshipEventId,
                                          content: {
                                            'msgtype': 'm.text',
                                            'body': '...'
                                          },
                                          senderId: event.senderId,
                                          type: 'm.room.message',
                                          room: event.room,
                                          status: EventStatus.sent,
                                          originServerTs: DateTime.now(),
                                        );
                                  return InkWell(
                                    onTap: () {
                                      if (scrollToEventId != null) {
                                        scrollToEventId(replyEvent.eventId);
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: ReplyContent(replyEvent,
                                            lightText: ownMessage,
                                            timeline: timeline),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            MessageContent(
                              displayEvent,
                              textColor: textColor,
                              onInfoTab: onInfoTab,
                            ),
                            if (event.hasAggregatedEvents(
                                timeline, RelationshipTypes.edit))
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      color: textColor.withAlpha(164),
                                      size: 14,
                                    ),
                                    Text(
                                      ' - ${displayEvent.originServerTs.localizedTimeShort(context)}',
                                      style: TextStyle(
                                        color: textColor.withAlpha(164),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: rowMainAxisAlignment,
      children: rowChildren,
    );
    Widget container;
    if (event.hasAggregatedEvents(timeline, RelationshipTypes.reaction) ||
        displayTime) {
      container = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            ownMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          if (displayTime)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                  child: Material(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(AppConfig.borderRadius / 2),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Text(
                    event.originServerTs.localizedTime(context),
                    style: TextStyle(fontSize: 14 * AppConfig.fontSizeFactor),
                  ),
                ),
              )),
            ),
          row,
          Padding(
            padding: EdgeInsets.only(
              top: 4.0,
              left: (ownMessage ? 0 : Avatar.defaultSize) + 12.0,
              right: 12.0,
            ),
            child: MessageReactions(event, timeline),
          ),
        ],
      );
    } else {
      container = row;
    }

    return Center(
      child: Container(
        color: selected
            ? Theme.of(context).primaryColor.withAlpha(100)
            : Theme.of(context).primaryColor.withAlpha(0),
        constraints:
            const BoxConstraints(maxWidth: FluffyThemes.columnWidth * 2.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          child: container,
        ),
      ),
    );
  }
}
