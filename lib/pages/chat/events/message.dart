import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:swipe_to_action/swipe_to_action.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/hover_builder.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../../config/app_config.dart';
import 'message_content.dart';
import 'message_reactions.dart';
import 'reply_content.dart';
import 'state_message.dart';
import 'verification_request_content.dart';

class Message extends StatelessWidget {
  final Event event;
  final Event? nextEvent;
  final Event? previousEvent;
  final bool displayReadMarker;
  final void Function(Event) onSelect;
  final void Function(Event) onAvatarTab;
  final void Function(Event) onInfoTab;
  final void Function(String) scrollToEventId;
  final void Function() onSwipe;
  final bool longPressSelect;
  final bool selected;
  final Timeline timeline;
  final bool highlightMarker;
  final bool animateIn;
  final void Function()? resetAnimateIn;
  final Color? avatarPresenceBackgroundColor;

  const Message(
    this.event, {
    this.nextEvent,
    this.previousEvent,
    this.displayReadMarker = false,
    this.longPressSelect = false,
    required this.onSelect,
    required this.onInfoTab,
    required this.onAvatarTab,
    required this.scrollToEventId,
    required this.onSwipe,
    this.selected = false,
    required this.timeline,
    this.highlightMarker = false,
    this.animateIn = false,
    this.resetAnimateIn,
    this.avatarPresenceBackgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!{
      EventTypes.Message,
      EventTypes.Sticker,
      EventTypes.Encrypted,
      EventTypes.CallInvite,
    }.contains(event.type)) {
      if (event.type.startsWith('m.call.')) {
        return const SizedBox.shrink();
      }
      return StateMessage(event);
    }

    if (event.type == EventTypes.Message &&
        event.messageType == EventTypes.KeyVerificationRequest) {
      return VerificationRequestContent(event: event, timeline: timeline);
    }

    final client = Matrix.of(context).client;
    final ownMessage = event.senderId == client.userID;
    final alignment = ownMessage ? Alignment.topRight : Alignment.topLeft;
    var color = Theme.of(context).colorScheme.surfaceVariant;
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

    final textColor = ownMessage
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onBackground;
    final rowMainAxisAlignment =
        ownMessage ? MainAxisAlignment.end : MainAxisAlignment.start;

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

    if (ownMessage) {
      color = displayEvent.status.isError
          ? Colors.redAccent
          : Theme.of(context).colorScheme.primary;
    }

    final resetAnimateIn = this.resetAnimateIn;
    var animateIn = this.animateIn;

    final row = StatefulBuilder(
      builder: (context, setState) {
        if (animateIn && resetAnimateIn != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            animateIn = false;
            setState(resetAnimateIn);
          });
        }
        return AnimatedSlide(
          offset: Offset(0, animateIn ? 1 : 0),
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: rowMainAxisAlignment,
            children: [
              if (longPressSelect)
                SizedBox(
                  height: 32,
                  width: Avatar.defaultSize,
                  child: Checkbox.adaptive(
                    value: selected,
                    shape: const CircleBorder(),
                    onChanged: (_) => onSelect(event),
                  ),
                )
              else if (nextEventSameSender || ownMessage)
                SizedBox(
                  width: Avatar.defaultSize,
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: event.status == EventStatus.error
                          ? const Icon(Icons.error, color: Colors.red)
                          : event.fileSendingStatus != null
                              ? const CircularProgressIndicator.adaptive(
                                  strokeWidth: 1,
                                )
                              : null,
                    ),
                  ),
                )
              else
                FutureBuilder<User?>(
                  future: event.fetchSenderUser(),
                  builder: (context, snapshot) {
                    final user =
                        snapshot.data ?? event.senderFromMemoryOrFallback;
                    return Avatar(
                      mxContent: user.avatarUrl,
                      name: user.calcDisplayname(),
                      presenceUserId: user.stateKey,
                      presenceBackgroundColor: avatarPresenceBackgroundColor,
                      onTap: () => onAvatarTab(event),
                    );
                  },
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!nextEventSameSender)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                        child: ownMessage || event.room.isDirectChat
                            ? const SizedBox(height: 12)
                            : FutureBuilder<User?>(
                                future: event.fetchSenderUser(),
                                builder: (context, snapshot) {
                                  final displayname =
                                      snapshot.data?.calcDisplayname() ??
                                          event.senderFromMemoryOrFallback
                                              .calcDisplayname();
                                  return Text(
                                    displayname,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: (Theme.of(context).brightness ==
                                              Brightness.light
                                          ? displayname.color
                                          : displayname.lightColorText),
                                    ),
                                  );
                                },
                              ),
                      ),
                    Container(
                      alignment: alignment,
                      padding: const EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onLongPress: longPressSelect
                            ? null
                            : () {
                                HapticFeedback.heavyImpact();
                                onSelect(event);
                              },
                        child: AnimatedOpacity(
                          opacity: animateIn
                              ? 0
                              : event.redacted ||
                                      event.messageType ==
                                          MessageTypes.BadEncrypted ||
                                      event.status.isSending
                                  ? 0.5
                                  : 1,
                          duration: FluffyThemes.animationDuration,
                          curve: FluffyThemes.animationCurve,
                          child: Material(
                            color: noBubble ? Colors.transparent : color,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: borderRadius,
                            ),
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
                              constraints: const BoxConstraints(
                                maxWidth: FluffyThemes.columnWidth * 1.5,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (event.relationshipType ==
                                      RelationshipTypes.reply)
                                    FutureBuilder<Event?>(
                                      future: event.getReplyEvent(timeline),
                                      builder:
                                          (BuildContext context, snapshot) {
                                        final replyEvent = snapshot.hasData
                                            ? snapshot.data!
                                            : Event(
                                                eventId:
                                                    event.relationshipEventId!,
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
                                            borderRadius:
                                                ReplyContent.borderRadius,
                                            onTap: () => scrollToEventId(
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
                                    displayEvent,
                                    textColor: textColor,
                                    onInfoTab: onInfoTab,
                                    borderRadius: borderRadius,
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
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    Widget container;
    final showReceiptsRow =
        event.hasAggregatedEvents(timeline, RelationshipTypes.reaction);
    if (showReceiptsRow || displayTime || selected || displayReadMarker) {
      container = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            ownMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          if (displayTime || selected)
            Padding(
              padding: displayTime
                  ? const EdgeInsets.symmetric(vertical: 8.0)
                  : EdgeInsets.zero,
              child: Center(
                child: Material(
                  color: displayTime
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.33),
                  borderRadius:
                      BorderRadius.circular(AppConfig.borderRadius / 2),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      event.originServerTs.localizedTime(context),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12 * AppConfig.fontSizeFactor,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          row,
          AnimatedSize(
            duration: FluffyThemes.animationDuration,
            curve: FluffyThemes.animationCurve,
            child: !showReceiptsRow
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(
                      top: 4.0,
                      left: (ownMessage ? 0 : Avatar.defaultSize) + 12.0,
                      right: ownMessage ? 0 : 12.0,
                    ),
                    child: MessageReactions(event, timeline),
                  ),
          ),
          if (displayReadMarker)
            Row(
              children: [
                Expanded(
                  child: Divider(color: Theme.of(context).colorScheme.primary),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Text(
                    L10n.of(context)!.readUpToHere,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                Expanded(
                  child: Divider(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
        ],
      );
    } else {
      container = row;
    }

    return Container(
      alignment: Alignment.center,
      color: selected
          ? Theme.of(context).colorScheme.secondaryContainer.withAlpha(100)
          : highlightMarker
              ? Theme.of(context).colorScheme.tertiaryContainer.withAlpha(100)
              : Colors.transparent,
      child: Swipeable(
        key: ValueKey(event.eventId),
        background: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Center(
            child: Icon(Icons.check_outlined),
          ),
        ),
        direction: SwipeDirection.endToStart,
        onSwipe: (_) => onSwipe(),
        child: HoverBuilder(
          builder: (context, hovered) => Stack(
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: FluffyThemes.columnWidth * 2.5,
                ),
                padding: EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: nextEventSameSender ? 1.0 : 4.0,
                  bottom: previousEventSameSender ? 1.0 : 4.0,
                ),
                child: container,
              ),
              Positioned(
                left: ownMessage ? null : 48,
                right: ownMessage ? 4 : null,
                top: displayTime ? 38 : 0,
                child: AnimatedScale(
                  duration: Duration(
                    milliseconds:
                        (FluffyThemes.animationDuration.inMilliseconds / 2)
                            .floor(),
                  ),
                  curve: FluffyThemes.animationCurve,
                  scale: !longPressSelect && hovered ? 1 : 0,
                  alignment: Alignment.center,
                  child: Material(
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.9),
                    elevation:
                        Theme.of(context).appBarTheme.scrolledUnderElevation ??
                            4,
                    borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                    shadowColor: Theme.of(context).appBarTheme.shadowColor,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (event.room.canSendDefaultMessages)
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: IconButton(
                              icon: Icon(
                                Icons.reply_outlined,
                                size: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onTertiaryContainer,
                              ),
                              tooltip: L10n.of(context)!.reply,
                              onPressed: event.room.canSendDefaultMessages
                                  ? () => onSwipe()
                                  : null,
                            ),
                          ),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                            ),
                            tooltip: L10n.of(context)!.select,
                            onPressed: () => onSelect(event),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
