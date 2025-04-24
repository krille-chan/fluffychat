import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/chat/widgets/pangea_chat_input_row.dart';
import 'package:fluffychat/pangea/toolbar/enums/reading_assistance_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/practice_mode_buttons.dart';

class OverlayFooter extends StatelessWidget {
  final ChatController controller;
  final MessageOverlayController overlayController;
  final bool showToolbarButtons;
  final ReadingAssistanceMode? readingAssistanceMode;

  const OverlayFooter({
    required this.controller,
    required this.overlayController,
    required this.showToolbarButtons,
    required this.readingAssistanceMode,
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
      height: readingAssistanceMode == ReadingAssistanceMode.practiceMode ||
              readingAssistanceMode == ReadingAssistanceMode.transitionMode
          ? AppConfig.practiceModeInputBarHeight
          : AppConfig.selectModeInputBarHeight,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showToolbarButtons)
            PracticeModeButtons(overlayController: overlayController),
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
