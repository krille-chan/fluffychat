import 'dart:convert';

import 'package:matrix/matrix.dart';

class SpaceCodeUtil {
  static Future<String> generateSpaceCode(Client client) async {
    final response = await client.httpClient.get(
      Uri.parse(
        '${client.homeserver}/_synapse/client/pangea/v1/request_room_code',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${client.accessToken}',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to generate room code: $response');
    }
    final roomCodeResult = jsonDecode(response.body);
    if (roomCodeResult['access_code'] is String) {
      return roomCodeResult['access_code'] as String;
    } else {
      throw Exception('Invalid response, access_code not found $response');
    }
  }
}
