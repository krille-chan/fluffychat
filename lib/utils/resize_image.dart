//@dart=2.12

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';

extension ResizeImage on MatrixFile {
  static const int max = 1200;
  static const int quality = 40;

  Future<MatrixVideoFile> resizeVideo() async {
    final tmpDir = await getTemporaryDirectory();
    final tmpFile = File(tmpDir.path + '/' + name);
    final compressedFile = File(tmpDir.path + '/compressed_' + name);
    MediaInfo? mediaInfo;
    await tmpFile.writeAsBytes(bytes);
    try {
      mediaInfo = await VideoCompress.compressVideo(compressedFile.path);
    } catch (e, s) {
      SentryController.captureException(e, s);
    }
    return MatrixVideoFile(
      bytes: await compressedFile.readAsBytes(),
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
    final tmpFile = File(tmpDir.path + '/' + name);
    if (await tmpFile.exists() == false) {
      await tmpFile.writeAsBytes(bytes);
    }
    try {
      final bytes = await VideoCompress.getByteThumbnail(tmpFile.path);
      if (bytes == null) return null;
      return MatrixImageFile(
        bytes: bytes,
        name: name,
      ).resizeImage();
    } catch (e, s) {
      SentryController.captureException(e, s);
    }
    return null;
  }

  Future<MatrixImageFile> resizeImage({
    bool calcBlurhash = true,
    int max = ResizeImage.max,
    int quality = ResizeImage.quality,
  }) async {
    final bytes = mimeType == 'image/gif'
        ? this.bytes
        : await compute<_ResizeBytesConfig, Uint8List>(
            resizeBytes,
            _ResizeBytesConfig(
              bytes: this.bytes,
              mimeType: mimeType,
              max: max,
              quality: quality,
            ));
    final blurhash = calcBlurhash
        ? await compute<Uint8List, BlurHash>(createBlurHash, bytes)
        : null;
    return MatrixImageFile(
      bytes: bytes,
      name: '${name.split('.').first}_thumbnail_$max.jpg',
      blurhash: blurhash?.hash,
    );
  }
}

Future<BlurHash> createBlurHash(Uint8List file) async {
  final image = decodeImage(file)!;
  return BlurHash.encode(image, numCompX: 4, numCompY: 3);
}

Future<Uint8List> resizeBytes(_ResizeBytesConfig config) async {
  var image = decodeImage(config.bytes)!;

  // Is file already smaller than max? Then just return.
  if (math.max(image.width, image.height) > config.max) {
    // Use the larger side to resize.
    final useWidth = image.width >= image.height;
    image = useWidth
        ? copyResize(image, width: config.max)
        : copyResize(image, height: config.max);
  }

  const pngMimeType = 'image/png';
  final encoded = config.mimeType.toLowerCase() == pngMimeType
      ? encodePng(image)
      : encodeJpg(image, quality: config.quality);

  return Uint8List.fromList(encoded);
}

class _ResizeBytesConfig {
  final Uint8List bytes;
  final int max;
  final int quality;
  final String mimeType;

  const _ResizeBytesConfig({
    required this.bytes,
    this.max = ResizeImage.max,
    this.quality = ResizeImage.quality,
    required this.mimeType,
  });
}
