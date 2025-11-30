import 'matrix_request.dart';
import 'widget_message.dart';

/// Action output from widget machine for driver to execute
sealed class MachineAction {
  const MachineAction();
}

/// Send message to widget via transport
class SendToWidget extends MachineAction {
  const SendToWidget(this.message);

  final WidgetMessage message;

  @override
  String toString() => 'SendToWidget(${message.action})';
}

/// Execute Matrix operation
class ExecuteMatrixRequest extends MachineAction {
  const ExecuteMatrixRequest({
    required this.request,
    required this.originalMessage,
  });

  final MatrixRequest request;
  final WidgetMessage originalMessage;

  @override
  String toString() => 'ExecuteMatrixRequest($request)';
}

/// Request capability approval from provider
class RequestCapabilityApproval extends MachineAction {
  const RequestCapabilityApproval({
    required this.requested,
    required this.originalMessage,
  });

  final List<String> requested;
  final WidgetMessage originalMessage;

  @override
  String toString() =>
      'RequestCapabilityApproval(${requested.length} capabilities)';
}

/// Subscribe to room events
class SubscribeToEvents extends MachineAction {
  const SubscribeToEvents();

  @override
  String toString() => 'SubscribeToEvents()';
}

/// Widget requested close
class WidgetClose extends MachineAction {
  const WidgetClose();

  @override
  String toString() => 'WidgetClose()';
}

/// Widget joined (Element Call)
class WidgetJoin extends MachineAction {
  const WidgetJoin();

  @override
  String toString() => 'WidgetJoin()';
}

/// Widget muted device (Element Call)
class WidgetDeviceMute extends MachineAction {
  const WidgetDeviceMute({
    required this.deviceId,
    required this.muted,
  });

  final String deviceId;
  final bool muted;

  @override
  String toString() => 'WidgetDeviceMute(device: $deviceId, muted: $muted)';
}

/// Widget hangup (Element Call)
class WidgetHangup extends MachineAction {
  const WidgetHangup();

  @override
  String toString() => 'WidgetHangup()';
}
