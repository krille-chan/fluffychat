extension ReturnShuffle on List {
  List<dynamic> shuffleReturn() {
    // final List<dynamic> copyList = toList();
    shuffle();
    return this;
    // return copyList;
  }
}
