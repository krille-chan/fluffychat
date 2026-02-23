import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_session_chat/activity_chat_extension.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/common/widgets/shimmer_background.dart';
import 'package:fluffychat/pangea/common/widgets/tutorial_overlay_message.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityMenuButton extends StatefulWidget {
  final ChatController controller;

  const ActivityMenuButton({super.key, required this.controller});

  @override
  State<ActivityMenuButton> createState() => _ActivityMenuButtonState();
}

class _ActivityMenuButtonState extends State<ActivityMenuButton> {
  bool _showShimmer = false;
  StreamSubscription? _rolesSubscription;
  StreamSubscription? _analyticsSubscription;

  @override
  void initState() {
    super.initState();

    _analyticsSubscription = Matrix.of(context)
        .analyticsDataService
        .updateDispatcher
        .constructUpdateStream
        .stream
        .listen(_showStatsMenuDropdownInstructions);

    _rolesSubscription = widget.controller.room.client.onRoomState.stream
        .where(
          (u) =>
              u.roomId == widget.controller.room.id &&
              u.state.type == PangeaEventTypes.activityRole,
        )
        .listen(_showStatsMenuDropdownInstructions);
  }

  @override
  void dispose() {
    _analyticsSubscription?.cancel();
    _rolesSubscription?.cancel();
    super.dispose();
  }

  /// Show a tutorial overlay that blocks the screen and points
  /// to the stats menu button with an explanation of what it does.
  void _showStatsMenuDropdownInstructions(dynamic _) {
    if (!mounted) return;
    if (!widget.controller.shouldShowActivityInstructions) {
      return;
    }

    final renderObject = context.findRenderObject() as RenderBox;
    final offset = renderObject.localToGlobal(Offset.zero);
    final cellRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderObject.size.width,
      renderObject.size.height,
    );

    FocusScope.of(context).unfocus();
    OverlayUtil.showTutorialOverlay(
      context,
      overlayContent: TutorialOverlayMessage(
        L10n.of(context).activityStatsButtonInstruction,
      ),
      overlayKey: "activity_stats_menu_instruction",
      anchorRect: cellRect,
      borderRadius: 12.0,
      padding: 8.0,
      onClick: () {
        setState(() => _showShimmer = false);
        InstructionsEnum.activityStatsMenu.setToggledOff(true);
        widget.controller.toggleShowDropdown();
      },
    );

    setState(() => _showShimmer = true);
  }

  @override
  Widget build(BuildContext context) {
    final content = IconButton(
      icon: const Icon(Icons.radar_outlined),
      tooltip: L10n.of(context).activityStatsButtonTooltip,
      onPressed: widget.controller.toggleShowDropdown,
    );
    return ShimmerBackground(enabled: _showShimmer, child: content);
  }
}
