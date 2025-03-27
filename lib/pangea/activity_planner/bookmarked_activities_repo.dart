// ignore_for_file: depend_on_referenced_packages

import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/activity_planner/activity_plan_model.dart';

class BookmarkedActivitiesRepo {
  static final GetStorage _bookStorage = GetStorage('bookmarked_activities');

  /// save an activity to the list of bookmarked activities
  /// returns the activity with a bookmarkId
  static Future<ActivityPlanModel> save(ActivityPlanModel activity) async {
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
    final list = _bookStorage.getValues();

    if (list == null) return [];

    return (list as Iterable)
        .map((json) => ActivityPlanModel.fromJson(json))
        .toList();
  }
}
