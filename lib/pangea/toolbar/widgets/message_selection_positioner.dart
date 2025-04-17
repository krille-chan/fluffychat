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
import 'package:fluffychat/pangea/events/models/pangea_token_model.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_inline_tooltip.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/enums/reading_assistance_mode_enum.dart';
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

  Offset? _centeredMessageOffset;
  Size? _centeredMessageSize;

  Size? _tooltipSize;

  final Completer _centeredMessageCompleter = Completer();
  final Completer _tooltipCompleter = Completer();

  MessageMode _currentMode = MessageMode.noneSelected;
  ReadingAssistanceMode? _readingAssistanceMode;

  Animation<Offset>? _overlayOffsetAnimation;
  Animation<Size>? _messageSizeAnimation;
  Offset? _currentOffset;

  StreamSubscription? _reactionSubscription;

  final _animationDuration = const Duration(
    milliseconds: AppConfig.overlayAnimationDuration,
    // seconds: 5,
  );

  @override
  void initState() {
    super.initState();
    _currentMode = widget.overlayController.toolbarMode;
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _centeredMessageCompleter.future;
      if (!mounted) return;

      setState(() {
        _currentOffset = Offset(
          _ownMessage ? _messageRightOffset : _messageLeftOffset,
          _originalMessageBottomOffset - _reactionsHeight,
        );
      });

      _setReadingAssistanceMode(
        widget.initialSelectedToken == null
            ? ReadingAssistanceMode.messageMode
            : ReadingAssistanceMode.tokenMode,
      );
    });
  }

  @override
  void didUpdateWidget(MessageSelectionPositioner oldWidget) {
    super.didUpdateWidget(oldWidget);
    final mode = widget.overlayController.toolbarMode;
    if (mode != _currentMode) {
      if (_currentMode == MessageMode.noneSelected) {
        _setReadingAssistanceMode(ReadingAssistanceMode.messageMode);
      }
      setState(() => _currentMode = mode);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _reactionSubscription?.cancel();
    super.dispose();
  }

  void _setCenteredMessageSize(RenderBox renderBox) {
    if (_centeredMessageCompleter.isCompleted) return;

    _centeredMessageSize = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _centeredMessageOffset = Offset(
      offset.dx - _columnWidth - _horizontalPadding - 2.0,
      _mediaQuery!.size.height -
          offset.dy -
          renderBox.size.height -
          _reactionsHeight +
          ((AppConfig.messageModeInputBarHeight -
                  AppConfig.tokenModeInputBarHeight) *
              0.75),
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

  Future<void> _setReadingAssistanceMode(ReadingAssistanceMode mode) async {
    if (mode == _readingAssistanceMode) {
      return;
    }

    await _centeredMessageCompleter.future;

    if (mode == ReadingAssistanceMode.messageMode) {
      setState(
        () => _readingAssistanceMode = ReadingAssistanceMode.transitionMode,
      );
    } else if (mode == ReadingAssistanceMode.tokenMode) {
      setState(
        () => _readingAssistanceMode = ReadingAssistanceMode.tokenMode,
      );
    }

    if (mode == ReadingAssistanceMode.tokenMode) {
      _overlayOffsetAnimation = Tween<Offset>(
        begin: _currentOffset,
        end: _adjustedOriginalMessageOffset,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: FluffyThemes.animationCurve,
        ),
      )..addListener(() {
          if (mounted) {
            setState(() => _currentOffset = _overlayOffsetAnimation?.value);
          }
        });
    } else if (mode == ReadingAssistanceMode.messageMode) {
      _overlayOffsetAnimation = Tween<Offset>(
        begin: _currentOffset,
        end: _centeredMessageOffset!,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: FluffyThemes.animationCurve,
        ),
      )..addListener(() {
          if (mounted) {
            setState(() => _currentOffset = _overlayOffsetAnimation?.value);
          }
        });

      _messageSizeAnimation = Tween<Size>(
        begin: Size(
          _originalMessageSize.width,
          _originalMessageSize.height,
        ),
        end: _adjustedCenteredMessageSize,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: FluffyThemes.animationCurve,
        ),
      );
    }

    await _animationController.forward(from: 0);
    if (mounted) setState(() => _readingAssistanceMode = mode);
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

  double get _inputBarSize =>
      _readingAssistanceMode == ReadingAssistanceMode.messageMode ||
              _readingAssistanceMode == ReadingAssistanceMode.transitionMode
          ? AppConfig.messageModeInputBarHeight
          : AppConfig.tokenModeInputBarHeight;

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

  /// Available vertical space not taken up by the header and footer
  double? get _verticalSpace {
    if (_mediaQuery == null) return null;
    return _mediaQuery!.size.height - _headerHeight - _footerHeight;
  }

  double get _toolbarMaxWidth {
    const double messageMargin = 16.0;
    // widget.event.isActivityMessage ? 0 : Avatar.defaultSize + 16 + 8;
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

  // original message size and offset

  RenderBox? get _messageRenderBox => _runWithLogging<RenderBox?>(
        () => MatrixState.pAnyState.getRenderBox(
          widget.event.eventId,
        ),
        "Error getting message render box",
        null,
      );

  Size get _defaultMessageSize => const Size(FluffyThemes.columnWidth / 2, 100);

  /// The size of the message in the chat list (as opposed to the expanded size in the center overlay)
  Size get _originalMessageSize {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return _defaultMessageSize;
    }

    return _runWithLogging(
      () => _messageRenderBox?.size,
      "Error getting message size",
      _defaultMessageSize,
    );
  }

  static const _messageDefaultLeftMargin = Avatar.defaultSize + 16 + 8;

  // Centered message size and offset

  bool get _centeredMessageHasOverflow {
    if (_verticalSpace == null ||
        _centeredMessageSize == null ||
        _centeredMessageOffset == null) {
      return false;
    }

    final finalMessageHeight = _centeredMessageSize!.height + _reactionsHeight;
    return finalMessageHeight > _verticalSpace!;
  }

  /// Size of the centered overlay message adjusted for overflow
  Size? get _adjustedCenteredMessageSize {
    if (_centeredMessageHasOverflow) {
      return Size(
        _centeredMessageSize!.width,
        _verticalSpace! - (AppConfig.toolbarSpacing * 2),
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

  // message offset

  static const Offset _defaultMessageOffset =
      Offset(_messageDefaultLeftMargin, 300);

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

  Offset get _adjustedOriginalMessageOffset {
    if (_messageRenderBox == null || !_messageRenderBox!.hasSize) {
      return _defaultMessageOffset;
    }

    final topOffset = _originalMessageOffset.dy;
    final bottomOffset = _originalMessageBottomOffset;
    final hasHeaderOverflow =
        topOffset < (_headerHeight + AppConfig.toolbarSpacing);
    final hasFooterOverflow =
        bottomOffset < (_footerHeight + AppConfig.toolbarSpacing);

    if (!hasHeaderOverflow && !hasFooterOverflow) {
      return Offset(
        _ownMessage ? _messageRightOffset : _messageLeftOffset,
        _originalMessageBottomOffset - _reactionsHeight,
      );
    }

    if (hasHeaderOverflow) {
      final difference = topOffset - (_headerHeight + AppConfig.toolbarSpacing);
      double newBottomOffset = _mediaQuery!.size.height -
          _originalMessageOffset.dy +
          difference -
          _originalMessageSize.height;
      if (newBottomOffset < _footerHeight + AppConfig.toolbarSpacing) {
        newBottomOffset = _footerHeight + AppConfig.toolbarSpacing;
      }

      return Offset(
        _ownMessage ? _messageRightOffset : _messageLeftOffset,
        newBottomOffset,
      );
    } else {
      final difference =
          bottomOffset - (_footerHeight + AppConfig.toolbarSpacing);
      return Offset(
        _ownMessage ? _messageRightOffset : _messageLeftOffset,
        _mediaQuery!.size.height -
            (_originalMessageOffset.dy + difference) -
            _originalMessageSize.height,
      );
    }
  }

  double get _originalMessageBottomOffset =>
      _mediaQuery!.size.height -
      _originalMessageOffset.dy -
      _originalMessageSize.height;

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
        _originalMessageOffset.dx - _columnWidth - _horizontalPadding,
        0,
      );

  double get _messageRightOffset {
    if (_mediaQuery == null || !_ownMessage) {
      return 0;
    }
    return _mediaQuery!.size.width -
        _originalMessageOffset.dx -
        _originalMessageSize.width -
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
    return _inputBarSize + (_mediaQuery?.padding.bottom ?? 0);
  }

  // measurement for items in the toolbar

  bool get showToolbarButtons =>
      (widget.pangeaMessageEvent?.shouldShowToolbar ?? false) &&
      widget.pangeaMessageEvent?.event.messageType == MessageTypes.Text &&
      (widget.pangeaMessageEvent?.messageDisplayLangIsL2 ?? false);

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

  double get _readingAssistanceModeOpacity {
    switch (_readingAssistanceMode) {
      case ReadingAssistanceMode.messageMode:
      case ReadingAssistanceMode.transitionMode:
        return 0.8;
      case ReadingAssistanceMode.tokenMode:
      case null:
        return 0.4;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_messageRenderBox == null || _mediaQuery == null) {
      return const SizedBox.shrink();
    }

    widget.overlayController.maxWidth = _toolbarMaxWidth;

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              duration: _animationDuration,
              opacity: _readingAssistanceModeOpacity,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Padding(
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
                    opacity: _readingAssistanceMode ==
                            ReadingAssistanceMode.messageMode
                        ? 1.0
                        : 0.0,
                    child: OverlayCenterContent(
                      event: widget.event,
                      messageHeight: null,
                      messageWidth: null,
                      maxWidth: widget.overlayController.maxWidth,
                      overlayController: widget.overlayController,
                      chatController: widget.chatController,
                      pangeaMessageEvent: widget.pangeaMessageEvent,
                      nextEvent: widget.nextEvent,
                      prevEvent: widget.prevEvent,
                      hasReactions: _hasReactions,
                      onChangeMessageSize: _setCenteredMessageSize,
                      isTransitionAnimation: false,
                      maxHeight: _mediaQuery!.size.height -
                          _headerHeight -
                          _footerHeight -
                          AppConfig.toolbarSpacing * 2,
                      readingAssistanceMode: _readingAssistanceMode,
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
                            OverlayFooter(
                              controller: widget.chatController,
                              overlayController: widget.overlayController,
                              showToolbarButtons: showToolbarButtons,
                              readingAssistanceMode: _readingAssistanceMode,
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
              if (_readingAssistanceMode != ReadingAssistanceMode.messageMode)
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
                          _originalMessageBottomOffset - _reactionsHeight,
                      child: OverlayCenterContent(
                        event: widget.event,
                        messageHeight: _originalMessageSize.height,
                        messageWidth: _originalMessageSize.width,
                        maxWidth: widget.overlayController.maxWidth,
                        overlayController: widget.overlayController,
                        chatController: widget.chatController,
                        pangeaMessageEvent: widget.pangeaMessageEvent,
                        nextEvent: widget.nextEvent,
                        prevEvent: widget.prevEvent,
                        hasReactions: _hasReactions,
                        sizeAnimation: _messageSizeAnimation,
                        isTransitionAnimation: true,
                        maxHeight: _mediaQuery!.size.height -
                            _headerHeight -
                            _footerHeight -
                            AppConfig.toolbarSpacing * 2,
                        readingAssistanceMode: _readingAssistanceMode,
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
                            instructionsEnum: widget.overlayController
                                    .toolbarMode.instructionsEnum ??
                                InstructionsEnum.readingAssistanceOverview,
                            bold: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_centeredMessageTopOffset != null &&
                  _tooltipSize != null &&
                  widget.overlayController.toolbarMode !=
                      MessageMode.noneSelected &&
                  widget.overlayController.selectedToken == null)
                Positioned(
                  top: max(
                    ((_headerHeight + _centeredMessageTopOffset!) / 2) -
                        (_tooltipSize!.height / 2),
                    _headerHeight,
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 200.0,
                      maxWidth: widget.overlayController.maxWidth,
                    ),
                    child: InstructionsInlineTooltip(
                      instructionsEnum: widget
                              .overlayController.toolbarMode.instructionsEnum ??
                          InstructionsEnum.readingAssistanceOverview,
                      bold: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
