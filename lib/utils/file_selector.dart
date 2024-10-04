import 'package:flutter/widgets.dart';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/app_lock.dart';

Future<List<XFile>> selectFiles(
  BuildContext context, {
  String? title,
  FileSelectorType type = FileSelectorType.any,
  bool allowMultiple = false,
}) async {
  if (!PlatformInfos.isLinux) {
    final result = await AppLock.of(context).pauseWhile(
      FilePicker.platform.pickFiles(
        compressionQuality: 0,
        allowMultiple: allowMultiple,
        type: type.filePickerType,
        allowedExtensions: type.extensions?.toList(),
      ),
    );
    return result?.xFiles ?? [];
  }

  if (allowMultiple) {
    return await AppLock.of(context).pauseWhile(
      openFiles(
        confirmButtonText: title,
        acceptedTypeGroups: [
          if (type != FileSelectorType.any)
            XTypeGroup(extensions: type.extensions?.toList()),
        ],
      ),
    );
  }
  final file = await AppLock.of(context).pauseWhile(
    openFile(
      confirmButtonText: title,
      acceptedTypeGroups: [
        if (type != FileSelectorType.any)
          XTypeGroup(extensions: type.extensions?.toList()),
      ],
    ),
  );
  if (file == null) return [];
  return [file];
}

enum FileSelectorType {
  any(null, FileType.any),
  images(
    {'png', 'PNG', 'jpg', 'JPG', 'jpeg', 'JPEG', 'webp', 'WebP'},
    FileType.image,
  ),
  zip({'zip', 'ZIP'}, FileType.custom);

  const FileSelectorType(this.extensions, this.filePickerType);
  final Set<String>? extensions;
  final FileType filePickerType;
}
