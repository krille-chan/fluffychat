class WordCloudTap {
  Map<String, Function> wordtap = {};

  void addWordtap(String word, Function func) {
    wordtap[word] = func;
  }

  Map<String, Function> getWordTaps() {
    return wordtap;
  }
}
