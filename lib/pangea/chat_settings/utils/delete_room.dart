import 'dart:convert';

import 'package:http/http.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix/matrix_api_lite/generated/api.dart';

import 'package:fluffychat/pangea/chat_settings/constants/pangea_room_types.dart';

extension on Api {
  // Send a POST request to /_synapse/client/pangea/v1/delete_room with JSON body {room_id: string}.
  // Response 200 OK format: { message: "Deleted" }.
  // Requester must be member of the room and have the highest power level of the room to perform this request.
  Future<void> delete(String roomId) async {
    final requestUri = Uri(
      path: '_synapse/client/pangea/v1/delete_room',
    );
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['authorization'] = 'Bearer ${bearerToken!}';
    request.bodyBytes = utf8.encode(
      jsonEncode({
        'room_id': roomId,
      }),
    );
    final response = await httpClient.send(request);
    if (response.statusCode != 200) {
      throw Exception('http error response');
    }
  }
}

extension DeleteRoom on Room {
  Future<void> delete() async {
    await client.delete(id);
  }

  Future<List<SpaceRoomsChunk>> getSpaceChildrenToDelete() async {
    final List<SpaceRoomsChunk> rooms = [];
    String? nextBatch;
    int calls = 0;

    while ((nextBatch != null || calls == 0) && calls < 10) {
      final resp = await client.getSpaceHierarchy(
        id,
        from: nextBatch,
        limit: 100,
      );
      rooms.addAll(resp.rooms);
      nextBatch = resp.nextBatch;
      calls++;
    }

    return rooms
        .where(
          (r) => r.roomType != PangeaRoomTypes.analytics && r.roomId != id,
        )
        .toList();
  }
}
