import 'package:matrix/matrix.dart';

extension ClientPresenceExtension on Client {
  List<CachedPresence> get contactList {
    final directChatsMxid = rooms
        .where((r) => r.isDirectChat)
        .map((r) => r.directChatMatrixID)
        .toSet();
    final contactList = directChatsMxid
        .map(
          (mxid) =>
              presences[mxid] ??
              CachedPresence(
                PresenceType.offline,
                0,
                null,
                false,
                mxid ?? '',
              ),
        )
        .toList();

    contactList.sort((a, b) => a.userid.compareTo(b.userid));
    contactList.sort((a, b) => ((a.lastActiveTimestamp ??
            DateTime.fromMillisecondsSinceEpoch(0))
        .compareTo(
            b.lastActiveTimestamp ?? DateTime.fromMillisecondsSinceEpoch(0))));
    return contactList;
  }
}
