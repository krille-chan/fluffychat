import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
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
      .where((mode) => mode.isValidMode(pangeaMessageEvent.event))
      .toList();

  static const double iconWidth = 36.0;

  @override
  Widget build(BuildContext context) {
    final double barWidth = width - iconWidth;

    if (overlayController.pangeaMessageEvent.isAudioMessage) {
      return const SizedBox();
    }

    return SizedBox(
      width: width,
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
            children: modes
                .mapIndexed(
                  (index, mode) => Tooltip(
                    message: mode.tooltip(context),
                    child: IconButton(
                      iconSize: 20,
                      icon: Icon(mode.icon),
                      color: mode == overlayController.toolbarMode
                          ? Colors.white
                          : null,
                      isSelected: mode == overlayController.toolbarMode,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          mode.iconButtonColor(
                            context,
                            index,
                            overlayController.toolbarMode,
                            pangeaMessageEvent.numberOfActivitiesCompleted,
                            overlayController.isPracticeComplete,
                          ),
                        ),
                      ),
                      onPressed: mode.isUnlocked(
                        index,
                        pangeaMessageEvent.numberOfActivitiesCompleted,
                        overlayController.isPracticeComplete,
                      )
                          ? () => overlayController.updateToolbarMode(mode)
                          : null,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
