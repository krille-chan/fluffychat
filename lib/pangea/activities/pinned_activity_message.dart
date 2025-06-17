import 'dart:async';

import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/chat/chat.dart';
import 'package:fluffychat/pages/chat/chat_app_bar_list_tile.dart';
import 'package:fluffychat/pangea/activities/activity_aware_builder.dart';
import 'package:fluffychat/pangea/activities/activity_duration_popup.dart';
import 'package:fluffychat/pangea/activities/countdown.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

class PinnedActivityMessage extends StatelessWidget {
  final ChatController controller;

  const PinnedActivityMessage(this.controller, {super.key});

  Future<void> _scrollToEvent() async {
    final eventId = _activityPlanEvent?.eventId;
    if (eventId != null) controller.scrollToEventId(eventId);
  }

  Event? get _activityPlanEvent => controller.timeline?.events.firstWhereOrNull(
        (event) => event.type == PangeaEventTypes.activityPlan,
      );

  ActivityPlanModel? get _activityPlan => controller.room.activityPlan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActivityAwareBuilder(
      deadline: _activityPlan?.endAt,
      builder: (isActive) {
        if (!isActive || _activityPlan == null) {
          return const SizedBox.shrink();
        }

        return ChatAppBarListTile(
          title: _activityPlan!.title,
          leading: IconButton(
            splashRadius: 18,
            iconSize: 18,
            color: theme.colorScheme.onSurfaceVariant,
            icon: const Icon(Icons.push_pin),
            onPressed: () {},
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () async {
                final Duration? duration = await showDialog(
                  context: context,
                  builder: (context) {
                    return ActivityDurationPopup(
                      initialValue:
                          _activityPlan?.duration ?? const Duration(days: 1),
                    );
                  },
                );

                if (duration == null) return;

                showFutureLoadingDialog(
                  context: context,
                  future: () => controller.room.sendActivityPlan(
                    _activityPlan!.copyWith(
                      endAt: DateTime.now().add(duration),
                      duration: duration,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CountDown(
                  deadline: _activityPlan!.endAt,
                  iconSize: 16.0,
                  textSize: 14.0,
                ),
              ),
            ),
          ),
          onTap: _scrollToEvent,
        );
      },
    );
  }
}
