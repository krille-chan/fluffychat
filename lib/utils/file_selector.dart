import 'package:flutter/widgets.dart';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/app_lock.dart';

Future<List<XFile>> selectFiles(
  BuildContext context, {
  String? title,
  List<String>? extensions,
  bool allowMultiple = false,
}) async {
  if (!PlatformInfos.isLinux) {
    final result = await AppLock.of(context).pauseWhile(
      FilePicker.platform.pickFiles(
        compressionQuality: 0,
        allowMultiple: allowMultiple,
        allowedExtensions: extensions,
      ),
    );
    return result?.xFiles ?? [];
  }

  if (allowMultiple) {
    return await AppLock.of(context).pauseWhile(
      openFiles(
        confirmButtonText: title,
        acceptedTypeGroups: [
          if (extensions != null) XTypeGroup(extensions: extensions),
        ],
      ),
    );
  }
  final file = await AppLock.of(context).pauseWhile(
    openFile(
      confirmButtonText: title,
      acceptedTypeGroups: [
        if (extensions != null) XTypeGroup(extensions: extensions),
      ],
    ),
  );
  if (file == null) return [];
  return [file];
}

const imageExtensions = [
  'png',
  'PNG',
  'jpg',
  'JPG',
  'jpeg',
  'JPEG',
  'webp',
  'WebP',
];
