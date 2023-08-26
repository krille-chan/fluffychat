import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

abstract class DesktopDropDownloader {
  const DesktopDropDownloader._();

  static Future<String?> unsupportedUriCallback(String url) async {
    if (kIsWeb) return null;
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (!['http', 'https'].contains(uri.scheme)) return null;

    Response response;

    try {
      response = await get(uri);
    } catch (_) {
      return null;
    }

    Directory tmp;

    // that's likely failing on many distros but future proof for upcoming
    // implementations
    try {
      tmp = await getTemporaryDirectory();
    } catch (_) {
      tmp =
          await getDownloadsDirectory() ?? await getApplicationCacheDirectory();
    }

    try {
      await tmp.create(recursive: true);
      final file =
          File('${tmp.path}/desktop_drop_example/${uri.path.split('/').last}');
      await file.create(recursive: true);
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (_) {
      return null;
    }
  }
}
