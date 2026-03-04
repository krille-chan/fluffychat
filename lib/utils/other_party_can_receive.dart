import 'package:matrix/matrix.dart';

extension OtherPartyCanReceiveExtension on Room {
  bool get otherPartyCanReceiveMessages {
    if (!encrypted) return true;
    final users = getParticipants()
        .map((u) => u.id)
        .where((userId) => userId != client.userID)
        .toSet();
    if (users.isEmpty) return true;

    for (final userId in users) {
      if (client.userDeviceKeys[userId]?.deviceKeys.values.isNotEmpty == true) {
        return true;
      }
    }
    return false;
  }
}

class OtherPartyCanNotReceiveMessages implements Exception {}
