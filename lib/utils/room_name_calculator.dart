import 'package:famedlysdk/famedlysdk.dart';

class RoomNameCalculator {
  final Room room;

  const RoomNameCalculator(this.room);

  String get name {
    if (room.name.isEmpty &&
        room.canonicalAlias.isEmpty &&
        !room.isDirectChat) {
      return "Group with ${room.displayname}";
    }
    return room.displayname;
  }
}
