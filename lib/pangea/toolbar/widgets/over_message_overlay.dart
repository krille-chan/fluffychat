import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/toolbar/enums/reading_assistance_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_positioner.dart';
import 'package:fluffychat/pangea/toolbar/widgets/overlay_center_content.dart';
import 'package:fluffychat/pangea/toolbar/widgets/select_mode_buttons.dart';
import 'package:fluffychat/pangea/toolbar/widgets/word_card_switcher.dart';
import 'package:fluffychat/widgets/matrix.dart';

class OverMessageOverlay extends StatelessWidget {
  final MessageSelectionPositionerState controller;
  const OverMessageOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          controller.ownMessage ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.only(
          left: controller.messageLeftOffset ?? 0.0,
          right: controller.messageRightOffset ?? 0.0,
        ),
        child: GestureDetector(
          onTap: controller.widget.chatController.clearSelectedEvents,
          child: SingleChildScrollView(
            controller: controller.scrollController,
            child: Column(
              crossAxisAlignment: controller.ownMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!controller.shouldScroll) ...[
                  WordCardSwitcher(controller: controller),
                  const SizedBox(height: 4.0),
                ] else
                  AnimatedContainer(
                    duration: FluffyThemes.animationDuration,
                    height: controller.overheadContentHeight,
                  ),
                CompositedTransformTarget(
                  link: MatrixState.pAnyState
                      .layerLinkAndKey(
                        'overlay_message_${controller.widget.event.eventId}',
                      )
                      .link,
                  child: OverlayCenterContent(
                    event: controller.widget.event,
                    messageHeight:
                        controller.widget.overlayController.selectedMode !=
                                SelectMode.emoji
                            ? controller.originalMessageSize.height
                            : null,
                    messageWidth:
                        controller.widget.overlayController.showingExtraContent
                            ? max(controller.originalMessageSize.width, 150)
                            : controller.originalMessageSize.width,
                    overlayController: controller.widget.overlayController,
                    chatController: controller.widget.chatController,
                    nextEvent: controller.widget.nextEvent,
                    prevEvent: controller.widget.prevEvent,
                    hasReactions: controller.hasReactions,
                    isTransitionAnimation: true,
                    readingAssistanceMode: controller.readingAssistanceMode,
                    overlayKey: MatrixState.pAnyState
                        .layerLinkAndKey(
                          'overlay_message_${controller.widget.event.eventId}',
                        )
                        .key,
                  ),
                ),
                const SizedBox(height: 4.0),
                SelectModeButtons(
                  controller: controller.widget.chatController,
                  overlayController: controller.widget.overlayController,
                  lauchPractice: () => controller.setReadingAssistanceMode(
                    ReadingAssistanceMode.practiceMode,
                  ),
                ),
                AnimatedContainer(
                  duration: FluffyThemes.animationDuration,
                  height: max(0, controller.spaceBelowContent),
                  width: controller.mediaQuery!.size.width -
                      controller.columnWidth -
                      (controller.showDetails ? FluffyThemes.columnWidth : 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
