import 'dart:async';

import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/common/widgets/pressable_button.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class ActivityStatsButton extends StatefulWidget {
  final ChatController controller;

  const ActivityStatsButton({
    super.key,
    required this.controller,
  });

  @override
  State<ActivityStatsButton> createState() => _ActivityStatsButtonState();
}

class _ActivityStatsButtonState extends State<ActivityStatsButton> {
  StreamSubscription? _analyticsSubscription;
  StreamSubscription? _rolesSubscription;
  ActivitySummaryAnalyticsModel? analytics;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateAnalytics(),
    );

    _analyticsSubscription = widget
        .controller.pangeaController.getAnalytics.analyticsStream.stream
        .listen((_) => _updateAnalytics());

    _rolesSubscription = widget.controller.room.client.onRoomState.stream
        .where(
      (u) =>
          u.roomId == widget.controller.room.id &&
          u.state.type == PangeaEventTypes.activityRole,
    )
        .listen((_) {
      _showStatsMenuDropdownInstructions();
    });
  }

  @override
  void dispose() {
    _analyticsSubscription?.cancel();
    _rolesSubscription?.cancel();
    super.dispose();
  }

  Client get _client => widget.controller.room.client;

  bool get _shouldShowInstructions {
    if (InstructionsEnum.activityStatsMenu.isToggledOff ||
        MatrixState.pAnyState.isOverlayOpen(
          RegExp(r"^word-zoom-card-.*$"),
        ) ||
        widget.controller.timeline == null) {
      return false;
    }

    // if someone has finished the activity, enable the tooltip
    final activityRoles =
        widget.controller.room.activityRoles?.roles.values.toList() ?? [];
    if (activityRoles.any((r) => r.isFinished)) {
      return true;
    }

    // otherwise, if no one has finished, only show if the user has sent >= 3 messages
    int count = 0;
    for (final event in widget.controller.timeline!.events) {
      if (event.senderId == _client.userID &&
          event.type == EventTypes.Message &&
          [
            MessageTypes.Text,
            MessageTypes.Audio,
          ].contains(event.messageType)) {
        count++;
      }

      if (count >= 3) return true;
    }

    return false;
  }

  int get _xpCount =>
      analytics?.totalXPForUser(
        _client.userID!,
      ) ??
      0;

  int? get _vocabCount => analytics?.uniqueConstructCountForUser(
        _client.userID!,
        ConstructTypeEnum.vocab,
      );

  int? get _grammarCount => analytics?.uniqueConstructCountForUser(
        _client.userID!,
        ConstructTypeEnum.morph,
      );

  /// Show a tutorial overlay that blocks the screen and points
  /// to the stats menu button with an explanation of what it does.
  void _showStatsMenuDropdownInstructions() {
    if (!_shouldShowInstructions) {
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

    OverlayUtil.showTutorialOverlay(
      context,
      overlayContent: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface,
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: 200,
          alignment: Alignment.center,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.info_outlined,
                    size: 16.0,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 4.0)),
                TextSpan(
                  text: L10n.of(context).activityStatsButtonInstruction,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      overlayKey: "activity_stats_menu_instruction",
      anchorRect: cellRect,
      borderRadius: 12.0,
      padding: 8.0,
      onClick: () {
        InstructionsEnum.activityStatsMenu.setToggledOff(true);
        widget.controller.setShowDropdown(true);
      },
    );
  }

  Future<void> _updateAnalytics() async {
    final analytics = await widget.controller.room.getActivityAnalytics();
    if (mounted) {
      setState(() => this.analytics = analytics);
      _showStatsMenuDropdownInstructions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final roleState =
        widget.controller.room.activityRoles?.roles.values.toList() ?? [];

    final enabled = _xpCount > 0 || roleState.any((r) => r.isFinished);

    return PressableButton(
      onPressed: () => widget.controller.setShowDropdown(
        !widget.controller.showActivityDropdown,
      ),
      borderRadius: BorderRadius.circular(12),
      color: enabled
          ? (theme.brightness == Brightness.light
              ? AppConfig.yellowLight
              : Color.lerp(AppConfig.gold, Colors.black, 0.3)!)
          : theme.colorScheme.surface,
      depressed: !enabled || widget.controller.showActivityDropdown,
      child: AnimatedContainer(
        duration: FluffyThemes.animationDuration,
        width: 280,
        height: 40,
        decoration: BoxDecoration(
          color: enabled
              ? theme.brightness == Brightness.light
                  ? AppConfig.yellowLight
                  : Color.lerp(AppConfig.gold, Colors.black, 0.3)!
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: analytics == null
            ? const CircularProgressIndicator.adaptive()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatsBadge(
                    icon: Icons.star,
                    value: "$_xpCount XP",
                  ),
                  _StatsBadge(
                    icon: Symbols.dictionary,
                    value: "$_vocabCount",
                  ),
                  _StatsBadge(
                    icon: Symbols.toys_and_games,
                    value: "$_grammarCount",
                  ),
                ],
              ),
      ),
    );
  }
}

class _StatsBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  const _StatsBadge({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodyMedium;
    final double fontSize = FluffyThemes.isColumnMode(context) ? 18 : 14;
    final double iconSize = FluffyThemes.isColumnMode(context) ? 22 : 18;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: iconSize,
          color: theme.colorScheme.onSurface,
        ),
        const SizedBox(width: 4),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: baseStyle?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
