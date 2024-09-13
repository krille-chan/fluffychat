import 'package:fluffychat/pangea/enum/construct_type_enum.dart';
import 'package:fluffychat/pangea/enum/construct_use_type_enum.dart';
import 'package:fluffychat/pangea/models/analytics/constructs_model.dart';

/// Represents a lemma object
class Lemma {
  /// [text] ex "ir" - text of the lemma of the word
  final String text;

  /// [form] ex "vamos" - conjugated form of the lemma and as it appeared in some original text
  final String form;

  /// [saveVocab] true - whether to save the lemma to the user's vocabulary
  /// vocab that are not saved: emails, urls, numbers, punctuation, etc.
  /// server handles this determination
  final bool saveVocab;

  Lemma({
    required this.text,
    required this.saveVocab,
    required this.form,
  });

  factory Lemma.fromJson(Map<String, dynamic> json) {
    return Lemma(
      text: json['text'],
      saveVocab: json['save_vocab'] ?? json['saveVocab'] ?? false,
      form: json["form"] ?? json['text'],
    );
  }

  toJson() {
    return {
      'text': text,
      'save_vocab': saveVocab,
      'form': form,
    };
  }

  static Lemma create(String form) =>
      Lemma(text: '', saveVocab: true, form: form);

  /// Given a [type] and [metadata], returns a [OneConstructUse] for this lemma
  OneConstructUse toVocabUse(
    ConstructUseTypeEnum type,
    ConstructUseMetaData metadata,
  ) {
    return OneConstructUse(
      useType: type,
      lemma: text,
      form: form,
      constructType: ConstructTypeEnum.vocab,
      metadata: metadata,
    );
  }
}
