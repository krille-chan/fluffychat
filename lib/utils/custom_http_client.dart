// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';
import 'dart:io';

import 'package:fluffychat/config/isrg_x1.dart';
import 'package:fluffychat/config/isrg_x2.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter_user_certificates_android/flutter_user_certificates_android.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http/retry.dart' as retry;

/// Custom HTTP client that adds the ISRG Root certificates used by Let's
/// Encrypt. Older Android versions may not include these roots in their
/// trust store, so we ship them ourselves to ensure TLS connections to
/// Let's Encrypt–signed servers continue to work.
///
/// On Android, user-installed CA certificates are also added, since apps
/// targeting API 24+ do not trust them by default.
class CustomHttpClient {
  static String derToPem(List<int> der) =>
      '-----BEGIN CERTIFICATE-----\n${base64Encode(der)}\n-----END CERTIFICATE-----';

  static Future<SecurityContext> buildSecurityContext() async {
    final context = SecurityContext(withTrustedRoots: true);
    _addTrustedCertificates(context, [ISRG_X1, ISRG_X2]);

    if (PlatformInfos.isAndroid) {
      final userCerts =
          await FlutterUserCertificatesAndroid().getUserCertificates();

      if (userCerts != null && userCerts.isNotEmpty) {
        final pem = userCerts.values.map(derToPem).join('\n');
        _addTrustedCertificates(context, [pem]);
      }
    }

    return context;
  }

  static void _addTrustedCertificates(
    SecurityContext context,
    Iterable<String> certificates,
  ) {
    for (final certificate in certificates) {
      try {
        context.setTrustedCertificatesBytes(utf8.encode(certificate));
      } on TlsException catch (e) {
        if (e.osError != null &&
            e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
          // The certificate is already present; nothing to do.
        } else {
          rethrow;
        }
      }
    }
  }

  static Future<HttpClient> customHttpClient() async =>
      HttpClient(context: await buildSecurityContext());

  static Future<http.Client> createHTTPClient() async => retry.RetryClient(
    PlatformInfos.isAndroid ? IOClient(await customHttpClient()) : http.Client(),
  );
}
