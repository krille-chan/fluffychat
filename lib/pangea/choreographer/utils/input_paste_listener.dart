import 'package:flutter/material.dart';

import 'package:fluffychat/pangea/choreographer/enums/edit_type.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/pangea_text_controller.dart';

class InputPasteListener {
  final PangeaTextController controller;
  final Function(String) onPaste;

  String _currentText = '';

  InputPasteListener(
    this.controller,
    this.onPaste,
  ) {
    controller.addListener(() {
      final difference =
          controller.text.characters.length - _currentText.characters.length;
      if (difference > 1 && controller.editType == EditType.keyboard) {
        onPaste(
          controller.text.characters
              .getRange(
                _currentText.characters.length,
                controller.text.characters.length,
              )
              .join(),
        );
      }
      _currentText = controller.text;
    });
  }
}
