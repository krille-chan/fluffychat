import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';
import 'package:fluffychat/pangea/activity_planner/activity_planner_page.dart';
import 'package:fluffychat/pangea/activity_planner/bookmarked_activities_repo.dart';
import 'activity_plan_card.dart';

class BookmarkedActivitiesList extends StatefulWidget {
  final Room? room;

  final ActivityPlannerPageState controller;

  const BookmarkedActivitiesList({
    super.key,
    required this.room,
    required this.controller,
  });

  @override
  BookmarkedActivitiesListState createState() =>
      BookmarkedActivitiesListState();
}

class BookmarkedActivitiesListState extends State<BookmarkedActivitiesList> {
  List<ActivityPlanModel> get _bookmarkedActivities =>
      BookmarkedActivitiesRepo.get();

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    if (_bookmarkedActivities.isEmpty) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Text(
            l10n.noBookmarkedActivities,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _bookmarkedActivities.length,
        itemBuilder: (context, index) {
          final activity = _bookmarkedActivities[index];
          return ActivityPlanCard(
            activity: activity,
            room: widget.room,
            onEdit: (updatedActivity) async {
              await BookmarkedActivitiesRepo.remove(activity.bookmarkId);
              await BookmarkedActivitiesRepo.save(updatedActivity);
              setState(() {});
            },
            onChange: () => setState(() {}),
          );
        },
      ),
    );
  }
}
