import 'package:famedlysdk/famedlysdk.dart';

extension ClientPresenceExtension on Client {
  List<Presence> get statusList {
    final statusList = presences.values.toList().reversed.toList();
    final directRooms = rooms.where((r) => r.isDirectChat).toList();
    statusList.removeWhere((p) =>
        directRooms.indexWhere((r) => r.directChatMatrixID == p.senderId) ==
        -1);
    statusList.reversed.toList();
    return statusList;
  }

  static final Map<String, Profile> presencesCache = {};

  Future<Profile> requestProfileCached(String senderId) async {
    presencesCache[senderId] ??= await getProfileFromUserId(senderId);
    return presencesCache[senderId];
  }
}
