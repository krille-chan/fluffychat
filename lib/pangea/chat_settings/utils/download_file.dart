import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_html/html.dart' as webfile;

import 'package:fluffychat/pangea/chat_settings/utils/download_chat.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';

enum DownloadType { txt, csv, xlsx }

Future<void> downloadFile(
  dynamic contents,
  String filename,
  DownloadType fileType,
) async {
  if (kIsWeb) {
    final blob = webfile.Blob([contents], mimetype(fileType), 'native');
    webfile.AnchorElement(
      href: webfile.Url.createObjectUrlFromBlob(blob).toString(),
    )
      ..setAttribute("download", filename)
      ..click();
    return;
  }
  if (await Permission.storage.request().isGranted) {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, s) {
      debugPrint("Failed to get download folder path");
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {},
      );
    }
    if (directory != null) {
      final File f = File("${directory.path}/$filename");
      File resp;
      if (fileType == DownloadType.txt || fileType == DownloadType.csv) {
        resp = await f.writeAsString(contents);
      } else {
        resp = await f.writeAsBytes(contents);
      }
      OpenFile.open(resp.path);
    }
  }
}
