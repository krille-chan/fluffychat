import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/message_content.dart';
import 'package:fluffychat/views/widgets/reply_content.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../avatar.dart';
import '../matrix.dart';
import '../message_reactions.dart';
import 'state_message.dart';

class Message extends StatelessWidget {
  final Event event;
  final Event nextEvent;
  final void Function(Event) onSelect;
  final void Function(Event) onAvatarTab;
  final void Function(String) scrollToEventId;
  final void Function(String) unfold;
  final bool longPressSelect;
  final bool selected;
  final Timeline timeline;

  const Message(this.event,
      {this.nextEvent,
      this.longPressSelect,
      this.onSelect,
      this.onAvatarTab,
      this.scrollToEventId,
      @required this.unfold,
      this.selected,
      this.timeline});

  /// Indicates wheither the user may use a mouse instead
  /// of touchscreen.
  static bool useMouse = false;

  @override
  Widget build(BuildContext context) {
    if (![EventTypes.Message, EventTypes.Sticker, EventTypes.Encrypted]
        .contains(event.type)) {
      return StateMessage(event, unfold: unfold);
    }

    final client = Matrix.of(context).client;
    final ownMessage = event.senderId == client.userID;
    final alignment = ownMessage ? Alignment.topRight : Alignment.topLeft;
    var color = Theme.of(context).secondaryHeaderColor;
    final sameSender = nextEvent != null &&
            [EventTypes.Message, EventTypes.Sticker].contains(nextEvent.type)
        ? nextEvent.sender.id == event.sender.id
        : false;
    var textColor = ownMessage
        ? Colors.white
        : Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;
    final rowMainAxisAlignment =
        ownMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

    final displayEvent = event.getDisplayEvent(timeline);

    if (event.showThumbnail) {
      color = Theme.of(context).scaffoldBackgroundColor;
      textColor = Theme.of(context).textTheme.bodyText2.color;
    } else if (ownMessage) {
      color = displayEvent.status == -1
          ? Colors.redAccent
          : Theme.of(context).primaryColor;
    }

    final rowChildren = <Widget>[
      Expanded(
        child: Container(
          alignment: alignment,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppConfig.borderRadius),
            ),
            constraints:
                BoxConstraints(maxWidth: FluffyThemes.columnWidth * 1.5),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (event.relationshipType == RelationshipTypes.reply)
                      FutureBuilder<Event>(
                        future: event.getReplyEvent(timeline),
                        builder: (BuildContext context, snapshot) {
                          final replyEvent = snapshot.hasData
                              ? snapshot.data
                              : Event(
                                  eventId: event.relationshipEventId,
                                  content: {'msgtype': 'm.text', 'body': '...'},
                                  senderId: event.senderId,
                                  type: 'm.room.message',
                                  room: event.room,
                                  roomId: event.roomId,
                                  status: 1,
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
                                margin: EdgeInsets.symmetric(vertical: 4.0),
                                child: ReplyContent(replyEvent,
                                    lightText: ownMessage, timeline: timeline),
                              ),
                            ),
                          );
                        },
                      ),
                    MessageContent(
                      displayEvent,
                      textColor: textColor,
                    ),
                    SizedBox(height: 3),
                    Opacity(
                      opacity: 0,
                      child: _MetaRow(
                        event, // meta information should be from the unedited event
                        ownMessage,
                        textColor,
                        timeline,
                        displayEvent,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: ownMessage ? 0 : null,
                  left: !ownMessage ? 0 : null,
                  child: _MetaRow(
                    event,
                    ownMessage,
                    textColor,
                    timeline,
                    displayEvent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
    final avatarOrSizedBox = sameSender
        ? SizedBox(width: Avatar.defaultSize)
        : Avatar(
            event.sender.avatarUrl,
            event.sender.calcDisplayname(),
            onTap: () => onAvatarTab(event),
          );
    if (ownMessage) {
      rowChildren.add(avatarOrSizedBox);
    } else {
      rowChildren.insert(0, avatarOrSizedBox);
    }
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: rowMainAxisAlignment,
      children: rowChildren,
    );
    Widget container;
    if (event.hasAggregatedEvents(timeline, RelationshipTypes.reaction)) {
      container = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            ownMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          row,
          Padding(
            padding: EdgeInsets.only(
              top: 4.0,
              left: (ownMessage ? 0 : Avatar.defaultSize) + 12.0,
              right: (ownMessage ? Avatar.defaultSize : 0) + 12.0,
            ),
            child: MessageReactions(event, timeline),
          ),
        ],
      );
    } else {
      container = row;
    }

    return InkWell(
      onHover: (b) => useMouse = true,
      onTap: !useMouse && longPressSelect ? () => null : () => onSelect(event),
      splashColor: Theme.of(context).primaryColor.withAlpha(100),
      onLongPress: !longPressSelect ? null : () => onSelect(event),
      child: Container(
        color: selected
            ? Theme.of(context).primaryColor.withAlpha(100)
            : Theme.of(context).primaryColor.withAlpha(0),
        child: Padding(
          padding:
              EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
          child: container,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Event event;
  final bool ownMessage;
  final Color color;
  final Timeline timeline;
  final Event displayEvent;

  const _MetaRow(
      this.event, this.ownMessage, this.color, this.timeline, this.displayEvent,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayname = event.sender.calcDisplayname();
    final showDisplayname =
        !ownMessage && event.senderId != event.room.directChatMatrixID;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (showDisplayname)
          Text(
            displayname,
            style: TextStyle(
              fontSize: 11 * AppConfig.fontSizeFactor,
              fontWeight: FontWeight.bold,
              color: (Theme.of(context).brightness == Brightness.light
                      ? displayname.darkColor
                      : displayname.lightColor)
                  .withAlpha(200),
            ),
          ),
        if (showDisplayname) SizedBox(width: 4),
        Text(
          event.originServerTs.localizedTime(context),
          style: TextStyle(
            color: color.withAlpha(200),
            fontSize: 11 * AppConfig.fontSizeFactor,
          ),
        ),
        if (event.hasAggregatedEvents(timeline, RelationshipTypes.edit))
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Icon(
              Icons.edit_outlined,
              size: 12 * AppConfig.fontSizeFactor,
              color: color,
            ),
          ),
        if (ownMessage) SizedBox(width: 2),
        if (ownMessage)
          Icon(
            displayEvent.statusIcon,
            size: 14 * AppConfig.fontSizeFactor,
            color: color,
          ),
      ],
    );
  }
}
