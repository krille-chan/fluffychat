import 'dart:async';
import 'dart:typed_data';

import 'package:fluffychat/pages/chat/input_bar.dart';
import 'package:fluffychat/pangea/widgets/igc/pangea_text_controller.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';

class InputBarWrapper extends StatefulWidget {
  final Room room;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<Uint8List?>? onSubmitImage;
  final FocusNode? focusNode;
  final PangeaTextController? controller;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final bool? autofocus;
  final bool readOnly;

  const InputBarWrapper({
    required this.room,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.onSubmitted,
    this.onSubmitImage,
    this.focusNode,
    this.controller,
    this.decoration,
    this.onChanged,
    this.autofocus,
    this.textInputAction,
    this.readOnly = false,
    super.key,
  });

  @override
  State<InputBarWrapper> createState() => InputBarWrapperState();
}

class InputBarWrapperState extends State<InputBarWrapper> {
  StreamSubscription? _choreoSub;
  String _currentText = '';

  @override
  void initState() {
    // Rebuild the widget each time there's an update from choreo
    _choreoSub =
        widget.controller?.choreographer.stateListener.stream.listen((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _choreoSub?.cancel();
    super.dispose();
  }

  void refreshOnChange(String text) {
    if (widget.onChanged != null) {
      widget.onChanged!(text);
    }

    final bool decreasedFromMaxLength =
        _currentText.length >= PangeaTextController.maxLength &&
            text.length < PangeaTextController.maxLength;
    final bool reachedMaxLength =
        _currentText.length < PangeaTextController.maxLength &&
            text.length < PangeaTextController.maxLength;

    if (decreasedFromMaxLength || reachedMaxLength) {
      setState(() {});
    }
    _currentText = text;
  }

  @override
  Widget build(BuildContext context) {
    return InputBar(
      room: widget.room,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      onSubmitted: widget.onSubmitted,
      onSubmitImage: widget.onSubmitImage,
      focusNode: widget.focusNode,
      controller: widget.controller,
      decoration: widget.decoration,
      onChanged: refreshOnChange,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      readOnly: widget.readOnly,
    );
  }
}
