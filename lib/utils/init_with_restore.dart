import 'dart:convert';
import 'dart:ui';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class SessionBackup {
  final String? olmAccount;
  final String accessToken;
  final String userId;
  final String homeserver;
  final String? deviceId;
  final String? deviceName;

  const SessionBackup({
    required this.olmAccount,
    required this.accessToken,
    required this.userId,
    required this.homeserver,
    required this.deviceId,
    this.deviceName,
  });

  factory SessionBackup.fromJsonString(String json) =>
      SessionBackup.fromJson(jsonDecode(json));

  factory SessionBackup.fromJson(Map<String, dynamic> json) => SessionBackup(
        olmAccount: json['olm_account'],
        accessToken: json['access_token'],
        userId: json['user_id'],
        homeserver: json['homeserver'],
        deviceId: json['device_id'],
        deviceName: json['device_name'],
      );

  Map<String, dynamic> toJson() => {
        'olm_account': olmAccount,
        'access_token': accessToken,
        'user_id': userId,
        'homeserver': homeserver,
        'device_id': deviceId,
        if (deviceName != null) 'device_name': deviceName,
      };

  @override
  String toString() => jsonEncode(toJson());
}

extension InitWithRestoreExtension on Client {
  static Future<void> deleteSessionBackup(String clientName) async {
    final storage = PlatformInfos.isMobile || PlatformInfos.isLinux
        ? const FlutterSecureStorage()
        : null;
    await storage?.delete(
      key: '${AppConfig.applicationName}_session_backup_$clientName',
    );
  }

  Future<void> initWithRestore({void Function()? onMigration}) async {
    final storageKey =
        '${AppConfig.applicationName}_session_backup_$clientName';
    final storage = PlatformInfos.isMobile || PlatformInfos.isLinux
        ? const FlutterSecureStorage()
        : null;

    try {
      await init(
        onMigration: onMigration,
        waitForFirstSync: false,
        waitUntilLoadCompletedLoaded: false,
      );
      if (isLogged()) {
        final accessToken = this.accessToken;
        final homeserver = this.homeserver?.toString();
        final deviceId = deviceID;
        final userId = userID;
        final hasBackup = accessToken != null &&
            homeserver != null &&
            deviceId != null &&
            userId != null;
        assert(hasBackup);
        if (hasBackup) {
          Logs().v('Store session in backup');
          storage?.write(
            key: storageKey,
            value: SessionBackup(
              olmAccount: encryption?.pickledOlmAccount,
              accessToken: accessToken,
              deviceId: deviceId,
              homeserver: homeserver,
              deviceName: deviceName,
              userId: userId,
            ).toString(),
          );
        }
      }
    } catch (e, s) {
      Logs().wtf('Client init failed!', e, s);
      final l10n = lookupL10n(PlatformDispatcher.instance.locale);
      final sessionBackupString = await storage?.read(key: storageKey);
      if (sessionBackupString == null) {
        ClientManager.sendInitNotification(
          l10n.initAppError,
          l10n.sessionLostBody(AppConfig.newIssueUrl.toString(), e.toString()),
        );
        rethrow;
      }

      try {
        final sessionBackup = SessionBackup.fromJsonString(sessionBackupString);
        await init(
          newToken: sessionBackup.accessToken,
          newOlmAccount: sessionBackup.olmAccount,
          newDeviceID: sessionBackup.deviceId,
          newDeviceName: sessionBackup.deviceName,
          newHomeserver: Uri.tryParse(sessionBackup.homeserver),
          newUserID: sessionBackup.userId,
          waitForFirstSync: false,
          waitUntilLoadCompletedLoaded: false,
          onMigration: onMigration,
        );
        ClientManager.sendInitNotification(
          l10n.initAppError,
          l10n.restoreSessionBody(
            AppConfig.newIssueUrl.toString(),
            e.toString(),
          ),
        );
      } catch (e, s) {
        Logs().wtf('Restore client failed!', e, s);
        ClientManager.sendInitNotification(
          l10n.initAppError,
          l10n.sessionLostBody(AppConfig.newIssueUrl.toString(), e.toString()),
        );
        rethrow;
      }
    }
  }
}
