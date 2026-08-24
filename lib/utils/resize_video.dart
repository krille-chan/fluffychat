// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:cross_file/cross_file.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:light_compressor_v2/light_compressor_v2.dart';
import 'package:matrix/matrix.dart';
import 'package:mime/mime.dart';

extension ResizeImage on XFile {
  Future<MatrixVideoFile> getVideoInfo({bool compress = true}) async {
    MediaInfo? mediaInfo;
    String? destinationPath;
    try {
      if (PlatformInfos.isMobile || PlatformInfos.isMacOS) {
        final result = await LightCompressor().compressVideo(
          path: path,
          videoQuality: VideoQuality.medium,
          android: AndroidConfig(isSharedStorage: false),
          ios: IOSConfig(saveInGallery: false),
          video: Video(videoName: name, targetSizeMb: 5),
        );
        if (result is OnFailure) {
          throw result.message;
        }
        if (result is OnSuccess) {
          destinationPath = result.destinationPath;
        }
        if (destinationPath != null) {
          mediaInfo = await LightCompressor().getMediaInfo(destinationPath);
        }
      }
    } catch (e, s) {
      Logs().w('Error while fetching video media info', e, s);
    }

    return MatrixVideoFile(
      bytes: destinationPath != null
          ? await XFile(destinationPath).readAsBytes()
          : await readAsBytes(),
      name: name,
      mimeType: destinationPath != null
          ? lookupMimeType(destinationPath)
          : mimeType,
      width: mediaInfo?.width,
      height: mediaInfo?.height,
      duration: mediaInfo?.duration?.inMilliseconds,
    );
  }

  Future<MatrixImageFile?> getVideoThumbnail() async {
    if (!PlatformInfos.isMobile) return null;

    try {
      final thumbnailPath = await LightCompressor().getVideoThumbnail(path);
      final bytes = await XFile(thumbnailPath).readAsBytes();
      return MatrixImageFile(bytes: bytes, name: name);
    } catch (e, s) {
      Logs().w('Error while compressing video', e, s);
    }
    return null;
  }
}
