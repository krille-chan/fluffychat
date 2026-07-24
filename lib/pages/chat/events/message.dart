// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/utils/date_time_extension.dart';
import 'package:fluffychat/utils/file_description.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/utils/string_color.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/member_actions_popup_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matrix/matrix.dart';
import 'package:swipe_to_action/swipe_to_action.dart';

import '../../../config/app_config.dart';
import 'message_content.dart';
import 'message_reactions.dart';
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
  final void Function(String eventId)? enterThread;
  final bool longPressSelect;
  final bool selected;
  final bool singleSelected;
  final Timeline timeline;
  final bool highlightMarker;
  final bool animateIn;
  final bool wallpaperMode;
  final ScrollController scrollController;
  final List<Color> colors;
  final void Function()? onExpand;
  final bool isCollapsed;
  final Set<String> bigEmojis;

  const Message(
    this.event, {
    this.nextEvent,
    this.previousEvent,
    this.displayReadMarker = false,
    this.longPressSelect = false,
    required this.bigEmojis,
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
    this.wallpaperMode = false,
    required this.onMention,
    required this.scrollController,
    required this.colors,
    this.onExpand,
    required this.enterThread,
    this.isCollapsed = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!{
      EventTypes.Message,
      EventTypes.Sticker,
      EventTypes.CallInvite,
      PollEventContent.startType,
    }.contains(event.type)) {
      if (event.type.startsWith('m.call.')) {
        return const SizedBox.shrink();
      }
      return StateMessage(event, onExpand: onExpand, isCollapsed: isCollapsed);
    }

    if (event.type == EventTypes.Message &&
        event.messageType == EventTypes.KeyVerificationRequest) {
      return StateMessage(event);
    }

    final client = Matrix.of(context).client;
    final ownMessage = event.senderId == client.userID;
    final alignment = ownMessage ? Alignment.topRight : Alignment.topLeft;

    var color = theme.colorScheme.surfaceContainerHigh;
    final displayTime =
        event.type == EventTypes.RoomCreate ||
        previousEvent == null ||
        !event.originServerTs.sameEnvironment(previousEvent!.originServerTs);

    final nextEventSameSender =
        nextEvent != null &&
        {EventTypes.Message, EventTypes.Sticker}.contains(nextEvent!.type) &&
        nextEvent!.senderId == event.senderId &&
        nextEvent!.originServerTs.sameEnvironment(event.originServerTs);

    final previousEventSameSender =
        previousEvent != null &&
        {
          EventTypes.Message,
          EventTypes.Sticker,
        }.contains(previousEvent!.type) &&
        previousEvent!.senderId == event.senderId &&
        previousEvent!.originServerTs.sameEnvironment(event.originServerTs);

    final textColor = ownMessage
        ? theme.onBubbleColor
        : theme.colorScheme.onSurface;

    final linkColor = ownMessage
        ? theme.brightness == Brightness.light
              ? theme.colorScheme.primaryFixed
              : theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.primary;

    final rowMainAxisAlignment = ownMessage
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    final displayEvent = event.getDisplayEvent(timeline);
    const hardCorner = Radius.circular(3);
    const roundedCorner = Radius.circular(AppConfig.borderRadius);
    final borderRadius = BorderRadius.only(
      topLeft: !ownMessage ? hardCorner : roundedCorner,
      topRight: ownMessage && nextEventSameSender ? hardCorner : roundedCorner,
      bottomLeft: !ownMessage && previousEventSameSender
          ? hardCorner
          : roundedCorner,
      bottomRight: ownMessage ? hardCorner : roundedCorner,
    );
    const avatarSize = Avatar.defaultSize;
    final noBubble =
        ({
          MessageTypes.Video,
          MessageTypes.Image,
          MessageTypes.Sticker,
        }.contains(event.messageType) &&
        event.fileDescription == null &&
        !event.redacted);

    if (ownMessage) {
      color = displayEvent.status.isError
          ? Colors.redAccent
          : theme.bubbleColor;
    }

    final sentReactions = <String>{};
    if (singleSelected) {
      sentReactions.addAll(
        event
            .aggregatedEvents(timeline, RelationshipTypes.reaction)
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

    final hasReactions = event.hasAggregatedEvents(
      timeline,
      RelationshipTypes.reaction,
    );

    final threadChildren = event.aggregatedEvents(
      timeline,
      RelationshipTypes.thread,
    );
    final isEdited = event.hasAggregatedEvents(
      timeline,
      RelationshipTypes.edit,
    );

    final showReactionPicker =
        singleSelected && event.room.canSendDefaultMessages;

    final enterThread = this.enterThread;
    final sender = event.senderFromMemoryOrFallback;

    final wallpaperTextShadow = !wallpaperMode
        ? null
        : [
            Shadow(
              offset: Offset(0.0, 0.0),
              blurRadius: 2,
              color: theme.colorScheme.surface,
            ),
          ];
    final eventStateTextColor = theme.colorScheme.onSurface;

    return Center(
      child: Swipeable(
        key: ValueKey(event.transactionId ?? event.eventId),
        background: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Center(child: Icon(Icons.check_outlined)),
        ),
        direction: AppSettings.swipeRightToLeftToReply.value
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
            top: nextEventSameSender ? 1.0 : 8.0,
            bottom: previousEventSameSender || previousEvent == null
                ? 1.0
                : 8.0,
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: ownMessage ? .end : .start,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: InkWell(
                      hoverColor: longPressSelect ? Colors.transparent : null,
                      enableFeedback: !selected,
                      onTap: longPressSelect ? null : () => onSelect(event),
                      borderRadius: BorderRadius.circular(
                        AppConfig.borderRadius / 2,
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(
                          AppConfig.borderRadius / 2,
                        ),
                        color: selected || highlightMarker
                            ? theme.colorScheme.secondaryContainer.withAlpha(
                                128,
                              )
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: rowMainAxisAlignment,
                    children: [
                      if (longPressSelect && !event.redacted)
                        SizedBox(
                          height: avatarSize,
                          width: avatarSize,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            tooltip: L10n.of(context).select,
                            icon: Icon(
                              selected
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                            ),
                            onPressed: () => onSelect(event),
                          ),
                        )
                      else if (nextEventSameSender || ownMessage)
                        SizedBox(width: avatarSize)
                      else
                        FutureBuilder<User?>(
                          future: event.fetchSenderUser(),
                          builder: (context, snapshot) {
                            final user = snapshot.data ?? sender;
                            return Avatar(
                              mxContent: user.avatarUrl,
                              name: user.calcDisplayname(),
                              onTap: () => showMemberActionsPopupMenu(
                                context: context,
                                user: user,
                                onMention: onMention,
                              ),
                              size: avatarSize,
                              presenceUserId: user.stateKey,
                              presenceBackgroundColor: wallpaperMode
                                  ? Colors.transparent
                                  : null,
                            );
                          },
                        ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          mainAxisSize: .min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: ownMessage ? .end : .start,
                                children: [
                                  if (sender.powerLevel.role !=
                                          PowerLevelRole.user &&
                                      !nextEventSameSender &&
                                      !ownMessage &&
                                      !event.room.isDirectChat)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 2.0,
                                      ),
                                      child: Icon(
                                        sender.powerLevel.role ==
                                                PowerLevelRole.moderator
                                            ? Icons.add_moderator_outlined
                                            : Icons.admin_panel_settings,
                                        size: 14,
                                        color: theme
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                  if ((!nextEventSameSender) && !ownMessage)
                                    FutureBuilder<User?>(
                                      future: event.fetchSenderUser(),
                                      builder: (context, snapshot) {
                                        final displayname =
                                            snapshot.data?.calcDisplayname() ??
                                            sender.calcDisplayname();
                                        return ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: 200,
                                          ),
                                          child: Text(
                                            displayname,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: event.room.isDirectChat
                                                  ? Colors.transparent
                                                  : (theme.brightness ==
                                                            Brightness.light
                                                        ? displayname
                                                              .colorScheme
                                                              .primary
                                                        : displayname
                                                              .colorScheme
                                                              .primaryContainer),
                                              fontSize: 11,
                                              shadows: wallpaperTextShadow,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),

                            Container(
                              alignment: alignment,
                              padding: const EdgeInsets.only(left: 8),
                              child: GestureDetector(
                                onDoubleTap: AppSettings.doubleTapToReact.value && event.room.canSendDefaultMessages
                                    ? () {
                                        HapticFeedback.lightImpact();
                                        final emoji = AppSettings.doubleTapReaction.value;
                                        final existingReaction = event
                                            .aggregatedEvents(
                                              timeline,
                                              RelationshipTypes.reaction,
                                            )
                                            .firstWhereOrNull(
                                              (e) =>
                                                  e.senderId ==
                                                      event.room.client.userID &&
                                                  e.content
                                                          .tryGetMap<
                                                            String,
                                                            Object?
                                                          >('m.relates_to')
                                                          ?.tryGet<String>('key') ==
                                                      emoji,
                                            );
                                        if (existingReaction != null) {
                                          existingReaction.redactEvent();
                                        } else {
                                          event.room.sendReaction(
                                            event.eventId,
                                            emoji,
                                          );
                                        }
                                      }
                                    : null,
                                onLongPress: longPressSelect
                                    ? null
                                    : () {
                                        HapticFeedback.heavyImpact();
                                        onSelect(event);
                                      },
                                child: _AnimateIn(
                                  key: ValueKey(
                                    event.transactionId ?? event.eventId,
                                  ),
                                  animateIn: animateIn,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: noBubble
                                          ? Colors.transparent
                                          : color,
                                      borderRadius: borderRadius,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: BubbleBackground(
                                      colors: colors,
                                      ignore:
                                          noBubble ||
                                          !ownMessage ||
                                          MediaQuery.highContrastOf(context),
                                      scrollController: scrollController,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            AppConfig.borderRadius,
                                          ),
                                        ),
                                        constraints: const BoxConstraints(
                                          maxWidth:
                                              FluffyThemes.columnWidth * 1.5,
                                        ),
                                        child: Column(
                                          mainAxisSize: .min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            if (event.inReplyToEventId(
                                                  includingFallback: false,
                                                ) !=
                                                null)
                                              FutureBuilder<Event?>(
                                                future: event.getReplyEvent(
                                                  timeline,
                                                ),
                                                builder: (BuildContext context, snapshot) {
                                                  final replyEvent =
                                                      snapshot.hasData
                                                      ? snapshot.data!
                                                      : Event(
                                                          eventId:
                                                              event
                                                                  .inReplyToEventId() ??
                                                              '\$fake_event_id',
                                                          content: {
                                                            'msgtype': 'm.text',
                                                            'body': '...',
                                                          },
                                                          senderId:
                                                              event.senderId,
                                                          type:
                                                              'm.room.message',
                                                          room: event.room,
                                                          status:
                                                              EventStatus.sent,
                                                          originServerTs:
                                                              DateTime.now(),
                                                        );
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 8,
                                                        ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      borderRadius: ReplyContent
                                                          .borderRadius,
                                                      child: InkWell(
                                                        borderRadius:
                                                            ReplyContent
                                                                .borderRadius,
                                                        onTap: () =>
                                                            scrollToEventId(
                                                              replyEvent
                                                                  .eventId,
                                                            ),
                                                        child: AbsorbPointer(
                                                          child: ReplyContent(
                                                            replyEvent,
                                                            ownMessage:
                                                                ownMessage,
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
                                              onInfoTab: onInfoTab,
                                              borderRadius: borderRadius,
                                              timeline: timeline,
                                              selected: selected,
                                              bigEmojis: bigEmojis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            AnimatedSize(
                              duration: FluffyThemes.animationDuration,
                              curve: FluffyThemes.animationCurve,
                              alignment: Alignment.bottomCenter,
                              child: !hasReactions
                                  ? const SizedBox.shrink()
                                  : Container(
                                      alignment: ownMessage
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                        top: 1.0,
                                        left: 8.0,
                                        right: ownMessage ? 0 : 12.0,
                                      ),
                                      child: MessageReactions(event, timeline),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: ownMessage ? .end : .start,
                              children: [
                                const SizedBox(width: 8),
                                if (event.status.isSent &&
                                    (displayTime ||
                                        !previousEventSameSender ||
                                        selected))
                                  Text(
                                    ' ${selected ? event.originServerTs.localizedDetailedTime(context) : event.originServerTs.localizedTimeOfDay(context)}',
                                    style: TextStyle(
                                      color: eventStateTextColor,
                                      fontSize: 11,
                                      shadows: wallpaperTextShadow,
                                    ),
                                  ),
                                if (isEdited) ...[
                                  Text(' ', style: TextStyle(fontSize: 11)),
                                  Text(
                                    L10n.of(context).edited,
                                    style: TextStyle(
                                      color: eventStateTextColor,
                                      fontSize: 11,
                                      shadows: wallpaperTextShadow,
                                    ),
                                  ),
                                ],
                                if (event.status == EventStatus.error) ...[
                                  Text(' ', style: TextStyle(fontSize: 11)),
                                  Text(
                                    L10n.of(context).couldNotBeSent,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.error,
                                      shadows: wallpaperTextShadow,
                                    ),
                                  ),
                                  Text(' ', style: TextStyle(fontSize: 11)),
                                  Icon(
                                    Icons.error_outlined,
                                    size: 14,
                                    color: theme.colorScheme.error,
                                    shadows: wallpaperTextShadow,
                                  ),
                                ],
                                if (event.status == EventStatus.sending) ...[
                                  Text(
                                    switch (event.fileSendingStatus) {
                                      null => L10n.of(context).sending,
                                      FileSendingStatus.generatingThumbnail =>
                                        L10n.of(context).generatingThumbnail,
                                      FileSendingStatus.encrypting => L10n.of(
                                        context,
                                      ).encrypting,
                                      FileSendingStatus.uploading => L10n.of(
                                        context,
                                      ).uploading,
                                    },
                                    style: TextStyle(
                                      color: eventStateTextColor,
                                      fontSize: 11,
                                      shadows: wallpaperTextShadow,
                                    ),
                                  ),
                                  Text(' ', style: TextStyle(fontSize: 11)),
                                  SizedBox.square(
                                    dimension: 11,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Align(
                              alignment: ownMessage
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft,
                              child: AnimatedSize(
                                duration: FluffyThemes.animationDuration,
                                curve: FluffyThemes.animationCurve,
                                child: showReactionPicker
                                    ? Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Material(
                                          elevation: 4,
                                          borderRadius: BorderRadius.circular(
                                            AppConfig.borderRadius,
                                          ),
                                          shadowColor: theme.colorScheme.surface
                                              .withAlpha(128),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: .min,
                                              children: [
                                                ...AppConfig.defaultReactions.map(
                                                  (emoji) => IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: Center(
                                                      child: Opacity(
                                                        opacity:
                                                            sentReactions
                                                                .contains(emoji)
                                                            ? 0.33
                                                            : 1,
                                                        child: Text(
                                                          emoji,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 20,
                                                              ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed:
                                                        sentReactions.contains(
                                                          emoji,
                                                        )
                                                        ? null
                                                        : () {
                                                            onSelect(event);
                                                            event.room
                                                                .sendReaction(
                                                                  event.eventId,
                                                                  emoji,
                                                                );
                                                          },
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.add_reaction_outlined,
                                                  ),
                                                  tooltip: L10n.of(
                                                    context,
                                                  ).customReaction,
                                                  onPressed: () async {
                                                    final emoji = await showAdaptiveBottomSheet<String>(
                                                      context: context,
                                                      builder: (context) => Scaffold(
                                                        appBar: AppBar(
                                                          title: Text(
                                                            L10n.of(
                                                              context,
                                                            ).customReaction,
                                                          ),
                                                          leading: CloseButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                  context,
                                                                ).pop(null),
                                                          ),
                                                        ),
                                                        body: SizedBox(
                                                          height:
                                                              double.infinity,
                                                          child: EmojiPicker(
                                                            onEmojiSelected:
                                                                (_, emoji) =>
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop(
                                                                      emoji
                                                                          .emoji,
                                                                    ),
                                                            config: Config(
                                                              locale:
                                                                  Localizations.localeOf(
                                                                    context,
                                                                  ),
                                                              emojiViewConfig:
                                                                  const EmojiViewConfig(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                  ),
                                                              bottomActionBarConfig:
                                                                  const BottomActionBarConfig(
                                                                    enabled:
                                                                        false,
                                                                  ),
                                                              categoryViewConfig: CategoryViewConfig(
                                                                initCategory:
                                                                    Category
                                                                        .SMILEYS,
                                                                backspaceColor: theme
                                                                    .colorScheme
                                                                    .primary,
                                                                iconColor: theme
                                                                    .colorScheme
                                                                    .primary
                                                                    .withAlpha(
                                                                      128,
                                                                    ),
                                                                iconColorSelected:
                                                                    theme
                                                                        .colorScheme
                                                                        .primary,
                                                                indicatorColor: theme
                                                                    .colorScheme
                                                                    .primary,
                                                                backgroundColor:
                                                                    theme
                                                                        .colorScheme
                                                                        .surface,
                                                              ),
                                                              skinToneConfig: SkinToneConfig(
                                                                dialogBackgroundColor: Color.lerp(
                                                                  theme
                                                                      .colorScheme
                                                                      .surface,
                                                                  theme
                                                                      .colorScheme
                                                                      .primaryContainer,
                                                                  0.75,
                                                                )!,
                                                                indicatorColor: theme
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                    if (emoji == null) {
                                                      return;
                                                    }
                                                    if (sentReactions.contains(
                                                      emoji,
                                                    )) {
                                                      return;
                                                    }
                                                    onSelect(event);

                                                    await event.room
                                                        .sendReaction(
                                                          event.eventId,
                                                          emoji,
                                                        );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (enterThread != null)
                AnimatedSize(
                  duration: FluffyThemes.animationDuration,
                  curve: FluffyThemes.animationCurve,
                  alignment: Alignment.bottomCenter,
                  child: threadChildren.isEmpty
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(
                            top: 2.0,
                            bottom: 8.0,
                            left: avatarSize + 8,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: FluffyThemes.columnWidth * 1.5,
                            ),
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                foregroundColor:
                                    theme.colorScheme.onSecondaryContainer,
                                backgroundColor:
                                    theme.colorScheme.secondaryContainer,
                              ),
                              onPressed: () => enterThread(event.eventId),
                              icon: const Icon(Icons.message),
                              label: Text(
                                '${L10n.of(context).countReplies(threadChildren.length)} | ${threadChildren.first.calcLocalizedBodyFallback(MatrixLocals(L10n.of(context)), withSenderNamePrefix: true)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
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
                        borderRadius: BorderRadius.circular(
                          AppConfig.borderRadius / 3,
                        ),
                        color: theme.colorScheme.surface.withAlpha(128),
                      ),
                      child: Text(
                        L10n.of(context).readUpToHere,
                        style: TextStyle(fontSize: 11),
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

    final origin = bubbleBox.localToGlobal(
      Offset.zero,
      ancestor: scrollableBox,
    );
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

class _AnimateIn extends StatefulWidget {
  final bool animateIn;
  final Widget child;
  const _AnimateIn({required this.animateIn, required this.child, super.key});

  @override
  State<_AnimateIn> createState() => __AnimateInState();
}

class __AnimateInState extends State<_AnimateIn> {
  bool _animationFinished = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.animateIn) return widget.child;
    if (!_animationFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _animationFinished = true;
        });
      });
    }

    return AnimatedSize(
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
      child: _animationFinished ? widget.child : const SizedBox.shrink(),
    );
  }
}
