import 'dart:io';

import 'package:matrix/matrix.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:share/share.dart';

extension MatrixFileExtension on MatrixFile {
  void save(BuildContext context) async {
    final fileName = name.split('/').last;
    if (PlatformInfos.isIOS) {
      final tmpDirectory = await getTemporaryDirectory();
      final path = '${tmpDirectory.path}$fileName';
      await File(path).writeAsBytes(bytes);
      await Share.shareFiles([path]);
      return;
    }
    if (PlatformInfos.isAndroid) {
      if (!(await Permission.storage.request()).isGranted) return;
      final path = await FilesystemPicker.open(
        title: L10n.of(context).saveFile,
        context: context,
        rootDirectory: Directory('/sdcard/'),
        fsType: FilesystemType.folder,
        pickText: L10n.of(context).saveFileToFolder,
        folderIconColor: Theme.of(context).primaryColor,
        requestPermission: () async =>
            await Permission.storage.request().isGranted,
      );
      if (path != null) {
        // determine a unique filename
        // somefile-number.extension, e.g. helloworld-1.txt
        var file = File('$path/$fileName');
        var i = 0;
        var extension = '';
        if (fileName.contains('.')) {
          extension = fileName.substring(fileName.lastIndexOf('.'));
        }
        final fileNameWithoutExtension =
            fileName.substring(0, fileName.lastIndexOf('.'));
        while (await file.exists()) {
          i++;
          file = File('$path/$fileNameWithoutExtension-$i$extension');
        }
        await file.writeAsBytes(bytes);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(L10n.of(context).savedFileAs(file.path.split('/').last))));
      }
    } else {
      final file = FilePickerCross(bytes);
      await file.exportToStorage(fileName: fileName);
    }
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
