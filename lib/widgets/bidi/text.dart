import 'package:fluffychat/utils/bidi.dart';
import 'package:flutter/material.dart' as material;

class Text extends material.Text {
  const Text(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  });

  const Text.rich(
    super.textSpan, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  }) : super.rich();

  @override
  material.TextDirection? get textDirection {
    // For Text.rich, use HTML-aware direction estimation
    if (super.textSpan != null) {
      return super.textSpan!.toPlainText().textDirectionHtml;
    }
    // For regular Text, use standard direction estimation
    return data?.textDirection;
  }
}
