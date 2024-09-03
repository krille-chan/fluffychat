import 'dart:async';

class MessageTextSelection {
  String? selectedText;
  String messageText = "";
  final StreamController<String?> selectionStream =
      StreamController<String?>.broadcast();

  void setMessageText(String text) {
    messageText = text;
  }

  void onSelection(String? text) => text == null || text.isEmpty
      ? clearTextSelection()
      : setTextSelection(text);

  void setTextSelection(String selection) {
    selectedText = selection;
    selectionStream.add(selectedText);
  }

  void clearTextSelection() {
    selectedText = null;
    selectionStream.add(selectedText);
  }

  int get offset => messageText.indexOf(selectedText!);
}
