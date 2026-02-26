import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestion_card.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/common/widgets/error_indicator.dart';
import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_model.dart';
import 'package:fluffychat/pangea/course_settings/activity_card_placeholder.dart';

class TopicActivitiesList extends StatefulWidget {
  final Room room;
  final CourseTopicModel topic;
  final bool Function(String userId, String activityId) hasCompletedActivity;

  const TopicActivitiesList({
    super.key,
    required this.room,
    required this.topic,
    required this.hasCompletedActivity,
  });
  @override
  State<TopicActivitiesList> createState() => TopicActivitiesListState();
}

class TopicActivitiesListState extends State<TopicActivitiesList> {
  final ScrollController _scrollController = ScrollController();

  bool _loading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant TopicActivitiesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.topic.uuid != widget.topic.uuid) {
      _load();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (widget.topic.activityListComplete) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await widget.topic.fetchActivities();
    } catch (e, s) {
      _error = e;
      ErrorHandler.logError(e: e, s: s, data: {'topicId': widget.topic.uuid});
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return ActivityCardPlaceholder(
        activityCount: widget.topic.activityIds.length,
      );
    }

    if (_error != null) {
      return ErrorIndicator(message: L10n.of(context).oopsSomethingWentWrong);
    }

    final theme = Theme.of(context);
    final isColumnMode = FluffyThemes.isColumnMode(context);

    final activityEntries = widget.topic.loadedActivities.entries.toList();
    activityEntries.sort(
      (a, b) => a.value.req.numberOfParticipants.compareTo(
        b.value.req.numberOfParticipants,
      ),
    );

    if (activityEntries.isEmpty) {
      return SizedBox();
    }

    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: activityEntries.length,
        itemBuilder: (context, index) {
          final activityEntry = activityEntries[index];
          final complete = widget.hasCompletedActivity(
            widget.room.client.userID!,
            activityEntry.key,
          );

          final activity = activityEntry.value;
          return Padding(
            padding: index != (activityEntries.length - 1)
                ? const EdgeInsets.only(right: 24.0)
                : EdgeInsets.zero,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => context.go(
                  "/rooms/spaces/${widget.room.id}/activity/${activityEntry.key}",
                ),
                child: Stack(
                  children: [
                    ActivitySuggestionCard(
                      activity: activity,
                      width: isColumnMode ? 160.0 : 120.0,
                      height: isColumnMode ? 280.0 : 200.0,
                      fontSize: isColumnMode ? 20.0 : 12.0,
                      fontSizeSmall: isColumnMode ? 12.0 : 8.0,
                      iconSize: isColumnMode ? 12.0 : 8.0,
                    ),
                    if (complete)
                      Container(
                        width: isColumnMode ? 160.0 : 120.0,
                        height: isColumnMode ? 280.0 : 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: theme.colorScheme.surface.withAlpha(180),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/pangea/check.svg",
                            width: 48.0,
                            height: 48.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
