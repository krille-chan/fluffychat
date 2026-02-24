import 'package:matrix/matrix.dart';

/// Tracks room IDs the user has knocked on so the client can auto-accept
/// invites for previously knocked rooms.
///
/// Stored in Matrix account data under [_accountDataKey] so the state
/// survives reinstall, logout, and syncs across devices.
class KnockTracker {
  static const String _accountDataKey = 'org.pangea.knocked_rooms';
  static const String _roomIdsField = 'room_ids';

  static Future<void> recordKnock(Client client, String roomId) async {
    final ids = _getKnockedRoomIds(client);
    if (!ids.contains(roomId)) {
      ids.add(roomId);
      await _writeIds(client, ids);
    }
  }

  static bool hasKnocked(Client client, String roomId) {
    return _getKnockedRoomIds(client).contains(roomId);
  }

  static Future<void> clearKnock(Client client, String roomId) async {
    final ids = _getKnockedRoomIds(client);
    if (ids.remove(roomId)) {
      await _writeIds(client, ids);
    }
  }

  static List<String> _getKnockedRoomIds(Client client) {
    final data = client.accountData[_accountDataKey];
    final list = data?.content[_roomIdsField];
    if (list is List) {
      return list.cast<String>().toList();
    }
    return [];
  }

  static Future<void> _writeIds(Client client, List<String> ids) async {
    await client.setAccountData(client.userID!, _accountDataKey, {
      _roomIdsField: ids,
    });
  }
}
