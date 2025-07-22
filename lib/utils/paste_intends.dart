import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pasteboard/pasteboard.dart';

class PasteImageIntent extends Intent {
  const PasteImageIntent();
}

/// Handles PasteImageIntent.
/// If an image is found it calls [onImage] and stops there.
/// If not, it re-issues PasteTextIntent **inside the focused EditableText
/// subtree**, so default paste kicks in.
class PasteImageAction extends Action<PasteImageIntent> {
  PasteImageAction(this.onImage);

  final ValueChanged<Uint8List> onImage;

  @override
  Future<Object?> invoke(covariant PasteImageIntent intent) async {
    final bytes = await Pasteboard.image;
    if (bytes != null) {
      onImage(bytes);
      return null;
    }

    // No image ⇒ forward the “paste text” to whoever is focused now.
    final focused = WidgetsBinding.instance.focusManager.primaryFocus;
    if (focused?.context != null) {
      return Actions.invoke(
        focused!.context!,
        const PasteTextIntent(SelectionChangedCause.keyboard),
      );
    }
    return null;
  }

  @override
  bool get isActionEnabled => true;
}
