import 'dart:typed_data';
import 'dart:ui';

import 'package:matrix/matrix.dart';
import 'package:native_imaging/native_imaging.dart' as native;

Future<MatrixImageFileResizedResponse?> customImageResizer(
  MatrixImageFileResizeArguments arguments,
) async {
  await native.init();
  late native.Image nativeImg;

  try {
    nativeImg = await native.Image.loadEncoded(arguments.bytes); // load on web
  } on UnsupportedError {
    try {
      // for the other platforms
      final dartCodec = await instantiateImageCodec(arguments.bytes);
      final dartFrame = await dartCodec.getNextFrame();
      final rgbaData = await dartFrame.image.toByteData();
      if (rgbaData == null) {
        return null;
      }
      final rgba = Uint8List.view(
        rgbaData.buffer,
        rgbaData.offsetInBytes,
        rgbaData.lengthInBytes,
      );

      final width = dartFrame.image.width;
      final height = dartFrame.image.height;

      dartFrame.image.dispose();
      dartCodec.dispose();

      nativeImg = native.Image.fromRGBA(width, height, rgba);
    } catch (e, s) {
      Logs().e("Could not generate preview", e, s);
      rethrow;
    }
  }

  final width = nativeImg.width;
  final height = nativeImg.height;

  final max = arguments.maxDimension;
  if (width > max || height > max) {
    var w = max, h = max;
    if (width > height) {
      h = max * height ~/ width;
    } else {
      w = max * width ~/ height;
    }

    final scaledImg = nativeImg.resample(w, h, native.Transform.lanczos);
    nativeImg.free();
    nativeImg = scaledImg;
  }
  final jpegBytes = await nativeImg.toJpeg(75);

  return MatrixImageFileResizedResponse(
    bytes: jpegBytes,
    width: nativeImg.width,
    height: nativeImg.height,
    blurhash: arguments.calcBlurhash ? nativeImg.toBlurhash(3, 3) : null,
  );
}
