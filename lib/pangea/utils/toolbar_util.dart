import 'dart:async';

import 'package:fluffychat/pangea/utils/any_state_holder.dart';
import 'package:fluffychat/pangea/utils/overlay.dart';
import 'package:fluffychat/pangea/widgets/igc/word_data_card.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

enum MessageMode { translation, play, definition, image, spellCheck }

class MessageOverlayController {
  OverlayEntry? _overlayEntry;
  final BuildContext _context;
  final GlobalKey _targetKey;
  MessageMode? _currentMode;
  AnimationController? _animationController;

  MessageOverlayController(this._context, this._targetKey) {
    _animationController = AnimationController(
      vsync: Navigator.of(_context), // Using the Navigator's TickerProvider
      duration: const Duration(milliseconds: 300),
    );
  }

  void showOverlay() {
    final RenderBox renderBox =
        _targetKey.currentContext?.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final double screenWidth = MediaQuery.of(_context).size.width;

    // Determines if there is more room above or below the RenderBox
    final bool isBottomRoomAvailable =
        MediaQuery.of(_context).size.height - (offset.dy + size.height) >=
            size.height;
    final double topPosition = isBottomRoomAvailable
        ? offset.dy + size.height
        : offset.dy - size.height;

    // Ensure the overlay does not overflow the screen horizontally
    double leftPosition = offset.dx + size.width / 2 - screenWidth / 2;
    leftPosition = leftPosition < 0 ? 0 : leftPosition;
    final double rightPosition =
        leftPosition + screenWidth > MediaQuery.of(_context).size.width
            ? MediaQuery.of(_context).size.width - leftPosition - screenWidth
            : leftPosition;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: leftPosition,
              right: rightPosition,
              top: isBottomRoomAvailable ? topPosition : null,
              bottom: isBottomRoomAvailable
                  ? null
                  : MediaQuery.of(_context).size.height -
                      topPosition -
                      size.height,
              child: AnimatedSize(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 300),
                child: Material(
                  elevation: 4.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: MessageMode.values.map((mode) {
                          return IconButton(
                            icon: Icon(_getIconData(mode)),
                            onPressed: () {
                              setState(() {
                                _currentMode = mode;
                              });
                              _animationController?.forward();
                            },
                          );
                        }).toList(),
                      ),
                      SizeTransition(
                        sizeFactor: CurvedAnimation(
                          parent: _animationController!,
                          curve: Curves.fastOutSlowIn,
                        ),
                        axisAlignment: -1.0,
                        child: _buildModeContent(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    Overlay.of(_context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController?.reverse();
  }

  Widget _buildModeContent() {
    switch (_currentMode) {
      case MessageMode.translation:
        return const Text('Translation Mode');
      case MessageMode.play:
        return const Text('Play Mode');
      case MessageMode.definition:
        return const Text('Definition Mode');
      case MessageMode.image:
        return const Text('Image Mode');
      case MessageMode.spellCheck:
        return const Text('SpellCheck Mode');
      default:
        return const SizedBox
            .shrink(); // Empty container for the default case, meaning no content
    }
  }

  IconData _getIconData(MessageMode mode) {
    switch (mode) {
      case MessageMode.translation:
        return Icons.g_translate;
      case MessageMode.play:
        return Icons.play_arrow;
      case MessageMode.definition:
        return Icons.book;
      case MessageMode.image:
        return Icons.image;
      case MessageMode.spellCheck:
        return Icons.spellcheck;
      default:
        return Icons.error; // Icon to indicate an error or unsupported mode
    }
  }

  void dispose() {
    _overlayEntry?.dispose();
    _animationController?.dispose();
  }
}

class ShowDefintionUtil {
  String messageText;
  final String langCode;
  final String targetId;
  final FocusNode focusNode = FocusNode();
  final Room room;
  String? textSelection;
  bool inCooldown = false;
  double? dx;
  double? dy;

  ShowDefintionUtil({
    required this.targetId,
    required this.room,
    required this.langCode,
    required this.messageText,
  });

  void onTextSelection({
    required BuildContext context,
    TextSelection? selectedText,
    SelectedContent? selectedContent,
    SelectionChangedCause? cause,
  }) {
    if ((selectedText == null && selectedContent == null) ||
        selectedText?.isCollapsed == true) {
      clearTextSelection();
      return;
    }
    textSelection = selectedText != null
        ? selectedText.textInside(messageText)
        : selectedContent!.plainText;

    if (BrowserContextMenu.enabled && kIsWeb) {
      BrowserContextMenu.disableContextMenu();
    }

    if (kIsWeb && cause != SelectionChangedCause.tap) {
      handleToolbar(context);
    }
  }

  void clearTextSelection() {
    textSelection = null;
    if (kIsWeb && !BrowserContextMenu.enabled) {
      BrowserContextMenu.enableContextMenu();
    }
  }

  void handleToolbar(BuildContext context) async {
    if (inCooldown || OverlayUtil.isOverlayOpen || !kIsWeb) return;
    inCooldown = true;
    Timer(const Duration(milliseconds: 750), () => inCooldown = false);
    await Future.delayed(const Duration(milliseconds: 750));
    showToolbar(context);
  }

  void showDefinition(BuildContext context) {
    if (textSelection == null) return;
    OverlayUtil.showPositionedCard(
      context: context,
      cardToShow: WordDataCard(
        word: textSelection!,
        wordLang: langCode,
        fullText: messageText,
        fullTextLang: langCode,
        hasInfo: false,
        room: room,
      ),
      cardSize: const Size(300, 300),
      transformTargetId: targetId,
      backDropToDismiss: false,
    );
  }

  // web toolbar
  Future<dynamic> showToolbar(BuildContext context) async {
    final LayerLinkAndKey layerLinkAndKey =
        MatrixState.pAnyState.layerLinkAndKey(targetId);

    final RenderObject? targetRenderBox =
        layerLinkAndKey.key.currentContext!.findRenderObject();
    final Offset transformTargetOffset =
        (targetRenderBox as RenderBox).localToGlobal(Offset.zero);

    if (dx != null && dx! > MediaQuery.of(context).size.width - 130) {
      dx = MediaQuery.of(context).size.width - 130;
    }
    final double xOffset = dx != null ? dx! - transformTargetOffset.dx : 0;
    final double yOffset =
        dy != null ? dy! - transformTargetOffset.dy + 10 : 10;

    OverlayUtil.showOverlay(
      context: context,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          showDefinition(context);
        },
        child: Text(
          L10n.of(context)!.showDefinition,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
      size: const Size(130, 45),
      transformTargetId: targetId,
      offset: Offset(xOffset, yOffset),
    );
  }

  void onMouseRegionUpdate(PointerEvent event) {
    dx = event.position.dx;
    dy = event.position.dy;
  }

  Widget contextMenuOverride({
    required BuildContext context,
    EditableTextState? textSelection,
    SelectableRegionState? contentSelection,
  }) {
    if (textSelection == null && contentSelection == null) {
      return const SizedBox();
    }
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: textSelection?.contextMenuAnchors ??
          contentSelection!.contextMenuAnchors,
      buttonItems: [
        if (textSelection != null) ...textSelection.contextMenuButtonItems,
        if (contentSelection != null)
          ...contentSelection.contextMenuButtonItems,
        ContextMenuButtonItem(
          label: L10n.of(context)!.showDefinition,
          onPressed: () {
            showDefinition(context);
            focusNode.unfocus();
          },
        ),
      ],
    );
  }
}
