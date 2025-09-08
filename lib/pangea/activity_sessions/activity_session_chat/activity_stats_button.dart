import 'dart:async';

import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';
import 'package:fluffychat/pangea/activity_summary/activity_summary_analytics_model.dart';
import 'package:fluffychat/pangea/analytics_misc/construct_type_enum.dart';
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
  ActivitySummaryAnalyticsModel analytics = ActivitySummaryAnalyticsModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateAnalytics(),
    );

    _analyticsSubscription = widget
        .controller.pangeaController.getAnalytics.analyticsStream.stream
        .listen((_) {
      _updateAnalytics();
    });
  }

  @override
  void dispose() {
    _analyticsSubscription?.cancel();
    super.dispose();
  }

  int get xpCount => analytics.totalXPForUser(
        Matrix.of(context).client.userID ?? '',
      );

  int get vocabCount => analytics.uniqueConstructCountForUser(
        widget.controller.room.client.userID!,
        ConstructTypeEnum.vocab,
      );

  int get grammarCount => analytics.uniqueConstructCountForUser(
        widget.controller.room.client.userID!,
        ConstructTypeEnum.morph,
      );

  Future<void> _updateAnalytics() async {
    final analytics = await widget.controller.room.getActivityAnalytics();
    if (mounted) {
      setState(() => this.analytics = analytics);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => widget.controller.setShowDropdown(
          !widget.controller.showActivityDropdown,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppConfig.goldLight.withAlpha(100),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
