import 'dart:async';
import 'dart:developer';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_reactions.dart';
import 'package:fluffychat/pangea/controllers/message_analytics_controller.dart';
import 'package:fluffychat/pangea/enum/activity_display_instructions_enum.dart';
import 'package:fluffychat/pangea/enum/activity_type_enum.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
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
  final Event _event;
  final Event? _nextEvent;
  final Event? _prevEvent;
  final PangeaMessageEvent _pangeaMessageEvent;
  final PangeaToken? _initialSelectedToken;

  const MessageSelectionOverlay({
    required this.chatController,
    required Event event,
    required PangeaMessageEvent pangeaMessageEvent,
    required PangeaToken? initialSelectedToken,
    required Event? nextEvent,
    required Event? prevEvent,
    super.key,
  })  : _initialSelectedToken = initialSelectedToken,
        _pangeaMessageEvent = pangeaMessageEvent,
        _nextEvent = nextEvent,
        _prevEvent = prevEvent,
        _event = event;

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

  List<PangeaToken>? tokens;
  bool initialized = false;

  PangeaMessageEvent get pangeaMessageEvent => widget._pangeaMessageEvent;

  final TtsController tts = TtsController();
  bool _isPlayingAudio = false;

  bool get showToolbarButtons => !widget._pangeaMessageEvent.isAudioMessage;

  int get activitiesLeftToComplete => messageAnalyticsEntry?.numActivities ?? 0;

  bool get isPracticeComplete => activitiesLeftToComplete <= 0;

  /// Decides whether an _initialSelectedToken should be used
  /// for a first practice activity on the word meaning
  PangeaToken? get _selectedTargetTokenForWordMeaning {
    // if there is no initial selected token, then we don't need to do anything
    if (widget._initialSelectedToken == null || messageAnalyticsEntry == null) {
      return null;
    }

    // should not already be involved in a hidden word activity
    final isInHiddenWordActivity =
        messageAnalyticsEntry!.isTokenInHiddenWordActivity(
      widget._initialSelectedToken!,
    );

    // whether the activity should generally be involved in an activity
    final shouldDoActivity = widget._initialSelectedToken!
        .shouldDoActivity(ActivityTypeEnum.wordMeaning);

    return !isInHiddenWordActivity && shouldDoActivity
        ? widget._initialSelectedToken
        : null;
  }

  @override
  void initState() {
    super.initState();

    _getTokens();
    _setupSubscriptions();

    if (_selectedTargetTokenForWordMeaning != null) {
      messageAnalyticsEntry?.addForWordMeaning(
        _selectedTargetTokenForWordMeaning!,
      );
    }

    debugPrint(
      "selected token: ${widget._initialSelectedToken?.text.content} total_xp:${widget._initialSelectedToken?.xp} vocab_construct_xp: ${widget._initialSelectedToken?.vocabConstruct.points} daysSincelastUseInWordMeaning ${widget._initialSelectedToken?.daysSinceLastUseByType(ActivityTypeEnum.wordMeaning)}",
    );
    debugPrint(
      "${widget._initialSelectedToken?.vocabConstruct.uses.map((u) => "${u.useType} ${u.timeStamp}").join(", ")}",
    );
  }

  void _setupSubscriptions() {
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: AppConfig.overlayAnimationDuration),
    );

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
  }

  MessageAnalyticsEntry? get messageAnalyticsEntry => tokens != null
      ? MatrixState.pangeaController.getAnalytics.perMessage.get(
          tokens!,
          pangeaMessageEvent,
        )
      : null;

  Future<void> _getTokens() async {
    try {
      final repEvent = pangeaMessageEvent.messageDisplayRepresentation;
      if (repEvent != null) {
        tokens = await repEvent.tokensGlobal(
          pangeaMessageEvent.senderId,
          pangeaMessageEvent.originServerTs,
        );
      }
    } catch (e, s) {
      ErrorHandler.logError(e: e, s: s);
    } finally {
      _setInitialToolbarMode();
      initialized = true;
      if (mounted) setState(() {});
    }
  }

  Future<void> _setInitialToolbarMode() async {
    if (widget._pangeaMessageEvent.isAudioMessage) {
      toolbarMode = MessageMode.speechToText;
      return setState(() {});
    }

    // 1) we're only going to do activities if we have tokens for the message
    // 2) if the user selects a span on initialization, then we want to give
    // them a practice activity on that word
    // 3) if the user has activities left to complete, then we want to give them
    if (tokens != null && activitiesLeftToComplete > 0) {
      return setState(() => toolbarMode = MessageMode.practiceActivity);
    }

    // Note: this setting is now hidden so this will always be false
    // leaving this here in case we want to bring it back
    if (MatrixState.pangeaController.userController.profile.userSettings
        .autoPlayMessages) {
      return setState(() => toolbarMode = MessageMode.textToSpeech);
    }

    setState(() => toolbarMode = MessageMode.translation);
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

  /// When an activity is completed, we need to update the state
  /// and check if the toolbar should be unlocked
  void onActivityFinish() {
    if (!mounted) return;
    _clearSelection();
    setState(() {});
  }

  /// In some cases, we need to exit the practice flow and let the user
  /// interact with the toolbar without completing activities
  void exitPracticeFlow() {
    messageAnalyticsEntry?.clearActivityQueue();
    _clearSelection();
    setState(() {});
  }

  void updateToolbarMode(MessageMode mode) {
    setState(() {
      toolbarMode = mode;
    });
  }

  void _clearSelection() {
    _selectedSpan = null;
    setState(() {});
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
        _isPlayingAudio) {
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

  bool get _hasReactions {
    final reactionsEvents = widget._pangeaMessageEvent.event.aggregatedEvents(
      widget.chatController.timeline!,
      RelationshipTypes.reaction,
    );
    return reactionsEvents.where((e) => !e.redacted).isNotEmpty;
  }

  double get _toolbarButtonsHeight =>
      showToolbarButtons ? AppConfig.toolbarButtonsHeight : 0;
  double get _reactionsHeight => _hasReactions ? 28 : 0;
  double get _belowMessageHeight => _toolbarButtonsHeight + _reactionsHeight;

  void setIsPlayingAudio(bool isPlaying) {
    if (mounted) {
      setState(() => _isPlayingAudio = isPlaying);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messageSize == null ||
        _messageOffset == null ||
        _screenHeight == null) {
      return;
    }

    // position the overlay directly over the underlying message
    final headerBottomOffset = _screenHeight! - _headerHeight;
    final footerBottomOffset = _footerHeight;
    final currentBottomOffset = _screenHeight! -
        _messageOffset!.dy -
        _messageSize!.height -
        (_mediaQuery?.padding.bottom ?? 0) -
        _belowMessageHeight;

    final bool hasHeaderOverflow =
        _messageOffset!.dy < (AppConfig.toolbarMaxHeight + _headerHeight);
    final bool hasFooterOverflow = _footerHeight > currentBottomOffset;

    if (!hasHeaderOverflow && !hasFooterOverflow) return;

    double scrollOffset = 0;
    double animationEndOffset = 0;

    final midpoint = (headerBottomOffset + footerBottomOffset) / 2;

    // if the overlay would have a footer overflow for this message,
    // check if shifting the overlay up could cause a header overflow
    final bottomOffsetDifference = _footerHeight - currentBottomOffset;
    final newTopOffset =
        _messageOffset!.dy - bottomOffsetDifference - _belowMessageHeight;
    final bool upshiftCausesHeaderOverflow = hasFooterOverflow &&
        newTopOffset < (_headerHeight + AppConfig.toolbarMaxHeight);

    if (hasHeaderOverflow || upshiftCausesHeaderOverflow) {
      animationEndOffset =
          midpoint - _messageSize!.height - _belowMessageHeight;
      final totalTopOffset = animationEndOffset +
          _messageSize!.height +
          AppConfig.toolbarMaxHeight;
      final remainingSpace = _screenHeight! - totalTopOffset;
      if (remainingSpace < _headerHeight) {
        // the overlay could run over the header, so it needs to be shifted down
        animationEndOffset -= (_headerHeight - remainingSpace);
      }
      scrollOffset = animationEndOffset - currentBottomOffset;
    } else if (hasFooterOverflow) {
      scrollOffset = _footerHeight - currentBottomOffset;
      animationEndOffset = _footerHeight;
    }

    // If, after ajusting the overlay position, the message still overflows the footer,
    // update the message height to fit the screen. The message is scrollable, so
    // this will make the both the toolbar box and the toolbar buttons visible.
    if (animationEndOffset < _footerHeight + _belowMessageHeight) {
      final double remainingSpace = _screenHeight! -
          AppConfig.toolbarMaxHeight -
          _headerHeight -
          _footerHeight -
          _belowMessageHeight;

      if (remainingSpace < _messageSize!.height) {
        _adjustedMessageHeight = remainingSpace;
      }

      animationEndOffset = _footerHeight;
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

  RenderBox? get _messageRenderBox {
    try {
      return MatrixState.pAnyState.getRenderBox(
        widget._event.eventId,
      );
    } catch (e, s) {
      ErrorHandler.logError(e: "Error getting message render box: $e", s: s);
      return null;
    }
  }

  Size? get _messageSize {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return null;
    }

    try {
      return _messageRenderBox?.size;
    } catch (e, s) {
      ErrorHandler.logError(e: "Error getting message size: $e", s: s);
      return null;
    }
  }

  Offset? get _messageOffset {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return null;
    }

    try {
      return _messageRenderBox?.localToGlobal(Offset.zero);
    } catch (e, s) {
      ErrorHandler.logError(e: "Error getting message offset: $e", s: s);
      return null;
    }
  }

  double? _adjustedMessageHeight;

  // height of the reply/forward bar + the reaction picker + contextual padding
  double get _footerHeight {
    return 56 +
        (FluffyThemes.isColumnMode(context) ? 16.0 : 8.0) +
        (_mediaQuery?.padding.bottom ?? 0);
  }

  MediaQueryData? get _mediaQuery {
    try {
      return MediaQuery.of(context);
    } catch (e, s) {
      ErrorHandler.logError(e: "Error getting media query: $e", s: s);
      return null;
    }
  }

  double get _headerHeight {
    return (Theme.of(context).appBarTheme.toolbarHeight ?? 56) +
        (_mediaQuery?.padding.top ?? 0);
  }

  double? get _screenHeight => _mediaQuery?.size.height;

  double? get _screenWidth => _mediaQuery?.size.width;

  @override
  Widget build(BuildContext context) {
    if (_messageSize == null) return const SizedBox.shrink();

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
    if (_screenWidth != null) {
      final chatViewWidth = _screenWidth! -
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
              height: _adjustedMessageHeight,
              child: OverlayMessage(
                pangeaMessageEvent,
                immersionMode:
                    widget.chatController.choreographer.immersionMode,
                controller: widget.chatController,
                overlayController: this,
                nextEvent: widget._nextEvent,
                prevEvent: widget._prevEvent,
                timeline: widget.chatController.timeline!,
                messageWidth: _messageSize!.width,
                messageHeight: _messageSize!.height,
              ),
            ),
            if (_hasReactions)
              Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  height: _reactionsHeight - 8,
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
        (widget._pangeaMessageEvent.ownMessage || _messageOffset == null)
            ? null
            : _messageOffset!.dx - horizontalPadding - columnOffset;

    final double? rightPadding = (widget._pangeaMessageEvent.ownMessage &&
            _screenWidth != null &&
            _messageOffset != null &&
            _messageSize != null)
        ? _screenWidth! -
            _messageOffset!.dx -
            _messageSize!.width -
            horizontalPadding
        : null;

    final positionedOverlayMessage = (_overlayPositionAnimation == null)
        ? (_screenHeight == null ||
                _messageSize == null ||
                _messageOffset == null)
            ? const SizedBox.shrink()
            : Positioned(
                left: leftPadding,
                right: rightPadding,
                bottom: _screenHeight! -
                    _messageOffset!.dy -
                    _messageSize!.height -
                    (_mediaQuery?.padding.bottom ?? 0) -
                    _belowMessageHeight,
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

    return SafeArea(
      child: Padding(
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
              type: MaterialType.transparency,
              child: OverlayHeader(controller: widget.chatController),
            ),
          ],
        ),
      ),
    );
  }
}
