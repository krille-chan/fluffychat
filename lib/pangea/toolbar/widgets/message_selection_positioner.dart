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
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/reading_assistance_input_row/overlay_footer.dart';
import 'package:fluffychat/pangea/toolbar/widgets/measure_render_box.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_center_content.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_header.dart';
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
  Animation<Size>? _messageSizeAnimation;

  StreamSubscription? _reactionSubscription;

  Offset? _centeredMessageOffset;
  Size? _centeredMessageSize;

  Size? _tooltipSize;
  Size? _inputBarSize;

  final Completer _centeredMessageCompleter = Completer();
  final Completer _tooltipCompleter = Completer();

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
      if (showToolbarButtons) _tooltipCompleter.future,
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

  void _setTooltipSize(RenderBox renderBox) {
    setState(() {
      _tooltipSize = renderBox.size;
    });

    if (!_tooltipCompleter.isCompleted) {
      _tooltipCompleter.complete();
    }
  }

  void _setInputBarSize(RenderBox renderBox) {
    setState(() => _inputBarSize = renderBox.size);
  }

  void _startAnimation() {
    if (_mediaQuery == null) {
      return;
    }

    _overlayOffsetAnimation = Tween<Offset>(
      begin: Offset(
        _ownMessage ? _messageRightOffset : _messageLeftOffset,
        _messageBottomOffset - _reactionsHeight,
      ),
      // For own messages, dx is the right offset. For other's messages, dx is the left offset.
      end: _adjustedCenteredMessageOffset,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: FluffyThemes.animationCurve,
      ),
    );

    _messageSizeAnimation = Tween<Size>(
      begin: Size(
        _messageSize.width,
        _originalMessageHeight,
      ),
      end: _adjustedCenteredMessageSize,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: FluffyThemes.animationCurve,
      ),
    );

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

  double get _originalMessageHeight => _messageSize.height;

  double? get _centerSpace {
    if (_mediaQuery == null) return null;
    return _mediaQuery!.size.height - _headerHeight - _footerHeight;
  }

  bool get _centeredMessageHasOverflow {
    if (_centerSpace == null ||
        _centeredMessageSize == null ||
        _centeredMessageOffset == null) {
      return false;
    }

    final finalMessageHeight = _centeredMessageSize!.height + _reactionsHeight;
    return finalMessageHeight > _centerSpace!;
  }

  Size? get _adjustedCenteredMessageSize {
    if (_centeredMessageHasOverflow) {
      return Size(
        _centeredMessageSize!.width,
        _centerSpace! - (AppConfig.toolbarSpacing * 2),
      );
    }
    return _centeredMessageSize;
  }

  Offset? get _adjustedCenteredMessageOffset {
    if (_centeredMessageHasOverflow) {
      return Offset(
        _centeredMessageOffset!.dx,
        _footerHeight + AppConfig.toolbarSpacing,
      );
    }
    return _centeredMessageOffset;
  }

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
      _mediaQuery!.size.height - _messageOffset.dy - _originalMessageHeight;

  double? get _centeredMessageTopOffset {
    if (_mediaQuery == null ||
        _adjustedCenteredMessageOffset == null ||
        _adjustedCenteredMessageSize == null) {
      return null;
    }
    return _mediaQuery!.size.height -
        _adjustedCenteredMessageOffset!.dy -
        _adjustedCenteredMessageSize!.height -
        _reactionsHeight;
  }

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
    return (_inputBarSize?.height ??
            (showToolbarButtons ? AppConfig.toolbarButtonsHeight : 0)) +
        (_mediaQuery?.padding.bottom ?? 0);
  }

  // measurement for items in the toolbar

  bool get showToolbarButtons =>
      widget.pangeaMessageEvent != null &&
      widget.pangeaMessageEvent!.shouldShowToolbar &&
      widget.pangeaMessageEvent!.event.messageType == MessageTypes.Text &&
      widget.pangeaMessageEvent!.messageDisplayLangIsL2;

  bool get _hasReactions {
    final reactionsEvents = widget.event.aggregatedEvents(
      widget.chatController.timeline!,
      RelationshipTypes.reaction,
    );
    return reactionsEvents.where((e) => !e.redacted).isNotEmpty;
  }

  double get _reactionsHeight => _hasReactions ? 28 : 0;

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
          Column(
            children: [
              Material(
                type: MaterialType.transparency,
                child: Column(
                  children: [
                    SizedBox(height: _mediaQuery?.padding.top ?? 0),
                    OverlayHeader(controller: widget.chatController),
                  ],
                ),
              ),
              const Expanded(
                flex: 3,
                child: SizedBox.shrink(),
              ),
              Opacity(
                opacity: _finishedAnimation ? 1.0 : 0.0,
                child: OverlayCenterContent(
                  event: widget.event,
                  messageHeight: null,
                  messageWidth: null,
                  // messageHeight: _adjustedCenteredMessageSize?.height,
                  // messageWidth: _adjustedCenteredMessageSize?.width,
                  maxWidth: _toolbarMaxWidth,
                  overlayController: widget.overlayController,
                  chatController: widget.chatController,
                  pangeaMessageEvent: widget.pangeaMessageEvent,
                  nextEvent: widget.nextEvent,
                  prevEvent: widget.prevEvent,
                  hasReactions: _hasReactions,
                  onChangeMessageSize: _setCenteredMessageSize,
                  isTransitionAnimation: false,
                  transitionAnimationFinished: _finishedAnimation,
                  maxHeight: _mediaQuery!.size.height -
                      _headerHeight -
                      _footerHeight -
                      AppConfig.toolbarSpacing * 2,
                ),
              ),
              const Expanded(
                flex: 1,
                child: SizedBox.shrink(),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MeasureRenderBox(
                          onChange: _setInputBarSize,
                          child: OverlayFooter(
                            controller: widget.chatController,
                            overlayController: widget.overlayController,
                            showToolbarButtons: showToolbarButtons,
                          ),
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
            ],
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
                      _messageBottomOffset - _reactionsHeight,
                  child: OverlayCenterContent(
                    event: widget.event,
                    messageHeight: _originalMessageHeight,
                    messageWidth: _messageSize.width,
                    maxWidth: _toolbarMaxWidth,
                    overlayController: widget.overlayController,
                    chatController: widget.chatController,
                    pangeaMessageEvent: widget.pangeaMessageEvent,
                    nextEvent: widget.nextEvent,
                    prevEvent: widget.prevEvent,
                    hasReactions: _hasReactions,
                    sizeAnimation: _messageSizeAnimation,
                    isTransitionAnimation: true,
                    transitionAnimationFinished: _finishedAnimation,
                    maxHeight: _mediaQuery!.size.height -
                        _headerHeight -
                        _footerHeight -
                        AppConfig.toolbarSpacing * 2,
                  ),
                );
              },
            ),
          if (showToolbarButtons)
            Positioned(
              top: 0,
              child: IgnorePointer(
                child: MeasureRenderBox(
                  onChange: _setTooltipSize,
                  child: Opacity(
                    opacity: 0.0,
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: 200.0,
                        maxWidth: _toolbarMaxWidth,
                      ),
                      child: InstructionsInlineTooltip(
                        instructionsEnum: widget.overlayController.toolbarMode
                                .instructionsEnum ??
                            InstructionsEnum.readingAssistanceOverview,
                        bold: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (_centeredMessageTopOffset != null && _tooltipSize != null)
            Positioned(
              top: max(
                ((_headerHeight + _centeredMessageTopOffset!) / 2) -
                    (_tooltipSize!.height / 2),
                _headerHeight,
              ),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 200.0,
                  maxWidth: _toolbarMaxWidth,
                ),
                child: InstructionsInlineTooltip(
                  instructionsEnum:
                      widget.overlayController.toolbarMode.instructionsEnum ??
                          InstructionsEnum.readingAssistanceOverview,
                  bold: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
