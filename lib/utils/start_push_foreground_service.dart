// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:matrix/matrix_api_lite/utils/logs.dart';

import '../l10n/l10n.dart';

/// Returns whether a foreground service was started for this push.
Future<bool> startPushForegroundService() async {
  if (!PlatformInfos.isAndroid) return false;
  try {
    final l10n = await L10n.delegate.load(PlatformDispatcher.instance.locale);
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'fluffychat_sync',
        channelName: l10n.loadingMessages,
        channelDescription: l10n.loadingMessages,
        onlyAlertOnce: true,
        playSound: false,
        enableVibration: false,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        allowWakeLock: true,
      ),
    );
    if (await FlutterForegroundTask.isRunningService) {
      Logs().d('[PushHelper] Foreground service already running');
      return false;
    }
    final result = await FlutterForegroundTask.startService(
      serviceTypes: [ForegroundServiceTypes.shortService],
      notificationTitle: 'FluffyChat',
      notificationText: l10n.loadingMessages,
      notificationIcon: NotificationIcon(metaDataName: 'ic_launcher'),
    );
    final started = result is ServiceRequestSuccess;
    Logs().d('[PushHelper] Foreground service start: $started ($result)');
    return started;
  } catch (e, s) {
    Logs().w('[PushHelper] Unable to start foreground service', e, s);
    return false;
  }
}
