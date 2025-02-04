/// Represents a lemma object
class Lemma {
  /// [text] ex "ir" - text of the lemma of the word
  String text;

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
}
