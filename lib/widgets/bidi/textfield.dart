import 'dart:ui' as ui;

import 'package:fluffychat/utils/bidi.dart';
import 'package:flutter/gestures.dart' as gestures;
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart' as services;

// encapsulates material.TextField
class TextField extends material.StatefulWidget {
  const TextField({
    super.key,
    this.groupId = material.EditableText,
    this.controller,
    this.focusNode,
    this.undoController,
    this.decoration = const material.InputDecoration(),
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = material.TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = material.TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.statesController,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.keyboardAppearance,
    this.scrollPadding = const material.EdgeInsets.all(20.0),
    this.dragStartBehavior = gestures.DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectAllOnFocus,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.onTapUpOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = material.Clip.hardEdge,
    this.restorationId,
    this.stylusHandwritingEnabled =
        material.EditableText.defaultStylusHandwritingEnabled,
    this.enableIMEPersonalizedLearning = true,
    this.enableInlinePrediction,
    this.canRequestFocus = true,
    this.magnifierConfiguration,
    this.hintLocales,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
  });
  final material.TextMagnifierConfiguration? magnifierConfiguration;
  final Object groupId;
  final material.TextEditingController? controller;
  final material.FocusNode? focusNode;
  final material.InputDecoration? decoration;
  final material.TextInputType? keyboardType;
  final material.TextInputAction? textInputAction;
  final material.TextCapitalization textCapitalization;
  final material.TextStyle? style;
  final material.StrutStyle? strutStyle;
  final material.TextAlign textAlign;
  final material.TextAlignVertical? textAlignVertical;
  final material.TextDirection? textDirection;
  final bool autofocus;
  // ignore: deprecated_member_use
  final material.MaterialStatesController? statesController;
  final String obscuringCharacter;
  final bool obscureText;
  final bool? autocorrect;
  final material.SmartDashesType? smartDashesType;
  final material.SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final bool readOnly;
  final bool? showCursor;
  static const int noMaxLength = -1;
  final int? maxLength;
  final services.MaxLengthEnforcement? maxLengthEnforcement;
  final material.ValueChanged<String>? onChanged;
  final material.VoidCallback? onEditingComplete;
  final material.ValueChanged<String>? onSubmitted;
  final material.AppPrivateCommandCallback? onAppPrivateCommand;
  final List<services.TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? ignorePointers;
  final double cursorWidth;
  final double? cursorHeight;
  final material.Radius? cursorRadius;
  final bool? cursorOpacityAnimates;
  final material.Color? cursorColor;
  final material.Color? cursorErrorColor;
  final ui.BoxHeightStyle? selectionHeightStyle;
  final ui.BoxWidthStyle? selectionWidthStyle;
  final material.Brightness? keyboardAppearance;
  final material.EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final bool? selectAllOnFocus;
  final material.TextSelectionControls? selectionControls;
  final gestures.DragStartBehavior dragStartBehavior;
  bool? get selectionEnabled => enableInteractiveSelection;
  final material.GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final material.TapRegionCallback? onTapOutside;
  final material.TapRegionUpCallback? onTapUpOutside;
  final material.MouseCursor? mouseCursor;
  final material.InputCounterWidgetBuilder? buildCounter;
  final material.ScrollPhysics? scrollPhysics;
  final material.ScrollController? scrollController;
  final Iterable<String>? autofillHints;
  final material.Clip clipBehavior;
  final String? restorationId;
  final bool stylusHandwritingEnabled;
  final bool enableIMEPersonalizedLearning;
  final bool? enableInlinePrediction;
  final material.ContentInsertionConfiguration? contentInsertionConfiguration;
  final bool canRequestFocus;
  final material.UndoHistoryController? undoController;
  final List<material.Locale>? hintLocales;
  final material.EditableTextContextMenuBuilder? contextMenuBuilder;

  // code from flutter/lib/src/material/text_field.dart
  static material.Widget _defaultContextMenuBuilder(
    material.BuildContext context,
    material.EditableTextState editableTextState,
  ) {
    if (material.SystemContextMenu.isSupportedByField(editableTextState)) {
      return material.SystemContextMenu.editableText(
        editableTextState: editableTextState,
      );
    }
    return material.AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  material.State<TextField> createState() => TextFieldState();
}

class TextFieldState extends material.State<TextField> {
  material.TextDirection? textDirection;

  @override
  void initState() {
    super.initState();
    _updateDirection(widget.controller?.text);
  }

  void _updateDirection(String? text) {
    if (text == null || text.isEmpty) return;
    final newDirection = text.textDirection;

    if (textDirection != newDirection) {
      setState(() {
        textDirection = newDirection;
      });
    }
  }

  @override
  material.Widget build(material.BuildContext context) {
    return material.TextField(
      textDirection: textDirection,
      onChanged: (value) {
        widget.onChanged?.call(value);
        _updateDirection(value);
      },

      groupId: widget.groupId,
      controller: widget.controller,
      focusNode: widget.focusNode,
      undoController: widget.undoController,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      statesController: widget.statesController,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      ignorePointers: widget.ignorePointers,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorOpacityAnimates: widget.cursorOpacityAnimates,
      cursorColor: widget.cursorColor,
      cursorErrorColor: widget.cursorErrorColor,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectAllOnFocus: widget.selectAllOnFocus,
      selectionControls: widget.selectionControls,
      onTap: widget.onTap,
      onTapAlwaysCalled: widget.onTapAlwaysCalled,
      onTapOutside: widget.onTapOutside,
      onTapUpOutside: widget.onTapUpOutside,
      mouseCursor: widget.mouseCursor,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      clipBehavior: widget.clipBehavior,
      restorationId: widget.restorationId,
      stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      enableInlinePrediction: widget.enableInlinePrediction,
      canRequestFocus: widget.canRequestFocus,
      magnifierConfiguration: widget.magnifierConfiguration,
      hintLocales: widget.hintLocales,
      contextMenuBuilder: widget.contextMenuBuilder,
    );
  }
}
