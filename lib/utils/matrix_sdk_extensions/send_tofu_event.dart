import 'package:matrix/matrix.dart';

const String tofuEventType = 'sdk.matrix.dart.tofu_event';

Future<void> sendTofuEvent(Room room, Set<String> userIds) async {
  await room.client.database.transaction(() async {
    await room.client.handleSync(
      SyncUpdate(
        nextBatch: '',
        rooms: RoomsUpdate(
          join: {
            room.id: JoinedRoomUpdate(
              timeline: TimelineUpdate(
                events: [
                  MatrixEvent(
                    eventId:
                        'fake_event_${room.client.generateUniqueTransactionId()}',
                    content: {
                      'body':
                          '${userIds.join(', ')} has/have reset their encryption keys',
                      'users': userIds.toList(),
                    },
                    type: tofuEventType,
                    senderId: room.client.userID!,
                    originServerTs: DateTime.now(),
                  ),
                ],
              ),
            ),
          },
        ),
      ),
    );
  });
}
