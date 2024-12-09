import 'package:cross_file/cross_file.dart';
import 'package:matrix/matrix.dart';
import 'package:video_compress/video_compress.dart';

import 'package:fluffychat/utils/platform_infos.dart';

extension ResizeImage on XFile {
  static const int max = 1200;
  static const int quality = 40;

  Future<MatrixVideoFile> resizeVideo() async {
    MediaInfo? mediaInfo;
    try {
      if (PlatformInfos.isMobile) {
        // will throw an error e.g. on Android SDK < 18
        mediaInfo = await VideoCompress.compressVideo(path);
      }
    } catch (e, s) {
      Logs().w('Error while compressing video', e, s);
    }
    return MatrixVideoFile(
      bytes: (await mediaInfo?.file?.readAsBytes()) ?? await readAsBytes(),
      name: name,
      mimeType: mimeType,
      width: mediaInfo?.width,
      height: mediaInfo?.height,
      duration: mediaInfo?.duration?.round(),
    );
  }

  Future<MatrixImageFile?> getVideoThumbnail() async {
    if (!PlatformInfos.isMobile) return null;

    try {
      final bytes = await VideoCompress.getByteThumbnail(path);
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
