import 'widget_message.dart';

/// Incoming message to the driver
sealed class IncomingMessage {
  const IncomingMessage();
}

/// Message from widget (request)
class FromWidget extends IncomingMessage {
  const FromWidget(this.message);

  final WidgetMessage message;

  @override
  String toString() => 'FromWidget(${message.action})';
}

/// Response to widget request
class ToWidgetResponse extends IncomingMessage {
  const ToWidgetResponse(this.message);

  final WidgetMessage message;

  @override
  String toString() => 'ToWidgetResponse(${message.action})';
}

/// Initialize driver
class Initialize extends IncomingMessage {
  const Initialize();

  @override
  String toString() => 'Initialize()';
}

/// Widget transport died
class TransportDied extends IncomingMessage {
  const TransportDied();

  @override
  String toString() => 'TransportDied()';
}
