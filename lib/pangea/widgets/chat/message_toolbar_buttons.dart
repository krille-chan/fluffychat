import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/enum/message_mode_enum.dart';
import 'package:fluffychat/pangea/matrix_event_wrappers/pangea_message_event.dart';
import 'package:fluffychat/pangea/widgets/chat/message_selection_overlay.dart';
import 'package:flutter/material.dart';

class ToolbarButtons extends StatefulWidget {
  final MessageOverlayController overlayController;
  final double width;

  const ToolbarButtons({
    required this.overlayController,
    required this.width,
    super.key,
  });

  @override
  ToolbarButtonsState createState() => ToolbarButtonsState();
}

class ToolbarButtonsState extends State<ToolbarButtons> {
  PangeaMessageEvent get pangeaMessageEvent =>
      widget.overlayController.pangeaMessageEvent;

  List<MessageMode> get modes => MessageMode.values
      .where((mode) => mode.isValidMode(pangeaMessageEvent.event))
      .toList();

  static const double iconWidth = 36.0;

  MessageOverlayController get overlayController => widget.overlayController;

  // @ggurdin - maybe this can be stateless now?
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double barWidth = widget.width - iconWidth;

    if (widget.overlayController.pangeaMessageEvent.isAudioMessage) {
      return const SizedBox();
    }

    return SizedBox(
      width: widget.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: widget.width,
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
                      color: mode == widget.overlayController.toolbarMode
                          ? Colors.white
                          : null,
                      isSelected: mode == widget.overlayController.toolbarMode,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          mode.iconButtonColor(
                            context,
                            index,
                            widget.overlayController.toolbarMode,
                            pangeaMessageEvent.numberOfActivitiesCompleted,
                            widget.overlayController.isPracticeComplete,
                          ),
                        ),
                      ),
                      onPressed: mode.isUnlocked(
                        index,
                        pangeaMessageEvent.numberOfActivitiesCompleted,
                        overlayController.isPracticeComplete,
                      )
                          ? () =>
                              widget.overlayController.updateToolbarMode(mode)
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
