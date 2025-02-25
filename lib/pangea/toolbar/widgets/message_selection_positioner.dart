import 'dart:async';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message_reactions.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_toolbar.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_footer.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_header.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_message.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_button_and_progress_row.dart';
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
  late AnimationController _animationController;
  Animation<double>? _overlayPositionAnimation;

  StreamSubscription? _reactionSubscription;
  double? _adjustedMessageHeight;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    _reactionSubscription?.cancel();
    super.dispose();
  }

  dynamic _runWithLogging(
    Function runner,
    String errorMessage,
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
      return null;
    }
  }

  bool get showDetails =>
      (Matrix.of(context).store.getBool(SettingKeys.displayChatDetailsColumn) ??
          false) &&
      FluffyThemes.isThreeColumnMode(context) &&
      widget.chatController.room.membership == Membership.join;

  // screen size

  MediaQueryData? get _mediaQuery => _runWithLogging(
        () => MediaQuery.of(context),
        "Error getting media query",
      );

  double get _columnWidth => FluffyThemes.isColumnMode(context)
      ? (FluffyThemes.columnWidth + FluffyThemes.navRailWidth)
      : 0;

  // message size

  RenderBox? get _messageRenderBox => _runWithLogging(
        () => MatrixState.pAnyState.getRenderBox(
          widget.event.eventId,
        ),
        "Error getting message render box",
      );

  Size? get _messageSize {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return null;
    }

    return _runWithLogging(
      () => _messageRenderBox?.size,
      "Error getting message size",
    );
  }

  double get _messageHeight =>
      _adjustedMessageHeight ?? _messageSize?.height ?? 0;

  double get _messageMaxWidth {
    final double messageMargin =
        widget.event.isActivityMessage ? 0 : Avatar.defaultSize + 16 + 8;
    final bool showingDetails = widget.chatController.displayChatDetailsColumn;
    final double totalMaxWidth = (FluffyThemes.columnWidth * 2.5) -
        (showingDetails ? FluffyThemes.columnWidth : 0) -
        messageMargin;
    double? maxWidth;

    if (_mediaQuery != null) {
      final chatViewWidth = _mediaQuery!.size.width - _columnWidth;
      maxWidth = chatViewWidth - (2 * _horizontalPadding) - messageMargin;
    }

    if (maxWidth == null || maxWidth > totalMaxWidth) {
      maxWidth = totalMaxWidth;
    }

    return maxWidth;
  }

  // message offset

  Offset? get _messageOffset {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return null;
    }

    return _runWithLogging(
      () => _messageRenderBox?.localToGlobal(Offset.zero),
      "Error getting message offset",
    );
  }

  double? get _messageTopOffset {
    if (_messageOffset == null) {
      return null;
    }

    return _messageOffset!.dy -
        (_mediaQuery?.padding.top ?? 0) +
        (_mediaQuery?.viewPadding.top ?? 0);
  }

  double? get _messageBottomOffset {
    if (_messageOffset == null || _messageSize == null || _mediaQuery == null) {
      return null;
    }

    return _mediaQuery!.size.height - _messageOffset!.dy - _messageHeight;
  }

  double? get _messageLeftOffset {
    if (_messageOffset == null ||
        widget.event.senderId == widget.event.room.client.userID) {
      return null;
    }

    return _messageOffset!.dx - _columnWidth - _horizontalPadding;
  }

  double? get _messageRightOffset {
    if (_messageOffset == null ||
        _mediaQuery == null ||
        _messageSize == null ||
        widget.event.senderId != widget.event.room.client.userID) {
      return null;
    }

    return _mediaQuery!.size.width -
        _messageOffset!.dx -
        _messageSize!.width -
        _horizontalPadding;
  }

  // measurements for items around the toolbar

  double get _horizontalPadding =>
      FluffyThemes.isColumnMode(context) ? 8.0 : 0.0;

  double get _headerHeight {
    return (Theme.of(context).appBarTheme.toolbarHeight ??
            AppConfig.defaultHeaderHeight) +
        (_mediaQuery?.padding.top ?? 0);
  }

  double get _footerHeight {
    return AppConfig.defaultFooterHeight +
        16 +
        (FluffyThemes.isColumnMode(context) ? 16.0 : 8.0) +
        (_mediaQuery?.padding.bottom ?? 0);
  }

  double? get _totalVerticalSpace {
    if (_mediaQuery == null) {
      return null;
    }

    return _mediaQuery!.size.height - _headerHeight - _footerHeight;
  }

  // measurement for items in the toolbar

  bool get showToolbarButtons =>
      widget.pangeaMessageEvent != null &&
      widget.pangeaMessageEvent!.shouldShowToolbar &&
      widget.pangeaMessageEvent!.event.messageType == MessageTypes.Text;

  double get _toolbarButtonsHeight =>
      showToolbarButtons ? AppConfig.toolbarButtonsHeight : 0;

  bool get _hasReactions {
    final reactionsEvents = widget.event.aggregatedEvents(
      widget.chatController.timeline!,
      RelationshipTypes.reaction,
    );
    return reactionsEvents.where((e) => !e.redacted).isNotEmpty;
  }

  double get _reactionsHeight => _hasReactions ? 28 : 0;

  double get _maxTotalToolbarHeight =>
      _toolbarButtonsHeight +
      _reactionsHeight +
      _messageHeight +
      AppConfig.toolbarSpacing +
      AppConfig.toolbarMaxHeight;

  double get _totalToolbarTopOffset =>
      (_messageTopOffset ?? 0) -
      (AppConfig.toolbarSpacing + AppConfig.toolbarMaxHeight);

  double get _totalToolbarBottomOffset =>
      (_messageBottomOffset ?? 0) - (_toolbarButtonsHeight + _reactionsHeight);

  /// The remaining space between the top of the screen and the top of the toolbar.
  /// Negative if the toolbar is overflowing the top of the screen.
  double get _remainingTopSpace => _totalToolbarTopOffset - _headerHeight;

  /// The remaining space between the bottom of the screen and the bottom of the toolbar.
  /// Negative if the toolbar is overflowing the bottom of the screen.
  double get _remainingBottomSpace => _totalToolbarBottomOffset - _footerHeight;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messageSize == null || _messageOffset == null || _mediaQuery == null) {
      return;
    }

    final bool hasHeaderOverflow =
        _remainingTopSpace < AppConfig.toolbarSpacing;
    final bool hasFooterOverflow =
        _remainingBottomSpace < AppConfig.toolbarSpacing;

    if (!hasHeaderOverflow && !hasFooterOverflow || _mediaQuery == null) {
      return;
    }

    double adjustedBottomOffset = _totalToolbarBottomOffset;
    double scrollOffset = 0;

    // if the message height is too tall to fit, adjust the message height
    if (_totalVerticalSpace! < _maxTotalToolbarHeight) {
      _adjustedMessageHeight = _totalVerticalSpace! -
          // one for within the toolbar itself, one for the top, and one for the bottom
          ((AppConfig.toolbarSpacing * 3) +
              _reactionsHeight +
              _toolbarButtonsHeight +
              AppConfig.toolbarMaxHeight);
    }

    // if the overlay could have header overflow if the message wasn't shifted, we want to shift
    // it down so the bottom to give it enough space.
    if (hasHeaderOverflow) {
      // what is the distance between the current top offset of the toolbar and the desired top offset?
      final double currentTopOffset =
          (_messageTopOffset ?? 0) - AppConfig.toolbarMaxHeight;
      final double neededShift =
          (_headerHeight - currentTopOffset) + AppConfig.toolbarSpacing;
      adjustedBottomOffset = _totalToolbarBottomOffset - neededShift;
    } else if (hasFooterOverflow) {
      adjustedBottomOffset = _footerHeight + AppConfig.toolbarSpacing;
    }

    scrollOffset = adjustedBottomOffset - _totalToolbarBottomOffset;

    _overlayPositionAnimation = Tween<double>(
      begin: _totalToolbarBottomOffset,
      end: adjustedBottomOffset,
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
  Widget build(BuildContext context) {
    if (_messageSize == null) return const SizedBox.shrink();

    final positionedOverlayMessage = AnimatedBuilder(
      animation: _overlayPositionAnimation ?? _animationController,
      builder: (context, child) {
        return Positioned(
          left: _messageLeftOffset,
          right: _messageRightOffset,
          bottom: _overlayPositionAnimation?.value ?? _totalToolbarBottomOffset,
          child: ToolbarOverlay(
            messageHeight: _messageHeight,
            messageWidth: _messageSize!.width,
            maxWidth: _messageMaxWidth,
            event: widget.event,
            pangeaMessageEvent: widget.pangeaMessageEvent,
            nextEvent: widget.nextEvent,
            prevEvent: widget.prevEvent,
            overlayController: widget.overlayController,
            chatController: widget.chatController,
            hasReactions: _hasReactions,
            shouldShowToolbarButtons: showToolbarButtons,
          ),
        );
      },
    );

    return Padding(
      padding: EdgeInsets.only(
        left: _horizontalPadding,
        right: _horizontalPadding,
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
                      OverlayFooter(
                        controller: widget.chatController,
                        overlayController: widget.overlayController,
                      ),
                      SizedBox(height: _mediaQuery?.padding.bottom ?? 0),
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
            child: Column(
              children: [
                SizedBox(height: _mediaQuery?.padding.top ?? 0),
                OverlayHeader(controller: widget.chatController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ToolbarOverlay extends StatelessWidget {
  final double messageHeight;
  final double messageWidth;
  final double maxWidth;

  final Event event;
  final Event? nextEvent;
  final Event? prevEvent;

  final bool hasReactions;
  final bool shouldShowToolbarButtons;

  final PangeaMessageEvent? pangeaMessageEvent;
  final MessageOverlayController overlayController;
  final ChatController chatController;

  const ToolbarOverlay({
    super.key,
    required this.messageHeight,
    required this.messageWidth,
    required this.maxWidth,
    required this.event,
    required this.overlayController,
    required this.chatController,
    required this.hasReactions,
    required this.shouldShowToolbarButtons,
    this.pangeaMessageEvent,
    this.nextEvent,
    this.prevEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: event.senderId == event.room.client.userID
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (pangeaMessageEvent != null &&
                pangeaMessageEvent!.shouldShowToolbar)
              MessageToolbar(
                pangeaMessageEvent: pangeaMessageEvent!,
                overlayController: overlayController,
              ),
            const SizedBox(height: AppConfig.toolbarSpacing),
            SizedBox(
              height: messageHeight,
              child: OverlayMessage(
                event,
                pangeaMessageEvent: pangeaMessageEvent,
                immersionMode: chatController.choreographer.immersionMode,
                controller: chatController,
                overlayController: overlayController,
                nextEvent: nextEvent,
                prevEvent: prevEvent,
                timeline: chatController.timeline!,
                messageWidth: messageWidth,
                messageHeight: messageHeight,
              ),
            ),
            if (hasReactions)
              Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                  height: 20,
                  child: MessageReactions(
                    event,
                    chatController.timeline!,
                  ),
                ),
              ),
            if (shouldShowToolbarButtons)
              ToolbarButtonAndProgressRow(
                event: event,
                overlayController: overlayController,
              ),
          ],
        ),
      ),
    );
  }
}
