import 'dart:developer';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message.dart';
import 'package:fluffychat/pages/chat/events/message_reactions.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/models/practice_activities.dart/practice_activity_model.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_footer.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_header.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  Animation<double>? _overlayPositionAnimation;

  MessageMode toolbarMode = MessageMode.translation;
  PangeaTokenText? _selectedSpan;

  /// The number of activities that need to be completed before the toolbar is unlocked
  /// If we don't have any good activities for them, we'll decrease this number
  static const int neededActivities = 3;

  int activitiesLeftToComplete = neededActivities;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: FluffyThemes.animationDuration,
    );

    activitiesLeftToComplete = activitiesLeftToComplete -
        widget._pangeaMessageEvent.numberOfActivitiesCompleted;

    setInitialToolbarMode();
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
    debugPrint('Exiting practice flow');
    clearSelection();
    activitiesLeftToComplete = 0;
    setState(() {});
  }

  Future<void> setInitialToolbarMode() async {
    if (widget._pangeaMessageEvent.isAudioMessage) {
      toolbarMode = MessageMode.speechToText;
      return;
    }

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
    if (toolbarMode == MessageMode.practiceActivity) {
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
        activity.multipleChoice?.spanDisplayDetails;

    if (span == null) {
      debugger(when: kDebugMode);
      return;
    }

    _selectedSpan = PangeaTokenText(
      offset: span.offset,
      length: span.length,
      content: widget._pangeaMessageEvent.messageDisplayText
          .substring(span.offset, span.offset + span.length),
    );

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (messageSize == null || messageOffset == null) {
      return;
    }

    // position the overlay directly over the underlying message
    final headerBottomOffset = screenHeight - headerHeight;
    final footerBottomOffset = footerHeight;
    final currentBottomOffset =
        screenHeight - messageOffset!.dy - messageSize!.height;

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
    final newTopOffset = messageOffset!.dy - bottomOffsetDifference;
    final bool upshiftCausesHeaderOverflow = hasFooterOverflow &&
        newTopOffset < (headerHeight + AppConfig.toolbarMaxHeight);

    if (hasHeaderOverflow || upshiftCausesHeaderOverflow) {
      animationEndOffset = midpoint - messageSize!.height;
      final totalTopOffset =
          animationEndOffset + messageSize!.height + AppConfig.toolbarMaxHeight;
      final remainingSpace = screenHeight - totalTopOffset;
      if (remainingSpace < headerHeight) {
        // the overlay could run over the header, so it needs to be shifted down
        animationEndOffset -= (headerHeight - remainingSpace);
      }
      scrollOffset = animationEndOffset - currentBottomOffset;
    } else if (hasFooterOverflow) {
      scrollOffset = footerHeight - currentBottomOffset;
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
      duration: FluffyThemes.animationDuration,
      curve: FluffyThemes.animationCurve,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  RenderBox? get messageRenderBox => MatrixState.pAnyState.getRenderBox(
        widget._event.eventId,
      );

  Size? get messageSize => messageRenderBox?.size;
  Offset? get messageOffset => messageRenderBox?.localToGlobal(Offset.zero);

  // height of the reply/forward bar + the reaction picker + contextual padding
  double get footerHeight =>
      48 + 56 + (FluffyThemes.isColumnMode(context) ? 16.0 : 8.0);

  double get headerHeight =>
      (Theme.of(context).appBarTheme.toolbarHeight ?? 56) +
      MediaQuery.of(context).padding.top;

  double get screenHeight => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    final bool showDetails = (Matrix.of(context)
                .store
                .getBool(SettingKeys.displayChatDetailsColumn) ??
            false) &&
        FluffyThemes.isThreeColumnMode(context) &&
        widget.chatController.room.membership == Membership.join;

    final overlayMessage = ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: FluffyThemes.columnWidth * 2.5,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: widget._pangeaMessageEvent.ownMessage
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: widget._pangeaMessageEvent.ownMessage
                        ? 0
                        : Avatar.defaultSize + 16,
                    right: widget._pangeaMessageEvent.ownMessage ? 8 : 0,
                  ),
                  child: MessageToolbar(
                    pangeaMessageEvent: widget._pangeaMessageEvent,
                    overLayController: this,
                  ),
                ),
              ],
            ),
            Message(
              widget._event,
              onSwipe: () => {},
              onInfoTab: (_) => {},
              onAvatarTab: (_) => {},
              scrollToEventId: (_) => {},
              onSelect: (_) => {},
              immersionMode: widget.chatController.choreographer.immersionMode,
              controller: widget.chatController,
              timeline: widget.chatController.timeline!,
              overlayController: this,
              animateIn: false,
              nextEvent: widget._nextEvent,
              previousEvent: widget._prevEvent,
            ),
            MessageReactions(widget._event, widget.chatController.timeline!),
          ],
        ),
      ),
    );

    final positionedOverlayMessage = _overlayPositionAnimation == null
        ? Positioned(
            left: 0,
            right: showDetails ? FluffyThemes.columnWidth : 0,
            bottom: screenHeight - messageOffset!.dy - messageSize!.height,
            child: Align(
              alignment: Alignment.center,
              child: overlayMessage,
            ),
          )
        : AnimatedBuilder(
            animation: _overlayPositionAnimation!,
            builder: (context, child) {
              return Positioned(
                left: 0,
                right: showDetails ? FluffyThemes.columnWidth : 0,
                bottom: _overlayPositionAnimation!.value,
                child: Align(
                  alignment: Alignment.center,
                  child: overlayMessage,
                ),
              );
            },
          );

    return Padding(
      padding: EdgeInsets.only(
        left: FluffyThemes.isColumnMode(context) ? 8.0 : 0.0,
        right: FluffyThemes.isColumnMode(context) ? 8.0 : 0.0,
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
