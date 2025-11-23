import 'dart:async';

/// Abstract transport for widget communication
abstract class WidgetTransport {
  /// Stream of incoming messages from widget (JSON strings)
  Stream<String> get incoming;

  /// Send message to widget
  Future<void> send(String message);

  /// Dispose transport
  void dispose();
}
