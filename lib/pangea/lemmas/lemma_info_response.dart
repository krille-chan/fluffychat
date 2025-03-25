import 'package:fluffychat/pangea/events/models/content_feedback.dart';

class LemmaInfoResponse implements JsonSerializable {
  final List<String> emoji;
  final String meaning;
  DateTime? expireAt;

  LemmaInfoResponse({
    required this.emoji,
    required this.meaning,
    this.expireAt,
  });

  factory LemmaInfoResponse.fromJson(Map<String, dynamic> json) {
    return LemmaInfoResponse(
      // NOTE: This is a workaround for the fact that the server sometimes sends more than 3 emojis
      emoji: (json['emoji'] as List<dynamic>).map((e) => e as String).toList(),
      meaning: json['meaning'] as String,
      expireAt: json['expireAt'] == null
          ? null
          : DateTime.parse(json['expireAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'meaning': meaning,
      'expireAt': expireAt?.toIso8601String(),
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
