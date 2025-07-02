import 'package:cross_file/cross_file.dart';
import 'package:matrix/matrix.dart';
import 'package:video_compress/video_compress.dart';

import 'package:fluffychat/utils/platform_infos.dart';

extension ResizeImage on XFile {
  static const int max = 1200;
  static const int quality = 40;

  Future<MatrixVideoFile> getVideoInfo({bool compress = true}) async {
    MediaInfo? mediaInfo;
    try {
      if (PlatformInfos.isMobile) {
        // will throw an error e.g. on Android SDK < 18
        mediaInfo = compress
            ? await VideoCompress.compressVideo(path, deleteOrigin: true)
            : await VideoCompress.getMediaInfo(path);
      }
    } catch (e, s) {
      Logs().w('Error while fetching video media info', e, s);
    }

    return MatrixVideoFile(
      bytes: (await mediaInfo?.file?.readAsBytes()) ?? await readAsBytes(),
      name: name,
      mimeType: mimeType,
      // on Android width and height is reversed:
      // https://github.com/jonataslaw/VideoCompress/issues/172
      width: PlatformInfos.isAndroid ? mediaInfo?.height : mediaInfo?.width,
      height: PlatformInfos.isAndroid ? mediaInfo?.width : mediaInfo?.height,
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
