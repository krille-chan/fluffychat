import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/learning_settings/enums/language_level_type_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

class Requests {
  late String? baseUrl;
  // Matrix access token
  late String? accessToken;
  late String? choreoApiKey;
  //Question: How can we make baseUrl optional?
  Requests({
    this.accessToken,
    this.baseUrl = '',
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

    debugPrint(baseUrl! + url);

    final http.Response response = await http.post(
      _uriBuilder(url),
      body: encoded,
      headers: _headers,
    );
    handleError(response, body: body);

    return response;
  }

  Future<http.Response> put({
    required String url,
    required Map<dynamic, dynamic> body,
  }) async {
    body[ModelKey.cefrLevel] = MatrixState
        .pangeaController.userController.profile.userSettings.cefrLevel.string;

    dynamic encoded;
    encoded = jsonEncode(body);

    debugPrint(baseUrl! + url);

    final http.Response response = await http.put(
      _uriBuilder(url),
      body: encoded,
      headers: _headers,
    );

    handleError(response, body: body);

    return response;
  }

  Future<http.Response> get({required String url, String objectId = ""}) async {
    final http.Response response =
        await http.get(_uriBuilder(url + objectId), headers: _headers);

    handleError(response, objectId: objectId);

    return response;
  }

  Uri _uriBuilder(url) =>
      baseUrl != null ? Uri.parse(baseUrl! + url) : Uri.parse(url);

  void handleError(
    http.Response response, {
    Map<dynamic, dynamic>? body,
    String? objectId,
  }) {
    //PTODO - handle 401 error - unauthorized call
    //kick them back to login?

    addBreadcrumb() {
      debugPrint("Error - code: ${response.statusCode}");
      debugPrint("api: ${response.request?.url}");
      debugPrint("request body: ${body ?? objectId}");
      Sentry.addBreadcrumb(
        Breadcrumb.http(
          url: response.request?.url ?? Uri(path: "not available"),
          method: response.request?.method ?? "not available",
          statusCode: response.statusCode,
        ),
      );
      Sentry.addBreadcrumb(
        Breadcrumb(data: {"body": body, "objectId": objectId}),
      );
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        break;
      case 502:
      case 504:
        addBreadcrumb();
        throw response;
      default:
        addBreadcrumb();
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
      //headers["Matrix-Access-Token"] = accessToken!;
    }
    if (choreoApiKey != null) {
      headers['api_key'] = choreoApiKey!;
    }
    return headers;
  }
}
