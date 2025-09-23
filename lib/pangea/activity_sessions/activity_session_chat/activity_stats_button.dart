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
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';

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
  ActivitySummaryAnalyticsModel analytics = ActivitySummaryAnalyticsModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateAnalytics(),
    );

    _analyticsSubscription = widget
        .controller.pangeaController.getAnalytics.analyticsStream.stream
        .listen((_) => _updateAnalytics());
  }

  Client get client => widget.controller.room.client;

  void _showInstructionPopup() {
    if (InstructionsEnum.activityStatsMenu.isToggledOff || xpCount <= 0) {
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
      Center(
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
      cellRect,
      borderRadius: 12.0,
      padding: 8.0,
      onClick: () => widget.controller.setShowDropdown(true),
      onDismiss: () {
        InstructionsEnum.activityStatsMenu.setToggledOff(true);
      },
    );
  }

  @override
  void dispose() {
    _analyticsSubscription?.cancel();
    super.dispose();
  }

  int get xpCount => analytics.totalXPForUser(
        client.userID!,
      );

  int get vocabCount => analytics.uniqueConstructCountForUser(
        client.userID!,
        ConstructTypeEnum.vocab,
      );

  int get grammarCount => analytics.uniqueConstructCountForUser(
        client.userID!,
        ConstructTypeEnum.morph,
      );

  Future<void> _updateAnalytics() async {
    final prevXP = xpCount;
    final analytics = await widget.controller.room.getActivityAnalytics();
    if (mounted) {
      setState(() => this.analytics = analytics);
      if (prevXP == 0 && xpCount > 0) _showInstructionPopup();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PressableButton(
      onPressed: () => widget.controller.setShowDropdown(
        !widget.controller.showActivityDropdown,
      ),
      borderRadius: BorderRadius.circular(12),
      color: xpCount > 0
          ? AppConfig.gold.withAlpha(180)
          : theme.colorScheme.surface,
      depressed: xpCount <= 0 || widget.controller.showActivityDropdown,
      child: AnimatedContainer(
        duration: FluffyThemes.animationDuration,
        width: 300,
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: xpCount > 0
              ? AppConfig.gold.withAlpha(180)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatsBadge(icon: Icons.radar, value: "$xpCount XP"),
            _StatsBadge(icon: Symbols.dictionary, value: "$vocabCount"),
            _StatsBadge(
              icon: Symbols.toys_and_games,
              value: "$grammarCount",
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
    final screenWidth = MediaQuery.of(context).size.width;
    final baseStyle = theme.textTheme.bodyMedium;
    final double fontSize = (screenWidth < 400) ? 10 : 14;
    final double iconSize = (screenWidth < 400) ? 14 : 18;
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
