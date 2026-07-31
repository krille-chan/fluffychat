// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:http/http.dart' as http;
import 'package:http/retry.dart' as retry;

import 'custom_http_client_stub.dart'
    if (dart.library.io) 'custom_http_client_native.dart';

/// Creates the HTTP client used by the Matrix SDK.
///
/// On Android this uses Cronet via [createPlatformHttpClient]; elsewhere the
/// default [http.Client] is used. Cronet is loaded only on `dart:io` platforms
/// so the web build does not pull in the JNI-based `cronet_http` package.
class CustomHttpClient {
  static http.Client createHTTPClient() =>
      retry.RetryClient(createPlatformHttpClient());
}
