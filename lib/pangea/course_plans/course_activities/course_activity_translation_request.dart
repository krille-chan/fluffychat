class TranslateActivityRequest {
  List<String> activityIds;
  String l1;

  TranslateActivityRequest({
    required this.activityIds,
    required this.l1,
  });

  Map<String, dynamic> toJson() => {
        "activity_ids": activityIds,
        "l1": l1,
      };

  factory TranslateActivityRequest.fromJson(Map<String, dynamic> json) {
    return TranslateActivityRequest(
      activityIds: json['activity_ids'] != null
          ? List<String>.from(json['activity_ids'])
          : [],
      l1: json['l1'],
    );
  }
}
