import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:matrix/matrix.dart';

Future<List<Room>> getChildRooms(Room space, Client client) async {
  final List<Room> children = [];
  for (final child in space.spaceChildren) {
    if (child.roomId == null) continue;
    final Room? room = client.getRoomById(child.roomId!);
    if (room != null) {
      children.add(room);
    }
  }
  return children;
}

Future<void> archiveSpace(Room? space, Client client) async {
  if (space == null) {
    ErrorHandler.logError(
      e: 'Tried to archive a space that is null. This should not happen.',
      s: StackTrace.current,
    );
    return;
  }

  final List<Room> children = await getChildRooms(space, client);
  for (final Room child in children) {
    await child.leave();
  }
  await space.leave();
}
