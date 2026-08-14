// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';
import 'dart:typed_data';

import 'package:fluffychat/utils/client_download_content_extension.dart';
import 'package:matrix/matrix.dart';
import 'package:path/path.dart' as path;

import 'matrix_sdk_extensions/flutter_matrix_dart_sdk_database/builder.dart';

const notificationAvatarDimension = 128;

extension NotificationAvatarExtension on Client {
  Future<Uint8List?> tryDownloadNotificationAvatar(Uri? avatar) async {
    if (avatar == null) return null;
    try {
      return await downloadMxcCached(
        avatar,
        thumbnailMethod: ThumbnailMethod.crop,
        width: notificationAvatarDimension,
        height: notificationAvatarDimension,
        animated: false,
        isThumbnail: true,
        rounded: true,
      ).timeout(const Duration(seconds: 3));
    } catch (e, s) {
      Logs().e('Unable to get avatar picture', e, s);
      return null;
    }
  }

  /// Keep in sync with `createAttachment()` in iOS Notification Extension
  /// This loads the avatar for a room and also stores it in a temporary
  /// directory so the Notification Service Extension can access it later.
  Future<String?> getIosNotificationAvatar(Uri? roomAvatar) async {
    if (roomAvatar == null) return null;

    final directory = await getFileStorageLocation();
    if (directory == null) return null;

    final host = roomAvatar.host.replaceAll('.', '_');
    final rawPath = roomAvatar.pathSegments.join('_');
    final fileName = 'notification_${host}_$rawPath.jpg';
    final cachedFile = File(path.join(directory.path, fileName));

    if (!await cachedFile.exists()) {
      final bytes = await tryDownloadNotificationAvatar(roomAvatar);
      if (bytes == null) return null;
      await cachedFile.writeAsBytes(bytes);
    }

    return cachedFile.path;
  }
}
