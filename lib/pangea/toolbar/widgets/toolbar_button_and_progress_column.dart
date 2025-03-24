import 'dart:math';

import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/toolbar/enums/message_mode_enum.dart';
import 'package:fluffychat/pangea/toolbar/widgets/message_selection_overlay.dart';

class ToolbarButtonAndProgressColumn extends StatelessWidget {
  final Event event;
  final MessageOverlayController overlayController;
  final double height;
  final double width;

  const ToolbarButtonAndProgressColumn({
    required this.event,
    required this.overlayController,
    required this.height,
    required this.width,
    super.key,
  });

  double? get proportionOfActivitiesCompleted =>
      overlayController.pangeaMessageEvent?.proportionOfActivitiesCompleted;

  static const double iconWidth = 36.0;
  static const double buttonSize = 40.0;
  static const barMargin =
      EdgeInsets.symmetric(horizontal: iconWidth / 2, vertical: buttonSize / 2);

  @override
  Widget build(BuildContext context) {
    if (event.messageType == MessageTypes.Audio ||
        !(overlayController.pangeaMessageEvent?.messageDisplayLangIsL2 ??
            false)) {
      return SizedBox(height: height, width: width);
    }

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  color: MessageModeExtension.barAndLockedButtonColor(context),
                ),
                margin: barMargin,
              ),
              AnimatedContainer(
                duration: FluffyThemes.animationDuration,
                width: width,
                height: overlayController.isPracticeComplete
                    ? height
                    : min(
                        height,
                        height * proportionOfActivitiesCompleted!,
                      ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                  color: AppConfig.gold,
                ),
                margin: barMargin,
              ),
              Positioned(
                bottom: height * MessageMode.noneSelected.pointOnBar -
                    buttonSize / 2 -
                    barMargin.vertical / 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: overlayController.isPracticeComplete
                        ? AppConfig.gold
                        : MessageModeExtension.barAndLockedButtonColor(context),
                    shape: BoxShape.circle,
                  ),
                  height: buttonSize,
                  width: buttonSize,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.star_rounded,
                    color: overlayController.isPracticeComplete
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
