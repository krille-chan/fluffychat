import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

extension MatrixIdentityExtension on Client {
  Future<MatrixIdentityApi> getIdentityApi() async {
    final wellKnown = await getWellknown();
    final identityServerInformation = wellKnown.mIdentityServer;
    if (identityServerInformation == null) {
      throw Exception(
        'Well-Known does not include identity server information',
      );
    }

    final openIdCredentials = await requestOpenIdToken(userID!, {});

    final registrationResult = await request(
      RequestType.POST,
      '/_matrix/identity/v2/account/register',
      data: openIdCredentials.toJson(),
    );
    final accessToken = registrationResult['token'] as String;

    return MatrixIdentityApi(
      accessToken: accessToken,
      httpClient: httpClient,
      homeserver: homeserver!,
    );
  }

  static const String threePidAccountDataType = 'chat.fluffy.three_pid';
}

class MatrixIdentityApi {
  final String accessToken;
  final http.Client httpClient;
  final Uri homeserver;

  MatrixIdentityApi({
    required this.accessToken,
    required this.httpClient,
    required this.homeserver,
  });

  Future<Map<String, Object>> request(
    RequestType type,
    String path, {
    Map<String, Object?>? body,
    Map<String, Object?>? queryParameters,
  }) async {
    final request = http.Request(
      type.name,
      homeserver.resolveUri(Uri(path: path, queryParameters: queryParameters)),
    );
    request.headers['authorization'] = 'Bearer $accessToken';
    request.headers['content-type'] = 'application/json';
    request.bodyBytes = utf8.encode(jsonEncode(body));
    final response = await httpClient.send(request);
    final responseBody = await response.stream.toBytes();
    if (response.statusCode >= 300) throw response;
    return jsonDecode(utf8.decode(responseBody));
  }

  Future<Policies> getTerms() => request(
    RequestType.GET,
    '_matrix/identity/v2/terms',
  ).then(Policies.fromJson);

  Future<void> acceptTerms(List<Uri> accepted) => request(
    RequestType.POST,
    '_matrix/identity/v2/terms',
    body: {'user_accepts': accepted.map((uri) => uri.toString()).toList()},
  );

  Future<HashDetails> getHashDetails() => request(
    RequestType.GET,
    '/_matrix/identity/v2/hash_details',
  ).then(HashDetails.fromJson);

  Future<LookUpResult> lookUp(
    List<String> addresses,
    String algorithm,
    String pepper,
  ) => request(
    .POST,
    '/_matrix/identity/v2/lookup',
    body: {'addresses': addresses, 'algorithm': algorithm, 'pepper': pepper},
  ).then(LookUpResult.fromJson);

  Future<RequestTokenResult> requestMsisdnToken(
    String clientSecret,
    String country,
    String phoneNumber,
    int sendAttempt, {
    Uri? nextLink,
  }) => request(
    .POST,
    '/_matrix/identity/v2/validate/msisdn/requestToken',
    body: {
      "client_secret": clientSecret,
      "country": country,
      if (nextLink != null) "next_link": nextLink.toString(),
      "phone_number": phoneNumber,
      "send_attempt": sendAttempt,
    },
  ).then(RequestTokenResult.fromJson);

  Future<SuccessResult> submitMsIsdnToken() => request(
    .POST,
    '/_matrix/identity/v2/validate/msisdn/submitToken',
    body: {},
  ).then(SuccessResult.fromJson);

  Future<Bind3PidResult> bind3Pid(
    String clientSecret,
    String mxid,
    String sid,
  ) => request(
    .POST,
    '/_matrix/identity/v2/3pid/bind',
    body: {"client_secret": clientSecret, "mxid": mxid, "sid": sid},
  ).then(Bind3PidResult.fromJson);

  Future<Validated3Pid> getValidated3Pid(String clientSecret, String sid) =>
      request(
        .GET,
        '/_matrix/identity/v2/3pid/getValidated3pid',
        queryParameters: {'client_secret': clientSecret, 'sid': sid},
      ).then(Validated3Pid.fromJson);

  Future<void> unbind3Pid(
    String mxId,
    ThreePid threepid, {
    String? sid,
    String? clientSecret,
  }) => request(
    .POST,
    '/_matrix/identity/v2/3pid/unbind',
    body: {
      if (clientSecret != null) 'client_secret': clientSecret,
      if (sid != null) 'sid': sid,
      'mxid': mxId,
      'threepid': threepid.toJson(),
    },
  );

  Future<void> logout() =>
      request(.POST, '/_matrix/identity/v2/account/logout');
}

class ThreePid {
  final String address, medium;

  ThreePid({required this.address, required this.medium});

  factory ThreePid.fromJson(Map<String, Object?> json) => ThreePid(
    address: json['address'] as String,
    medium: json['medium'] as String,
  );
  Map<String, Object?> toJson() => {'address': address, 'medium': medium};
}

class Validated3Pid {
  final String address, medium;
  final DateTime validatedAt;

  Validated3Pid({
    required this.address,
    required this.medium,
    required this.validatedAt,
  });

  factory Validated3Pid.fromJson(Map<String, Object?> json) => Validated3Pid(
    address: json['address'] as String,
    medium: json['medium'] as String,
    validatedAt: DateTime.fromMillisecondsSinceEpoch(
      json['validated_at'] as int,
    ),
  );
}

class Bind3PidResult {
  final String address, medium, mxid;
  final int notAfter, notBefore;
  final DateTime ts;
  final Map<String, Map<String, String>> signatures;

  Bind3PidResult({
    required this.address,
    required this.medium,
    required this.mxid,
    required this.notAfter,
    required this.notBefore,
    required this.ts,
    required this.signatures,
  });
  factory Bind3PidResult.fromJson(Map<String, Object> json) => Bind3PidResult(
    address: json['address'] as String,
    medium: json['medium'] as String,
    mxid: json['mxid'] as String,
    notAfter: json['not_after'] as int,
    notBefore: json['not_before'] as int,
    ts: DateTime.fromMillisecondsSinceEpoch(json['ts'] as int),
    signatures: Map<String, Map<String, String>>.from(
      json['signatures'] as Map<String, Object>,
    ),
  );
}

class SuccessResult {
  final bool success;

  SuccessResult({required this.success});
  factory SuccessResult.fromJson(Map<String, Object> json) =>
      SuccessResult(success: json['success'] as bool);
}

class RequestTokenResult {
  final String sid;

  RequestTokenResult({required this.sid});
  factory RequestTokenResult.fromJson(Map<String, Object> json) =>
      RequestTokenResult(sid: json['sid'] as String);
}

class LookUpResult {
  final Map<String, String> mappings;

  LookUpResult(this.mappings);

  factory LookUpResult.fromJson(Map<String, Object> json) =>
      LookUpResult(json.tryGetMap<String, String>('mapping')!);
}

class HashDetails {
  final List<String> algorithms;
  final String lookupPepper;

  HashDetails({required this.algorithms, required this.lookupPepper});

  factory HashDetails.fromJson(Map<String, Object> json) => HashDetails(
    algorithms: json.tryGetList<String>('algorithms')!,
    lookupPepper: json['lookup_peppers'] as String,
  );
}

class Policies {
  final Map<String, Map<String, Terms>> policies;

  Policies(this.policies);

  factory Policies.fromJson(Map<String, Object> json) => Policies(
    json.map(
      (key, value) => MapEntry(
        key,
        (value as Map<String, Object>).map(
          (key, value) =>
              MapEntry(key, Terms.fromJson(value as Map<String, Object>)),
        ),
      ),
    ),
  );
}

class Terms {
  final String name;
  final Uri url;

  Terms({required this.name, required this.url});

  factory Terms.fromJson(Map<String, Object> json) => Terms(
    name: json['name'] as String,
    url: Uri.parse(json['url'] as String),
  );
}
