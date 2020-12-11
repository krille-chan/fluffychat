abstract class AppConfig {
  static const String applicationName = 'FluffyChat';
  static const String applicationWelcomeMessage = null;
  static const String defaultHomeserver = 'matrix.org';
  static String jitsiInstance = 'https://meet.jit.si/';
  static const bool allowOtherHomeservers = true;
  static const bool enableRegistration = true;
  static const String privacyUrl = 'https://fluffychat.im/en/privacy.html';
  static const String sourceCodeUrl =
      'https://gitlab.com/ChristianPauly/fluffychat-flutter';
  static const String supportUrl =
      'https://gitlab.com/ChristianPauly/fluffychat-flutter/issues';
  static const bool enableSentry = true;
  static const String sentryDns =
      'https://8591d0d863b646feb4f3dda7e5dcab38@o256755.ingest.sentry.io/5243143';
  static bool renderHtml = false;
  static bool hideRedactedEvents = false;
  static bool hideUnknownEvents = false;
  static const String inviteLinkPrefix = 'https://matrix.to/#/';
  static const String pushNotificationsChannelId = 'fluffychat_push';
  static const String pushNotificationsChannelName = 'FluffyChat push channel';
  static const String pushNotificationsChannelDescription =
      'Push notifications for FluffyChat';
  static const String pushNotificationsAppId = 'chat.fluffy.fluffychat';
  static const String pushNotificationsGatewayUrl = 'https://janian.de:7023/';
  static const String pushNotificationsPusherFormat = 'event_id_only';
}
