//@dart=2.12

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:image/image.dart';
import 'package:matrix/matrix.dart';

extension ResizeImage on MatrixFile {
  static const int max = 1200;
  static const int quality = 20;

  Future<MatrixImageFile> resizeImage({bool calcBlurhash = true}) async {
    final bytes = await compute<Uint8List, Uint8List>(resizeBytes, this.bytes);
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

Future<Uint8List> resizeBytes(Uint8List file) async {
  final image = decodeImage(file)!;

  // Is file already smaller than max? Then just return.
  if (math.max(image.width, image.height) <= ResizeImage.max) {
    return file;
  }

  // Use the larger side to resize.
  final useWidth = image.width >= image.height;
  final thumbnail = useWidth
      ? copyResize(image, width: ResizeImage.max)
      : copyResize(image, height: ResizeImage.max);

  return Uint8List.fromList(encodeJpg(thumbnail, quality: ResizeImage.quality));
}
