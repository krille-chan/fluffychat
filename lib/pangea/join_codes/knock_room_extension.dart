import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/join_codes/knock_tracker.dart';

extension KnockRoomExtension on Room {
  bool get hasKnocked => KnockTracker.hasKnocked(client, id);

  Future<void> joinKnockedRoom() async {
    await join();
    await KnockTracker.clearKnock(client, id);
  }
}

extension KnockClientExtension on Client {
  Future<String> knockAndRecordRoom(
    String roomIdOrAlias, {
    List<String>? via,
    String? reason,
  }) async {
    final resp = await knockRoom(roomIdOrAlias, via: via, reason: reason);
    await KnockTracker.recordKnock(this, roomIdOrAlias);
    return resp;
  }
}
