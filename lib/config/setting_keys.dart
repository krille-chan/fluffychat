import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingKeys {
  static const String renderHtml = 'chat.fluffy.renderHtml';
  static const String hideRedactedEvents = 'chat.fluffy.hideRedactedEvents';
  static const String hideUnknownEvents = 'chat.fluffy.hideUnknownEvents';
  static const String hideUnimportantStateEvents =
      'chat.fluffy.hideUnimportantStateEvents';
  static const String separateChatTypes = 'chat.fluffy.separateChatTypes';
  static const String sentry = 'sentry';
  static const String theme = 'theme';
  static const String amoledEnabled = 'amoled_enabled';
  static const String codeLanguage = 'code_language';
  static const String showNoGoogle = 'chat.fluffy.show_no_google';
  static const String fontSizeFactor = 'chat.fluffy.font_size_factor';
  static const String showNoPid = 'chat.fluffy.show_no_pid';
  static const String databasePassword = 'database-password';
  static const String appLockKey = 'chat.fluffy.app_lock';
  static const String unifiedPushRegistered =
      'chat.fluffy.unifiedpush.registered';
  static const String unifiedPushEndpoint = 'chat.fluffy.unifiedpush.endpoint';
  static const String ownStatusMessage = 'chat.fluffy.status_msg';
  static const String dontAskForBootstrapKey =
      'chat.fluffychat.dont_ask_bootstrap';
  static const String autoplayImages = 'chat.fluffy.autoplay_images';
  static const String sendTypingNotifications =
      'chat.fluffy.send_typing_notifications';
  static const String sendPublicReadReceipts =
      'chat.fluffy.send_public_read_receipts';
  static const String sendOnEnter = 'chat.fluffy.send_on_enter';
  static const String swipeRightToLeftToReply =
      'chat.fluffy.swipeRightToLeftToReply';
  static const String experimentalVoip = 'chat.fluffy.experimental_voip';
  static const String showPresences = 'chat.fluffy.show_presences';
  static const String displayNavigationRail =
      'chat.fluffy.display_navigation_rail';
}

enum AppSettings<T> {
  textMessageMaxLength<int>('textMessageMaxLength', 16384),
  audioRecordingNumChannels<int>('audioRecordingNumChannels', 1),
  audioRecordingAutoGain<bool>('audioRecordingAutoGain', true),
  audioRecordingEchoCancel<bool>('audioRecordingEchoCancel', false),
  audioRecordingNoiseSuppress<bool>('audioRecordingNoiseSuppress', true),
  audioRecordingBitRate<int>('audioRecordingBitRate', 64000),
  audioRecordingSamplingRate<int>('audioRecordingSamplingRate', 44100),
  pushNotificationsGatewayUrl<String>(
    'pushNotificationsGatewayUrl',
    'https://push.fluffychat.im/_matrix/push/v1/notify',
  ),
  pushNotificationsPusherFormat<String>(
    'pushNotificationsPusherFormat',
    'event_id_only',
  ),
  shareKeysWith<String>('chat.fluffy.share_keys_with_2', 'all'),
  noEncryptionWarningShown<bool>(
    'chat.fluffy.no_encryption_warning_shown',
    false,
  ),
  displayChatDetailsColumn(
    'chat.fluffy.display_chat_details_column',
    false,
  ),
  enableSoftLogout<bool>('chat.fluffy.enable_soft_logout', false);

  final String key;
  final T defaultValue;

  const AppSettings(this.key, this.defaultValue);
}

extension AppSettingsBoolExtension on AppSettings<bool> {
  bool getItem(SharedPreferences store) => store.getBool(key) ?? defaultValue;

  Future<void> setItem(SharedPreferences store, bool value) =>
      store.setBool(key, value);
}

extension AppSettingsStringExtension on AppSettings<String> {
  String getItem(SharedPreferences store) =>
      store.getString(key) ?? defaultValue;

  Future<void> setItem(SharedPreferences store, String value) =>
      store.setString(key, value);
}

extension AppSettingsIntExtension on AppSettings<int> {
  int getItem(SharedPreferences store) => store.getInt(key) ?? defaultValue;

  Future<void> setItem(SharedPreferences store, int value) =>
      store.setInt(key, value);
}

extension AppSettingsDoubleExtension on AppSettings<double> {
  double getItem(SharedPreferences store) =>
      store.getDouble(key) ?? defaultValue;

  Future<void> setItem(SharedPreferences store, double value) =>
      store.setDouble(key, value);
}
