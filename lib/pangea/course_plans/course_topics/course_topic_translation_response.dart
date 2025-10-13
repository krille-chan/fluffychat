import 'package:fluffychat/pangea/course_plans/course_topics/course_topic_model.dart';

class TranslateTopicResponse {
  final Map<String, CourseTopicModel> topics;

  TranslateTopicResponse({required this.topics});

  factory TranslateTopicResponse.fromJson(Map<String, dynamic> json) {
    final topicsEntry = json['topics'] as Map<String, dynamic>;
    return TranslateTopicResponse(
      topics: topicsEntry.map(
        (key, value) => MapEntry(
          key,
          CourseTopicModel.fromJson(value),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "topics": topics.map((key, value) => MapEntry(key, value.toJson())),
      };
}
