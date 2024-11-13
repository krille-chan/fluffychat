import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_reactions.dart';
import 'package:fluffychat/pangea/enum/activity_display_instructions_enum.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/pangea/widgets/chat/message_token_text.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar_buttons.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_footer.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_header.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_message.dart';
import 'package:fluffychat/pangea/widgets/chat/tts_controller.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:matrix/matrix.dart';

class MessageSelectionOverlay extends StatefulWidget {
  final ChatController chatController;
  late final Event _event;
  late final Event? _nextEvent;
  late final Event? _prevEvent;
  late final PangeaMessageEvent _pangeaMessageEvent;

  MessageSelectionOverlay({
    required this.chatController,
    required Event event,
    required PangeaMessageEvent pangeaMessageEvent,
    required Event? nextEvent,
    required Event? prevEvent,
    super.key,
  }) {
    _pangeaMessageEvent = pangeaMessageEvent;
    _nextEvent = nextEvent;
    _prevEvent = prevEvent;
    _event = event;
  }

  @override
  MessageOverlayController createState() => MessageOverlayController();
}

class MessageOverlayController extends State<MessageSelectionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  StreamSubscription? _reactionSubscription;
  Animation<double>? _overlayPositionAnimation;

  MessageMode toolbarMode = MessageMode.translation;
  PangeaTokenText? _selectedSpan;

  /// The number of activities that need to be completed before the toolbar is unlocked
  /// If we don't have any good activities for them, we'll decrease this number
  static const int neededActivities = 3;
  int activitiesLeftToComplete = neededActivities;

  bool get messageInUserL2 =>
      pangeaMessageEvent.messageDisplayLangCode ==
      MatrixState.pangeaController.languageController.userL2?.langCode;

  PangeaMessageEvent get pangeaMessageEvent => widget._pangeaMessageEvent;

  final TtsController tts = TtsController();
  bool isPlayingAudio = false;

  bool get showToolbarButtons => !widget._pangeaMessageEvent.isAudioMessage;

  List<PangeaToken>? tokens;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: AppConfig.overlayAnimationDuration),
    );

    _getTokens();

    activitiesLeftToComplete = activitiesLeftToComplete -
        widget._pangeaMessageEvent.numberOfActivitiesCompleted;

    _reactionSubscription =
        widget.chatController.room.client.onSync.stream.where(
      (update) {
        // check if this sync update has a reaction event or a
        // redaction (of a reaction event). If so, rebuild the overlay
        final room = widget.chatController.room;
        final timelineEvents = update.rooms?.join?[room.id]?.timeline?.events;
        if (timelineEvents == null) return false;

        final eventID = widget._pangeaMessageEvent.event.eventId;
        return timelineEvents.any(
          (e) =>
              e.type == EventTypes.Redaction ||
              (e.type == EventTypes.Reaction &&
                  Event.fromMatrixEvent(e, room).relationshipEventId ==
                      eventID),
        );
      },
    ).listen((_) => setState(() {}));

    tts.setupTTS();
    setInitialToolbarMode();
  }

  MessageTokenText get messageTokenText => MessageTokenText(
        ownMessage: pangeaMessageEvent.ownMessage,
        fullText: pangeaMessageEvent.messageDisplayText,
        tokensWithDisplay: tokens
            ?.map(
              (token) => TokenWithDisplayInstructions(
                token: token,
                highlight: isTokenSelected(token),
                //NOTE: we actually do want the controller to be aware of which
                // tokens are currently being involved in activities and adjust here
                hideContent: false,
              ),
            )
            .toList(),
        onClick: onClickOverlayMessageToken,
      );

  Future<void> _getTokens() async {
    tokens = pangeaMessageEvent.originalSent?.tokens;

    if (pangeaMessageEvent.originalSent != null && tokens == null) {
      pangeaMessageEvent.originalSent!
          .tokensGlobal(
        pangeaMessageEvent.senderId,
        pangeaMessageEvent.originServerTs,
      )
          .then((tokens) {
        // this isn't currently working because originalSent's _event is null
        setState(() => this.tokens = tokens);
      });
    }
  }

  /// We need to check if the setState call is safe to call immediately
  /// Kept getting the error: setState() or markNeedsBuild() called during build.
  /// This is a workaround to prevent that error
  @override
  void setState(VoidCallback fn) {
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (mounted &&
        (phase == SchedulerPhase.idle ||
            phase == SchedulerPhase.postFrameCallbacks)) {
      // It's safe to call setState immediately
      try {
        super.setState(fn);
      } catch (e, s) {
        ErrorHandler.logError(
          e: "Error calling setState in MessageSelectionOverlay: $e",
          s: s,
        );
      }
    } else {
      // Defer the setState call to after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          if (mounted) super.setState(fn);
        } catch (e, s) {
          ErrorHandler.logError(
            e: "Error calling setState in MessageSelectionOverlay after postframeCallback: $e",
            s: s,
          );
        }
      });
    }
  }

  bool get isPracticeComplete => activitiesLeftToComplete <= 0;

  /// When an activity is completed, we need to update the state
  /// and check if the toolbar should be unlocked
  void onActivityFinish() {
    if (!mounted) return;
    activitiesLeftToComplete -= 1;
    clearSelection();
    setState(() {});
  }

  /// In some cases, we need to exit the practice flow and let the user
  /// interact with the toolbar without completing activities
  void exitPracticeFlow() {
    clearSelection();
    activitiesLeftToComplete = 0;
    setState(() {});
  }

  Future<void> setInitialToolbarMode() async {
    if (widget._pangeaMessageEvent.isAudioMessage) {
      toolbarMode = MessageMode.speechToText;
      return;
    }
    // if (!messageInUserL2) {
    //   activitiesLeftToComplete = 0;
    //   toolbarMode = MessageMode.nullMode;
    //   return;
    // }

    if (activitiesLeftToComplete > 0) {
      toolbarMode = MessageMode.practiceActivity;
      return;
    }

    if (MatrixState.pangeaController.userController.profile.userSettings
        .autoPlayMessages) {
      toolbarMode = MessageMode.textToSpeech;
      return;
    }

    toolbarMode = MessageMode.translation;

    setState(() {});
  }

  updateToolbarMode(MessageMode mode) {
    setState(() {
      toolbarMode = mode;
    });
  }

  /// The text that the toolbar should target
  /// If there is no selectedSpan, then the whole message is the target
  /// If there is a selectedSpan, then the target is the selected text
  String get targetText {
    if (_selectedSpan == null) {
      return widget._pangeaMessageEvent.messageDisplayText;
    }

    return widget._pangeaMessageEvent.messageDisplayText.substring(
      _selectedSpan!.offset,
      _selectedSpan!.offset + _selectedSpan!.length,
    );
  }

  void onClickOverlayMessageToken(
    PangeaToken token,
  ) {
    if ([
          MessageMode.practiceActivity,
          // MessageMode.textToSpeech
        ].contains(toolbarMode) ||
        isPlayingAudio) {
      return;
    }

    // if there's no selected span, then select the token
    if (_selectedSpan == null) {
      _selectedSpan = token.text;
    } else {
      // if there is a selected span, then deselect the token if it's the same
      if (isTokenSelected(token)) {
        _selectedSpan = null;
      } else {
        // if there is a selected span but it is not the same, then select the token
        _selectedSpan = token.text;
      }
    }

    setState(() {});
  }

  void clearSelection() {
    _selectedSpan = null;
    setState(() {});
  }

  void setSelectedSpan(PracticeActivityModel activity) {
    final RelevantSpanDisplayDetails? span =
        activity.content.spanDisplayDetails;

    if (span == null) {
      debugger(when: kDebugMode);
      return;
    }

    if (span.displayInstructions != ActivityDisplayInstructionsEnum.nothing) {
      _selectedSpan = PangeaTokenText(
        offset: span.offset,
        length: span.length,
        content: widget._pangeaMessageEvent.messageDisplayText
            .substring(span.offset, span.offset + span.length),
      );
    } else {
      _selectedSpan = null;
    }

    setState(() {});
  }

  /// Whether the given token is currently selected
  bool isTokenSelected(PangeaToken token) {
    return _selectedSpan?.offset == token.text.offset &&
        _selectedSpan?.length == token.text.length;
  }

  /// Whether the overlay is currently displaying a selection
  bool get isSelection => _selectedSpan != null;

  PangeaTokenText? get selectedSpan => _selectedSpan;

  bool get hasReactions {
    final reactionsEvents = widget._pangeaMessageEvent.event.aggregatedEvents(
      widget.chatController.timeline!,
      RelationshipTypes.reaction,
    );
    return reactionsEvents.where((e) => !e.redacted).isNotEmpty;
  }

  double get toolbarButtonsHeight =>
      showToolbarButtons ? AppConfig.toolbarButtonsHeight : 0;
  double get reactionsHeight => hasReactions ? 28 : 0;
  double get belowMessageHeight => toolbarButtonsHeight + reactionsHeight;

  void setIsPlayingAudio(bool isPlaying) {
    if (mounted) {
      setState(() => isPlayingAudio = isPlaying);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (messageSize == null || messageOffset == null || screenHeight == null) {
      return;
    }

    // position the overlay directly over the underlying message
    final headerBottomOffset = screenHeight! - headerHeight;
    final footerBottomOffset = footerHeight;
    final currentBottomOffset = screenHeight! -
        messageOffset!.dy -
        messageSize!.height -
        belowMessageHeight;

    final bool hasHeaderOverflow =
        messageOffset!.dy < (AppConfig.toolbarMaxHeight + headerHeight);
    final bool hasFooterOverflow = footerHeight > currentBottomOffset;

    if (!hasHeaderOverflow && !hasFooterOverflow) return;

    double scrollOffset = 0;
    double animationEndOffset = 0;

    final midpoint = (headerBottomOffset + footerBottomOffset) / 2;

    // if the overlay would have a footer overflow for this message,
    // check if shifting the overlay up could cause a header overflow
    final bottomOffsetDifference = footerHeight - currentBottomOffset;
    final newTopOffset =
        messageOffset!.dy - bottomOffsetDifference - belowMessageHeight;
    final bool upshiftCausesHeaderOverflow = hasFooterOverflow &&
        newTopOffset < (headerHeight + AppConfig.toolbarMaxHeight);

    if (hasHeaderOverflow || upshiftCausesHeaderOverflow) {
      animationEndOffset = midpoint - messageSize!.height - belowMessageHeight;
      final totalTopOffset =
          animationEndOffset + messageSize!.height + AppConfig.toolbarMaxHeight;
      final remainingSpace = screenHeight! - totalTopOffset;
      if (remainingSpace < headerHeight) {
        // the overlay could run over the header, so it needs to be shifted down
        animationEndOffset -= (headerHeight - remainingSpace);
      }
      scrollOffset = animationEndOffset - currentBottomOffset;
    } else if (hasFooterOverflow) {
      scrollOffset = footerHeight - currentBottomOffset;
      animationEndOffset = footerHeight;
    }

    // If, after ajusting the overlay position, the message still overflows the footer,
    // update the message height to fit the screen. The message is scrollable, so
    // this will make the both the toolbar box and the toolbar buttons visible.
    if (animationEndOffset < footerHeight + belowMessageHeight) {
      final double remainingSpace = screenHeight! -
          AppConfig.toolbarMaxHeight -
          headerHeight -
          footerHeight -
          belowMessageHeight;

      if (remainingSpace < messageSize!.height) {
        adjustedMessageHeight = remainingSpace;
      }

      animationEndOffset = footerHeight;
    }

    _overlayPositionAnimation = Tween<double>(
      begin: currentBottomOffset,
      end: animationEndOffset,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: FluffyThemes.animationCurve,
      ),
    );

    widget.chatController.scrollController.animateTo(
      widget.chatController.scrollController.offset - scrollOffset,
      duration:
          const Duration(milliseconds: AppConfig.overlayAnimationDuration),
      curve: FluffyThemes.animationCurve,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _reactionSubscription?.cancel();
    tts.dispose();
    super.dispose();
  }

  RenderBox? get messageRenderBox {
    try {
      return MatrixState.pAnyState.getRenderBox(
        widget._event.eventId,
      );
    } catch (e, s) {
      ErrorHandler.logError(e: "Error getting message render box: $e", s: s);
      return null;
    }
  }

  Size? get messageSize {
    if (messageRenderBox == null || !messageRenderBox!.hasSize) {
      return null;
    }

    try {
      return messageRenderBox?.size;
    } catch (e, s) {
      ErrorHandler.logError(e: "Error getting message size: $e", s: s);
      return null;
    }
  }

  Offset? get messageOffset {
    if (messageRenderBox == null || !messageRenderBox!.hasSize) {
      return null;
    }

    try {
      return messageRenderBox?.localToGlobal(Offset.zero);
    } catch (e, s) {
      ErrorHandler.logError(e: "Error getting message offset: $e", s: s);
      return null;
    }
  }

  double? adjustedMessageHeight;

  // height of the reply/forward bar + the reaction picker + contextual padding
  double get footerHeight =>
      48 + 56 + (FluffyThemes.isColumnMode(context) ? 16.0 : 8.0);

  MediaQueryData? get mediaQuery {
    try {
      return MediaQuery.of(context);
    } catch (e, s) {
      ErrorHandler.logError(e: "Error getting media query: $e", s: s);
      return null;
    }
  }

  double get headerHeight =>
      (Theme.of(context).appBarTheme.toolbarHeight ?? 56) +
      (mediaQuery?.padding.top ?? 0);

  double? get screenHeight => mediaQuery?.size.height;

  double? get screenWidth => mediaQuery?.size.width;

  @override
  Widget build(BuildContext context) {
    if (messageSize == null) return const SizedBox.shrink();

    final bool showDetails = (Matrix.of(context)
                .store
                .getBool(SettingKeys.displayChatDetailsColumn) ??
            false) &&
        FluffyThemes.isThreeColumnMode(context) &&
        widget.chatController.room.membership == Membership.join;

    // the default spacing between the side of the screen and the message bubble
    const double messageMargin = Avatar.defaultSize + 16 + 8;
    final horizontalPadding = FluffyThemes.isColumnMode(context) ? 8.0 : 0.0;

    const totalMaxWidth = (FluffyThemes.columnWidth * 2.5) - messageMargin;
    double? maxWidth;
    if (screenWidth != null) {
      final chatViewWidth = screenWidth! -
          (FluffyThemes.isColumnMode(context)
              ? (FluffyThemes.columnWidth + FluffyThemes.navRailWidth)
              : 0);
      maxWidth = chatViewWidth - (2 * horizontalPadding) - messageMargin;
    }
    if (maxWidth == null || maxWidth > totalMaxWidth) {
      maxWidth = totalMaxWidth;
    }

    final overlayMessage = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: widget._pangeaMessageEvent.ownMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            MessageToolbar(
              pangeaMessageEvent: widget._pangeaMessageEvent,
              overLayController: this,
              ttsController: tts,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: adjustedMessageHeight,
              child: OverlayMessage(
                pangeaMessageEvent,
                immersionMode:
                    widget.chatController.choreographer.immersionMode,
                controller: widget.chatController,
                overlayController: this,
                nextEvent: widget._nextEvent,
                prevEvent: widget._prevEvent,
                timeline: widget.chatController.timeline!,
                messageWidth: messageSize!.width,
                messageHeight: messageSize!.height,
              ),
            ),
            if (hasReactions)
              Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  height: reactionsHeight - 8,
                  child: MessageReactions(
                    widget._pangeaMessageEvent.event,
                    widget.chatController.timeline!,
                  ),
                ),
              ),
            ToolbarButtons(
              overlayController: this,
              width: 250,
            ),
          ],
        ),
      ),
    );

    final columnOffset = FluffyThemes.isColumnMode(context)
        ? FluffyThemes.columnWidth + FluffyThemes.navRailWidth
        : 0;

    final double? leftPadding =
        (widget._pangeaMessageEvent.ownMessage || messageOffset == null)
            ? null
            : messageOffset!.dx - horizontalPadding - columnOffset;

    final double? rightPadding = (widget._pangeaMessageEvent.ownMessage &&
            screenWidth != null &&
            messageOffset != null &&
            messageSize != null)
        ? screenWidth! -
            messageOffset!.dx -
            messageSize!.width -
            horizontalPadding
        : null;

    final positionedOverlayMessage = (_overlayPositionAnimation == null)
        ? (screenHeight == null || messageSize == null || messageOffset == null)
            ? const SizedBox.shrink()
            : Positioned(
                left: leftPadding,
                right: rightPadding,
                bottom: screenHeight! -
                    messageOffset!.dy -
                    messageSize!.height -
                    belowMessageHeight,
                child: overlayMessage,
              )
        : AnimatedBuilder(
            animation: _overlayPositionAnimation!,
            builder: (context, child) {
              return Positioned(
                left: leftPadding,
                right: rightPadding,
                bottom: _overlayPositionAnimation!.value,
                child: overlayMessage,
              );
            },
          );

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      child: Stack(
        children: [
          positionedOverlayMessage,
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OverlayFooter(controller: widget.chatController),
                    ],
                  ),
                ),
                if (showDetails)
                  const SizedBox(
                    width: FluffyThemes.columnWidth,
                  ),
              ],
            ),
          ),
          Material(
            child: OverlayHeader(controller: widget.chatController),
          ),
        ],
      ),
    );
  }
}

class MessagePadding extends StatelessWidget {
  const MessagePadding({
    super.key,
    required this.child,
    required this.pangeaMessageEvent,
  });

  final Widget child;
  final PangeaMessageEvent pangeaMessageEvent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: pangeaMessageEvent.ownMessage ? 0 : Avatar.defaultSize + 16,
        right: pangeaMessageEvent.ownMessage ? 8 : 0,
      ),
      child: child,
    );
  }
}
