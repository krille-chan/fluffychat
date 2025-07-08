class LemmaEditRequest {
  String lemma;
  String partOfSpeech;
  String lemmaLang;
  String userL1;

  String? newMeaning;
  List<String>? newEmojis;

  LemmaEditRequest({
    required this.lemma,
    required this.partOfSpeech,
    required this.lemmaLang,
    required this.userL1,
    this.newMeaning,
    this.newEmojis,
  });

  Map<String, dynamic> toJson() {
    return {
      "lemma": lemma,
      "part_of_speech": partOfSpeech,
      "lemma_lang": lemmaLang,
      "user_l1": userL1,
      "new_meaning": newMeaning,
      "new_emojis": newEmojis,
    };
  }

  factory LemmaEditRequest.fromJson(Map<String, dynamic> json) {
    return LemmaEditRequest(
      lemma: json["lemma"],
      partOfSpeech: json["part_of_speech"],
      lemmaLang: json["lemma_lang"],
      userL1: json["user_l1"],
      newMeaning: json["new_meaning"],
      newEmojis: List<String>.from(json["new_emojis"] ?? []),
    );
  }
}
