import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/platform_infos.dart';

extension IosBadgeClientExtension on Client {
  void updateIosBadge() {
    if (!PlatformInfos.isIOS) return;
    final unreadCount = rooms.where((room) => room.isUnreadOrInvited).length;
    if (unreadCount == 0) {
      FlutterAppBadger.removeBadge();
      FlutterLocalNotificationsPlugin()
          .cancelAll(); // Workaround for iOS not clearing notifications with fcm_shared_isolate
    } else {
      FlutterAppBadger.updateBadgeCount(unreadCount);
    }
  }
}
