import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/enums/reading_assistance_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/reading_assistance_input_bar.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/over_message_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_mode_transition_animation.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_card_switcher.dart';
import 'package:fluffychat/utils/adaptive_bottom_sheet.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Controls positioning of the message overlay.
class MessageSelectionPositioner extends StatefulWidget {
  final MessageOverlayController overlayController;
  final ChatController chatController;
  final Event event;

  final PangeaMessageEvent? pangeaMessageEvent;
  final PangeaToken? initialSelectedToken;
  final Event? nextEvent;
  final Event? prevEvent;

  const MessageSelectionPositioner({
    required this.overlayController,
    required this.chatController,
    required this.event,
    this.pangeaMessageEvent,
    this.initialSelectedToken,
    this.nextEvent,
    this.prevEvent,
    super.key,
  });

  @override
  MessageSelectionPositionerState createState() =>
      MessageSelectionPositionerState();
}

class MessageSelectionPositionerState extends State<MessageSelectionPositioner>
    with TickerProviderStateMixin {
  StreamSubscription? _reactionSubscription;
  StreamSubscription? _contentChangedSubscription;

  ScrollController? scrollController;

  bool finishedTransition = false;
  bool startedTransition = false;

  ReadingAssistanceMode readingAssistanceMode =
      ReadingAssistanceMode.selectMode;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(
      onAttach: (position) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            scrollController?.jumpTo(
              scrollController!.position.maxScrollExtent,
            );
          }
        });
      },
    );

    _reactionSubscription =
        widget.chatController.room.client.onSync.stream.where(
      (update) {
        // check if this sync update has a reaction event or a
        // redaction (of a reaction event). If so, rebuild the overlay
        final room = widget.chatController.room;
        final timelineEvents = update.rooms?.join?[room.id]?.timeline?.events;
        if (timelineEvents == null) return false;

        final eventID = widget.event.eventId;
        return timelineEvents.any(
          (e) =>
              e.type == EventTypes.Redaction ||
              (e.type == EventTypes.Reaction &&
                  Event.fromMatrixEvent(e, room).relationshipEventId ==
                      eventID),
        );
      },
    ).listen((_) => setState(() {}));

    _contentChangedSubscription = widget
        .overlayController.contentChangedStream.stream
        .listen(_onContentSizeChanged);
  }

  @override
  void dispose() {
    _reactionSubscription?.cancel();
    _contentChangedSubscription?.cancel();
    scrollController?.dispose();
    MatrixState.pangeaController.matrixState.audioPlayer
      ?..stop()
      ..dispose();
    super.dispose();
  }

  T _runWithLogging<T>(
    Function runner,
    String errorMessage,
    T defaultValue,
  ) {
    try {
      return runner();
    } catch (e, s) {
      ErrorHandler.logError(
        e: "$errorMessage: $e",
        s: s,
        data: {
          "eventID": widget.event.eventId,
        },
      );
      return defaultValue;
    }
  }

  final Duration transitionAnimationDuration =
      const Duration(milliseconds: 300);

  final Offset _defaultMessageOffset =
      const Offset(Avatar.defaultSize + 16 + 8, 300);

  double get _horizontalPadding =>
      FluffyThemes.isColumnMode(context) ? 8.0 : 0.0;

  bool get hasReactions {
    final reactionsEvents = widget.event.aggregatedEvents(
      widget.chatController.timeline!,
      RelationshipTypes.reaction,
    );
    return reactionsEvents.where((e) => !e.redacted).isNotEmpty;
  }

  double get reactionsHeight => hasReactions ? 32.0 : 0.0;

  bool get ownMessage =>
      widget.event.senderId == widget.event.room.client.userID;

  bool get showDetails =>
      AppSettings.displayChatDetailsColumn.getItem(Matrix.of(context).store) &&
      FluffyThemes.isThreeColumnMode(context) &&
      widget.chatController.room.membership == Membership.join;

  MediaQueryData? get mediaQuery => _runWithLogging<MediaQueryData?>(
        () => MediaQuery.of(context),
        "Error getting media query",
        null,
      );

  double get columnWidth => FluffyThemes.isColumnMode(context)
      ? (FluffyThemes.columnWidth + FluffyThemes.navRailWidth + 1.0)
      : 0;

  double get _toolbarMaxWidth {
    const double messageMargin = 16.0;
    // widget.event.isActivityMessage ? 0 : Avatar.defaultSize + 16 + 8;
    final bool showingDetails = widget.chatController.displayChatDetailsColumn;
    final double totalMaxWidth = FluffyThemes.maxTimelineWidth -
        (showingDetails ? FluffyThemes.columnWidth : 0) -
        messageMargin;
    double? maxWidth;

    if (mediaQuery != null) {
      final chatViewWidth = mediaQuery!.size.width - columnWidth;
      maxWidth = chatViewWidth - (2 * _horizontalPadding) - messageMargin;
    }

    if (maxWidth == null || maxWidth > totalMaxWidth) {
      maxWidth = totalMaxWidth;
    }

    return maxWidth;
  }

  Size get _defaultMessageSize => const Size(FluffyThemes.columnWidth / 2, 100);

  RenderBox? get _overlayMessageRenderBox => _runWithLogging<RenderBox?>(
        () => MatrixState.pAnyState.getRenderBox(
          'overlay_message_${widget.event.eventId}',
        ),
        "Error getting overlay message render box",
        null,
      );

  Size? get _overlayMessageSize => _overlayMessageRenderBox?.size;

  Offset? get overlayMessageOffset {
    if (_overlayMessageRenderBox == null ||
        !_overlayMessageRenderBox!.hasSize) {
      return null;
    }
    return _runWithLogging(
      () => _overlayMessageRenderBox?.localToGlobal(Offset.zero),
      "Error getting overlay message offset",
      null,
    );
  }

  RenderBox? get _messageRenderBox => _runWithLogging<RenderBox?>(
        () => MatrixState.pAnyState.getRenderBox(
          widget.event.eventId,
        ),
        "Error getting message render box",
        null,
      );

  Offset get _originalMessageOffset {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return _defaultMessageOffset;
    }
    return _runWithLogging(
      () => _messageRenderBox?.localToGlobal(Offset.zero),
      "Error getting message offset",
      _defaultMessageOffset,
    );
  }

  /// The size of the message in the chat list (as opposed to the expanded size in the center overlay)
  Size get originalMessageSize {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return _defaultMessageSize;
    }

    return _runWithLogging(
      () => _messageRenderBox?.size,
      "Error getting message size",
      _defaultMessageSize,
    );
  }

  double? get messageLeftOffset {
    if (ownMessage) return null;
    return max(_originalMessageOffset.dx - columnWidth, 0);
  }

  double? get messageRightOffset {
    if (mediaQuery == null || !ownMessage) return null;
    return mediaQuery!.size.width -
        _originalMessageOffset.dx -
        originalMessageSize.width -
        (showDetails ? FluffyThemes.columnWidth : 0);
  }

  double get _contentHeight {
    final messageHeight =
        _overlayMessageSize?.height ?? originalMessageSize.height;
    return messageHeight + reactionsHeight + AppConfig.toolbarMenuHeight + 4.0;
  }

  double get overheadContentHeight {
    return (widget.pangeaMessageEvent != null &&
                widget.overlayController.selectedToken != null
            ? AppConfig.toolbarMaxHeight
            : 40.0) +
        4.0;
  }

  double? get _wordCardLeftOffset {
    if (ownMessage) return null;
    if (widget.pangeaMessageEvent != null &&
        widget.overlayController.selectedToken != null &&
        mediaQuery != null &&
        (mediaQuery!.size.width < _toolbarMaxWidth + messageLeftOffset!)) {
      return mediaQuery!.size.width - _toolbarMaxWidth - 8.0;
    }
    return messageLeftOffset;
  }

  double get _fullContentHeight {
    return _contentHeight + overheadContentHeight;
  }

  double? get _screenHeight {
    if (mediaQuery == null) return null;
    return mediaQuery!.size.height -
        mediaQuery!.padding.bottom -
        mediaQuery!.padding.top;
  }

  bool get shouldScroll {
    if (_screenHeight == null) return false;
    return _fullContentHeight > _screenHeight!;
  }

  bool get _hasFooterOverflow {
    if (_screenHeight == null) return false;
    final bottomOffset = _originalMessageOffset.dy + _contentHeight;
    return bottomOffset > _screenHeight!;
  }

  double get spaceBelowContent {
    if (shouldScroll) return 0;
    if (_hasFooterOverflow) return 0;

    final messageHeight = originalMessageSize.height;
    final originalContentHeight =
        messageHeight + reactionsHeight + AppConfig.toolbarMenuHeight + 4.0;

    final screenHeight = mediaQuery!.size.height - mediaQuery!.padding.bottom;

    final boxHeight =
        screenHeight - _originalMessageOffset.dy - originalContentHeight;

    if (boxHeight + _fullContentHeight > screenHeight) {
      return screenHeight - _fullContentHeight;
    }

    return screenHeight - _originalMessageOffset.dy - originalContentHeight;
  }

  void _onContentSizeChanged(_) {
    Future.delayed(FluffyThemes.animationDuration, () {
      if (mounted) setState(() {});
    });
  }

  void onStartedTransition() {
    if (mounted) {
      setState(() {
        startedTransition = true;
      });
    }
  }

  void onFinishedTransition() {
    if (mounted) {
      setState(() {
        finishedTransition = true;
      });
    }
  }

  void setReadingAssistanceMode(ReadingAssistanceMode mode) {
    if (mounted) {
      setState(() => readingAssistanceMode = mode);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_messageRenderBox == null || mediaQuery == null) {
      return const SizedBox.shrink();
    }

    widget.overlayController.maxWidth = _toolbarMaxWidth;
    return SafeArea(
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: mediaQuery!.size.width -
                    columnWidth -
                    (showDetails ? FluffyThemes.columnWidth : 0),
                height: _screenHeight!,
                child: Stack(
                  alignment:
                      ownMessage ? Alignment.centerRight : Alignment.centerLeft,
                  children: [
                    if (!startedTransition) ...[
                      OverMessageOverlay(controller: this),
                      if (shouldScroll)
                        Positioned(
                          top: 0,
                          left: _wordCardLeftOffset,
                          right: messageRightOffset,
                          child: WordCardSwitcher(controller: this),
                        ),
                    ],
                    if (readingAssistanceMode ==
                        ReadingAssistanceMode.practiceMode) ...[
                      CenteredMessage(
                        targetId:
                            "overlay_center_message_${widget.event.eventId}",
                        controller: this,
                      ),
                      PracticeModeTransitionAnimation(
                        targetId:
                            "overlay_center_message_${widget.event.eventId}",
                        controller: this,
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 20,
                        child: ReadingAssistanceInputBar(
                          widget.chatController,
                          widget.overlayController,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (showDetails)
            const SizedBox(
              width: FluffyThemes.columnWidth,
            ),
        ],
      ),
    );
  }
}

class MessageReactionPicker extends StatelessWidget {
  final ChatController chatController;
  const MessageReactionPicker({
    super.key,
    required this.chatController,
  });

  @override
  Widget build(BuildContext context) {
    if (chatController.selectedEvents.length != 1) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final sentReactions = <String>{};
    final event = chatController.selectedEvents.first;
    sentReactions.addAll(
      event
          .aggregatedEvents(
            chatController.timeline!,
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

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(
        AppConfig.borderRadius,
      ),
      shadowColor: theme.colorScheme.surface.withAlpha(128),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 40.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...AppConfig.defaultReactions.map(
                (emoji) => IconButton(
                  padding: EdgeInsets.zero,
                  icon: Center(
                    child: Opacity(
                      opacity: sentReactions.contains(
                        emoji,
                      )
                          ? 0.33
                          : 1,
                      child: Text(
                        emoji,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onPressed: sentReactions.contains(emoji)
                      ? null
                      : () => event.room.sendReaction(
                            event.eventId,
                            emoji,
                          ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_reaction_outlined,
                ),
                tooltip: L10n.of(context).customReaction,
                onPressed: () async {
                  final emoji = await showAdaptiveBottomSheet<String>(
                    context: context,
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text(
                          L10n.of(context).customReaction,
                        ),
                        leading: CloseButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pop(
                            null,
                          ),
                        ),
                      ),
                      body: SizedBox(
                        height: double.infinity,
                        child: EmojiPicker(
                          onEmojiSelected: (
                            _,
                            emoji,
                          ) =>
                              Navigator.of(
                            context,
                          ).pop(
                            emoji.emoji,
                          ),
                          config: Config(
                            emojiViewConfig: const EmojiViewConfig(
                              backgroundColor: Colors.transparent,
                            ),
                            bottomActionBarConfig: const BottomActionBarConfig(
                              enabled: false,
                            ),
                            categoryViewConfig: CategoryViewConfig(
                              initCategory: Category.SMILEYS,
                              backspaceColor: theme.colorScheme.primary,
                              iconColor: theme.colorScheme.primary.withAlpha(
                                128,
                              ),
                              iconColorSelected: theme.colorScheme.primary,
                              indicatorColor: theme.colorScheme.primary,
                              backgroundColor: theme.colorScheme.surface,
                            ),
                            skinToneConfig: SkinToneConfig(
                              dialogBackgroundColor: Color.lerp(
                                theme.colorScheme.surface,
                                theme.colorScheme.primaryContainer,
                                0.75,
                              )!,
                              indicatorColor: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                  if (emoji == null) return;
                  if (sentReactions.contains(emoji)) return;
                  await event.room.sendReaction(
                    event.eventId,
                    emoji,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
