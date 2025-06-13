class PhoneticTranscriptionRequest {
  final String l1;
  final String l2;
  final String content;
  final bool requiresTokenization;

  PhoneticTranscriptionRequest({
    required this.l1,
    required this.l2,
    required this.content,
    this.requiresTokenization = true,
  });

  factory PhoneticTranscriptionRequest.fromJson(Map<String, dynamic> json) {
    return PhoneticTranscriptionRequest(
      l1: json['l1'] as String,
      l2: json['l2'] as String,
      content: json['content'] as String,
      requiresTokenization: json['requires_tokenization'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'l1': l1,
      'l2': l2,
      'content': content,
      'requires_tokenization': requiresTokenization,
    };
  }

  String get storageKey => 'l1:$l1,l2:$l2,content:$content';
}
