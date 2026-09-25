// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/size_string.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

extension MatrixFileExtension on MatrixFile {
  Future<void> copyImageToClipboard(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = L10n.of(context);

    if (PlatformInfos.isDesktop) {
      // Pasteboard.writeImage is unsupported on desktop
      final tempDir = await getTemporaryDirectory();
      final path = path_lib.join(tempDir.path, name);
      final file = File(path);
      await file.writeAsBytes(bytes);

      await Pasteboard.writeFiles([path]);
    } else {
      await Pasteboard.writeImage(bytes);
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(l10n.copiedToClipboard), showCloseIcon: true),
    );
  }

  Future<void> save(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = L10n.of(context);
    final downloadPath = await FilePicker.saveFile(
      dialogTitle: l10n.saveFile,
      fileName: name,
      type: filePickerFileType,
      bytes: bytes,
    );
    if (downloadPath == null) return;

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(l10n.fileHasBeenSavedAt(downloadPath.toString())),
        showCloseIcon: true,
      ),
    );
  }

  FileType get filePickerFileType {
    if (this is MatrixImageFile) return FileType.image;
    if (this is MatrixAudioFile) return FileType.audio;
    if (this is MatrixVideoFile) return FileType.video;
    return FileType.any;
  }

  Future<void> share(BuildContext context) async {
    // Workaround for iPad from
    // https://github.com/fluttercommunity/plus_plugins/tree/main/packages/share_plus/share_plus#ipad
    final box = context.findRenderObject() as RenderBox?;

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile.fromData(bytes, name: name, mimeType: mimeType)],
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
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

  String get sizeString => size.sizeString;
}
