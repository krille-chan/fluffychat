abstract class JsonSerializable {
  Map<String, dynamic> toJson();
  factory JsonSerializable.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}

class ContentFeedback<T extends JsonSerializable> {
  final JsonSerializable content;
  final String feedback;

  ContentFeedback(this.content, this.feedback);

  toJson() {
    return {
      'content': content.toJson(),
      'feedback': feedback,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentFeedback &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          feedback == other.feedback;

  @override
  int get hashCode => content.hashCode ^ feedback.hashCode;
}
