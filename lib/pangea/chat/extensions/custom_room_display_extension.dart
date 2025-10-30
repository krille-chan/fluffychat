import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/activity_sessions/activity_room_extension.dart';

extension CustomRoomDisplayExtension on Room {
  String senderDisplayName(User user) {
    final displayName = user.calcDisplayname();
    if (showActivityChatUI) {
      final role = activityRoles?.role(user.id);
      if (role?.role == null) return displayName;
      return "${role!.role} | $displayName";
    }

    return displayName;
  }
}
