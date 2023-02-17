extension BeautifyStringExtension on String {
  String get beautified {
    var beautifiedStr = '';
    for (var i = 0; i < length; i++) {
      beautifiedStr += substring(i, i + 1);
      if (i % 4 == 3) {
        beautifiedStr += ' ';
      }
      if (i % 16 == 15) {
        beautifiedStr += '\n';
      }
    }
    return beautifiedStr;
  }
}
