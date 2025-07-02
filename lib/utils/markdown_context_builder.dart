import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_text_input_dialog.dart';

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
              validator: (text) {
                if (text.isEmpty) {
                  return l10n.pleaseFillOut;
                }
                try {
                  text.startsWith('http') ? Uri.parse(text) : Uri.https(text);
                } catch (_) {
                  return l10n.invalidUrl;
                }
                return null;
              },
              hintText: 'www...',
              keyboardType: TextInputType.url,
            );
            final urlString = input;
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
          label: l10n.checkList,
          onPressed: () {
            final text = controller.text;
            final selection = controller.selection;

            var start = selection.textBefore(text).lastIndexOf('\n');
            if (start == -1) start = 0;
            final end = selection.end;

            final fullLineSelection =
                TextSelection(baseOffset: start, extentOffset: end);

            const checkBox = '- [ ]';

            final replacedRange = fullLineSelection
                .textInside(text)
                .split('\n')
                .map(
                  (line) => line.startsWith(checkBox) || line.isEmpty
                      ? line
                      : '$checkBox $line',
                )
                .join('\n');
            controller.text =
                controller.text.replaceRange(start, end, replacedRange);
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
