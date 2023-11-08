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

  final List<String?> children =
      space.spaceChildren.map((e) => e.roomId).where((e) => e != null).toList();
  for (final String? child in children) {
    final Room? room = client.getRoomById(child!);
    if (room == null) continue;
    await room.leave();
  }
  await space.leave();
}
