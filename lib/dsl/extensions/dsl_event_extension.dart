import 'package:flutter/widgets.dart';
import 'package:matrix/matrix.dart';

import '../models/dsl_message.dart';
import '../models/dsl_registry.dart';
import '../models/dsl_render_result.dart';

extension EventDSLRuntime on Event {
  Map<String, dynamic>? get _rawDSL =>
      content['com.jaino.dsl'] as Map<String, dynamic>?;

  DSLMessage? get dsl {
    final raw = _rawDSL;
    if (raw == null) return null;

    try {
      return DSLMessage.fromMap(raw);
    } catch (_) {
      return null;
    }
  }

  bool get hasDSL => dsl != null;

  /// SAFE rendering (never throws, because you're not a psychopath)
  Widget? buildDSLWidget() {
    final msg = dsl;
    if (msg == null) return null;

    final handler = DSLRegistry.instance.tryResolve(msg);
    if (handler == null) {
      return const Text('Unsupported DSL message');
    }

    try {
      final result = handler.render(this, msg);
      return result.widget;
    } catch (_) {
      return const Text('Failed to render DSL');
    }
  }

  /// Optional: if you still want structured result
  DSLRenderResult? renderDSL() {
    final msg = dsl;
    if (msg == null) return null;

    final handler = DSLRegistry.instance.tryResolve(msg);
    if (handler == null) return null;

    try {
      return handler.render(this, msg);
    } catch (_) {
      return null;
    }
  }
}