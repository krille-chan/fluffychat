import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_input_row.dart';
import 'package:fluffychat/pages/chat/reactions_picker.dart';
import 'package:fluffychat/pages/chat/reply_display.dart';
import 'package:fluffychat/pangea/choreographer/widgets/it_bar.dart';
import 'package:fluffychat/widgets/connection_status_header.dart';
import 'package:flutter/material.dart';

enum _EventContextAction { info, report }

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
                const ConnectionStatusHeader(),
                ITBar(
                  choreographer: controller.choreographer,
                ),
                ReactionsPicker(controller),
                ReplyDisplay(controller),
                ChatInputRow(controller),
              ],
            ),
          ),
          SizedBox(
            height: FluffyThemes.isColumnMode(context) ? 16.0 : 8.0,
          ),
        ],
      ),
    );
  }
}
