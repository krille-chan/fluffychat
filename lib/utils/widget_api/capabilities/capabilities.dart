/// Capability provider for approving widget capabilities
typedef CapabilitiesProvider = Future<List<String>> Function(
  List<String> requested,
);

/// Auto-approve all capabilities
Future<List<String>> autoApproveCapabilities(
  List<String> requested,
) async {
  return requested;
}

/// Deny all capabilities
Future<List<String>> denyAllCapabilities(
  List<String> requested,
) async {
  return [];
}

/// Common capability sets for widgets

class WidgetCapabilities {
  /// Element Call capabilities
  static List<String> elementCall() {
    return [
      // Read timeline events
      'org.matrix.msc2762.receive.event:m.room.message',
      'org.matrix.msc2762.receive.event:m.reaction',
      'org.matrix.msc2762.receive.event:m.sticker',

      // Read state events
      'org.matrix.msc2762.receive.state_event:m.room.member',
      'org.matrix.msc2762.receive.state_event:m.room.name',
      'org.matrix.msc2762.receive.state_event:m.room.avatar',
      'org.matrix.msc2762.receive.state_event:m.room.topic',
      'org.matrix.msc2762.receive.state_event:m.room.encryption',
      'org.matrix.msc2762.receive.state_event:m.room.power_levels',
      'org.matrix.msc2762.receive.state_event:org.matrix.msc3401.call',
      'org.matrix.msc2762.receive.state_event:org.matrix.msc3401.call.member',

      // Send timeline events
      'org.matrix.msc2762.send.event:m.room.message',
      'org.matrix.msc2762.send.event:m.reaction',

      // Send state events
      'org.matrix.msc2762.send.state_event:org.matrix.msc3401.call.member#_@',

      // To-device (call signaling)
      'org.matrix.msc2762.send.to_device:m.call.invite',
      'org.matrix.msc2762.send.to_device:m.call.candidates',
      'org.matrix.msc2762.send.to_device:m.call.answer',
      'org.matrix.msc2762.send.to_device:m.call.hangup',
      'org.matrix.msc2762.send.to_device:m.call.select_answer',
      'org.matrix.msc2762.send.to_device:m.call.reject',
      'org.matrix.msc2762.send.to_device:m.call.negotiate',
      'org.matrix.msc2762.send.to_device:org.matrix.call.sdp_stream_metadata_changed',

      // To-device (E2EE key exchange)
      'org.matrix.msc2762.send.to_device:org.matrix.msc3401.call.encryption_keys',
      'org.matrix.msc2762.receive.to_device:org.matrix.msc3401.call.encryption_keys',
      'org.matrix.msc2762.send.to_device:m.call.encryption_key',
      'org.matrix.msc2762.receive.to_device:m.call.encryption_key',

      // Other capabilities
      'org.matrix.msc2762.timeline:*',
    ];
  }

  /// Jitsi widget capabilities
  static List<String> jitsi() {
    return [
      'org.matrix.msc2762.receive.state_event:m.room.member',
      'org.matrix.msc2762.receive.state_event:m.room.name',
      'org.matrix.msc2762.receive.state_event:m.room.avatar',
      'org.matrix.msc2762.timeline:*',
    ];
  }

  /// Basic read-only capabilities
  static List<String> readOnly() {
    return [
      'org.matrix.msc2762.receive.event:m.room.message',
      'org.matrix.msc2762.receive.state_event:m.room.member',
      'org.matrix.msc2762.receive.state_event:m.room.name',
      'org.matrix.msc2762.receive.state_event:m.room.avatar',
      'org.matrix.msc2762.timeline:*',
    ];
  }
}
