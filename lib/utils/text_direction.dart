import 'package:flutter/material.dart';

import 'package:intl/intl.dart' as intl;

extension BidiFormatter on String {
  String get bidiFormatted {
    return intl.BidiFormatter.UNKNOWN().wrapWithUnicode(this);
  }

  TextDirection? get textDirectionHtml {
    switch (
        intl.BidiFormatter.UNKNOWN().estimateDirection(this, isHtml: true)) {
      case intl.TextDirection.LTR:
        return TextDirection.ltr;
      case intl.TextDirection.RTL:
        return TextDirection.rtl;
      case intl.TextDirection.UNKNOWN:
      default:
        return null;
    }
  }
}

class AutoDirection extends StatefulWidget {
  final String text;
  final Widget child;
  final void Function(bool isRTL)? onDirectionChange;

  const AutoDirection({
    super.key,
    required this.text,
    required this.child,
    this.onDirectionChange,
  });

  @override
  AutoDirectionState createState() => AutoDirectionState();
}

class AutoDirectionState extends State<AutoDirection> {
  late String text;
  late Widget childWidget;

  @override
  Widget build(BuildContext context) {
    text = widget.text;
    childWidget = widget.child;
    return Directionality(
      textDirection: isRTL(text) ? TextDirection.rtl : TextDirection.ltr,
      child: childWidget,
    );
  }

  @override
  void didUpdateWidget(AutoDirection oldWidget) {
    if (isRTL(oldWidget.text) != isRTL(widget.text)) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onDirectionChange?.call(isRTL(widget.text)),
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  bool isRTL(String text) {
    if (text.isEmpty) return Directionality.of(context) == TextDirection.rtl;
    return intl.Bidi.detectRtlDirectionality(text);
  }
}
