import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';

class ActivitiesProfileModel {
  final List<String> _bookmarkedActivities;

  ActivitiesProfileModel({
    required List<String> bookmarkedActivities,
  }) : _bookmarkedActivities = bookmarkedActivities;

  static ActivitiesProfileModel get empty => ActivitiesProfileModel(
        bookmarkedActivities: [],
      );

  bool isBookmarked(String id) => _bookmarkedActivities.contains(id);

  void addBookmark(String activityId) {
    if (!_bookmarkedActivities.contains(activityId)) {
      _bookmarkedActivities.add(activityId);
    }
  }

  void removeBookmark(String activityId) {
    _bookmarkedActivities.remove(activityId);
  }

  // Future<List<ActivityPlanModel>> getBookmarkedActivities() => Future.wait(
  //       _bookmarkedActivities.map((id) => ActivityPlanRepo.get(id)).toList(),
  //     );

  // List<ActivityPlanModel> getBookmarkedActivitiesSync() => _bookmarkedActivities
  //     .map((id) => ActivityPlanRepo.getCached(id))
  //     .whereType<ActivityPlanModel>()
  //     .toList();

  static ActivitiesProfileModel fromJson(Map<String, dynamic> json) {
    if (!json.containsKey(PangeaEventTypes.profileActivities)) {
      return ActivitiesProfileModel.empty;
    }

    final profileJson = json[PangeaEventTypes.profileActivities];
    return ActivitiesProfileModel(
      bookmarkedActivities:
          List<String>.from(profileJson[ModelKey.bookmarkedActivities] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ModelKey.bookmarkedActivities: _bookmarkedActivities,
    };
  }
}
