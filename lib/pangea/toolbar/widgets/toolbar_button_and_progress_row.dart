import 'dart:math';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_meaning_button.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';
import 'package:fluffychat/pangea/toolbar/widgets/toolbar_button.dart';

class ToolbarButtonAndProgressRow extends StatelessWidget {
  final Event event;
  final MessageOverlayController overlayController;

  const ToolbarButtonAndProgressRow({
    required this.event,
    required this.overlayController,
    super.key,
  });

  double? get proportionOfActivitiesCompleted =>
      overlayController.pangeaMessageEvent?.proportionOfActivitiesCompleted;

  static const double iconWidth = 36.0;
  static const double buttonSize = 40.0;
  static const double totalRowWidth = 250.0;

  @override
  Widget build(BuildContext context) {
    if (event.messageType == MessageTypes.Audio) {
      return const SizedBox();
    }

    if (!overlayController.showToolbarButtons) {
      return const SizedBox();
    }

    return SizedBox(
      width: totalRowWidth,
      height: AppConfig.toolbarButtonsHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: totalRowWidth,
                height: 12,
                decoration: BoxDecoration(
                  color: MessageModeExtension.barAndLockedButtonColor(context),
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                ),
                margin: const EdgeInsets.symmetric(horizontal: iconWidth / 2),
              ),
              AnimatedContainer(
                duration: FluffyThemes.animationDuration,
                height: 12,
                width: overlayController.isPracticeComplete
                    ? totalRowWidth
                    : min(
                        totalRowWidth,
                        totalRowWidth * proportionOfActivitiesCompleted!,
                      ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  color: AppConfig.success,
                ),
                margin: const EdgeInsets.symmetric(horizontal: iconWidth / 2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MessageMeaningButton(
                buttonSize: buttonSize,
                overlayController: overlayController,
              ),
              SizedBox(
                width: MessageMode.textToSpeech.pointOnBar * totalRowWidth -
                    buttonSize,
              ),
              ToolbarButton(
                mode: MessageMode.textToSpeech,
                overlayController: overlayController,
                buttonSize: buttonSize,
              ),
              SizedBox(
                width: MessageMode.translation.pointOnBar * totalRowWidth -
                    MessageMode.textToSpeech.pointOnBar * totalRowWidth -
                    buttonSize -
                    buttonSize,
              ),
              ToolbarButton(
                mode: MessageMode.translation,
                overlayController: overlayController,
                buttonSize: buttonSize,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
