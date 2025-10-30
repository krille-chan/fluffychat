import 'dart:convert';

import 'package:http/http.dart' hide Client;
import 'package:matrix/matrix.dart';
import 'package:matrix/matrix_api_lite/generated/api.dart';

extension on Api {
  Future<KnockSpaceResponse> knockSpace(String code) async {
    final requestUri = Uri(
      path: '_synapse/client/pangea/v1/knock_with_code',
    );
    final request = Request('POST', baseUri!.resolveUri(requestUri));
    request.headers['content-type'] = 'application/json';
    request.headers['authorization'] = 'Bearer ${bearerToken!}';
    request.bodyBytes = utf8.encode(
      jsonEncode({
        'access_code': code,
      }),
    );
    final response = await httpClient.send(request);
    if (response.statusCode != 200) {
      if (response.statusCode == 429) {
        return KnockSpaceResponse(
          roomIds: [],
          alreadyJoined: [],
          rateLimited: true,
        );
      }
      throw response;
    }

    final responseBody = await response.stream.toBytes();
    final responseString = utf8.decode(responseBody);
    final json = jsonDecode(responseString);
    return KnockSpaceResponse.fromJson(json);
  }
}

extension KnockSpaceExtension on Client {
  Future<KnockSpaceResponse> knockWithCode(String code) => knockSpace(code);
}

class KnockSpaceResponse {
  final List<String> roomIds;
  final List<String> alreadyJoined;
  final bool rateLimited;

  KnockSpaceResponse({
    required this.roomIds,
    required this.alreadyJoined,
    required this.rateLimited,
  });

  factory KnockSpaceResponse.fromJson(Map<String, dynamic> json) {
    return KnockSpaceResponse(
      roomIds: List<String>.from(json['rooms'] ?? []),
      alreadyJoined: List<String>.from(json['already_joined'] ?? []),
      rateLimited: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rooms': roomIds,
      'already_joined': alreadyJoined,
      'rate_limited': rateLimited,
    };
  }
}
