class Lemma {
  final String text;
  final String form;
  final bool saveVocab;

  Lemma({required this.text, required this.saveVocab, required this.form});

  factory Lemma.fromJson(Map<String, dynamic> json) {
    return Lemma(
      text: json['text'],
      saveVocab: json['save_vocab'] ?? json['saveVocab'] ?? false,
      form: json["form"] ?? json['text'],
    );
  }

  toJson() {
    return {'text': text, 'save_vocab': saveVocab, 'form': form};
  }

  static Lemma get empty => Lemma(text: '', saveVocab: true, form: '');

  static Lemma create(String form) =>
      Lemma(text: '', saveVocab: true, form: form);
}
