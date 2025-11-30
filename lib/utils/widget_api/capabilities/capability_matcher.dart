import 'filter.dart';

/// Matches capability requests against approved capabilities
class CapabilityMatcher {
  CapabilityMatcher(this.approved)
      : filters = CapabilityFilters.fromCapabilities(approved);

  final List<String> approved;
  final CapabilityFilters filters;

  /// Check if can read event
  bool canRead(String eventType, {String? stateKey, String? msgtype}) {
    return filters.canRead(eventType, stateKey: stateKey, msgtype: msgtype);
  }

  /// Check if can send event
  bool canSend(String eventType, {String? stateKey, String? msgtype}) {
    return filters.canSend(eventType, stateKey: stateKey, msgtype: msgtype);
  }

  /// Check if can send to-device
  bool canSendToDevice(String eventType) {
    return filters.canSendToDevice(eventType);
  }

  /// Check if can receive to-device
  bool canReceiveToDevice(String eventType) {
    return filters.canReceiveToDevice(eventType);
  }

  /// Check if has specific capability
  bool hasCapability(String capability) {
    return approved.contains(capability);
  }

  /// Check if has any OpenID capability
  bool canRequestOpenId() {
    return approved.any((k) => k.contains('openid'));
  }

  /// Check if has TURN server capability
  bool canGetTurnServers() {
    return hasCapability('org.matrix.msc3846.turn_servers');
  }
}
