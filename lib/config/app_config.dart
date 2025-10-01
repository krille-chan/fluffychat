import 'dart:ui';

abstract class AppConfig {
  // Const and final configuration values (immutable)
  static const Color primaryColor = Color(0xFF5625BA);
  static const Color primaryColorLight = Color(0xFFCCBDEA);
  static const Color secondaryColor = Color(0xFF41a2bc);

  static const Color chatColor = primaryColor;
  static const double messageFontSize = 16.0;
  static const bool allowOtherHomeservers = true;
  static const bool enableRegistration = true;
  static const bool hideTypingUsernames = false;

  static const String inviteLinkPrefix = 'https://matrix.to/#/';
  static const String deepLinkPrefix = 'im.hermes://chat/';
  static const String schemePrefix = 'matrix:';
  static const String pushNotificationsChannelId = 'hermes_push';
  static const String pushNotificationsAppId = 'chat.pantheon.hermes';
  static const double borderRadius = 18.0;
  static const double columnWidth = 360.0;

  static const String website = 'https://hermes.im';
  static const String enablePushTutorial =
      'https://github.com/allomanta/hermes/wiki/Push-Notifications-without-Google-Services';
  static const String encryptionTutorial =
      'https://github.com/allomanta/hermes/wiki/How-to-use-end-to-end-encryption-in-Hermes';
  static const String startChatTutorial =
      'https://github.com/allomanta/hermes/wiki/How-to-Find-Users-in-Hermes';
  static const String appId = 'im.hermes.Hermes';
  static const String appOpenUrlScheme = 'im.hermes';

  static const String sourceCodeUrl = 'https://github.com/allomanta/hermes';
  static const String supportUrl = 'https://github.com/allomanta/hermes/issues';
  static const String changelogUrl =
      'https://github.com/allomanta/hermes/blob/main/CHANGELOG.md';
  static const String donationUrl = 'https://ko-fi.com/krille';

  static const Set<String> defaultReactions = {'👍', '❤️', '😂', '😮', '😢'};

  static final Uri newIssueUrl = Uri(
    scheme: 'https',
    host: 'github.com',
    path: '/allomanta/hermes/issues/new',
  );

  static final Uri homeserverList = Uri(
    scheme: 'https',
    host: 'servers.joinmatrix.org',
    path: 'servers.json',
  );

  static final Uri privacyUrl = Uri(
    scheme: 'https',
    host: 'github.com',
    path: '/allomanta/hermes/blob/main/PRIVACY.md',
  );
}
