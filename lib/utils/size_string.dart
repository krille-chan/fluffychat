extension SizeString on num {
  String get sizeString {
    var size = toDouble();
    if (size < 1000) {
      return '${size.round()} Bytes';
    }
    if (size < 1000 * 1000) {
      size = size / 1000;
      size = (size * 10).round() / 10;
      return '${size.toString()} KB';
    }
    if (size < 1000 * 1000 * 1000) {
      size = size / 1000000;
      size = (size * 10).round() / 10;
      return '${size.toString()} MB';
    }
    size = size / 1000 * 1000 * 1000 * 1000;
    size = (size * 10).round() / 10;
    return '${size.toString()} GB';
  }
}
