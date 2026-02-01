import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/fluffy_chat_app.dart';

/// Actions available on desktop notifications
enum DesktopNotificationAction {
  openChat,
  markAsRead,
}

/// Singleton manager for desktop notifications on Linux and macOS.
/// Follows the BackgroundPush pattern for consistent architecture.
class DesktopNotificationsManager {
  static DesktopNotificationsManager? _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Maps room IDs to their current notification IDs for replacement
  final Map<String, int> _roomIdToNotificationId = {};

  /// Callback invoked when user clicks a notification or selects "Open Chat"
  void Function(String roomId)? onSelectNotification;

  /// Callback invoked when user selects "Mark as Read"
  void Function(String roomId, String eventId)? onMarkAsRead;

  DesktopNotificationsManager._();

  /// Get the singleton instance
  static DesktopNotificationsManager get instance =>
      _instance ??= DesktopNotificationsManager._();

  /// Check if desktop notifications are supported on this platform
  static bool get isSupported =>
      !kIsWeb && (Platform.isLinux || Platform.isMacOS);

  /// Initialize the notifications plugin for desktop platforms
  Future<void> initialize() async {
    if (!isSupported) return;

    try {
      if (Platform.isLinux) {
        const linuxSettings = LinuxInitializationSettings(
          defaultActionName: 'Open',
        );
        await _plugin.initialize(
          const InitializationSettings(linux: linuxSettings),
          onDidReceiveNotificationResponse: _onNotificationResponse,
        );
      } else if (Platform.isMacOS) {
        const macOSSettings = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
        await _plugin.initialize(
          const InitializationSettings(macOS: macOSSettings),
          onDidReceiveNotificationResponse: _onNotificationResponse,
        );
      }
      Logs().v('DesktopNotificationsManager initialized');
    } catch (e, s) {
      Logs().e('Failed to initialize DesktopNotificationsManager', e, s);
    }
  }

  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null) return;

    // Payload format: "roomId|eventId"
    final parts = payload.split('|');
    if (parts.length < 2) return;

    final roomId = parts[0];
    final eventId = parts[1];

    // Check if this was an action button or default tap
    final actionId = response.actionId;

    if (actionId == DesktopNotificationAction.markAsRead.name) {
      onMarkAsRead?.call(roomId, eventId);
    } else {
      // Default action or "openChat" action
      if (onSelectNotification != null) {
        onSelectNotification!(roomId);
      } else {
        FluffyChatApp.router.go('/rooms/$roomId');
      }
    }
  }

  /// Show a notification with the given parameters
  ///
  /// [title] - Notification title (usually room name)
  /// [body] - Notification body (message content)
  /// [roomId] - Room ID for navigation
  /// [eventId] - Event ID for mark as read
  /// [avatarData] - Optional avatar image data (RGBA format for Linux)
  /// [avatarWidth] - Avatar width if avatarData provided
  /// [avatarHeight] - Avatar height if avatarData provided
  /// [openChatLabel] - Label for "Open Chat" action
  /// [markAsReadLabel] - Label for "Mark as Read" action
  Future<void> showNotification({
    required String title,
    required String body,
    required String roomId,
    required String eventId,
    Uint8List? avatarData,
    int? avatarWidth,
    int? avatarHeight,
    String? openChatLabel,
    String? markAsReadLabel,
  }) async {
    if (!isSupported) return;

    // Use roomId.hashCode for consistent IDs (allows notification replacement)
    final id = roomId.hashCode;
    _roomIdToNotificationId[roomId] = id;

    final payload = '$roomId|$eventId';

    try {
      if (Platform.isLinux) {
        // Build Linux notification with full features
        LinuxNotificationIcon? icon;
        if (avatarData != null && avatarWidth != null && avatarHeight != null) {
          icon = ByteDataLinuxIcon(
            LinuxRawIconData(
              data: avatarData,
              width: avatarWidth,
              height: avatarHeight,
              channels: 4,
              hasAlpha: true,
            ),
          );
        }

        final actions = <LinuxNotificationAction>[
          LinuxNotificationAction(
            key: DesktopNotificationAction.openChat.name,
            label: openChatLabel ?? 'Open',
          ),
          LinuxNotificationAction(
            key: DesktopNotificationAction.markAsRead.name,
            label: markAsReadLabel ?? 'Mark as Read',
          ),
        ];

        await _plugin.show(
          id,
          title,
          body,
          NotificationDetails(
            linux: LinuxNotificationDetails(
              icon: icon,
              sound: const ThemeLinuxSound('message-new-instant'),
              urgency: LinuxNotificationUrgency.normal,
              actions: actions,
              defaultActionName: openChatLabel ?? 'Open',
            ),
          ),
          payload: payload,
        );
      } else if (Platform.isMacOS) {
        // TODO: macOS could support action buttons and avatars via notification
        // categories (DarwinNotificationCategory) defined at initialization.
        // Currently simpler than Linux - just title, body, click-to-open.
        await _plugin.show(
          id,
          title,
          body,
          const NotificationDetails(
            macOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: payload,
        );
      }
    } catch (e, s) {
      Logs().e('Failed to show desktop notification', e, s);
    }
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    if (!isSupported) return;
    await _plugin.cancelAll();
    _roomIdToNotificationId.clear();
  }

  /// Cancel notification for a specific room
  Future<void> cancelNotification(String roomId) async {
    if (!isSupported) return;

    final id = _roomIdToNotificationId[roomId];
    if (id != null) {
      await _plugin.cancel(id);
      _roomIdToNotificationId.remove(roomId);
    }
  }
}
