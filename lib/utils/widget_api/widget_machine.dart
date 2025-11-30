import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

import 'models/models.dart';

const _uuid = Uuid();

/// Widget machine state
sealed class MachineState {
  const MachineState();
}

/// Awaiting version negotiation
class AwaitingVersions extends MachineState {
  const AwaitingVersions(this.versionRequestId);
  final String versionRequestId;
}

/// Content loaded, awaiting ACK
class ContentLoaded extends MachineState {
  const ContentLoaded({
    required this.negotiatedVersions,
    required this.contentLoadedRequestId,
  });
  final List<String> negotiatedVersions;
  final String contentLoadedRequestId;
}

/// Negotiating capabilities
class NegotiatingCapabilities extends MachineState {
  const NegotiatingCapabilities({
    required this.negotiatedVersions,
    required this.capabilitiesRequestId,
    this.approvedCapabilities = const [],
    this.notifyRequestId,
    this.secondVersionRequestId,
    this.postponedUpdates = const [],
  });
  final List<String> negotiatedVersions;
  final String capabilitiesRequestId;
  final List<String> approvedCapabilities;
  final String? notifyRequestId;
  final String? secondVersionRequestId;
  final List<Map<String, dynamic>> postponedUpdates;

  NegotiatingCapabilities copyWith({
    List<String>? approvedCapabilities,
    String? notifyRequestId,
    String? secondVersionRequestId,
    List<Map<String, dynamic>>? postponedUpdates,
  }) {
    return NegotiatingCapabilities(
      negotiatedVersions: negotiatedVersions,
      capabilitiesRequestId: capabilitiesRequestId,
      approvedCapabilities: approvedCapabilities ?? this.approvedCapabilities,
      notifyRequestId: notifyRequestId ?? this.notifyRequestId,
      secondVersionRequestId:
          secondVersionRequestId ?? this.secondVersionRequestId,
      postponedUpdates: postponedUpdates ?? this.postponedUpdates,
    );
  }
}

/// Fully negotiated and ready
class Negotiated extends MachineState {
  const Negotiated({
    required this.negotiatedVersions,
    required this.approvedCapabilities,
  });
  final List<String> negotiatedVersions;
  final List<String> approvedCapabilities;
}

/// Pure state machine for Widget API protocol
class WidgetMachine {
  WidgetMachine({required this.widgetId})
      : _state = AwaitingVersions(_uuid.v4()) {
    Logs().i('[WidgetAPI.WidgetMachine] constructor: widgetId=$widgetId');
  }

  final String widgetId;
  MachineState _state;

  MachineState get state => _state;

  /// Process incoming message and return actions to execute
  List<MachineAction> process(IncomingMessage message) {
    Logs().v(
      '[WidgetAPI.WidgetMachine] process: message=$message, state=${_state.runtimeType}',
    );
    return switch (message) {
      Initialize() => _handleInitialize(),
      FromWidget(message: final msg) => _handleFromWidget(msg),
      ToWidgetResponse(message: final msg) => _handleToWidgetResponse(msg),
      TransportDied() => [], // Just let driver handle cleanup
    };
  }

  List<MachineAction> _handleInitialize() {
    Logs().i(
      '[WidgetAPI.WidgetMachine] _handleInitialize: sending initial supported_api_versions',
    );
    // Send initial supported_api_versions request
    final state = _state as AwaitingVersions;
    return [
      SendToWidget(
        WidgetMessage(
          api: WidgetApi.toWidget,
          requestId: state.versionRequestId,
          action: WidgetAction.supportedApiVersions,
          widgetId: widgetId,
          data: const {},
        ),
      ),
    ];
  }

  List<MachineAction> _handleFromWidget(WidgetMessage msg) {
    Logs()
        .d('[WidgetAPI.WidgetMachine] _handleFromWidget: action=${msg.action}');
    // Widget requests
    final actions = switch (msg.action) {
      WidgetAction.supportedApiVersions => _handleWidgetVersionRequest(msg),
      WidgetAction.contentLoaded => _handleWidgetContentLoaded(msg),
      WidgetAction.capabilities => _handleWidgetCapabilitiesRequest(msg),
      WidgetAction.getOpenId => _handleGetOpenId(msg),
      WidgetAction.readEvent => _handleReadEvent(msg),
      WidgetAction.sendEvent => _handleSendEvent(msg),
      WidgetAction.sendToDevice => _handleSendToDevice(msg),
      WidgetAction.sendDelayedEvent => _handleSendDelayedEvent(msg),
      WidgetAction.updateDelayedEvent => _handleUpdateDelayedEvent(msg),
      WidgetAction.getTurnServers => _handleGetTurnServers(msg),
      WidgetAction.searchUsers => _handleSearchUsers(msg),
      WidgetAction.uploadFile => _handleUploadFile(msg),
      WidgetAction.downloadFile => _handleDownloadFile(msg),
      WidgetAction.elementClose => [const WidgetClose()],
      WidgetAction.elementJoin => [const WidgetJoin()],
      WidgetAction.elementDeviceMute => _handleElementDeviceMute(msg),
      WidgetAction.elementHangup => _handleElementHangup(msg),
      _ => () {
          Logs().w(
            '[WidgetAPI.WidgetMachine] _handleFromWidget: unknown action=${msg.action}',
          );
          return [SendToWidget(msg.respondError('Unknown action'))];
        }(),
    };
    Logs().v(
      '[WidgetAPI.WidgetMachine] _handleFromWidget: generated ${actions.length} actions',
    );
    return actions;
  }

  List<MachineAction> _handleToWidgetResponse(WidgetMessage msg) {
    Logs().d(
      "[WidgetAPI.WidgetMachine] _handleToWidgetResponse: action=${msg.action}, requestId=${msg.requestId}",
    );

    // Route responses based on state and requestId
    return switch (_state) {
      NegotiatingCapabilities(capabilitiesRequestId: final reqId)
          when msg.requestId == reqId =>
        _handleCapabilitiesResponse(msg),
      NegotiatingCapabilities(notifyRequestId: final reqId)
          when msg.requestId == reqId =>
        _handleNotifyCapabilitiesResponse(msg),
      NegotiatingCapabilities(secondVersionRequestId: final reqId)
          when msg.requestId == reqId =>
        _handleSecondVersionResponse(msg),
      _ => [], // Ignore unexpected responses
    };
  }

  List<MachineAction> _handleCapabilitiesResponse(WidgetMessage msg) {
    Logs().d(
      '[WidgetAPI.WidgetMachine] _handleCapabilitiesResponse: isError=${msg.isError}',
    );
    if (msg.isError) return [];

    // Capabilities come as List<String> from widget
    final capabilitiesList =
        (msg.response?['capabilities'] as List?)?.cast<String>() ?? [];
    Logs().i(
      '[WidgetAPI.WidgetMachine] _handleCapabilitiesResponse: requested capabilities=${capabilitiesList.length}',
    );

    // Widget's response IS the ACK - don't respond to responses!
    // Just request approval from provider
    return [
      RequestCapabilityApproval(
        requested: capabilitiesList,
        originalMessage: msg,
      ),
    ];
  }

  /// Called by driver after capability approval
  List<MachineAction> approveCapabilities(List<String> approved) {
    Logs().i(
      '[WidgetAPI.WidgetMachine] approveCapabilities: approved=$approved',
    );
    if (_state is! NegotiatingCapabilities) {
      Logs().w(
        '[WidgetAPI.WidgetMachine] approveCapabilities: not in NegotiatingCapabilities state',
      );
      return [];
    }

    final state = _state as NegotiatingCapabilities;
    final requestId = _uuid.v4();

    // Stay in NegotiatingCapabilities, store notifyRequestId and approved capabilities
    _state = state.copyWith(
      notifyRequestId: requestId,
      approvedCapabilities: approved,
    );

    Logs().d(
      '[WidgetAPI.WidgetMachine] approveCapabilities: sending notify_capabilities',
    );

    // Send notify_capabilities with requested and approved capabilities
    return [
      SendToWidget(
        WidgetMessage(
          api: WidgetApi.toWidget,
          requestId: requestId,
          action: WidgetAction.notifyCapabilities,
          widgetId: widgetId,
          data: {
            'requested': approved,
            'approved': approved,
          },
        ),
      ),
    ];
  }

  List<MachineAction> _handleNotifyCapabilitiesResponse(WidgetMessage msg) {
    Logs().d(
      '[WidgetAPI.WidgetMachine] _handleNotifyCapabilitiesResponse: isError=${msg.isError}',
    );
    if (msg.isError) return [];

    if (_state is! NegotiatingCapabilities) {
      Logs().w(
        '[WidgetAPI.WidgetMachine] _handleNotifyCapabilitiesResponse: not in NegotiatingCapabilities state',
      );
      return [];
    }

    final state = _state as NegotiatingCapabilities;
    final requestId = _uuid.v4();

    // Stay in NegotiatingCapabilities, store secondVersionRequestId
    _state = state.copyWith(secondVersionRequestId: requestId);

    Logs().d(
      '[WidgetAPI.WidgetMachine] _handleNotifyCapabilitiesResponse: sending second supported_api_versions request',
    );

    // Send second supported_api_versions request
    return [
      SendToWidget(
        WidgetMessage(
          api: WidgetApi.toWidget,
          requestId: requestId,
          action: WidgetAction.supportedApiVersions,
          widgetId: widgetId,
          data: const {},
        ),
      ),
    ];
  }

  List<MachineAction> _handleSecondVersionResponse(WidgetMessage msg) {
    Logs().d(
      '[WidgetAPI.WidgetMachine] _handleSecondVersionResponse: isError=${msg.isError}',
    );
    if (msg.isError) return [];

    if (_state is! NegotiatingCapabilities) {
      Logs().w(
        '[WidgetAPI.WidgetMachine] _handleSecondVersionResponse: not in NegotiatingCapabilities state',
      );
      return [];
    }

    final state = _state as NegotiatingCapabilities;

    // Transition to Negotiated with approved capabilities from state
    _state = Negotiated(
      negotiatedVersions: state.negotiatedVersions,
      approvedCapabilities: state.approvedCapabilities,
    );

    Logs().i(
      '[WidgetAPI.WidgetMachine] _handleSecondVersionResponse: transitioning to Negotiated state',
    );

    // Subscribe to events
    return [
      const SubscribeToEvents(),
    ];
  }

  // Matrix operation handlers

  List<MachineAction> _handleGetOpenId(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    return [
      ExecuteMatrixRequest(
        request: const GetOpenId(),
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleReadEvent(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    final eventType = msg.data['type'] as String?;
    if (eventType == null) {
      return [SendToWidget(msg.respondError('Missing event type'))];
    }

    final request = ReadEvents(
      eventType: eventType,
      limit: msg.data['limit'] as int?,
      roomIds: (msg.data['room_ids'] as List?)?.cast<String>(),
      stateKey: msg.data['state_key'] as String?,
      relationType: msg.data['rel_type'] as String?,
      eventId: msg.data['event_id'] as String?,
    );

    return [
      ExecuteMatrixRequest(
        request: request,
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleSendEvent(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    final roomId = msg.data['room_id'] as String?;
    final eventType = msg.data['type'] as String?;
    final content = msg.data['content'] as Map<String, dynamic>?;
    final delay = msg.data['delay'] as int?;

    if (roomId == null || eventType == null || content == null) {
      return [SendToWidget(msg.respondError('Missing required fields'))];
    }

    // If delay is present, treat as delayed event
    final MatrixRequest request;
    if (delay != null) {
      request = SendDelayedEvent(
        roomId: roomId,
        eventType: eventType,
        content: content,
        delay: delay,
        stateKey: msg.data['state_key'] as String?,
        parentDelayId: msg.data['parent_delay_id'] as String?,
      );
    } else {
      request = SendEvent(
        roomId: roomId,
        eventType: eventType,
        content: content,
        stateKey: msg.data['state_key'] as String?,
      );
    }

    return [
      ExecuteMatrixRequest(
        request: request,
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleSendToDevice(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    // Validate request fields (match matrix-widget-api validation)
    final eventType = msg.data['type'] as String?;
    if (eventType == null) {
      return [
        SendToWidget(
          msg.respondError('Invalid request - missing event type'),
        ),
      ];
    }

    final messages = msg.data['messages'] as Map<String, dynamic>?;
    if (messages == null) {
      return [
        SendToWidget(
          msg.respondError('Invalid request - missing event contents'),
        ),
      ];
    }

    final encrypted = msg.data['encrypted'];
    if (encrypted is! bool) {
      return [
        SendToWidget(
          msg.respondError('Invalid request - missing encryption flag'),
        ),
      ];
    }

    // Convert messages to proper format
    final formattedMessages = <String, Map<String, Map<String, dynamic>>>{};
    messages.forEach((userId, deviceMap) {
      if (deviceMap is Map) {
        formattedMessages[userId] = {};
        deviceMap.forEach((deviceId, content) {
          if (content is Map) {
            formattedMessages[userId]![deviceId.toString()] =
                Map<String, dynamic>.from(content);
          }
        });
      }
    });

    final request = SendToDevice(
      eventType: eventType,
      messages: formattedMessages,
      encrypted: encrypted as bool,
    );

    return [
      ExecuteMatrixRequest(
        request: request,
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleSendDelayedEvent(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    final roomId = msg.data['room_id'] as String?;
    final eventType = msg.data['type'] as String?;
    final content = msg.data['content'] as Map<String, dynamic>?;
    final delay = msg.data['delay'] as int?;

    if (roomId == null ||
        eventType == null ||
        content == null ||
        delay == null) {
      return [SendToWidget(msg.respondError('Missing required fields'))];
    }

    final request = SendDelayedEvent(
      roomId: roomId,
      eventType: eventType,
      content: content,
      delay: delay,
      stateKey: msg.data['state_key'] as String?,
      parentDelayId: msg.data['parent_delay_id'] as String?,
    );

    return [
      ExecuteMatrixRequest(
        request: request,
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleUpdateDelayedEvent(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    final delayId = msg.data['delay_id'] as String?;
    final action = msg.data['action'] as String?;

    if (delayId == null || action == null) {
      return [SendToWidget(msg.respondError('Missing required fields'))];
    }

    final request = UpdateDelayedEvent(
      delayId: delayId,
      action: action,
    );

    return [
      ExecuteMatrixRequest(
        request: request,
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleGetTurnServers(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    return [
      ExecuteMatrixRequest(
        request: const GetTurnServers(),
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleSearchUsers(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    final searchTerm = msg.data['search_term'] as String?;
    if (searchTerm == null) {
      return [SendToWidget(msg.respondError('Missing search_term'))];
    }

    final request = SearchUsers(
      searchTerm: searchTerm,
      limit: msg.data['limit'] as int?,
    );

    return [
      ExecuteMatrixRequest(
        request: request,
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleUploadFile(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    final file = msg.data['file'] as List<int>?;
    if (file == null) {
      return [SendToWidget(msg.respondError('Missing file'))];
    }

    final request = UploadFile(
      file: file,
      filename: msg.data['filename'] as String?,
      mimetype: msg.data['mimetype'] as String?,
    );

    return [
      ExecuteMatrixRequest(
        request: request,
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleDownloadFile(WidgetMessage msg) {
    if (_state is! Negotiated) {
      return [SendToWidget(msg.respondError('Not negotiated'))];
    }

    final mxcUri = msg.data['mxc_uri'] as String?;
    if (mxcUri == null) {
      return [SendToWidget(msg.respondError('Missing mxc_uri'))];
    }

    final request = DownloadFile(mxcUri: mxcUri);

    return [
      ExecuteMatrixRequest(
        request: request,
        originalMessage: msg,
      ),
    ];
  }

  List<MachineAction> _handleElementDeviceMute(WidgetMessage msg) {
    final deviceId = msg.data['device_id'] as String?;
    final muted = msg.data['muted'] as bool?;

    if (deviceId == null || muted == null) {
      return [SendToWidget(msg.respondError('Missing device_id or muted'))];
    }

    return [
      WidgetDeviceMute(deviceId: deviceId, muted: muted),
      SendToWidget(msg.respond({})), // ACK
    ];
  }

  List<MachineAction> _handleElementHangup(WidgetMessage msg) {
    return [
      const WidgetHangup(),
      SendToWidget(msg.respond({})), // ACK
    ];
  }

  // Widget-initiated protocol messages

  List<MachineAction> _handleWidgetVersionRequest(WidgetMessage msg) {
    // Widget asking what versions we support
    return [
      SendToWidget(
        msg.respond({
          'supported_versions': currentApiVersions,
        }),
      ),
    ];
  }

  List<MachineAction> _handleWidgetContentLoaded(WidgetMessage msg) {
    final capabilitiesRequestId = _uuid.v4();

    // Transition to NegotiatingCapabilities when we request capabilities
    _state = NegotiatingCapabilities(
      negotiatedVersions: [],
      capabilitiesRequestId: capabilitiesRequestId,
    );

    // Widget notifying it's loaded
    // Send ACK and request capabilities
    return [
      SendToWidget(msg.respond({})),
      SendToWidget(
        WidgetMessage(
          api: WidgetApi.toWidget,
          requestId: capabilitiesRequestId,
          action: WidgetAction.capabilities,
          widgetId: widgetId,
          data: const {},
        ),
      ),
    ];
  }

  List<MachineAction> _handleWidgetCapabilitiesRequest(WidgetMessage msg) {
    // This shouldn't happen - we ask widget for capabilities, not the other way
    return [SendToWidget(msg.respondError('Unexpected capabilities request'))];
  }
}
