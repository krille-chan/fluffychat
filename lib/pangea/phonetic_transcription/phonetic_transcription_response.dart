class PhoneticTranscriptionResponse {
  final Map<String, dynamic> arc;
  final Map<String, dynamic> content;
  final Map<String, dynamic> tokenization;
  final Map<String, dynamic> phoneticTranscriptionResult;
  DateTime? expireAt;

  PhoneticTranscriptionResponse({
    required this.arc,
    required this.content,
    required this.tokenization,
    required this.phoneticTranscriptionResult,
    this.expireAt,
  });

  factory PhoneticTranscriptionResponse.fromJson(Map<String, dynamic> json) {
    return PhoneticTranscriptionResponse(
      arc: Map<String, dynamic>.from(json['arc'] as Map),
      content: Map<String, dynamic>.from(json['content'] as Map),
      tokenization: Map<String, dynamic>.from(json['tokenization'] as Map),
      phoneticTranscriptionResult: Map<String, dynamic>.from(
          json['phonetic_transcription_result'] as Map),
      expireAt: json['expireAt'] == null
          ? null
          : DateTime.parse(json['expireAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arc': arc,
      'content': content,
      'tokenization': tokenization,
      'phonetic_transcription_result': phoneticTranscriptionResult,
      'expireAt': expireAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneticTranscriptionResponse &&
          runtimeType == other.runtimeType &&
          arc == other.arc &&
          content == other.content &&
          tokenization == other.tokenization &&
          phoneticTranscriptionResult == other.phoneticTranscriptionResult;

  @override
  int get hashCode =>
      arc.hashCode ^
      content.hashCode ^
      tokenization.hashCode ^
      phoneticTranscriptionResult.hashCode;
}
