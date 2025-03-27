import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_generation_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_request.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_response.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_page.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'package:fluffychat/pangea/activity_planner/list_request_schema.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'activity_plan_card.dart';

class ActivityListView extends StatefulWidget {
  final Room? room;

  /// if null, show saved activities
  final ActivityPlanRequest? activityPlanRequest;

  final ActivityPlannerPageState controller;

  const ActivityListView({
    super.key,
    required this.room,
    required this.activityPlanRequest,
    required this.controller,
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

  String? _avatarURL;
  String? _filename;

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _setModeImageURL();
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
      if (mounted) setState(() => _isLoading = false);
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

  Future<ActivitySettingResponseSchema?> get _selectedMode async {
    final modes = await widget.controller.modeItems;
    return modes.firstWhereOrNull(
      (element) =>
          element.name.toLowerCase() ==
          widget.activityPlanRequest?.mode.toLowerCase(),
    );
  }

  Future<void> _setModeImageURL() async {
    final mode = await _selectedMode;
    if (mode == null) return;

    final modeName =
        mode.defaultName.toLowerCase().replaceAll(RegExp(r'\s+'), '');
    final filename =
        "${ActivitySuggestionsConstants.modeImageFileStart}$modeName.jpg";

    if (!mounted) return;
    setState(() {
      _avatarURL = "${AppConfig.assetsBaseURL}/$filename";
      _filename = filename;
    });
  }

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
            room: widget.room,
            onEdit: (updatedActivity) => _onEdit(index, updatedActivity),
            avatarURL: _avatarURL,
            initialFilename: _filename,
          );
        },
      );
    }
  }
}
