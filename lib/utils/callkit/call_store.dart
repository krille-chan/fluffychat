import 'dart:async';

import 'package:matrix/matrix.dart';

import '../element_call/call_connection_state.dart';
import 'callkit_service.dart';
import 'group_call.dart';

/// Singleton managing all GroupCall instances
class CallStore {
  static CallStore? _instance;
  static CallStore get instance {
    _instance ??= CallStore._();
    return _instance!;
  }

  CallStore._();

  final Map<String, GroupCall> _calls = {};
  final Map<String, GroupCall> _connectedCalls = {};

  final _callsController = StreamController<Map<String, GroupCall>>.broadcast();
  final _connectedCallsController =
      StreamController<Map<String, GroupCall>>.broadcast();

  Stream<Map<String, GroupCall>> get onCallsChanged => _callsController.stream;
  Stream<Map<String, GroupCall>> get onConnectedCallsChanged =>
      _connectedCallsController.stream;

  Map<String, GroupCall> get calls => Map.unmodifiable(_calls);
  Map<String, GroupCall> get connectedCalls =>
      Map.unmodifiable(_connectedCalls);

  /// Get or create call for room
  GroupCall getOrCreateCall({
    required Room room,
    required Client client,
    bool autoReconnect = false,
    required String baseUrl,
    required String parentUrl,
    String? callKitUuid,
  }) {
    final existing = _calls[room.id];
    if (existing != null) {
      Logs().d(
        '[CallKit.CallStore] getOrCreateCall: returning existing call for roomId=${room.id}',
      );
      // Update CallKit UUID if provided
      if (callKitUuid != null && existing.callKitUuid == null) {
        existing.callKitUuid = callKitUuid;
      }
      return existing;
    }

    Logs().i(
      '[CallKit.CallStore] getOrCreateCall: creating new call for roomId=${room.id}, autoReconnect=$autoReconnect',
    );

    final call = GroupCall(
      room: room,
      client: client,
      autoReconnect: autoReconnect,
      baseUrl: baseUrl,
      parentUrl: parentUrl,
    );

    // Set CallKit UUID if provided
    if (callKitUuid != null) {
      call.callKitUuid = callKitUuid;
    }

    call.onConnectionStateChanged.listen((state) {
      _handleConnectionStateChanged(room.id, state);
    });

    _calls[room.id] = call;
    _callsController.add(_calls);

    Logs()
        .d('[CallKit.CallStore] getOrCreateCall: total calls=${_calls.length}');
    return call;
  }

  /// Handle call accepted from CallKit
  Future<GroupCall?> handleCallAccepted({
    required String callUuid,
    required Client client,
    required String baseUrl,
    required String parentUrl,
  }) async {
    Logs().i(
      '[CallKit.CallStore] handleCallAccepted: callUuid=$callUuid',
    );

    // Get room ID from CallKit service
    final roomId = CallKitService.instance.getRoomIdForCall(callUuid);
    if (roomId == null) {
      Logs().w(
        '[CallKit.CallStore] handleCallAccepted: unknown call UUID: $callUuid',
      );
      return null;
    }

    // Get room
    final room = client.getRoomById(roomId);
    if (room == null) {
      Logs().w(
        '[CallKit.CallStore] handleCallAccepted: room not found: $roomId',
      );
      return null;
    }

    // Create or get existing call
    final call = getOrCreateCall(
      room: room,
      client: client,
      autoReconnect: false,
      baseUrl: baseUrl,
      parentUrl: parentUrl,
      callKitUuid: callUuid,
    );

    return call;
  }

  /// Get existing call
  GroupCall? getCall(String roomId) {
    final call = _calls[roomId];
    Logs().v(
      '[CallKit.CallStore] getCall: roomId=$roomId, found=${call != null}',
    );
    return call;
  }

  /// Remove call
  Future<void> removeCall(String roomId) async {
    Logs().i('[CallKit.CallStore] removeCall: roomId=$roomId');
    final call = _calls.remove(roomId);
    if (call == null) {
      Logs().w(
        '[CallKit.CallStore] removeCall: call not found for roomId=$roomId',
      );
      return;
    }

    call.dispose();
    _connectedCalls.remove(roomId);

    _callsController.add(_calls);
    _connectedCallsController.add(_connectedCalls);

    Logs()
        .d('[CallKit.CallStore] removeCall: remaining calls=${_calls.length}');
  }

  void _handleConnectionStateChanged(String roomId, CallConnectionState state) {
    Logs().i(
      '[CallKit.CallStore] _handleConnectionStateChanged: roomId=$roomId, state=$state',
    );
    final call = _calls[roomId];
    if (call == null) {
      Logs().w(
        '[CallKit.CallStore] _handleConnectionStateChanged: call not found for roomId=$roomId',
      );
      return;
    }

    if (state.isConnected) {
      if (!_connectedCalls.containsKey(roomId)) {
        Logs().d(
          '[CallKit.CallStore] _handleConnectionStateChanged: adding to connected calls',
        );
        _connectedCalls[roomId] = call;
        _connectedCallsController.add(_connectedCalls);
      }
    } else {
      if (_connectedCalls.containsKey(roomId)) {
        Logs().d(
          '[CallKit.CallStore] _handleConnectionStateChanged: removing from connected calls',
        );
        _connectedCalls.remove(roomId);
        _connectedCallsController.add(_connectedCalls);
      }
    }

    if (state == CallConnectionState.disconnected) {
      Logs().d(
        '[CallKit.CallStore] _handleConnectionStateChanged: scheduling auto-cleanup in 5s',
      );
      Timer(const Duration(seconds: 5), () {
        if (call.connectionState == CallConnectionState.disconnected) {
          Logs().i(
            '[CallKit.CallStore] _handleConnectionStateChanged: auto-cleanup triggered for roomId=$roomId',
          );
          removeCall(roomId);
        } else {
          Logs().d(
            '[CallKit.CallStore] _handleConnectionStateChanged: auto-cleanup cancelled, state changed',
          );
        }
      });
    }
  }

  Future<void> dispose() async {
    Logs().i('[CallKit.CallStore] dispose: disposing ${_calls.length} calls');
    for (final call in _calls.values) {
      call.dispose();
    }

    _calls.clear();
    _connectedCalls.clear();

    _callsController.close();
    _connectedCallsController.close();
  }
}
