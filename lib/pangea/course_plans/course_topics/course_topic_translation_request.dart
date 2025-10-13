class TranslateTopicRequest {
  List<String> topicIds;
  String l1;

  TranslateTopicRequest({
    required this.topicIds,
    required this.l1,
  });

  Map<String, dynamic> toJson() => {
        "topic_ids": topicIds,
        "l1": l1,
      };

  factory TranslateTopicRequest.fromJson(Map<String, dynamic> json) {
    return TranslateTopicRequest(
      topicIds:
          json['topic_ids'] != null ? List<String>.from(json['topic_ids']) : [],
      l1: json['l1'],
    );
  }
}
