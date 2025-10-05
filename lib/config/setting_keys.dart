import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix_api_lite/utils/logs.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingKeys {
  static const String renderHtml = 'chat.pantheon.renderHtml';
  static const String hideRedactedEvents = 'chat.pantheon.hideRedactedEvents';
  static const String hideUnknownEvents = 'chat.pantheon.hideUnknownEvents';
  static const String hideUnimportantStateEvents =
      'chat.pantheon.hideUnimportantStateEvents';
  static const String separateChatTypes = 'chat.pantheon.separateChatTypes';
  static const String sentry = 'sentry';
  static const String theme = 'theme';
  static const String amoledEnabled = 'amoled_enabled';
  static const String codeLanguage = 'code_language';
  static const String showNoGoogle = 'chat.pantheon.show_no_google';
  static const String fontSizeFactor = 'chat.pantheon.font_size_factor';
  static const String showNoPid = 'chat.pantheon.show_no_pid';
  static const String databasePassword = 'database-password';
  static const String appLockKey = 'chat.pantheon.app_lock';
  static const String unifiedPushRegistered =
      'chat.pantheon.unifiedpush.registered';
  static const String unifiedPushEndpoint =
      'chat.pantheon.unifiedpush.endpoint';
  static const String ownStatusMessage = 'chat.pantheon.status_msg';
  static const String dontAskForBootstrapKey = 'chat.hermes.dont_ask_bootstrap';
  static const String autoplayImages = 'chat.pantheon.autoplay_images';
  static const String sendTypingNotifications =
      'chat.pantheon.send_typing_notifications';
  static const String sendPublicReadReceipts =
      'chat.pantheon.send_public_read_receipts';
  static const String sendOnEnter = 'chat.pantheon.send_on_enter';
  static const String swipeRightToLeftToReply =
      'chat.pantheon.swipeRightToLeftToReply';

  static const String swipePopEnableFullScreenDrag =
      'chat.pantheon.swipePopEnableFullScreenDrag';
  static const String swipePopDurationMs = 'chat.pantheon.swipePopDurationMs';
  static const String swipePopMinimumDragFraction =
      'chat.pantheon.swipePopMinimumDragFraction';
  static const String swipePopVelocityThreshold =
      'chat.pantheon.swipePopVelocityThreshold';

  static const String experimentalVoip = 'chat.pantheon.experimental_voip';
  static const String showPresences = 'chat.pantheon.show_presences';
  static const String displayNavigationRail =
      'chat.pantheon.display_navigation_rail';
}

enum AppSettings<T> {
  textMessageMaxLength<int>('textMessageMaxLength', 16384),
  audioRecordingNumChannels<int>('audioRecordingNumChannels', 1),
  audioRecordingAutoGain<bool>('audioRecordingAutoGain', true),
  audioRecordingEchoCancel<bool>('audioRecordingEchoCancel', false),
  audioRecordingNoiseSuppress<bool>('audioRecordingNoiseSuppress', true),
  audioRecordingBitRate<int>('audioRecordingBitRate', 64000),
  audioRecordingSamplingRate<int>('audioRecordingSamplingRate', 44100),
  showNoGoogle<bool>('chat.pantheon.show_no_google', false),
  unifiedPushRegistered<bool>('chat.pantheon.unifiedpush.registered', false),
  unifiedPushEndpoint<String>('chat.pantheon.unifiedpush.endpoint', ''),
  pushNotificationsGatewayUrl<String>(
    'pushNotificationsGatewayUrl',
    'https://push.lageveen.co/_matrix/push/v1/notify',
  ),
  pushNotificationsPusherFormat<String>(
    'pushNotificationsPusherFormat',
    'event_id_only',
  ),
  renderHtml<bool>('chat.fluffy.renderHtml', true),
  fontSizeFactor<double>('chat.fluffy.font_size_factor', 1.0),
  hideRedactedEvents<bool>('chat.fluffy.hideRedactedEvents', false),
  hideUnknownEvents<bool>('chat.fluffy.hideUnknownEvents', true),
  separateChatTypes<bool>('chat.fluffy.separateChatTypes', false),
  autoplayImages<bool>('chat.fluffy.autoplay_images', true),
  sendTypingNotifications<bool>('chat.fluffy.send_typing_notifications', true),
  sendPublicReadReceipts<bool>('chat.fluffy.send_public_read_receipts', true),
  swipeRightToLeftToReply<bool>('chat.fluffy.swipeRightToLeftToReply', true),
  sendOnEnter<bool>('chat.fluffy.send_on_enter', false),
  showPresences<bool>('chat.fluffy.show_presences', true),
  displayNavigationRail<bool>('chat.fluffy.display_navigation_rail', false),
  experimentalVoip<bool>('chat.fluffy.experimental_voip', false),
  shareKeysWith<String>('chat.pantheon.share_keys_with_2', 'all'),
  noEncryptionWarningShown<bool>(
    'chat.pantheon.no_encryption_warning_shown',
    false,
  ),
  displayChatDetailsColumn(
    'chat.pantheon.display_chat_details_column',
    false,
  ),
  // AppConfig-mirrored settings
  applicationName<String>('chat.pantheon.application_name', 'Hermes'),
  defaultHomeserver<String>('chat.pantheon.default_homeserver', 'matrix.org'),
  // colorSchemeSeed stored as ARGB int
  colorSchemeSeedInt<int>(
    'chat.pantheon.color_scheme_seed',
    0xFF5625BA,
  ),
  enableSoftLogout<bool>('chat.pantheon.enable_soft_logout', false);

  final String key;
  final T defaultValue;

  const AppSettings(this.key, this.defaultValue);

  static SharedPreferences get store => _store!;
  static SharedPreferences? _store;

  static Future<SharedPreferences> init({loadWebConfigFile = true}) async {
    if (AppSettings._store != null) return AppSettings.store;

    final store = AppSettings._store = await SharedPreferences.getInstance();

    if (store.getBool(AppSettings.sendOnEnter.key) == null) {
      await store.setBool(AppSettings.sendOnEnter.key, !PlatformInfos.isMobile);
    }
    if (kIsWeb && loadWebConfigFile) {
      try {
        final configJsonString =
            utf8.decode((await http.get(Uri.parse('config.json'))).bodyBytes);
        final configJson =
            json.decode(configJsonString) as Map<String, Object?>;
        for (final setting in AppSettings.values) {
          if (store.get(setting.key) != null) continue;
          final configValue = configJson[setting.name];
          if (configValue == null) continue;
          if (configValue is bool) {
            await store.setBool(setting.key, configValue);
          }
          if (configValue is String) {
            await store.setString(setting.key, configValue);
          }
          if (configValue is int) {
            await store.setInt(setting.key, configValue);
          }
          if (configValue is double) {
            await store.setDouble(setting.key, configValue);
          }
        }
      } on FormatException catch (_) {
        Logs().v('[ConfigLoader] config.json not found');
      } catch (e) {
        Logs().v('[ConfigLoader] config.json not found', e);
      }
    }

    return store;
  }
}

extension AppSettingsBoolExtension on AppSettings<bool> {
  bool get value => AppSettings.store.getBool(key) ?? defaultValue;

  Future<void> setItem(bool value) => AppSettings.store.setBool(key, value);
}

extension AppSettingsStringExtension on AppSettings<String> {
  String get value => AppSettings.store.getString(key) ?? defaultValue;

  Future<void> setItem(String value) => AppSettings.store.setString(key, value);
}

extension AppSettingsIntExtension on AppSettings<int> {
  int get value => AppSettings.store.getInt(key) ?? defaultValue;

  Future<void> setItem(int value) => AppSettings.store.setInt(key, value);
}

extension AppSettingsDoubleExtension on AppSettings<double> {
  double get value => AppSettings.store.getDouble(key) ?? defaultValue;

  Future<void> setItem(double value) => AppSettings.store.setDouble(key, value);
}
