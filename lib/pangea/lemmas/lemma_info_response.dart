import 'package:fluffychat/pangea/events/models/content_feedback.dart';

class LemmaInfoResponse implements JsonSerializable {
  final List<String> emoji;
  final String meaning;

  LemmaInfoResponse({
    required this.emoji,
    required this.meaning,
  });

  factory LemmaInfoResponse.fromJson(Map<String, dynamic> json) {
    return LemmaInfoResponse(
      emoji: (json['emoji'] as List<dynamic>).map((e) => e as String).toList(),
      meaning: json['meaning'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'meaning': meaning,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LemmaInfoResponse &&
          runtimeType == other.runtimeType &&
          emoji.length == other.emoji.length &&
          emoji.every((element) => other.emoji.contains(element)) &&
          meaning == other.meaning;

  @override
  int get hashCode =>
      emoji.fold(0, (prev, element) => prev ^ element.hashCode) ^
      meaning.hashCode;
}
