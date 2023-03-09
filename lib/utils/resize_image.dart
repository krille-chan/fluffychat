import 'dart:io';

import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

import 'package:fluffychat/utils/platform_infos.dart';

extension ResizeImage on MatrixFile {
  static const int max = 1200;
  static const int quality = 40;

  Future<MatrixVideoFile> resizeVideo() async {
    final tmpDir = await getTemporaryDirectory();
    final tmpFile = File('${tmpDir.path}/$name');
    MediaInfo? mediaInfo;
    await tmpFile.writeAsBytes(bytes);
    try {
      // will throw an error e.g. on Android SDK < 18
      mediaInfo = await VideoCompress.compressVideo(tmpFile.path);
    } catch (e, s) {
      Logs().w('Error while compressing video', e, s);
    }
    return MatrixVideoFile(
      bytes: (await mediaInfo?.file?.readAsBytes()) ?? bytes,
      name: name,
      mimeType: mimeType,
      width: mediaInfo?.width,
      height: mediaInfo?.height,
      duration: mediaInfo?.duration?.round(),
    );
  }

  Future<MatrixImageFile?> getVideoThumbnail() async {
    if (!PlatformInfos.isMobile) return null;
    final tmpDir = await getTemporaryDirectory();
    final tmpFile = File('${tmpDir.path}/$name');
    if (await tmpFile.exists() == false) {
      await tmpFile.writeAsBytes(bytes);
    }
    try {
      final bytes = await VideoCompress.getByteThumbnail(tmpFile.path);
      if (bytes == null) return null;
      return MatrixImageFile(
        bytes: bytes,
        name: name,
      );
    } catch (e, s) {
      Logs().w('Error while compressing video', e, s);
    }
    return null;
  }
}
