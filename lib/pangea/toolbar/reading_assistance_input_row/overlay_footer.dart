import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/chat/widgets/pangea_chat_input_row.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_button_column.dart';

class OverlayFooter extends StatelessWidget {
  final ChatController controller;
  final MessageOverlayController overlayController;
  final bool showToolbarButtons;

  const OverlayFooter({
    required this.controller,
    required this.overlayController,
    required this.showToolbarButtons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //@ggurdin can we change this mobile padding to 0? seems a some extrea space on mobile
    final bottomSheetPadding = FluffyThemes.isColumnMode(context) ? 16.0 : 8.0;

    return Container(
      margin: EdgeInsets.only(
        bottom: bottomSheetPadding,
        left: bottomSheetPadding,
        right: bottomSheetPadding,
      ),
      // constraints: const BoxConstraints(
      //   maxWidth: FluffyThemes.columnWidth * 2.5,
      // ),
      alignment: Alignment.center,
      child: Column(
        children: [
          if (showToolbarButtons)
            ToolbarButtonRow(overlayController: overlayController),
          Material(
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(AppConfig.borderRadius),
            ),
            child: PangeaChatInputRow(
              controller: controller,
              overlayController: overlayController,
            ),
          ),
        ],
      ),
    );
  }
}
