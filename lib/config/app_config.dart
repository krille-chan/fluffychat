abstract class AppConfig {
  static String get applicationName => _applicationName;
  static String _applicationName = 'FluffyChat';
  static String get defaultHomeserver => _defaultHomeserver;
  static String _defaultHomeserver = 'matrix-client.matrix.org';
  static String get privacyUrl => _privacyUrl;
  static String _privacyUrl = 'https://fluffychat.im/en/privacy.html';
  static String get sourceCodeUrl => _sourceCodeUrl;
  static String _sourceCodeUrl =
      'https://gitlab.com/ChristianPauly/fluffychat-flutter';
  static String get supportUrl => _supportUrl;
  static String _supportUrl =
      'https://gitlab.com/ChristianPauly/fluffychat-flutter/issues';
  static String get sentryDsn => _sentryDsn;
  static String _sentryDsn =
      'https://8591d0d863b646feb4f3dda7e5dcab38@o256755.ingest.sentry.io/5243143';
  // these settings can be re-set at runtime depending on what the in-app settings are
  static bool renderHtml = false;
  static bool hideRedactedEvents = false;
  static bool hideUnknownEvents = false;
  static String matrixToLinkPrefix = 'https://matrix.to/#/';

  static void loadFromJson(Map<String, dynamic> json) {
    if (json['application_name'] is String) {
      _applicationName = json['application_name'];
    }
    if (json['default_homeserver'] is String) {
      _defaultHomeserver = json['default_homeserver'];
    }
    if (json['privacy_url'] is String) {
      _privacyUrl = json['privacy_url'];
    }
    if (json['source_code_url'] is String) {
      _sourceCodeUrl = json['source_code_url'];
    }
    if (json['support_url'] is String) {
      _supportUrl = json['support_url'];
    }
    if (json['sentry_dsn'] is String) {
      _sentryDsn = json['sentry_dsn'];
    }
    if (json['render_html'] is bool) {
      renderHtml = json['render_html'];
    }
    if (json['hide_redacted_events'] is bool) {
      hideRedactedEvents = json['hide_redacted_events'];
    }
    if (json['hide_unknown_events'] is bool) {
      hideUnknownEvents = json['hide_unknown_events'];
    }
  }
}
