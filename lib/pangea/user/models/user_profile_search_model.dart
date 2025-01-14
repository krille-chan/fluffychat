import 'user_model.dart';

class UserProfileSearchResponse {
  int count;
  String? next;
  String? previous;
  List<PangeaProfile> results;

  UserProfileSearchResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory UserProfileSearchResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileSearchResponse(
      count: json["count"],
      next: json["next"],
      previous: json["previous"],
      results: json["results"]
          .map((p) => PangeaProfile.fromJson(p))
          .toList()
          .cast<PangeaProfile>(),
    );
  }
}
