class PTextTapModel {
  late int cursorOffset;
  late String word;
  late bool isHighLighted;
  late int textAtOffSet;
  PTextTapModel(
      {required this.cursorOffset,
      required this.isHighLighted,
      required this.textAtOffSet,
      required this.word});
  toJson() {
    return {
      'cursorOffset': cursorOffset,
      'word': word,
      'isHighlighted': isHighLighted,
      'textAtOffSet': textAtOffSet
    };
  }
}
