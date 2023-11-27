// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Project imports:
import 'user_model.dart';

class UserProfileSearchResponse {
  int count;
  String? next;
  String? previous;
  List<Profile> results;

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
          .map((p) => Profile.fromJson(p))
          .toList()
          .cast<Profile>(),
    );
  }
}
