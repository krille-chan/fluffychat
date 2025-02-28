import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:swipe_to_action/swipe_to_action.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/room_creation_state_event.dart';
import 'package:fluffychat/pangea/choreographer/enums/use_type.dart';
import 'package:fluffychat/pangea/common/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_buttons.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/file_description.dart';
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
  final bool wallpaperMode;
  // #Pangea
  final bool immersionMode;
  final ChatController controller;
  final MessageOverlayController? overlayController;
  final bool isButton;
  // Pangea#

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
    this.wallpaperMode = false,
    // #Pangea
    required this.immersionMode,
    required this.controller,
    this.overlayController,
    this.isButton = false,
    // Pangea#
    super.key,
  });

  // #Pangea
  void showToolbar(PangeaMessageEvent? pangeaMessageEvent) {
    // if overlayController is not null, the message is already in overlay mode
    if (pangeaMessageEvent != null && overlayController == null) {
      controller.showToolbar(
        event,
        pangeaMessageEvent: pangeaMessageEvent,
        nextEvent: nextEvent,
        prevEvent: previousEvent,
      );
    }
  }
  // Pangea#

  @override
  Widget build(BuildContext context) {
    // #Pangea
    PangeaMessageEvent? pangeaMessageEvent;
    if (event.type == EventTypes.Message) {
      pangeaMessageEvent = PangeaMessageEvent(
        event: event,
        timeline: timeline,
        ownMessage: event.senderId == Matrix.of(context).client.userID,
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.pangeaEditingEvent?.eventId == event.eventId) {
        pangeaMessageEvent?.updateLatestEdit();
        controller.clearEditingEvent();
      }
    });
    // Pangea#
    final theme = Theme.of(context);

    if (!{
      EventTypes.Message,
      EventTypes.Sticker,
      EventTypes.Encrypted,
      EventTypes.CallInvite,
    }.contains(event.type)) {
      if (event.type.startsWith('m.call.')) {
        return const SizedBox.shrink();
      }
      if (event.type == EventTypes.RoomCreate) {
        return RoomCreationStateEvent(event: event);
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

    var color = theme.colorScheme.surfaceContainerHigh;
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
        ?
        // #Pangea
        // theme.brightness == Brightness.light
        //     ? theme.colorScheme.onPrimary
        //     : theme.colorScheme.onPrimaryContainer
        ThemeData.dark().colorScheme.onPrimary
        // Pangea#
        : theme.colorScheme.onSurface;

    // #Pangea
    // final linkColor = ownMessage
    //     ? theme.brightness == Brightness.light
    //         ? theme.colorScheme.primaryFixed
    //         : theme.colorScheme.onTertiaryContainer
    //     : theme.colorScheme.primary;
    final linkColor = theme.brightness == Brightness.light
        ? theme.colorScheme.primary
        : ownMessage
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface;
    // Pangea#

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
    final noPadding = {
      MessageTypes.File,
      MessageTypes.Audio,
    }.contains(event.messageType);

    if (ownMessage) {
      color = displayEvent.status.isError
          ? Colors.redAccent
          // #Pangea
          // : theme.brightness == Brightness.light
          //     ? theme.colorScheme.primary
          //     : theme.colorScheme.primaryContainer;
          : Color.alphaBlend(
              Colors.white.withAlpha(180),
              ThemeData.dark().colorScheme.primary,
            );
      // Pangea#
    }

    final resetAnimateIn = this.resetAnimateIn;
    var animateIn = this.animateIn;

    final row = StatefulBuilder(
      builder: (context, setState) {
        if (animateIn && resetAnimateIn != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            animateIn = false;
            // #Pangea
            // setState(resetAnimateIn);
            if (context.mounted) setState(resetAnimateIn);
            // Pangea#
          });
        }
        return AnimatedSize(
          duration: FluffyThemes.animationDuration,
          curve: FluffyThemes.animationCurve,
          clipBehavior: Clip.none,
          alignment: ownMessage ? Alignment.bottomRight : Alignment.bottomLeft,
          child: animateIn
              ? const SizedBox(height: 0, width: double.infinity)
              : Stack(
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: InkWell(
                        // #Pangea
                        onTap: () => overlayController == null
                            ? showToolbar(pangeaMessageEvent)
                            : controller.clearSelectedEvents(),
                        onLongPress: () => overlayController == null
                            ? showToolbar(pangeaMessageEvent)
                            : controller.clearSelectedEvents(),
                        // onTap: () => onSelect(event),
                        // onLongPress: () => onSelect(event),
                        // Pangea#
                        borderRadius:
                            BorderRadius.circular(AppConfig.borderRadius / 2),
                        child: Material(
                          borderRadius:
                              BorderRadius.circular(AppConfig.borderRadius / 2),
                          color: selected || highlightMarker
                              ? theme.colorScheme.secondaryContainer
                                  .withAlpha(128)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: rowMainAxisAlignment,
                      children: [
                        // #Pangea
                        // if (longPressSelect)
                        //   SizedBox(
                        //     height: 32,
                        //     width: Avatar.defaultSize,
                        //     child: Checkbox.adaptive(
                        //       value: selected,
                        //       shape: const CircleBorder(),
                        //       onChanged: (_) => onSelect(event),
                        //     ),
                        //   )
                        // else if (nextEventSameSender || ownMessage)
                        if (nextEventSameSender ||
                            ownMessage ||
                            overlayController != null)
                          // Pangea#
                          SizedBox(
                            width: Avatar.defaultSize,
                            child: Center(
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: event.status == EventStatus.error
                                    ? const Icon(Icons.error, color: Colors.red)
                                    : event.fileSendingStatus != null
                                        ? const CircularProgressIndicator
                                            .adaptive(
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
                              final user = snapshot.data ??
                                  event.senderFromMemoryOrFallback;
                              return Avatar(
                                mxContent: user.avatarUrl,
                                name: user.calcDisplayname(),
                                presenceUserId: user.stateKey,
                                presenceBackgroundColor:
                                    wallpaperMode ? Colors.transparent : null,
                                onTap: () => onAvatarTab(event),
                              );
                            },
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // #Pangea
                              // if (!nextEventSameSender)
                              if (!nextEventSameSender &&
                                  overlayController == null)
                                // Pangea#
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 4,
                                  ),
                                  child: ownMessage || event.room.isDirectChat
                                      ? const SizedBox(height: 12)
                                      : FutureBuilder<User?>(
                                          future: event.fetchSenderUser(),
                                          builder: (context, snapshot) {
                                            final displayname = snapshot.data
                                                    ?.calcDisplayname() ??
                                                event.senderFromMemoryOrFallback
                                                    .calcDisplayname();
                                            return Text(
                                              displayname,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: (theme.brightness ==
                                                        Brightness.light
                                                    ? displayname.color
                                                    : displayname
                                                        .lightColorText),
                                                shadows: !wallpaperMode
                                                    ? null
                                                    : [
                                                        const Shadow(
                                                          offset: Offset(
                                                            0.0,
                                                            0.0,
                                                          ),
                                                          blurRadius: 3,
                                                          color: Colors.black,
                                                        ),
                                                      ],
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          },
                                        ),
                                ),
                              Container(
                                alignment: alignment,
                                padding: const EdgeInsets.only(left: 8),
                                child: GestureDetector(
                                  // #Pangea
                                  onTap: () => showToolbar(pangeaMessageEvent),
                                  onLongPress: () =>
                                      showToolbar(pangeaMessageEvent),
                                  // onLongPress: longPressSelect
                                  //     ? null
                                  //     : () {
                                  //         HapticFeedback.heavyImpact();
                                  //         onSelect(event);
                                  //       },
                                  // Pangea#
                                  child: AnimatedOpacity(
                                    opacity: animateIn
                                        ? 0
                                        : event.messageType ==
                                                    MessageTypes.BadEncrypted ||
                                                event.status.isSending
                                            ? 0.5
                                            : 1,
                                    duration: FluffyThemes.animationDuration,
                                    curve: FluffyThemes.animationCurve,
                                    child:
                                        // #Pangea
                                        PressableButton(
                                      triggerAnimation: controller
                                          .showToolbarStream.stream
                                          .where(
                                        (eventID) => eventID == event.eventId,
                                      ),
                                      depressed: !isButton,
                                      borderRadius: borderRadius,
                                      onPressed: () {
                                        showToolbar(pangeaMessageEvent);
                                      },
                                      color: color,
                                      child:
                                          // Pangea#
                                          Container(
                                        decoration: BoxDecoration(
                                          color: noBubble
                                              ? Colors.transparent
                                              : color,
                                          borderRadius: borderRadius,
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        // #Pangea
                                        child: CompositedTransformTarget(
                                          link: overlayController != null
                                              ? LayerLinkAndKey('overlay_msg')
                                                  .link
                                              : MatrixState.pAnyState
                                                  .layerLinkAndKey(
                                                    event.eventId,
                                                  )
                                                  .link,
                                          child: Container(
                                            key: overlayController != null
                                                ? LayerLinkAndKey('overlay_msg')
                                                    .key
                                                : MatrixState.pAnyState
                                                    .layerLinkAndKey(
                                                      event.eventId,
                                                    )
                                                    .key,
                                            // Pangea#
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
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
                                              maxWidth:
                                                  FluffyThemes.columnWidth *
                                                      1.5,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                if (event.relationshipType ==
                                                    RelationshipTypes.reply)
                                                  FutureBuilder<Event?>(
                                                    future: event.getReplyEvent(
                                                      timeline,
                                                    ),
                                                    builder: (
                                                      BuildContext context,
                                                      snapshot,
                                                    ) {
                                                      final replyEvent =
                                                          snapshot.hasData
                                                              ? snapshot.data!
                                                              : Event(
                                                                  eventId: event
                                                                      .relationshipEventId!,
                                                                  content: {
                                                                    'msgtype':
                                                                        'm.text',
                                                                    'body':
                                                                        '...',
                                                                  },
                                                                  senderId: event
                                                                      .senderId,
                                                                  type:
                                                                      'm.room.message',
                                                                  room: event
                                                                      .room,
                                                                  status:
                                                                      EventStatus
                                                                          .sent,
                                                                  originServerTs:
                                                                      DateTime
                                                                          .now(),
                                                                );
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: 4.0,
                                                        ),
                                                        child: InkWell(
                                                          borderRadius:
                                                              ReplyContent
                                                                  .borderRadius,
                                                          onTap: () =>
                                                              scrollToEventId(
                                                            replyEvent.eventId,
                                                          ),
                                                          child: AbsorbPointer(
                                                            child: ReplyContent(
                                                              replyEvent,
                                                              ownMessage:
                                                                  ownMessage,
                                                              timeline:
                                                                  timeline,
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
                                                  onInfoTab: onInfoTab,
                                                  borderRadius: borderRadius,
                                                  timeline: timeline,
                                                  // #Pangea
                                                  pangeaMessageEvent:
                                                      pangeaMessageEvent,
                                                  immersionMode: immersionMode,
                                                  overlayController:
                                                      overlayController,
                                                  controller: controller,
                                                  nextEvent: nextEvent,
                                                  prevEvent: previousEvent,
                                                  // Pangea#
                                                ),
                                                if (event.hasAggregatedEvents(
                                                          timeline,
                                                          RelationshipTypes
                                                              .edit,
                                                        )
                                                        // #Pangea
                                                        ||
                                                        (pangeaMessageEvent
                                                                ?.showUseType ??
                                                            false)
                                                    // Pangea#
                                                    )
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 4.0,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        // #Pangea
                                                        if (pangeaMessageEvent
                                                                ?.showUseType ??
                                                            false) ...[
                                                          pangeaMessageEvent!
                                                              .msgUseType
                                                              .iconView(
                                                            context,
                                                            textColor
                                                                .withAlpha(164),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                        ],
                                                        if (event
                                                            .hasAggregatedEvents(
                                                          timeline,
                                                          RelationshipTypes
                                                              .edit,
                                                        )) ...[
                                                          // Pangea#
                                                          Icon(
                                                            Icons.edit_outlined,
                                                            color: textColor
                                                                .withAlpha(164),
                                                            size: 14,
                                                          ),
                                                          Text(
                                                            ' - ${displayEvent.originServerTs.localizedTimeShort(context)}',
                                                            style: TextStyle(
                                                              color: textColor
                                                                  .withAlpha(
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
                  ],
                ),
        );
      },
    );
    Widget container;
    final showReceiptsRow =
        event.hasAggregatedEvents(timeline, RelationshipTypes.reaction);
    // #Pangea
    // if (showReceiptsRow || displayTime || selected || displayReadMarker) {
    if (overlayController == null &&
        (showReceiptsRow ||
            displayTime ||
            displayReadMarker ||
            (pangeaMessageEvent?.showMessageButtons ?? false))) {
      // Pangea#
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Material(
                    borderRadius:
                        BorderRadius.circular(AppConfig.borderRadius * 2),
                    color: theme.colorScheme.surface.withAlpha(128),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      child: Text(
                        event.originServerTs.localizedTime(context),
                        style: TextStyle(
                          fontSize: 12 * AppConfig.fontSizeFactor,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                        ),
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
            // #Pangea
            child: overlayController != null ||
                    (!showReceiptsRow &&
                        !(pangeaMessageEvent?.showMessageButtons ?? false))
                // child: !showReceiptsRow
                // Pangea#
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(
                      top: 4.0,
                      left: (ownMessage ? 0 : Avatar.defaultSize) + 12.0,
                      right: ownMessage ? 0 : 12.0,
                    ),
                    // #Pangea
                    child: Row(
                      mainAxisAlignment: ownMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        if (pangeaMessageEvent?.showMessageButtons ?? false)
                          MessageButtons(
                            event: event,
                            controller: controller,
                            pangeaMessageEvent: pangeaMessageEvent!,
                            nextEvent: nextEvent,
                            prevEvent: previousEvent,
                          ),
                        MessageReactions(event, timeline),
                      ],
                    ),
                    // child: MessageReactions(event, timeline),
                    // Pangea#
                  ),
          ),
          if (displayReadMarker)
            Row(
              children: [
                Expanded(
                  child:
                      Divider(color: theme.colorScheme.surfaceContainerHighest),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 16.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppConfig.borderRadius / 3),
                    color: theme.colorScheme.surface.withAlpha(128),
                  ),
                  child: Text(
                    L10n.of(context).readUpToHere,
                    style: TextStyle(
                      fontSize: 12 * AppConfig.fontSizeFactor,
                    ),
                  ),
                ),
                Expanded(
                  child:
                      Divider(color: theme.colorScheme.surfaceContainerHighest),
                ),
              ],
            ),
        ],
      );
    } else {
      container = row;
    }

    // #Pangea
    container = Material(type: MaterialType.transparency, child: container);
    // Pangea#

    return Center(
      child: Swipeable(
        key: ValueKey(event.eventId),
        background: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Center(
            child: Icon(Icons.check_outlined),
          ),
        ),
        direction: AppConfig.swipeRightToLeftToReply
            ? SwipeDirection.endToStart
            : SwipeDirection.startToEnd,
        onSwipe: (_) => onSwipe(),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: FluffyThemes.columnWidth * 2.5,
          ),
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: nextEventSameSender ? 1.0 : 4.0,
            bottom:
                // #Pangea
                overlayController != null
                    ? 0
                    :
                    // Pangea#
                    previousEventSameSender
                        ? 1.0
                        : 4.0,
          ),
          child: container,
        ),
      ),
    );
  }
}
