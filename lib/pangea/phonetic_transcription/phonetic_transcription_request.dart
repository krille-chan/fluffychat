import 'package:fluffychat/pangea/events/models/pangea_token_text_model.dart';
import 'package:fluffychat/pangea/learning_settings/models/language_model.dart';

class PhoneticTranscriptionRequest {
  final LanguageArc arc;
  final PangeaTokenText content;
  final bool requiresTokenization;

  PhoneticTranscriptionRequest({
    required this.arc,
    required this.content,
    this.requiresTokenization = false,
  });

  factory PhoneticTranscriptionRequest.fromJson(Map<String, dynamic> json) {
    return PhoneticTranscriptionRequest(
      arc: LanguageArc.fromJson(json['arc'] as Map<String, dynamic>),
      content:
          PangeaTokenText.fromJson(json['content'] as Map<String, dynamic>),
      requiresTokenization: json['requires_tokenization'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'arc': arc.toJson(),
      'content': content.toJson(),
      'requires_tokenization': requiresTokenization,
    };
  }

  String get storageKey => '${arc.l1}-${arc.l2}-${content.hashCode}';
}
