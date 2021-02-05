import 'package:famedlysdk/famedlysdk.dart';

extension ClientPresenceExtension on Client {
  List<Presence> get contactList {
    final directChatsMxid = rooms
        .where((r) => r.isDirectChat)
        .map((r) => r.directChatMatrixID)
        .toSet();
    final contactList = directChatsMxid
        .map(
          (mxid) =>
              presences[mxid] ??
              Presence.fromJson(
                {
                  'sender': mxid,
                  'type': 'm.presence',
                  'content': {'presence': 'online'},
                },
              ),
        )
        .toList();
    contactList.addAll(
      presences.values
          .where((p) =>
              !directChatsMxid.contains(p.senderId) &&
              (p.presence?.statusMsg?.isNotEmpty ?? false))
          .toList(),
    );
    contactList.sort((a, b) => (a.presence.lastActiveAgo?.toDouble() ??
            double.infinity)
        .compareTo((b.presence.lastActiveAgo?.toDouble() ?? double.infinity)));
    return contactList;
  }
}
