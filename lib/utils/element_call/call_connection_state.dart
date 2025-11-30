// Connection states for ElementCall matching element-web implementation
enum CallConnectionState {
  // Widget loaded, awaiting join
  lobby,

  // Join action sent, waiting for confirmation
  connecting,

  // Active in RTC session
  connected,

  // Hangup in progress
  disconnecting,

  // Call ended
  disconnected,
}

extension CallConnectionStateExtension on CallConnectionState {
  bool get isConnected => this == CallConnectionState.connected;
  bool get isConnecting => this == CallConnectionState.connecting;
  bool get isDisconnected => this == CallConnectionState.disconnected;
  bool get canJoin => this == CallConnectionState.lobby;
  bool get canHangup => isConnected || isConnecting;
}
