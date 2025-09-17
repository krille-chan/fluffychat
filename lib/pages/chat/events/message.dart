import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';
import 'package:swipe_to_action/swipe_to_action.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/pangea_message_reactions.dart';
import 'package:fluffychat/pages/chat/events/room_creation_state_event.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/activity_roles_event_widget.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_summary_widget.dart';
import 'package:fluffychat/pangea/chat/extensions/custom_room_display_extension.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/file_description.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/member_actions_popup_menu_button.dart';
import '../../../config/app_config.dart';
import 'message_content.dart';
import 'reply_content.dart';
import 'state_message.dart';

class Message extends StatelessWidget {
  final Event event;
  final Event? nextEvent;
  final Event? previousEvent;
  final bool displayReadMarker;
  final void Function(Event) onSelect;
  final void Function(Event) onInfoTab;
  final void Function(String) scrollToEventId;
  final void Function() onSwipe;
  final void Function() onMention;
  final void Function() onEdit;
  final bool longPressSelect;
  final bool selected;
  final bool singleSelected;
  final Timeline timeline;
  final bool highlightMarker;
  final bool animateIn;
  final void Function()? resetAnimateIn;
  final bool wallpaperMode;
  final ScrollController scrollController;
  final List<Color> colors;
  // #Pangea
  final ChatController controller;
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
    required this.scrollToEventId,
    required this.onSwipe,
    this.selected = false,
    required this.onEdit,
    required this.singleSelected,
    required this.timeline,
    this.highlightMarker = false,
    this.animateIn = false,
    this.resetAnimateIn,
    this.wallpaperMode = false,
    required this.onMention,
    required this.scrollController,
    required this.colors,
    // #Pangea
    required this.controller,
    this.isButton = false,
    // Pangea#
    super.key,
  });

  // #Pangea
  void showToolbar(PangeaMessageEvent? pangeaMessageEvent) {
    // if overlayController is not null, the message is already in overlay mode
    if (pangeaMessageEvent != null) {
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
        // #Pangea
        // return RoomCreationStateEvent(event: event);
        return event.room.isActivitySession
            ? const SizedBox(height: 60.0)
            : RoomCreationStateEvent(event: event);
        // Pangea#
      }

      // #Pangea
      if (event.type == PangeaEventTypes.activityPlan &&
          event.room.activityPlan != null) {
        return ActivitySummary(
          activity: event.room.activityPlan!,
          room: event.room,
          showInstructions: controller.showInstructions,
          toggleInstructions: controller.toggleShowInstructions,
          getParticipantOpacity: (role) =>
              role == null || role.isFinished ? 0.5 : 1.0,
          isParticipantSelected: (id) => controller.room.ownRoleState?.id == id,
        );
      }

      if (event.type == PangeaEventTypes.activityRole) {
        return ActivityRolesEvent(event: event);
      }
      // Pangea#

      return StateMessage(event);
    }

    if (event.type == EventTypes.Message &&
        event.messageType == EventTypes.KeyVerificationRequest) {
      return StateMessage(event);
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

    // #Pangea
    // final textColor =
    //     ownMessage ? theme.onBubbleColor : theme.colorScheme.onSurface;
    final textColor = ownMessage
        ? ThemeData.dark().colorScheme.onPrimary
        : theme.colorScheme.onSurface;

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

    if (ownMessage) {
      // #Pangea
      // color =
      //     displayEvent.status.isError ? Colors.redAccent : theme.bubbleColor;
      color = displayEvent.status.isError
          ? Colors.redAccent
          : Color.alphaBlend(
              Colors.white.withAlpha(180),
              ThemeData.dark().colorScheme.primary,
            );
      // Pangea#
    }

    final resetAnimateIn = this.resetAnimateIn;
    var animateIn = this.animateIn;

    final sentReactions = <String>{};
    if (singleSelected) {
      sentReactions.addAll(
        event
            .aggregatedEvents(
              timeline,
              RelationshipTypes.reaction,
            )
            .where(
              (event) =>
                  event.senderId == event.room.client.userID &&
                  event.type == 'm.reaction',
            )
            .map(
              (event) => event.content
                  .tryGetMap<String, Object?>('m.relates_to')
                  ?.tryGet<String>('key'),
            )
            .whereType<String>(),
      );
    }

    final showReceiptsRow =
        event.hasAggregatedEvents(timeline, RelationshipTypes.reaction);

    // #Pangea
    // final showReactionPicker =
    //     singleSelected && event.room.canSendDefaultMessages;
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
            maxWidth: FluffyThemes.maxTimelineWidth,
          ),
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: nextEventSameSender ? 1.0 : 4.0,
            bottom: previousEventSameSender ? 1.0 : 4.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                ownMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              // #Pangea
              // if (displayTime || selected)
              if (displayTime)
                // Pangea#
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
              StatefulBuilder(
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
                    alignment: ownMessage
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child: animateIn
                        ? const SizedBox(height: 0, width: double.infinity)
                        : Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: InkWell(
                                  hoverColor: longPressSelect
                                      ? Colors.transparent
                                      : null,
                                  enableFeedback: !selected,
                                  // #Pangea
                                  // onTap: longPressSelect
                                  //     ? null
                                  //     : () => onSelect(event),
                                  onTap: () => showToolbar(pangeaMessageEvent),
                                  onLongPress: () =>
                                      showToolbar(pangeaMessageEvent),
                                  // Pangea#
                                  borderRadius: BorderRadius.circular(
                                    AppConfig.borderRadius / 2,
                                  ),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(
                                      AppConfig.borderRadius / 2,
                                    ),
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
                                  // if (longPressSelect && !event.redacted)
                                  //   SizedBox(
                                  //     height: 32,
                                  //     width: Avatar.defaultSize,
                                  //     child: IconButton(
                                  //       padding: EdgeInsets.zero,
                                  //       tooltip: L10n.of(context).select,
                                  //       icon: Icon(
                                  //         selected
                                  //             ? Icons.check_circle
                                  //             : Icons.circle_outlined,
                                  //       ),
                                  //       onPressed: () => onSelect(event),
                                  //     ),
                                  //   )
                                  // else if (nextEventSameSender || ownMessage)
                                  if (nextEventSameSender || ownMessage)
                                    // Pangea#
                                    SizedBox(
                                      width: Avatar.defaultSize,
                                      child: Center(
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: event.status ==
                                                  EventStatus.error
                                              ? const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                )
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
                                          onTap: () =>
                                              showMemberActionsPopupMenu(
                                            context: context,
                                            user: user,
                                            onMention: onMention,
                                          ),
                                          presenceUserId: user.stateKey,
                                          presenceBackgroundColor: wallpaperMode
                                              ? Colors.transparent
                                              : null,
                                        );
                                      },
                                    ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (!nextEventSameSender)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                              bottom: 4,
                                            ),
                                            child: ownMessage ||
                                                    event.room.isDirectChat
                                                ? const SizedBox(height: 12)
                                                : FutureBuilder<User?>(
                                                    future:
                                                        event.fetchSenderUser(),
                                                    builder:
                                                        (context, snapshot) {
                                                      final displayname = snapshot
                                                              .data
                                                              ?.calcDisplayname() ??
                                                          event
                                                              .senderFromMemoryOrFallback
                                                              .calcDisplayname();
                                                      return Text(
                                                        // #Pangea
                                                        // displayname,
                                                        controller.room
                                                            .senderDisplayName(
                                                          snapshot.data ??
                                                              event
                                                                  .senderFromMemoryOrFallback,
                                                        ),
                                                        // Pangea#
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: (theme.brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? displayname
                                                                  .color
                                                              : displayname
                                                                  .lightColorText),
                                                          shadows:
                                                              !wallpaperMode
                                                                  ? null
                                                                  : [
                                                                      const Shadow(
                                                                        offset:
                                                                            Offset(
                                                                          0.0,
                                                                          0.0,
                                                                        ),
                                                                        blurRadius:
                                                                            3,
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ],
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    },
                                                  ),
                                          ),
                                        Container(
                                          alignment: alignment,
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: GestureDetector(
                                            // #Pangea
                                            onTap: () =>
                                                showToolbar(pangeaMessageEvent),
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
                                                              MessageTypes
                                                                  .BadEncrypted ||
                                                          event.status.isSending
                                                      ? 0.5
                                                      : 1,
                                              duration: FluffyThemes
                                                  .animationDuration,
                                              curve:
                                                  FluffyThemes.animationCurve,
                                              child:
                                                  // #Pangea
                                                  PressableButton(
                                                triggerAnimation: controller
                                                    .showToolbarStream.stream
                                                    .where(
                                                  (eventID) =>
                                                      eventID == event.eventId,
                                                ),
                                                depressed: !isButton,
                                                borderRadius: borderRadius,
                                                onPressed: () {
                                                  showToolbar(
                                                    pangeaMessageEvent,
                                                  );
                                                },
                                                color: color,
                                                visible: isButton && !noBubble,
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
                                                  child:
                                                      CompositedTransformTarget(
                                                    link: MatrixState.pAnyState
                                                        .layerLinkAndKey(
                                                          event.eventId,
                                                        )
                                                        .link,
                                                    // child: BubbleBackground(
                                                    //   colors: colors,
                                                    //   ignore: noBubble || !ownMessage,
                                                    //   scrollController: scrollController,
                                                    // Pangea#
                                                    child: Container(
                                                      // #Pangea
                                                      key: MatrixState.pAnyState
                                                          .layerLinkAndKey(
                                                            event.eventId,
                                                          )
                                                          .key,
                                                      // Pangea#
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          AppConfig
                                                              .borderRadius,
                                                        ),
                                                      ),
                                                      constraints:
                                                          const BoxConstraints(
                                                        maxWidth: FluffyThemes
                                                                .columnWidth *
                                                            1.5,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          if ({
                                                            RelationshipTypes
                                                                .reply,
                                                            RelationshipTypes
                                                                .thread,
                                                          }.contains(
                                                            event
                                                                .relationshipType,
                                                          ))
                                                            FutureBuilder<
                                                                Event?>(
                                                              future: event
                                                                  .getReplyEvent(
                                                                timeline,
                                                              ),
                                                              builder: (
                                                                BuildContext
                                                                    context,
                                                                snapshot,
                                                              ) {
                                                                final replyEvent =
                                                                    snapshot
                                                                            .hasData
                                                                        ? snapshot
                                                                            .data!
                                                                        : Event(
                                                                            eventId:
                                                                                event.relationshipEventId!,
                                                                            content: {
                                                                              'msgtype': 'm.text',
                                                                              'body': '...',
                                                                            },
                                                                            // #Pangea
                                                                            // senderId: event
                                                                            //     .senderId,
                                                                            senderId:
                                                                                "",
                                                                            // Pangea#
                                                                            type:
                                                                                'm.room.message',
                                                                            room:
                                                                                event.room,
                                                                            status:
                                                                                EventStatus.sent,
                                                                            originServerTs:
                                                                                DateTime.now(),
                                                                          );
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 16,
                                                                    right: 16,
                                                                    top: 8,
                                                                  ),
                                                                  child:
                                                                      Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    borderRadius:
                                                                        ReplyContent
                                                                            .borderRadius,
                                                                    child:
                                                                        InkWell(
                                                                      borderRadius:
                                                                          ReplyContent
                                                                              .borderRadius,
                                                                      onTap: () =>
                                                                          scrollToEventId(
                                                                        replyEvent
                                                                            .eventId,
                                                                      ),
                                                                      child:
                                                                          AbsorbPointer(
                                                                        child:
                                                                            ReplyContent(
                                                                          replyEvent,
                                                                          ownMessage:
                                                                              ownMessage,
                                                                          timeline:
                                                                              timeline,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          MessageContent(
                                                            displayEvent,
                                                            textColor:
                                                                textColor,
                                                            linkColor:
                                                                linkColor,
                                                            onInfoTab:
                                                                onInfoTab,
                                                            borderRadius:
                                                                borderRadius,
                                                            timeline: timeline,
                                                            selected: selected,
                                                            // #Pangea
                                                            pangeaMessageEvent:
                                                                pangeaMessageEvent,
                                                            controller:
                                                                controller,
                                                            nextEvent:
                                                                nextEvent,
                                                            prevEvent:
                                                                previousEvent,
                                                            // Pangea#
                                                          ),
                                                          if (event
                                                              .hasAggregatedEvents(
                                                            timeline,
                                                            RelationshipTypes
                                                                .edit,
                                                          ))
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                bottom: 8.0,
                                                                left: 16.0,
                                                                right: 16.0,
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                spacing: 4.0,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .edit_outlined,
                                                                    color: textColor
                                                                        .withAlpha(
                                                                      164,
                                                                    ),
                                                                    size: 14,
                                                                  ),
                                                                  Text(
                                                                    displayEvent
                                                                        .originServerTs
                                                                        .localizedTimeShort(
                                                                      context,
                                                                    ),
                                                                    style:
                                                                        TextStyle(
                                                                      color: textColor
                                                                          .withAlpha(
                                                                        164,
                                                                      ),
                                                                      fontSize:
                                                                          11,
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
                                          ),
                                        ),
                                        // #Pangea
                                        // Align(
                                        //   alignment: ownMessage
                                        //       ? Alignment.bottomRight
                                        //       : Alignment.bottomLeft,
                                        //   child: AnimatedSize(
                                        //     duration:
                                        //         FluffyThemes.animationDuration,
                                        //     curve: FluffyThemes.animationCurve,
                                        //     child: showReactionPicker
                                        //         ? Padding(
                                        //             padding:
                                        //                 const EdgeInsets.all(
                                        //               4.0,
                                        //             ),
                                        //             child: Material(
                                        //               elevation: 4,
                                        //               borderRadius:
                                        //                   BorderRadius.circular(
                                        //                 AppConfig.borderRadius,
                                        //               ),
                                        //               shadowColor: theme
                                        //                   .colorScheme.surface
                                        //                   .withAlpha(128),
                                        //               child:
                                        //                   SingleChildScrollView(
                                        //                 scrollDirection:
                                        //                     Axis.horizontal,
                                        //                 child: Row(
                                        //                   mainAxisSize:
                                        //                       MainAxisSize.min,
                                        //                   children: [
                                        //                     ...AppConfig
                                        //                         .defaultReactions
                                        //                         .map(
                                        //                       (emoji) =>
                                        //                           IconButton(
                                        //                         padding:
                                        //                             EdgeInsets
                                        //                                 .zero,
                                        //                         icon: Center(
                                        //                           child:
                                        //                               Opacity(
                                        //                             opacity: sentReactions
                                        //                                     .contains(
                                        //                               emoji,
                                        //                             )
                                        //                                 ? 0.33
                                        //                                 : 1,
                                        //                             child: Text(
                                        //                               emoji,
                                        //                               style:
                                        //                                   const TextStyle(
                                        //                                 fontSize:
                                        //                                     20,
                                        //                               ),
                                        //                               textAlign:
                                        //                                   TextAlign
                                        //                                       .center,
                                        //                             ),
                                        //                           ),
                                        //                         ),
                                        //                         onPressed:
                                        //                             sentReactions
                                        //                                     .contains(
                                        //                           emoji,
                                        //                         )
                                        //                                 ? null
                                        //                                 : () {
                                        //                                     onSelect(
                                        //                                       event,
                                        //                                     );
                                        //                                     event.room.sendReaction(
                                        //                                       event.eventId,
                                        //                                       emoji,
                                        //                                     );
                                        //                                   },
                                        //                       ),
                                        //                     ),
                                        //                     IconButton(
                                        //                       icon: const Icon(
                                        //                         Icons
                                        //                             .add_reaction_outlined,
                                        //                       ),
                                        //                       tooltip: L10n.of(
                                        //                         context,
                                        //                       ).customReaction,
                                        //                       onPressed:
                                        //                           () async {
                                        //                         final emoji =
                                        //                             await showAdaptiveBottomSheet<
                                        //                                 String>(
                                        //                           context:
                                        //                               context,
                                        //                           builder:
                                        //                               (context) =>
                                        //                                   Scaffold(
                                        //                             appBar:
                                        //                                 AppBar(
                                        //                               title:
                                        //                                   Text(
                                        //                                 L10n.of(context)
                                        //                                     .customReaction,
                                        //                               ),
                                        //                               leading:
                                        //                                   CloseButton(
                                        //                                 onPressed:
                                        //                                     () =>
                                        //                                         Navigator.of(
                                        //                                   context,
                                        //                                 ).pop(
                                        //                                   null,
                                        //                                 ),
                                        //                               ),
                                        //                             ),
                                        //                             body:
                                        //                                 SizedBox(
                                        //                               height: double
                                        //                                   .infinity,
                                        //                               child:
                                        //                                   EmojiPicker(
                                        //                                 onEmojiSelected: (
                                        //                                   _,
                                        //                                   emoji,
                                        //                                 ) =>
                                        //                                     Navigator.of(
                                        //                                   context,
                                        //                                 ).pop(
                                        //                                   emoji
                                        //                                       .emoji,
                                        //                                 ),
                                        //                                 config:
                                        //                                     Config(
                                        //                                   emojiViewConfig:
                                        //                                       const EmojiViewConfig(
                                        //                                     backgroundColor:
                                        //                                         Colors.transparent,
                                        //                                   ),
                                        //                                   bottomActionBarConfig:
                                        //                                       const BottomActionBarConfig(
                                        //                                     enabled:
                                        //                                         false,
                                        //                                   ),
                                        //                                   categoryViewConfig:
                                        //                                       CategoryViewConfig(
                                        //                                     initCategory:
                                        //                                         Category.SMILEYS,
                                        //                                     backspaceColor:
                                        //                                         theme.colorScheme.primary,
                                        //                                     iconColor:
                                        //                                         theme.colorScheme.primary.withAlpha(
                                        //                                       128,
                                        //                                     ),
                                        //                                     iconColorSelected:
                                        //                                         theme.colorScheme.primary,
                                        //                                     indicatorColor:
                                        //                                         theme.colorScheme.primary,
                                        //                                     backgroundColor:
                                        //                                         theme.colorScheme.surface,
                                        //                                   ),
                                        //                                   skinToneConfig:
                                        //                                       SkinToneConfig(
                                        //                                     dialogBackgroundColor:
                                        //                                         Color.lerp(
                                        //                                       theme.colorScheme.surface,
                                        //                                       theme.colorScheme.primaryContainer,
                                        //                                       0.75,
                                        //                                     )!,
                                        //                                     indicatorColor:
                                        //                                         theme.colorScheme.onSurface,
                                        //                                   ),
                                        //                                 ),
                                        //                               ),
                                        //                             ),
                                        //                           ),
                                        //                         );
                                        //                         if (emoji ==
                                        //                             null) {
                                        //                           return;
                                        //                         }
                                        //                         if (sentReactions
                                        //                             .contains(
                                        //                           emoji,
                                        //                         )) {
                                        //                           return;
                                        //                         }
                                        //                         onSelect(event);

                                        //                         await event.room
                                        //                             .sendReaction(
                                        //                           event.eventId,
                                        //                           emoji,
                                        //                         );
                                        //                       },
                                        //                     ),
                                        //                   ],
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           )
                                        //         : const SizedBox.shrink(),
                                        //   ),
                                        // ),
                                        // Pangea#
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  );
                },
              ),
              // #Pangea
              // AnimatedSize(
              //   duration: FluffyThemes.animationDuration,
              //   curve: FluffyThemes.animationCurve,
              //   alignment: Alignment.bottomCenter,
              //   clipBehavior: Clip.none,
              //   child: !showReceiptsRow
              //       ? const SizedBox.shrink()
              //       : Padding(
              //           padding: EdgeInsets.only(
              //             top: 4.0,
              //             left: (ownMessage ? 0 : Avatar.defaultSize) + 12.0,
              //             right: ownMessage ? 0 : 12.0,
              //           ),
              //           child: MessageReactions(event, timeline),
              //         ),
              // ),
              !showReceiptsRow
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.only(
                        top: 4.0,
                        left: (ownMessage ? 0 : Avatar.defaultSize) + 12.0,
                        right: ownMessage ? 0 : 12.0,
                      ),
                      child: PangeaMessageReactions(
                        event,
                        timeline,
                        controller,
                        key: MatrixState.pAnyState
                            .layerLinkAndKey(
                              'message_reactions_${event.eventId}',
                            )
                            .key,
                      ),
                      // Pangea#
                    ),
              if (displayReadMarker)
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
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
                      child: Divider(
                        color: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class BubbleBackground extends StatelessWidget {
  const BubbleBackground({
    super.key,
    required this.scrollController,
    required this.colors,
    required this.ignore,
    required this.child,
  });

  final ScrollController scrollController;
  final List<Color> colors;
  final bool ignore;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (ignore) return child;
    return CustomPaint(
      painter: BubblePainter(
        repaint: scrollController,
        colors: colors,
        context: context,
      ),
      child: child,
    );
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({
    required this.context,
    required this.colors,
    required super.repaint,
  });

  final BuildContext context;
  final List<Color> colors;
  ScrollableState? _scrollable;

  @override
  void paint(Canvas canvas, Size size) {
    final scrollable = _scrollable ??= Scrollable.of(context);
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final scrollableRect = Offset.zero & scrollableBox.size;
    final bubbleBox = context.findRenderObject() as RenderBox;

    final origin =
        bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    final scrollable = Scrollable.of(context);
    final oldScrollable = _scrollable;
    _scrollable = scrollable;
    return scrollable.position != oldScrollable?.position;
  }
}
