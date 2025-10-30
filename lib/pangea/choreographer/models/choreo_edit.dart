import 'dart:math';

/// Changes made to previous choreo step's text
/// Remove substring of length 'length', starting at position 'offset'
/// Then add String 'insert' at that position
class ChoreoEdit {
  int offset = 0;
  int length = 0;
  String insert = "";

  /// Normal constructor created from preexisting ChoreoEdit values
  ChoreoEdit({
    required this.offset,
    required this.length,
    required this.insert,
  });

  /// Constructor that determines and saves
  /// edits differentiating originalText and editedText
  ChoreoEdit.fromText({
    required String originalText,
    required String editedText,
  }) {
    if (originalText == editedText) {
      // No changes, return empty edit
      return;
    }

    offset = _firstDifference(originalText, editedText);
    length = _lastDifference(originalText, editedText) + 1 - offset;
    insert = _insertion(originalText, editedText);
  }

  factory ChoreoEdit.fromJson(Map<String, dynamic> json) {
    return ChoreoEdit(
      offset: json[_offsetKey],
      length: json[_lengthKey],
      insert: json[_insertKey],
    );
  }

  static const _offsetKey = "offst_v2";
  static const _lengthKey = "lngth_v2";
  static const _insertKey = "insrt_v2";

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[_offsetKey] = offset;
    data[_lengthKey] = length;
    data[_insertKey] = insert;
    return data;
  }

  /// Find index of first character where strings differ
  int _firstDifference(String originalText, String editedText) {
    var i = 0;
    final minLength = min(originalText.length, editedText.length);
    while (i < minLength && originalText[i] == editedText[i]) {
      i++;
    }
    return i;
  }

  /// Starting at the end of both text versions,
  /// traverse backward until a non-matching char is found
  int _lastDifference(String originalText, String editedText) {
    var i = originalText.length - 1;
    var j = editedText.length - 1;
    while (min(i, j) >= offset && originalText[i] == editedText[j]) {
      i--;
      j--;
    }
    return i;
  }

  /// Length of inserted text is the length of deleted text,
  /// plus the difference in string length
  /// If dif is -x and length of deleted text is x,
  /// inserted text is empty string
  String _insertion(String originalText, String editedText) {
    final insertLength = length + (editedText.length - originalText.length);
    return editedText.substring(offset, offset + insertLength);
  }

  /// Given the original string, use offset, length, and insert
  /// to find the edited version of the string
  String editedText(String originalText) {
    return originalText.replaceRange(offset, offset + length, insert);
  }
}
