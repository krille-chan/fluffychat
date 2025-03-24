import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/events/event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/overlay_footer.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_center_content.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_header.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_button_column.dart';
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
  Animation<Offset>? _overlayOffsetAnimation;
  Animation<Offset>? _buttonsOffsetAnimation;
  Animation<Size>? _messageSizeAnimation;

  StreamSubscription? _reactionSubscription;

  /// if the message height is too tall to fit with the tools, adjust the message height
  double? _adjustedMessageHeight;

  Offset? _centeredMessageOffset;
  Size? _centeredMessageSize;
  final Completer _centeredMessageCompleter = Completer();

  Offset? _centeredButtonsOffset;
  Size? _centeredButtonsSize;
  final Completer _centeredButtonsCompleter = Completer();

  bool _finishedAnimation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: AppConfig.overlayAnimationDuration,
        // seconds: 5,
      ),
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

    Future.wait([
      _centeredMessageCompleter.future,
      _centeredButtonsCompleter.future,
    ]).then((_) => _startAnimation());
  }

  @override
  void didUpdateWidget(MessageSelectionPositioner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.overlayController.toolbarMode !=
        widget.overlayController.toolbarMode) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _reactionSubscription?.cancel();
    super.dispose();
  }

  void _setCenteredMessageSize(RenderBox renderBox) {
    if (_finishedAnimation) return;
    _centeredMessageSize = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _centeredMessageOffset = Offset(
      offset.dx - _columnWidth - _horizontalPadding - 2.0,
      _mediaQuery!.size.height -
          offset.dy -
          renderBox.size.height -
          _reactionsHeight,
    );
    setState(() {});

    if (!_centeredMessageCompleter.isCompleted) {
      _centeredMessageCompleter.complete();
    }
  }

  void _setCenteredButtonsSize(RenderBox renderBox) {
    if (_finishedAnimation) return;
    _centeredButtonsSize = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _centeredButtonsOffset = Offset(
      offset.dx - _columnWidth - _horizontalPadding - 2.0,
      offset.dy,
    );
    setState(() {});

    if (!_centeredButtonsCompleter.isCompleted) {
      _centeredButtonsCompleter.complete();
    }
  }

  void _startAnimation() {
    if (_mediaQuery == null) {
      return;
    }

    // if the message height is too tall to fit, adjust the message height
    if (_totalVerticalSpace! < _maxTotalToolbarHeight) {
      _adjustedMessageHeight = _totalVerticalSpace! -
          // one for within the toolbar itself, one for the top, and one for the bottom
          ((AppConfig.toolbarSpacing * 3) +
              _reactionsHeight +
              AppConfig.toolbarMaxHeight);
      _adjustedMessageHeight = max(_adjustedMessageHeight!, 0);
    }

    _overlayOffsetAnimation = Tween<Offset>(
      begin: Offset(
        _ownMessage ? _messageRightOffset : _messageLeftOffset,
        _totalToolbarBottomOffset,
      ),
      // For own messages, dx is the right offset. For other's messages, dx is the left offset.
      end: _centeredMessageOffset,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: FluffyThemes.animationCurve,
      ),
    );

    _buttonsOffsetAnimation = Tween<Offset>(
      begin: Offset(
        _ownMessage
            ? (_centeredButtonsSize!.width * -1)
            : _centeredButtonsSize!.width + _mediaQuery!.size.width,
        _totalToolbarBottomOffset,
      ),
      end: _centeredButtonsOffset,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: FluffyThemes.animationCurve,
      ),
    );

    _messageSizeAnimation = Tween<Size>(
      begin: Size(
        _messageSize.width,
        _messageHeight,
      ),
      end: _centeredMessageSize,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: FluffyThemes.animationCurve,
      ),
    );

    // _contentSizeAnimation = Tween<double>(
    //   begin: 0,
    //   end: 1,
    // ).animate(
    //   CurvedAnimation(
    //     parent: _animationController,
    //     curve: FluffyThemes.animationCurve,
    //   ),
    // );

    _animationController.forward().then((_) {
      _finishedAnimation = true;
      if (mounted) setState(() {});
    });
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

  bool get _showDetails =>
      (Matrix.of(context).store.getBool(SettingKeys.displayChatDetailsColumn) ??
          false) &&
      FluffyThemes.isThreeColumnMode(context) &&
      widget.chatController.room.membership == Membership.join;

  // screen size

  MediaQueryData? get _mediaQuery => _runWithLogging<MediaQueryData?>(
        () => MediaQuery.of(context),
        "Error getting media query",
        null,
      );

  double get _columnWidth => FluffyThemes.isColumnMode(context)
      ? (FluffyThemes.columnWidth + FluffyThemes.navRailWidth)
      : 0;

  // message size

  RenderBox? get _messageRenderBox => _runWithLogging<RenderBox?>(
        () => MatrixState.pAnyState.getRenderBox(
          widget.event.eventId,
        ),
        "Error getting message render box",
        null,
      );

  Size get _defaultMessageSize => const Size(FluffyThemes.columnWidth / 2, 100);
  Size get _messageSize {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return _defaultMessageSize;
    }

    return _runWithLogging(
      () => _messageRenderBox?.size,
      "Error getting message size",
      _defaultMessageSize,
    );
  }

  double get _messageHeight => _adjustedMessageHeight ?? _messageSize.height;

  //TODO: figure out where the 16 and 8 come from and use references instead of hard-coded values
  static const _messageDefaultLeftMargin = Avatar.defaultSize + 16 + 8;

  double get _toolbarMaxWidth {
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

  static const Offset _defaultMessageOffset =
      Offset(_messageDefaultLeftMargin, 300);
  Offset get _messageOffset {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return _defaultMessageOffset;
    }
    return _runWithLogging(
      () => _messageRenderBox?.localToGlobal(Offset.zero),
      "Error getting message offset",
      _defaultMessageOffset,
    );
  }

  double get _messageBottomOffset =>
      _mediaQuery!.size.height - _messageOffset.dy - _messageHeight;

  double get _messageLeftOffset => max(
        _messageOffset.dx - _columnWidth - _horizontalPadding,
        0,
      );

  double get _messageRightOffset {
    if (_mediaQuery == null || !_ownMessage) {
      return 0;
    }
    return _mediaQuery!.size.width -
        _messageOffset.dx -
        _messageSize.width -
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
    return AppConfig.readingAssistanceInputBarHeight +
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

  bool get _hasReactions {
    final reactionsEvents = widget.event.aggregatedEvents(
      widget.chatController.timeline!,
      RelationshipTypes.reaction,
    );
    return reactionsEvents.where((e) => !e.redacted).isNotEmpty;
  }

  double get _reactionsHeight => _hasReactions ? 28 : 0;

  double get _maxTotalCenterHeight =>
      _reactionsHeight +
      _messageHeight +
      AppConfig.toolbarSpacing +
      AppConfig.toolbarMaxHeight;

  double get _maxTotalToolbarHeight => _maxTotalCenterHeight;

  double get _totalToolbarBottomOffset =>
      _messageBottomOffset - _reactionsHeight;

  bool get _ownMessage =>
      widget.event.senderId == widget.event.room.client.userID;

  @override
  Widget build(BuildContext context) {
    if (_messageRenderBox == null || _mediaQuery == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: _horizontalPadding,
        right: _horizontalPadding,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: _finishedAnimation ? 1.0 : 0.0,
            child: OverlayCenterContent(
              event: widget.event,
              messageHeight: _messageHeight,
              messageWidth: _messageSize.width,
              toolbarMaxWidth: _toolbarMaxWidth,
              overlayController: widget.overlayController,
              chatController: widget.chatController,
              pangeaMessageEvent: widget.pangeaMessageEvent,
              nextEvent: widget.nextEvent,
              prevEvent: widget.prevEvent,
              showToolbarButtons: showToolbarButtons,
              hasReactions: _hasReactions,
              onChangeMessageSize: _setCenteredMessageSize,
              onChangeButtonsSize: _setCenteredButtonsSize,
              isTransitionAnimation: false,
            ),
          ),
          if (!_finishedAnimation)
            AnimatedBuilder(
              animation: _overlayOffsetAnimation ?? _animationController,
              builder: (context, child) {
                return Positioned(
                  left: _ownMessage
                      ? null
                      : (_overlayOffsetAnimation?.value)?.dx ??
                          _messageLeftOffset,
                  right: _ownMessage
                      ? (_overlayOffsetAnimation?.value)?.dx ??
                          _messageRightOffset
                      : null,
                  bottom: (_overlayOffsetAnimation?.value)?.dy ??
                      _totalToolbarBottomOffset,
                  child: OverlayCenterContent(
                    event: widget.event,
                    messageHeight: _messageHeight,
                    messageWidth: _messageSize.width,
                    toolbarMaxWidth: _toolbarMaxWidth,
                    overlayController: widget.overlayController,
                    chatController: widget.chatController,
                    pangeaMessageEvent: widget.pangeaMessageEvent,
                    nextEvent: widget.nextEvent,
                    prevEvent: widget.prevEvent,
                    showToolbarButtons: showToolbarButtons,
                    hasReactions: _hasReactions,
                    sizeAnimation: _messageSizeAnimation,
                    isTransitionAnimation: true,
                  ),
                );
              },
            ),
          if (!_finishedAnimation && _buttonsOffsetAnimation != null)
            AnimatedBuilder(
              animation: _buttonsOffsetAnimation!,
              builder: (context, child) {
                return Positioned(
                  left: (_buttonsOffsetAnimation?.value)!.dx,
                  top: _centeredButtonsOffset?.dy,
                  child: ToolbarButtonRow(
                    event: widget.event,
                    overlayController: widget.overlayController,
                    shouldShowToolbarButtons: showToolbarButtons,
                  ),
                );
              },
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ToolbarButtonRow(
                      //   event: widget.overlayController.pangeaMessageEvent!.event,
                      //   overlayController: widget.overlayController,
                      //   shouldShowToolbarButtons: showToolbarButtons,
                      // ),
                      OverlayFooter(
                        controller: widget.chatController,
                        overlayController: widget.overlayController,
                      ),
                      SizedBox(height: _mediaQuery?.padding.bottom ?? 0),
                    ],
                  ),
                ),
                if (_showDetails)
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
                widget.overlayController.toolbarMode.instructionsEnum != null
                    ? Container(
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                        ),
                        child: InstructionsInlineTooltip(
                          instructionsEnum: widget
                              .overlayController.toolbarMode.instructionsEnum!,
                          bold: true,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
