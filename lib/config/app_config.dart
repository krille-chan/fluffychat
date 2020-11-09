abstract class AppConfig {
  static const String applicationName = 'FluffyChat';
  static const String defaultHomeserver = 'matrix.tchncs.de';
  static const String privacyUrl = 'https://fluffychat.im/en/privacy.html';
  static const String sourceCodeUrl =
      'https://gitlab.com/ChristianPauly/fluffychat-flutter';
  static const String supportUrl =
      'https://gitlab.com/ChristianPauly/fluffychat-flutter/issues';
  static const String sentryDsn =
      'https://8591d0d863b646feb4f3dda7e5dcab38@o256755.ingest.sentry.io/5243143';
  static bool renderHtml = false;
  static bool hideRedactedEvents = false;
  static bool hideUnknownEvents = false;
}
