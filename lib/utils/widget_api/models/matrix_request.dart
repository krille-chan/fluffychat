/// Matrix operation request
sealed class MatrixRequest {
  const MatrixRequest();
}

/// MSC2931: Get OpenID token
class GetOpenId extends MatrixRequest {
  const GetOpenId();

  @override
  String toString() => 'GetOpenId()';
}

/// MSC2876: Read events
class ReadEvents extends MatrixRequest {
  const ReadEvents({
    required this.eventType,
    this.limit,
    this.roomIds,
    this.stateKey,
    this.relationType,
    this.eventId,
  });

  final String eventType;
  final int? limit;
  final List<String>? roomIds;
  final String? stateKey;
  final String? relationType; // MSC3869
  final String? eventId; // MSC3869

  bool get isStateEvent => stateKey != null;
  bool get isRelationQuery => relationType != null || eventId != null;

  @override
  String toString() =>
      'ReadEvents(type: $eventType, state: $isStateEvent, relations: $isRelationQuery)';
}

/// Send event
class SendEvent extends MatrixRequest {
  const SendEvent({
    required this.roomId,
    required this.eventType,
    required this.content,
    this.stateKey,
  });

  final String roomId;
  final String eventType;
  final Map<String, dynamic> content;
  final String? stateKey;

  bool get isStateEvent => stateKey != null;

  @override
  String toString() =>
      'SendEvent(room: $roomId, type: $eventType, state: $isStateEvent)';
}

/// MSC3819: Send to-device message
class SendToDevice extends MatrixRequest {
  const SendToDevice({
    required this.eventType,
    required this.messages,
    this.encrypted = false,
  });

  final String eventType;
  final Map<String, Map<String, Map<String, dynamic>>>
      messages; // userId -> deviceId -> content
  final bool encrypted;

  @override
  String toString() => 'SendToDevice(type: $eventType, encrypted: $encrypted)';
}

/// MSC4157: Send delayed event
class SendDelayedEvent extends MatrixRequest {
  const SendDelayedEvent({
    required this.roomId,
    required this.eventType,
    required this.content,
    required this.delay,
    this.stateKey,
    this.parentDelayId,
  });

  final String roomId;
  final String eventType;
  final Map<String, dynamic> content;
  final int delay; // milliseconds
  final String? stateKey;
  final String? parentDelayId;

  @override
  String toString() =>
      'SendDelayedEvent(room: $roomId, type: $eventType, delay: ${delay}ms)';
}

/// MSC4157: Update delayed event
class UpdateDelayedEvent extends MatrixRequest {
  const UpdateDelayedEvent({
    required this.delayId,
    required this.action,
  });

  final String delayId;
  final String action; // 'send', 'cancel', 'restart'

  @override
  String toString() => 'UpdateDelayedEvent(id: $delayId, action: $action)';
}

/// MSC3846: Get TURN servers
class GetTurnServers extends MatrixRequest {
  const GetTurnServers();

  @override
  String toString() => 'GetTurnServers()';
}

/// MSC3973: Search user directory
class SearchUsers extends MatrixRequest {
  const SearchUsers({
    required this.searchTerm,
    this.limit,
  });

  final String searchTerm;
  final int? limit;

  @override
  String toString() => 'SearchUsers(term: $searchTerm)';
}

/// MSC4039: Upload file
class UploadFile extends MatrixRequest {
  const UploadFile({
    required this.file,
    this.filename,
    this.mimetype,
  });

  final List<int> file;
  final String? filename;
  final String? mimetype;

  @override
  String toString() => 'UploadFile(size: ${file.length} bytes)';
}

/// MSC4039: Download file
class DownloadFile extends MatrixRequest {
  const DownloadFile({
    required this.mxcUri,
  });

  final String mxcUri;

  @override
  String toString() => 'DownloadFile(uri: $mxcUri)';
}
