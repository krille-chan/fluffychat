import 'package:flutter/widgets.dart';

import 'dsl_action.dart';

class DSLRenderResult {
  final Widget widget;
  final DSLAction? action;
  final Map<String, dynamic>? payload;

  DSLRenderResult({
    required this.widget,
    this.action,
    this.payload,
  });
}