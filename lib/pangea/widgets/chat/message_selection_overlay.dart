import 'dart:async';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/events/message.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/widgets/chat/message_text_selection.dart';
import 'package:fluffychat/pangea/widgets/chat/message_toolbar.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_footer.dart';
import 'package:fluffychat/pangea/widgets/chat/overlay_header.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class MessageSelectionOverlay extends StatefulWidget {
  final ChatController controller;
  final Event event;
  final PangeaMessageEvent pangeaMessageEvent;
  final MessageMode? initialMode;
  final MessageTextSelection textSelection;

  const MessageSelectionOverlay({
    required this.controller,
    required this.event,
    required this.pangeaMessageEvent,
    required this.textSelection,
    this.initialMode,
    super.key,
  });

  @override
  MessageSelectionOverlayState createState() => MessageSelectionOverlayState();
}

class MessageSelectionOverlayState extends State<MessageSelectionOverlay> {
  double overlayBottomOffset = -1;
  double adjustedOverlayBottomOffset = -1;
  Size? messageSize;
  Offset? messageOffset;

  final StreamController _completeAnimationStream =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // position the overlay directly over the underlying message
    setOverlayBottomOffset();

    // wait for the toolbar to animate to full height
    _completeAnimationStream.stream.first.then((_) {
      if (toolbarHeight == null ||
          messageSize == null ||
          messageOffset == null) {
        return;
      }

      // Once the toolbar has fully expanded, adjust
      // the overlay's position if there's an overflow
      final overlayTopOffset = messageOffset!.dy - toolbarHeight!;

      final bool hasHeaderOverflow = overlayTopOffset < headerHeight;
      final bool hasFooterOverflow = overlayBottomOffset < footerHeight;

      if (hasHeaderOverflow) {
        final overlayHeight = toolbarHeight! + messageSize!.height;
        adjustedOverlayBottomOffset = screenHeight -
            overlayHeight -
            footerHeight -
            MediaQuery.of(context).padding.bottom;
      } else if (hasFooterOverflow) {
        adjustedOverlayBottomOffset = footerHeight;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _completeAnimationStream.close();
    super.dispose();
  }

  void setOverlayBottomOffset() {
    // Try to get the offset and size of the original message bubble.
    // If it fails, return an empty SizedBox. For instance, this can fail if
    // you change the screen size while the overlay is open.
    try {
      final messageRenderBox = MatrixState.pAnyState.getRenderBox(
        widget.event.eventId,
      );
      if (messageRenderBox != null && messageRenderBox.hasSize) {
        messageSize = messageRenderBox.size;
        messageOffset = messageRenderBox.localToGlobal(Offset.zero);
        final messageTopOffset = messageOffset!.dy;
        overlayBottomOffset =
            screenHeight - messageTopOffset - messageSize!.height;
      }
    } catch (err) {
      overlayBottomOffset = adjustedOverlayBottomOffset = -1;
    } finally {
      setState(() {});
    }
  }

  // height of the reply/forward bar + the reaction picker + contextual padding
  double get footerHeight =>
      48 + 56 + (FluffyThemes.isColumnMode(context) ? 16.0 : 8.0);

  double get headerHeight =>
      (Theme.of(context).appBarTheme.toolbarHeight ?? 56) +
      MediaQuery.of(context).padding.top;

  double get screenHeight => MediaQuery.of(context).size.height;

  double? get toolbarHeight {
    try {
      final toolbarRenderBox = MatrixState.pAnyState.getRenderBox(
        '${widget.pangeaMessageEvent.eventId}-toolbar',
      );

      return toolbarRenderBox?.size.height;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (overlayBottomOffset == -1) {
      return const SizedBox.shrink();
    }

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
              mainAxisAlignment: widget.pangeaMessageEvent.ownMessage
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.pangeaMessageEvent.ownMessage
                        ? 0
                        : Avatar.defaultSize + 16,
                    right: widget.pangeaMessageEvent.ownMessage ? 8 : 0,
                  ),
                  child: MessageToolbar(
                    pangeaMessageEvent: widget.pangeaMessageEvent,
                    controller: widget.controller,
                    textSelection: widget.textSelection,
                    completeAnimationStream: _completeAnimationStream,
                    initialMode: widget.initialMode,
                  ),
                ),
              ],
            ),
            Message(
              widget.event,
              onSwipe: () => {},
              onInfoTab: (_) => {},
              onAvatarTab: (_) => {},
              scrollToEventId: (_) => {},
              immersionMode: widget.controller.choreographer.immersionMode,
              controller: widget.controller,
              timeline: widget.controller.timeline!,
              isOverlay: true,
              animateIn: false,
            ),
          ],
        ),
      ),
    );

    return Expanded(
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: FluffyThemes.animationDuration,
            left: 0,
            right: 0,
            bottom: adjustedOverlayBottomOffset == -1
                ? overlayBottomOffset
                : adjustedOverlayBottomOffset,
            child: Align(
              alignment: Alignment.center,
              child: overlayMessage,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OverlayFooter(controller: widget.controller),
              ],
            ),
          ),
          Material(
            child: OverlayHeader(controller: widget.controller),
          ),
        ],
      ),
    );
  }
}
