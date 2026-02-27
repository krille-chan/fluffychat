import 'package:collection/collection.dart';

class KnockedRoomsModel {
  final List<String> knockedRoomIds;
  final List<String> acceptedInviteRoomIds;

  const KnockedRoomsModel({
    this.knockedRoomIds = const [],
    this.acceptedInviteRoomIds = const [],
  });

  static const String _roomIdsField = 'room_ids';
  static const String _acceptedInviteRoomIdsField = 'accepted_invite_room_ids';

  bool hasEverKnocked(String roomId) {
    return knockedRoomIds.contains(roomId) ||
        acceptedInviteRoomIds.contains(roomId);
  }

  Map<String, dynamic> toJson() {
    return {
      _roomIdsField: knockedRoomIds,
      _acceptedInviteRoomIdsField: acceptedInviteRoomIds,
    };
  }

  factory KnockedRoomsModel.fromJson(Map<String, dynamic> json) {
    final knockedIds = json[_roomIdsField];
    final acceptedInviteIds = json[_acceptedInviteRoomIdsField];
    return KnockedRoomsModel(
      knockedRoomIds: knockedIds is List
          ? List<String>.from(knockedIds)
          : <String>[],
      acceptedInviteRoomIds: acceptedInviteIds is List
          ? List<String>.from(acceptedInviteIds)
          : <String>[],
    );
  }

  KnockedRoomsModel copyWithKnockedRoom(String roomId) {
    final newKnockedRoomIds = List<String>.from(knockedRoomIds);
    if (!newKnockedRoomIds.contains(roomId)) {
      newKnockedRoomIds.add(roomId);
    }

    final newAcceptedInviteRoomIds = List<String>.from(acceptedInviteRoomIds)
      ..remove(roomId);
    return KnockedRoomsModel(
      knockedRoomIds: newKnockedRoomIds,
      acceptedInviteRoomIds: newAcceptedInviteRoomIds,
    );
  }

  KnockedRoomsModel copyWithAcceptedInviteRoom(String roomId) {
    final newAcceptedInviteRoomIds = List<String>.from(acceptedInviteRoomIds);
    if (!newAcceptedInviteRoomIds.contains(roomId)) {
      newAcceptedInviteRoomIds.add(roomId);
    }

    final newKnockedRoomIds = List<String>.from(knockedRoomIds)..remove(roomId);
    return KnockedRoomsModel(
      knockedRoomIds: newKnockedRoomIds,
      acceptedInviteRoomIds: newAcceptedInviteRoomIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KnockedRoomsModel &&
        ListEquality().equals(other.knockedRoomIds, knockedRoomIds) &&
        ListEquality().equals(
          other.acceptedInviteRoomIds,
          acceptedInviteRoomIds,
        );
  }

  @override
  int get hashCode => Object.hash(
    ListEquality().hash(knockedRoomIds),
    ListEquality().hash(acceptedInviteRoomIds),
  );
}
