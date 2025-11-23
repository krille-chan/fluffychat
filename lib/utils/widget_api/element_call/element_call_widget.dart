import 'package:matrix/matrix.dart';
import 'package:uuid/uuid.dart';

import '../widget_settings.dart';
import 'call_url_builder.dart';

const _uuid = Uuid();

/// Element Call widget helpers
class ElementCallWidget {
  /// Create Element Call widget settings
  static WidgetSettings create({
    required Room room,
    required String deviceId,
    required String baseUrl,
    required String parentUrl,
    String? widgetId,
  }) {
    final id = widgetId ?? _uuid.v4();
    Logs().i(
      '[WidgetAPI.ElementCallWidget] create: roomId=${room.id}, widgetId=$id, deviceId=$deviceId',
    );

    final url = CallUrlBuilder.build(
      room: room,
      widgetId: id,
      deviceId: deviceId,
      baseUrl: baseUrl,
      parentUrl: parentUrl,
    );
    Logs().d('[WidgetAPI.ElementCallWidget] create: url=$url');

    final settings = WidgetSettings.forElementCall(
      roomId: room.id,
      url: url,
      widgetId: id,
      name: 'Element Call - ${room.getLocalizedDisplayname()}',
    );
    Logs().d('[WidgetAPI.ElementCallWidget] create: created widget settings');
    return settings;
  }

  /// Check if room has active Element Call
  static bool hasActiveCall(Room room) {
    Logs().v(
      '[WidgetAPI.ElementCallWidget] hasActiveCall: checking roomId=${room.id}',
    );
    final callEvent = room.getState('org.matrix.msc3401.call');
    final hasCall = callEvent != null;
    Logs().v('[WidgetAPI.ElementCallWidget] hasActiveCall: hasCall=$hasCall');
    return hasCall;
  }

  /// Get call session ID
  static String? getCallSessionId(Room room) {
    Logs().v(
      '[WidgetAPI.ElementCallWidget] getCallSessionId: roomId=${room.id}',
    );
    final callEvent = room.getState('org.matrix.msc3401.call');
    final sessionId = callEvent?.content['m.intent'] as String?;
    Logs().v(
      '[WidgetAPI.ElementCallWidget] getCallSessionId: sessionId=$sessionId',
    );
    return sessionId;
  }
}
