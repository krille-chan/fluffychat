import 'dart:convert';

/// Base widget message structure (MSC2762)
class WidgetMessage {
  const WidgetMessage({
    required this.api,
    required this.requestId,
    required this.action,
    required this.widgetId,
    this.data = const {},
    this.response,
  });

  final String api;
  final String requestId;
  final String action;
  final String widgetId;
  final Map<String, dynamic> data;
  final Map<String, dynamic>? response;

  /// Check if this is a request
  bool get isRequest => response == null;

  /// Check if this is a response
  bool get isResponse => response != null;

  /// Check if response is an error
  bool get isError => response?['error'] != null;

  /// Get error message if this is an error response
  String? get errorMessage => response?['error']?['message'] as String?;

  /// Parse from JSON
  factory WidgetMessage.fromJson(Map<String, dynamic> json) {
    return WidgetMessage(
      api: json['api'] as String,
      requestId: json['requestId'] as String,
      action: json['action'] as String,
      widgetId: json['widgetId'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
      response: json['response'] as Map<String, dynamic>?,
    );
  }

  /// Parse from JSON string
  factory WidgetMessage.fromJsonString(String jsonStr) {
    return WidgetMessage.fromJson(
      jsonDecode(jsonStr) as Map<String, dynamic>,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'api': api,
      'requestId': requestId,
      'action': action,
      'widgetId': widgetId,
      'data': data,
    };
    if (response != null) {
      json['response'] = response;
    }
    return json;
  }

  /// Convert to JSON string
  String toJsonString() => jsonEncode(toJson());

  /// Create response to this message
  WidgetMessage respond(Map<String, dynamic> responseData) {
    return WidgetMessage(
      api: api,
      requestId: requestId,
      action: action,
      widgetId: widgetId,
      data: data,
      response: responseData,
    );
  }

  /// Create error response to this message
  WidgetMessage respondError(String errorMessage) {
    return respond({
      'error': {'message': errorMessage},
    });
  }

  @override
  String toString() =>
      'WidgetMessage(api: $api, action: $action, requestId: $requestId, isResponse: $isResponse)';
}

/// Message API types
class WidgetApi {
  static const fromWidget = 'fromWidget';
  static const toWidget = 'toWidget';
}

/// Message actions
class WidgetAction {
  // MSC2762: Core protocol
  static const supportedApiVersions = 'supported_api_versions';
  static const contentLoaded = 'content_loaded';

  // MSC2871: Capabilities
  static const capabilities = 'capabilities';
  static const notifyCapabilities = 'notify_capabilities';

  // MSC2762: State updates
  static const updateState = 'update_state';

  // MSC2931: OpenID
  static const getOpenId = 'get_openid';

  // MSC2876: Read events
  static const readEvent = 'read_event';

  // Send events
  static const sendEvent = 'send_event';

  // MSC3819: To-device
  static const sendToDevice = 'send_to_device';

  // MSC4157: Delayed events
  static const sendDelayedEvent = 'send_delayed_event';
  static const updateDelayedEvent = 'org.matrix.msc4157.update_delayed_event';

  // MSC3846: TURN servers
  static const getTurnServers = 'get_turn_servers';

  // MSC3973: User directory
  static const searchUsers = 'org.matrix.msc3973.user_directory_search';

  // MSC4039: Media
  static const uploadFile = 'org.matrix.msc4039.upload_file';
  static const downloadFile = 'org.matrix.msc4039.download_file';

  // Element Call specific
  static const elementClose = 'io.element.close';
  static const elementJoin = 'io.element.join';
  static const elementDeviceMute = 'io.element.device_mute';
  static const elementHangup = 'im.vector.hangup';
}
