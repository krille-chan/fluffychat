// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:matrix/matrix_api_lite/utils/logs.dart';
import 'package:universal_html/html.dart' as html;

import '../l10n/l10n.dart';

abstract class ForegroundServices {
  static final List<String> runningServices = [];

  static bool _beforeUnload(html.Event e) {
    e.preventDefault();
    return true;
  }

  static Future<void> stopService(String name) async {
    runningServices.remove(name);
    if (runningServices.isNotEmpty) return;
    if (kIsWeb) {
      html.window.removeEventListener('beforeunload', _beforeUnload);
      return;
    }
    FlutterForegroundTask.stopService();
  }

  static Future<void> startService(String name) async {
    try {
      runningServices.add(name);
      if (kIsWeb) {
        html.window.addEventListener('beforeunload', _beforeUnload);
        return;
      }
      if (PlatformInfos.isMobile) {
        final l10n = await L10n.delegate.load(
          PlatformDispatcher.instance.locale,
        );
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
          return;
        }
        final result = await FlutterForegroundTask.startService(
          serviceTypes: [ForegroundServiceTypes.shortService],
          notificationTitle: 'FluffyChat',
          notificationText: l10n.loadingMessages,
          notificationIcon: NotificationIcon(metaDataName: 'ic_launcher'),
        );
        final started = result is ServiceRequestSuccess;
        Logs().d('[PushHelper] Foreground service start: $started ($result)');
      } else if (kIsWeb) {
        // TODO: Implement window.onBeforeUnload overwrite
      }
      return;
    } catch (e, s) {
      Logs().w('[PushHelper] Unable to start foreground service', e, s);
      return;
    }
  }
}
