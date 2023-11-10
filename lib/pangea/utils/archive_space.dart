import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:matrix/matrix.dart';

Future<void> archiveSpace(Room? space, Client client) async {
  if (space == null) {
    ErrorHandler.logError(
      e: 'Tried to archive a space that is null. This should not happen.',
      s: StackTrace.current,
    );
    return;
  }

  final List<Room> children = await space.getChildRooms();
  for (final Room child in children) {
    await child.leave();
  }
  await space.leave();
}
