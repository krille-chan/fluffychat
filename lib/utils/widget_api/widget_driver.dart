import 'dart:async';

import 'package:matrix/matrix.dart';

import 'capabilities/capability_matcher.dart';
import 'matrix_driver.dart';
import 'models/models.dart';
import 'transport/widget_transport.dart';
import 'widget_machine.dart';
import 'widget_settings.dart';

/// Callbacks for widget events
typedef OnCloseCallback = void Function();
typedef OnJoinCallback = void Function();
typedef OnDeviceMuteCallback = void Function(String deviceId, bool muted);
typedef OnHangupCallback = void Function();

/// Widget driver orchestrator
class WidgetDriver {
  WidgetDriver({
    required this.settings,
    required this.transport,
    required this.client,
    required this.room,
    this.onClose,
    this.onJoin,
    this.onDeviceMute,
    this.onHangup,
  }) : _machine = WidgetMachine(widgetId: settings.widgetId);

  final WidgetSettings settings;
  final WidgetTransport transport;
  final Client client;
  final Room room;
  final OnCloseCallback? onClose;
  final OnJoinCallback? onJoin;
  final OnDeviceMuteCallback? onDeviceMute;
  final OnHangupCallback? onHangup;

  final WidgetMachine _machine;
  MatrixDriver? _matrixDriver;

  StreamSubscription? _transportSub;
  StreamSubscription? _timelineSub;
  StreamSubscription? _stateSub;
  StreamSubscription? _toDeviceSub;

  List<String> _approvedCapabilities = [];
  bool _initialized = false;
  bool _disposed = false;

  /// Initialize driver
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    Logs()
        .i('WidgetDriver: Initializing widget driver for ${settings.widgetId}');

    // Listen to transport messages
    _transportSub = transport.incoming.listen(
      _handleTransportMessage,
      onError: (error) {
        Logs().e('WidgetDriver: Transport error', error);
      },
    );

    // Send Initialize message to machine
    final actions = _machine.process(const Initialize());
    await _executeActions(actions);
  }

  /// Dispose driver
  void dispose() {
    if (_disposed) return;
    _disposed = true;

    Logs().i('WidgetDriver: Disposing widget driver for ${settings.widgetId}');

    _transportSub?.cancel();
    _timelineSub?.cancel();
    _stateSub?.cancel();
    _toDeviceSub?.cancel();
    transport.dispose();
    _matrixDriver?.dispose();
  }

  void _handleTransportMessage(String message) {
    if (_disposed) return;

    try {
      final widgetMessage = WidgetMessage.fromJsonString(message);
      Logs().v(
        'WidgetDriver: Received: ${widgetMessage.action} (${widgetMessage.api})',
      );

      final IncomingMessage incoming;
      if (widgetMessage.api == WidgetApi.fromWidget) {
        if (widgetMessage.isResponse) {
          incoming = ToWidgetResponse(widgetMessage);
        } else {
          incoming = FromWidget(widgetMessage);
        }
      } else {
        // toWidget from widget - should be response
        if (widgetMessage.isResponse) {
          incoming = ToWidgetResponse(widgetMessage);
        } else {
          Logs().w('WidgetDriver: Unexpected toWidget request from widget');
          return;
        }
      }

      final actions = _machine.process(incoming);
      _executeActions(actions);
    } catch (e, s) {
      Logs().e('WidgetDriver: Error handling transport message', e, s);
    }
  }

  Future<void> _executeActions(List<MachineAction> actions) async {
    for (final action in actions) {
      if (_disposed) return;

      try {
        await _executeAction(action);
      } catch (e, s) {
        Logs().e('WidgetDriver: Error executing action $action', e, s);
      }
    }
  }

  Future<void> _executeAction(MachineAction action) async {
    Logs().v('WidgetDriver: Executing: $action');

    switch (action) {
      case SendToWidget(:final message):
        await transport.send(message.toJsonString());

      case ExecuteMatrixRequest(:final request, :final originalMessage):
        await _executeMatrixRequest(request, originalMessage);

      case RequestCapabilityApproval(:final requested, :final originalMessage):
        await _requestCapabilityApproval(requested, originalMessage);

      case SubscribeToEvents():
        await _subscribeToEvents();

      case WidgetClose():
        onClose?.call();

      case WidgetJoin():
        onJoin?.call();

      case WidgetDeviceMute(:final deviceId, :final muted):
        onDeviceMute?.call(deviceId, muted);

      case WidgetHangup():
        onHangup?.call();
    }
  }

  Future<void> _executeMatrixRequest(
    MatrixRequest request,
    WidgetMessage originalMessage,
  ) async {
    try {
      if (_matrixDriver == null) {
        throw const WidgetError('Matrix driver not initialized');
      }
      final result = await _matrixDriver!.execute(request);
      final response = originalMessage.respond(result);
      await transport.send(response.toJsonString());
    } on WidgetError catch (e) {
      final response = originalMessage.respondError(e.message);
      await transport.send(response.toJsonString());
    } catch (e) {
      Logs().e('WidgetDriver: Matrix request failed', e);
      final response =
          originalMessage.respondError('Matrix operation failed: $e');
      await transport.send(response.toJsonString());
    }
  }

  Future<void> _requestCapabilityApproval(
    List<String> requested,
    WidgetMessage originalMessage,
  ) async {
    try {
      // Request approval from provider
      final approved = await settings.capabilitiesProvider(requested);
      _approvedCapabilities = approved;

      // Create matrix driver with approved capabilities
      _matrixDriver = MatrixDriver(
        client: client,
        room: room,
        capabilities: CapabilityMatcher(approved),
      );

      // Tell machine to send notify_capabilities and transition to Negotiated
      final actions = _machine.approveCapabilities(approved);
      await _executeActions(actions);
    } catch (e) {
      Logs().e('WidgetDriver: Capability approval failed', e);
      final response =
          originalMessage.respondError('Capability approval failed');
      await transport.send(response.toJsonString());
    }
  }

  Future<void> _subscribeToEvents() async {
    Logs().i('WidgetDriver: Subscribing to events');

    // Subscribe to timeline events
    _timelineSub = client.onSync.stream
        .where((sync) => sync.rooms?.join?[room.id] != null)
        .listen((_) {
      if (_disposed) return;
      _sendTimelineUpdate();
    });

    // Subscribe to state events
    _stateSub = client.onSync.stream
        .where((sync) => sync.rooms?.join?[room.id] != null)
        .listen((_) {
      if (_disposed) return;
      _sendStateUpdate();
    });

    // Subscribe to to-device events (for E2EE key exchange)
    _toDeviceSub = client.onToDeviceEvent.stream.listen((event) {
      if (_disposed) return;
      final matcher = CapabilityMatcher(_approvedCapabilities);
      if (matcher.canReceiveToDevice(event.type)) {
        _sendToDeviceEventToWidget(event);
      }
    });

    // Send initial state
    await _sendInitialState();
  }

  Future<void> _sendInitialState() async {
    Logs().i('WidgetDriver: Sending initial state');

    final matcher = CapabilityMatcher(_approvedCapabilities);
    final state = <Map<String, dynamic>>[];
    final addedKeys = <String>{};

    // Fetch all members for small rooms (≤100) to ensure current user is included
    // For larger rooms, use cached members for performance
    if ((room.summary.mJoinedMemberCount ?? 0) <= 100) {
      await room.requestParticipants();
    }

    final currentUser = room.getState('m.room.member', client.userID ?? "-");
    if (currentUser != null) {
      final data = currentUser.toJson();
      data['room_id'] = room.id;
      state.add(data);
    }

    // Always include ALL members (needed for participant tracking)
    // Note: room.states contains StrippedStateEvent objects which lack full data
    // Use room.getState() to get complete Event objects with all fields
    final memberStates = room.states['m.room.member'];
    if (memberStates is Map) {
      for (final strippedMember in memberStates!.values) {
        final stateKey = strippedMember.stateKey ?? '';
        // Get full Event object with all fields (event_id, room_id, etc.)
        final fullEvent = room.getState('m.room.member', stateKey);
        if (fullEvent != null) {
          state.add(fullEvent.toJson());
        } else {
          // Fallback to stripped data if full event not available
          state.add(strippedMember.toJson());
        }
        addedKeys.add('m.room.member|$stateKey');
      }
    }

    // Always include core room events (needed for room context)
    final coreTypes = [
      'm.room.create',
      'm.room.power_levels',
      'm.room.encryption',
    ];
    for (final type in coreTypes) {
      final event = room.getState(type);
      if (event != null) {
        state.add(event.toJson());
        addedKeys.add('$type|');
      }
    }

    // Add capability-matched state events (avoid duplicates)
    for (final stateEvent in room.states.values.expand((m) => m.values)) {
      final key = '${stateEvent.type}|${stateEvent.stateKey}';
      if (!addedKeys.contains(key) &&
          matcher.canRead(stateEvent.type, stateKey: stateEvent.stateKey)) {
        state.add(stateEvent.toJson());
        addedKeys.add(key);
      }
    }

    // Collect recent timeline events
    final timeline = await room.getTimeline();
    final events = <Map<String, dynamic>>[];

    for (final event in timeline.events.take(50)) {
      if (matcher.canRead(event.type)) {
        events.add(event.toJson());
      }
    }

    // Send update_state
    await _sendUpdateState(events, state);
  }

  Future<void> _sendTimelineUpdate() async {
    final matcher = CapabilityMatcher(_approvedCapabilities);
    final timeline = await room.getTimeline();

    // Get latest events
    final events = <Map<String, dynamic>>[];
    for (final event in timeline.events.take(10)) {
      if (matcher.canRead(event.type)) {
        events.add(event.toJson());
      }
    }

    if (events.isNotEmpty) {
      await _sendUpdateState(events, null);
    }
  }

  Future<void> _sendStateUpdate() async {
    final matcher = CapabilityMatcher(_approvedCapabilities);
    final state = <Map<String, dynamic>>[];

    for (final stateEvent in room.states.values.expand((m) => m.values)) {
      if (matcher.canRead(stateEvent.type, stateKey: stateEvent.stateKey)) {
        state.add(stateEvent.toJson());
      }
    }

    if (state.isNotEmpty) {
      await _sendUpdateState(null, state);
    }
  }

  Future<void> _sendUpdateState(
    List<Map<String, dynamic>>? events,
    List<Map<String, dynamic>>? state,
  ) async {
    final message = WidgetMessage(
      api: WidgetApi.toWidget,
      requestId: 'update_${DateTime.now().millisecondsSinceEpoch}',
      action: WidgetAction.updateState,
      widgetId: settings.widgetId,
      data: {
        if (events != null) 'events': events,
        if (state != null) 'state': state,
      },
    );

    await transport.send(message.toJsonString());
  }

  void _sendToDeviceEventToWidget(ToDeviceEvent event) {
    Logs().i(
      'WidgetDriver: Forwarding to-device event ${event.type} from ${event.sender}',
    );

    final message = WidgetMessage(
      api: WidgetApi.toWidget,
      requestId: 'todevice_${DateTime.now().millisecondsSinceEpoch}',
      action: WidgetAction.sendToDevice,
      widgetId: settings.widgetId,
      data: {
        'type': event.type,
        'sender': event.sender,
        'content': event.content,
        'encrypted': event.encryptedContent != null,
      },
    );

    transport.send(message.toJsonString());
  }
}
