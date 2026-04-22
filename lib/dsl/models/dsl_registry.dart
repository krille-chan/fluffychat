import 'dsl_handler.dart';
import 'dsl_message.dart';

class DSLRegistry {
  DSLRegistry._();

  static final DSLRegistry instance = DSLRegistry._();

  final List<DSLHandler> _handlers = [];

  void register(DSLHandler handler) {
    final duplicate = _handlers.any(
          (h) => h.type == handler.type && h.version == handler.version,
    );

    if (duplicate) {
      throw Exception(
        'Duplicate DSL handler registered for ${handler.type} v${handler.version}',
      );
    }

    _handlers.add(handler);
  }

  /// Safe resolve (use THIS in UI)
  DSLHandler? tryResolve(DSLMessage msg) {
    for (final h in _handlers) {
      if (h.canHandle(msg)) return h;
    }
    return null;
  }

  /// Strict resolve (use only if you enjoy crashes)
  DSLHandler resolve(DSLMessage msg) {
    return tryResolve(msg) ??
        (throw Exception(
          'No DSL handler found for ${msg.type} v${msg.version}',
        ));
  }

  List<String> dumpRegistered() {
    return _handlers.map((h) => '${h.type} v${h.version}').toList();
  }
}