/// Represents a lemma object
class Lemma {
  /// [text] ex "ir" - text of the lemma of the word
  final String text;

  /// [form] ex "vamos" - conjugated form of the lemma and as it appeared in some original text
  final String form;

  /// [saveVocab] true - whether to save the lemma to the user's vocabulary
  /// vocab that are not saved: emails, urls, numbers, punctuation, etc.
  final bool saveVocab;

  /// [pos] ex "v" - part of speech of the lemma
  /// https://universaldependencies.org/u/pos/
  final String pos;

  /// [morph] ex {} - morphological features of the lemma
  /// https://universaldependencies.org/u/feat/
  final Map<String, String> morph;

  Lemma(
      {required this.text,
      required this.saveVocab,
      required this.form,
      this.pos = '',
      this.morph = const {}});

  factory Lemma.fromJson(Map<String, dynamic> json) {
    return Lemma(
      text: json['text'],
      saveVocab: json['save_vocab'] ?? json['saveVocab'] ?? false,
      form: json["form"] ?? json['text'],
      pos: json['pos'] ?? '',
      morph: json['morph'] ?? {},
    );
  }

  toJson() {
    return {
      'text': text,
      'save_vocab': saveVocab,
      'form': form,
      'pos': pos,
      'morph': morph
    };
  }

  static Lemma create(String form) =>
      Lemma(text: '', saveVocab: true, form: form);
}
