/// Event filter for widget capabilities
class EventFilter {
  const EventFilter({
    this.eventType,
    this.stateKey,
    this.msgtype,
  });

  final String? eventType;
  final String? stateKey; // null = any, '#_@' = user-specific
  final String? msgtype; // For m.room.message granularity

  /// Check if event matches filter
  bool matches({
    required String type,
    String? key,
    String? messageType,
  }) {
    // Check event type
    if (eventType != null && !(eventType?.startsWith(type) ?? false)) {
      return false;
    }

    // Check state key
    if (stateKey != null) {
      if (key == null) return false;
      if (stateKey == '#_@') {
        // User-specific wildcard - matches if key starts with _@
        if (!key.startsWith('_@')) return false;
      } else if (stateKey != key) {
        return false;
      }
    }

    // Check msgtype for m.room.message
    if (msgtype != null && type == 'm.room.message') {
      if (messageType == null || messageType != msgtype) {
        return false;
      }
    }

    return true;
  }

  /// Parse from capability string
  /// Examples:
  /// - "m.room.message" -> EventFilter(eventType: "m.room.message")
  /// - "m.room.member#_@" -> EventFilter(eventType: "m.room.member", stateKey: "#_@")
  /// - "m.room.message:m.text" -> EventFilter(eventType: "m.room.message", msgtype: "m.text")
  factory EventFilter.parse(String capability) {
    String? eventType;
    String? stateKey;
    String? msgtype;

    if (capability.contains(':')) {
      // Has msgtype
      final parts = capability.split(':');
      eventType = parts[0];
      msgtype = parts.length > 1 ? parts[1] : null;
    } else if (capability.contains('#')) {
      // Has state key
      final parts = capability.split('#');
      eventType = parts[0];
      stateKey = parts.length > 1 ? '#${parts[1]}' : null;
    } else {
      eventType = capability;
    }

    return EventFilter(
      eventType: eventType,
      stateKey: stateKey,
      msgtype: msgtype,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer(eventType ?? '*');
    if (stateKey != null) buffer.write('#$stateKey');
    if (msgtype != null) buffer.write(':$msgtype');
    return buffer.toString();
  }
}

/// Capability filters
class CapabilityFilters {
  const CapabilityFilters({
    this.read = const [],
    this.send = const [],
    this.receiveState = const [],
    this.sendState = const [],
    this.toDevice = const [],
    this.sendToDevice = const [],
    this.receiveToDevice = const [],
  });

  final List<EventFilter> read;
  final List<EventFilter> send;
  final List<EventFilter> receiveState;
  final List<EventFilter> sendState;
  final List<EventFilter> toDevice; // Legacy - combined send/receive
  final List<EventFilter> sendToDevice;
  final List<EventFilter> receiveToDevice;

  /// Parse from capabilities map
  factory CapabilityFilters.fromCapabilities(List<String> capabilities) {
    final read = <EventFilter>[];
    final send = <EventFilter>[];
    final receiveState = <EventFilter>[];
    final sendState = <EventFilter>[];
    final toDevice = <EventFilter>[];
    final sendToDevice = <EventFilter>[];
    final receiveToDevice = <EventFilter>[];

    for (final value in capabilities) {
      // Support both MSC2762 and MSC3819 (to-device) capabilities
      if (!value.startsWith('org.matrix.msc2762.') &&
          !value.startsWith('org.matrix.msc3819.')) {
        continue;
      }

      // Extract just the event type part after the action prefix
      String? eventTypeStr;

      if (value.contains('.receive.event:')) {
        eventTypeStr = value.split('.receive.event:').last;
        read.add(EventFilter.parse(eventTypeStr));
      } else if (value.contains('.send.event:')) {
        eventTypeStr = value.split('.send.event:').last;
        send.add(EventFilter.parse(eventTypeStr));
      } else if (value.contains('.receive.state_event:')) {
        eventTypeStr = value.split('.receive.state_event:').last;
        receiveState.add(EventFilter.parse(eventTypeStr));
      } else if (value.contains('.send.state_event:')) {
        eventTypeStr = value.split('.send.state_event:').last;
        sendState.add(EventFilter.parse(eventTypeStr));
      } else if (value.contains('.send.to_device:') ||
          value.contains('.receive.to_device:')) {
        // MSC3819 uses send.to_device and receive.to_device
        if (value.contains('.send.to_device:')) {
          eventTypeStr = value.split('.send.to_device:').last;
          final filter = EventFilter.parse(eventTypeStr);
          toDevice.add(filter); // Legacy
          sendToDevice.add(filter);
        } else {
          eventTypeStr = value.split('.receive.to_device:').last;
          final filter = EventFilter.parse(eventTypeStr);
          toDevice.add(filter); // Legacy
          receiveToDevice.add(filter);
        }
      }
    }

    return CapabilityFilters(
      read: read,
      send: send,
      receiveState: receiveState,
      sendState: sendState,
      toDevice: toDevice,
      sendToDevice: sendToDevice,
      receiveToDevice: receiveToDevice,
    );
  }

  /// Check if can read event
  bool canRead(String eventType, {String? stateKey, String? msgtype}) {
    if (stateKey != null) {
      return receiveState.any(
        (f) => f.matches(
          type: eventType,
          key: stateKey,
          messageType: msgtype,
        ),
      );
    }
    return read.any(
      (f) => f.matches(
        type: eventType,
        messageType: msgtype,
      ),
    );
  }

  /// Check if can send event
  bool canSend(String eventType, {String? stateKey, String? msgtype}) {
    if (stateKey != null) {
      return sendState.any(
        (f) => f.matches(
          type: eventType,
          key: stateKey,
          messageType: msgtype,
        ),
      );
    }
    return send.any(
      (f) => f.matches(
        type: eventType,
        messageType: msgtype,
      ),
    );
  }

  /// Check if can send to-device
  bool canSendToDevice(String eventType) {
    return sendToDevice.any((f) => f.matches(type: eventType));
  }

  /// Check if can receive to-device
  bool canReceiveToDevice(String eventType) {
    return receiveToDevice.any((f) => f.matches(type: eventType));
  }
}
