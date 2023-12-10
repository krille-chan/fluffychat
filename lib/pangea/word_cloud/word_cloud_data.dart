class WordCloudData {
  List<Map> data = [];

  WordCloudData({
    required this.data,
  }) {
    data = (data..sort((a, b) => (a['value'] ?? 0).compareTo(b['value'] ?? 0)))
        .reversed
        .toList();
  }

  void addDataAsMapList(List<Map> newdata) {
    data.addAll(newdata);
    data = (data..sort((a, b) => a['value'].compareTo(b['value'])))
        .reversed
        .toList();
  }

  void addData(String word, double value) {
    data.add({'word': word, 'value': value});
    data = (data..sort((a, b) => a['value'].compareTo(b['value'])))
        .reversed
        .toList();
  }

  List<Map> getData() {
    return data;
  }
}
