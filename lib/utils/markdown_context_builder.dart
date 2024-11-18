import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

Widget markdownContextBuilder(
  BuildContext context,
  EditableTextState editableTextState,
  TextEditingController controller,
) {
  final value = editableTextState.textEditingValue;
  final selectedText = value.selection.textInside(value.text);
  final buttonItems = editableTextState.contextMenuButtonItems;
  final l10n = L10n.of(context);

  return AdaptiveTextSelectionToolbar.buttonItems(
    anchors: editableTextState.contextMenuAnchors,
    buttonItems: [
      ...buttonItems,
      if (selectedText.isNotEmpty) ...[
        ContextMenuButtonItem(
          label: l10n.link,
          onPressed: () async {
            final input = await showTextInputDialog(
              context: context,
              title: l10n.addLink,
              okLabel: l10n.ok,
              cancelLabel: l10n.cancel,
              textFields: [
                DialogTextField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return l10n.pleaseFillOut;
                    }
                    try {
                      text.startsWith('http')
                          ? Uri.parse(text)
                          : Uri.https(text);
                    } catch (_) {
                      return l10n.invalidUrl;
                    }
                    return null;
                  },
                  hintText: 'www...',
                  keyboardType: TextInputType.url,
                ),
              ],
            );
            final urlString = input?.singleOrNull;
            if (urlString == null) return;
            final url = urlString.startsWith('http')
                ? Uri.parse(urlString)
                : Uri.https(urlString);
            final selection = controller.selection;
            controller.text = controller.text.replaceRange(
              selection.start,
              selection.end,
              '[$selectedText](${url.toString()})',
            );
            ContextMenuController.removeAny();
          },
        ),
        ContextMenuButtonItem(
          label: l10n.boldText,
          onPressed: () {
            final selection = controller.selection;
            controller.text = controller.text.replaceRange(
              selection.start,
              selection.end,
              '**$selectedText**',
            );
            ContextMenuController.removeAny();
          },
        ),
        ContextMenuButtonItem(
          label: l10n.italicText,
          onPressed: () {
            final selection = controller.selection;
            controller.text = controller.text.replaceRange(
              selection.start,
              selection.end,
              '*$selectedText*',
            );
            ContextMenuController.removeAny();
          },
        ),
        ContextMenuButtonItem(
          label: l10n.strikeThrough,
          onPressed: () {
            final selection = controller.selection;
            controller.text = controller.text.replaceRange(
              selection.start,
              selection.end,
              '~~$selectedText~~',
            );
            ContextMenuController.removeAny();
          },
        ),
      ],
    ],
  );
}
