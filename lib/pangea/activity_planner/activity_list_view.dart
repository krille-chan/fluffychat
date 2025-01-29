import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_generation_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_response.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'activity_plan_card.dart';

class ActivityListView extends StatefulWidget {
  final Room? room;

  /// if null, show saved activities
  final ActivityPlanRequest? activityPlanRequest;

  const ActivityListView({
    super.key,
    required this.room,
    required this.activityPlanRequest,
  });

  @override
  ActivityListViewState createState() => ActivityListViewState();
}

class ActivityListViewState extends State<ActivityListView> {
  List<ActivityPlanModel>? _activities;
  List<ActivityPlanModel> get _bookmarkedActivities =>
      BookmarkedActivitiesRepo.get();

  bool _isLoading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (widget.activityPlanRequest != null) {
        final resp = await ActivityPlanGenerationRepo.get(
          widget.activityPlanRequest!,
        );
        _activities = resp.activityPlans;
      }
    } catch (e, s) {
      _error = e;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'room': widget.room,
          'activityPlanRequest': widget.activityPlanRequest,
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onEdit(int index, ActivityPlanModel updatedActivity) async {
    // in this case we're editing an activity plan that was generated recently
    // via the repo and should be updated in the cached response
    if (widget.activityPlanRequest != null && _activities != null) {
      final activities = _activities;
      activities?[index] = updatedActivity;
      ActivityPlanGenerationRepo.set(
        widget.activityPlanRequest!,
        ActivityPlanResponse(activityPlans: _activities!),
      );
    }

    setState(() {});
  }

  Future<void> _onLaunch(int index) => showFutureLoadingDialog(
        context: context,
        future: () async {
          final activity = _activities![index];

          final eventId = await widget.room?.pangeaSendTextEvent(
            activity.markdown,
            messageTag: ModelKey.messageTagActivityPlan,
            //include full model or should we move to a state event for this?
          );

          if (eventId == null) {
            debugger(when: kDebugMode);
            return;
          }

          await widget.room?.setPinnedEvents([eventId]);

          Navigator.of(context).pop();
        },
      );

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.oopsSomethingWentWrong),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadActivities,
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      );
    } else if (widget.activityPlanRequest != null &&
        (_activities == null || _activities!.isEmpty)) {
      return Center(child: Text(l10n.noDataFound));
    } else if (widget.activityPlanRequest == null &&
        (_bookmarkedActivities.isEmpty)) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            l10n.noBookmarkedActivities,
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.activityPlanRequest == null
            ? _bookmarkedActivities.length
            : _activities!.length,
        itemBuilder: (context, index) {
          return ActivityPlanCard(
            activity: widget.activityPlanRequest == null
                ? _bookmarkedActivities[index]
                : _activities![index],
            onLaunch: () => _onLaunch(index),
            onEdit: (updatedActivity) => _onEdit(index, updatedActivity),
          );
        },
      );
    }
  }
}
