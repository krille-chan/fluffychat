import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:mime_type/mime_type.dart';
import 'package:permission_handler/permission_handler.dart';

extension MatrixFileExtension on MatrixFile {
  void open() async {
    if (kIsWeb) {
      final fileName = name.split('/').last;
      final mimeType = mime(fileName);
      final element = html.document.createElement('a');
      element.setAttribute(
          'href', html.Url.createObjectUrlFromBlob(html.Blob([bytes])));
      element.setAttribute('target', '_blank');
      element.setAttribute('rel', 'noopener');
      element.setAttribute('download', fileName);
      element.setAttribute('type', mimeType);
      element.style.display = 'none';
      html.document.body.append(element);
      element.click();
      element.remove();
    } else {
      if (PlatformInfos.isMobile &&
          !(await Permission.storage.request()).isGranted) return;
      final downloadsDir = PlatformInfos.isDesktop
          ? (await getDownloadsDirectory()).path
          : Platform.isAndroid
              ? (await AndroidPathProvider.downloadsPath)
              : (await getApplicationDocumentsDirectory()).path;

      final file = File(downloadsDir + '/' + name.split('/').last);
      file.writeAsBytesSync(bytes);
      await OpenFile.open(file.path);
    }
    return;
  }

  MatrixFile get detectFileType {
    if (msgType == MessageTypes.Image) {
      return MatrixImageFile(bytes: bytes, name: name);
    }
    if (msgType == MessageTypes.Video) {
      return MatrixVideoFile(bytes: bytes, name: name);
    }
    if (msgType == MessageTypes.Audio) {
      return MatrixAudioFile(bytes: bytes, name: name);
    }
    return this;
  }

  String get sizeString {
    var size = this.size.toDouble();
    if (size < 1000000) {
      size = size / 1000;
      size = (size * 10).round() / 10;
      return '${size.toString()} KB';
    } else if (size < 1000000000) {
      size = size / 1000000;
      size = (size * 10).round() / 10;
      return '${size.toString()} MB';
    } else {
      size = size / 1000000000;
      size = (size * 10).round() / 10;
      return '${size.toString()} GB';
    }
  }
}
