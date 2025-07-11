import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix_api_lite/utils/logs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/utils/platform_infos.dart';

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
    'https://push.hermes.im/_matrix/push/v1/notify',
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
