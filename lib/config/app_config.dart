import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/foundation.dart';

abstract class AppConfig {
  // Const and final configuration values (immutable)
  static const Color primaryColor = Color(0xFF5625BA);
  static const Color primaryColorLight = Color(0xFFCCBDEA);
  static const Color secondaryColor = Color(0xFF41a2bc);

  static const Color chatColor = primaryColor;
  // Chat body base size. macOS native chat apps (Telegram, Messages, Mail)
  // render body around 14pt, noticeably tighter than Material 3's 16sp.
  // Everywhere else we keep Material/HIG defaults (16sp on Android,
  // ~17pt on iOS via Dynamic Type).
  static final double messageFontSize = (!kIsWeb && Platform.isMacOS)
      ? 14.0
      : 16.0;

  // Line-height for message body. macOS/SF Pro feels natural at 1.25×,
  // which is tighter than the default Material/font leading. On other
  // platforms we leave it null so each font uses its own intrinsic leading.
  static final double? messageLineHeight = (!kIsWeb && Platform.isMacOS)
      ? 1.25
      : null;
  static const bool allowOtherHomeservers = true;
  static const bool enableRegistration = true;
  static const bool hideTypingUsernames = false;

  static const String inviteLinkPrefix = 'https://matrix.to/#/';
  static const String deepLinkPrefix = 'im.fluffychat://chat/';
  static const String schemePrefix = 'matrix:';
  static const String pushNotificationsChannelId = 'fluffychat_push';
  static const String pushNotificationsAppId = 'chat.fluffy.fluffychat';
  static const double borderRadius = 16.0;
  static const double spaceBorderRadius = 11.0;
  static const double columnWidth = 360.0;

  static const String enablePushTutorial =
      'https://fluffychat.im/faq/#push_without_google_services';
  static const String encryptionTutorial =
      'https://fluffychat.im/faq/#how_to_use_end_to_end_encryption';
  static const String startChatTutorial =
      'https://fluffychat.im/faq/#how_do_i_find_other_users';
  static const String howDoIGetStickersTutorial =
      'https://fluffychat.im/faq/#how_do_i_get_stickers';
  static const String appId = 'im.fluffychat.FluffyChat';
  static const String appOpenUrlScheme = 'im.fluffychat';
  static const String appSsoUrlScheme = 'im.fluffychat.auth';

  static const String sourceCodeUrl =
      'https://github.com/krille-chan/fluffychat';
  static const String supportUrl =
      'https://github.com/krille-chan/fluffychat/issues';
  static const String changelogUrl = 'https://fluffy.chat/en/changelog/';

  static const Set<String> defaultReactions = {'👍', '❤️', '😂', '😮', '😢'};

  static final Uri newIssueUrl = Uri(
    scheme: 'https',
    host: 'github.com',
    path: '/krille-chan/fluffychat/issues/new',
  );

  static final Uri homeserverList = Uri(
    scheme: 'https',
    host: 'raw.githubusercontent.com',
    path: 'krille-chan/fluffychat/refs/heads/main/recommended_homeservers.json',
  );

  static const String mainIsolatePortName = 'main_isolate';
  static const String pushIsolatePortName = 'push_isolate';
}
