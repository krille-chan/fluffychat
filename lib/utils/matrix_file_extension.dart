import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:mime_type/mime_type.dart';

extension MatrixFileExtension on MatrixFile {
  void open() async {
    if (kIsWeb) {
      final fileName = name.split('/').last;
      final mimeType = mime(fileName);
      var element = html.document.createElement('a');
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
      var tempDir = await getTemporaryDirectory();
      final file = File(tempDir.path + '/' + name.split('/').last);
      file.writeAsBytesSync(bytes);
      await OpenFile.open(file.path);
    }
    return;
  }
}
