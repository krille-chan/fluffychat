import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class MessageContextMenu {
  static List<ContextMenuButtonItem> customToolbarOptions(
    BuildContext context,
    void Function()? onDefine,
    void Function()? onListen,
  ) {
    return [
      ContextMenuButtonItem(
        label: L10n.of(context).define,
        onPressed: onDefine,
      ),
      ContextMenuButtonItem(
        label: L10n.of(context).listen,
        onPressed: onListen,
      ),
    ];
  }

  static List<ContextMenuButtonItem> toolbarOptions(
    EditableTextState? textSelection,
    SelectableRegionState? contentSelection,
    BuildContext context,
    void Function()? onDefine,
    void Function()? onListen,
  ) {
    final List<ContextMenuButtonItem> menuItems =
        textSelection?.contextMenuButtonItems ??
            contentSelection?.contextMenuButtonItems ??
            [];
    menuItems.sort((a, b) {
      if (a.type == ContextMenuButtonType.copy) return -1;
      if (b.type == ContextMenuButtonType.copy) return 1;
      return 0;
    });
    return MessageContextMenu.customToolbarOptions(
            context, onDefine, onListen) +
        menuItems;
  }

  static Widget contextMenuOverride({
    required BuildContext context,
    EditableTextState? textSelection,
    SelectableRegionState? contentSelection,
    void Function()? onDefine,
    void Function()? onListen,
  }) {
    if (textSelection == null && contentSelection == null) {
      return const SizedBox();
    }

    final List<ContextMenuButtonItem> menuItems =
        MessageContextMenu.toolbarOptions(
      textSelection,
      contentSelection,
      context,
      onDefine,
      onListen,
    );

    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: textSelection?.contextMenuAnchors ??
          contentSelection!.contextMenuAnchors,
      buttonItems: menuItems,
    );
  }
}
