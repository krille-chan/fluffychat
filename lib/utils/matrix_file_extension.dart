import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

extension MatrixFileExtension on MatrixFile {
  void open() async {
    Directory tempDir = await getTemporaryDirectory();
    final file = File(tempDir.path + "/" + path.split("/").last);
    file.writeAsBytesSync(bytes);
    await OpenFile.open(file.path);
    return;
  }
}
