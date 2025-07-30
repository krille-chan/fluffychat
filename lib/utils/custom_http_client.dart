import 'dart:convert';
import 'dart:io';

import 'package:cronet_http/cronet_http.dart' as cronet;
import 'package:cupertino_http/cupertino_http.dart' as cupertino_http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http/retry.dart' as retry;

import 'package:fluffychat/config/isrg_x1.dart';
import 'package:fluffychat/utils/platform_infos.dart';

/// Custom Client to add an additional certificate. This is for the isrg X1
/// certificate which is needed for LetsEncrypt certificates. It is shipped
/// on Android since OS version 7.1. As long as we support older versions we
/// still have to ship this certificate by ourself.
class CustomHttpClient {
  static HttpClient customHttpClient(String? cert) {
    final context = SecurityContext.defaultContext;

    try {
      if (cert != null) {
        final bytes = utf8.encode(cert);
        context.setTrustedCertificatesBytes(bytes);
      }
    } on TlsException catch (e) {
      if (e.osError != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
      } else {
        rethrow;
      }
    }

    return HttpClient(context: context);
  }

  static Future<http.Client> createHTTPClient() async {
    if (PlatformInfos.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      if (info.version.sdkInt <= 24) {
        return retry.RetryClient(IOClient(customHttpClient(ISRG_X1)));
      }
      return retry.RetryClient(cronet.CronetClient.defaultCronetEngine());
    }
    if (PlatformInfos.isIOS || PlatformInfos.isMacOS) {
      return retry.RetryClient(
        cupertino_http.CupertinoClient.defaultSessionConfiguration(),
      );
    }

    return retry.RetryClient(http.Client());
  }
}
