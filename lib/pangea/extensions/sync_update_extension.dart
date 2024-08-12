import 'package:fluffychat/pangea/utils/bot_name.dart';
import 'package:matrix/matrix.dart';

extension MembershipUpdate on SyncUpdate {
  List<String> botMessages(String roomID) {
    if (rooms?.join == null ||
        !rooms!.join!.containsKey(roomID) ||
        rooms!.join![roomID]!.timeline?.events == null) {
      return [];
    }

    final messageEvents = rooms!.join![roomID]!.timeline!.events!
        .where(
          (event) => event.type == EventTypes.Message,
        )
        .toList();
    if (messageEvents.isEmpty) {
      return [];
    }

    return messageEvents
        .where((event) => event.senderId == BotName.byEnvironment)
        .map((event) => event.eventId)
        .toList();
  }
}
