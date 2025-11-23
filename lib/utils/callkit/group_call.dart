// ignore_for_file: require_trailing_commas

import 'dart:async';
import 'dart:convert';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:matrix/matrix.dart';

import '../element_call/call_connection_state.dart';
import '../widget_api/element_call/element_call_widget.dart';
import '../widget_api/element_call/participants_tracker.dart';
import '../widget_api/transport/webview_transport.dart';
import '../widget_api/widget_driver.dart';
import '../widget_api/widget_settings.dart';
import 'callkit_service.dart';

/// GroupCall managing Element Call via Widget API
class GroupCall {
  GroupCall({
    required this.room,
    required this.client,
    required this.baseUrl,
    required this.parentUrl,
    this.autoReconnect = false,
  });

  final Room room;
  final Client client;
  final bool autoReconnect;
  final String baseUrl;
  final String parentUrl;

  // State
  CallConnectionState _connectionState = CallConnectionState.disconnected;
  final _connectionStateController =
      StreamController<CallConnectionState>.broadcast();

  // Widget driver
  WidgetDriver? _driver;
  WidgetSettings? _settings;
  ParticipantsTracker? _participantsTracker;

  // Timers for call.member management
  Timer? _membershipRefreshTimer;
  Timer? _joinTimeoutTimer;

  // CallKit integration
  String? _callKitUuid;

  // Streams
  Stream<CallConnectionState> get onConnectionStateChanged =>
      _connectionStateController.stream;
  Stream<List<User>>? get onParticipantsChanged =>
      _participantsTracker?.participants;

  // Getters
  CallConnectionState get connectionState => _connectionState;
  List<User> get participants =>
      _participantsTracker?.currentParticipants ?? [];
  int get participantCount => participants.length;
  bool get isConnected => _connectionState.isConnected;
  bool get canJoin => _connectionState.canJoin;
  bool get canHangup => _connectionState.canHangup;
  String? get callKitUuid => _callKitUuid;

  // Setters
  set callKitUuid(String? uuid) {
    Logs().d('[CallKit.GroupCall] Setting CallKit UUID: $uuid');
    _callKitUuid = uuid;
  }

  /// Join call
  Future<void> join({
    required InAppWebViewController webViewController,
    bool skipLobby = true,
  }) async {
    Logs()
        .i('[CallKit.GroupCall] join: roomId=${room.id}, skipLobby=$skipLobby');
    // Allow joining from disconnected (initial) or lobby state
    if (_connectionState != CallConnectionState.disconnected &&
        _connectionState != CallConnectionState.lobby) {
      Logs()
          .w('[CallKit.GroupCall] join: cannot join, state=$_connectionState');
      return;
    }

    _setConnectionState(CallConnectionState.connecting);

    try {
      final deviceId = client.deviceID ?? 'UNKNOWN';
      Logs().d('[CallKit.GroupCall] join: deviceId=$deviceId');

      // Create widget settings
      Logs().d('[CallKit.GroupCall] join: creating widget settings');
      _settings = ElementCallWidget.create(
        baseUrl: baseUrl,
        parentUrl: parentUrl,
        room: room,
        deviceId: deviceId,
      );

      // Create transport
      Logs().d('[CallKit.GroupCall] join: creating webview transport');
      final transport = WebViewWidgetTransport(webViewController);
      await transport.initialize();

      // Create driver
      Logs().d('[CallKit.GroupCall] join: creating widget driver');
      _driver = WidgetDriver(
        settings: _settings!,
        transport: transport,
        client: client,
        room: room,
        onJoin: _onWidgetJoined,
        onClose: _onWidgetClosed,
        onHangup: _onWidgetHangup,
      );

      // Initialize driver (starts protocol)
      Logs().d('[CallKit.GroupCall] join: initializing driver');
      await _driver!.initialize();

      // Load widget URL in iframe
      Logs()
          .d('[CallKit.GroupCall] join: loading widget URL: ${_settings!.url}');
      await webViewController.evaluateJavascript(
        source: "window.setWidgetUrl('${_settings!.url}')",
      );

      // Start timeout for widget join (10 seconds)
      Logs().d('[CallKit.GroupCall] join: starting widget join timeout');
      // _joinTimeoutTimer = Timer(const Duration(seconds: 40), () {
      //   if (_connectionState == CallConnectionState.connecting) {
      //     Logs().e(
      //         '[CallKit.GroupCall] Widget join timeout - no io.element.join received');
      //     hangup();
      //   }
      // });

      // Create call.member state
      Logs().d('[CallKit.GroupCall] join: creating call membership');
      await _createCallMembership();

      // Start participants tracker
      Logs().d('[CallKit.GroupCall] join: starting participants tracker');
      _participantsTracker = ParticipantsTracker(room);

      // Start membership refresh timer
      Logs().d('[CallKit.GroupCall] join: starting membership refresh timer');
      _startMembershipRefreshTimer();

      Logs().i('[CallKit.GroupCall] join: completed successfully');
    } catch (e, s) {
      Logs().e('[CallKit.GroupCall] join: failed', e, s);
      _joinTimeoutTimer?.cancel();
      _joinTimeoutTimer = null;
      _setConnectionState(CallConnectionState.disconnected);
      rethrow;
    }
  }

  /// Hangup call
  Future<void> hangup() async {
    Logs().i(
      '[CallKit.GroupCall] hangup: roomId=${room.id}, state=$_connectionState',
    );
    // Allow hangup from any state except already disconnected
    if (_connectionState == CallConnectionState.disconnected) {
      Logs().w(
        '[CallKit.GroupCall] hangup: already disconnected, skipping',
      );
      return;
    }

    _setConnectionState(CallConnectionState.disconnecting);

    try {
      // Remove call.member state
      Logs().d('[CallKit.GroupCall] hangup: removing call membership');
      await _removeCallMembership();

      // Dispose driver
      Logs().d('[CallKit.GroupCall] hangup: disposing driver');
      _driver?.dispose();
      _driver = null;

      // Dispose participants tracker
      Logs().d('[CallKit.GroupCall] hangup: disposing participants tracker');
      _participantsTracker?.dispose();
      _participantsTracker = null;

      // Stop timers
      Logs().d('[CallKit.GroupCall] hangup: stopping timers');
      _membershipRefreshTimer?.cancel();
      _membershipRefreshTimer = null;
      _joinTimeoutTimer?.cancel();
      _joinTimeoutTimer = null;

      // End CallKit call
      if (_callKitUuid != null) {
        Logs().d('[CallKit.GroupCall] hangup: ending CallKit call');
        await CallKitService.instance.endCall(_callKitUuid!);
        _callKitUuid = null;
      }

      _setConnectionState(CallConnectionState.disconnected);
      Logs().i('[CallKit.GroupCall] hangup: completed successfully');
    } catch (e, s) {
      Logs().e('[CallKit.GroupCall] hangup: failed', e, s);
      _setConnectionState(CallConnectionState.disconnected);
    }
  }

  void _onWidgetJoined() {
    Logs().i('[CallKit.GroupCall] _onWidgetJoined: state=$_connectionState');
    // Cancel join timeout - widget successfully joined
    _joinTimeoutTimer?.cancel();
    _joinTimeoutTimer = null;

    if (_connectionState == CallConnectionState.connecting) {
      _setConnectionState(CallConnectionState.connected);
    }
  }

  void _onWidgetClosed() {
    Logs().i('[CallKit.GroupCall] _onWidgetClosed: triggering hangup');
    hangup();
  }

  void _onWidgetHangup() {
    Logs().i('[CallKit.GroupCall] _onWidgetHangup: triggering hangup');
    hangup();
  }

  void _setConnectionState(CallConnectionState state) {
    if (_connectionState == state) return;
    Logs().i(
      '[CallKit.GroupCall] _setConnectionState: $_connectionState -> $state',
    );
    _connectionState = state;
    _connectionStateController.add(state);

    // Sync with CallKit
    _syncCallKitState(state);
  }

  void _syncCallKitState(CallConnectionState state) {
    if (_callKitUuid == null) return;

    final stateString = switch (state) {
      CallConnectionState.connecting => 'connecting',
      CallConnectionState.connected => 'connected',
      CallConnectionState.disconnecting => 'disconnecting',
      CallConnectionState.disconnected => 'disconnected',
      _ => null,
    };

    if (stateString != null) {
      CallKitService.instance.updateCallState(
        callUuid: _callKitUuid!,
        state: stateString,
      );
    }
  }

  Future<void> _createCallMembership() async {
    final userId = client.userID!;
    final deviceId = client.deviceID ?? 'UNKNOWN';
    final stateKey = _getStateKey(userId, deviceId);

    Logs().i('[CallKit.GroupCall] _createCallMembership: stateKey=$stateKey');

    final now = DateTime.now().millisecondsSinceEpoch;
    final expiresTs = now + (5 * 60 * 60 * 1000); // 5 hours

    final liveKitUrl = await _getLiveKitUrl();

    final content = {
      'application': 'm.call',
      'call_id': room.id,
      'scope': 'm.room',
      'device_id': deviceId,
      'expires_ts': expiresTs,
      'm.encryption': 'perParticipantKeys',
      'focus_active': {
        'type': 'livekit',
        'focus_selection': 'oldest_membership',
      },
      'foci_preferred': [
        {
          'type': 'livekit',
          'livekit_service_url': liveKitUrl,
          'livekit_alias': room.id,
        }
      ],
    };

    await client.setRoomStateWithKey(
      room.id,
      'org.matrix.msc3401.call.member',
      stateKey,
      content,
    );
    Logs().d(
      '[CallKit.GroupCall] _createCallMembership: call.member created, expires=$expiresTs',
    );
  }

  Future<void> _removeCallMembership() async {
    final userId = client.userID!;
    final deviceId = client.deviceID ?? 'UNKNOWN';
    final stateKey = _getStateKey(userId, deviceId);

    Logs().i('[CallKit.GroupCall] _removeCallMembership: stateKey=$stateKey');

    await client.setRoomStateWithKey(
      room.id,
      'org.matrix.msc3401.call.member',
      stateKey,
      {},
    );
    Logs().d('[CallKit.GroupCall] _removeCallMembership: call.member removed');
  }

  void _startMembershipRefreshTimer() {
    Logs().i(
      '[CallKit.GroupCall] _startMembershipRefreshTimer: starting 4.5h periodic timer',
    );
    _membershipRefreshTimer?.cancel();
    _membershipRefreshTimer = Timer.periodic(
      const Duration(hours: 4, minutes: 30),
      (_) {
        Logs().d(
          '[CallKit.GroupCall] _startMembershipRefreshTimer: refreshing membership',
        );
        _createCallMembership();
      },
    );
  }

  String _getStateKey(String userId, String deviceId) {
    final roomVersion = room.getState('m.room.create')?.content['room_version'];
    final supportsMsc3779 =
        roomVersion?.toString().contains('org.matrix.msc3779') ?? false;

    final key = '${userId}_${deviceId}_m.call';
    final stateKey = supportsMsc3779 ? key : '_$key';
    Logs().v(
      '[CallKit.GroupCall] _getStateKey: userId=$userId, deviceId=$deviceId, stateKey=$stateKey, msc3779=$supportsMsc3779',
    );
    return stateKey;
  }

  /// Get LiveKit URL from .well-known or fallback.
  Future<String> _getLiveKitUrl() async {
    Logs().v('[CallKit.GroupCall] _getLiveKitUrl: fetching from .well-known');
    try {
      final response = await client.httpClient.get(
        Uri.parse('${client.homeserver}/.well-known/matrix/client'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foci = data['org.matrix.msc4143.rtc_foci'];

        if (foci is List && foci.isNotEmpty) {
          const url = "https://livekit-jwt.call.element.io";
          Logs().d('[CallKit.GroupCall] _getLiveKitUrl: using url=$url');
          return url;
        }
      }
    } catch (e, s) {
      Logs().e(
          '[CallKit.GroupCall] _getLiveKitUrl: .well-known fetch failed', e, s);
    }

    const fallbackUrl = 'https://livekit-jwt.call.element.io';
    Logs().d(
        '[CallKit.GroupCall] _getLiveKitUrl: using fallback url=$fallbackUrl');
    return fallbackUrl;
  }

  void dispose() {
    Logs().i('[CallKit.GroupCall] dispose: cleaning up');
    _driver?.dispose();
    _participantsTracker?.dispose();
    _membershipRefreshTimer?.cancel();
    _joinTimeoutTimer?.cancel();
    _connectionStateController.close();
  }
}
