import 'package:flutter/material.dart';

const _rtlRanges = [
  [0x0590, 0x08FF],
  [0xFB1D, 0xFDFF],
  [0xFE70, 0xFEFF],
  [0x0600, 0x06FF],
];

const _ltrRanges = [
  [0x0041, 0x007A],
  [0x00C0, 0x024F],
  [0x0370, 0x03FF],
  [0x0400, 0x04FF],
];

bool _isRtl(int rune) => _rtlRanges.any((r) => rune >= r[0] && rune <= r[1]) || rune == 0x200F;

bool _isLtr(int rune) => _ltrRanges.any((r) => rune >= r[0] && rune <= r[1]);

TextDirection autoTextDirection(String text) {
  if (text.isEmpty) return TextDirection.ltr;
  for (final rune in text.runes) {
    if (_isRtl(rune)) return TextDirection.rtl;
    if (_isLtr(rune)) return TextDirection.ltr;
  }
  return TextDirection.ltr;
}

String bidiIsolate(String text) {
  if (text.isEmpty) return text;
  if (autoTextDirection(text) == TextDirection.rtl) {
    return '\u{2067}$text\u{2069}';
  }
  return text;
}

String bidiIsolateMultiline(String text) {
  if (!text.contains('\n')) return bidiIsolate(text);
  return text.split('\n').map(bidiIsolate).join('\n');
}