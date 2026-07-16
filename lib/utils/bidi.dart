import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart' as intl;

extension BidiFormatter on String {
  String get bidiFormatted {
    return intl.BidiFormatter.UNKNOWN().wrapWithUnicode(this);
  }

  material.TextDirection? get textDirection {
    switch (intl.BidiFormatter.UNKNOWN().estimateDirection(this)) {
      case intl.TextDirection.LTR:
        return material.TextDirection.ltr;
      case intl.TextDirection.RTL:
        return material.TextDirection.rtl;
      case intl.TextDirection.UNKNOWN:
      default:
        return null;
    }
  }

  material.TextDirection? get textDirectionHtml {
    switch (intl.BidiFormatter.UNKNOWN().estimateDirection(
      this,
      isHtml: true,
    )) {
      case intl.TextDirection.LTR:
        return material.TextDirection.ltr;
      case intl.TextDirection.RTL:
        return material.TextDirection.rtl;
      case intl.TextDirection.UNKNOWN:
      default:
        return null;
    }
  }
}
