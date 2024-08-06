import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_input_row.dart';
import 'package:fluffychat/pages/chat/reactions_picker.dart';
import 'package:flutter/material.dart';

class OverlayFooter extends StatelessWidget {
  ChatController controller;

  OverlayFooter({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bottomSheetPadding = FluffyThemes.isColumnMode(context) ? 18.0 : 10.0;

    return Container(
      margin: EdgeInsets.only(
        bottom: bottomSheetPadding,
        left: bottomSheetPadding,
        right: bottomSheetPadding,
      ),
      constraints: const BoxConstraints(
        maxWidth: FluffyThemes.columnWidth * 2.5,
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Material(
            clipBehavior: Clip.hardEdge,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: const BorderRadius.all(
              Radius.circular(24),
            ),
            child: Column(
              children: [
                ReactionsPicker(controller),
                ChatInputRow(controller),
              ],
            ),
          ),
          SizedBox(
            height: FluffyThemes.isColumnMode(context) ? 23.0 : 15.0,
          ),
        ],
      ),
    );
  }
}
