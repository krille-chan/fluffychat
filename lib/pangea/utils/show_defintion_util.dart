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
