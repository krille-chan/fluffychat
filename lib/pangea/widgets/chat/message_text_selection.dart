import 'dart:async';

/// Contains information about the text currently being shown in a
/// toolbar overlay message and any selection within that text.
/// The ChatController contains one instance of this class, and it's values
/// should be updated each time an overlay is openned or closed, or when
/// an overlay's text selection changes.
class MessageTextSelection {
  /// The currently selected text in the overlay message.
  String? selectedText;

  /// The full text displayed in the overlay message.
  String? messageText;

  /// A stream that emits the currently selected text whenever it changes.
  final StreamController<String?> selectionStream =
      StreamController<String?>.broadcast();

  /// Sets messageText to match the text currently being displayed in the overlay.
  /// Text in messages is displayed in a variety of ways, i.e., direct message content,
  /// translation, HTML rendered message, etc. This method should be called wherever the
  /// text displayed in the overlay is determined.
  void setMessageText(String text) => messageText = text;

  /// Clears the messageText value. Called when the message selection overlay is closed.
  void clearMessageText() => messageText = null;

  /// Updates the selectedText value and emits it to the selectionStream.
  void onSelection(String? text) {
    text == null || text.isEmpty ? selectedText = null : selectedText = text;
    selectionStream.add(selectedText);
  }

  /// Returns the index of the selected text within the message text.
  /// If the selected text is not found, returns null.
  int? get offset {
    if (selectedText == null || messageText == null) return null;
    final index = messageText!.indexOf(selectedText!);
    return index > -1 ? index : null;
  }
}
