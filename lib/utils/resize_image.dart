//@dart=2.12

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart';
import 'package:matrix/matrix.dart';

extension ResizeImage on MatrixFile {
  static const int max = 1200;
  static const int quality = 40;

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
