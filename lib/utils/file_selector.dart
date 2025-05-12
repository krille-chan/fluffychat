import 'package:flutter/widgets.dart';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/app_lock.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';

Future<List<XFile>> selectFiles(
  BuildContext context, {
  String? title,
  FileSelectorType type = FileSelectorType.any,
  bool allowMultiple = false,
}) async {
  if (!PlatformInfos.isLinux) {
    final result = await AppLock.of(context).pauseWhile(
      showFutureLoadingDialog(
        context: context,
        future: () => FilePicker.platform.pickFiles(
          compressionQuality: 0,
          allowMultiple: allowMultiple,
          type: type.filePickerType,
          allowedExtensions: type.extensions,
        ),
      ),
    );
    return result.result?.xFiles ?? [];
  }

  if (allowMultiple) {
    return await AppLock.of(context).pauseWhile(
      openFiles(confirmButtonText: title, acceptedTypeGroups: type.groups),
    );
  }
  final file = await AppLock.of(context).pauseWhile(
    openFile(confirmButtonText: title, acceptedTypeGroups: type.groups),
  );
  if (file == null) return [];
  return [file];
}

enum FileSelectorType {
  any([], FileType.any, null),
  images(
    [
      XTypeGroup(
        label: 'Images',
        extensions: <String>[
          'jpg',
          'JPG',
          'jpeg',
          'JPEG',
          'png',
          'PNG',
          'webp',
          'WebP',
          'WEBP',
          'gif',
          'GIF',
          'bmp',
          'BMP',
          'tiff',
          'TIFF',
          'tif',
          'TIF',
          'heic',
          'HEIC',
          'svg',
          'SVG',
        ],
      ),
      XTypeGroup(
        label: 'JPG',
        extensions: <String>['jpg', 'JPG', 'jpeg', 'JPEG'],
      ),
      XTypeGroup(label: 'PNG', extensions: <String>['png', 'PNG']),
      XTypeGroup(label: 'WebP', extensions: <String>['webp', 'WebP', 'WEBP']),
      XTypeGroup(label: 'GIF', extensions: <String>['gif', 'GIF']),
      XTypeGroup(label: 'BMP', extensions: <String>['bmp', 'BMP']),
      XTypeGroup(
        label: 'TIFF',
        extensions: <String>['tiff', 'TIFF', 'tif', 'TIF'],
      ),
      XTypeGroup(label: 'HEIC', extensions: <String>['heic', 'HEIC']),
      XTypeGroup(label: 'SVG', extensions: <String>['svg', 'SVG']),
    ],
    FileType.image,
    null,
  ),
  videos(
    [
      XTypeGroup(
        label: 'Videos',
        extensions: <String>[
          'mp4',
          'MP4',
          'avi',
          'AVI',
          'webm',
          'WebM',
          'WEBM',
          'mov',
          'MOV',
          'mkv',
          'MKV',
          'wmv',
          'WMV',
          'flv',
          'FLV',
          'mpeg',
          'MPEG',
          '3gp',
          '3GP',
          'ogg',
          'OGG',
        ],
      ),
      XTypeGroup(label: 'MP4', extensions: <String>['mp4', 'MP4']),
      XTypeGroup(label: 'WebM', extensions: <String>['webm', 'WebM', 'WEBM']),
      XTypeGroup(label: 'AVI', extensions: <String>['avi', 'AVI']),
      XTypeGroup(label: 'MOV', extensions: <String>['mov', 'MOV']),
      XTypeGroup(label: 'MKV', extensions: <String>['mkv', 'MKV']),
      XTypeGroup(label: 'WMV', extensions: <String>['wmv', 'WMV']),
      XTypeGroup(label: 'FLV', extensions: <String>['flv', 'FLV']),
      XTypeGroup(label: 'MPEG', extensions: <String>['mpeg', 'MPEG']),
      XTypeGroup(label: '3GP', extensions: <String>['3gp', '3GP']),
      XTypeGroup(label: 'OGG', extensions: <String>['ogg', 'OGG']),
    ],
    FileType.video,
    null,
  ),
  zip(
    [
      XTypeGroup(label: 'ZIP', extensions: <String>['zip', 'ZIP']),
    ],
    FileType.custom,
    ['zip', 'ZIP'],
  );

  const FileSelectorType(this.groups, this.filePickerType, this.extensions);
  final List<XTypeGroup> groups;
  final FileType filePickerType;
  final List<String>? extensions;
}
