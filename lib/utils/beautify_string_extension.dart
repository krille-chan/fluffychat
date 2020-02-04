extension BeautifyStringExtension on String {
  String get beautified {
    String beautifiedStr = "";
    for (int i = 0; i < this.length; i++) {
      beautifiedStr += this.substring(i, i + 1);
      if (i % 4 == 3) {
        beautifiedStr += "    ";
      }
      if (i % 16 == 15) {
        beautifiedStr += "\n";
      }
    }
    return beautifiedStr;
  }
}
