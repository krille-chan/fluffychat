import 'package:famedlysdk/famedlysdk.dart';

extension ClientPresenceExtension on Client {
  static final Map<String, Profile> presencesCache = {};

  Future<Profile> requestProfileCached(String senderId) async {
    presencesCache[senderId] ??= await getProfileFromUserId(senderId);
    return presencesCache[senderId];
  }
}
