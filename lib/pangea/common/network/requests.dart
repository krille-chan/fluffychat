import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class Requests {
  late String? accessToken;
  late String? choreoApiKey;

  Requests({
    this.accessToken,
    this.choreoApiKey,
  });

  Future<http.Response> post({
    required String url,
    required Map<dynamic, dynamic> body,
  }) async {
    body[ModelKey.cefrLevel] = MatrixState
        .pangeaController.userController.profile.userSettings.cefrLevel.string;

    dynamic encoded;
    encoded = jsonEncode(body);

    final http.Response response = await http.post(
      Uri.parse(url),
      body: encoded,
      headers: _headers,
    );

    handleError(response, body: body);
    return response;
  }

  Future<http.Response> get({required String url}) async {
    final http.Response response =
        await http.get(Uri.parse(url), headers: _headers);

    handleError(response);
    return response;
  }

  void addBreadcrumb(
    http.Response response, {
    Map<dynamic, dynamic>? body,
  }) {
    debugPrint("Error - code: ${response.statusCode}");
    debugPrint("api: ${response.request?.url}");
    debugPrint("request body: $body");
    Sentry.addBreadcrumb(
      Breadcrumb.http(
        url: response.request?.url ?? Uri(path: "not available"),
        method: response.request?.method ?? "not available",
        statusCode: response.statusCode,
      ),
    );
    Sentry.addBreadcrumb(
      Breadcrumb(data: {"body": body}),
    );
  }

  void handleError(
    http.Response response, {
    Map<dynamic, dynamic>? body,
  }) {
    if (response.statusCode == 401) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseBody['detail'] == 'No active subscription found') {
        throw UnsubscribedException();
      }
    }

    if (response.statusCode >= 400) {
      addBreadcrumb(response, body: body);
      throw response;
    }
  }

  get _headers {
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (accessToken != null) {
      headers["Authorization"] = 'Bearer ${accessToken!}';
    }
    if (choreoApiKey != null) {
      headers['api_key'] = choreoApiKey!;
    }
    return headers;
  }
}

class UnsubscribedException implements Exception {}
