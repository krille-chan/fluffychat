import 'package:uuid/uuid.dart';

import 'capabilities/capabilities.dart';

const _uuid = Uuid();

/// Widget configuration settings
class WidgetSettings {
  const WidgetSettings({
    required this.widgetId,
    required this.url,
    required this.roomId,
    required this.capabilitiesProvider,
    this.name,
  });

  final String widgetId;
  final String url;
  final String roomId;
  final String? name;
  final CapabilitiesProvider capabilitiesProvider;

  /// Create settings for Element Call widget
  factory WidgetSettings.forElementCall({
    required String roomId,
    required String url,
    String? widgetId,
    String? name,
  }) {
    return WidgetSettings(
      widgetId: widgetId ?? _uuid.v4(),
      url: url,
      roomId: roomId,
      name: name ?? 'Element Call',
      capabilitiesProvider: (requested) async {
        // Auto-approve all requested capabilities for Element Call
        return requested;
      },
    );
  }

  /// Create settings for Jitsi widget
  factory WidgetSettings.forJitsi({
    required String roomId,
    required String url,
    String? widgetId,
    String? name,
  }) {
    return WidgetSettings(
      widgetId: widgetId ?? _uuid.v4(),
      url: url,
      roomId: roomId,
      name: name ?? 'Jitsi',
      capabilitiesProvider: (requested) async {
        final approved = WidgetCapabilities.jitsi();
        final filtered =
            requested.where((value) => approved.contains(value)).toList();
        return filtered.isEmpty ? approved : filtered;
      },
    );
  }

  /// Create settings for custom widget with read-only access
  factory WidgetSettings.readOnly({
    required String roomId,
    required String url,
    String? widgetId,
    String? name,
  }) {
    return WidgetSettings(
      widgetId: widgetId ?? _uuid.v4(),
      url: url,
      roomId: roomId,
      name: name,
      capabilitiesProvider: (requested) async {
        final approved = WidgetCapabilities.readOnly();
        final filtered =
            requested.where((value) => approved.contains(value)).toList();
        return filtered.isEmpty ? approved : filtered;
      },
    );
  }

  /// Create settings for custom widget with custom capability provider
  factory WidgetSettings.custom({
    required String roomId,
    required String url,
    required CapabilitiesProvider capabilitiesProvider,
    String? widgetId,
    String? name,
  }) {
    return WidgetSettings(
      widgetId: widgetId ?? _uuid.v4(),
      url: url,
      roomId: roomId,
      name: name,
      capabilitiesProvider: capabilitiesProvider,
    );
  }

  @override
  String toString() =>
      'WidgetSettings(id: $widgetId, name: $name, room: $roomId)';
}
