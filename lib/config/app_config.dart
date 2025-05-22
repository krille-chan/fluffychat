import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/common/config/environment.dart';

abstract class AppConfig {
  // #Pangea
  // static String _applicationName = 'FluffyChat';
  static String _applicationName = 'Pangea Chat';
  // #Pangea
  static String get applicationName => _applicationName;
  static String? _applicationWelcomeMessage;

  static String? get applicationWelcomeMessage => _applicationWelcomeMessage;
  // #Pangea
  // static String _defaultHomeserver = 'matrix.org';
  static String get _defaultHomeserver => Environment.synapseURL;
  // #Pangea
  static String get defaultHomeserver => _defaultHomeserver;
  static double fontSizeFactor = 1;
  static const Color chatColor = primaryColor;
  static Color? colorSchemeSeed = primaryColor;
  static const double messageFontSize = 16.0;
  static const bool allowOtherHomeservers = true;
  static const bool enableRegistration = true;
  static const double toolbarMaxHeight = 250.0;
  static const double toolbarMinHeight = 200.0;
  static const double toolbarMinWidth = 350.0;
  static const double defaultHeaderHeight = 56.0;
  static const double toolbarButtonsHeight = 50.0;
  static const double toolbarSpacing = 8.0;
  static const double toolbarIconSize = 24.0;
  static const double readingAssistanceInputBarHeight = 140.0;
  static const double reactionsPickerHeight = 48.0;
  static const double chatInputRowOverlayPadding = 8.0;
  static const double selectModeInputBarHeight =
      reactionsPickerHeight + (chatInputRowOverlayPadding * 2) + toolbarSpacing;
  static const double practiceModeInputBarHeight =
      readingAssistanceInputBarHeight +
          toolbarButtonsHeight +
          (chatInputRowOverlayPadding * 2) +
          toolbarSpacing;
  static const double audioTranscriptionMaxHeight = 150.0;

  static TextStyle messageTextStyle(
    Event? event,
    Color textColor,
  ) {
    final fontSize = messageFontSize * fontSizeFactor;
    final bigEmotes = event != null &&
        event.onlyEmotes &&
        event.numberEmotes > 0 &&
        event.numberEmotes <= 10;

    return TextStyle(
      color: textColor,
      fontSize: bigEmotes ? fontSize * 5 : fontSize,
      decoration:
          (event?.redacted ?? false) ? TextDecoration.lineThrough : null,
      height: 1.3,
    );
  }

  // static const Color primaryColor = Color(0xFF5625BA);
  // static const Color primaryColorLight = Color(0xFFCCBDEA);
  static const Color primaryColor = Color(0xFF8560E0);
  static const Color primaryColorLight = Color(0xFFDBC9FF);
  // static const Color secondaryColor = Color(0xFF41a2bc);
  static const Color secondaryColor = Color.fromARGB(255, 253, 191, 1);
  static const Color activeToggleColor = Color(0xFF33D057);
  static const Color success = Color(0xFF33D057);
  static const Color warning = Color.fromARGB(255, 210, 124, 12);
  static const Color gold = Color.fromARGB(255, 253, 191, 1);
  static const Color silver = Color.fromARGB(255, 192, 192, 192);
  static const Color bronze = Color.fromARGB(255, 205, 127, 50);
  static const Color goldLight = Color.fromARGB(255, 254, 223, 73);
  static const Color error = Colors.red;
  static const int overlayAnimationDuration = 250;
  static const int roomCreationTimeoutSeconds = 15;
  // static String _privacyUrl =
  //     'https://gitlab.com/famedly/fluffychat/-/blob/main/PRIVACY.md';
  static String _privacyUrl = "https://www.pangeachat.com/privacy";
  //Pangea#
  static String get privacyUrl => _privacyUrl;
  // #Pangea
  // static const String website = 'https://fluffychat.im';
  static const String website = "https://pangea.chat/";
  // Pangea#
  static const String enablePushTutorial =
      'https://github.com/krille-chan/fluffychat/wiki/Push-Notifications-without-Google-Services';
  static const String encryptionTutorial =
      'https://github.com/krille-chan/fluffychat/wiki/How-to-use-end-to-end-encryption-in-FluffyChat';
  static const String startChatTutorial =
      'https://github.com/krille-chan/fluffychat/wiki/How-to-Find-Users-in-FluffyChat';
  static const String appId = 'im.fluffychat.FluffyChat';
  // #Pangea
  // static const String appOpenUrlScheme = 'im.fluffychat';
  static const String appOpenUrlScheme = 'matrix.pangea.chat';
  static String _webBaseUrl = 'https://fluffychat.im/web';
  // Pangea#
  static String get webBaseUrl => _webBaseUrl;
  //#Pangea
  static const String sourceCodeUrl = 'https://gitlab.com/famedly/fluffychat';
  // static const String supportUrl =
  //     'https://gitlab.com/famedly/fluffychat/issues';
  static const String supportUrl = 'https://www.pangeachat.com/faqs';
  static const String termsOfServiceUrl =
      'https://www.pangeachat.com/terms-of-service';
  // static const String changelogUrl =
  //     'https://github.com/krille-chan/fluffychat/blob/main/CHANGELOG.md';
  //Pangea#
  static final Uri newIssueUrl = Uri(
    scheme: 'https',
    host: 'github.com',
    path: '/krille-chan/fluffychat/issues/new',
  );
  // #Pangea
  static const bool enableSentry = true;
  static const String sentryDns =
      'https://8591d0d863b646feb4f3dda7e5dcab38@o256755.ingest.sentry.io/5243143';
  // Pangea#
  static bool renderHtml = true;
  // #Pangea
  // static bool hideRedactedEvents = false;
  static bool hideRedactedEvents = true;
  // Pangea#
  static bool hideUnknownEvents = true;
  static bool hideUnimportantStateEvents = true;
  static bool separateChatTypes = false;
  static bool autoplayImages = true;
  static bool sendTypingNotifications = true;
  static bool sendPublicReadReceipts = true;
  static bool swipeRightToLeftToReply = true;
  static bool? sendOnEnter;
  static bool showPresences = true;
  // #Pangea
  static bool displayNavigationRail = true;
  // Pangea#
  static bool experimentalVoip = false;
  static const bool hideTypingUsernames = false;
  static const bool hideAllStateEvents = false;
  static const String inviteLinkPrefix = 'https://matrix.to/#/';
  static const String deepLinkPrefix = 'im.fluffychat://chat/';
  static const String schemePrefix = 'matrix:';
  // #Pangea
  // static const String pushNotificationsChannelId = 'fluffychat_push';
  // static const String pushNotificationsChannelName = 'FluffyChat push channel';
  // static const String pushNotificationsChannelDescription =
  //     'Push notifications for FluffyChat';
  // static const String pushNotificationsAppId = 'chat.fluffy.fluffychat';
  // static const String pushNotificationsGatewayUrl =
  //     'https://push.fluffychat.im/_matrix/push/v1/notify';
  // static const String pushNotificationsPusherFormat = 'event_id_only';
  static const String pushNotificationsChannelId = 'pangeachat_push';
  static const String pushNotificationsChannelName = 'Pangea Chat push channel';
  static const String pushNotificationsChannelDescription =
      'Push notifications for Pangea Chat';
  static const String pushNotificationsAppId = 'com.talktolearn.chat';
  static const String pushNotificationsGatewayUrl =
      'https://sygnal.pangea.chat/_matrix/push/v1/notify';
  static const String? pushNotificationsPusherFormat = null;
  // Pangea#
  static const double borderRadius = 18.0;
  static const double columnWidth = 360.0;
  static final Uri homeserverList = Uri(
    scheme: 'https',
    host: 'servers.joinmatrix.org',
    path: 'servers.json',
  );
  // #Pangea
  static String googlePlayMangementUrl =
      "https://play.google.com/store/account/subscriptions";
  static String googlePlayHistoryUrl =
      "https://play.google.com/store/account/orderhistory";
  static String googlePlayPaymentMethodUrl =
      "https://play.google.com/store/paymentmethods";
  static String appleMangementUrl =
      "https://apps.apple.com/account/subscriptions";
  static String stripePerMonth =
      "https://buy.stripe.com/test_bIY6ssd8z5Uz8ec8ww";
  static String iosPromoCode =
      "https://apps.apple.com/redeem?ctx=offercodes&id=1445118630&code=";
  static String androidUpdateURL =
      "https://play.google.com/store/apps/details?id=com.talktolearn.chat";
  static String iosUpdateURL = "itms-apps://itunes.apple.com/app/id1445118630";

  static String windowsTTSDownloadInstructions =
      "https://support.microsoft.com/en-us/topic/download-languages-and-voices-for-immersive-reader-read-mode-and-read-aloud-4c83a8d8-7486-42f7-8e46-2b0fdf753130";
  static String androidTTSDownloadInstructions =
      "https://support.google.com/accessibility/android/answer/6006983?hl=en";
  static String assetsBaseURL =
      "https://pangea-chat-client-assets.s3.us-east-1.amazonaws.com";

  static String errorSubscriptionId = "pangea_subscription_error";
  // Pangea#

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
    // #Pangea
    // if (json['default_homeserver'] is String) {
    //   _defaultHomeserver = json['default_homeserver'];
    // }
    // Pangea#
    if (json['privacy_url'] is String) {
      _privacyUrl = json['privacy_url'];
    }
    if (json['web_base_url'] is String) {
      _webBaseUrl = json['web_base_url'];
    }
    if (json['render_html'] is bool) {
      // #Pangea
      // this is interfering with our PangeaRichText functionality, removing it for now
      renderHtml = false;
      // renderHtml = json['render_html'];
      // Pangea#
    }
    if (json['hide_redacted_events'] is bool) {
      hideRedactedEvents = json['hide_redacted_events'];
    }
    if (json['hide_unknown_events'] is bool) {
      hideUnknownEvents = json['hide_unknown_events'];
    }
  }
}
