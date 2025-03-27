import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_generation_repo.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_plan_response.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_page.dart';
import 'package:fluffychat/pangea/activity_planner/list_request_schema.dart';
import 'package:fluffychat/pangea/activity_suggestions/activity_suggestions_constants.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'activity_plan_card.dart';

class GeneratedActivitiesList extends StatefulWidget {
  final ActivityPlannerPageState controller;

  const GeneratedActivitiesList({
    super.key,
    required this.controller,
  });

  @override
  GeneratedActivitiesListState createState() => GeneratedActivitiesListState();
}

class GeneratedActivitiesListState extends State<GeneratedActivitiesList> {
  List<ActivityPlanModel>? _activities;
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
      final resp = await ActivityPlanGenerationRepo.get(
        widget.controller.planRequest,
      );
      _activities = resp.activityPlans;
    } catch (e, s) {
      _error = e;
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          'activityPlanRequest': widget.controller.planRequest,
        },
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  Future<void> _onEdit(int index, ActivityPlanModel updatedActivity) async {
    // in this case we're editing an activity plan that was generated recently
    // via the repo and should be updated in the cached response
    if (_activities != null) {
      final activities = _activities;
      activities?[index] = updatedActivity;
      ActivityPlanGenerationRepo.set(
        widget.controller.planRequest,
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
          widget.controller.planRequest.mode.toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
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
    } else if (_activities == null || _activities!.isEmpty) {
      return Center(child: Text(l10n.noDataFound));
    } else {
      return Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _activities!.length,
          itemBuilder: (context, index) {
            return ActivityPlanCard(
              activity: _activities![index],
              room: widget.controller.room,
              onEdit: (updatedActivity) => _onEdit(index, updatedActivity),
              avatarURL: _avatarURL,
              initialFilename: _filename,
              onChange: () => setState(() {}),
            );
          },
        ),
      );
    }
  }
}
