import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:fluffychat/pangea/widgets/pressable_button.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class ToolbarButtons extends StatelessWidget {
  final MessageOverlayController overlayController;
  final double width;

  const ToolbarButtons({
    required this.overlayController,
    required this.width,
    super.key,
  });

  PangeaMessageEvent get pangeaMessageEvent =>
      overlayController.pangeaMessageEvent;

  List<MessageMode> get modes => MessageMode.values
      .where((mode) => mode.shouldShowAsToolbarButton(pangeaMessageEvent.event))
      .toList();

  bool get messageInUserL2 =>
      pangeaMessageEvent.messageDisplayLangCode ==
      MatrixState.pangeaController.languageController.userL2?.langCode;

  static const double iconWidth = 36.0;
  static const buttonSize = 40.0;

  @override
  Widget build(BuildContext context) {
    final totallyDone =
        overlayController.isPracticeComplete || !messageInUserL2;
    final double barWidth = width - iconWidth;

    if (!overlayController.showToolbarButtons) {
      return const SizedBox();
    }

    return SizedBox(
      width: width,
      height: AppConfig.toolbarButtonsHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: width,
                height: 12,
                decoration: BoxDecoration(
                  color: MessageModeExtension.barAndLockedButtonColor(context),
                ),
                margin: const EdgeInsets.symmetric(horizontal: iconWidth / 2),
              ),
              AnimatedContainer(
                duration: FluffyThemes.animationDuration,
                height: 12,
                width: overlayController.isPracticeComplete
                    ? barWidth
                    : min(
                        barWidth,
                        (barWidth / 3) *
                            pangeaMessageEvent.numberOfActivitiesCompleted,
                      ),
                color: AppConfig.success,
                margin: const EdgeInsets.symmetric(horizontal: iconWidth / 2),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: modes.mapIndexed((index, mode) {
              final enabled = mode.isUnlocked(
                index,
                pangeaMessageEvent.numberOfActivitiesCompleted,
                totallyDone,
              );
              final color = mode.iconButtonColor(
                context,
                index,
                overlayController.toolbarMode,
                pangeaMessageEvent.numberOfActivitiesCompleted,
                totallyDone,
              );
              return Tooltip(
                message: mode.tooltip(context),
                child: PressableButton(
                  width: buttonSize,
                  height: buttonSize,
                  borderRadius: BorderRadius.circular(20),
                  enabled: enabled,
                  depressed: !enabled || mode == overlayController.toolbarMode,
                  color: color,
                  onPressed: enabled
                      ? () => overlayController.updateToolbarMode(mode)
                      : null,
                  child: AnimatedContainer(
                    duration: FluffyThemes.animationDuration,
                    height: buttonSize,
                    width: buttonSize,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      mode.icon,
                      size: 20,
                      color: mode == overlayController.toolbarMode
                          ? Colors.white
                          : null,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
