import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:matrix/matrix.dart';

abstract class AppConfig {
  static String _applicationName = 'Tawkie';
  static String get applicationName => _applicationName;
  static String? _applicationWelcomeMessage;
  static String? get applicationWelcomeMessage => _applicationWelcomeMessage;
  static String _defaultHomeserver = 'alpha.tawkie.fr';
  static String get defaultHomeserver => _defaultHomeserver;
  static double fontSizeFactor = 1;
  static const Color chatColor = primaryColor;
  static Color? colorSchemeSeed = primaryColor;
  static const double messageFontSize = 16.0;
  static const bool allowOtherHomeservers = true;
  static const bool enableRegistration = true;
  static const Color primaryColor = Color(0xFF8123B0);
  static const Color primaryColorLight = Color(0xFFFEEA77);
  static const Color secondaryColor = Color(0xFFFAAB22);
  static String _privacyUrl = 'https://tawkie.fr/privacy-policy/';
  static String get privacyUrl => _privacyUrl;
  static const String termsUrl = 'https://tawkie.fr/legal/';
  static const String enablePushTutorial = 'https://www.tawkie.fr/faq/';
  static const String encryptionTutorial = 'https://www.tawkie.fr/faq/';
  static const String startChatTutorial = 'https://www.tawkie.fr/faq/';
  static const String appId = 'fr.tawkie.app';
  static const String appOpenUrlScheme = 'fr.tawkie';
  static String _webBaseUrl = 'https://tawkie.fr/web/';
  static String get webBaseUrl => _webBaseUrl;
  static const String sourceCodeUrl = 'https://github.com/Tawkie/tawkie-app';
  static const String supportUrl = 'https://www.tawkie.fr/faq/';
  static final Uri newIssueUrl = Uri(
    scheme: 'https',
    host: 'github.com',
    path: '/Tawkie/tawkie-app/issues/new',
  );
  static bool renderHtml = true;
  static bool hideRedactedEvents = false;
  static bool hideUnknownEvents = true;
  static bool hideUnimportantStateEvents = true;
  static bool separateChatTypes = false;
  static bool autoplayImages = true;
  static bool sendTypingNotifications = true;
  static bool sendPublicReadReceipts = true;
  static bool swipeRightToLeftToReply = true;
  static bool? sendOnEnter;
  static bool showPresences = true;
  static bool experimentalVoip = false;
  static const bool hideTypingUsernames = false;
  static const bool hideAllStateEvents = false;
  static const String inviteLinkPrefix = 'https://matrix.to/#/';
  static const String deepLinkPrefix = 'fr.tawkie://chat/';
  static const String schemePrefix = 'matrix:';
  static const String pushNotificationsChannelId = 'tawkie_push';
  static const String pushNotificationsAppId = 'fr.tawkie.app';
  static const String pushNotificationsGatewayUrl =
      'https://push.tawkie.fr/_matrix/push/v1/notify';
  static const String pushNotificationsPusherFormat = 'event_id_only';
  static const String emojiFontName = 'Noto Emoji';
  static const String emojiFontUrl =
      'https://github.com/googlefonts/noto-emoji/';
  static const String aboutUrl = 'https://tawkie.fr/faq/';
  static const double borderRadius = 16.0;
  static const double columnWidth = 360.0;
  static final Uri homeserverList = Uri(
    scheme: 'https',
    host: 'servers.joinmatrix.org',
    path: 'servers.json',
  );

  // Ory Kratos URL
  static const String stagingUrl = 'https://staging.tawkie.fr/';
  static const String productionUrl = 'https://tawkie.fr/';
  static const String baseUrl = kDebugMode ? stagingUrl : productionUrl;
  static String tawkieSubscriptionIdentifier = 'Tawkie subscription';

  // URLs for Beta Join
  static const String testflightAppUrl =
      'https://apps.apple.com/us/app/testflight/id899247664';
  static const String appleBetaUrl =
      'https://testflight.apple.com/join/daXe0NfW';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=fr.tawkie.app';
  static const String androidBetaUrl =
      'https://play.google.com/apps/testing/fr.tawkie.app';

  static const String iosUrl = 'itms-apps://itunes.apple.com/app/id899247664';
  static const String androidUrl = 'market://details?id=fr.tawkie.app';

  static const String prodBetaAlias = 'beta';
  static const String testBetaAlias = 'testbeta';
  static const String betaAlias = kDebugMode ? testBetaAlias : prodBetaAlias;
  static const String serverStagingUrl = ':staging.tawkie.fr';
  static const String serverProductionUrl = ':alpha.tawkie.fr';
  static const String server =
      kDebugMode ? serverStagingUrl : serverProductionUrl;
  static const String roomAlias = '#$betaAlias$server';

  static void loadFromJson(Map<String, dynamic> json) {
    if (json['chat_color'] != null) {
      try {
        colorSchemeSeed = Color(json['chat_color']);
      } catch (e) {
        Logs().w(
          'Invalid color in config.json! Please make sure to define the color in this format: "0xffdd0000"',
          e,
        );
      }
    }
    if (json['application_name'] is String) {
      _applicationName = json['application_name'];
    }
    if (json['application_welcome_message'] is String) {
      _applicationWelcomeMessage = json['application_welcome_message'];
    }
    if (json['default_homeserver'] is String) {
      _defaultHomeserver = json['default_homeserver'];
    }
    if (json['privacy_url'] is String) {
      _webBaseUrl = json['privacy_url'];
    }
    if (json['web_base_url'] is String) {
      _privacyUrl = json['web_base_url'];
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
    if (json['tawkie_subscription_identifier'] is String) {
      tawkieSubscriptionIdentifier = json['tawkie_subscription_identifier'];
    }
  }
}
