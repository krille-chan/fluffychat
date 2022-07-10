extension SizeString on num {
  String get sizeString {
    var size = toDouble();
    if (size < 1000000) {
      size = size / 1000;
      size = (size * 10).round() / 10;
      return '${size.toString()} KB';
    } else if (size < 1000000000) {
      size = size / 1000000;
      size = (size * 10).round() / 10;
      return '${size.toString()} MB';
    } else {
      size = size / 1000000000;
      size = (size * 10).round() / 10;
      return '${size.toString()} GB';
    }
  }
}
