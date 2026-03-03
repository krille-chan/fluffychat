import 'package:matrix/matrix.dart';

extension RoomMemberChangeExtension on RoomMemberChangeType {
  bool get isVisibleLastEvent {
    switch (this) {
      case RoomMemberChangeType.join:
      case RoomMemberChangeType.acceptInvite:
      case RoomMemberChangeType.rejectInvite:
      case RoomMemberChangeType.withdrawInvitation:
      case RoomMemberChangeType.leave:
      case RoomMemberChangeType.kick:
      case RoomMemberChangeType.invite:
      case RoomMemberChangeType.ban:
      case RoomMemberChangeType.unban:
      case RoomMemberChangeType.knock:
        return true;
      default:
        return false;
    }
  }
}
