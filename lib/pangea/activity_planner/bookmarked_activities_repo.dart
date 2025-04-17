// ignore_for_file: depend_on_referenced_packages

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';

class BookmarkedActivitiesRepo {
  static final GetStorage _bookStorage = GetStorage('bookmarked_activities');

  /// save an activity to the list of bookmarked activities
  /// returns the activity with a bookmarkId
  static Future<ActivityPlanModel> save(
    ActivityPlanModel activity,
  ) async {
    await _bookStorage.write(
      activity.bookmarkId,
      activity.toJson(),
    );

    //now it has a bookmarkId
    return activity;
  }

  static Future<void> remove(String bookmarkId) =>
      _bookStorage.remove(bookmarkId);

  static bool isBookmarked(ActivityPlanModel activity) {
    return _bookStorage.read(activity.bookmarkId) != null;
  }

  static List<ActivityPlanModel> get() {
    final List<String> keys = List<String>.from(_bookStorage.getKeys());
    if (keys.isEmpty) return [];

    final List<ActivityPlanModel> activities = [];
    for (final key in keys) {
      final json = _bookStorage.read(key);
      if (json == null) continue;
      final activity = ActivityPlanModel.fromJson(json);
      if (key != activity.bookmarkId) {
        _bookStorage.remove(key);
        _bookStorage.write(activity.bookmarkId, activity.toJson());
      }
      activities.add(activity);
    }

    return activities;
  }
}
