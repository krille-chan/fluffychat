import 'package:matrix/matrix.dart';

extension MembershipUpdate on SyncUpdate {
  List<Event> messages(Room chat) {
    if (rooms?.join == null ||
        !rooms!.join!.containsKey(chat.id) ||
        rooms!.join![chat.id]!.timeline?.events == null) {
      return [];
    }

    return rooms!.join![chat.id]!.timeline!.events!
        .where(
          (event) =>
              event.type == EventTypes.Message &&
              !event.eventId.startsWith("Pangea Chat"),
        )
        .map((event) => Event.fromMatrixEvent(event, chat))
        .toList();
  }
}
