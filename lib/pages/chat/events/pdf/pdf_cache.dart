// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class PdfCache {
  // Files above this limit fall back to external-app download.
  static const int maxFileSizeForInlinePreview = 50 * 1024 * 1024; // 50 MB

  static Directory? _dir;

  static Future<File> cacheFile(String eventId) async {
    _dir = await _validatedDir();
    return File('${_dir!.path}/$eventId.pdf');
  }

  // First-page JPEG thumbnail, generated once and reused across sessions.
  static Future<File> thumbnailFile(String eventId) async {
    _dir = await _validatedDir();
    return File('${_dir!.path}/${eventId}_thumb.jpg');
  }

  // Re-creates the cache directory if the OS has purged it (e.g. iOS memory
  // pressure). Checking existsSync() on every call is cheap and prevents
  // writeAsBytes() failures against a stale cached path.
  static Future<Directory> _validatedDir() async {
    final current = _dir;
    if (current != null && current.existsSync()) return current;
    return _createDir();
  }

  static Future<Directory> _createDir() async {
    final tmp = await getTemporaryDirectory();
    final dir = Directory('${tmp.path}/fluffychat/pdf');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }
}
