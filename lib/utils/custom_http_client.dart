// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';
import 'dart:io';

import 'package:fluffychat/config/isrg_x1.dart';
import 'package:fluffychat/config/isrg_x2.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http/retry.dart' as retry;

/// Custom HTTP client that adds the ISRG Root certificates used by Let's
/// Encrypt. Older Android versions may not include these roots in their
/// trust store, so we ship them ourselves to ensure TLS connections to
/// Let's Encrypt–signed servers continue to work.
class CustomHttpClient {
  static HttpClient customHttpClient() {
    final context = SecurityContext.defaultContext;

    try {
      context.setTrustedCertificatesBytes(utf8.encode(ISRG_X1));
      context.setTrustedCertificatesBytes(utf8.encode(ISRG_X2));
    } on TlsException catch (e) {
      if (e.osError != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
      } else {
        rethrow;
      }
    }

    return HttpClient(context: context);
  }

  static http.Client createHTTPClient() => retry.RetryClient(
    PlatformInfos.isAndroid ? IOClient(customHttpClient()) : http.Client(),
  );
}
