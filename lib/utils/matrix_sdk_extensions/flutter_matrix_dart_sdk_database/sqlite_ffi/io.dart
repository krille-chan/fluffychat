import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:sqlite3/open.dart';

/// overrides the sqlite shared object / dynamic library with the SQLCipher one
///
/// https://github.com/tekartik/sqflite/blob/master/sqflite_common_ffi/doc/encryption_support.md
void ffiInit() {
  open.overrideFor(OperatingSystem.linux, sqlcipherOpen);
}

DynamicLibrary sqlcipherOpen() {
  // Taken from https://github.com/simolus3/sqlite3.dart/blob/e66702c5bec7faec2bf71d374c008d5273ef2b3b/sqlite3/lib/src/load_library.dart#L24
  // keeping Android here in case we should ever use FFI for Android too
  if (Platform.isLinux || Platform.isAndroid) {
    try {
      return DynamicLibrary.open('libsqlcipher.so');
    } catch (_) {
      if (Platform.isAndroid) {
        // On some (especially old) Android devices, we somehow can't dlopen
        // libraries shipped with the apk. We need to find the full path of the
        // library (/data/data/<id>/lib/libsqlite3.so) and open that one.
        // For details, see https://github.com/simolus3/moor/issues/420
        final appIdAsBytes = File('/proc/self/cmdline').readAsBytesSync();

        // app id ends with the first \0 character in here.
        final endOfAppId = max(appIdAsBytes.indexOf(0), 0);
        final appId = String.fromCharCodes(appIdAsBytes.sublist(0, endOfAppId));

        return DynamicLibrary.open('/data/data/$appId/lib/libsqlcipher.so');
      }

      rethrow;
    }
  }
  if (Platform.isIOS) {
    return DynamicLibrary.process();
  }
  if (Platform.isMacOS) {
    return DynamicLibrary.open('/usr/lib/libsqlite3.dylib');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('sqlite3.dll');
  }

  throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
}
